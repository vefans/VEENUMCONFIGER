//
//  VECorrectionViewController.m
//  VEENUMCONFIGER
//
//  Created by mac on 2024/1/25.
//

#import "VECorrectionViewController.h"
#import <VEENUMCONFIGER/VEImageCropView.h>
#import <VEENUMCONFIGER/VEHelp.h>
#import <VEENUMCONFIGER/VECropTypeModel.h>
#import <VEENUMCONFIGER/VEVideoCropView.h>
#import <VEENUMCONFIGER/VEAngleRulerView.h>


@interface VECorrectionViewController ()<VECropViewDelegate, VECoreDelegate, VEAngleRulerViewDelegate>
{
    VEMediaInfo        *oldselectFile;
    CGRect originalvideoCropViewFrame;
    CGSize originalCoreSDKSize;
    BOOL isNeedRefreshPlayer;
}
@property(nonatomic,assign) CMTime                  seekTime;

@property (nonatomic, strong) VEAngleRulerView   *rulerView;
@property (nonatomic, strong) UILabel             *rulerSelectedLabel;

@property(nonatomic,strong)NSMutableArray * scenesArray;
@property(nonatomic,strong)VECore         * videoCoreSDK;

@property(nonatomic,strong)NSMutableArray          <Scene *>*scenes;

@property (nonatomic, strong) UIView                  *playView;
@property (nonatomic, strong) VEImageCropView * imageCropView;

@property (nonatomic, strong) UIView                *toobarView;
@property (nonatomic, strong) UIButton             *resetBtn;
@property (nonatomic, strong) UIButton             *confirmationBtn;
@property (nonatomic, strong) UIButton             *verticalCorrectionBtn;
@property (nonatomic, strong) UIButton             *LateralDirectionBtn;

@property(nonatomic,strong) VEVideoCropView             * videoCropView;

@end

@implementation VECorrectionViewController

-(VEVideoCropView *)videoCropView{
    if (_videoCropView == nil) {
        if([VEConfigManager sharedManager].iPad_HD){
            _videoCropView = [[VEVideoCropView alloc] initWithFrame:CGRectMake(0,44, CGRectGetWidth(_playView.frame), CGRectGetHeight(_playView.frame) - 180 - 44) withVideoCropType:VEVideoCropType_Crop];
            _videoCropView.backgroundColor = [UIColor clearColor];
        }else{
            _videoCropView = [[VEVideoCropView alloc] initWithFrame:_playView.bounds withVideoCropType:VEVideoCropType_Crop];
        }
        _videoCropView.cropView.delegate = self;
    }
    return _videoCropView;
}

/**初始化播放器
 */
- (void)initPlayer{
    self.scenesArray = [NSMutableArray new];
    self.scenes =  self.scenesArray;
    Scene *scene = [[Scene alloc] init];
   
    MediaAsset * vvasset = [[MediaAsset alloc] init];
    vvasset.url = _selectFile.contentURL;
    vvasset.localIdentifier = _selectFile.localIdentifier;
    vvasset.identifier = @"video";
    if(_selectFile.fileType == kFILEVIDEO){
        vvasset.videoActualTimeRange = _selectFile.videoActualTimeRange;
        vvasset.type = MediaAssetTypeVideo;
        if(_selectFile.isReverse){
            vvasset.url = _selectFile.reverseVideoURL;
            
            if (CMTimeRangeEqual(kCMTimeRangeZero, _selectFile.reverseVideoTimeRange)) {
                vvasset.timeRange = CMTimeRangeMake(kCMTimeZero, _selectFile.reverseDurationTime);
            }else{
                if(CMTimeRangeEqual(_selectFile.reverseVideoTrimTimeRange, kCMTimeRangeZero)){
                    vvasset.timeRange = _selectFile.reverseVideoTimeRange;
                }else{
                    vvasset.timeRange = _selectFile.reverseVideoTrimTimeRange;
                }
            }
            
            NSLog(@"timeRange.duration:%f",CMTimeGetSeconds(vvasset.timeRange.duration));
        }
        else{
            if (CMTimeRangeEqual(kCMTimeRangeZero, _selectFile.videoTimeRange)) {
                vvasset.timeRange = CMTimeRangeMake(kCMTimeZero, _selectFile.videoDurationTime);
            }else{
                if(CMTimeRangeEqual(_selectFile.videoTrimTimeRange, kCMTimeRangeZero)){
                    vvasset.timeRange = _selectFile.videoTimeRange;
                }else{
                    vvasset.timeRange = _selectFile.videoTrimTimeRange;
                }
            }
            NSLog(@"timeRange.duration:%f",CMTimeGetSeconds(vvasset.timeRange.duration));
        }
        vvasset.speed        = _selectFile.speed;
        vvasset.volume       = _selectFile.videoVolume;
    }else{
        NSLog(@"图片");
        vvasset.type         = MediaAssetTypeImage;
        
        vvasset.timeRange    = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(3, TIMESCALE));//_selectFile.imageDurationTime
        vvasset.speed        = _selectFile.speed;
        vvasset.volume       = _selectFile.videoVolume;
    }
    scene.transition.type   = TransitionTypeNone;
    scene.transition.duration = 0.0;
    vvasset.rotate = _selectFile.rotate;
    vvasset.isVerticalMirror = _selectFile.isVerticalMirror;
    vvasset.isHorizontalMirror = _selectFile.isHorizontalMirror;
    vvasset.horizontalDegrees = _selectFile.horizontalDegrees;
    vvasset.verticalDegrees = _selectFile.verticalDegrees;
    vvasset.degrees = _selectFile.degrees;
    vvasset.rt = _selectFile.rt;
    //vvasset.crop = _selectFile.crop;
    vvasset.adjustments = _selectFile.adjustments;
    [scene.media addObject:vvasset];
    //添加特效
    //滤镜特效
    if( _selectFile.customFilterIndex != 0 )
    {
        NSArray *filterFxArray = [NSArray arrayWithContentsOfFile:kNewSpecialEffectPlistPath];
        vvasset.customFilter = [VEHelp getCustomFilerWithFxId:_selectFile.customFilterId filterFxArray:filterFxArray timeRange:CMTimeRangeMake(kCMTimeZero,vvasset.timeRange.duration) currentFrameTexturePath:nil atPath:nil];
    }
    [self.scenesArray addObject:scene];

    _editVideoSize = [VEHelp getEditOrginSizeWithFile:_selectFile];//[VEDeluxeCommonClass getEditSizeWithFile:_selectFile];

    if (_videoCoreSDK == nil) {
        _videoCoreSDK = [[VECore alloc] initWithAPPKey:[VEConfigManager sharedManager].appKey
        APPSecret:[VEConfigManager sharedManager].appSecret
        LicenceKey:[VEConfigManager sharedManager].licenceKey
        videoSize:self.editVideoSize
        fps:kEXPORTFPS
        resultFail:^(NSError *error) {
            
        }];
        [self.videoCropView.videoView insertSubview:_videoCoreSDK.view  atIndex:0];
        _videoCoreSDK.delegate = self;
    }
    self.videoCropView.cropView.cropType = VE_VECROPTYPE_FREE;
    self.videoCropView.videoSize = self.editVideoSize;
    _videoCoreSDK.frame = self.videoCropView.videoView.bounds;
    [_videoCoreSDK setEditorVideoSize:_editVideoSize];
    originalvideoCropViewFrame = _videoCoreSDK.frame;
    originalCoreSDKSize = self.videoCropView.videoSize;
    
    [_videoCoreSDK setScenes:self.scenesArray];
    [_videoCoreSDK build];
}

- (CGRect)imageRectForView:(UIView *)view atImage:( UIImage * ) image {
    CGRect rect;
    CGFloat viewAspectRatio = CGRectGetWidth(view.bounds) / CGRectGetHeight(view.bounds);
    CGFloat imageAspectRatio = image.size.width / image.size.height;

    if (imageAspectRatio >= viewAspectRatio) {
        // 图片宽度过大，以 UIView 宽度为基准进行缩放
        CGFloat scaledWidth = CGRectGetWidth(view.bounds);
        CGFloat scaledHeight = scaledWidth / imageAspectRatio;
        CGFloat originX = 0.0;
        CGFloat originY = (CGRectGetHeight(view.bounds) - scaledHeight) / 2.0;
        rect = CGRectMake(originX, originY, scaledWidth, scaledHeight);
    } else {
        // 图片高度过大，以 UIView 高度为基准进行缩放
        CGFloat scaledHeight = CGRectGetHeight(view.bounds);
        CGFloat scaledWidth = scaledHeight * imageAspectRatio;
        CGFloat originX = (CGRectGetWidth(view.bounds) - scaledWidth) / 2.0;
        CGFloat originY = 0.0;
        rect = CGRectMake(originX, originY, scaledWidth, scaledHeight);
    }
    return rect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
    
//    UIImage *image =  [VEHelp getFullImageWithUrl:_asset.url];
    float height = 200 + kToolbarHeight;
    {
        self.playView = [[UIView alloc] initWithFrame:CGRectMake(5, kPlayerViewOriginX + 5, kWIDTH - 10, kHEIGHT - height - kPlayerViewOriginX - 10)];
//        self.playView.layer.masksToBounds = true;
        [self.view addSubview:self.playView];
    }
    {
        [self.playView addSubview:self.videoCropView];
        [self initPlayer];
    }
//    {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.playView.frame.size.width - 10, self.playView.frame.size.height - 10)];
//        [self.playView addSubview:view];
//        CGRect rect = [self imageRectForView:view atImage:image];
//        self.imageCropView = [[VEImageCropView alloc] initWithFrame:rect];
//        self.imageCropView.imageView.image = image;
//        [view addSubview:self.imageCropView];
//    }
//    
    {
        self.toobarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.playView.frame), kWIDTH , height)];
        [self.view addSubview:self.toobarView];
        self.toobarView.backgroundColor = VIEW_IPAD_COLOR;
        {
            self.rulerView = [[VEAngleRulerView alloc] initWithFrame:CGRectMake(35,  (self.toobarView.frame.size.height - kToolbarHeight - 30.0)/2.0 - 30, kWIDTH - 35 * 2, 30)];
            self.rulerView.delegate = self;
            [self.toobarView addSubview:self.rulerView];
            self.rulerSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake((kWIDTH - 302.0)/2.0, (self.toobarView.frame.size.height - kToolbarHeight - 30.0)/2.0 - 20 - 30, 60, 20)];
            self.rulerSelectedLabel.textAlignment = NSTextAlignmentCenter;
            self.rulerSelectedLabel.backgroundColor = [UIColor clearColor];
            self.rulerSelectedLabel.font = [UIFont systemFontOfSize:12];
            self.rulerSelectedLabel.textColor = Main_Color;
            [self.toobarView addSubview:self.rulerSelectedLabel];
            self.rulerSelectedLabel.center = CGPointMake((_selectFile.verticalDegrees / 90+0.5)*(self.rulerView.frame.size.width - 0.5) + self.rulerView.frame.origin.x, self.rulerSelectedLabel.center.y);
            self.rulerSelectedLabel.text = [NSString stringWithFormat:@"%.f\u00B0", _selectFile.verticalDegrees];
            
            CGFloat xPosition = (_selectFile.verticalDegrees / 90 + 0.5) * (CGRectGetWidth(_rulerView.frame) - 0.5);
            CGPoint center = CGPointMake(xPosition, _rulerView.valueSelectedImage.center.y);
            _rulerView.valueSelectedImage.center = center;
            _rulerView.value =  (_scenes[0].media.firstObject.degrees / 90 + 0.5);
        }
        {
            self.verticalCorrectionBtn = [[UIButton alloc] initWithFrame:CGRectMake( self.toobarView.frame.size.width/2.0 - 55 - 20 - 15 , (self.toobarView.frame.size.height - kToolbarHeight - 75)/2.0 + 75/2.0, 55, 75)];
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.verticalCorrectionBtn.frame.size.width, self.verticalCorrectionBtn.frame.size.width)];
                imageView.tag  = 2;
                [self.verticalCorrectionBtn addSubview:imageView];
                imageView.image =  [VEHelp imageWithContentOfPath:[VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/New_EditVideo/Correction/基础属性-垂直_选中@3x" Type:@"png"]];
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.verticalCorrectionBtn.frame.size.width - 10, self.verticalCorrectionBtn.frame.size.width, self.verticalCorrectionBtn.frame.size.height - self.verticalCorrectionBtn.frame.size.width)];
                label.text = VELocalizedString(@"垂直", nil);
                label.tag = 3;
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = Main_Color;
                [self.verticalCorrectionBtn addSubview:label];
                
                [self.verticalCorrectionBtn addTarget:self action:@selector(Correction_Btn:) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.toobarView addSubview:self.verticalCorrectionBtn];
            
            self.LateralDirectionBtn = [[UIButton alloc] initWithFrame:CGRectMake( self.toobarView.frame.size.width/2.0 + 30, (self.toobarView.frame.size.height - kToolbarHeight - 75)/2.0 + 75/2.0
                                                                                  , 55, 75)];
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.LateralDirectionBtn.frame.size.width, self.LateralDirectionBtn.frame.size.width)];
                imageView.tag  = 2;
                [self.LateralDirectionBtn addSubview:imageView];
                imageView.image =  [VEHelp imageWithContentOfPath:[VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/New_EditVideo/Correction/基础属性-水平_默认@3x" Type:@"png"]];
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.LateralDirectionBtn.frame.size.width - 10, self.LateralDirectionBtn.frame.size.width, self.LateralDirectionBtn.frame.size.height - self.LateralDirectionBtn.frame.size.width)];
                label.text = VELocalizedString(@"水平", nil);
                label.tag = 3;
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [UIColor whiteColor];
                [self.LateralDirectionBtn addSubview:label];
            }
            [self.toobarView addSubview:self.LateralDirectionBtn];
            self.verticalCorrectionBtn.selected = true;
            [self.LateralDirectionBtn addTarget:self action:@selector(Correction_Btn:) forControlEvents:UIControlEventTouchUpInside];
        }
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.toobarView.frame.size.height - kToolbarHeight, kWIDTH,  kToolbarHeight)];
            [self.toobarView addSubview:view];
            self.confirmationBtn = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width - 44, 0, 44, 44)];
            [view addSubview:self.confirmationBtn];
            UILabel *titleLbe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            titleLbe.frame = CGRectMake(50, 0, CGRectGetWidth(self.view.frame)-100, 44);
            titleLbe.text = VELocalizedString(@"矫正", nil);
            titleLbe.textAlignment = NSTextAlignmentCenter;
            titleLbe.textColor = [UIColor whiteColor];
            titleLbe.font = [UIFont boldSystemFontOfSize:14];
            [view addSubview:titleLbe];
            [view addSubview:self.confirmationBtn];
            view.backgroundColor = [UIColor clearColor];
            
            _resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 80, 44)];
            [_resetBtn setTitle:VELocalizedString(@"重置", nil) forState:UIControlStateNormal];
            [_resetBtn setImage:[VEHelp imageNamed:@"剪辑_重置默认_"] forState:UIControlStateNormal];
            [_resetBtn setImage:[VEHelp imageNamed:@"剪辑_重置选中_"] forState:UIControlStateDisabled];
            _resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_resetBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            [_resetBtn setTitleColor:DISABLED_COLOR forState:UIControlStateDisabled];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                [_resetBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
                [_resetBtn setTitleColor:UIColorFromRGB(0x727272) forState:UIControlStateDisabled];
            }
            if (_selectFile.verticalDegrees == 0 && _selectFile.horizontalDegrees == 0) {
                _resetBtn.enabled = NO;
            }
            
            [_resetBtn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:_resetBtn];
            
            [self.confirmationBtn setImage:nil forState:UIControlStateNormal];
            //[self.finishToolBarBtn setTitle:VELocalizedString(@"完成", nil) forState:UIControlStateNormal];
            [self.confirmationBtn setImage:[VEHelp imageNamed:([VEConfigManager sharedManager].iPad_HD ? @"ipad/剪辑_勾_" : @"剪辑_勾_")] forState:UIControlStateNormal];
            [self.confirmationBtn setTitleColor:UIColorFromRGB(0x31d065) forState:UIControlStateNormal];
            
            [self.confirmationBtn addTarget:self action:@selector(finishToolBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    // Do any additional setup after loading the view.
    self.videoCropView.alpha = 0.0;
}

-(void)Correction_Btn:( UIButton * ) sender
{
    if( self.verticalCorrectionBtn == sender )
    {
        self.verticalCorrectionBtn.selected = true;
        self.LateralDirectionBtn.selected = false;
        
        self.rulerView.value = _scenes[0].media.firstObject.verticalDegrees/90.0;
        [self.rulerView updateValueCoordinate];
        
        ((UIImageView*)[self.LateralDirectionBtn viewWithTag:2]).image = [VEHelp imageWithContentOfPath:[VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/New_EditVideo/Correction/基础属性-水平_默认@3x" Type:@"png"]];
        ((UILabel*)[self.LateralDirectionBtn viewWithTag:3]).textColor = [UIColor whiteColor];
        
        ((UIImageView*)[self.verticalCorrectionBtn viewWithTag:2]).image = [VEHelp imageWithContentOfPath:[VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/New_EditVideo/Correction/基础属性-垂直_选中@3x" Type:@"png"]];
        ((UILabel*)[self.verticalCorrectionBtn viewWithTag:3]).textColor = Main_Color;
    }
    else{
        self.verticalCorrectionBtn.selected = false;
        self.LateralDirectionBtn.selected = true;
        
        self.rulerView.value = _scenes[0].media.firstObject.horizontalDegrees/90.0;
        [self.rulerView updateValueCoordinate];
        
        ((UIImageView*)[self.LateralDirectionBtn viewWithTag:2]).image = [VEHelp imageWithContentOfPath:[VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/New_EditVideo/Correction/基础属性-水平_选中@3x" Type:@"png"]];
        ((UILabel*)[self.LateralDirectionBtn viewWithTag:3]).textColor = Main_Color;
        
        ((UIImageView*)[self.verticalCorrectionBtn viewWithTag:2]).image = [VEHelp imageWithContentOfPath:[VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/New_EditVideo/Correction/基础属性-垂直_默认@3x" Type:@"png"]];
        ((UILabel*)[self.verticalCorrectionBtn viewWithTag:3]).textColor = [UIColor whiteColor];;
    }
}

- (void)resetBtnAction:(UIButton *)sender {
    sender.enabled = NO;
    _scenes[0].media.firstObject.verticalDegrees = 0;
    _scenes[0].media.firstObject.horizontalDegrees = 0;
    _selectFile.verticalDegrees = 0;
    _selectFile.horizontalDegrees = 0;
    [self.videoCoreSDK refreshCurrentFrame];
    
    self.rulerSelectedLabel.text = @"0\u00B0";
    self.rulerSelectedLabel.center = CGPointMake((_toobarView.frame.size.width - _rulerSelectedLabel.frame.size.width) / 2.0 + _rulerSelectedLabel.frame.size.width / 2.0, self.rulerSelectedLabel.center.y);
    
    _rulerView.valueSelectedImage.center = CGPointMake((_rulerView.frame.size.width - _rulerView.valueSelectedImage.frame.size.width) / 2.0 + _rulerView.valueSelectedImage.frame.size.width / 2.0, _rulerView.valueSelectedImage.center.y);
    _rulerView.value =  (_selectFile.degrees / 90 + 0.5);
}

-(void)seekTime:(CMTime) time
{
    _seekTime = time;
}

-(void)seektimeCore
{
//    if( CMTimeGetSeconds(self.seekTime) > 0 )
    {
        [_videoCoreSDK seekToTime:self.seekTime];
        
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.25 animations:^{
            self.videoCropView.alpha = 1.0;
        }];
    }
}

- (void)statusChanged:(VECore *)sender status:(VECoreStatus)status
{
    if (sender == _videoCoreSDK && status == kVECoreStatusReadyToPlay) {
        [self seektimeCore];
    }
}
-(void)finishToolBarButtonClicked{
    
    CGRect crop = [self.videoCropView.cropView crop];
    CGRect cropRect = [self.videoCropView.cropView cropRect];
    CGRect r = crop;
    
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            if( _editVideoForOnceFinishFiltersAction )
            {
                _editVideoForOnceFinishFiltersAction(r, _selectFile.verticalDegrees, _selectFile.horizontalDegrees );
            }
        }];
        return;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        if( _editVideoForOnceFinishFiltersAction )
        {
            _editVideoForOnceFinishFiltersAction(r, _selectFile.verticalDegrees, _selectFile.horizontalDegrees );
        }
    }
}


- (void)rulerView_Value:(float)value RulerView:(UIView *)rulerView
{
    _resetBtn.enabled = YES;
    if( self.verticalCorrectionBtn.selected )
    {
        _scenes[0].media.firstObject.verticalDegrees = value * 90;
        _selectFile.verticalDegrees = value * 90;
        self.rulerSelectedLabel.text = [NSString stringWithFormat:@"%ld\u00B0",(long)(_scenes[0].media.firstObject.verticalDegrees)];
    }
    else{
        _scenes[0].media.firstObject.horizontalDegrees = value * 90;
        _selectFile.horizontalDegrees = value * 90;
        self.rulerSelectedLabel.text = [NSString stringWithFormat:@"%ld\u00B0",(long)(_scenes[0].media.firstObject.horizontalDegrees)];
    }

    [self.videoCoreSDK refreshCurrentFrame];
    self.rulerSelectedLabel.center = CGPointMake((value+0.5)*(rulerView.frame.size.width - 0.5) + rulerView.frame.origin.x, self.rulerSelectedLabel.center.y);
    
}

@end
