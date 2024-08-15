//
//  VEAPITemplateRecordViewController.m
//  VEDeluxeSDK
//
//  Created by iOS VESDK Team  on 2021/7/16.
//

#import "VEAPITemplateRecordViewController.h"
#import "VEAPITemplateRecordButton.h"
#import "VEAPITemplatePlayer.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <ATMHud/ATMHud.h>
#import <CoreMotion/CoreMotion.h>
#ifdef EnableMNNFaceDetection
#import <MNNFaceDetection/MNNFaceDetection.h>
#import <MNNFaceDetection/MNNFaceDetector.h>

#ifdef  AECHITECTURES_ARM64
#import <MLKitSegmentationCommon/MLKSegmenter.h>
#import <MLKitSegmentationCommon/MLKSegmentationMask.h>
#import <MLKitVision/MLKVisionImage.h>
#import <MLKitSegmentationSelfie/MLKSelfieSegmenterOptions.h>
#endif

#endif

#import <Vision/Vision.h>
#import "VEAPITemplateBeauty_VirtualView.h"
#import "VEHelp.h"
#import <libVECore/LibVECore.h>
#import <libVECore/CameraManager.h>

@interface VEAPITemplateRecordViewController ()<CameraManagerDelegate, VEAPITemplatePlayerDelegate, VECoreDelegate, VEAPITemplateBeauty_VirtualViewDelegate>
{
    UIView                      *_recordTypeView;
    UIButton                    *_deleteBtn;
    UIButton                    *_finishBtn;
    BOOL                        _isTiming;//倒计时中
    dispatch_source_t           _timer;
    UILabel                     *_timerLabel;
    UILabel                     *_recordDurationLbl;
    int                         _timerDuration;
    float                        totalDuration;
    float                        speededTotalDuration;
    NSMutableArray              *videoArray;
    NSMutableArray              *videoDurationArray;
    AVCaptureDevicePosition     _cameraPosition;
    UIButton                    *_recordBtn;
    VEAPITemplateRecordButton        *_recordProgressView;
    UIButton                    *_pictureBtn;
    UIButton                    *_beautyBtn;
    UIButton                    *_recordIV;
    NSInteger                    selectedBeautyTypeIndex;
    VEAPITemplatePlayer              *_player;
    BOOL                         isResignActive;
    CMMotionManager             *motionManager; //设备传感器
    int                         deviecAutoRotateAngle;      //开启系统自动旋转时，设备旋转的角度0/90/270（手机倒置180不会更新）
    MBProgressHUD               *progressHud;
    MediaAsset                  *_orignalMedia;
    UIButton                    *_saveToAlbumBtn;
    
#ifdef EnableMNNFaceDetection
    MNNFaceDetector             *faceDetector;
    MNNFaceDetector             *_faceDetector;
#endif
#ifdef  AECHITECTURES_ARM64
    MLKSegmenter                *segmenter;        //mlkit segment
    NSThread                    *segmenterThread;      //mlkit背景分割线程
    BOOL                        isAbortedSegmenterThread;
#endif
    VNDetectFaceRectanglesRequest *_facePoseRequest API_AVAILABLE(ios(11.0), macos(10.13));
    VNSequenceRequestHandler *_requestHandler API_AVAILABLE(ios(11.0), macos(10.13));
    VNGeneratePersonSegmentationRequest *_segmentationRequest API_AVAILABLE(ios(15.0), macos(12.0));
}
@property (nonatomic, weak) UIButton    *closeBtn;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) VEAPITemplateBeauty_VirtualView *beautyView;
@property (nonatomic, strong) CameraManager *cameraManager;
@property (nonatomic, strong) UIView *recordTimeView;
@property (nonatomic, strong) ATMHud *hud;
@property (nonatomic, strong) UIView *deleteTipView;
@property (nonatomic, strong) UIView *playerView;

@property (nonatomic, strong) UIView *closeTipView;

@end

@implementation VEAPITemplateRecordViewController

-(void)playStop
{
    [_player pause];
    [_player stop];
}

- (BOOL)prefersStatusBarHidden{
    return !iPhone_X;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterHome:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForegroundNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self.cameraManager startCamera];
}

-(void)startCamera
{
    [_cameraManager startCamera];
}

- (void)applicationEnterHome:(NSNotification *) notification{
    isResignActive = YES;
    [_player pause];
    [_videoCoreSDK pause];
    if (_cameraManager.recordStatus == VideoRecordStatusBegin) {
        [_cameraManager stopRecording];
    }
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
        [_timerLabel removeFromSuperview];
        
    }
}

- (void)appEnterForegroundNotification:(NSNotification *) notification{
    [_player play];
    isResignActive = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_player.isplaying) {
        [_player pause];
    }
#ifdef  AECHITECTURES_ARM64
    isAbortedSegmenterThread = YES;
    [segmenterThread cancel];
    segmenterThread = nil;
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SCREEN_BACKGROUND_COLOR;
    _cameraPosition = [VEConfigManager sharedManager].cameraConfiguration.cameraCaptureDevicePosition;
    if( self.isBackShot )
    {
        _cameraPosition = AVCaptureDevicePositionBack;
    }
    selectedBeautyTypeIndex = 1;
    _orignalMedia = [_media copy];
    WeakSelf(self);
    _player = [[VEAPITemplatePlayer alloc] initWithFrame:CGRectMake(kWIDTH - 108 - 10, (iPhone_X ? 88 : 44) + 10, 108, 192)
                                            urlPath:_previewVideoPath
                                           delegate:self
                                  completionHandler:^(NSError *error) {
        StrongSelf(self);
        if( strongSelf )
        {
            strongSelf->_player.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : VIEW_COLOR;
            if (strongSelf && !strongSelf->isResignActive) {
                if (CMTimeCompare(strongSelf.previewTimeRange.start, kCMTimeZero) == 1) {
                    [strongSelf->_player seekToTime:strongSelf.previewTimeRange.start toleranceTime:kCMTimeZero completionHandler:^(BOOL finished) {
                        [strongSelf->_player play];
                    }];
                }else {
                    [strongSelf->_player play];
                }
            }
        }
    }];
    [self.view addSubview:_player];
    
    UIButton *zoomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zoomBtn.frame = CGRectMake(kWIDTH - 44 - 10, CGRectGetMaxY(_player.frame) - 44, 44, 44);
    [zoomBtn setImage:[VEHelp imageNamed:@"/APITemplate/缩小"] forState:UIControlStateNormal];
    [zoomBtn setImage:[VEHelp imageNamed:@"/APITemplate/放大"] forState:UIControlStateNormal];
    [zoomBtn addTarget:self action:@selector(zoomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zoomBtn];
    
    self.topView.hidden = NO;
    self.bottomView.hidden = NO;
    
#ifdef EnableMNNFaceDetection
    dispatch_async(dispatch_get_main_queue(), ^{
        MNNFaceDetectorCreateConfig *createConfig = [[MNNFaceDetectorCreateConfig alloc] init];
        createConfig.detectMode = MNN_FACE_DETECT_MODE_VIDEO;
        [MNNFaceDetector createInstanceAsync:createConfig callback:^(NSError *error, MNNFaceDetector *net) {
            StrongSelf(self);
            if( strongSelf )
            {
                strongSelf->faceDetector = net;
            }
        }];
    });
#endif
#if 0
    if (_recordSize.width > _recordSize.height) {
        // 设备方向变化监听（需开启系统自动旋转功能，关闭时方向永远是UIDeviceOrientationPortrait）
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationDidChange:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        // pull获取设备陀螺仪数据（和系统自动旋转是否打开无关）
        motionManager = [[CMMotionManager alloc] init];
        if ([motionManager isDeviceMotionAvailable]) {
            [motionManager startDeviceMotionUpdates];
        }
        deviecAutoRotateAngle = [self currentAngle];
    }
#endif
//    [self.view setUserInteractionEnabled:NO];
}

- (int)currentAngle {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return 0;
        case UIDeviceOrientationPortraitUpsideDown:
            return 180;
        case UIDeviceOrientationLandscapeLeft:
            return 270;
        case UIDeviceOrientationLandscapeRight:
            return 90;
            
        default:
            return 0;
            break;
    }
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, iPhone_X ? 44 : 0, kWIDTH, 44)];
        [self.view addSubview:_topView];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 44, 44);
        [backBtn setImage:[VEHelp getBundleImagePNG:@"dyRecord/拍摄_关闭@3x"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:backBtn];
        self.closeBtn = backBtn;
        
        NSArray *btnArray = [NSArray arrayWithObjects:@"倒计时", @"音乐", @"闪光灯", @"翻转", nil];
        float spaceW = (kWIDTH - 44 * 5) / 4.0;
        [btnArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            itemBtn.frame = CGRectMake(44 + spaceW + (44 + spaceW) * idx, 0, 44, 44);
            if (idx == 0) {
                if( !self.isPhotoMain )
                    [itemBtn setImage:[VEHelp imageNamed:@"APITemplate/倒计时关"] forState:UIControlStateNormal];
                else
                {
                    _timerDuration = 3;
                    [itemBtn setImage:[VEHelp imageNamed:@"/APITemplate/倒计时3"] forState:UIControlStateNormal];
                }
            }
            else if (idx == 2) {
                [itemBtn setImage:[VEHelp getBundleImagePNG:[NSString stringWithFormat:@"dyRecord/拍摄_%@Off@3x", obj]] forState:UIControlStateNormal];
                [itemBtn setImage:[VEHelp getBundleImagePNG:[NSString stringWithFormat:@"dyRecord/拍摄_%@On@3x", obj]] forState:UIControlStateSelected];
                if (_cameraPosition == AVCaptureDevicePositionFront) {
                    itemBtn.enabled = NO;
                }
            }else if (idx == 1) {
                [itemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"/APITemplate/%@", obj]] forState:UIControlStateNormal];
                [itemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"/APITemplate/%@关", obj]] forState:UIControlStateSelected];
            }
            else {
                [itemBtn setImage:[VEHelp getBundleImagePNG:[NSString stringWithFormat:@"dyRecord/拍摄_%@@3x", obj]] forState:UIControlStateNormal];
            }
            itemBtn.tag = idx + 1;
            [itemBtn addTarget:self action:@selector(topBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_topView addSubview:itemBtn];
        }];
    }
    
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        if( self.isPhotoMain )
        {
            float height = (kHEIGHT - (iPhone_X ? 166 : 44)) * 0.25;
            height = 44 + 80;
            _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,kHEIGHT - height - self.photoMainTooBarHeight, kWIDTH, height)];
            [self.view addSubview:_bottomView];
            
            NSMutableArray *btnArray = [NSMutableArray arrayWithObjects:@"拍照", @"视频", nil];
            if (_supportType == ONLYSUPPORT_IMAGE) {
                [btnArray removeLastObject];
            }else if (_supportType == ONLYSUPPORT_VIDEO) {
                [btnArray removeObjectAtIndex:0];
            }
            _recordTypeView = [[UIView alloc] initWithFrame:CGRectMake(_isRecordVideo ? ((kWIDTH - 50)/2.0 - 50) : (kWIDTH - 50)/2.0, 0, btnArray.count * 50, 44)];
            if (btnArray.count == 1) {
                CGRect frame = _recordTypeView.frame;
                frame.origin.x = (kWIDTH - frame.size.width) / 2.0;
                _recordTypeView.frame = frame;
            }
            [_bottomView addSubview:_recordTypeView];
            UIButton *btn = nil;
            for (int i = 0; i < btnArray.count; i++) {
                UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                typeBtn.frame = CGRectMake(50 * i, 0, 50, 55);
                [typeBtn setTitle:VELocalizedString(btnArray[i], nil) forState:UIControlStateNormal];
                [typeBtn setTitleColor:UIColorFromRGB(0xc4c4c4) forState:UIControlStateNormal];
                [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                typeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [_recordTypeView addSubview:typeBtn];
                if (_supportType == SUPPORT_ALL) {
                    typeBtn.tag = i + 1;
                    [typeBtn addTarget:self action:@selector(recordTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    if (_isRecordVideo) {
                        if (i == 1) {
                            typeBtn.selected = YES;
                            btn = typeBtn;
                        }
                    }else if (i == 0) {
                        typeBtn.selected = YES;
                    }
                }else {
                    typeBtn.selected = YES;
                }
            }
            
            if( btnArray.count <= 1 )
            {
                _recordTypeView.hidden = TRUE;
            }
            
            
            UIButton *beautyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            beautyBtn.frame = CGRectMake(((kWIDTH - 70)/2.0 - 44)/2.0, (_bottomView.frame.size.height - _recordTypeView.frame.size.height - 66)/2.0 + _recordTypeView.frame.size.height + 4, 44, 66);
            [beautyBtn setImage:[VEHelp getBundleImagePNG:@"dyRecord/拍摄_美化@3x"] forState:UIControlStateNormal];
            [beautyBtn setTitle:VELocalizedString(@"美颜", nil) forState:UIControlStateNormal];
            [beautyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            beautyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            beautyBtn.imageEdgeInsets = UIEdgeInsetsMake(-beautyBtn.titleLabel.intrinsicContentSize.height, 0, 0, -beautyBtn.titleLabel.intrinsicContentSize.width);
            beautyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -beautyBtn.imageView.frame.size.width, -beautyBtn.imageView.frame.size.height, 0);
            [beautyBtn addTarget:self action:@selector(beautyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:beautyBtn];
            _beautyBtn = beautyBtn;
#if 1
            _pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _pictureBtn.frame = CGRectMake((kWIDTH - 70)/2.0, _bottomView.frame.origin.y + (_bottomView.frame.size.height - 55 - 70)/2.0 + 55, 70, 70);
            _pictureBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            _pictureBtn.layer.borderWidth = 4;
            _pictureBtn.layer.cornerRadius = 35;
            _pictureBtn.layer.masksToBounds = YES;
            [_pictureBtn addTarget:self action:@selector(pictureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_pictureBtn];
            
            _recordIV = [UIButton buttonWithType:UIButtonTypeCustom];
            _recordIV.frame = CGRectMake(-70, 3, 64, 64);
            _recordIV.backgroundColor = [UIColor whiteColor];
            _recordIV.layer.cornerRadius = 62/2.0;
            _recordIV.layer.masksToBounds = YES;
            [_recordIV setImage:[VEHelp imageNamed:@"/APITemplate/拍摄"] forState:UIControlStateNormal];
            [_recordIV setImage:[VEHelp imageNamed:@"/AE/模板_暂停_"] forState:UIControlStateSelected];
            [_recordIV addTarget:self action:@selector(pictureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_recordIV removeFromSuperview];
            if (_isRecordVideo) {
                _recordIV.frame = CGRectMake(-70, 3, 64, 64);
            }else {
                _pictureBtn.hidden = NO;
                _recordIV.frame = CGRectMake(3, 3, 64, 64);
            }
            CGRect frame = _recordTypeView.frame;
            [_pictureBtn addSubview:_recordIV];
            WeakSelf(self);
            [UIView animateWithDuration:0.2 animations:^{
                StrongSelf(self);
                _recordTypeView.frame = frame;
                if (strongSelf->_isRecordVideo) {
                    strongSelf->_recordIV.frame = CGRectMake(3, 3, 64, 64);
                }else {
                    strongSelf->_recordIV.frame = CGRectMake(-70, 3, 64, 64);
                }
            }];
            
            _recordProgressView = [[VEAPITemplateRecordButton alloc] initWithFrame:CGRectMake((kWIDTH - 85)/2.0, _pictureBtn.frame.origin.y - (85 - 70)/2.0, 85, 85)];
            _recordProgressView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            _recordProgressView.layer.cornerRadius = _recordProgressView.frame.size.width / 2.0;
            _recordProgressView.layer.masksToBounds = YES;
            [_recordProgressView addTarget:self action:@selector(recordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            _recordProgressView.hidden = YES;
            [self.view addSubview:_recordProgressView];
#else
            UIButton *recordBtn = [[UIButton alloc] initWithFrame:CGRectMake((kWIDTH - 80)/2.0, _bottomView.frame.origin.y + (_bottomView.frame.size.height - _recordTypeView.frame.size.height - 80)/2.0, 80, 80)];
            [recordBtn setImage:[VEHelp getBundleImagePNG:@"拍摄_拍摄@3x"] forState:UIControlStateNormal];
            [recordBtn setImage:[VEHelp getBundleImagePNG:@"拍摄_暂停@3x"] forState:UIControlStateSelected];
            [recordBtn addTarget:self action:@selector(recordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:recordBtn];
            _recordBtn = recordBtn;
#endif
            _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _deleteBtn.frame = CGRectMake(CGRectGetMaxX(_recordProgressView.frame) + 17, (_bottomView.frame.size.height - _recordTypeView.frame.size.height - 26)/2.0 +  _recordTypeView.frame.size.height, 26, 26);
            _deleteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            _deleteBtn.layer.borderWidth = 2.0;
            _deleteBtn.layer.cornerRadius = 13;
            _deleteBtn.layer.masksToBounds = YES;
            [_deleteBtn setImage:[VEHelp imageWithContentOfFile:@"jianji/特效-撤销"] forState:UIControlStateNormal];;
            [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            _deleteBtn.hidden = YES;
            [_bottomView addSubview:_deleteBtn];
            
            _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _finishBtn.frame = CGRectMake(CGRectGetMaxX(_deleteBtn.frame) + (kWIDTH - CGRectGetMaxX(_deleteBtn.frame) - 26)/2.0, _deleteBtn.frame.origin.y, 26, 26);
            _finishBtn.backgroundColor = Main_Color;
            _finishBtn.layer.cornerRadius = 13;
            _finishBtn.layer.masksToBounds = YES;
            [_finishBtn setImage:[VEHelp getBundleImagePNG:@"剪辑_下一步完成默认_@2x"] forState:UIControlStateNormal];
            [_finishBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            _finishBtn.hidden = YES;
            [_bottomView addSubview:_finishBtn];
        }
        else
        {
            float height = (kHEIGHT - (iPhone_X ? 166 : 44)) * 0.25;
            height = 44 + (iPhone_X ? 34 : 0) + 80;
            _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kHEIGHT - height, kWIDTH, height)];
            [self.view addSubview:_bottomView];
            
            NSMutableArray *btnArray = [NSMutableArray arrayWithObjects:@"拍照", @"视频", nil];
            if (_supportType == ONLYSUPPORT_IMAGE) {
                [btnArray removeLastObject];
            }else if (_supportType == ONLYSUPPORT_VIDEO) {
                [btnArray removeObjectAtIndex:0];
            }
            _recordTypeView = [[UIView alloc] initWithFrame:CGRectMake(_isRecordVideo ? ((kWIDTH - 50)/2.0 - 50) : (kWIDTH - 50)/2.0, height - 44 - (iPhone_X ? 34 : 0), btnArray.count * 50, 44)];
            if (btnArray.count == 1) {
                CGRect frame = _recordTypeView.frame;
                frame.origin.x = (kWIDTH - frame.size.width) / 2.0;
                _recordTypeView.frame = frame;
            }
            [_bottomView addSubview:_recordTypeView];
            for (int i = 0; i < btnArray.count; i++) {
                UIButton *typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                typeBtn.frame = CGRectMake(50 * i, 0, 50, 55);
                [typeBtn setTitle:VELocalizedString(btnArray[i], nil) forState:UIControlStateNormal];
                [typeBtn setTitleColor:UIColorFromRGB(0x8F8988) forState:UIControlStateNormal];
                [typeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                typeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
                [_recordTypeView addSubview:typeBtn];
                if (_supportType == SUPPORT_ALL) {
                    typeBtn.tag = i + 1;
                    [typeBtn addTarget:self action:@selector(recordTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    if (_isRecordVideo) {
                        if (i == 1) {
                            typeBtn.selected = YES;
                        }
                    }else if (i == 0) {
                        typeBtn.selected = YES;
                    }
                }else {
                    typeBtn.selected = YES;
                }
            }
            UIButton *beautyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            beautyBtn.frame = CGRectMake(((kWIDTH - 70)/2.0 - 44)/2.0, (_bottomView.frame.size.height - (iPhone_X ? _recordTypeView.frame.size.height + 34 : _recordTypeView.frame.size.height) - 66)/2.0, 44, 66);
            [beautyBtn setImage:[VEHelp getBundleImagePNG:@"dyRecord/拍摄_美化@3x"] forState:UIControlStateNormal];
            [beautyBtn setTitle:VELocalizedString(@"美颜", nil) forState:UIControlStateNormal];
            [beautyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            beautyBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            beautyBtn.imageEdgeInsets = UIEdgeInsetsMake(-beautyBtn.titleLabel.intrinsicContentSize.height, 0, 0, -beautyBtn.titleLabel.intrinsicContentSize.width);
            beautyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -beautyBtn.imageView.frame.size.width, -beautyBtn.imageView.frame.size.height, 0);
            [beautyBtn addTarget:self action:@selector(beautyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:beautyBtn];
#if 1
            _pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _pictureBtn.frame = CGRectMake((kWIDTH - 70)/2.0, _bottomView.frame.origin.y + (_bottomView.frame.size.height - (iPhone_X ? 55 + 34 : 55) - 70)/2.0, 70, 70);
            _pictureBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            _pictureBtn.layer.borderWidth = 4;
            _pictureBtn.layer.cornerRadius = 35;
            _pictureBtn.layer.masksToBounds = YES;
            [_pictureBtn addTarget:self action:@selector(pictureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_pictureBtn];
            
            _recordIV = [UIButton buttonWithType:UIButtonTypeCustom];
            _recordIV.frame = CGRectMake(-70, 3, 64, 64);
            _recordIV.backgroundColor = [UIColor whiteColor];
            _recordIV.layer.cornerRadius = 62/2.0;
            _recordIV.layer.masksToBounds = YES;
            [_recordIV setImage:[VEHelp imageNamed:@"/APITemplate/拍摄"] forState:UIControlStateNormal];
            [_recordIV setImage:[VEHelp imageNamed:@"/AE/模板_暂停_"] forState:UIControlStateSelected];
            [_recordIV addTarget:self action:@selector(pictureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            _recordProgressView = [[VEAPITemplateRecordButton alloc] initWithFrame:CGRectMake((kWIDTH - 85)/2.0, _pictureBtn.frame.origin.y - (85 - 70)/2.0, 85, 85)];
            _recordProgressView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
            _recordProgressView.layer.cornerRadius = _recordProgressView.frame.size.width / 2.0;
            _recordProgressView.layer.masksToBounds = YES;
            [_recordProgressView addTarget:self action:@selector(recordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            _recordProgressView.hidden = YES;
            [self.view addSubview:_recordProgressView];
#else
            UIButton *recordBtn = [[UIButton alloc] initWithFrame:CGRectMake((kWIDTH - 80)/2.0, _bottomView.frame.origin.y + (_bottomView.frame.size.height - (iPhone_X ? _recordTypeView.frame.size.height + 34 : _recordTypeView.frame.size.height) - 80)/2.0, 80, 80)];
            [recordBtn setImage:[VEHelp getBundleImagePNG:@"拍摄_拍摄@3x"] forState:UIControlStateNormal];
            [recordBtn setImage:[VEHelp getBundleImagePNG:@"拍摄_暂停@3x"] forState:UIControlStateSelected];
            [recordBtn addTarget:self action:@selector(recordBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:recordBtn];
            _recordBtn = recordBtn;
#endif
            _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _deleteBtn.frame = CGRectMake(CGRectGetMaxX(_recordProgressView.frame) + 17, (_bottomView.frame.size.height - (iPhone_X ? _recordTypeView.frame.size.height + 34 : _recordTypeView.frame.size.height) - 26)/2.0, 26, 26);
            _deleteBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            _deleteBtn.layer.borderWidth = 2.0;
            _deleteBtn.layer.cornerRadius = 13;
            _deleteBtn.layer.masksToBounds = YES;
            [_deleteBtn setImage:[VEHelp imageWithContentOfFile:@"jianji/特效-撤销"] forState:UIControlStateNormal];;
            [_deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            _deleteBtn.hidden = YES;
            [_bottomView addSubview:_deleteBtn];
            
            _finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _finishBtn.frame = CGRectMake(CGRectGetMaxX(_deleteBtn.frame) + (kWIDTH - CGRectGetMaxX(_deleteBtn.frame) - 26)/2.0, _deleteBtn.frame.origin.y, 26, 26);
            _finishBtn.backgroundColor = Main_Color;
            _finishBtn.layer.cornerRadius = 13;
            _finishBtn.layer.masksToBounds = YES;
            [_finishBtn setImage:[VEHelp getBundleImagePNG:@"剪辑_下一步完成默认_@2x"] forState:UIControlStateNormal];
            [_finishBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            _finishBtn.hidden = YES;
            [_bottomView addSubview:_finishBtn];
        }
    }
    
    return _bottomView;
}

- (VEAPITemplateBeauty_VirtualView *)beautyView {
    if (!_beautyView) {
        _beautyView = [[VEAPITemplateBeauty_VirtualView alloc] initWithFrame:CGRectMake(0, kHEIGHT - kHEIGHT / 3.0, kWIDTH, kHEIGHT / 3.0)];
        _beautyView.backgroundColor = [[VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : VIEW_COLOR colorWithAlphaComponent:0.8];
        _beautyView.hidden = YES;
        _beautyView.delegate = self;
        [self.view addSubview:_beautyView];
    }
    return _beautyView;
}

- (UIView *)recordTimeView {
    if (!_recordTimeView) {
        _recordTimeView = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH - 92)/2.0, _recordProgressView.frame.origin.y - 17 - 29, 92, 29)];
        _recordTimeView.frame = CGRectMake(10, CGRectGetMaxY(_topView.frame), 92, 29);
        _recordTimeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _recordTimeView.layer.cornerRadius = 29/2.0;
        _recordTimeView.layer.masksToBounds = YES;
        [self.view addSubview:_recordTimeView];
        
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(10, (29 - 6)/2.0, 6, 6)];
        circleView.backgroundColor = Main_Color;
        circleView.layer.cornerRadius = 3;
        circleView.layer.masksToBounds = YES;
        [_recordTimeView addSubview:circleView];
        
        _recordDurationLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _recordTimeView.frame.size.width/2.0 - 3, _recordTimeView.frame.size.height)];
        _recordDurationLbl.textColor = [UIColor whiteColor];
        _recordDurationLbl.textAlignment = NSTextAlignmentRight;
        _recordDurationLbl.font = [UIFont systemFontOfSize:10];
        [_recordTimeView addSubview:_recordDurationLbl];
        
        UILabel *totalDurationLbl = [[UILabel alloc] initWithFrame:CGRectMake(_recordTimeView.frame.size.width/2.0, 0, _recordTimeView.frame.size.width/2.0, _recordTimeView.frame.size.height)];
        totalDurationLbl.text = [NSString stringWithFormat:@"/ %.1fs", CMTimeGetSeconds(_previewTimeRange.duration)];
        totalDurationLbl.textColor = [UIColor whiteColor];
        totalDurationLbl.textAlignment = NSTextAlignmentLeft;
        totalDurationLbl.font = [UIFont systemFontOfSize:10];
        [_recordTimeView addSubview:totalDurationLbl];
    }
    
    return _recordTimeView;;
}

- (UIView *)closeTipView {
    if (!_closeTipView) {
        _closeTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
        _closeTipView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self.navigationController.view addSubview:_closeTipView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH - 266)/2.0, (kHEIGHT - 135)/2.0, 266, 135)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5.0;
        bgView.layer.masksToBounds = YES;
        [_closeTipView addSubview:bgView];
        
        UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, bgView.frame.size.width, 35)];
        tipLbl.text = VELocalizedString(@"确定放弃当前拍摄内容？", nil);
        tipLbl.textColor = [UIColor blackColor];
        tipLbl.textAlignment = NSTextAlignmentCenter;
        tipLbl.font = [UIFont systemFontOfSize:13.0];
        [bgView addSubview:tipLbl];
        
        UIButton *cancelDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelDeleteBtn.frame = CGRectMake(bgView.frame.size.width - 44, 0, 44, 44);
        [cancelDeleteBtn setImage:[VEHelp imageWithContentOfFile:@"jianji/music/剪辑-剪辑-音乐_关闭默认_"] forState:UIControlStateNormal];
        [cancelDeleteBtn addTarget:self action:@selector(cancelCloseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelDeleteBtn];
        
        UIButton *confirmDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmDeleteBtn.frame = CGRectMake((bgView.frame.size.width - 206)/2.0, bgView.frame.size.height/2.0, 206, 40);
        confirmDeleteBtn.backgroundColor = Main_Color;
        confirmDeleteBtn.layer.cornerRadius = 5.0;
        confirmDeleteBtn.layer.masksToBounds = YES;
        [confirmDeleteBtn setTitle:VELocalizedString(@"确认", nil) forState:UIControlStateNormal];
        [confirmDeleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmDeleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [confirmDeleteBtn addTarget:self action:@selector(confirmCloseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:confirmDeleteBtn];
    }
    
    return _deleteTipView;
}

- (UIView *)deleteTipView {
    if (!_deleteTipView) {
        _deleteTipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
        _deleteTipView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self.navigationController.view addSubview:_deleteTipView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH - 266)/2.0, (kHEIGHT - 135)/2.0, 266, 135)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5.0;
        bgView.layer.masksToBounds = YES;
        [_deleteTipView addSubview:bgView];
        
        UILabel *tipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, bgView.frame.size.width, 35)];
        tipLbl.text = VELocalizedString(@"确定删除上一段视频？", nil);
        tipLbl.textColor = [UIColor blackColor];
        tipLbl.textAlignment = NSTextAlignmentCenter;
        tipLbl.font = [UIFont systemFontOfSize:13.0];
        [bgView addSubview:tipLbl];
        
        UIButton *cancelDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelDeleteBtn.frame = CGRectMake(bgView.frame.size.width - 44, 0, 44, 44);
        [cancelDeleteBtn setImage:[VEHelp imageWithContentOfFile:@"jianji/music/剪辑-剪辑-音乐_关闭默认_"] forState:UIControlStateNormal];
        [cancelDeleteBtn addTarget:self action:@selector(cancelDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelDeleteBtn];
        
        UIButton *confirmDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        confirmDeleteBtn.frame = CGRectMake((bgView.frame.size.width - 206)/2.0, bgView.frame.size.height/2.0, 206, 40);
        confirmDeleteBtn.backgroundColor = Main_Color;
        confirmDeleteBtn.layer.cornerRadius = 5.0;
        confirmDeleteBtn.layer.masksToBounds = YES;
        [confirmDeleteBtn setTitle:VELocalizedString(@"确认", nil) forState:UIControlStateNormal];
        [confirmDeleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmDeleteBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [confirmDeleteBtn addTarget:self action:@selector(confirmDeleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:confirmDeleteBtn];
    }
    
    return _deleteTipView;
}

- (ATMHud *)hud {
    if (!_hud) {
        _hud = [[ATMHud alloc] init];
        [self.navigationController.view addSubview:_hud.view];
    }
    return _hud;
}

- (CameraManager *)cameraManager {
    if (!_cameraManager) {
        VECameraConfiguration *cameraConfig = [VEConfigManager sharedManager].cameraConfiguration;
        int fps = cameraConfig.cameraFrameRate;
        int bitrate = cameraConfig.cameraBitRate;
        unlink([cameraConfig.cameraOutputPath UTF8String]);
        
        UIView *cameraView = [[UIView alloc] init];
        cameraView.frame = CGRectMake(0, 0, MAX(kHEIGHT, kWIDTH),MIN(kHEIGHT, kWIDTH));
        cameraView.center = CGPointMake( MIN(kHEIGHT, kWIDTH)/2,MAX(kHEIGHT, kWIDTH)/2);
        cameraView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.view insertSubview:cameraView atIndex:0];
        CGRect rect = CGRectMake(0, 0, kHEIGHT, kWIDTH);
        if (_recordSize.width >= _recordSize.height) {
            rect.origin.x = -64;
        }
        
        _cameraManager = [[CameraManager alloc] initWithAPPKey:[VEConfigManager sharedManager].appKey
                                                       APPSecret:[VEConfigManager sharedManager].appSecret
                                                      LicenceKey:[VEConfigManager sharedManager].licenceKey
                                                      resultFail:^(NSError *error) {
                                                          NSLog(@"initError:%@", error.localizedDescription);
                                                      }];
        [_cameraManager prepareRecordWithFrame:rect
                                     superview:cameraView
                                       bitrate:bitrate
                                           fps:fps
                                isSquareRecord:NO
                                    cameraSize:_recordSize
                                    outputSize:_recordSize
                                       isFront:(_cameraPosition == AVCaptureDevicePositionFront)
                                  captureAsYUV:NO
                              disableTakePhoto:NO
                         enableCameraWaterMark:cameraConfig.enabelCameraWaterMark
                                enableVECoreBeauty:!cameraConfig.enableFaceU];
        _cameraManager.view.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : VIEW_COLOR;
        _cameraManager.blur = 0.5;
        _cameraManager.brightness = 0.5;
        _cameraManager.beautyToneIntensity = 0.5;
        _cameraManager.beautyThinFace = 0.5;
        _cameraManager.beautyBigEye = 0.0;
        _cameraManager.swipeScreenIsChangeFilter = NO;
        [_cameraManager setfocus];
        _cameraManager.delegate = self;
        _cameraManager.beautifyState = BeautifyStateSeleted;
    }
    return _cameraManager;
}

- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
        _playerView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:_playerView];
        
        _videoCoreSDK.delegate = self;
        [_videoCoreSDK setFrame:_playerView.bounds];
        [_playerView addSubview:_videoCoreSDK.view];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, (iPhone_X ? 44 : 0), 44, 44);
        [backBtn setImage:[VEHelp getBundleImagePNG:@"dyRecord/拍摄_关闭@3x"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(closePlayerView) forControlEvents:UIControlEventTouchUpInside];
        [_playerView addSubview:backBtn];
        
        UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        applyBtn.frame = CGRectMake((kWIDTH - 180)/2.0, kHEIGHT - 125 - (iPhone_X ? 34 : 0), 180, 50);
        applyBtn.backgroundColor = Main_Color;
        applyBtn.layer.cornerRadius = 5.0;
        applyBtn.layer.masksToBounds = YES;
        [applyBtn setTitle:VELocalizedString(@"应用视频到剪同款", nil) forState:UIControlStateNormal];
        [applyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        applyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [applyBtn addTarget:self action:@selector(applyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_playerView addSubview:applyBtn];
        
        NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:VELocalizedString(@"保存到本地相册", nil)
                                               attributes:@{NSStrokeWidthAttributeName: [NSNumber numberWithInt:-2],
                               NSStrokeColorAttributeName: [UIColor blackColor],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSFontAttributeName: [UIFont systemFontOfSize:13.0]}];
        _saveToAlbumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveToAlbumBtn.frame = CGRectMake((kWIDTH - 180)/2.0, CGRectGetMaxY(applyBtn.frame) + 26, 180, 18);
        [_saveToAlbumBtn setAttributedTitle:attributedText forState:UIControlStateNormal];
        UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(_saveToAlbumBtn.titleLabel.frame.origin.x - 18 - 6, 0, 18, 18)];
        iconIV.image = [VEHelp imageNamed:@"ic_select_normal_"];
        iconIV.tag = 1;
        [_saveToAlbumBtn addSubview:iconIV];
        [_saveToAlbumBtn addTarget:self action:@selector(saveToAlbumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_playerView addSubview:_saveToAlbumBtn];
    }
    
    return _playerView;
}

#pragma mark - 按钮事件
- (void)closePlayerView {
    [_videoCoreSDK stop];
    _playerView.hidden = YES;
    [self.cameraManager startCamera];
    if (_media.type == MediaAssetTypeImage) {
        [_player play];
    }
}

- (void)applyBtnAction:(UIButton *)sender {
    
    if(_player){
        [_player stop];
        _player = nil;
    }
    [self deleteItems];
    [_videoCoreSDK.view removeFromSuperview];
//    _videoCoreSDK.delegate = nil;
    [_videoCoreSDK pause];
    if (_completionHandler) {
        _completionHandler();
    }
    if (_saveToAlbumBtn.selected) {
        
    }
    [VEHelp setCloseSceneAnimation_FromTheTopDown:self];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)saveToAlbumBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    UIImageView *iconIV = [sender viewWithTag:1];
    if (sender.selected) {
        iconIV.image = [VEHelp imageNamed:@"ic_select_normal_"];
    }else {
        iconIV.image = [VEHelp imageNamed:@"ic_select_selected_"];
    }
}

-(void)cancelCloseBtnAction:( UIButton * ) btn
{
    self.closeTipView.hidden = true;
}
-(void)confirmCloseBtnAction:( UIButton * ) btn
{
    [self closeAtion];
}
- (void)backBtnAction:(UIButton *)sender {
    if( _isPhotoMain && (videoArray.count > 0) )
    {
        self.closeTipView.hidden = NO;
        return;
    }
    else{
        [self closeAtion];
    }
}

-(void)closeAtion
{
    if(_player){
        [_player stop];
        _player = nil;
    }
    [self deleteItems];
    if (_media.url != _orignalMedia.url) {
        _media.url = _orignalMedia.url;
        _media.type = _orignalMedia.type;
        _media.crop = _orignalMedia.crop;
        [_media.animate enumerateObjectsUsingBlock:^(MediaAssetAnimatePosition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.crop = _media.crop;
        }];
        [_videoCoreSDK build];
    }else {
        [_videoCoreSDK prepare];
    }
    [_videoCoreSDK.view removeFromSuperview];
    _videoCoreSDK.delegate = nil;
    if( self.isPhotoMain )
    {
        if( self.completionHandler )
        {
            self.completionHandler();
        }
    }
    else
    {
        [VEHelp setCloseSceneAnimation_FromTheTopDown:self];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)topBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
        {
            if( !self.isPhotoMain )
            {
                if (_timerDuration == 0) {
                    _timerDuration = 3;
                    [sender setImage:[VEHelp imageNamed:@"/APITemplate/倒计时3"] forState:UIControlStateNormal];
                }else if (_timerDuration == 3) {
                    _timerDuration = 5;
                    [sender setImage:[VEHelp imageNamed:@"/APITemplate/倒计时5"] forState:UIControlStateNormal];
                }else if (_timerDuration == 5) {
                    _timerDuration = 7;
                    [sender setImage:[VEHelp imageNamed:@"/APITemplate/倒计时7"] forState:UIControlStateNormal];
                }else {
                    _timerDuration = 0;
                    [sender setImage:[VEHelp imageNamed:@"APITemplate/倒计时关"] forState:UIControlStateNormal];
                }
            }
            else{
                if (_timerDuration == 7) {
                    _timerDuration = 3;
                    [sender setImage:[VEHelp imageNamed:@"/APITemplate/倒计时3"] forState:UIControlStateNormal];
                }else if (_timerDuration == 3) {
                    _timerDuration = 5;
                    [sender setImage:[VEHelp imageNamed:@"/APITemplate/倒计时5"] forState:UIControlStateNormal];
                }else if (_timerDuration == 5) {
                    _timerDuration = 7;
                    [sender setImage:[VEHelp imageNamed:@"/APITemplate/倒计时7"] forState:UIControlStateNormal];
                }
            }
        }
            break;
        case 2:
        {
            sender.selected = !sender.selected;
            if (sender.selected) {
                _player.mute = YES;
            }else {
                _player.mute = NO;
            }
        }
            break;
        case 3:
        {
            sender.selected = !sender.selected;
            if(_cameraManager.flashMode == AVCaptureTorchModeOn){
                _cameraManager.flashMode = AVCaptureTorchModeOff;
            }else{
                _cameraManager.flashMode = AVCaptureTorchModeOn;
            }
        }
            break;
        case 4:
        {
            [_player pause];
            UIButton *flashBtn = [_topView viewWithTag:3];
            if (_cameraManager.position == AVCaptureDevicePositionBack) {
                _cameraManager.position = AVCaptureDevicePositionFront;
                flashBtn.enabled = NO;
                self.isBackShot = NO;
                if( _delegate && [_delegate respondsToSelector:@selector(templateRecordView_BackShot:atViewController:)] )
                {
                    [_delegate templateRecordView_BackShot:NO atViewController:self];
                }
            }else{
                _cameraManager.position = AVCaptureDevicePositionBack;
                flashBtn.enabled = YES;
                if(flashBtn.selected){
                    [self performSelector:@selector(setFlashModeOn) withObject:nil afterDelay:0.2];
                }
                self.isBackShot = true;
                if( _delegate && [_delegate respondsToSelector:@selector(templateRecordView_BackShot:atViewController:)] )
                {
                    [_delegate templateRecordView_BackShot:true atViewController:self];
                }
            }
            [_player play];
            _cameraPosition = _cameraManager.position;
        }
            break;
            
        default:
            break;
    }
}

- (void)setFlashModeOn{
    [_cameraManager setFlashMode:AVCaptureTorchModeOn];
}

- (void)recordTypeBtnAction:(UIButton *)sender {
    if (sender.tag - 1 != _isRecordVideo) {
        UIView *recordTypeView = sender.superview;
        if (_isRecordVideo) {
            UIButton *prevBtn = [recordTypeView viewWithTag:2];
            prevBtn.selected = NO;
        }else {
            UIButton *prevBtn = [recordTypeView viewWithTag:1];
            prevBtn.selected = NO;
        }
        sender.selected = YES;
        _isRecordVideo = !_isRecordVideo;
        CGRect frame = recordTypeView.frame;
        if (sender.tag == 1) {
            frame.origin.x = (kWIDTH - 50)/2.0;
        }else {
            frame.origin.x = (kWIDTH - 50)/2.0 - 50;
        }
        [_recordIV removeFromSuperview];
        if (_isRecordVideo) {
            _recordIV.frame = CGRectMake(-70, 3, 64, 64);
        }else {
            _pictureBtn.hidden = NO;
            _recordIV.frame = CGRectMake(3, 3, 64, 64);
        }
        [_pictureBtn addSubview:_recordIV];
        WeakSelf(self);
        [UIView animateWithDuration:0.2 animations:^{
            StrongSelf(self);
            recordTypeView.frame = frame;
            if (strongSelf->_isRecordVideo) {
                strongSelf->_recordIV.frame = CGRectMake(3, 3, 64, 64);
            }else {
                strongSelf->_recordIV.frame = CGRectMake(-70, 3, 64, 64);
            }
        }];
    }
}

- (void)startTimer
{
    _isTiming = YES;
    _topView.hidden = YES;
    _bottomView.hidden = YES;
    __block int count = _timerDuration + 1;
    _timerLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _timerLabel.backgroundColor = [UIColor clearColor];
    _timerLabel.center = self.view.center;
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.textColor = [UIColor whiteColor];
    _timerLabel.font = [UIFont systemFontOfSize:125];
    [self.view addSubview:_timerLabel];
    
    if( (_timerDuration > 0) && ( videoArray.count == 0 ) )
    {
        [_player pause];
        [_player seekToTime:_previewTimeRange.start toleranceTime:kCMTimeZero completionHandler:nil];
    }
    else
    {
        [_player pause];
        [_player seekToTime:CMTimeMakeWithSeconds(totalDuration, TIMESCALE)toleranceTime:kCMTimeZero completionHandler:nil];
    }
    
    WeakSelf(self);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0);
    dispatch_source_set_event_handler(_timer, ^{
        StrongSelf(self);
        if (count < 2) {
            dispatch_source_cancel(strongSelf->_timer);
            dispatch_async(mainQueue, ^{
                strongSelf->_timer = nil;
                [strongSelf->_timerLabel removeFromSuperview];
                [strongSelf startRecord];
            });
        }else{
            count--;
            dispatch_async(mainQueue, ^{
#if 1
//                strongSelf->_timerLabel.font = [UIFont systemFontOfSize:125];
                strongSelf->_timerLabel.text = [NSString stringWithFormat:@"%d", count];
#else
                if (strongSelf->_isRecordVideo) {
                    strongSelf->_timerLabel.text = [NSString stringWithFormat:VELocalizedString(@"%d秒后开始录制", nil),count];
                }else{
                    strongSelf->_timerLabel.text = [NSString stringWithFormat:VELocalizedString(@"%d秒后拍摄照片", nil),count];
                }
#endif
            });
        }
    });
    dispatch_resume(_timer);
}

- (void)beautyBtnAction:(UIButton *)sender {
    if( self.showViewHandler )
    {
        self.showViewHandler( true );
    }
    _pictureBtn.hidden = true;
    _beautyBtn.hidden = true;
    _recordTypeView.hidden = true;
    self.beautyView.hidden = NO;
    CGRect rect = _beautyView.frame;
    rect.size.height =  kHEIGHT / 3.0;
    rect.origin.y = kHEIGHT - kHEIGHT / 3.0;
    _beautyView.frame = CGRectMake(_beautyView.frame.origin.x, kHEIGHT, _beautyView.frame.size.width, 0);
    WeakSelf(self);
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:0.25 animations:^{
        StrongSelf(self);
        strongSelf.beautyView.frame = rect;
    }];
}

#pragma mark - VEAPITemplateBeauty_VirtualViewDelegate
- (void)resetBeautyWithArray:( NSMutableArray * ) array atView:( VEAPITemplateBeauty_VirtualView * ) beautyEditView
{
    _cameraManager.blur = [array[0] floatValue];
    _cameraManager.brightness =  [array[1] floatValue];
    _cameraManager.beautyToneIntensity =  [array[2] floatValue];
    _cameraManager.beautyBigEye =  [array[3] floatValue];
    _cameraManager.beautyThinFace =  [array[4] floatValue];
}
- (void)refreshBeautyValue:(float)value beautyType:(KVLBeautyType)beautyType {
    switch (beautyType) {
        case KVLBeautyType_Blur://磨皮
            _cameraManager.blur = value;
            break;
        case KVLBeautyType_Brightness://美白
            _cameraManager.brightness = value;
            break;
        case KVLBeautyType_ToneIntensity://红润
            _cameraManager.beautyToneIntensity = value;
            break;
        case KVLBeautyType_Bigeye://大眼
            _cameraManager.beautyBigEye = value;
            break;
        case KVLBeautyType_ThinFace://廋脸
            _cameraManager.beautyThinFace = value;
            break;
            
        default:
            break;
    }
}

- (void)resetFiveSenses {
    _cameraManager.faceAttribute = nil;
    _cameraManager.blur = 0.6;
    _cameraManager.brightness = 0.3;
    _cameraManager.beautyThinFace = 0.5;
    _cameraManager.beautyBigEye = 0.3;
    _cameraManager.beautyToneIntensity = 0;
}

- (void)refreshFiveSenses:(FaceAttribute *)faceAttribute {
    _cameraManager.faceAttribute = faceAttribute;
}

- (void)refreshFiveSensesValue:(float)value beautyType:(KBeautyType)beautyType {
    FaceAttribute *faceAttribute = _cameraManager.faceAttribute;
    if( !faceAttribute )
    {
        faceAttribute = [FaceAttribute new];
//        faceAttribute.faceRect = faceRect;
        _cameraManager.faceAttribute = faceAttribute;
    }
    switch (beautyType) {
        case KBeauty_FaceWidth://MARK: 脸的宽度
        {
            faceAttribute.faceWidth = value;
        }
            break;
        case KBeauty_Forehead://MARK: 额头高度
        {
            faceAttribute.forehead = value;
        }
            break;
        case KBeauty_ChinWidth://MARK: 下颚的宽度
        {
            faceAttribute.chinWidth = value;
        }
            break;
        case KBeauty_ChinHeight://MARK: 下巴的高度
        {
            faceAttribute.chinHeight = value;
        }
            break;
        case KBeauty_EyeSize://MARK: 眼睛大小
        {
            faceAttribute.eyeWidth = value;
            faceAttribute.eyeHeight = value;
        }
            break;
        case KBeauty_EyeWidth://MARK: 眼睛宽度
        {
            faceAttribute.eyeWidth = value;
        }
            break;
        case KBeauty_EyeHeight://MARK: 眼睛高度
        {
            faceAttribute.eyeHeight = value;
        }
            break;
        case KBeauty_EyeSlant://MARK: 眼睛倾斜
        {
            faceAttribute.eyeSlant = value;
        }
            break;
        case KBeauty_EyeDistance://MARK: 眼睛距离
        {
            faceAttribute.eyeDistance = value;
        }
            break;
        case KBeauty_NoseSize://MARK: 鼻子大小
        {
            faceAttribute.noseWidth = value;
            faceAttribute.noseHeight = value;
        }
            break;
        case KBeauty_NoseWidth://MARK: 鼻子宽度
        {
            faceAttribute.noseWidth = value;
        }
            break;
        case KBeauty_NoseHeight://MARK: 鼻子高度
        {
            faceAttribute.noseHeight = value;
        }
            break;
        case KBeauty_MouthWidth://MARK: 嘴巴宽度
        {
            faceAttribute.mouthWidth = value;
        }
            break;
        case KBeauty_LipUpper://MARK: 上嘴唇
        {
            faceAttribute.lipUpper = value;
        }
            break;
        case KBeauty_LipLower://MARK: 下嘴唇
        {
            faceAttribute.lipLower = value;
        }
            break;
        case KBeauty_Smile://MARK: 微笑
        {
            faceAttribute.smile = value;
        }
            break;
        case KBeauty_BlurIntensity://MARK: 磨皮
        {
            _cameraManager.blur = value;
        }
            break;
        case KBeauty_ToneIntensity://MARK: 红润
        {
            _cameraManager.beautyToneIntensity = value;
        }
            break;
        case KBeauty_BrightIntensity://MARK: 美白
        {
            _cameraManager.brightness = value;
        }
            break;
        case KBeauty_BigEyes://MARK: 大眼
        {
            faceAttribute.beautyBigEyeIntensity = value;
        }
            break;
        case KBeauty_FaceLift://MARK: 瘦脸
        {
            faceAttribute.beautyThinFaceIntensity = value;
        }
            break;
        case KBeauty_beauty://MARK: 一键美颜
        {
            _cameraManager.beautyBigEye = value;
            _cameraManager.beautyToneIntensity = value;
            _cameraManager.brightness = value;
            faceAttribute.beautyBigEyeIntensity = value;
            faceAttribute.beautyThinFaceIntensity = value;
        }
            break;
        default:
            break;
    }
}

- (void)beautyConfirm_Btn:(VEAPITemplateBeauty_VirtualView *) beautyEditView{
    WeakSelf(self);
    CGRect rect = _beautyView.frame;
    [UIView animateWithDuration:0.25 animations:^{
        StrongSelf(self);
        strongSelf->_beautyView.frame = CGRectMake(self.beautyView.frame.origin.x, kHEIGHT, self.beautyView.frame.size.width, 0);
    } completion:^(BOOL finished) {
        StrongSelf(self);
        strongSelf->_beautyView.hidden = YES;
        strongSelf->_pictureBtn.hidden = NO;
        strongSelf->_beautyBtn.hidden = NO;
        strongSelf->_recordTypeView.hidden = NO;
        if( self.showViewHandler )
        {
            self.showViewHandler( NO );
        }
    }];
}

- (void)pictureBtnAction:(UIButton *)sender {
    
    if( _recordProgressView.percent == 1.0 )
    {
        [self.hud setCaption:VELocalizedString(@"录制时长不足！", nil)];
        [self.hud show];
        [self.hud hideAfter:1.5];
    }
    
    if( self.isDisableSave )
    {
        if( self.completionTipsHandler )
        {
            self.completionTipsHandler();
        }
        return;
    }
    
    if (!_isRecordVideo) {
        [self startRecord];
    }else {
        if (_recordIV.selected) {
            [self stopRecord];
        }
        else if (_timerDuration == 0) {
            [self startRecord];
        }else {
            [self startTimer];
        }
    }
}

- (void)recordBtnAction:(UIButton *)sender {
    if (_cameraManager.isRecording) {
        [self stopRecord];
    }else if (_timerDuration == 0) {
        [self startRecord];
    }else {
        [self startTimer];
    }
}

- (void)startRecord {
    if (_isRecordVideo) {
        _pictureBtn.hidden = YES;
        _recordIV.selected = YES;
        _recordIV.frame = CGRectMake((_recordProgressView.frame.size.width - 64)/2.0, (_recordProgressView.frame.size.height - 64)/2.0, 64, 64);
        [_recordIV removeFromSuperview];
        [_recordProgressView addSubview:_recordIV];
        if (!_recordProgressView.superview) {
            [self.view addSubview:_recordProgressView];
        }
        _recordProgressView.hidden = NO;
        _recordIV.transform = CGAffineTransformIdentity;
        WeakSelf(self);
        [UIView animateWithDuration:0.2 animations:^{
            StrongSelf(self);
            strongSelf->_recordIV.transform = CGAffineTransformMakeScale(1.06, 1.06);
        } completion:^(BOOL finished) {
            StrongSelf(self);
            strongSelf->_recordIV.transform = CGAffineTransformIdentity;
        }];
        _recordTypeView.hidden = YES;
        _recordBtn.selected = YES;
        _topView.hidden = YES;
        _bottomView.hidden = YES;
        if (_player.isplaying) {
            [_player pause];
            [_player seekToTime:_previewTimeRange.start toleranceTime:kCMTimeZero completionHandler:nil];
            
        }
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedStartRecord) object:nil];
        [self performSelector:@selector(delayedStartRecord) withObject:nil afterDelay:0.5];
    }else {
        [_player pause];
        WeakSelf(self);
        [_cameraManager takePhoto:UIImageOrientationUp block:^(UIImage *image) {
            StrongSelf(self);
            if(![[NSFileManager defaultManager] fileExistsAtPath:kVEDraftDirectory]){
                [[NSFileManager defaultManager] createDirectoryAtPath:kVEDraftDirectory withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *photoPath = [kVEDraftDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Photo%d.jpg",0]];
            BOOL have = NO;
            NSInteger exportPathIndex = 0;
            do {
                photoPath = [kVEDraftDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Photo%ld.jpg",(long)exportPathIndex]];
                exportPathIndex ++;
                have = [[NSFileManager defaultManager] fileExistsAtPath:photoPath];
            } while (have);
            NSData* imagedata = UIImageJPEGRepresentation(image, 1.0);
            
            [[NSFileManager defaultManager] createFileAtPath:photoPath contents:imagedata attributes:nil];
            [strongSelf deleteItems];
            [strongSelf showPlayerViewWithMediaUrl:[NSURL fileURLWithPath:photoPath]];
        }];
    }
    
    if( self.isPhotoMain )
    {
        if( self.showViewHandler )
        {
            self.showViewHandler(true);
        }
    }
}

-(void)delayedStartRecord
{
    _topView.hidden = YES;
    _bottomView.hidden = YES;
    [_cameraManager beginRecording];
}

-(void)delayedStopRecord
{
    _recordBtn.selected = NO;
    _recordIV.selected = NO;
    [_cameraManager stopRecording];
    _topView.hidden = NO;
    _bottomView.hidden = NO;
    [_player pause];
    if( self.isPhotoMain )
    {
        if( self.showViewHandler )
        {
            self.showViewHandler(NO);
        }
    }
}

- (void)stopRecord {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedStopRecord) object:nil];
    [self performSelector:@selector(delayedStopRecord) withObject:nil afterDelay:0.5];
}

- (void)zoomBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        WeakSelf(self);
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.25 animations:^{
            StrongSelf(self);
            if (strongSelf->_player.frame.origin.x != 0) {
                [strongSelf->_player setPlayerFrame:CGRectMake(kWIDTH - 50 - 10, (iPhone_X ? 88 : 44) + 10, 50, 50)];
            }else {
                [strongSelf->_cameraManager setVideoViewFrame:CGRectMake((iPhone_X ? 88 : 44) + 10, 10, 50, 50)];
            }
//            sender.frame = CGRectMake(kWIDTH - 44 - 10 - (50 - 44)/2.0, (iPhone_X ? 88 : 44) + 10 + (50 - 44)/2.0, 44, 44);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            sender.frame = CGRectMake(kWIDTH - 44 - 10 - (50 - 44)/2.0, (iPhone_X ? 88 : 44) + 10 + (50 - 44)/2.0, 44, 44);
        }];
    }else {
        WeakSelf(self);
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.25 animations:^{
            StrongSelf(self);
//            sender.frame = CGRectMake(kWIDTH - 44 - 10, (iPhone_X ? 88 : 44) + 10 + 192 - 44, 44, 44);
            if (strongSelf->_player.frame.origin.x != 0) {
                [strongSelf->_player setPlayerFrame:CGRectMake(kWIDTH - 108 - 10, (iPhone_X ? 88 : 44) + 10, 108, 192)];
            }else {
                [_cameraManager setVideoViewFrame:CGRectMake((iPhone_X ? 88 : 44) + 10, 10, 192, 108)];
            }
        }];
        [UIView animateWithDuration:0.2 animations:^{
            sender.frame = CGRectMake(kWIDTH - 44 - 10, (iPhone_X ? 88 : 44) + 10 + 192 - 44, 44, 44);
        }];
    }
}

- (void)deleteBtnAction:(UIButton *)sender {
    self.deleteTipView.hidden = NO;
}

- (void)cancelDeleteBtnAction:(UIButton *)sender {
    _deleteTipView.hidden = YES;
}

- (void)confirmDeleteBtnAction:(UIButton *)sender {
    _deleteTipView.hidden = YES;
    if (videoArray.count > 0 ) {
        totalDuration -= [[videoDurationArray lastObject] floatValue];
        totalDuration = MAX(0, totalDuration);
        float progress = (totalDuration - (floor(totalDuration/CMTimeGetSeconds(_previewTimeRange.duration)) * CMTimeGetSeconds(_previewTimeRange.duration)))/CMTimeGetSeconds(_previewTimeRange.duration);
        _recordProgressView.percent = progress;
        CGFloat all = totalDuration <= 0 ? 0 : totalDuration;
        _recordDurationLbl.text = [NSString stringWithFormat:@"%.1fs", all];
        [_player seekToTime:CMTimeMakeWithSeconds(totalDuration, TIMESCALE) toleranceTime:kCMTimeZero completionHandler:nil];
        
        NSString *filePath = [[_cameraManager getVideoSaveFileFolderString] stringByAppendingString:[NSString stringWithFormat:@"/%@",((CameraFile *)[videoArray lastObject]).fileName]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:filePath]) {
                NSError *error = nil;
                [fileManager removeItemAtPath:filePath error:&error];
                if (error) {
                    NSLog(@"删除失败");
                }
            }
        });
        
        [videoArray removeLastObject];
        [videoDurationArray removeLastObject];
        
        [_cameraManager refreshRecordTime];
        [self refreshBtnStatus];
        if (videoArray.count == 0) {
            _finishBtn.hidden = YES;
        }
    }
}

- (void)finishBtnAction:(UIButton *)sender {
    __block typeof(self) bself = self;
    if (_cameraManager.recordStatus == VideoRecordStatusBegin) {
        sender.enabled = NO;
        [self stopRecord];
    }else {
        [_cameraManager stopCamera];
        if ((videoArray.count == 1) || (_recordProgressView.percent == 1.0) ) {
            if( !self.isPhotoMain )
                [self deleteItems];
            CameraFile *cameraFile = videoArray.firstObject;
            [self showPlayerViewWithMediaUrl:cameraFile.url];
        }else {
            progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            progressHud.mode = MBProgressHUDModeAnnularDeterminate;
            [progressHud showAnimated:YES];
            [_cameraManager mergeAndExportVideosAtFileURLs:videoArray
                                                 musicInfo:nil
                                                  progress:^(NSNumber *progress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [bself->progressHud setProgress:[progress floatValue]];
                });
            } finish:^(NSURL *videourl) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [bself->progressHud hideAnimated:YES];
                    [bself deleteItems];
                    [bself showPlayerViewWithMediaUrl:videourl];
                });
                
            } fail:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"failed:%@",error);
                    [bself->_cameraManager startCamera];
                    [bself->progressHud hideAnimated:YES];
                    
                    NSString *message;
                    if (error.localizedRecoverySuggestion) {
                        message = error.localizedRecoverySuggestion;
                    }else {
                        message = error.localizedDescription;
                    }
                    [bself.hud setCaption:message];
                    [bself.hud show];
                    [bself.hud hideAfter:2];
                });
            } cancel:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"取消合并");
                    [bself->_cameraManager startCamera];
                    [bself->progressHud hideAnimated:YES];
                });
            }];
        }
    }
}

#pragma mark - VEAPITemplatePlayerDelegate
- (void)playCurrentTime:(CMTime)currentTime {
    if (_player.isplaying && CMTimeCompare(CMTimeAdd(currentTime, CMTimeMake(1, 30)), CMTimeAdd(_previewTimeRange.start, _previewTimeRange.duration)) >= 0) {
        [_player pause];
        WeakSelf(self);
        [_player seekToTime:_previewTimeRange.start toleranceTime:kCMTimeZero completionHandler:^(BOOL finished) {
            StrongSelf(self);
            if (strongSelf) {
                [strongSelf->_player play];
            }
        }];
    }
}

- (void)playerItemDidReachEnd:(VEAPITemplatePlayer *)player {
    WeakSelf(self);
    [_player seekToTime:_previewTimeRange.start toleranceTime:kCMTimeZero completionHandler:^(BOOL finished) {
        StrongSelf(self);
        if (strongSelf) {
            [strongSelf->_player play];
        }
    }];
}

- (void)tapPlayer {
    CGRect playerFrame = _player.frame;
    if (playerFrame.origin.x != 0) {
        [_player setPlayerFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
        [_cameraManager setVideoViewFrame:CGRectMake(playerFrame.origin.y, 10, playerFrame.size.height, playerFrame.size.width)];
        [self.view sendSubviewToBack:_player];
    }    
}

#pragma mark - CameraManagerDelegate
- (void)tapTheScreenFocus {
    if (_cameraManager.view.frame.origin.x != 0) {
        [_player setPlayerFrame:CGRectMake(kWIDTH - 108 - 10, (iPhone_X ? 88 : 44) + 10, 108, 192)];
        [_cameraManager setVideoViewFrame:CGRectMake(0, 0, kHEIGHT, kWIDTH)];
        [self.view sendSubviewToBack:_cameraManager.view.superview];
    }
}

- (NSArray<FaceRecognition*>*)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    //人脸数据提取
    return [self faceDetectionWithSampleBuffer:sampleBuffer];
}

-(NSArray<FaceRecognition*>*)faceDetectionWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
#ifdef EnableMNNFaceDetection
    NSDictionary *angleDic = [self calculateInAndOutAngle];
    float inAngle = [angleDic[@"inAngle"] floatValue];
    float outAngle = [angleDic[@"outAngle"] floatValue];
    MNNFaceDetectConfig detectConfig = EYE_BLINK|MOUTH_AH|HEAD_YAW|HEAD_PITCH|BROW_JUMP;
    CVPixelBufferRef pixelBufer = CMSampleBufferGetImageBuffer(sampleBuffer);
    int width = (int)CVPixelBufferGetWidth(pixelBufer);
    int height = (int)CVPixelBufferGetHeight(pixelBufer);
    NSError *error = nil;
//    float start = CACurrentMediaTime();
    NSArray<MNNFaceDetectionReport *> *detectResult = nil;
    for(int i = 0;i < MAX_DETECT_NUM;i++)//2023.06.21 - 有可能需要多次检测才能获取到人脸坐标
    {
        detectResult = [faceDetector inferenceWithPixelBuffer:pixelBufer config:detectConfig angle:inAngle outAngle:outAngle flipType:FLIP_NONE error:&error];
        if(detectResult)
            break;
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return nil;
        }
    }
//    NSLog(@"detect face time :%f",CACurrentMediaTime() - start);
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        return nil;
    }
    if(detectResult)
    {
        NSMutableArray<FaceRecognition*>* faces = [[NSMutableArray alloc] init];
        [detectResult enumerateObjectsUsingBlock:^(MNNFaceDetectionReport * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FaceRecognition* face = [[FaceRecognition alloc] init];
            face.left0 = CGPointMake((float)obj.keyPoints[0].x/(float)width, (float)obj.keyPoints[0].y/(float)height);
            face.right0 = CGPointMake((float)obj.keyPoints[32].x/(float)width, (float)obj.keyPoints[32].y/(float)height);
            face.left1 = CGPointMake((float)obj.keyPoints[5].x/(float)width, (float)obj.keyPoints[5].y/(float)height);
            face.right1 = CGPointMake((float)obj.keyPoints[27].x/(float)width, (float)obj.keyPoints[27].y/(float)height);
            face.left2 = CGPointMake((float)obj.keyPoints[8].x/(float)width, (float)obj.keyPoints[8].y/(float)height);
            face.right2 = CGPointMake((float)obj.keyPoints[23].x/(float)width, (float)obj.keyPoints[23].y/(float)height);
            face.left3 = CGPointMake((float)obj.keyPoints[12].x/(float)width, (float)obj.keyPoints[12].y/(float)height);
            face.right3 = CGPointMake((float)obj.keyPoints[19].x/(float)width, (float)obj.keyPoints[19].y/(float)height);
            face.bottom = CGPointMake((float)obj.keyPoints[16].x/(float)width, (float)obj.keyPoints[16].y/(float)height);
            face.nose = CGPointMake((float)obj.keyPoints[46].x/(float)width, (float)obj.keyPoints[46].y/(float)height);
            face.leftPupil = CGPointMake((float)obj.keyPoints[74].x/(float)width, (float)obj.keyPoints[74].y/(float)height);
            face.rightPupil = CGPointMake((float)obj.keyPoints[77].x/(float)width, (float)obj.keyPoints[77].y/(float)height);
            
            
            //左眼
            [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[55]]];//55
            [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[54]]];//54
            [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[53]]];//53
            [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[52]]];//52
            [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[57]]];//57
            [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[56]]];//56
            
            //右眼
            [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[58]]];//58
            [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[59]]];//59
            [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[60]]];//60
            [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[61]]];//61
            [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[62]]];//62
            [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[63]]];//63
            
            //左脸
            [face.cheekLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[0]]];//0
            [face.cheekLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[4]]];//4
            [face.cheekLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[9]]];//9
            [face.cheekLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[12]]];//12
            
            //右脸
            [face.cheekRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[32]]];//32
            [face.cheekRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[27]]];//27
            [face.cheekRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[22]]];//22
            [face.cheekRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[20]]];//20
            
            //下巴底部
            [face.chinLowerPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[16]]];//16
            
            //嘴唇外圈
            [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[84]]];//84
            [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[86]]];//86
            [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[88]]];//88
            [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[90]]];//90
            [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[92]]];//92
            [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[94]]];//94
            
            //上唇下沿中间
            [face.lipUpperLowPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[98]]];//98
            
            //下唇上沿中间
            [face.lipLowerUppPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[102]]];//102
            
            //鼻子
            [face.nosePoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[47]]];//47
            [face.nosePoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[51]]];//51
            
            [faces addObject:face];
        }];
        return faces;
    }
    return nil;
#else
    return nil;
#endif
}
- (NSDictionary*)calculateInAndOutAngle {
    double degree = [self rotateDegreeFromDeviceMotion];
    //可以根据不同角度检测处理，这里只检测四个角度的改变
    int rotateDegree = (((int)degree + 45) / 90 * 90) % 360;// 0/90/180/270

    //    NSLog(@"物理设备旋转角度: %d", rotateDegree);
    //    NSLog(@"自动旋转j角度: %d", _deviecAutoRotateAngle);
        
    /**
    如果自动旋转角度为0，无论有没有打开自动旋转，都当做关闭自动旋转处理
    如果自动旋转角度不为0，则一定是打开的自动旋转
    */
    int inAngle = 0;
    int outAngle = 0;
    if (deviecAutoRotateAngle==0) {
        inAngle = rotateDegree;
        outAngle = rotateDegree;
    }
    /**
    自动旋转打开时，手机旋转180标题栏不会翻转，保留上一个的状态
    */
    else if (rotateDegree==180) {
            
        if (deviecAutoRotateAngle==90) {
            inAngle = 90;
            outAngle = 90;
        }else if (deviecAutoRotateAngle==270) {
            inAngle = 270;
            outAngle = 270;
        }
            
    } else {
        inAngle = 0;
        outAngle = 0;
    }
    
    return @{@"inAngle":@(inAngle), @"outAngle":@(outAngle)};
}

// 根据陀螺仪数据计算的设备旋转角度（和系统自动旋转是否打开无关）
- (double)rotateDegreeFromDeviceMotion {
    if (!motionManager || !motionManager.deviceMotion) {
        return 0;
    }
    double gravityX = motionManager.deviceMotion.gravity.x;
    double gravityY = motionManager.deviceMotion.gravity.y;
    //double gravityZ = self.motionManager .deviceMotion.gravity.z;
    // 手机顺时针旋转的角度 0-360
    double xyTheta = atan2(gravityX, -gravityY) / M_PI * 180.0;
    if (gravityX<0) {
        xyTheta = 360+xyTheta;
    }
    
    return xyTheta;
}

- (void)currentTime:(float)time {
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        StrongSelf(self);
        float duration = strongSelf->totalDuration + time;
        float progress = (duration - (floor(duration/CMTimeGetSeconds(strongSelf.previewTimeRange.duration)) * CMTimeGetSeconds(strongSelf.previewTimeRange.duration)))/CMTimeGetSeconds(strongSelf.previewTimeRange.duration);
        if (progress > strongSelf->_recordProgressView.percent) {
            strongSelf->_recordProgressView.percent = progress;
        }
        strongSelf->_recordDurationLbl.text = [NSString stringWithFormat:@"%.1fs", duration];
        if (duration + 1.0/strongSelf->_cameraManager.fps >= CMTimeGetSeconds(strongSelf.previewTimeRange.duration)) {
            strongSelf->_recordProgressView.percent = 1.0;
            strongSelf->_recordDurationLbl.text = [NSString stringWithFormat:@"%.1fs", CMTimeGetSeconds(strongSelf.previewTimeRange.duration)];
            strongSelf->_finishBtn.hidden = NO;
            strongSelf->_recordIV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
            [strongSelf delayedStopRecord];
        }
    });
}

- (void)movieRecordBegin {
//    if (videoArray.count == 0) {
    [_player play];
//    }
    _isTiming = NO;
    totalDuration = [self totalVideoDuration];
    self.recordTimeView.hidden = NO;
}

- (void) movieRecordFailed:(NSError *)error{
    [_player pause];
    NSLog(@"录制失败:%@",error);
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        StrongSelf(self);
        [strongSelf refreshBtnStatus];
    });
}

- (void)movieRecordingCompletion:(NSURL *)videoUrl {
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
    float duration = CMTimeGetSeconds(asset.duration);
    if(duration >0){
        CameraFile *cameraFile = [CameraFile new];
        cameraFile.url = videoUrl;
        cameraFile.fileName = [[videoUrl absoluteString] lastPathComponent];
        cameraFile.duration = duration;
        if (!videoArray) {
            videoArray = [NSMutableArray array];
            videoDurationArray = [NSMutableArray array];
        }
        [videoArray addObject:cameraFile];
        [videoDurationArray addObject:[NSNumber numberWithFloat:duration]];
    }
    totalDuration = [self totalVideoDuration];
    WeakSelf(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        StrongSelf(self);
        [strongSelf->_player pause];
        [strongSelf refreshBtnStatus];
        if (!strongSelf->_finishBtn.enabled) {
            [strongSelf finishBtnAction:strongSelf->_finishBtn];
        }
        if( strongSelf.isPhotoMain )
        {
            if( strongSelf.isDisableSave )
            {
                if( strongSelf.completionTipsHandler )
                {
                    strongSelf.completionTipsHandler();
                }
                return;
            }
            if( (( strongSelf->_recordProgressView.percent == 1.0 ) && ( strongSelf->videoArray.count == 1 )) || (strongSelf->_recordProgressView.percent == 1.0  ) )
                [strongSelf finishBtnAction:nil];
            else
            {
                [strongSelf->_player pause];
                strongSelf->_finishBtn.hidden = NO;
            }
        }
    });
}

- (void)refreshBtnStatus {
    totalDuration = [self totalVideoDuration];
    if (videoArray.count > 0) {
        _deleteBtn.hidden = NO;
        _recordTypeView.hidden = YES;
    }else {
        [_recordIV removeFromSuperview];
        _recordIV.frame = CGRectMake(3, 3, 64, 64);
        [_pictureBtn addSubview:_recordIV];
        _recordProgressView.hidden = YES;
        [_recordProgressView removeFromSuperview];
        _pictureBtn.hidden = NO;
        _recordDurationLbl.text = @"0.0s";
        _deleteBtn.hidden = YES;
        _recordTimeView.hidden = YES;
        _recordTypeView.hidden = NO;
        [_player play];
    }
    _topView.hidden = NO;
    _bottomView.hidden = NO;
}

- (float) totalVideoDuration{
    CMTime totalDuration = kCMTimeZero;
    for (int i = 0; i< videoDurationArray.count;i++) {
       totalDuration = CMTimeAdd(totalDuration, CMTimeMakeWithSeconds([videoDurationArray[i] floatValue], TIMESCALE));
    }
    return CMTimeGetSeconds(totalDuration);
}

#pragma mark - 录制完成后预览
- (void)showPlayerViewWithMediaUrl:(NSURL *)url {
    if( self.isPhotoMain )
    {
        if( (_recordProgressView.percent == 1.0) || ( !_isRecordVideo  ) )
        {
            [_player pause];
            if( self.previewPlayHandler )
            {
                self.previewPlayHandler( url );
            }
        }
        else{
            [self.hud setCaption:VELocalizedString(@"录制时长不足！", nil)];
            [self.hud show];
            [self.hud hideAfter:1.5];
        }
    }
    else{
        self.playerView.hidden = NO;
        if ([VEHelp isImageUrl:url]) {
            _media.type = MediaAssetTypeImage;
        }else {
            _media.type = MediaAssetTypeVideo;
        }
        _media.url = url;
        _media.crop = CGRectMake(0, 0, 1, 1);
        [_media.animate enumerateObjectsUsingBlock:^(MediaAssetAnimatePosition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.crop = _media.crop;
        }];
        [_videoCoreSDK build];
    }
}

#pragma mark - VECoreDelegate
- (void)statusChanged:(VECoreStatus)status {
    if (status == kVECoreStatusReadyToPlay && !isResignActive) {
        if (CMTimeCompare(_previewTimeRange.start, kCMTimeZero) == 1 && CMTimeCompare(_videoCoreSDK.currentTime, _previewTimeRange.start) != 0) {
            WeakSelf(self);
            [_videoCoreSDK seekToTime:_previewTimeRange.start toleranceTime:kCMTimeZero completionHandler:^(BOOL finished) {
                [weakSelf.videoCoreSDK play];
            }];
        }else {
            [_videoCoreSDK play];
        }
    }
}

- (void)progressCurrentTime:(CMTime)currentTime {
    if (_videoCoreSDK.isPlaying && CMTimeCompare(CMTimeAdd(currentTime, CMTimeMake(1, kEXPORTFPS)), CMTimeAdd(_previewTimeRange.start, _previewTimeRange.duration)) >= 0) {
        [_videoCoreSDK pause];
        WeakSelf(self);
        [_videoCoreSDK seekToTime:_previewTimeRange.start toleranceTime:kCMTimeZero completionHandler:^(BOOL finished) {
            StrongSelf(self);
            if (strongSelf) {
                [strongSelf->_videoCoreSDK play];
            }
        }];
    }
}

- (void)playToEnd {
    WeakSelf(self);
    [_videoCoreSDK seekToTime:_previewTimeRange.start toleranceTime:kCMTimeZero completionHandler:^(BOOL finished) {
        StrongSelf(self);
        if (strongSelf) {
            [strongSelf->_videoCoreSDK play];
        }
    }];
}

- (NSArray<FaceRecognition*>*)willOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer asset:(MediaAsset*)asset
{
    if (asset.autoSegmentType != kAutoSegmentType_None) {
        if (@available(iOS 15.0, *)) {
            if (!_facePoseRequest) {
                _facePoseRequest = [[VNDetectFaceRectanglesRequest alloc] initWithCompletionHandler:nil];
                _facePoseRequest.revision = VNDetectFaceRectanglesRequestRevision3;
                _segmentationRequest = [[VNGeneratePersonSegmentationRequest alloc] init];
                _segmentationRequest.qualityLevel = VNGeneratePersonSegmentationRequestQualityLevelBalanced;
                _segmentationRequest.outputPixelFormat = kCVPixelFormatType_OneComponent8;
                _requestHandler = [[VNSequenceRequestHandler alloc] init];
            }
            NSError *error = nil;
            [_requestHandler performRequests:@[_facePoseRequest, _segmentationRequest] onCVPixelBuffer:pixelBuffer error:&error];
            if (!error) {
                CVPixelBufferRef maskPixelBuffer = _segmentationRequest.results.firstObject.pixelBuffer;
                if (maskPixelBuffer) {
                    CGSize originalBufferSize = CGSizeMake(CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer));
                    CGSize maskBufferSize = CGSizeMake(CVPixelBufferGetWidth(maskPixelBuffer), CVPixelBufferGetHeight(maskPixelBuffer));
                    CIImage *originalImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer];
                    CIImage *maskImage = [[CIImage alloc] initWithCVPixelBuffer:maskPixelBuffer];
                    if (!CGSizeEqualToSize(originalBufferSize, maskBufferSize)) {
                        float scaleX = originalBufferSize.width / maskBufferSize.width;
                        float scaleY = originalBufferSize.height / maskBufferSize.height;
                        maskImage = [maskImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
                    }
                    
                    CIFilter *blendFilter = [CIFilter filterWithName:@"CIBlendWithMask"];
                    [blendFilter setValue:originalImage forKey:@"inputImage"];
                    [blendFilter setValue:maskImage forKey:@"inputMaskImage"];
                    CIImage *resultImage = blendFilter.outputImage;
                    if (resultImage) {
                        CVPixelBufferRef resultPixelBuffer = [VEHelp pixelBufferFromCIImage:resultImage];
                        [VEHelp copyPixelBuffer:resultPixelBuffer toPixelBuffer:pixelBuffer];
                        CVPixelBufferRelease(resultPixelBuffer);
                    }
                }
            }
        }else {
#ifdef AECHITECTURES_ARM64
            [self mlkitSegmentWithPixelBuffer:pixelBuffer];
#endif
        }
    }
    if(asset.beautyBigEyeIntensity > 0.0 || asset.beautyThinFaceIntensity > 0.0 || asset.multipleFaceAttribute.count > 0)
    {
#ifdef EnableMNNFaceDetection
        if (!_faceDetector) {
            WeakSelf(self);
            
            // init face detector
            MNNFaceDetectorCreateConfig *createConfig = [[MNNFaceDetectorCreateConfig alloc] init];
            /*
             // In `MNN_FACE_DETECT_MODE_VIDEO`, the detection is run by default every 20 frames while the rest of the frames are only used for tracking.
             // In `MNN_FACE_DETECT_MODE_IMAGE`, each frame will trigger the detection.
             // 测试设置图片需要每隔20帧才会真正检测一次，视频每帧都会检测，不知道为什么
             */
            createConfig.detectMode = MNN_FACE_DETECT_MODE_IMAGE;

            [MNNFaceDetector createInstanceAsync:createConfig callback:^(NSError *error, MNNFaceDetector *net) {
                StrongSelf(self);
                strongSelf->_faceDetector = net;
            }];
        }
        if (_faceDetector) {
            return [self faceDetectionWithPixelBuffer:pixelBuffer asset:asset];
        }
#endif
    }
    return nil;
}

-(NSArray<FaceRecognition*>*)faceDetectionWithPixelBuffer:(CVPixelBufferRef)pixelBufer asset:(MediaAsset*)asset {
    /*
     // In `MNN_FACE_DETECT_MODE_VIDEO`, the detection is run by default every 20 frames while the rest of the frames are only used for tracking.
     // In `MNN_FACE_DETECT_MODE_IMAGE`, each frame will trigger the detection.
     // 测试设置图片需要每隔20帧才会真正检测一次，视频每帧都会检测，不知道为什么
     */
    
#ifdef EnableMNNFaceDetection
    for(int i = 0;i < MAX_DETECT_NUM;i++)
    {
        float inAngle = 0;
        float outAngle = 0;

        MNNFaceDetectConfig detectConfig = EYE_BLINK|MOUTH_AH|HEAD_YAW|HEAD_PITCH|BROW_JUMP;
        int width = (int)CVPixelBufferGetWidth(pixelBufer);
        int height = (int)CVPixelBufferGetHeight(pixelBufer);
        NSError *error = nil;
        NSArray<MNNFaceDetectionReport *> *detectResult = [_faceDetector inferenceWithPixelBuffer:pixelBufer config:detectConfig angle:inAngle outAngle:outAngle flipType:FLIP_NONE error:&error];
            if (error) {
            NSLog(@"%@", error.localizedDescription);
            return nil;
        }
        NSLog(@"i = %d detectResult:%p",i,detectResult);
        if(detectResult)
        {
            NSMutableArray<FaceRecognition*>* faces = [[NSMutableArray alloc] init];
            [detectResult enumerateObjectsUsingBlock:^(MNNFaceDetectionReport * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FaceRecognition* face = [[FaceRecognition alloc] init];
                face.faceRect = obj.rect;
                if(asset.multipleFaceAttribute.count > 0)//五官美颜，需要面部/眼睛/鼻子/嘴巴等等相关的点
                {
//                    NSLog(@"rect:%@ multipleFaceAttribute:%@", NSStringFromCGRect(obj.rect), NSStringFromCGRect(asset.multipleFaceAttribute.firstObject.faceRect));
                    
                    //左眼
                    [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[55]]];//55
                    [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[54]]];//54
                    [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[53]]];//53
                    [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[52]]];//52
                    [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[57]]];//57
                    [face.eyeLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[56]]];//56
                    
                    //右眼
                    [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[58]]];//58
                    [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[59]]];//59
                    [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[60]]];//60
                    [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[61]]];//61
                    [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[62]]];//62
                    [face.eyeRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[63]]];//63
                    
                    //左脸
                    [face.cheekLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[0]]];//0
                    [face.cheekLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[4]]];//4
                    [face.cheekLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[9]]];//9
                    [face.cheekLeftPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[12]]];//12
                    
                    //右脸
                    [face.cheekRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[32]]];//32
                    [face.cheekRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[27]]];//27
                    [face.cheekRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[22]]];//22
                    [face.cheekRightPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[20]]];//20
                    
                    //下巴底部
                    [face.chinLowerPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[16]]];//16
                    
                    //嘴唇外圈
                    [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[84]]];//84
                    [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[86]]];//86
                    [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[88]]];//88
                    [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[90]]];//90
                    [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[92]]];//92
                    [face.lipOuterPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[94]]];//94
                    
                    //上唇下沿中间
                    [face.lipUpperLowPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[98]]];//98
                    
                    //下唇上沿中间
                    [face.lipLowerUppPoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[102]]];//102
                    
                    //鼻子
                    [face.nosePoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[47]]];//47
                    [face.nosePoints addObject:[NSValue valueWithCGPoint:obj.keyPoints[51]]];//51
                }
                else
                {
                    //瘦脸大眼，仅仅只需要面部/眼睛相关的点
                    face.left0 = CGPointMake((float)obj.keyPoints[0].x/(float)width, (float)obj.keyPoints[0].y/(float)height);
                    face.right0 = CGPointMake((float)obj.keyPoints[32].x/(float)width, (float)obj.keyPoints[32].y/(float)height);
                    face.left1 = CGPointMake((float)obj.keyPoints[5].x/(float)width, (float)obj.keyPoints[5].y/(float)height);
                    face.right1 = CGPointMake((float)obj.keyPoints[27].x/(float)width, (float)obj.keyPoints[27].y/(float)height);
                    face.left2 = CGPointMake((float)obj.keyPoints[8].x/(float)width, (float)obj.keyPoints[8].y/(float)height);
                    face.right2 = CGPointMake((float)obj.keyPoints[23].x/(float)width, (float)obj.keyPoints[23].y/(float)height);
                    face.left3 = CGPointMake((float)obj.keyPoints[12].x/(float)width, (float)obj.keyPoints[12].y/(float)height);
                    face.right3 = CGPointMake((float)obj.keyPoints[19].x/(float)width, (float)obj.keyPoints[19].y/(float)height);
                    face.bottom = CGPointMake((float)obj.keyPoints[16].x/(float)width, (float)obj.keyPoints[16].y/(float)height);
                    face.nose = CGPointMake((float)obj.keyPoints[46].x/(float)width, (float)obj.keyPoints[46].y/(float)height);
                    face.leftPupil = CGPointMake((float)obj.keyPoints[74].x/(float)width, (float)obj.keyPoints[74].y/(float)height);
                    face.rightPupil = CGPointMake((float)obj.keyPoints[77].x/(float)width, (float)obj.keyPoints[77].y/(float)height);
                }
                [faces addObject:face];
            }];
            return faces;
        }
    }
    return nil;
#else
    return nil;
#endif
    
}

#ifdef  AECHITECTURES_ARM64
#pragma mark - UIImage covert to CVPixelBufferRef

static uint32_t bitmapInfoWithPixelFormatType(OSType inputPixelFormat, bool hasAlpha){
    
    if (inputPixelFormat == kCVPixelFormatType_32BGRA) {
        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
        if (!hasAlpha) {
            bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host;
        }
        return bitmapInfo;
    }else if (inputPixelFormat == kCVPixelFormatType_32ARGB) {
        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
        return bitmapInfo;
    }else{
        NSLog(@"不支持此格式");
        return 0;
    }
}

-(OSType)inputPixelFormat
{
    return kCVPixelFormatType_32BGRA;
}
// 此方法能还原真实的图片
-(CVPixelBufferRef)CVPixelBufferRefFromUiImage:(UIImage *)img {
    CGSize size = img.size;
    CGImageRef image = [img CGImage];
    
    BOOL hasAlpha = [VEHelp CGImageRefContainsAlpha:image];
    CFDictionaryRef empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             empty, kCVPixelBufferIOSurfacePropertiesKey,
                             nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, [self inputPixelFormat], (__bridge CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    uint32_t bitmapInfo = bitmapInfoWithPixelFormatType([self inputPixelFormat], (bool)hasAlpha);
    
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, CVPixelBufferGetBytesPerRow(pxbuffer), rgbColorSpace, bitmapInfo);
    NSParameterAssert(context);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    return pxbuffer;
}

/**
 * Applies a segmentation mask to an image buffer by replacing colors in the segmented regions.
 *
 * @param The mask output from a segmentation operation.
 * @param imageBuffer The image buffer on which segmentation was performed. Must have pixel format
 *     type `kCVPixelFormatType_32BGRA`.
 * @param backgroundColor Optional color to render into the background region (i.e. outside of the
 *     segmented region of interest).
 * @param foregroundColor Optional color to render into the foreground region (i.e. inside the
 *     segmented region of interest).
 */
-(void)applySegmentationMask:(MLKSegmentationMask *)mask
                toImageBuffer:(CVImageBufferRef)imageBuffer
          withBackgroundColor:(nullable UIColor *)backgroundColor
             foregroundColor:(nullable UIColor *)foregroundColor {
    NSAssert(CVPixelBufferGetPixelFormatType(imageBuffer) == kCVPixelFormatType_32BGRA,
             @"Image buffer must have 32BGRA pixel format type");
    size_t width = CVPixelBufferGetWidth(mask.buffer);
    size_t height = CVPixelBufferGetHeight(mask.buffer);
    NSAssert(CVPixelBufferGetWidth(imageBuffer) == width, @"Height must match");
    NSAssert(CVPixelBufferGetHeight(imageBuffer) == height, @"Width must match");
    
    if (backgroundColor == nil && foregroundColor == nil) {
        return;
    }
    
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    CVPixelBufferLockBaseAddress(mask.buffer, 0);
    
    float *maskAddress = (float *)CVPixelBufferGetBaseAddress(mask.buffer);
    unsigned char *tempAddress = (unsigned char *)CVPixelBufferGetBaseAddress(mask.buffer);
    size_t maskBytesPerRow = CVPixelBufferGetBytesPerRow(mask.buffer);
    
    unsigned char *imageAddress = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    static const int kBGRABytesPerPixel = 4;
    
    foregroundColor = foregroundColor ?: UIColor.clearColor;
    backgroundColor = backgroundColor ?: UIColor.clearColor;
    CGFloat redFG, greenFG, blueFG, alphaFG;
    CGFloat redBG, greenBG, blueBG, alphaBG;
    [foregroundColor getRed:&redFG green:&greenFG blue:&blueFG alpha:&alphaFG];
    [backgroundColor getRed:&redBG green:&greenBG blue:&blueBG alpha:&alphaBG];
    
    
    static const float kMaxColorComponentValue = 255.0f;
    
    for (int row = 0; row < height; ++row) {
        for (int col = 0; col < width; ++col) {
            
            int pixelOffset = col * kBGRABytesPerPixel;
            int blueOffset = pixelOffset;
            int greenOffset = pixelOffset + 1;
            int redOffset = pixelOffset + 2;
            int alphaOffset = pixelOffset + 3;
            
            float maskValue = maskAddress[col];
            float backgroundRegionRatio = 1.0 - maskValue;
            float foregroundRegionRatio = maskValue;
            
            
            float originalPixelRed = imageAddress[redOffset] / kMaxColorComponentValue;
            float originalPixelGreen = imageAddress[greenOffset] / kMaxColorComponentValue;
            float originalPixelBlue = imageAddress[blueOffset] / kMaxColorComponentValue;
            float originalPixelAlpha = imageAddress[alphaOffset] / kMaxColorComponentValue;
#if 0
            float redOverlay = redBG * backgroundRegionRatio + redFG * foregroundRegionRatio;
            float greenOverlay = greenBG * backgroundRegionRatio + greenFG * foregroundRegionRatio;
            float blueOverlay = blueBG * backgroundRegionRatio + blueFG * foregroundRegionRatio;
#endif
            float alphaOverlay = alphaBG * backgroundRegionRatio + alphaFG * foregroundRegionRatio;
            // Calculate composite color component values.
            // Derived from https://en.wikipedia.org/wiki/Alpha_compositing#Alpha_blending
#if 0
            //设置背景色
            float compositeAlpha = ((1.0f - alphaOverlay) * originalPixelAlpha) + alphaOverlay;
#else
            //没有背景色
            float compositeAlpha = ((1.0f - alphaOverlay) * originalPixelAlpha) ;
#endif
            float compositeRed = 0.0f;
            float compositeGreen = 0.0f;
            float compositeBlue = 0.0f;

            // Only perform rgb blending calculations if the output alpha is > 0. A zero-value alpha
            // means none of the color channels actually matter, and would introduce division by 0.
            if (fabs(compositeAlpha) > FLT_EPSILON) {
#if 0
                //设置背景色
                compositeRed = (((1.0f - alphaOverlay) * originalPixelAlpha * originalPixelRed) +
                                (alphaOverlay * redOverlay)) /
                compositeAlpha;
                compositeGreen = (((1.0f - alphaOverlay) * originalPixelAlpha * originalPixelGreen) +
                                  (alphaOverlay * greenOverlay)) /
                compositeAlpha;
                compositeBlue = (((1.0f - alphaOverlay) * originalPixelAlpha * originalPixelBlue) +
                                 (alphaOverlay * blueOverlay)) /
                compositeAlpha;
#else
                //没有背景色
                compositeRed = (1.0f - alphaOverlay) * originalPixelAlpha * originalPixelRed;
                compositeGreen = (1.0f - alphaOverlay) * originalPixelAlpha * originalPixelGreen;
                compositeBlue = (1.0f - alphaOverlay) * originalPixelAlpha * originalPixelBlue;
#endif
            }
            
            imageAddress[blueOffset] = compositeBlue * kMaxColorComponentValue;
            imageAddress[greenOffset] = compositeGreen * kMaxColorComponentValue;
            imageAddress[redOffset] = compositeRed * kMaxColorComponentValue;
            imageAddress[alphaOffset] = compositeAlpha * kMaxColorComponentValue;

        }
        imageAddress += bytesPerRow / sizeof(unsigned char);
        tempAddress += bytesPerRow / sizeof(unsigned char);
        maskAddress += maskBytesPerRow / sizeof(float);
    }
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    CVPixelBufferUnlockBaseAddress(mask.buffer, 0);
}
- (BOOL)detectSegmentationMaskInImage:(MLKVisionImage *)image
                          pixelBuffer:(CVPixelBufferRef)pixelBuffer {
    NSError *error = nil;
    CGFloat MLKSegmentationMaskAlpha = 1.0;
    if(!segmenter)
    {
        MLKSelfieSegmenterOptions *options = [[MLKSelfieSegmenterOptions alloc] init];
        segmenter = [MLKSegmenter segmenterWithOptions:options];
    }
    MLKSegmentationMask *mask = [segmenter resultsInImage:image error:&error];
    CVImageBufferRef imageBuffer = pixelBuffer;
    
    if (mask != nil) {
        UIColor *backgroundColor =
        [UIColor.purpleColor colorWithAlphaComponent:MLKSegmentationMaskAlpha];
        [self applySegmentationMask:mask
                      toImageBuffer:imageBuffer
                withBackgroundColor:backgroundColor
                    foregroundColor:nil];
    } else {
        NSLog(@"Failed to segment image with error: %@", error.localizedDescription);
        return NO;
    }
    return YES;
}

-(void)detectSegmentationWithPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    UIImage *image = [self imageFromSampleBuffer:pixelBuffer orientation:UIImageOrientationUp];
    MLKVisionImage *visionImage = [[MLKVisionImage alloc] initWithImage:image];
    visionImage.orientation = UIImageOrientationUp;
    if(![self detectSegmentationMaskInImage:visionImage pixelBuffer:pixelBuffer])
        return ;
}

- (UIImage *)imageFromSampleBuffer:(CVPixelBufferRef)pixelBuffer orientation:(UIImageOrientation)orientation{
    CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer];
    CIContext *context = [CIContext new];
    CGImageRef cgimage = [context createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *image= [UIImage imageWithCGImage:cgimage scale:1.f orientation:orientation];
    CGImageRelease(cgimage);
    return image;
}

#pragma mark - 子线程
- (void)processMLKitSegmentThread:(id)obj {
    @autoreleasepool {
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        while (!isAbortedSegmenterThread) {
            [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
            [NSThread sleepForTimeInterval:0.01];
        }
    }
}

#pragma mark - 谷歌MLKit背景分割 - 需要ios10.0++才支持
- (void)mlkitSegmentWithPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    if (@available(iOS 10.0,*)) {
        //ios 10.0 ++ 才会执行
        
        if([NSThread isMainThread]) //google mlkit segment 不能在主线程操作
        {
            [self performSelector:@selector(detectSegmentationWithPixelBuffer:) onThread:segmenterThread withObject:(__bridge id _Nullable)(pixelBuffer) waitUntilDone:YES];
        }
        else
            [self detectSegmentationWithPixelBuffer:pixelBuffer];

    }else{
        //ios 10.0 以下的低版本 才会执行
    }
}
#endif

#pragma mark - notification
- (BOOL)onDeviceOrientationDidChange:(NSNotification*)notification {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    //识别当前设备的旋转方向
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:// 270
        {
            deviecAutoRotateAngle = 270;
            NSLog(@"屏幕向左橫置");
        }
            break;
            
        case UIDeviceOrientationLandscapeRight:// 90
        {
            deviecAutoRotateAngle = 90;
            NSLog(@"屏幕向右橫置");
        }
            break;
            
        case UIDeviceOrientationPortrait:// 0
        {
            deviecAutoRotateAngle = 0;
            NSLog(@"屏幕直立");
        }
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:// 180
        {
            deviecAutoRotateAngle = 0;
            NSLog(@"屏幕直立，上下顛倒");
            return YES;
        }
            break;
            
        default:
            deviecAutoRotateAngle = 0;
            NSLog(@"无法识别");
            break;
    }
    
    return YES;
}

- (void) deleteItems{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_cameraManager stopCamera];
    [_cameraManager deleteItems];
    _cameraManager.delegate = nil;
    _cameraManager = nil;
}

- (void)dealloc {
    [_player pause];
    NSLog(@"%s", __func__);
}

@end
