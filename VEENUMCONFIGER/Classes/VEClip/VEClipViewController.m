//
//  VEClipViewController.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/7/16.
//

#import "VEClipViewController.h"
#import <VEENUMCONFIGER/VETrimSlider.h>
#import <VEENUMCONFIGER/VEPasterTextView.h>

@interface VEClipViewController ()<VEPlaySliderDelegate,VECropTypeDelegate,VECoreDelegate,VEVideoCropDelegte, VECropViewDelegate,VETrimSliderDelegate,VEPasterTextViewDelegate>
{
    VEMediaInfo        *oldselectFile;
    CGRect originalvideoCropViewFrame;
    CGSize originalCoreSDKSize;
    BOOL isNeedRefreshPlayer;
    
    CGPoint     _pasterTextCenter;
    CMTimeRange _playTimeRange;
    NSMutableArray  *thumbTimes;
}

@property (nonatomic,assign) float trimDuration_OneSpecifyTime;
@property(nonatomic, assign)CGRect                          syncContainerRect;
@property(nonatomic, assign)float                               pasterTextViewScale;
@property( nonatomic, weak ) VESyncContainerView    *syncContainerView;
@property( nonatomic, weak ) VEPasterTextView          *pasterTextView;
@property( nonatomic, assign)CGRect                          originalRect;

@property(nonatomic,strong) VEVideoCropView             * videoCropView;
@property(nonatomic,strong) UIView                  * toolView;

@property(nonatomic,strong) UIButton                * playButton;
@property(nonatomic,strong) UILabel                 * playTimeLabel;
@property(nonatomic,strong) VEPlaySlider            * playSlider;
@property(nonatomic,strong) UILabel                 * endTimeLabel;

@property(nonatomic,strong) UIButton                * backButton;
@property(nonatomic,strong) UIView                  * lineView;
@property(nonatomic,strong) UIButton                * vertButton;//垂直翻转
@property(nonatomic,strong) UIButton                * horizontalButton;//水平翻转
@property(nonatomic,strong) UIButton                * whirlButton;

@property(nonatomic,strong)VECropTypeView            * cropTypeView;
@property(nonatomic,strong) NSMutableArray           * dataCropTypeArray;

@property(nonatomic, weak)UIView                            * ribbtonView;
@property(nonatomic, weak)UIScrollView                     *cropTypeScrollView;
@property(nonatomic, weak)UIButton                          *cropTypeSelectBtn;


@property(nonatomic,strong)NSMutableArray * scenesArray;
@property(nonatomic,strong)VECore         * videoCoreSDK;

@property(nonatomic,strong)NSMutableArray          <Scene *>  *oldscenes;

@property(nonatomic,assign) CMTime                  seekTime;

@property (nonatomic, strong) VEExportProgressView *exportProgressView;

@property(nonatomic,assign)CGRect crop;
@property(nonatomic,assign)CGRect cropRect;

@property(nonatomic,strong)NSMutableArray          <Scene *>*scenes;

@property(nonatomic,assign)BOOL                      idleTimerDisabled;//20171101 解决不锁屏的bug
@property (nonatomic, strong) UIView         *currentFrameView;

@property(nonatomic, weak)UIView            *photoView; //图片界面操作

@property(nonatomic, weak)UIView            *videoView; //视频界面操作
@property(nonatomic, weak)VETrimSlider   *videoTrimiSlider;

@end

@implementation VEClipViewController

- (BOOL)prefersStatusBarHidden {
    return  YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 1.Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if( [VEConfigManager sharedManager].isPictureEditing )
    {
        self.view.backgroundColor = UIColorFromRGB(0x111111);//[UIColor whiteColor];
    }
    if([VEConfigManager sharedManager].iPad_HD && !CGRectEqualToRect(_frameRect, CGRectZero)){
        
    
        UIImageView *blurview = [[UIImageView alloc] initWithFrame:self.view.bounds];
        blurview.alpha = 0.95;
        blurview.image = _blurBgImage;
        CALayer *layer = [[CALayer alloc] init];
        layer.bounds = blurview.bounds;
        layer.position = blurview.center;
        layer.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6].CGColor;
        [blurview.layer addSublayer:layer];
        [self.view addSubview:blurview];
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0];
        _bgView = [[UIView alloc] initWithFrame:_frameRect];//
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    }else{
        _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    [self.view addSubview:_bgView];
    if (CGRectEqualToRect(_fixedMaxCrop, CGRectZero)) {
        _fixedMaxCrop = CGRectMake(0, 0, 1, 1);
    }    
    [self initConfiguration];
    [self setupNavBar];
    [self setupViews];
    [self setupData];
    
    if(_flowPicture){
//        _videoView.backgroundColor = SCREEN_BACKGROUND_COLOR;
//        _photoView.backgroundColor = SCREEN_BACKGROUND_COLOR;
//        self.toolView.backgroundColor = SCREEN_BACKGROUND_COLOR;
    }
#ifdef kEnterBackgroundCancelExport
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterHome:) name:UIApplicationDidEnterBackgroundNotification object:nil];
#endif
}

-(void)setSelectFile:(VEMediaInfo *)selectFile
{
    CGRect corp = selectFile.crop;
    if( (selectFile.isVerticalMirror) && ( !selectFile.isHorizontalMirror ))
    {
        if( (selectFile.rotate != -90 ) && ( selectFile.rotate != -270 ) && (selectFile.rotate != 90 ) && ( selectFile.rotate != 270 ))
            selectFile.crop = CGRectMake( 1.0 - corp.origin.x - corp.size.width, 1.0 -  corp.origin.y - corp.size.height, corp.size.width, corp.size.height);
    }
    if(selectFile.isHorizontalMirror && (!selectFile.isVerticalMirror) )
    {
        if( (selectFile.rotate != -90 ) && ( selectFile.rotate != -270 ) && (selectFile.rotate != 90 ) && ( selectFile.rotate != 270 ))
            selectFile.crop = CGRectMake( 1.0 - corp.origin.x - corp.size.width, 1.0 -  corp.origin.y - corp.size.height, corp.size.width, corp.size.height);
    }
//    if([VEConfigManager sharedManager].isPictureEditing)
//    {
//        _cropType = selectFile.fileCropModeType;
//        if( self.cropTypeSelectBtn )
//        {
//            self.cropTypeSelectBtn.selected = NO;
//            if( self.cropTypeSelectBtn.tag == VE_VECROPTYPE_ORIGINAL )
//                ((UILabel*)[self.cropTypeSelectBtn viewWithTag:22222]).textColor = PESDKTEXT_COLOR;
//        }
//
//        self.cropTypeSelectBtn = [_cropTypeScrollView viewWithTag:_cropType];
//        self.cropTypeSelectBtn.selected = YES;
//        if( self.cropTypeSelectBtn.tag == VE_VECROPTYPE_ORIGINAL )
//            ((UILabel*)[self.cropTypeSelectBtn viewWithTag:22222]).textColor = PESDKMain_Color;
//    }
    _selectFile = selectFile;
}

-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.translucent = YES;
    [self prefersStatusBarHidden];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 2.Setting View and Style

-(void)initConfiguration{
    
}


- (void)setupNavBar {
    if (_isNeedExport) {
        self.navBar.hidden = NO;
        [self.exportNavBarBtn addTarget:self action:@selector(exportNavBarButtonClicked)
                      forControlEvents:UIControlEventTouchUpInside];
    }else {
        self.toolBar.hidden = NO;
        [self.finishToolBarBtn addTarget:self action:@selector(finishToolBarButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.bgView addSubview:self.toolBar];
    if([VEConfigManager sharedManager].iPad_HD){
        self.toolBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), 44);
        self.finishToolBarBtn.frame = CGRectMake(CGRectGetWidth(self.toolBar.frame) - 54, 0, 44, 44);
        self.backBtn.frame = CGRectMake(10, 0, 44, 44);
        self.titlelab.frame = CGRectMake(50, 0, CGRectGetWidth(self.toolBar.frame)-100, 44);
        [self.bgView addSubview:self.toolBar];
        self.toolBar.backgroundColor = [UIColor clearColor];
        
        [self.backBtn setImage:nil forState:UIControlStateNormal];
        [self.backBtn setTitle:VELocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [self.backBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        self.backBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self.finishToolBarBtn setImage:nil forState:UIControlStateNormal];
        [self.finishToolBarBtn setTitle:VELocalizedString(@"完成", nil) forState:UIControlStateNormal];
        [self.finishToolBarBtn setTitleColor:UIColorFromRGB(0x31d065) forState:UIControlStateNormal];
        self.finishToolBarBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.toolBar.hidden = NO;
        self.titlelab.text = @"";
    }else{
        self.titlelab.textColor = UIColorFromRGB(0xffffff);
        self.barline.backgroundColor = UIColorFromRGB(0x1a1a1a);
        self.titlelab.text = VELocalizedString(@"裁切", nil);
        self.titlelab.backgroundColor = UIColorFromRGB(0x1a1a1a);
    }
}


- (void)setupViews {
    [self.bgView addSubview:self.videoCropView];
    if( _cutMmodeType == kCropTypeFixed )
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kPlayerViewOriginX, self.bgView.frame.size.width, 45)];
        if( _isNeedExport )
        {
            label.frame = CGRectMake(0, kNavgationBar_Height, self.bgView.frame.size.width, 45);
        }
        label.text = VELocalizedString(@"拖动选择视频显示区域", nil);
        if( [VEConfigManager sharedManager].isPictureEditing )
        {
            label.text = VELocalizedString(@"拖动选择图片显示区域", nil);
            label.textColor = PESDKTEXT_COLOR;
        }
        else
            label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        [self.bgView addSubview:label];
    }
    if( _cutMmodeType == kCropTypeNone )
    {
        [self.bgView addSubview:self.toolView];
        [self.toolView addSubview:self.playButton];
        [self.toolView addSubview:self.playTimeLabel];
        [self.toolView addSubview:self.playSlider];
        [self.toolView addSubview:self.endTimeLabel];
        [self.toolView addSubview:self.backButton];
        [self.toolView addSubview:self.lineView];
        [self.toolView addSubview:self.vertButton];
        [self.toolView addSubview:self.horizontalButton];
        [self.toolView addSubview:self.whirlButton];
        if(self.cropType != VE_VECROPTYPE_FIXEDRATIO)
        [self.toolView addSubview:self.cropTypeView];
    }
    else if( _cutMmodeType == kCropTypeFixed ){
        if( _selectFile.fileType == kFILEIMAGE && !_selectFile.isGif)
        {
            if( !_isCropTypeViewHidden )
            {
                [self initphotoView];
            }
        }
        else{
            if (_selectFile.isGif) {
                _playTimeRange = _selectFile.imageTimeRange;
            }else {
                _playTimeRange = _selectFile.videoTrimTimeRange;
            }
            [self initvideoView];
            [self.bgView addSubview:self.playButton];
            
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVideoEvent:)];
            [tapGesture setNumberOfTapsRequired:1];
            [self.videoCropView addGestureRecognizer:tapGesture];
        }
    }
    
}

- (void)setCropType:(VECropType)cropType{
    _cropType = cropType;
}

#pragma mark - 3.Request Data

- (void)setupData {
    if(self.cropType != VE_VECROPTYPE_FIXEDRATIO)
    self.cropType = VE_VECROPTYPE_FREE;
    [self reloadDataCropTypeView];
   
    if (_selectFile.isGif) {
        self.seekTime = _selectFile.imageTimeRange.start;
    }
    else if (_selectFile.isReverse) {
        self.seekTime = _selectFile.reverseVideoTrimTimeRange.start;
    }else {
        self.seekTime = _selectFile.videoTrimTimeRange.start;
    }
    
    [self initPlayer];
    
    self.videoCropView.cropView.cropType = self.cropType;
    CMTime endTime = CMTimeMakeWithSeconds(_videoCoreSDK.duration, TIMESCALE);
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@",[VEHelp timeToStringFormat:(CMTimeGetSeconds(endTime))]];
    
    [self canvasImage];
    CGRect rect =  [self getFileCrop];
    
    _pasterTextCenter = CGPointMake(rect.origin.x, rect.origin.y);
    
    if( _videoCropView.cropView.cropType != self.cropType )
        [_videoCropView.cropView setCropRectViewFrame:self.cropType];
    //    if (!CGRectEqualToRect(_selectFile.cropRect, CGRectZero)) {
    //        [_videoCropView.cropView setCropRect:_selectFile.cropRect];
    //    }else{
    CGRect r = _selectFile.cropRect;
    r.size.width = rect.size.width;
    r.size.height = rect.size.height;
    r.origin.x = (_videoCropView.cropView.cropRectView.frame.size.width-rect.size.width)/2.0;
    r.origin.y =  (_videoCropView.cropView.cropRectView.frame.size.height - rect.size.height)/2.0;
    if( self.cropType == VE_VECROPTYPE_ORIGINAL )
    {
        r.origin.x = (_syncContainerRect.size.width-rect.size.width)/2.0;
        r.origin.y =  (_syncContainerRect.size.height - rect.size.height)/2.0;
    }
    [_videoCropView.cropView setCropRect:r];
    [_videoCropView.cropView trackButton_hidden:YES];
    //    }
    
    if( _videoView )
    {
        [self initTrimSlider];
    }
}


-(void)reloadDataCropTypeView{
    
    self.dataCropTypeArray = [[NSMutableArray alloc] init];
    if(_cropType == VE_VECROPTYPE_FIXEDRATIO)
    {
        [self.cropTypeView reloadDataForDataArray:self.dataCropTypeArray];
        return;
    }
    float shaow = -5.0/90.0*self.cropTypeView.frame.size.height;
    if([VEConfigManager sharedManager].isPictureEditing)
    {
        self.cropTypeView.hidden = YES;
        {
            UIScrollView *scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(self.cropTypeView.frame.origin.x, self.cropTypeView.frame.origin.y, self.cropTypeView.frame.size.width, self.cropTypeView.frame.size.height+20)];
            [_photoView addSubview:scrollView];
            _cropTypeScrollView = scrollView;
            _cropTypeScrollView.tag = 222221;
        }
        
        float cropTypeWidth = _cropTypeScrollView.frame.size.height - 20;
        float cropTypeHeight =  _cropTypeScrollView.frame.size.height - 20;
        NSMutableArray * array = [NSMutableArray new];
        [array addObject:[NSNumber numberWithInteger:0]];
        [array addObject:[NSNumber numberWithInteger:3]];
        [array addObject:[NSNumber numberWithInteger:4]];
        [array addObject:[NSNumber numberWithInteger:1]];
        [array addObject:[NSNumber numberWithInteger:5]];
        [array addObject:[NSNumber numberWithInteger:2]];
        [array addObject:[NSNumber numberWithInteger:10]];
        [array addObject:[NSNumber numberWithInteger:11]];
        [array addObject:[NSNumber numberWithInteger:8]];
        [array addObject:[NSNumber numberWithInteger:9]];
        [array addObject:[NSNumber numberWithInteger:6]];
        [array addObject:[NSNumber numberWithInteger:7]];
        
        float asp = 1.0;
        float contWidth = 15;
        for( int i = 0; i < 12; i++ )
        {
            NSInteger index = [array[i] integerValue];
            VECropType type = VE_VECROPTYPE_FREE;
            NSString * str = nil;
            UIImage * namedImage = nil;
            UIImage *selectImage = nil;
            
            UIButton   *sender = [[UIButton alloc] initWithFrame:CGRectMake(contWidth, 5, cropTypeWidth, cropTypeHeight)];
            
            switch (index) {
                case 0://原比例
                {
                    type = VE_VECROPTYPE_ORIGINAL;
                    str = VELocalizedString(@"原始", nil);
                    asp = 1.0;
//                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_自由默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
//                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_自由选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                }
                    break;
                case 1://1:1
                {
                    type = VE_VECROPTYPE_1TO1;
                    asp = 1.0;
                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_1-1默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_1-1选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                }
                    break;
                case 2://4:5
                {
                    type = VE_VECROPTYPE_4TO5;
                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_4-5默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_4-5选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                }
                    break;
                case 3://9:16
                {
                    type = VE_VECROPTYPE_9TO16;
                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_9-16默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_9-16选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                }
                    break;
                case 4://16:9
                {
                    type = VE_VECROPTYPE_16TO9;
                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_16-9默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_16-9选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                }
                    break;
                case 5://6:7
                {
                    type = VE_VECROPTYPE_6TO7;
                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_6-7默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_6-7选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                }
                    break;
                case 6://5:8
                {
                    type = VE_VECROPTYPE_5TO8;
                    str = VELocalizedString(@"5:8", nil);
                    asp = 5.0/8.0;
//                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_1-2默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
//                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_1-2选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                }
                    break;
                case 7://2:1
                {
                    type = VE_VECROPTYPE_2TO1;
                    str = VELocalizedString(@"2:1", nil);
//                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_2-1默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
//                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_2-1选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                    asp = 2.0;
                }
                    break;
                case 8://2:3
                {
                    type = VE_VECROPTYPE_2TO3;
                    str = VELocalizedString(@"2:3", nil);
//                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_2-3默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
//                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_2-3选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                    asp = 2.0/3.0;
                }
                    break;
                case 9://3:2
                {
                    type = VE_VECROPTYPE_3TO2;
                    str = VELocalizedString(@"3:2", nil);
//                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_3-2默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
//                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_3-2选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                    asp = 3.0/2.0;
                }
                    break;
                case 10://4:3
                {
                    type = VE_VECROPTYPE_4TO3;
                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_4-3默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_4-3选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                }
                    break;
                case 11://3:4
                {
                    type = VE_VECROPTYPE_3TO4;
                    namedImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_3-4默认@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                    selectImage = [VEHelp imageNamed:@"/PESDKImage/PESDKCrop/PESDKCrop_3-4选中@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                }
                    break;
                    
                default:
                    break;
            }
            if(namedImage){
                asp = (namedImage.size.width/namedImage.size.height);
                sender.frame = CGRectMake(contWidth, 5, asp*cropTypeHeight, cropTypeHeight);
                contWidth += asp *cropTypeHeight + 5;
            }else{
                if(asp == 1.0){
                    sender.frame = CGRectMake(contWidth, cropTypeHeight * 0.35 + 5, cropTypeHeight * 0.65, cropTypeHeight * 0.65);
                    contWidth += cropTypeHeight * 0.65 + 5;
                }else{
                    sender.frame = CGRectMake(contWidth, 5, MIN(asp, 1.0)*cropTypeHeight, cropTypeHeight);
                    contWidth += MIN(asp, 1.0) *cropTypeHeight + 5;
                }
            }
            
            if( str.length > 0 )
            {
                UILabel * label = [[UILabel alloc] init];
                if(asp <1.0){
                    label.frame = CGRectMake((sender.frame.size.width - ((sender.frame.size.height - 10) * asp))/2.0, 5, (sender.frame.size.height - 10) * asp, (sender.frame.size.height - 10));
                }else{
                    label.frame = CGRectMake(5, (sender.frame.size.height - 5 - ((sender.frame.size.width - 10)/ asp)), (sender.frame.size.width - 10), (sender.frame.size.width - 10) / asp);
                }
                label.tag = 22222;
                label.textColor = UIColorFromRGB(0xffffff);
                label.backgroundColor = UIColorFromRGB(0x272727);
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                label.layer.cornerRadius = 5.0;
                label.layer.masksToBounds = YES;
                label.text = str;
                [sender addSubview:label];
            }
            
            sender.tag = type;
            [sender setImage:namedImage forState:UIControlStateNormal];
            [sender setImage:selectImage forState:UIControlStateSelected];
            [self.cropTypeScrollView addSubview:sender];
            
            if( (_selectFile.fileCropModeType == sender.tag) || ( (VE_VECROPTYPE_FREE == _cropType) && ( sender.tag == VE_VECROPTYPE_ORIGINAL ) ) )
            {
                if( self.cropTypeSelectBtn )
                {
                    self.cropTypeSelectBtn.selected = NO;
                    if( self.cropTypeSelectBtn.tag == VE_VECROPTYPE_ORIGINAL )
                        ((UILabel*)[self.cropTypeSelectBtn viewWithTag:22222]).textColor = PESDKTEXT_COLOR;
                }
                
                _cropType = sender.tag;
                [sender setSelected:YES];
                if( VE_VECROPTYPE_ORIGINAL == sender.tag )
                    ((UILabel*)[sender viewWithTag:22222]).textColor = Main_Color;
                self.cropTypeSelectBtn = sender;
                _cropType = VE_VECROPTYPE_ORIGINAL;
            }
            [sender addTarget:self action:@selector(cropType_Btn:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.cropTypeScrollView setContentSize:CGSizeMake(contWidth + 5, self.cropTypeScrollView.frame.size.height)];
        [self.cropTypeScrollView setContentOffset:CGPointMake(0, 0)];
        self.cropTypeScrollView.showsVerticalScrollIndicator = NO;
        self.cropTypeScrollView.showsHorizontalScrollIndicator = NO;
        
        {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - (self.cropTypeScrollView.frame.size.height + self.toolBar.frame.size.height+kBottomSafeHeight + 3), self.view.frame.size.width, self.cropTypeScrollView.frame.size.height + self.toolBar.frame.size.height+kBottomSafeHeight + 3)];
            view.backgroundColor = UIColorFromRGB(0x1a1a1a);
            [VEHelp addShadowToView:view withColor:UIColorFromRGB(0x000000)];
//            {
//                UIView *gsView = [[UIView alloc] init];
//                gsView.backgroundColor = [UIColor clearColor];
//                gsView.frame = CGRectMake(0, 0, view.frame.size.width, 15);
//                [gsView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(view_GSAction:)]];
//                {
//                    UIView *lineView = [UIView new];
//                    lineView.backgroundColor = UIColorFromRGB(0x272727);
//                    lineView.frame = CGRectMake( (gsView.frame.size.width - 28)/2.0 , (gsView.frame.size.height - 5)/2.0 + 3, 28, 5);
//                    lineView.layer.cornerRadius = 2;
//                    lineView.layer.masksToBounds = YES;
//                    [gsView addSubview:lineView];
//                }
//                [view addSubview:gsView];
//            }
            
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 39.5, view.frame.size.width, 0.5)];
                label.backgroundColor = UIColorFromRGB(0x272727);
                [view addSubview:label];
            }
            
            self.ribbtonView = view;
            [self.view addSubview:view];
            self.cropTypeScrollView.frame = CGRectMake(0, 5 + 40, self.cropTypeScrollView.frame.size.width, self.cropTypeScrollView.frame.size.height);
            self.toolBar.frame = CGRectMake(0,  15, self.toolBar.frame.size.width, 40);
            self.titlelab.frame = CGRectMake(50, 0, kWIDTH-100, 40);
            [view addSubview:self.cropTypeScrollView];
            [view addSubview:self.toolBar];
        }
    }
    else
    {
        for (int i = 0; i< 9; i++) {
            VECropTypeModel * cropTypeModel = [[VECropTypeModel alloc] init];
            cropTypeModel.height = _cropTypeView.frame.size.height;
            NSString * str = nil;
            if (i == 0){
                cropTypeModel.cropType = VE_VECROPTYPE_ORIGINAL;
                str = VELocalizedString(@"原比例", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 1) {
                cropTypeModel.cropType = VE_VECROPTYPE_FREE;
                str = VELocalizedString(@"自由", nil);
                cropTypeModel.iconNormal = [VEHelp imageWithContentOfFile:@"jianji/bianji/croptype_free_nomal"];
                cropTypeModel.iconSelecct = [VEHelp imageWithContentOfFile:@"jianji/bianji/croptype_free_select"];
                cropTypeModel.isHaveIcon = YES;
                cropTypeModel.isSelect = YES;
                
            }else if (i == 2){
                cropTypeModel.cropType = VE_VECROPTYPE_1TO1;
                str = VELocalizedString(@"1:1", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 3){
                cropTypeModel.cropType = VE_VECROPTYPE_9TO16;
                str = VELocalizedString(@"9:16", nil);
                cropTypeModel.iconNormal = [VEHelp imageWithContentOfFile:@"jianji/bianji/croptype_9to16_nomal"];
                cropTypeModel.iconSelecct = [VEHelp imageWithContentOfFile:@"jianji/bianji/croptype_9to16_select"];
                cropTypeModel.isHaveIcon = YES;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 4){
                cropTypeModel.cropType = VE_VECROPTYPE_16TO9;
                str = VELocalizedString(@"16:9", nil);
                cropTypeModel.iconNormal = [VEHelp imageWithContentOfFile:@"jianji/bianji/croptype_16to9_nomal"];
                cropTypeModel.iconSelecct = [VEHelp imageWithContentOfFile:@"jianji/bianji/croptype_16to9_select"];
                cropTypeModel.isHaveIcon = YES;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 5){
                cropTypeModel.cropType = VE_VECROPTYPE_6TO7;
                str = VELocalizedString(@"6:7", nil);
                cropTypeModel.iconNormal = [VEHelp imageWithContentOfFile:@"jianji/bianji/croptype_6to7_nomal"];
                cropTypeModel.iconSelecct = [VEHelp imageWithContentOfFile:@"jianji/bianji/croptype_6to7_select"];
                cropTypeModel.isHaveIcon = YES;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 6){
                cropTypeModel.cropType = VE_VECROPTYPE_5TO8;
                str = VELocalizedString(@"5.8\"", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 7){
                cropTypeModel.cropType = VE_VECROPTYPE_4TO5;
                str = VELocalizedString(@"4:5", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 8){
                cropTypeModel.cropType = VE_VECROPTYPE_4TO3;
                str = VELocalizedString(@"4:3", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 9){
                cropTypeModel.cropType = VE_VECROPTYPE_3TO5;
                str = VELocalizedString(@"3:5", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
            }else if (i == 10){
                cropTypeModel.cropType = VE_VECROPTYPE_3TO4;
                str = VELocalizedString(@"3:4", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
            }else if (i == 11){
                cropTypeModel.cropType = VE_VECROPTYPE_3TO2;
                str = VELocalizedString(@"3:2", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 12){
                cropTypeModel.cropType = VE_VECROPTYPE_235TO1;
                str = VELocalizedString(@"2.35:1", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 13){
                cropTypeModel.cropType = VE_VECROPTYPE_2TO3;
                str = VELocalizedString(@"2:3", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 14){
                cropTypeModel.cropType = VE_VECROPTYPE_2TO1;
                str = VELocalizedString(@"2:1", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
                
            }else if (i == 15){
                cropTypeModel.cropType = VE_VECROPTYPE_185TO1;
                str = VELocalizedString(@"1.85:1", nil);
                cropTypeModel.isHaveIcon = NO;
                cropTypeModel.isSelect = NO;
                
            }
            [self.dataCropTypeArray addObject:cropTypeModel];
            
            cropTypeModel.selecctTitle = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12.0/90.0*self.cropTypeView.frame.size.height], NSForegroundColorAttributeName: Main_Color, NSStrokeWidthAttributeName:@(shaow),NSStrokeColorAttributeName:Main_Color}];
            cropTypeModel.title = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12.0/90.0*self.cropTypeView.frame.size.height], NSForegroundColorAttributeName: UIColorFromRGB(0x808080), NSStrokeWidthAttributeName:@(shaow),NSStrokeColorAttributeName:UIColorFromRGB(0x808080)}];
        }
        [self.cropTypeView reloadDataForDataArray:self.dataCropTypeArray];
    }
}


-(void)view_GSAction:(UIPanGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled){
        [self finishToolBarButtonClicked];
    }
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
        if( _videoView )
            vvasset.timeRange = _selectFile.videoActualTimeRange;
        else
            vvasset.speed        = _selectFile.speed;
        
        vvasset.volume       = 1.0;//_selectFile.videoVolume;
    }else{
        NSLog(@"图片");
        vvasset.type         = MediaAssetTypeImage;
        vvasset.timeRange    = CMTimeRangeMake(kCMTimeZero, _selectFile.imageDurationTime);
        vvasset.speed        = _selectFile.speed;
        vvasset.volume       = _selectFile.videoVolume;
    }
    scene.transition.type   = TransitionTypeNone;
    scene.transition.duration = 0.0;
    vvasset.rotate = _selectFile.rotate;
    vvasset.isVerticalMirror = _selectFile.isVerticalMirror;
    vvasset.isHorizontalMirror = _selectFile.isHorizontalMirror;
    [scene.media addObject:vvasset];
    
    if( [VEConfigManager sharedManager].isPictureEditing )
    {
        scene.backgroundColor = UIColorFromRGB(0xffffff);
    }
    
    [self.scenesArray addObject:scene];

    _editVideoSize = [VEHelp getEditOrginSizeWithFile:_selectFile];

//    self.editVideoSize = self.videoCropView.bounds.size;
    
    if (_videoCoreSDK == nil) {
        _videoCoreSDK = [[VECore alloc] initWithAPPKey:[VEConfigManager sharedManager].appKey
        APPSecret:[VEConfigManager sharedManager].appSecret
        LicenceKey:[VEConfigManager sharedManager].licenceKey
        videoSize:self.editVideoSize
        fps:kEXPORTFPS
        resultFail:^(NSError *error) {
            
        }];
        [_videoCropView.videoView insertSubview:_videoCoreSDK.view  atIndex:0];
        _videoCoreSDK.delegate = self;
    }
    
    self.videoCropView.cropView.cropType = self.cropType;
    self.videoCropView.videoSize = CGSizeMake(self.editVideoSize.width, self.editVideoSize.height);
    _videoCoreSDK.frame = self.videoCropView.videoView.bounds;
    [_videoCoreSDK setEditorVideoSize:_editVideoSize];
    originalvideoCropViewFrame = _videoCoreSDK.frame;
    originalCoreSDKSize = self.videoCropView.videoSize;
    
    if( [VEConfigManager sharedManager].isPictureEditing )
    {
        _videoCoreSDK.view.backgroundColor = UIColorFromRGB(0x111111);////[UIColor whiteColor];
        _videoCropView.backgroundColor = UIColorFromRGB(0x111111);//[UIColor whiteColor];
//        _videoCropView.videoView.backgroundColor = [UIColor whiteColor];
//        _videoCropView.maskView.backgroundColor = [UIColor whiteColor];
//        _videoCropView.cropView.backgroundColor = [UIColor whiteColor];
//        _videoCropView.inputView.backgroundColor = [UIColor whiteColor];
//        _videoCropView.superview.backgroundColor = [UIColor whiteColor];
    }
    if([VEConfigManager sharedManager].iPad_HD){
        _videoCoreSDK.view.backgroundColor = VIEW_IPAD_COLOR;
        _videoCropView.backgroundColor = VIEW_IPAD_COLOR;
    }
    [_videoCoreSDK setScenes:self.scenesArray];
    
    
    
    {
        //视频分辨率
        CGRect videoRect = AVMakeRectWithAspectRatioInsideRect(self.editVideoSize, self.videoCropView.videoView.bounds);
        _syncContainerRect = CGRectMake(videoRect.origin.x + 3, videoRect.origin.y + 3, videoRect.size.width, videoRect.size.height);
        
        if(!self.syncContainerView){
            VESyncContainerView * view = [[VESyncContainerView alloc] init];
            self.syncContainerView = view;
            [self.syncContainerView setMark];
            [self.videoCropView addSubview:_syncContainerView];
        }
        self.syncContainerView.frame = _syncContainerRect;
        self.syncContainerView.layer.masksToBounds = YES;
        [self.videoCropView addSubview:_syncContainerView];
        self.syncContainerView.isNoPasterMidline = TRUE;
        
        [self.syncContainerView.syncContainer_X_Left removeFromSuperview];
        self.syncContainerView.syncContainer_X_Left = nil;
        [self.syncContainerView.syncContainer_X_Right removeFromSuperview];
        self.syncContainerView.syncContainer_X_Right = nil;
        [self.syncContainerView.syncContainer_Y_Left removeFromSuperview];
        self.syncContainerView.syncContainer_Y_Left = nil;
        [self.syncContainerView.syncContainer_Y_Right removeFromSuperview];
        self.syncContainerView.syncContainer_Y_Right = nil;
        [self initPasterViewWithFile:[self canvasImage]];
    }
    
    [_videoCoreSDK build];
}

/**销毁播放器
 */
- (void)deletePlayer {
    [_videoCoreSDK pause];
    [_videoCoreSDK stop];
    [_videoCoreSDK.view removeFromSuperview];
    _videoCoreSDK.delegate = nil;
    _videoCoreSDK = nil;
}



#pragma mark - 4.Custom Methods

- (void)applicationEnterHome:(NSNotification *)notification{
    if(_exportProgressView){
        __block typeof(self) myself = self;
        [_videoCoreSDK cancelExportMovie:^{
            //更新UI需在主线程中操作
            dispatch_async(dispatch_get_main_queue(), ^{
                [myself.exportProgressView removeFromSuperview];
                myself.exportProgressView = nil;
                [[UIApplication sharedApplication] setIdleTimerDisabled:self.idleTimerDisabled];
            });
        }];
    }
}

-(void)backAction{
    
    [self deletePlayer];
    if (_cancelBlock) {
        _cancelBlock();
    }
    if([VEConfigManager sharedManager].iPad_HD){
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        return;
    }
    if(_isPresentModel){
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    }
    UIViewController *upView = [self.navigationController popViewControllerAnimated:NO];
    if(!upView){
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
}

-(void)playVideoEvent:(UITapGestureRecognizer *)gesture{
    [self playButtonClicked];
}

-(void)exportNavBarButtonClicked{
    oldselectFile = _selectFile;
    [self save];
}

-(void)finishToolBarButtonClicked{
    oldselectFile = _selectFile;
    [self save];
}

-(void)playButtonClicked{
    [self playVideo:![_videoCoreSDK isPlaying]];
}

- (void)playVideo:(BOOL)play{

    if(!play){
        if([_videoCoreSDK isPlaying]){
           [_videoCoreSDK pause];
        }
        _playButton.selected = NO;
        if( _cutMmodeType == kCropTypeFixed ){
            _playButton.hidden = NO;
        }
    }else{
        _playButton.selected = YES;
        if( _cutMmodeType == kCropTypeFixed ){
            _playButton.hidden = YES;
        }
        [_videoCoreSDK play];
    }
}

- (void)playToEnd{
    [self playVideo:NO];
    if( _cutMmodeType == kCropTypeFixed ){
        [_videoCoreSDK seekToTime:_playTimeRange.start];
        [_videoTrimiSlider progress:CMTimeGetSeconds(_playTimeRange.start)];
    }else {
        CMTime start = CMTimeMakeWithSeconds(_videoCoreSDK.duration* self.playSlider.minimumValue, TIMESCALE);
        [_videoCoreSDK seekToTime:start toleranceTime:kCMTimeZero completionHandler:nil];
    }
}

-(void)seekTime:(CMTime) time
{
    _seekTime = time;
}

-(void)seektimeCore
{
    if( CMTimeGetSeconds(self.seekTime) > 0 )
    {
        if (_selectFile.isGif) {
            self.seekTime = _selectFile.imageTimeRange.start;
        }else {
            self.seekTime = _selectFile.videoTrimTimeRange.start;
        }
        double time = CMTimeGetSeconds(self.seekTime);
        [_videoCoreSDK seekToTime:self.seekTime];
        float duration = _videoCoreSDK.duration;
        float progress = time/duration;
        if(!isnan(progress)){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.playSlider.value = progress;
            });
        }
    }
}

-(void)whirlButtonClicked{
    _selectFile.rotate += 90;
    
    self.videoCropView.hidden = YES;
    [self playVideo:NO];
    [_videoCoreSDK stop];
    [self refreshPlayerFrame];
    [self setBackButtonWithisEnabled:YES];
    
}

-(void)vertButtonClicked{
    
    _selectFile.isVerticalMirror = !_selectFile.isVerticalMirror;
    [self playVideo:NO];
    MediaAsset * vvasset = [[_scenes firstObject].media firstObject];
    vvasset.isVerticalMirror = _selectFile.isVerticalMirror;
    [self.videoCoreSDK refreshCurrentFrame];
    [self setBackButtonWithisEnabled:YES];
   

    
}

-(void)horizontalButtonClicked{
    
    _selectFile.isHorizontalMirror = !_selectFile.isHorizontalMirror;
    [self playVideo:NO];
    
    MediaAsset * vvasset = [[_scenes firstObject].media firstObject];
    vvasset.isHorizontalMirror = _selectFile.isHorizontalMirror;
    [self.videoCoreSDK refreshCurrentFrame];
    
    [self setBackButtonWithisEnabled:YES];
    
    
}

-(void)backButtonClicked{
    
    [self setBackButtonWithisEnabled:NO];
    [self playVideo:NO];
    _selectFile.isVerticalMirror = NO;
    _selectFile.isHorizontalMirror = NO;
    _selectFile.rotate = 0;
    [self deletePlayer];
    [self initPlayer];
    
}

-(void)setBackButtonWithisEnabled:(BOOL)isEnabled{
    if (isEnabled) {
        [self.backButton setImage:[VEHelp imageWithContentOfFile:@"jianji/bianji/jianji_back_select"] forState:UIControlStateNormal];
        self.backButton.userInteractionEnabled = YES;
        [self.backButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
    }else{
        
        [_backButton setImage:[VEHelp imageWithContentOfFile:@"jianji/bianji/jianji_back_normal"] forState:UIControlStateNormal];
        [self.backButton setTitleColor:UIColorFromRGB(0x808080) forState:UIControlStateNormal];
        self.backButton.userInteractionEnabled = NO;
        [self.cropTypeView didSelectItemAtIndexPathRow:self.cropType];//0
        //self.cropType = VE_VECROPTYPE_FREE;
        [_videoCropView.cropView setCropRectViewFrame:self.cropType];
        self.playSlider.value = self.playSlider.minimumValue;
        _playTimeLabel.text = @"00:00.0";
        
        
    }
    
}

- (void)save{
    CGRect crop = [self.videoCropView.cropView crop];
    CGRect cropRect = [self.videoCropView.cropView cropRect];
    CGRect r = crop;
    if(!_selectFile.isVerticalMirror && !_selectFile.isHorizontalMirror){
        if(self.cropType == VE_VECROPTYPE_FIXEDRATIO){
            if(_selectFile.rotate == - 270 || _selectFile.rotate == 90){
                r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
            }else if(_selectFile.rotate == - 180 || _selectFile.rotate == 180){
                r = CGRectMake(crop.origin.x,  crop.origin.y, crop.size.width, crop.size.height);
            }else if(_selectFile.rotate == - 90 || _selectFile.rotate == 270){
                r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
            }else{
                r = CGRectMake(crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
            }
        }else{
            if(_selectFile.rotate == - 270 || _selectFile.rotate == 90){
                r = CGRectMake(1 - crop.size.height - crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
            }else if(_selectFile.rotate == - 180 || _selectFile.rotate == 180){
                r = CGRectMake(1- crop.size.width - crop.origin.x, 1- crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
            }else if(_selectFile.rotate == - 90 || _selectFile.rotate == 270){
                r = CGRectMake(crop.origin.y, 1 - crop.size.width - crop.origin.x, crop.size.height, crop.size.width);
            }
        }
    }else if(_selectFile.isVerticalMirror && !_selectFile.isHorizontalMirror){
        if(_selectFile.rotate == - 270 || _selectFile.rotate == 90){
            r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
        }else if(_selectFile.rotate == - 180 || _selectFile.rotate == 180){
            r = CGRectMake(1- crop.size.width - crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
        }else if(_selectFile.rotate == - 90 || _selectFile.rotate == 270){
            r = CGRectMake(1 - crop.size.height - crop.origin.y, 1 - crop.size.width - crop.origin.x, crop.size.height, crop.size.width);
        }else{
            r = CGRectMake(crop.origin.x, 1 - crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
        }
    }else if(!_selectFile.isVerticalMirror && _selectFile.isHorizontalMirror){
        if(_selectFile.rotate == - 270 || _selectFile.rotate == 90){
            r = CGRectMake(1 - crop.size.height - crop.origin.y, 1- crop.size.width - crop.origin.x, crop.size.height, crop.size.width);
        }else if(_selectFile.rotate == - 180 || _selectFile.rotate == 180){
            r = CGRectMake(crop.origin.x, 1- crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
        }else if(_selectFile.rotate == - 90 || _selectFile.rotate == 270){
            r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
        }else{
            r = CGRectMake(1- crop.size.width - crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
        }
    }else{
        if(_selectFile.rotate == - 270 || _selectFile.rotate == 90){
            r = CGRectMake(crop.origin.y,1- crop.size.width- crop.origin.x, crop.size.height, crop.size.width);
        }else if(_selectFile.rotate == - 180 || _selectFile.rotate == 180){
            r = CGRectMake(crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
        }else if(_selectFile.rotate == - 90 || _selectFile.rotate == 270){
            r = CGRectMake(1- crop.size.height - crop.origin.y,crop.origin.x, crop.size.height, crop.size.width);
        }else{
            r = CGRectMake(1- crop.size.width - crop.origin.x,1- crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
        }
    }
    
    oldselectFile.crop = r;
    oldselectFile.cropRect = cropRect;
    if(_flowPicture){
        _selectFile.crop = r;
        if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
            [self dismissViewControllerAnimated:NO completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:NO];
        }
    }else{
        if([VEConfigManager sharedManager].isSingleFunc && [VEConfigManager sharedManager].callbackBlock){
            _selectFile.crop = r;
            [self exportMovie];
        }else {
            if([VEConfigManager sharedManager].iPad_HD){
                [self.view removeFromSuperview];
                [self removeFromParentViewController];
//                return;
            }
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
    

    CGPoint point = [_videoCropView.cropView convertPoint:_videoCropView.cropView.cropRectView.frame.origin toView:self.pasterTextView.contentImage ];
    CGSize size = _videoCropView.cropView.cropRectView.frame.size;
    
    point = CGPointMake(point.x*self.pasterTextView.selfscale, point.y*self.pasterTextView.selfscale);
    CGSize imageSize = CGSizeMake(self.pasterTextView.contentImage.bounds.size.width*self.pasterTextView.selfscale, self.pasterTextView.contentImage.bounds.size.height*self.pasterTextView.selfscale);
    
    if(_editVideoForOnceFinishAction){
        _selectFile.contentURL = oldselectFile.contentURL;
        _editVideoForOnceFinishAction(NO,
                                      CGRectMake(point.x/imageSize.width, point.y/imageSize.height, size.width/imageSize.width, size.height/imageSize.height),
                                      _videoCropView.cropView.cropRectView.frame,
                                      oldselectFile.isVerticalMirror,
                                      oldselectFile.isHorizontalMirror,
                                      oldselectFile.rotate,
                                      _cropType);
        
    }
    
    CMTimeRange range = kCMTimeRangeZero;
    if (_cutMmodeType == kCropTypeFixed) {
        range.duration = CMTimeMakeWithSeconds(_trimDuration_OneSpecifyTime, TIMESCALE);
        range.start = CMTimeMakeWithSeconds( _videoTrimiSlider.progressValue, TIMESCALE);
    }else {
        range.duration = CMTimeMakeWithSeconds(_trimDuration_OneSpecifyTime/(float)_selectFile.speed, TIMESCALE);
        range.start = CMTimeMakeWithSeconds( _videoTrimiSlider.progressValue/(float)_selectFile.speed, TIMESCALE);
    }
    
    if(_editVideoForOnce_timeFinishAction){
        _selectFile.contentURL = oldselectFile.contentURL;
        if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
            [self dismissViewControllerAnimated:NO completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:NO];
        }
        _editVideoForOnce_timeFinishAction(NO,
                                           CGRectMake(point.x/imageSize.width, point.y/imageSize.height, size.width/imageSize.width, size.height/imageSize.height),
                                           _videoCropView.cropView.cropRectView.frame,
                                           _selectFile.isVerticalMirror,
                                           _selectFile.isHorizontalMirror,
                                           _selectFile.rotate,
                                           range,
                                           _selectFile.fileCropModeType);
        
    }
    
    if( _editVideoForOnceFinishFiltersAction )
    {
        _editVideoForOnceFinishFiltersAction(oldselectFile.crop,oldselectFile.cropRect,oldselectFile.isVerticalMirror,oldselectFile.isHorizontalMirror,oldselectFile.rotate,_cropType,oldselectFile.filterIndex);
    }
    
    
}


- (void)exportMovie{
    
    
    [self playVideo:NO];
    if(self.exportProgressView.superview){
        [self.exportProgressView removeFromSuperview];
    }
    [self refreshPlayer:[NSNumber numberWithBool:NO]];
    [self.view addSubview:self.exportProgressView];
    self.exportProgressView.hidden = NO;
    [self.exportProgressView setProgress:0 animated:NO];
    
    //[self refreshPlayer:[NSNumber numberWithBool:NO]];
    
    CGRect selectCrop = [self.videoCropView.cropView crop];
    
    float videoSizeWidth = self.videoCropView.videoSize.width * selectCrop.size.width;
    float videoSizeHeight = self.videoCropView.videoSize.height * selectCrop.size.height;
    
    CGSize size = CGSizeMake(videoSizeWidth, videoSizeHeight);
    
    
    
    [_videoCoreSDK setEditorVideoSize:size];
    
    
    NSString *export = [VEConfigManager sharedManager].outPath;
    if(export.length==0){
        export = [NSTemporaryDirectory() stringByAppendingPathComponent:@"exportvideo.mp4"];
    }
    unlink([export UTF8String]);
    self.idleTimerDisabled = [UIApplication sharedApplication].idleTimerDisabled;
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    
    AVMutableMetadataItem *titleMetadata = [[AVMutableMetadataItem alloc] init];
    titleMetadata.key = AVMetadataCommonKeyTitle;
    titleMetadata.keySpace = AVMetadataKeySpaceQuickTimeMetadata;
    titleMetadata.locale =[NSLocale currentLocale];
    titleMetadata.value = @"titile";
    
    AVMutableMetadataItem *locationMetadata = [[AVMutableMetadataItem alloc] init];
    locationMetadata.key = AVMetadataCommonKeyLocation;
    locationMetadata.keySpace = AVMetadataKeySpaceQuickTimeMetadata;
    locationMetadata.locale = [NSLocale currentLocale];
    locationMetadata.value = @"location";
    
    AVMutableMetadataItem *creationDateMetadata = [[AVMutableMetadataItem alloc] init];
    creationDateMetadata.key = AVMetadataCommonKeyCopyrights;
    creationDateMetadata.keySpace = AVMetadataKeySpaceQuickTimeMetadata;
    creationDateMetadata.locale = [NSLocale currentLocale];
    creationDateMetadata.value = @"copyrights";
    
    AVMutableMetadataItem *descriptionMetadata = [[AVMutableMetadataItem alloc] init];
    descriptionMetadata.key = AVMetadataCommonKeyDescription;
    descriptionMetadata.keySpace = AVMetadataKeySpaceQuickTimeMetadata;
    descriptionMetadata.locale = [NSLocale currentLocale];
    descriptionMetadata.value = @"descriptionMetadata";
    
    WeakSelf(self);
    [_videoCoreSDK exportMovieURL:[NSURL fileURLWithPath:export]
                        size:size
                     bitrate:[VEConfigManager sharedManager].videoAverageBitRate
                         fps:kEXPORTFPS
                    metadata:@[titleMetadata, locationMetadata, creationDateMetadata, descriptionMetadata]
                audioBitRate:0
         audioChannelNumbers:[VEConfigManager sharedManager].peExportConfiguration.audioChannelNumbers
      maxExportVideoDuration:[VEConfigManager sharedManager].peExportConfiguration.outputVideoMaxDuration
                    progress:^(float progress) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            StrongSelf(self);
                            if(strongSelf && strongSelf->_exportProgressView)
                                [strongSelf->_exportProgressView setProgress:progress*100.0 animated:NO];
                        });
                    } success:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf exportMovieSuc:export];
                        });
                    } fail:^(NSError *error) {
                        NSLog(@"失败:%@",error);
                        [weakSelf exportMovieFail:error];
                    }];
    
}


- (void)exportMovieFail:(NSError *)error {
    isNeedRefreshPlayer = YES;
    if(self.exportProgressView.superview){
        [self.exportProgressView removeFromSuperview];
    }
    self.exportProgressView = nil;
    [[UIApplication sharedApplication] setIdleTimerDisabled:self.idleTimerDisabled];
    self.currentFrameView.hidden = NO;
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:error.localizedDescription
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:VELocalizedString(@"确定",nil)
                                                  otherButtonTitles:nil, nil];
        alertView.tag = 3;
        [alertView show];
    }
}

- (void)exportMovieSuc:(NSString *)exportPath{
    if ([self.navigationController.visibleViewController isKindOfClass:[UIAlertController class]]) {
        WeakSelf(self);
        UIAlertController *alert = (UIAlertController *)self.navigationController.visibleViewController;
        [alert dismissViewControllerAnimated:YES completion:^{
            [weakSelf exportMovieSuc:exportPath];
        }];
        return;
    }
    if(self.exportProgressView.superview){
        [self.exportProgressView removeFromSuperview];
        self.exportProgressView = nil;
    }
    
    [self deletePlayer];
    if([VEConfigManager sharedManager].iPad_HD){
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        if([VEConfigManager sharedManager].callbackBlock){
            [VEConfigManager sharedManager].callbackBlock(exportPath);
        }
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if([VEConfigManager sharedManager].callbackBlock){
            [VEConfigManager sharedManager].callbackBlock(exportPath);
        }
    }];
}

-(void)refreshPlayerFrame{
    
    
    
    MediaAsset * vvasset = [[_scenes firstObject].media firstObject];
    vvasset.rotate = _selectFile.rotate;
    vvasset.isVerticalMirror = _selectFile.isVerticalMirror;
    vvasset.isHorizontalMirror = _selectFile.isHorizontalMirror;
    vvasset.crop = CGRectZero;
    _selectFile.crop = CGRectMake(0, 0, 1, 1);
    
    self.editVideoSize = [VEHelp getEditSizeWithFile:self.selectFile];
    self.videoCropView.videoSize = self.editVideoSize;
    
    
    self.videoCoreSDK.frame = self.videoCropView.videoView.bounds;
    [self.videoCoreSDK setEditorVideoSize:self.editVideoSize];
    [self.videoCoreSDK build];
    
}

- (void)refreshPlayer:(NSNumber *)needRefreshFiles{
    
    self.scenes = [NSMutableArray new];
    VEMediaInfo *file = _selectFile;
    Scene *scene = [[Scene alloc] init];
    MediaAsset * vvasset = [[MediaAsset alloc] init];
    vvasset.localIdentifier = file.localIdentifier;
    vvasset.url = file.contentURL;
    if(_selectFile.fileType == kFILEVIDEO){
        vvasset.videoActualTimeRange = file.videoActualTimeRange;
        vvasset.type = MediaAssetTypeVideo;
        if(file.isReverse){
            vvasset.url = file.reverseVideoURL;
            if (CMTimeRangeEqual(kCMTimeRangeZero, file.reverseVideoTimeRange)) {
                vvasset.timeRange = CMTimeRangeMake(kCMTimeZero, file.reverseDurationTime);
            }else{
                vvasset.timeRange = file.reverseVideoTimeRange;
            }
            if(CMTimeCompare(vvasset.timeRange.duration, file.reverseVideoTrimTimeRange.duration) == 1){
                vvasset.timeRange = file.reverseVideoTrimTimeRange;
            }
        }
        else{
            if (CMTimeRangeEqual(kCMTimeRangeZero, file.videoTimeRange)) {
                vvasset.timeRange = CMTimeRangeMake(kCMTimeZero, file.videoDurationTime);
            }else{
                vvasset.timeRange = file.videoTimeRange;
            }
            if(CMTimeGetSeconds(file.videoTrimTimeRange.duration) > 0){
                vvasset.timeRange = file.videoTrimTimeRange;
            }
        }
    }else{
        vvasset.type         = MediaAssetTypeImage;
        if (CMTimeCompare(file.imageTimeRange.duration, kCMTimeZero) == 1) {
            vvasset.timeRange = file.imageTimeRange;
        }else {
            vvasset.timeRange    = CMTimeRangeMake(kCMTimeZero, file.imageDurationTime);
        }
        vvasset.speed        = file.speed;
        vvasset.volume       = file.videoVolume;
    }
    vvasset.speed = file.speed;
    vvasset.volume = file.videoVolume;
    vvasset.rotate = file.rotate;
    vvasset.isVerticalMirror = file.isVerticalMirror;
    vvasset.isHorizontalMirror = file.isHorizontalMirror;
    if (_exportProgressView) {
        vvasset.crop = file.crop;
    }else {
        vvasset.crop = CGRectZero;
    }
    [scene.media addObject:vvasset];
    [self.scenes addObject:scene];
    
    _oldscenes = [[NSMutableArray alloc] initWithArray:self.scenes];
    [_videoCoreSDK setScenes:self.scenes];
    
//    if (_musicURL) {
//        MusicInfo *music = [[MusicInfo alloc] init];
//        music.url = _musicURL;
//        music.clipTimeRange = _musicTimeRange;
//        music.volume = _musicVolume;
//        music.isFadeInOut = YES;
//        [_videoCoreSDK setMusics:[NSMutableArray arrayWithObject:music]];
//    }
    
//    [_videoCoreSDK build];
    if (!_exportProgressView) {
        [_videoCoreSDK build];
    }
}


//- (void)refreshSelectThumbFiles:(BOOL)needRefreshFile cropOrRotation:(BOOL)cropOrRotation{
//    if(_originFile.isReverse){
//        _isPortrait = [VECommonClass isVideoPortrait:[AVURLAsset assetWithURL:_originFile.reverseVideoURL]];
//    }else{
//        _isPortrait = [VECommonClass isVideoPortrait:[AVURLAsset assetWithURL:_originFile.contentURL]];
//    }
//
//    if(_originFile.fileType == kFILEIMAGE && !_originFile.isGif){
//        UIImage *image = [VECommonClass getFullScreenImageWithUrl:_originFile.contentURL];
//        if(_originFile.filterIndex >0 && _globalFilters && (_globalFilters.count > 0) )
//        {
//            Filter * filter = _globalFilters[_originFile.filterIndex];
//            _currentImage = [VECore getFilteredImage:image filter:filter];
//        }
//        else{
//            _currentImage = image;
//        }
//        _currentImage = [VECommonClass imageRotatedByDegrees:_currentImage rotation: _originFile.rotate];
//
//
//        _presentationSize  = _currentImage.size;
//        _custom_imagev.image = _currentImage;
//        if(needRefreshFile){
//            [self initCustomPreView];
//            [self initCropView];
//        }
//    }
//    else{
//
//        CGSize size;
//
//
//        size = [self getVideoSizeForTrack];
//        _presentationSize = size;
//
//        if(size.height == size.width){
//
//            _presentationSize        = size;
//
//        }else if(_isPortrait){
//            _presentationSize = size;
//
//            if(size.height < size.width){
//                _presentationSize  = CGSizeMake(size.height, size.width);
//            }
//            if(_originFile.rotate == -90 || _originFile.rotate == -270 || _originFile.rotate == 90 || _originFile.rotate == 270){
//                _presentationSize  = CGSizeMake(_presentationSize.height, _presentationSize.width);
//            }
//        }else{
//            _presentationSize  = [self getVideoSizeForTrack];
//            if(_originFile.rotate == -90 || _originFile.rotate == -270 || _originFile.rotate == 90 || _originFile.rotate == 270){
//                CGSize size = [self getVideoSizeForTrack];
//                _presentationSize  = CGSizeMake(size.height, size.width);
//            }
//        }
//    }
//}


#pragma mark - 5.DataSource and Delegate



#pragma mark - VECoreDelegate
- (void)statusChanged:(VECore *)sender status:(VECoreStatus)status
{
    if (sender == _videoCoreSDK && status == kVECoreStatusReadyToPlay) {
        if (isNeedRefreshPlayer) {
            isNeedRefreshPlayer = NO;
            self.scenes = [[NSMutableArray alloc] initWithArray:_oldscenes];
            [self refreshPlayerFrame];
            [_videoCropView.cropView setCropRectViewFrame:self.cropType];
        }else {
            [_currentFrameView removeFromSuperview];
            _currentFrameView = nil;
            _videoCoreSDK.view.hidden = NO;
            [self seektimeCore];
            self.videoCropView.hidden = NO;
        }
        if( _videoTrimiSlider )
        {
            CMTimeRange timeRange = kCMTimeRangeZero;
            if (_selectFile.isGif) {
                timeRange = _selectFile.imageTimeRange;
            }
            else if(_selectFile.isReverse){
                timeRange = _selectFile.reverseVideoTrimTimeRange;
            }else{
                timeRange = _selectFile.videoTrimTimeRange;
            }
            [self performSelector:@selector(loadTrimmerViewThumbImage) withObject:nil afterDelay:0.1];
            [_videoTrimiSlider interceptProgress:CMTimeGetSeconds( timeRange.start )];
        }
//        if([VEConfigManager sharedManager].iPad_HD){
//            CGRect r = self.videoCropView.cropView.cropRectView.frame;
//            r.origin.y = 0;
//            self.videoCropView.cropView.cropRectView.frame = r;
//        }
        CGPoint point = self.videoCropView.cropView.cropRectView.frame.origin;
        
        point = [self.videoCropView.cropView convertPoint:point toView:self.syncContainerView];
        self.pasterTextView.cropRect = CGRectMake(point.x, point.y, self.videoCropView.cropView.cropRectView.frame.size.width, self.videoCropView.cropView.cropRectView.frame.size.height);
        
        CGAffineTransform transform2 = CGAffineTransformMakeRotation( -_selectFile.rotate/(180.0/M_PI) );
        self.pasterTextView.transform = CGAffineTransformScale(transform2, _pasterTextViewScale, _pasterTextViewScale);
        [self.pasterTextView setFramescale:_pasterTextViewScale];
        [self.pasterTextView setCenter:CGPointMake(_pasterTextCenter.x+(point.x + self.pasterTextView.cropRect.size.width/2.0), _pasterTextCenter.y+(point.y + self.pasterTextView.cropRect.size.height/2.0))];
        
        [self svae_PaterText];
        [self.videoCoreSDK refreshCurrentFrame];
        
        {
            
        }
    }
}
- (void)tapPlayerView{
    [self playVideo:![_videoCoreSDK isPlaying]];
}


- (void)progressCurrentTime:(CMTime)currentTime{
    CMTime time = currentTime;
    if(!_videoCoreSDK.isPlaying){
        return;
    }
    //NSLog(@"%d",time.value/time.timescale);
    if([[NSString stringWithFormat:@"%f", CMTimeGetSeconds(time)] isEqualToString:@"nan"])
    {
        return;
    }
    float progress = CMTimeGetSeconds(time);
    if( _cutMmodeType == kCropTypeFixed ){
        [_videoTrimiSlider progress:progress];
        if (CMTimeCompare(currentTime, CMTimeAdd(_playTimeRange.start, _playTimeRange.duration)) >= 0) {
            [self playVideo:NO];
            [_videoCoreSDK seekToTime:_playTimeRange.start];
            [_videoTrimiSlider progress:CMTimeGetSeconds(_playTimeRange.start)];
        }
    }else {
        float progressValue = progress/_videoCoreSDK.duration;
        self.playSlider.value = progressValue;
        CMTime palyTime = CMTimeMakeWithSeconds(_videoCoreSDK.duration*progressValue*(float)_selectFile.speed, TIMESCALE);
        _playTimeLabel.text = [NSString stringWithFormat:@"%@",[VEHelp timeToStringFormat:(CMTimeGetSeconds(palyTime))]];
        CMTime endtime = CMTimeMakeWithSeconds(_videoCoreSDK.duration*_playSlider.maximumValue, TIMESCALE);
        if(CMTimeCompare(CMTimeAdd(currentTime, CMTimeMake(1, kEXPORTFPS)), endtime) == 1){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.playSlider.value = 0;
            });
            self.playSlider.value = 1.1;
            _playTimeLabel.text = @"00:00.0";
            [self playToEnd];
            return;
        }
    }
}


#pragma mark VEPlaySliderDelegate
-(void)playSlider:(VEPlaySlider*)playSlider withPlayValue:(CGFloat)playValue{
    
    [_videoCoreSDK seekToTime:CMTimeMakeWithSeconds(_videoCoreSDK.duration*playValue, TIMESCALE) toleranceTime:kCMTimeZero completionHandler:nil];
    CMTime palyTime = CMTimeMakeWithSeconds(_videoCoreSDK.duration*playValue*(float)_selectFile.speed, TIMESCALE);
    _playTimeLabel.text = [NSString stringWithFormat:@"%@",[VEHelp timeToStringFormat:(CMTimeGetSeconds(palyTime))]];
    
    
}
-(void)playSliderTouchesBegan:(VEPlaySlider *)playSlider withEvent:(UIEvent *)event{
    [self playVideo:NO];
}
-(void)playSliderTouchesMoved:(VEPlaySlider *)playSlider withEvent:(UIEvent *)event{
    
}
-(void)playSliderTouchesEnded:(VEPlaySlider *)playSlider withEvent:(UIEvent *)event{
    
}

-(void)cropType_Btn:( UIButton * ) sender
{
    if( self.cropTypeSelectBtn == sender )
    {
        return;
    }
 
    if( self.cropTypeSelectBtn )
    {
        self.cropTypeSelectBtn.selected = NO;
        if([self.cropTypeSelectBtn viewWithTag:22222])
            ((UILabel*)[self.cropTypeSelectBtn viewWithTag:22222]).textColor = UIColorFromRGB(0xffffff);
    }
    
    [_videoCropView.cropView setCropRectViewFrame:sender.tag];
    self.cropType = sender.tag;
    self.cropTypeSelectBtn = sender;
    self.cropTypeSelectBtn.selected = YES;
    if([self.cropTypeSelectBtn viewWithTag:22222])
        ((UILabel*)[self.cropTypeSelectBtn viewWithTag:22222]).textColor = Main_Color;
    
    CGPoint point = self.videoCropView.cropView.cropRectView.frame.origin;
    point = [self.videoCropView.cropView convertPoint:point toView:self.syncContainerView];
    self.pasterTextView.cropRect = CGRectMake(point.x, point.y, self.videoCropView.cropView.cropRectView.frame.size.width, self.videoCropView.cropView.cropRectView.frame.size.height);
    float scale = [self.pasterTextView getCropREct_Scale:self.pasterTextView.selfscale];
    [self.pasterTextView setMinScale:scale];
//    if( self.cropType == VE_VECROPTYPE_ORIGINAL )
//    {
//        scale = [VEHelp getMediaAssetScale_File:[self canvasImage].size atRect:self.originalRect atCorp:CGRectMake(0, 0, 1, 1) atSyncContainerHeihgt:self.syncContainerView.bounds.size atIsWatermark:NO];
//    }
    CGAffineTransform transform2 = CGAffineTransformMakeRotation( -_selectFile.rotate/(180.0/M_PI) );
    self.pasterTextView.transform = CGAffineTransformScale(transform2, scale, scale);
    [self.pasterTextView setFramescale:scale];
    [self.pasterTextView setCenter:[self.pasterTextView  getCropRect_Center:self.pasterTextView .center]];
    
    [self svae_PaterText];
    [self.videoCoreSDK refreshCurrentFrame];
    
//    [self getFileCrop];
}

#pragma mark VECropTypeDelegate
-(void)cropTypeView:(VECropTypeView *)cropTypeView selectItemAtIndexPath:(NSIndexPath *)indexPath{
    VECropTypeModel * cropTypeModel = [self.dataCropTypeArray objectAtIndex:indexPath.section];
    [_videoCropView.cropView setCropRectViewFrame:cropTypeModel.cropType];
    self.cropType = cropTypeModel.cropType;
    
    CGPoint point = self.videoCropView.cropView.cropRectView.frame.origin;
    point = [self.videoCropView.cropView convertPoint:point toView:self.syncContainerView];
    self.pasterTextView.cropRect = CGRectMake(point.x, point.y, self.videoCropView.cropView.cropRectView.frame.size.width, self.videoCropView.cropView.cropRectView.frame.size.height);
    float scale = [self.pasterTextView getCropREct_Scale:self.pasterTextView.selfscale];
    CGAffineTransform transform2 = CGAffineTransformMakeRotation( -_selectFile.rotate/(180.0/M_PI) );
    self.pasterTextView.transform = CGAffineTransformScale(transform2, scale, scale);
    [self.pasterTextView setFramescale:scale];
    [self.pasterTextView setCenter:[self.pasterTextView  getCropRect_Center:self.pasterTextView .center]];
    
    [self svae_PaterText];
    [self.videoCoreSDK refreshCurrentFrame];
}

#pragma mark VECropTypeDelegate

-(void)cropViewbeginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [self setBackButtonWithisEnabled:YES];
}


- (void)cropViewCrop:(CGRect)crop withCropRect:(CGRect)cropRect{
    
    self.crop = crop;
    self.cropRect =  cropRect;
    
    NSLog(@"%f  %f    %f    %f",crop.origin.x,crop.origin.y,crop.size.width,crop.size.height);
    NSLog(@"%f  %f    %f    %f",cropRect.origin.x,cropRect.origin.y,cropRect.size.width,cropRect.size.height);
    
}

#pragma mark- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case 1:
            if (buttonIndex == 1) {
               
                [self exportMovie];
            }
            break;
        case 2:
            if(buttonIndex == 1){
                isNeedRefreshPlayer = YES;
                [_exportProgressView setProgress:0 animated:NO];
                [_exportProgressView removeFromSuperview];
                _exportProgressView = nil;
                [[UIApplication sharedApplication] setIdleTimerDisabled:self.idleTimerDisabled];
                self.currentFrameView.hidden = NO;
                [_videoCoreSDK cancelExportMovie:nil];
                
                //cropView.frame = CGRectMake(0, 0,self.frame.size.width, self.frame.size.height);
                
//                self.videoCoreSDK.frame = originalvideoCropViewFrame;
//                [self.videoCoreSDK setEditorVideoSize:originalCoreSDKSize];
//                [self.videoCoreSDK refreshCurrentFrame];
                
//                _editVideoSize = [VECommonClass getEditSizeWithFile:_selectFile];
//                self.videoCropView.videoSize = self.editVideoSize;
//
//                _videoCoreSDK.frame = originalvideoCropViewFrame;
//                [_videoCoreSDK setEditorVideoSize:originalCoreSDKSize];
                _selectFile = oldselectFile;
                [self refreshPlayer:[NSNumber numberWithBool:NO]];
            }
            break;
        default:
            break;
    }
}

- (UIView *)currentFrameView {
    if (!_currentFrameView) {
        _currentFrameView = [_videoCropView.videoView snapshotViewAfterScreenUpdates:YES];
        _videoCoreSDK.view.hidden = YES;
        _currentFrameView.frame = _videoCropView.videoView.bounds;
        [_videoCropView.videoView addSubview:_currentFrameView];
    }
    return _currentFrameView;
}

#pragma mark - 6.Set & Get
-(VEVideoCropView *)videoCropView{
    if (_videoCropView == nil) {
        CGRect rect = CGRectZero;
        if (_isNeedExport) {
            rect = CGRectMake(0,kNavgationBar_Height, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kNavgationBar_Height - 240 - kBottomSafeHeight);
            if( _cutMmodeType == kCropTypeFixed ){
                if( _selectFile.fileType == kFILEIMAGE )
                {
                    if( _isCropTypeViewHidden )
                    {
                        rect = CGRectMake(0,kNavgationBar_Height, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kNavgationBar_Height - kBottomSafeHeight);
                    }
                    else
                        rect = CGRectMake(0,kNavgationBar_Height, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kNavgationBar_Height - 65 - kBottomSafeHeight);
                }
                else{
                    if( _isCropTypeViewHidden )
                    {
                        rect = CGRectMake(0,kNavgationBar_Height, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kNavgationBar_Height - 85 - kBottomSafeHeight);
                    }
                    else
                        rect = CGRectMake(0,kNavgationBar_Height, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kNavgationBar_Height - 180 - kBottomSafeHeight);
                }
            }
        }else {
            rect = CGRectMake(0,kPlayerViewOriginX, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kPlayerViewOriginX - 240 - kToolbarHeight);
            if( _cutMmodeType == kCropTypeFixed ){
                if( _selectFile.fileType == kFILEIMAGE )
                {
                    if( _isCropTypeViewHidden )
                    {
                        rect = CGRectMake(0,kPlayerViewOriginX, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kPlayerViewOriginX - kToolbarHeight - ipadToolBarHeight);
                    }
                    else
                        rect = CGRectMake(0,kPlayerViewOriginX, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kPlayerViewOriginX - 65 - kToolbarHeight);
                }
                else{
                    if( _isCropTypeViewHidden )
                    {
                        rect = CGRectMake(0,kPlayerViewOriginX, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kPlayerViewOriginX - 85 - kToolbarHeight);
                    }
                    else
                        rect = CGRectMake(0,kPlayerViewOriginX, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kPlayerViewOriginX - 180 - kToolbarHeight);
                }
            }
            else if( kCropTypeFixedRatio == _cutMmodeType ){
                rect = CGRectMake(0,kPlayerViewOriginX, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kPlayerViewOriginX - kToolbarHeight);
            }
        }
        if([VEConfigManager sharedManager].iPad_HD){
            if( _isCropTypeViewHidden )
            {
//                rect = CGRectMake(0,44, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame) - 44 - 20);
                rect = CGRectMake(0,44, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame) - 44 - 85);
            }else{
                rect = CGRectMake(0,44, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame) - 44 - 180);
            }
        }
        if( _cutMmodeType == kCropTypeFixed )
        {
//            rect.origin.x =  rect.origin.x+5;
//            rect.origin.y =  rect.origin.y+45;
//            rect.size.width =  rect.size.width-10;
//            rect.size.height =  rect.size.height-90;
            if( [VEConfigManager sharedManager].isPictureEditing )
            {
                rect = CGRectMake(0,kPlayerViewOriginX, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame) - kPlayerViewOriginX - 100 - kToolbarHeight);
            }
            _videoCropView = [[VEVideoCropView alloc] initWithFrame:rect withVideoCropType:VEVideoCropType_FixedCrop];
            UIImage * image = [self canvasImage];
            _videoCropView.cropView.cropRatio = image.size.width/image.size.height;
        }
        else
            _videoCropView = [[VEVideoCropView alloc] initWithFrame:rect withVideoCropType:VEVideoCropType_Crop];
        _videoCropView.cropView.delegate = self;
    }
    return _videoCropView;
}

-(UIView *)toolView{
    if (_toolView == nil) {
        if (_isNeedExport) {
            _toolView = [[UIView alloc] initWithFrame:CGRectMake(0,([VEConfigManager sharedManager].iPad_HD ? (CGRectGetHeight(self.bgView.frame) - 85) : (CGRectGetHeight(self.bgView.frame) - kBottomSafeHeight - 240)), CGRectGetWidth(self.bgView.frame), 240)];
        }else {
            _toolView = [[UIView alloc] initWithFrame:CGRectMake(0,([VEConfigManager sharedManager].iPad_HD ? (CGRectGetHeight(self.bgView.frame) - 85) : (CGRectGetHeight(self.bgView.frame) - kToolbarHeight - 240)), CGRectGetWidth(self.bgView.frame), 240)];
        }
        
        _toolView.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : UIColorFromRGB(0x10100F);
        if( [VEConfigManager sharedManager].isPictureEditing )
        {
            _toolView.backgroundColor = [UIColor whiteColor];
        }
    }
    return _toolView;
}

/**播放暂停按键
 */
- (UIButton *)playButton{
    if(_playButton == nil){
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.backgroundColor = [UIColor clearColor];
        if( _cutMmodeType == kCropTypeNone ) {
            _playButton.frame = CGRectMake(10, 16, 28, 28);
            [_playButton setImage:[VEHelp imageWithContentOfFile:@"jianji/bianji/jianji_video_play"] forState:UIControlStateNormal];
            [_playButton setImage:[VEHelp imageWithContentOfFile:@"jianji/bianji/jianji_video_stop"] forState:UIControlStateSelected];
        }else {
            _playButton.frame = CGRectMake((CGRectGetWidth(self.bgView.frame) - 56)/2.0, (iPhone_X ? 44 : 0) + (_videoCropView.frame.size.height - 56)/2.0, 56, 56);
            [_playButton setImage:[VEHelp imageWithContentOfFile:@"/剪辑_播放_@3x"] forState:UIControlStateNormal];
            [_playButton setImage:[VEHelp imageWithContentOfFile:@"/剪辑_暂停_@3x"] forState:UIControlStateSelected];
        }
        [_playButton addTarget:self action:@selector(playButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

-(UILabel *)playTimeLabel{
    if (_playTimeLabel == nil) {
        _playTimeLabel = [[UILabel alloc] init];
        _playTimeLabel.frame = CGRectMake(50, 16 + ((28 -17)/2), 60, 17);
        _playTimeLabel.font = [UIFont systemFontOfSize:12];
        _playTimeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        _playTimeLabel.textColor = Color(255,255,255,0.64);
        _playTimeLabel.textAlignment = NSTextAlignmentLeft;
        _playTimeLabel.text = @"00:00.0";
        _playTimeLabel.layer.cornerRadius = 4;
        _playTimeLabel.layer.masksToBounds = YES;
    }
    return _playTimeLabel;
}

-(UILabel *)endTimeLabel{
    if (_endTimeLabel == nil) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.frame = CGRectMake(CGRectGetWidth(self.bgView.frame) - 60, 16 + ((28 -17)/2), 60, 17);
        _endTimeLabel.font = [UIFont systemFontOfSize:12];
        _endTimeLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        _endTimeLabel.textColor = Color(255,255,255,0.64);
        _endTimeLabel.textAlignment = NSTextAlignmentLeft;
        _endTimeLabel.text = @"00:00.0";
        _endTimeLabel.layer.cornerRadius = 4;
        _endTimeLabel.layer.masksToBounds = YES;
    }
    return _endTimeLabel;
}

-(VEPlaySlider *)playSlider{
    if (_playSlider == nil) {
        _playSlider = [[VEPlaySlider alloc] initWithFrame:CGRectMake(120, 16 + ((28 -16)/2), CGRectGetWidth(self.bgView.frame) - 120 -70, 16)];
        _playSlider.delegate = self;
    }
    return _playSlider;
}

-(UIButton *)backButton{
    if (_backButton == nil) {
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, (self.cropType == VE_VECROPTYPE_FIXEDRATIO ? ((self.toolView.frame.size.height - 70 - 30)/2.0 + 70) : 70), 80, 30)];
        [_backButton setTitle:VELocalizedString(@"重置", nil) forState:UIControlStateNormal];
        [_backButton setImage:[VEHelp imageNamed:@"剪辑_重置默认_"] forState:UIControlStateNormal];
        [_backButton setImage:[VEHelp imageNamed:@"剪辑_重置选中_"] forState:UIControlStateHighlighted];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _backButton.layer.cornerRadius = 30/2;
        _backButton.layer.masksToBounds = YES;
        [_backButton setTitleColor:UIColorFromRGB(0x808080) forState:UIControlStateNormal];
        [_backButton setBackgroundColor:UIColorFromRGB(0x27262C)];
        _backButton.userInteractionEnabled = NO;
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backButton;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(86, 63,1, 2)];
        [_lineView setBackgroundColor:UIColorFromRGB(0x27262C)];
        
        
    }
    return _lineView;
}

-(UIButton *)vertButton{
    if (_vertButton == nil) {

        float widthButton = (CGRectGetWidth(self.bgView.frame) -  99 - (10*3))/3;
        
        _vertButton = [[UIButton alloc] initWithFrame:CGRectMake(99, (self.cropType == VE_VECROPTYPE_FIXEDRATIO ? ((self.toolView.frame.size.height - 70 - 30)/2.0 + 70) : 70), widthButton, 30)];
        [_vertButton setTitle:VELocalizedString(@"垂直翻转", nil) forState:UIControlStateNormal];
        [_vertButton setImage:[VEHelp imageWithContentOfFile:@"jianji/bianji/jianji_vert"] forState:UIControlStateNormal];
        _vertButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _vertButton.layer.cornerRadius = 30/2;
        _vertButton.layer.masksToBounds = YES;
        [_vertButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
        [_vertButton setBackgroundColor:UIColorFromRGB(0x27262C)];
        
        [_vertButton addTarget:self action:@selector(vertButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _vertButton;
}
-(UIButton *)horizontalButton{
    if (_horizontalButton == nil) {
        
        float widthButton = (CGRectGetWidth(self.bgView.frame) -  99 - (10*3))/3;
        
        _horizontalButton = [[UIButton alloc]initWithFrame:CGRectMake(99 + widthButton +10, (self.cropType == VE_VECROPTYPE_FIXEDRATIO ? ((self.toolView.frame.size.height - 70 - 30)/2.0 + 70) : 70), widthButton, 30)];
        [_horizontalButton setTitle:VELocalizedString(@"水平翻转", nil) forState:UIControlStateNormal];
        [_horizontalButton setImage:[VEHelp imageWithContentOfFile:@"jianji/bianji/jianji_horizontal"] forState:UIControlStateNormal];
        _horizontalButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _horizontalButton.layer.cornerRadius = 30/2;
        _horizontalButton.layer.masksToBounds = YES;
        [_horizontalButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
        [_horizontalButton setBackgroundColor:UIColorFromRGB(0x27262C)];
        
        [_horizontalButton addTarget:self action:@selector(horizontalButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _horizontalButton;
}

-(UIButton *)whirlButton{
    if (_whirlButton == nil) {
        float widthButton = (CGRectGetWidth(self.bgView.frame) -  99 - (10*3))/3;
        _whirlButton = [[UIButton alloc]initWithFrame:CGRectMake(99 + (widthButton +10)*2, (self.cropType == VE_VECROPTYPE_FIXEDRATIO ? ((self.toolView.frame.size.height - 70 - 30)/2.0 + 70) : 70), widthButton, 30)];
        [_whirlButton setTitle:VELocalizedString(@"旋     转", nil) forState:UIControlStateNormal];
        [_whirlButton setImage:[VEHelp imageWithContentOfFile:@"jianji/bianji/jianji_whirl_icon"] forState:UIControlStateNormal];
        _whirlButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _whirlButton.layer.cornerRadius = 30/2;
        _whirlButton.layer.masksToBounds = YES;
        [_whirlButton setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateNormal];
        [_whirlButton setBackgroundColor:UIColorFromRGB(0x27262C)];
        [_whirlButton addTarget:self action:@selector(whirlButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _whirlButton;
}


-(VECropTypeView *)cropTypeView{
    if (_cropTypeView == nil) {
        if( _cutMmodeType == kCropTypeFixed )
        {
            if( _photoView )
                if( _cutMmodeType == kCropTypeFixed ) {
                    _cropTypeView = [[VECropTypeView alloc] initWithFrame:CGRectMake(16, _photoView.frame.size.height - 65, CGRectGetWidth(self.bgView.frame) - 16, 65)];
                }else {
                    _cropTypeView = [[VECropTypeView alloc] initWithFrame:CGRectMake(16, _videoView.frame.size.height - 65, CGRectGetWidth(self.bgView.frame) - 16, 65)];
                }
        }
        else{
            _cropTypeView = [[VECropTypeView alloc] initWithFrame:CGRectMake(16, 130, CGRectGetWidth(self.bgView.frame) - 16, 90)];
        }
        if( [VEConfigManager sharedManager].isPictureEditing )
        {
            _cropTypeView.backgroundColor = UIColorFromRGB(0x111111);//[UIColor whiteColor];
            _cropTypeView.frame = CGRectMake(0, _photoView.frame.size.height - 100, CGRectGetWidth(self.bgView.frame), 100);
        }
        _cropTypeView.delegate = self;
    }
    return _cropTypeView;
}

- (VEExportProgressView *)exportProgressView{
    if(!_exportProgressView){
        _exportProgressView = [[VEExportProgressView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame))];
        _exportProgressView.canTouchUpCancel = YES;
        [_exportProgressView setProgressTitle:VELocalizedString(@"视频导出中，请耐心等待...", nil)];
        [_exportProgressView setProgress:0 animated:NO];
        [_exportProgressView setTrackbackTintColor:UIColorFromRGB(0x545454)];
        [_exportProgressView setTrackprogressTintColor:[UIColor whiteColor]];
        __weak typeof(self) weakself = self;
        _exportProgressView.cancelExportBlock = ^(){
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:VELocalizedString(@"视频尚未导出完成，确定取消导出？",nil)
                                                                    message:nil
                                                                   delegate:weakself
                                                          cancelButtonTitle:VELocalizedString(@"取消",nil)
                                                          otherButtonTitles:VELocalizedString(@"确定",nil), nil];
                alertView.tag = 2;
                [alertView show];
                
            });
        };
    }
    return _exportProgressView;
}

-(void)dealloc{
    NSLog(@"释放");
    [self deletePlayer];
    
}

#pragma mark- 图片
-(void)initphotoView
{
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.bgView.frame) - kBottomSafeHeight - 180, CGRectGetWidth(self.bgView.frame), 180)];
        if( !_isNeedExport )
        {
            view.frame = CGRectMake(0,CGRectGetHeight(self.bgView.frame) - kToolbarHeight - 180, CGRectGetWidth(self.bgView.frame), 180);
        }
        view.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : UIColorFromRGB(0x10100F);
        [self.bgView addSubview:view];
        if( [VEConfigManager sharedManager].isPictureEditing )
        {
            view.backgroundColor = UIColorFromRGB(0x111111);//[UIColor whiteColor];
        }
        _photoView = view;
        if( [VEConfigManager sharedManager].isPictureEditing )
        {
            view.backgroundColor = UIColorFromRGB(0x111111);//[UIColor whiteColor];
        }
        if( _isCropTypeViewHidden )
        {
            view.frame = CGRectMake(0,CGRectGetHeight(self.bgView.frame) - kToolbarHeight, CGRectGetWidth(self.bgView.frame), 0);
        }
        else
        {
            view.frame = CGRectMake(0,CGRectGetHeight(self.bgView.frame) - kToolbarHeight - 65, CGRectGetWidth(self.bgView.frame), 65);
        }
    }
    
    [_photoView addSubview:self.cropTypeView];
    if( _isCropTypeViewHidden )
    {
        self.cropTypeView.hidden = YES;
    }
}

#pragma mark- 视频
-(void)initvideoView
{
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetHeight(self.bgView.frame) - ([VEConfigManager sharedManager].iPad_HD ? 0 : kBottomSafeHeight) - 180, CGRectGetWidth(self.bgView.frame), 180)];
        if( !_isNeedExport )
        {
            view.frame = CGRectMake(0,CGRectGetHeight(self.bgView.frame) - ([VEConfigManager sharedManager].iPad_HD ? 0 : kToolbarHeight) - 180, CGRectGetWidth(self.bgView.frame), 180);
        }
        if( _isCropTypeViewHidden )
        {
            view.frame = CGRectMake(0,CGRectGetHeight(self.bgView.frame) - ([VEConfigManager sharedManager].iPad_HD ? 0 : kToolbarHeight) - 85, CGRectGetWidth(self.bgView.frame), 85);
        }
        view.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : UIColorFromRGB(0x10100F);
        [self.bgView addSubview:view];
        _videoView = view;
    }
    [_videoView addSubview:self.cropTypeView];
    if( _isCropTypeViewHidden )
    {
        self.cropTypeView.hidden = YES;
    }
}

-(void)initTrimSlider
{
    CMTimeRange timeRange = kCMTimeRangeZero;
    if (_selectFile.isGif) {
        timeRange = _selectFile.imageTimeRange;
    }
    else if(_selectFile.isReverse){
        timeRange = _selectFile.reverseVideoTrimTimeRange;
    }else{
        timeRange = _selectFile.videoTrimTimeRange;
    }
    VETrimSlider * trimSlider = [[VETrimSlider alloc] initWithFrame:CGRectMake(0, (_videoView.bounds.size.height - 65 - 50)/2.0, _videoView.bounds.size.width, 50) videoCore:_videoCoreSDK trimDuration_OneSpecifyTime: CMTimeGetSeconds(timeRange.duration)];
    _trimDuration_OneSpecifyTime = CMTimeGetSeconds(timeRange.duration);
    [_videoView addSubview:trimSlider];
    _videoTrimiSlider = trimSlider;
    _videoTrimiSlider.delegate = self;
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, trimSlider.frame.size.width/6.0, trimSlider.frame.size.height)];
        label.alpha = 0.3;
        label.backgroundColor = [UIColor blackColor];
        [trimSlider addSubview:label];
    }
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(trimSlider.frame.size.width - trimSlider.frame.size.width/6.0, 0, trimSlider.frame.size.width/6.0, trimSlider.frame.size.height)];
        label.alpha = 0.3;
        label.backgroundColor = [UIColor blackColor];
        [trimSlider addSubview:label];
    }
    
    if( _isCropTypeViewHidden )
    {
        trimSlider.frame = CGRectMake(0, 30, _videoView.bounds.size.width, 50);
    }
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, _videoView.bounds.size.width, 20)];
    label.text = [NSString stringWithFormat:@"%.1fs", CMTimeGetSeconds(timeRange.duration)];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment =NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [_videoView addSubview:label];
}

- (void)loadTrimmerViewThumbImage {
    @autoreleasepool {
        CMTimeRange timeRange = kCMTimeRangeZero;
        if (_selectFile.isGif) {
            timeRange = _selectFile.imageTimeRange;
        }
        else if(_selectFile.isReverse){
            timeRange = _selectFile.reverseVideoTrimTimeRange;
        }else{
            timeRange = _selectFile.videoTrimTimeRange;
        }
        
        [thumbTimes removeAllObjects];
        thumbTimes = nil;
        thumbTimes=[[NSMutableArray alloc] init];
        Float64 duration;
        Float64 start;
        duration = _videoCoreSDK.duration;
        start = (duration > (CMTimeGetSeconds(timeRange.duration)/2.0) ? 0.2 : (duration-0.05));
        [thumbTimes addObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(start,TIMESCALE)]];
//        float actualFramesNeeded = duration/(CMTimeGetSeconds(timeRange.duration)/2.0);
        float actualFramesNeeded = duration/(CMTimeGetSeconds(timeRange.duration)/4.0);
        Float64 durationPerFrame = duration / (actualFramesNeeded*1.0);
        /*截图为什么用两个for循环：第一个for循环是分配内存，第二个for循环显示图片，截图快一些*/
        for (int i=1; i<actualFramesNeeded; i++){
            CMTime time = CMTimeMakeWithSeconds( (int)(start + i*durationPerFrame),TIMESCALE);
            [thumbTimes addObject:[NSValue valueWithCMTime:time]];
        }
            
        [_videoTrimiSlider loadTrimmerViewThumbImage:nil
                                thumbnailCount:thumbTimes.count];
        
        
        [_videoTrimiSlider interceptProgress:CMTimeGetSeconds( timeRange.start )];
        
        [self refreshTrimmerViewImage];
    }
}
- (void)refreshTrimmerViewImage {
    @autoreleasepool {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Float64 durationPerFrame = self.videoCoreSDK.duration / (self->thumbTimes.count*1.0);
            for (int i=0; i<self->thumbTimes.count; i++){
                CMTime time = CMTimeMakeWithSeconds(i*durationPerFrame + 0.2,TIMESCALE);
                [self->thumbTimes replaceObjectAtIndex:i withObject:[NSValue valueWithCMTime:time]];
            }
            
            [self->thumbTimes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                int number = ceilf( CMTimeGetSeconds([ ((NSValue*)obj) CMTimeValue]) );
                if (_cutMmodeType != kCropTypeFixed) {
                    number *= self.selectFile.speed;
                }
                
                if( (_videoCoreSDK.duration*1) <  number )
                {
                    number = (_videoCoreSDK.duration*1);
                }
                
                NSString * strPatch = [self.selectFile.filtImagePatch stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",number]];
                
                __block UIImage * image = nil;
                image = [[UIImage alloc] initWithContentsOfFile:strPatch];
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    [self.videoTrimiSlider.TrimmerView refreshThumbImage:idx thumbImage:image];
                    
                });
            }];
        });
    }
}

#pragma mark- VETrimSliderDelegate
-(void)trimmerViewProgress:(CGFloat)startTime;
{
    _playTimeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(startTime, TIMESCALE), _playTimeRange.duration);
    [_videoCoreSDK seekToTime:_playTimeRange.start toleranceTime:kCMTimeZero completionHandler:nil];
    if([_videoCoreSDK isPlaying])
        [self playVideo:NO];
}

-(void)svae_PaterText
{
    float scale = [self.pasterTextView getFramescale];
    CGRect rect = CGRectMake(0, 0, 1, 1);
    double rotate = 0;
    [self pasterView_Rect:&rect atRotate:&rotate];
    
    CGRect rectInFile = CGRectMake(self.pasterTextView.frame.origin.x/self.pasterTextView.frame.size.width, self.pasterTextView.frame.origin.y/self.pasterTextView.frame.size.height, self.pasterTextView.frame.size.width/self.pasterTextView.frame.size.width, self.pasterTextView.frame.size.height/self.pasterTextView.frame.size.height);
    
    if (self.syncContainerView.bounds.size.width == self.syncContainerView.bounds.size.height) {
        _selectFile.rectInScale  = scale*0.25;
    }else if (self.syncContainerView.bounds.size.width < self.syncContainerView.bounds.size.height) {
        _selectFile.rectInScale  = scale*0.5;
    }else {
        _selectFile.rectInScale  =  scale*0.5;
    }
    
    _selectFile.rectInFile = rectInFile;
//    self.fileList[[self.timeLine getCurrentFileIndex]].rectInScene = rect;
    _selectFile.rotate = rotate;
    _selectFile.fileScale = scale;
//    self.fileList[[self.timeLine getCurrentFileIndex]].backgroundType = self.CurrentCanvasType;
    
    Scene * scene = (Scene *)[self.videoCoreSDK getScenes][0];
    [scene.media enumerateObjectsUsingBlock:^(MediaAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.rotate = rotate;
        obj.rectInVideo = rect;
    }];
}

-(CGRect)getFileCrop
{
    CGSize cropSize = CGSizeZero;
    CGSize imageSize = CGSizeMake(_selectFile.thumbImage.size.width, _selectFile.thumbImage.size.height);
    
    if (_syncContainerRect.size.width == _syncContainerRect.size.height) {
        cropSize.width = _syncContainerRect.size.width/4.0;
        cropSize.height = cropSize.width / (imageSize.width / imageSize.height);
    }else if (_syncContainerRect.size.width < _syncContainerRect.size.height) {
        cropSize.width = _syncContainerRect.size.width/2.0;
        cropSize.height = cropSize.width / (imageSize.width / imageSize.height);
    }else {
        cropSize.height = _syncContainerRect.size.height/2.0;
        cropSize.width = cropSize.height * (imageSize.width / imageSize.height);
    }
    
    CGSize size = CGSizeMake(cropSize.width*_selectFile.crop.size.width, cropSize.height*_selectFile.crop.size.height);
    CGPoint point = CGPointMake(_selectFile.crop.origin.x*cropSize.width, _selectFile.crop.origin.y*cropSize.height);
    
    point.x = point.x + size.width/2.0;
    point.y = point.y + size.height/2.0;
    CGRect rect = CGRectZero;
    CGSize videoSize = CGSizeMake(_syncContainerRect.size.width - 40, _syncContainerRect.size.height - 90);
    
    if( [VEConfigManager sharedManager].isPictureEditing )
    {
        videoSize = CGSizeMake(_syncContainerRect.size.width, _syncContainerRect.size.height);
    }
    
    float proportion = size.width/size.height;
    float width = proportion*videoSize.height;
    
    if( width <= videoSize.width  )
    {
        float scale = width/size.width;
        rect.size.width = _selectFile.crop.size.width * cropSize.width * scale;
        rect.size.height = _selectFile.crop.size.height * cropSize.height * scale;
        rect.origin.x = (0.5-(_selectFile.crop.origin.x+_selectFile.crop.size.width/2.0)) * cropSize.width * scale;
        rect.origin.y = (0.5-(_selectFile.crop.origin.y+_selectFile.crop.size.height/2.0)) * cropSize.height * scale;
        _pasterTextViewScale = scale;
    }
    else{
        float scale = videoSize.width/size.width;
        rect.size.width = _selectFile.crop.size.width * cropSize.width * scale;
        rect.size.height = _selectFile.crop.size.height * cropSize.height * scale;
        rect.origin.x = (0.5-(_selectFile.crop.origin.x+_selectFile.crop.size.width/2.0)) * cropSize.width * scale;
        rect.origin.y = (0.5-(_selectFile.crop.origin.y+_selectFile.crop.size.height/2.0)) * cropSize.height * scale;
        _pasterTextViewScale = scale;
    }
    size = CGSizeMake(cropSize.width*_fixedMaxCrop.size.width, cropSize.height*_fixedMaxCrop.size.height);
    float originalProportion = size.width/size.height;
    width = originalProportion*videoSize.height;
    float minScale;
    if( width <= videoSize.width  )
    {
        minScale = width/size.width;
    }else {
        minScale = videoSize.width/size.width;
    }
    [self.pasterTextView setMinScale:minScale];
    
    return rect;
}

#pragma mark - 画布图片获取
-(UIImage *)canvasImage
{
    UIImage *  image = nil;
    if(self.selectFile.fileType == kFILEVIDEO){
    
        if( self.selectFile.thumbImage == nil )
        {
            float duration = CMTimeGetSeconds(self.selectFile.videoActualTimeRange.duration);
            if( duration < 0.1 )
            {
                duration = duration/2.0;
            }
            else
                duration = 0.1;
            
            image = [VEHelp geScreenShotImageFromVideoURL:self.selectFile.contentURL atTime:CMTimeMakeWithSeconds(duration, TIMESCALE)  atSearchDirection:false];
            self.selectFile.thumbImage = image;
        }
        else
            image = self.selectFile.thumbImage;
    }else
    {
        if( self.selectFile.thumbImage == nil )
        {
            image = [VEHelp getFullScreenImageWithUrl:self.selectFile.contentURL];
            self.selectFile.thumbImage = image;
        }
        else
            image = _selectFile.thumbImage;
    }
    
    return image;
}

#pragma mark - 7.Notification

#pragma mark - 8.Event Response

#pragma mark- 设置画布显示参数
- (void)initPasterViewWithFile:(UIImage *)thumbImage {
    VEMediaInfo * file = _selectFile;
    
    [self.pasterTextView removeFromSuperview];
    self.pasterTextView = nil;
    if (!self.pasterTextView) {
        CGSize size = thumbImage.size;
        float width;
        float height;
        if (self.syncContainerView.bounds.size.width == self.syncContainerView.bounds.size.height) {
            width = self.syncContainerView.bounds.size.width/4.0;
            height = width / (size.width / size.height);
        }else if (self.syncContainerView.bounds.size.width < self.syncContainerView.bounds.size.height) {
            width = self.syncContainerView.bounds.size.width/2.0;
            height = width / (size.width / size.height);
        }else {
            height = self.syncContainerView.bounds.size.height/2.0;
            width = height * (size.width / size.height);
        }
        CGRect frame = CGRectMake((self.syncContainerView.bounds.size.width - width)/2.0, (self.syncContainerView.bounds.size.height - height)/2.0, width, height);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        imageView.image = thumbImage;
        
       VEPasterTextView * PasterTextView  = [[VEPasterTextView alloc] initWithFrame:CGRectInset(frame, -8, -8)
                                                                     superViewFrame:self.videoCropView.videoView.frame
                                                                       contentImage:imageView
                                                                  syncContainerRect:self.videoCropView.videoView.bounds];
        [PasterTextView remove_Recognizer];
        PasterTextView.isFixedCrop = true;
        [self.syncContainerView setMark];
//        [PasterTextView setRotationGestureRecognizer];
        [[PasterTextView getRotateView] removeFromSuperview];
        [PasterTextView.mirrorBtn removeFromSuperview];
        PasterTextView.mirrorBtn = nil;
        self.pasterTextView = PasterTextView;
//        self.pasterTextView.mirrorBtn.hidden = NO;
        [self.pasterTextView.mirrorBtn removeFromSuperview];
        [self.pasterTextView.closeBtn removeFromSuperview];
        self.pasterTextView.delegate = self;
        [self.syncContainerView addSubview:self.pasterTextView];
        [self.pasterTextView setSyncContainer:self.syncContainerView];
        self.pasterTextView.syncContainer = self.syncContainerView;
        self.syncContainerView.currentPasterTextView = self.pasterTextView;
        
    }else {
        self.pasterTextView.contentImage.image = thumbImage;
        
        CGSize size = thumbImage.size;
        float width;
        float height;
        if (self.syncContainerView.bounds.size.width == self.syncContainerView.bounds.size.height) {
            width = self.syncContainerView.bounds.size.width/4.0;
            height = width / (size.width / size.height);
        }else if (self.syncContainerView.bounds.size.width <= self.syncContainerView.bounds.size.height) {
            width = self.syncContainerView.bounds.size.width/2.0;
            height = width / (size.width / size.height);
        }else {
            height = self.syncContainerView.bounds.size.height/2.0;
            width = height * (size.width / size.height);
        }
        CGRect frame = CGRectMake((self.syncContainerView.bounds.size.width - width)/2.0, (self.syncContainerView.bounds.size.height - height)/2.0, width, height);
        CGRect rect = CGRectInset(frame, -8, -8);
        [self.pasterTextView refreshBounds:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    }
    
    [self.pasterTextView getselectImageView].layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    
    float fileScale = file.fileScale;
    CGRect rectInScene = CGRectMake(0, 0, 1, 1);
//    self.isCanvasFirst = false;
    
    double rotate = 0;//file.rotate;
    if( (fileScale == 0) && ( (rectInScene.origin.x == 0) && (rectInScene.origin.y == 0)
                             && (rectInScene.size.width == 1)
                             && (rectInScene.size.height == 1)))
    {
        
        fileScale = 2.0;
        CGSize size = CGSizeMake(rectInScene.size.width * self.syncContainerView.bounds.size.width, rectInScene.size.height* self.syncContainerView.bounds.size.height);
        
        if (self.syncContainerView.bounds.size.width == self.syncContainerView.bounds.size.height) {
            fileScale = 4.0;
            
            float width = self.syncContainerView.bounds.size.width/4.0;
            float height = width / (size.width / size.height);
            
            float imageScale = size.width/size.height;
            float imageHeight = self.syncContainerView.bounds.size.width/imageScale;
            float imageWidth = self.syncContainerView.bounds.size.height*imageScale;
            
            if( imageHeight < self.syncContainerView.bounds.size.height )
            {
                fileScale = self.syncContainerView.bounds.size.width/width;
            }
            else if( imageWidth < self.syncContainerView.bounds.size.width )
            {
                fileScale = self.syncContainerView.bounds.size.height/height;
            }
            
        }
        else if (self.syncContainerView.bounds.size.width < self.syncContainerView.bounds.size.height) {
            
            float width = self.syncContainerView.bounds.size.width/2.0;
            float height = width / (size.width / size.height);
            float imageScale = size.width/size.height;
            float imageHeight = self.syncContainerView.bounds.size.width/imageScale;
            float imageWidth = self.syncContainerView.bounds.size.height*imageScale;
            
            if( ( ( (file.rotate < 90.02) && (file.rotate > 89.98) ) || ( (file.rotate < 270.02) && (file.rotate > 269.98) ) ) && ( imageScale != 1 ) )
            {
                if( imageWidth < self.syncContainerView.bounds.size.width )
                {
                    fileScale = self.syncContainerView.bounds.size.width/height;
                }
                else if( imageHeight < self.syncContainerView.bounds.size.height )
                {
                    fileScale = self.syncContainerView.bounds.size.height/width;
                }
            }
            else
            {
                if( imageWidth < self.syncContainerView.bounds.size.width )
                {
                    fileScale = self.syncContainerView.bounds.size.height/height;
                }
                else if( imageHeight < self.syncContainerView.bounds.size.height )
                {
                    fileScale = self.syncContainerView.bounds.size.width/width;
                }
            }
        }
        else
        {
            float height = self.syncContainerView.bounds.size.height/2.0;
            float width = height * (size.width / size.height);
            
            float imageScale = size.width/size.height;
            float imageHeight = self.syncContainerView.bounds.size.width/imageScale;
            float imageWidth = self.syncContainerView.bounds.size.height*imageScale;
            
            if( ( ( (file.rotate < 90.02) && (file.rotate > 89.98) ) || ( (file.rotate < 270.02) && (file.rotate > 269.98) ) ) && ( imageScale != 1 ) )
            {
                if( imageWidth < self.syncContainerView.bounds.size.width )
                {
                    fileScale = self.syncContainerView.bounds.size.width/height;
                }
                else if( imageHeight < self.syncContainerView.bounds.size.height )
                {
                    fileScale = self.syncContainerView.bounds.size.height/width;
                }
            }
            else
            {
                if( imageHeight < self.syncContainerView.bounds.size.height )
                {
                    fileScale = self.syncContainerView.bounds.size.width/width;
                }
                else if( imageWidth < self.syncContainerView.bounds.size.width )
                {
                    fileScale = self.syncContainerView.bounds.size.height/height;
                }
            }
        }
        
        CGAffineTransform transform2 = CGAffineTransformMakeRotation( - rotate/(180.0/M_PI) );
        
        file.fileScale = fileScale;
        
        self.pasterTextView.transform = CGAffineTransformScale(transform2, fileScale, fileScale);
        if( file.fileScale >0 )
            [self.pasterTextView setFramescale:fileScale];
        else
            [self.pasterTextView setFramescale:2.0];
        [self pasterView_Rect:&rectInScene atRotate:&rotate];
        
        if( self.originalRect.size.width == 0 )
        {
            self.originalRect = rectInScene;
        }
        
        [self svae_PaterText];
        [self.videoCoreSDK refreshCurrentFrame];
    }
//    CGPoint point = CGPointMake(rectInScene.origin.x + rectInScene.size.width/2.0, rectInScene.origin.y + rectInScene.size.height/2.0);
//    point = CGPointMake(point.x*self.syncContainerView.frame.size.width, point.y*self.syncContainerView.frame.size.height);
    
    fileScale = [VEHelp getMediaAssetScale_File:thumbImage.size atRect:rectInScene atCorp:CGRectMake(0, 0, 1, 1) atSyncContainerHeihgt:self.syncContainerView.bounds.size mediaType:VEAdvanceEditType_None];
    file.fileScale = fileScale;
    CGAffineTransform transform2 = CGAffineTransformMakeRotation( -rotate/(180.0/M_PI) );
    self.pasterTextView.transform = CGAffineTransformScale(transform2, fileScale, fileScale);
    [self.pasterTextView setFramescale:file.fileScale];
    
//    self.pasterTextView.center = point;
    [self.syncContainerView setMark];
    [self.pasterTextView setCanvasPasterText:true];
    [self.pasterTextView setMinScale:1.0/4.0];
    self.pasterTextView.contentImage.alpha = 0.0;
    self.pasterTextView.isDrag = true;
    self.syncContainerView.currentPasterTextView = self.pasterTextView;
    self.pasterTextView.syncContainer = self.syncContainerView;
}

-(void)pasterView_Rect:(  CGRect * ) rect atRotate:( double * ) rotate
{
    CGPoint point = CGPointMake(self.pasterTextView.center.x/self.syncContainerView.frame.size.width, self.pasterTextView.center.y/self.syncContainerView.frame.size.height);
    float scale = [self.pasterTextView getFramescale];
    
    float fwidth = self.pasterTextView.contentImage.frame.size.width*scale / self.syncContainerView.bounds.size.width;
    float fheight = self.pasterTextView.contentImage.frame.size.height*scale / self.syncContainerView.bounds.size.height;
    (*rect).size = CGSizeMake(fwidth,fheight);
    (*rect).origin = CGPointMake(point.x - (*rect).size.width/2.0, point.y - (*rect).size.height/2.0);
    
    CGFloat radius = atan2f(self.pasterTextView.transform.b, self.pasterTextView.transform.a);
    (*rotate) = -radius * (180 / M_PI);
    if ((*rotate) < 0) {
        (*rotate) += 360;
    }
}


#pragma mark- pasterTextViewDelegate
- (void)pasterViewMoved:(VEPasterTextView *_Nullable)sticker
{
    if( sticker == self.pasterTextView )
    {
        [self svae_PaterText];
        [sticker showEditingHandles];
        [self.videoCoreSDK refreshCurrentFrame];
    }
}

- (void)pasterViewSizeScale:(VEPasterTextView *_Nullable)sticker atValue:( float ) value
{
    if( sticker == self.pasterTextView )
    {
        [self svae_PaterText];
        [sticker showEditingHandles];
        [self.videoCoreSDK refreshCurrentFrame];
    }
}

@end
