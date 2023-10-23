//
//  VENewClipViewController.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/7/16.
//

#import "VENewClipViewController.h"
#import <VEENUMCONFIGER/VETrimSlider.h>

@interface VENewClipViewController ()<VEPlaySliderDelegate,VECropTypeDelegate,VECoreDelegate, VETrimSliderDelegate,UIScrollViewDelegate>
{
    VEMediaInfo        *oldselectFile;
    CGRect originalvideoCropViewFrame;
    CGSize originalCoreSDKSize;
    BOOL isNeedRefreshPlayer;
    
    CGPoint     _pasterTextCenter;
    CMTimeRange _playTimeRange;
    NSMutableArray  *thumbTimes;
    
    VEMediaInfo     *_originFile;
    CGRect           _videoBgRect;
    UIImage *_sourceImage;
    CGSize   _sourceImageSize;
    float _rotation;
}

@property (nonatomic,assign) float trimDuration_OneSpecifyTime;
@property( nonatomic, assign)CGRect                          originalRect;

@property(nonatomic,strong) UIView                  * toolView;
//============================================================
@property(nonatomic,strong) UIScrollView             * videoBgView;
@property( nonatomic, assign)CGRect                    videoPrewRect;
@property(nonatomic,strong) UIImageView             * videoPrewView;
//============================================================
@property(nonatomic,strong) UIButton                * playButton;
@property(nonatomic,strong) UILabel                 * playTimeLabel;
@property(nonatomic,strong) VEPlaySlider            * playSlider;
@property(nonatomic,strong) UILabel                 * endTimeLabel;

@property(nonatomic,strong) UIButton                * resetBtn;

@property(nonatomic,strong)VECropTypeView            * cropTypeView;
@property(nonatomic,strong) NSMutableArray           * dataCropTypeArray;
@property(nonatomic,strong)UIScrollView *rotateTypeView;
@property(nonatomic,strong) UIButton                * typeCropBtn;
@property(nonatomic,strong) UIButton                * typeRotateBtn;

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

@implementation VENewClipViewController

- (BOOL)prefersStatusBarHidden {
    return  YES;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - 1.Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    if(_zoomScale == 0){
        _zoomScale = 1;
    }
    
    if( [VEConfigManager sharedManager].isPictureEditing )
    {
        _selectFile.rectInFile = _selectFile.rectInScene;
    }
    self.view.backgroundColor = ([VEConfigManager sharedManager].iPad_HD ? SCREEN_IPAD_BACKGROUND_COLOR : SCREEN_BACKGROUND_COLOR);
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
        _bgView.backgroundColor = VIEW_IPAD_COLOR;//[UIColor colorWithWhite:0.7 alpha:1.0];
    }else{
        _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    _videoBgRect = CGRectMake(0, (iPhone_X ? 44 : 0), _bgView.frame.size.width, _bgView.frame.size.height - 180 - (iPhone_X ? 44 : 0) - 40 - kBottomSafeHeight - (_selectFile.fileType != kFILEIMAGE ? 80 : 0));
    if(_isCropTypeViewHidden){
        _videoBgRect = CGRectMake(0, (iPhone_X ? 44 : 0), _bgView.frame.size.width, _bgView.frame.size.height - 100 - (iPhone_X ? 44 : 0) - 40 - kBottomSafeHeight - (_selectFile.fileType != kFILEIMAGE ? 80 : 0));
    }
    if([VEConfigManager sharedManager].iPad_HD){
        _videoBgRect = CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height - 40 - kBottomSafeHeight - (_selectFile.fileType != kFILEIMAGE ? 80 : 0));
    }
    [self.view addSubview:_bgView];
    if (CGRectEqualToRect(_fixedMaxCrop, CGRectZero)) {
        _fixedMaxCrop = CGRectMake(0, 0, 1, 1);
    }
    _sourceImage = [VEHelp getFullImageWithUrl:_selectFile.contentURL];
    CGSize imageSize = _sourceImage.size;
    if(_sourceImage.size.width > _sourceImage.size.height){
        imageSize.width = 1080;
        imageSize.height = 1080 * (_sourceImage.size.height/_sourceImage.size.width);
    }else{
        imageSize.height = 1920;
        imageSize.width = 1920 * (_sourceImage.size.width/_sourceImage.size.height);
    }
    _sourceImage = [VEHelp rescaleImage:_sourceImage size:imageSize];
    _sourceImageSize = imageSize;
    _editVideoSize = imageSize;
    
    {
        float x = _fixedMaxCrop.origin.x;
        float y = _fixedMaxCrop.origin.y;
        float w = _fixedMaxCrop.size.width;
        float h = _fixedMaxCrop.size.height;
        if((_selectFile.rotate > 45 && _selectFile.rotate < 90 + 45)){
            x = _fixedMaxCrop.origin.y;
            y = (1 - (_fixedMaxCrop.origin.x + _fixedMaxCrop.size.width));
            w = _fixedMaxCrop.size.height;
            h = _fixedMaxCrop.size.width;
            if(self.cropType != VE_VECROPTYPE_ORIGINAL && self.cropType != VE_VECROPTYPE_FREE)
            _sourceImageSize = CGSizeMake(imageSize.height, imageSize.width);
        }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
            x = (1 - (_fixedMaxCrop.origin.x + _fixedMaxCrop.size.width));
            y = (1 - (_fixedMaxCrop.origin.y + _fixedMaxCrop.size.height));
            
        }else  if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
            x = (1 - (_fixedMaxCrop.origin.y + _fixedMaxCrop.size.height));
            y = _fixedMaxCrop.origin.x;
            w = _fixedMaxCrop.size.height;
            h = _fixedMaxCrop.size.width;
            if(self.cropType != VE_VECROPTYPE_ORIGINAL && self.cropType != VE_VECROPTYPE_FREE)
            _sourceImageSize = CGSizeMake(imageSize.height, imageSize.width);
        }
        _fixedMaxCrop = CGRectMake(x, y, w, h);
    }
    [self initConfiguration];
    [self setupNavBar];
    [self setupViews];
    [self setupData];
    
    
    //============================================================
    [self refreshPrewFrame];
    _videoBgView.hidden = NO;
    [_videoBgView setContentSize:_videoPrewRect.size];
    {
//        float v_w = _videoBgView.frame.size.width;
//        if(self.cropType ==VE_VECROPTYPE_FIXEDRATIO){
//            if((_selectFile.rotate > 45 && _selectFile.rotate < 90 + 45) || (_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45)){
//                v_w = v_w/_fixedMaxCrop.size.height;
//            }else{
//                v_w = v_w/_fixedMaxCrop.size.width;
//            }
//        }
//        UIImage *image = [VEHelp image:_sourceImage rotation:_selectFile.rotate cropRect:CGRectMake(0, 0, 1, 1)];
//        imageSize = image.size;
//        
//        float v_h = v_w * (image.size.height/image.size.width);
//        float previewAsp = image.size.width/image.size.height;
//        if(previewAsp > _videoBgView.frame.size.width /_videoBgView.frame.size.height){
//            v_h = _videoBgView.frame.size.height;
//            if(self.cropType ==VE_VECROPTYPE_FIXEDRATIO){
//                if((_selectFile.rotate > 45 && _selectFile.rotate < 90 + 45) || (_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45)){
//                    v_h = v_h/_fixedMaxCrop.size.width;
//                }else{
//                    v_h = v_h/_fixedMaxCrop.size.height;
//                }
//            }
//            v_w = v_h * (image.size.width/image.size.height);
//        }
//        
//        [_videoBgView setMinimumZoomScale:MAX(_videoBgView.frame.size.width/v_w,_videoBgView.frame.size.height/v_h)];
        if(!CGRectEqualToRect(_selectFile.cropRect, CGRectZero)){
            float scale = 1;
            
            float x = _selectFile.cropRect.origin.x;
            float y = _selectFile.cropRect.origin.y;
            float contentsize_width = (1 - CGRectGetMaxX(_selectFile.crop)) * (_selectFile.cropRect.size.width / _selectFile.crop.size.width) + x + _selectFile.cropRect.size.width;
            scale = contentsize_width/self.videoBgView.contentSize.width;
            if((_selectFile.rotate > 45 && _selectFile.rotate < 90 + 45) || (_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45)){
                contentsize_width = (1 - CGRectGetMaxY(_selectFile.crop)) * (_selectFile.cropRect.size.width / _selectFile.crop.size.height) + x + _selectFile.cropRect.size.width;
                scale = contentsize_width/self.videoBgView.contentSize.width;
            }
            [_videoBgView setZoomScale:scale animated:NO];
            [_videoBgView setContentOffset:CGPointMake(x, y) animated:YES];
        }
    }
    
    
    CMTime endTime = CMTimeMakeWithSeconds(_videoCoreSDK.duration, TIMESCALE);
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@",[VEHelp timeToStringFormat:(CMTimeGetSeconds(endTime))]];
    if( _videoView )
    {
        [self initTrimSlider];
    }
    
    //============================================================
    
    
    
    
    if( _cutMmodeType == kCropTypeFixed )
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_videoBgRect), self.bgView.frame.size.width, 30)];
        if( _isNeedExport )
        {
            label.frame = CGRectMake(0, kNavgationBar_Height, self.bgView.frame.size.width, 30);
        }
        label.text = VELocalizedString(@"拖动或双指缩放调整画面", nil);
        if( [VEConfigManager sharedManager].isPictureEditing )
        {
            label.textColor = UIColorFromRGB(0x727272);
        }
        else {
            label.textColor = UIColorFromRGB(0x727272);
        }
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            label.textColor = UIColorFromRGB(0x727272);
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        [self.bgView addSubview:label];
    }
    if(_flowPicture){
//        _videoView.backgroundColor = SCREEN_BACKGROUND_COLOR;
//        _photoView.backgroundColor = SCREEN_BACKGROUND_COLOR;
//        self.toolView.backgroundColor = SCREEN_BACKGROUND_COLOR;
    }
    if( [VEConfigManager sharedManager].isPictureEditing )
    {
        Scene * scene = (Scene *)[self.videoCoreSDK getScenes][0];
        [scene.media enumerateObjectsUsingBlock:^(MediaAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.rectInVideo = _selectFile.rectInFile;
        }];
        [self.videoCoreSDK refreshCurrentFrame];
        
    }
#ifdef kEnterBackgroundCancelExport
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterHome:) name:UIApplicationDidEnterBackgroundNotification object:nil];
#endif
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    
}
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *view = _videoCoreSDK.view;
    return view;
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
    _originFile = [_selectFile mutableCopy];
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
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [self.backBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
            [self.finishToolBarBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
        }
        self.finishToolBarBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        self.toolBar.hidden = NO;
        self.titlelab.text = @"";
    }else{
        self.titlelab.textColor = TEXT_COLOR;
        self.barline.backgroundColor = UIColorFromRGB(0x1a1a1a);
        self.titlelab.text = VELocalizedString(@"裁切", nil);
        self.titlelab.font = [UIFont boldSystemFontOfSize:14];
//        self.titlelab.backgroundColor = UIColorFromRGB(0x1a1a1a);
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            self.titlelab.textColor = UIColorFromRGB(0x131313);
            self.barline.backgroundColor = UIColorFromRGB(0xefefef);
        }
    }
}


- (void)setupViews {
    [self.bgView addSubview:self.toolView];
//    [self.bgView addSubview:self.videoCropView];
    if( _cutMmodeType == kCropTypeNone )
    {
        [self.toolView addSubview:self.playButton];
        [self.toolView addSubview:self.playTimeLabel];
        [self.toolView addSubview:self.playSlider];
        [self.toolView addSubview:self.endTimeLabel];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(86, 63,1, 2)];
        [lineView setBackgroundColor:UIColorFromRGB(0x27262C)];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [lineView setBackgroundColor:UIColorFromRGB(0xefefef)];
        }
        [_toolView addSubview:lineView];
        
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
            
        }
    }
    if (_cutMmodeType == kCropTypeNone || _isCropTypeViewHidden) {
        float width = (_toolView.frame.size.width - 40) / 4.0;
        float y = (_toolView.frame.size.height - 44) / 2.0;
        if (_cutMmodeType == kCropTypeNone) {
            y = (_cropType == VE_VECROPTYPE_FIXEDRATIO ? ((_toolView.frame.size.height - 70 - 30)/2.0 + 70) : 70);
        }
#if 0
        width = (_toolView.frame.size.width - 40) / 3.0;
        for (int i = 0; i < 3; i++) {
            UIButton *rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rotateBtn.frame = CGRectMake(20 + width * i, y, width, 44);
            NSString * imagePath = nil;
            if (i == 0) {
                imagePath = @"/New_EditVideo/scrollViewChildImage/剪辑_剪辑上下翻转默认_";
                [rotateBtn setTitle:VELocalizedString(@"上下", nil) forState:UIControlStateNormal];
            }else if (i == 1) {
                imagePath = @"/New_EditVideo/scrollViewChildImage/剪辑_剪辑左右翻转默认_";
                [rotateBtn setTitle:VELocalizedString(@"左右", nil) forState:UIControlStateNormal];
            }else {
                imagePath = @"剪辑_重置默认_";
                [rotateBtn setImage:[VEHelp imageWithContentOfFile:@"剪辑_重置选中_"] forState:UIControlStateDisabled];
                [rotateBtn setTitle:VELocalizedString(@"重置", nil) forState:UIControlStateNormal];
                [rotateBtn setTitleColor:UIColorFromRGB(0x3c3d3d) forState:UIControlStateDisabled];
                rotateBtn.enabled = NO;
                _resetBtn = rotateBtn;
            }
            [rotateBtn setImage:[VEHelp imageWithContentOfFile:imagePath] forState:UIControlStateNormal];
            [rotateBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                [rotateBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
            }
            rotateBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [rotateBtn addTarget:self action:@selector(rotateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            rotateBtn.tag = i + 1;
            [_toolView addSubview:rotateBtn];
        }
#else
        for (int i = 0; i < 4; i++) {
            UIButton *rotateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            rotateBtn.frame = CGRectMake(20 + width * i, y, width, 44);
            NSString * imagePath = nil;
            if (i == 0) {
                imagePath = @"/New_EditVideo/scrollViewChildImage/剪辑_剪辑上下翻转默认_";
                [rotateBtn setTitle:VELocalizedString(@"上下", nil) forState:UIControlStateNormal];
            }else if (i == 1) {
                imagePath = @"/New_EditVideo/scrollViewChildImage/剪辑_剪辑左右翻转默认_";
                [rotateBtn setTitle:VELocalizedString(@"左右", nil) forState:UIControlStateNormal];
            }else if (i == 2) {
                imagePath = @"New_EditVideo/scrollViewChildImage/剪辑_剪辑旋转默认_";
                [rotateBtn setTitle:VELocalizedString(@"旋转", nil) forState:UIControlStateNormal];
            }else {
                imagePath = @"剪辑_重置默认_";
                [rotateBtn setImage:[VEHelp imageWithContentOfFile:@"剪辑_重置选中_"] forState:UIControlStateDisabled];
                [rotateBtn setTitle:VELocalizedString(@"重置", nil) forState:UIControlStateNormal];
                [rotateBtn setTitleColor:UIColorFromRGB(0x3c3d3d) forState:UIControlStateDisabled];
                rotateBtn.enabled = NO;
                _resetBtn = rotateBtn;
            }
            [rotateBtn setImage:[VEHelp imageWithContentOfFile:imagePath] forState:UIControlStateNormal];
            [rotateBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                [rotateBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
            }
            rotateBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [rotateBtn addTarget:self action:@selector(rotateBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            rotateBtn.tag = i + 1;
            [_toolView addSubview:rotateBtn];
        }
#endif
    }
}

- (void)setCropType:(VECropType)cropType{
    _cropType = cropType;
}

#pragma mark - 3.Request Data

- (void)setupData {
//    if(self.cropType != VE_VECROPTYPE_FIXEDRATIO)
//    self.cropType = VE_VECROPTYPE_FREE;
    [self reloadDataCropTypeView];
   
    if (_selectFile.isGif) {
        self.seekTime = _selectFile.imageTimeRange.start;
    }
    else if (_selectFile.isReverse) {
        self.seekTime = _selectFile.reverseVideoTrimTimeRange.start;
    }else {
        self.seekTime = _selectFile.videoTrimTimeRange.start;
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
            UIScrollView *scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(self.cropTypeView.frame.origin.x, self.cropTypeView.frame.origin.y + (iPhone_X ? 16 : 0), self.cropTypeView.frame.size.width, self.cropTypeView.frame.size.height+20)];
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
                if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                    label.textColor = UIColorFromRGB(0x131313);
                    label.backgroundColor = UIColorFromRGB(0xefefef);
                }
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
            if(_cutMmodeType == kCropTypeFixed && !_isCropTypeViewHidden && index == 0){
                _cropType = sender.tag;
                [sender setSelected:YES];
                if( VE_VECROPTYPE_ORIGINAL == sender.tag ){
                    ((UILabel*)[sender viewWithTag:22222]).textColor = Main_Color;
                }
                self.cropTypeSelectBtn = sender;
            }
            if( (_selectFile.fileCropModeType == sender.tag) || ( (VE_VECROPTYPE_FREE == _cropType) && ( sender.tag == VE_VECROPTYPE_ORIGINAL ) ) )
            {
                if( self.cropTypeSelectBtn )
                {
                    self.cropTypeSelectBtn.selected = NO;
                    if( self.cropTypeSelectBtn.tag == VE_VECROPTYPE_ORIGINAL ){
                        ((UILabel*)[self.cropTypeSelectBtn viewWithTag:22222]).textColor = PESDKTEXT_COLOR;
                        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                            ((UILabel*)[self.cropTypeSelectBtn viewWithTag:22222]).textColor = UIColorFromRGB(0x131313);
                        }
                    }
                }
                
                _cropType = sender.tag;
                [sender setSelected:YES];
                if( VE_VECROPTYPE_ORIGINAL == sender.tag ){
                    ((UILabel*)[sender viewWithTag:22222]).textColor = Main_Color;
                }
                self.cropTypeSelectBtn = sender;
                _cropType = _selectFile.fileCropModeType;
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
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                view.backgroundColor = [VEConfigManager sharedManager].viewBackgroundColor;
            }
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
            
            self.toolBar.frame = CGRectMake(0,  5, self.toolBar.frame.size.width, 40);
            self.titlelab.frame = CGRectMake(50, 0, kWIDTH-100, 40);
            {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolBar.frame) + 5, view.frame.size.width, 1.0/[UIScreen mainScreen].scale)];
                label.backgroundColor = UIColorFromRGB(0x272727);
                if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                    label.backgroundColor = UIColorFromRGB(0xefefef);
                }
                [view addSubview:label];
                
                if(!_isCropTypeViewHidden){
                    self.titlelab.hidden = YES;
                    self.titlelab.alpha = 0;
                    UIButton *cropBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWIDTH/2.0 - 60, 0, 60, 40)];
                    cropBtn.backgroundColor = [UIColor clearColor];
                    cropBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                    [cropBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
                    [cropBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
                    [cropBtn setTitle:VELocalizedString(@"裁切", nil) forState:UIControlStateNormal];
                    cropBtn.tag = 1;
                    cropBtn.selected = YES;
                    [cropBtn addTarget:self action:@selector(type_Btn:) forControlEvents:UIControlEventTouchUpInside];
                    _typeCropBtn = cropBtn;
                    [self.toolBar addSubview:cropBtn];
                    
                    UIButton *rotateBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWIDTH/2.0, 0, 60, 40)];
                    rotateBtn.backgroundColor = [UIColor clearColor];
                    rotateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                    [rotateBtn setTitleColor:UIColorFromRGB(0xcccccc) forState:UIControlStateNormal];
                    [rotateBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateSelected];
                    [rotateBtn setTitle:VELocalizedString(@"旋转", nil) forState:UIControlStateNormal];
                    rotateBtn.tag = 2;
                    rotateBtn.selected = NO;
                    [rotateBtn addTarget:self action:@selector(type_Btn:) forControlEvents:UIControlEventTouchUpInside];
                    _typeRotateBtn = rotateBtn;
                    [self.toolBar addSubview:rotateBtn];
                }
            }
            
            self.ribbtonView = view;
            [self.view addSubview:view];
            self.cropTypeScrollView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame) + (view.frame.size.height - CGRectGetMaxY(self.toolBar.frame) - self.cropTypeScrollView.frame.size.height) / 2.0, self.cropTypeScrollView.frame.size.width, self.cropTypeScrollView.frame.size.height);
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
            cropTypeModel.isSelect = (_selectFile.fileCropModeType == i);
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
    vvasset.rectInVideo = CGRectMake(0, 0, 1, 1);
    vvasset.crop = CGRectMake(0, 0, 1, 1);
    vvasset.isVerticalMirror = _selectFile.isVerticalMirror;
    vvasset.isHorizontalMirror = _selectFile.isHorizontalMirror;
    [scene.media addObject:vvasset];
    
    if( [VEConfigManager sharedManager].isPictureEditing )
    {
        scene.backgroundColor = UIColorFromRGB(0x000000);
    }
    if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
        scene.backgroundColor = [VEConfigManager sharedManager].viewBackgroundColor;
    }
    [self.scenesArray addObject:scene];
    if (_videoCoreSDK == nil) {
        _videoCoreSDK = [[VECore alloc] initWithAPPKey:[VEConfigManager sharedManager].appKey
        APPSecret:[VEConfigManager sharedManager].appSecret
        LicenceKey:[VEConfigManager sharedManager].licenceKey
        videoSize:self.editVideoSize
        fps:kEXPORTFPS
        resultFail:^(NSError *error) {
            
        }];
        if(CGRectEqualToRect(_videoPrewRect, CGRectZero)){
            [_videoCoreSDK setFrame:_videoBgView.bounds];
        }else{
            [_videoCoreSDK setFrame:_videoPrewRect];
        }
        [_videoBgView insertSubview:_videoCoreSDK.view  atIndex:0];
        _videoCoreSDK.delegate = self;
    }
    [_videoCoreSDK setScenes:self.scenesArray];
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
    _selectFile.isHorizontalMirror = _originFile.isHorizontalMirror;
    _selectFile.isVerticalMirror = _originFile.isVerticalMirror;
    _selectFile.rotate = _originFile.rotate;
    _selectFile.crop = _originFile.crop;
    _selectFile.rectInFile = _originFile.rectInFile;
    _selectFile.rectInScale = _originFile.rectInScale;
    _selectFile.fileScale = _originFile.fileScale;
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
    if (_selectFile.rotate == 360) {
        _selectFile.rotate = 0;
    }
    [self playVideo:NO];
    
    [self refreshPrewFrame];
    
    [self setResetButtonEnabled:YES];
    
}

-(void)vertButtonClicked{
    
    _selectFile.isVerticalMirror = !_selectFile.isVerticalMirror;
    [self playVideo:NO];
    MediaAsset * vvasset = [[_scenes firstObject].media firstObject];
    vvasset.isVerticalMirror = _selectFile.isVerticalMirror;
    [self.videoCoreSDK refreshCurrentFrame];
    [self setResetButtonEnabled:YES];
}

-(void)horizontalButtonClicked{
    
    _selectFile.isHorizontalMirror = !_selectFile.isHorizontalMirror;
    [self playVideo:NO];
    
    MediaAsset * vvasset = [[_scenes firstObject].media firstObject];
    vvasset.isHorizontalMirror = _selectFile.isHorizontalMirror;
    [self.videoCoreSDK refreshCurrentFrame];
    
    [self setResetButtonEnabled:YES];
}

-(void)resetButtonClicked{
    
    [self setResetButtonEnabled:NO];
    [self playVideo:NO];
    _selectFile.isVerticalMirror = NO;
    _selectFile.isHorizontalMirror = NO;
    _selectFile.rotate = 0;
    _selectFile.fileScale = 0;
    [self refreshPlayerFrame];
}

-(void)setResetButtonEnabled:(BOOL)isEnabled{
    _resetBtn.enabled = isEnabled;
//    if (!isEnabled) {
//        //[self.cropTypeView didSelectItemAtIndexPathRow:self.cropType];
//        self.playSlider.value = self.playSlider.minimumValue;
//        _playTimeLabel.text = @"00:00.0";
//    }
}

- (void)save{
    //CGRect crop = [self.videoCropView.cropView crop];
    //CGRect cropRect = [self.videoCropView.cropView cropRect];
    CGRect crop = CGRectMake(0, 0, 1, 1);
    crop.origin.x = self.videoBgView.contentOffset.x/self.videoBgView.contentSize.width;
    crop.origin.y = self.videoBgView.contentOffset.y/self.videoBgView.contentSize.height;
    crop.size.width = self.videoBgView.frame.size.width/self.videoBgView.contentSize.width;
    crop.size.height = self.videoBgView.frame.size.height/self.videoBgView.contentSize.height;
    
    CGRect cropRect = CGRectMake(self.videoBgView.contentOffset.x, self.videoBgView.contentOffset.y, self.videoBgView.frame.size.width, self.videoBgView.frame.size.height);
    CGRect r = crop;
    if(!_selectFile.isVerticalMirror && !_selectFile.isHorizontalMirror){
//        if(self.cropType == VE_VECROPTYPE_FIXEDRATIO){
//            if(_selectFile.rotate > 45 && _selectFile.rotate < 90 + 45){
//                r = CGRectMake(1 - crop.size.height - crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
//            }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
//                r = CGRectMake(crop.origin.x,  crop.origin.y, crop.size.width, crop.size.height);
//            }else if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
//                r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
//            }else{
//                r = CGRectMake(crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
//            }
//        }else{
            if(_selectFile.rotate > 45 && _selectFile.rotate < 90 + 45){
                r = CGRectMake(1 - crop.size.height - crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
            }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
                r = CGRectMake(1- crop.size.width - crop.origin.x, 1- crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
            }else if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
                r = CGRectMake(crop.origin.y, 1 - crop.size.width - crop.origin.x, crop.size.height, crop.size.width);
            }
//        }
    }else if(_selectFile.isVerticalMirror && !_selectFile.isHorizontalMirror){
        if(_selectFile.rotate > 90 - 45 && _selectFile.rotate < 90 + 45){
            r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
        }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
            r = CGRectMake(1- crop.size.width - crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
        }else if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
            r = CGRectMake(1 - crop.size.height - crop.origin.y, 1 - crop.size.width - crop.origin.x, crop.size.height, crop.size.width);
        }else{
            r = CGRectMake(crop.origin.x, 1 - crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
        }
    }else if(!_selectFile.isVerticalMirror && _selectFile.isHorizontalMirror){
        if(_selectFile.rotate > 90 - 45 && _selectFile.rotate < 90 + 45){
            r = CGRectMake(1 - crop.size.height - crop.origin.y, 1- crop.size.width - crop.origin.x, crop.size.height, crop.size.width);
        }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
            r = CGRectMake(crop.origin.x, 1- crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
        }else if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
            r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
        }else{
            r = CGRectMake(1- crop.size.width - crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
        }
    }else{
        if(_selectFile.rotate > 90 - 45 && _selectFile.rotate < 90 + 45){
            r = CGRectMake(crop.origin.y,1- crop.size.width- crop.origin.x, crop.size.height, crop.size.width);
        }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
            r = CGRectMake(crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
        }else if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
            r = CGRectMake(1- crop.size.height - crop.origin.y,crop.origin.x, crop.size.height, crop.size.width);
        }else{
            r = CGRectMake(1- crop.size.width - crop.origin.x,1- crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
        }
    }
    UIImage *rotateNewImage = [VEHelp image:_sourceImage rotation:0 cropRect:r];
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
    
    if(_editVideoForOnceFinishAction){
        _selectFile.contentURL = oldselectFile.contentURL;
        _editVideoForOnceFinishAction(NO,
                                      r,
                                      cropRect,
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
    
    //_selectFile.rectInScene = r;
    if(_editVideoForOnce_timeFinishAction){
        _selectFile.contentURL = oldselectFile.contentURL;
        if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
            [self dismissViewControllerAnimated:NO completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:NO];
        }
        _editVideoForOnce_timeFinishAction(NO,
                                           r,
                                           cropRect,
                                           _selectFile.isVerticalMirror,
                                           _selectFile.isHorizontalMirror,
                                           _selectFile.rotate,
                                           range,
                                           self.cropType);//_selectFile.fileCropModeType
        
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
    [self.view addSubview:self.exportProgressView];
    self.exportProgressView.hidden = NO;
    [self.exportProgressView setProgress:0 animated:NO];
    
    //[self refreshPlayer:[NSNumber numberWithBool:NO]];
    CGRect crop = CGRectMake(0, 0, 1, 1);
    crop.origin.x = self.videoBgView.contentOffset.x/self.videoBgView.contentSize.width;
    crop.origin.y = self.videoBgView.contentOffset.y/self.videoBgView.contentSize.height;
    crop.size.width = self.videoBgView.frame.size.width/self.videoBgView.contentSize.width;
    crop.size.height = self.videoBgView.frame.size.height/self.videoBgView.contentSize.height;
    
    CGRect cropRect = CGRectMake(self.videoBgView.contentOffset.x, self.videoBgView.contentOffset.y, self.videoBgView.frame.size.height, self.videoBgView.frame.size.height);
    CGRect r = crop;
    if(!_selectFile.isVerticalMirror && !_selectFile.isHorizontalMirror){
        if(self.cropType == VE_VECROPTYPE_FIXEDRATIO){
            if(_selectFile.rotate > 90 - 45 && _selectFile.rotate < 90 + 45){
                r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
            }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
                r = CGRectMake(crop.origin.x,  crop.origin.y, crop.size.width, crop.size.height);
            }else if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
                r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
            }else{
                r = CGRectMake(crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
            }
        }else{
            if(_selectFile.rotate > 90 - 45 && _selectFile.rotate < 90 + 45){
                r = CGRectMake(1 - crop.size.height - crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
            }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
                r = CGRectMake(1- crop.size.width - crop.origin.x, 1- crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
            }else if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
                r = CGRectMake(crop.origin.y, 1 - crop.size.width - crop.origin.x, crop.size.height, crop.size.width);
            }
        }
    }else if(_selectFile.isVerticalMirror && !_selectFile.isHorizontalMirror){
        if(_selectFile.rotate > 90 - 45 && _selectFile.rotate < 90 + 45){
            r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
        }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
            r = CGRectMake(1- crop.size.width - crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
        }else if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
            r = CGRectMake(1 - crop.size.height - crop.origin.y, 1 - crop.size.width - crop.origin.x, crop.size.height, crop.size.width);
        }else{
            r = CGRectMake(crop.origin.x, 1 - crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
        }
    }else if(!_selectFile.isVerticalMirror && _selectFile.isHorizontalMirror){
        if(_selectFile.rotate > 90 - 45 && _selectFile.rotate < 90 + 45){
            r = CGRectMake(1 - crop.size.height - crop.origin.y, 1- crop.size.width - crop.origin.x, crop.size.height, crop.size.width);
        }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
            r = CGRectMake(crop.origin.x, 1- crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
        }else if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
            r = CGRectMake(crop.origin.y, crop.origin.x, crop.size.height, crop.size.width);
        }else{
            r = CGRectMake(1- crop.size.width - crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
        }
    }else{
        if(_selectFile.rotate > 90 - 45 && _selectFile.rotate < 90 + 45){
            r = CGRectMake(crop.origin.y,1- crop.size.width- crop.origin.x, crop.size.height, crop.size.width);
        }else if(_selectFile.rotate > 180 - 45 && _selectFile.rotate < 180 + 45){
            r = CGRectMake(crop.origin.x, crop.origin.y, crop.size.width, crop.size.height);
        }else if(_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45){
            r = CGRectMake(1- crop.size.height - crop.origin.y,crop.origin.x, crop.size.height, crop.size.width);
        }else{
            r = CGRectMake(1- crop.size.width - crop.origin.x,1- crop.size.height - crop.origin.y, crop.size.width, crop.size.height);
        }
    }
    _selectFile.crop = r;
    
    UIImage *image = [VEHelp getFullImageWithUrl:_selectFile.contentURL];
    CGSize imageSize = image.size;
    if(image.size.width > image.size.height){
        imageSize.width = 1080;
        imageSize.height = 1080 * (image.size.height/image.size.width);
    }else{
        imageSize.height = 1920;
        imageSize.width = 1920 * (image.size.width/image.size.height);
    }
    float videoSizeWidth = imageSize.width * r.size.width;
    float videoSizeHeight = imageSize.height * r.size.height;
    
    CGSize size = CGSizeMake(videoSizeWidth, videoSizeHeight);
    
    [_videoCoreSDK setEditorVideoSize:size];
    
    [self refreshPlayer:[NSNumber numberWithBool:NO]];
    
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

- (void)getVideoSize {
    float rotate = _selectFile.rotate;
    _selectFile.rotate = 0;
    UIImage *image = [VEHelp getFullImageWithUrl:_selectFile.contentURL];
    CGSize imageSize = image.size;
    if(image.size.width > image.size.height){
        imageSize.width = 1080;
        imageSize.height = 1080 * (image.size.height/image.size.width);
    }else{
        imageSize.height = 1920;
        imageSize.width = 1920 * (image.size.width/image.size.height);
    }
    image = [VEHelp rescaleImage:image size:imageSize];
    image = [VEHelp image:image rotation:_selectFile.rotate cropRect:_selectFile.crop];
    _editVideoSize = image.size;
    if (rotate == 90 || rotate == 270) {
        _editVideoSize = CGSizeMake(_editVideoSize.height, _editVideoSize.width);
    }
}

-(void)refreshPlayerFrame{
    [_videoCoreSDK stop];
    MediaAsset * vvasset = [[_scenes firstObject].media firstObject];
    vvasset.rotate = _selectFile.rotate;
    vvasset.isVerticalMirror = _selectFile.isVerticalMirror;
    vvasset.isHorizontalMirror = _selectFile.isHorizontalMirror;

    [self getVideoSize];
    
    self.videoCoreSDK.frame = _videoBgView.bounds;
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
    if (!_exportProgressView) {
        [_videoCoreSDK build];
    }
}

#pragma mark - 5.DataSource and Delegate

#pragma mark - VECoreDelegate
- (void)statusChanged:(VECore *)sender status:(VECoreStatus)status
{
    if (sender == _videoCoreSDK && status == kVECoreStatusReadyToPlay) {
        if(_videoPrewView){
            _videoBgView.hidden = NO;
            [_videoPrewView removeFromSuperview];
            _videoPrewView = nil;
        }
        if (isNeedRefreshPlayer) {
            isNeedRefreshPlayer = NO;
            self.scenes = [[NSMutableArray alloc] initWithArray:_oldscenes];
            [self refreshPlayerFrame];
        }else {
            [_currentFrameView removeFromSuperview];
            _currentFrameView = nil;
            _videoCoreSDK.view.hidden = NO;
            [self seektimeCore];
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
    
    self.cropType = sender.tag;
    self.cropTypeSelectBtn = sender;
    self.cropTypeSelectBtn.selected = YES;
    if([self.cropTypeSelectBtn viewWithTag:22222])
        ((UILabel*)[self.cropTypeSelectBtn viewWithTag:22222]).textColor = Main_Color;
   
    [self refreshPrewFrame];
    
}

- (void)refreshPrewFrame{
    
    CGSize imageSize = _sourceImageSize;
    UIImage *prewViewImage = [self convertPlayerImage];
    
    float cropAsp = imageSize.width/imageSize.height;
    
    if(self.cropType ==VE_VECROPTYPE_ORIGINAL ){//原比例
        cropAsp = imageSize.width/imageSize.height;
    }else if(self.cropType ==VE_VECROPTYPE_FREE ){////自由
        cropAsp = imageSize.width/imageSize.height;
    }else if(self.cropType ==VE_VECROPTYPE_9TO16 ){////9:16
        cropAsp = 9.0/16.0;
    }else if(self.cropType ==VE_VECROPTYPE_16TO9 ){////16:9
        cropAsp = 16.0/9.0;
    }else if(self.cropType ==VE_VECROPTYPE_1TO1 ){////1:1
        cropAsp = 1.0;
    }else if(self.cropType ==VE_VECROPTYPE_6TO7 ){////6:7
        cropAsp = 6.0/7.0;
    }else if(self.cropType ==VE_VECROPTYPE_5TO8 ){////5.8"
        cropAsp = 5.0/8.0;
    }else if(self.cropType ==VE_VECROPTYPE_4TO5 ){////4:5
        cropAsp = 4.0/5.0;
    }else if(self.cropType ==VE_VECROPTYPE_4TO3 ){////4:3
        cropAsp = 4.0/3.0;
    }else if(self.cropType ==VE_VECROPTYPE_3TO5 ){////3:5
        cropAsp = 3.0/5.0;
    }else if(self.cropType ==VE_VECROPTYPE_3TO4 ){////3:4
        cropAsp = 3.0/4.0;
    }else if(self.cropType ==VE_VECROPTYPE_3TO2 ){////3:2
        cropAsp = 3.0/2.0;
    }else if(self.cropType ==VE_VECROPTYPE_235TO1 ){////2.35:1
        cropAsp = 2.35;
    }else if(self.cropType ==VE_VECROPTYPE_2TO3 ){////2:3
        cropAsp = 2.0/3.0;
    }else if(self.cropType ==VE_VECROPTYPE_2TO1 ){////2:1
        cropAsp = 2.0;
    }else if(self.cropType ==VE_VECROPTYPE_185TO1 ){////1.85:1
        cropAsp = 1.85;
    }else if(self.cropType ==VE_VECROPTYPE_FIXEDRATIO){///**< 固定比例裁切*/
        cropAsp = (imageSize.width *_fixedMaxCrop.size.width)/(imageSize.height *_fixedMaxCrop.size.height);
//        if((_selectFile.rotate > 45 && _selectFile.rotate < 90 + 45) || (_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45)){
//            cropAsp = (image.size.height *_fixedMaxCrop.size.height)/(image.size.width *_fixedMaxCrop.size.width);
//        }
    }else if(self.cropType ==VE_VECROPTYPE_1TO2 ){////1:2
        cropAsp = 1.0/2.0;
    }
    
    _videoCoreSDK.delegate = self;
    [_videoCoreSDK.view removeFromSuperview];
    _videoCoreSDK = nil;
    if(_videoPrewView){
        [_videoPrewView removeFromSuperview];
        _videoPrewView = nil;
    }
    if(_videoBgView){
        _videoPrewView = [[UIImageView alloc] initWithFrame:_videoBgView.frame];
        _videoPrewView.image = prewViewImage;
        _videoPrewView.layer.borderColor = [UIColor whiteColor].CGColor;
        _videoPrewView.layer.borderWidth = 2.0;
        [_bgView addSubview:_videoPrewView];
    }
    {
        [_videoBgView removeFromSuperview];
        
        CGRect rect = CGRectZero;
        rect = _videoBgRect;
        float w = rect.size.width;
        float h = w / cropAsp;
        if(h > rect.size.height){
            h = rect.size.height;
            w = h * cropAsp;
        }
        
        CGRect playerRect = CGRectMake((rect.size.width - w)/2.0, (rect.size.height - h)/2.0 + (iPhone_X ? 44 : 0), w, h);
        _videoBgView = [[UIScrollView alloc] initWithFrame:playerRect];
        
        _videoBgView.backgroundColor = UIColorFromRGB(0x000000);
        _videoBgView.minimumZoomScale = 1;
        _videoBgView.maximumZoomScale = 6;
        _videoBgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _videoBgView.layer.borderWidth = 2.0;
        _videoBgView.delegate = self;
        _videoBgView.hidden = YES;
        [_bgView addSubview:_videoBgView];
        
        
        float v_w = playerRect.size.width;
        if(self.cropType ==VE_VECROPTYPE_FIXEDRATIO){
            if((_selectFile.rotate > 45 && _selectFile.rotate < 90 + 45) || (_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45)){
                v_w = v_w/_fixedMaxCrop.size.height;
            }else{
                v_w = v_w/_fixedMaxCrop.size.width;
            }
        }
        UIImage *image = [VEHelp image:_sourceImage rotation:_selectFile.rotate cropRect:CGRectMake(0, 0, 1, 1)];
        imageSize = image.size;
        _editVideoSize = imageSize;
        
        float v_h = v_w * (image.size.height/image.size.width);
        float previewAsp = image.size.width/image.size.height;
        if(previewAsp > playerRect.size.width /playerRect.size.height){
            v_h = playerRect.size.height;
            if(self.cropType ==VE_VECROPTYPE_FIXEDRATIO){
                if((_selectFile.rotate > 45 && _selectFile.rotate < 90 + 45) || (_selectFile.rotate > 270 - 45 && _selectFile.rotate < 270 + 45)){
                    v_h = v_h/_fixedMaxCrop.size.width;
                }else{
                    v_h = v_h/_fixedMaxCrop.size.height;
                }
            }
            if(v_h > playerRect.size.height){
                v_h = playerRect.size.height;
            }
            v_w = v_h * (image.size.width/image.size.height);
        }
        
        _videoPrewRect = CGRectMake(0, 0, v_w, v_h);
        _editVideoSize = CGSizeMake(_editVideoSize.width, _editVideoSize.width * (v_h/v_w));
        [self initPlayer];
        _videoBgView.contentSize = _videoPrewRect.size;
    }
}

- (UIImage *)convertPlayerImage{
    @autoreleasepool{
        if(!self.videoBgView){
            return nil;
        }
        CGRect crop = CGRectMake(0, 0, 1, 1);
        crop.origin.x = self.videoBgView.contentOffset.x/self.videoBgView.contentSize.width;
        crop.origin.y = self.videoBgView.contentOffset.y/self.videoBgView.contentSize.height;
        crop.size.width = self.videoBgView.frame.size.width/self.videoBgView.contentSize.width;
        crop.size.height = self.videoBgView.frame.size.height/self.videoBgView.contentSize.height;
        
        UIImage *imageRet = [UIImage imageWithCGImage:[_videoCoreSDK copyCurrentCGImage]];
        imageRet = [VEHelp image:imageRet rotation:0 cropRect:crop];
        return imageRet;
    };
}

#pragma mark VECropTypeDelegate
-(void)cropTypeView:(VECropTypeView *)cropTypeView selectItemAtIndexPath:(NSIndexPath *)indexPath{
    VECropTypeModel * cropTypeModel = [self.dataCropTypeArray objectAtIndex:indexPath.section];
    UIImage *image = [VEHelp getFullImageWithUrl:_selectFile.contentURL];
    CGSize imageSize = image.size;
    if(image.size.width > image.size.height){
        imageSize.width = 1080;
        imageSize.height = 1080 * (image.size.height/image.size.width);
    }else{
        imageSize.height = 1920;
        imageSize.width = 1920 * (image.size.width/image.size.height);
    }
    image = [VEHelp rescaleImage:image size:imageSize];
    self.cropType = cropTypeModel.cropType;
    float cropAsp = image.size.width/image.size.height;
    if(self.cropType ==VE_VECROPTYPE_ORIGINAL ){//原比例
        cropAsp = image.size.width/image.size.height;
    }else if(self.cropType ==VE_VECROPTYPE_FREE ){////自由
        cropAsp = image.size.width/image.size.height;
    }else if(self.cropType ==VE_VECROPTYPE_9TO16 ){////9:16
        cropAsp = 9.0/16.0;
    }else if(self.cropType ==VE_VECROPTYPE_16TO9 ){////16:9
        cropAsp = 16.0/9.0;
    }else if(self.cropType ==VE_VECROPTYPE_1TO1 ){////1:1
        cropAsp = 1.0;
    }else if(self.cropType ==VE_VECROPTYPE_6TO7 ){////6:7
        cropAsp = 6.0/7.0;
    }else if(self.cropType ==VE_VECROPTYPE_5TO8 ){////5.8"
        cropAsp = 5.0/8.0;
    }else if(self.cropType ==VE_VECROPTYPE_4TO5 ){////4:5
        cropAsp = 4.0/5.0;
    }else if(self.cropType ==VE_VECROPTYPE_4TO3 ){////4:3
        cropAsp = 4.0/3.0;
    }else if(self.cropType ==VE_VECROPTYPE_3TO5 ){////3:5
        cropAsp = 3.0/5.0;
    }else if(self.cropType ==VE_VECROPTYPE_3TO4 ){////3:4
        cropAsp = 3.0/4.0;
    }else if(self.cropType ==VE_VECROPTYPE_3TO2 ){////3:2
        cropAsp = 3.0/2.0;
    }else if(self.cropType ==VE_VECROPTYPE_235TO1 ){////2.35:1
        cropAsp = 2.35;
    }else if(self.cropType ==VE_VECROPTYPE_2TO3 ){////2:3
        cropAsp = 2.0/3.0;
    }else if(self.cropType ==VE_VECROPTYPE_2TO1 ){////2:1
        cropAsp = 2.0;
    }else if(self.cropType ==VE_VECROPTYPE_185TO1 ){////1.85:1
        cropAsp = 1.85;
    }else if(self.cropType ==VE_VECROPTYPE_FIXEDRATIO ){///**< 固定比例裁切*/
        cropAsp = _fixedMaxCrop.size.width/_fixedMaxCrop.size.height;
    }else if(self.cropType ==VE_VECROPTYPE_1TO2 ){////1:2
        cropAsp = 1.0/2.0;
    }
    _videoCoreSDK.delegate = self;
    [_videoCoreSDK.view removeFromSuperview];
    _videoCoreSDK = nil;
    
    {
        [_videoBgView removeFromSuperview];
        image = [VEHelp image:image rotation:_selectFile.rotate cropRect:_selectFile.crop];
        CGRect rect = CGRectZero;
        _editVideoSize = image.size;
        rect = _videoBgRect;
        CGRect videoRect = AVMakeRectWithAspectRatioInsideRect(_editVideoSize, rect);
        _videoBgView = [[UIScrollView alloc] initWithFrame:videoRect];
        _videoBgView.backgroundColor = UIColorFromRGB(0x000000);
        _videoBgView.minimumZoomScale = 1;
        _videoBgView.maximumZoomScale = 6;
        _videoBgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _videoBgView.layer.borderWidth = 2.0;
        _videoBgView.delegate = self;
        [_bgView addSubview:_videoBgView];
        
        [self initPlayer];
    }
  
}

#pragma mark VECropTypeDelegate
-(void)cropViewbeginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [self setResetButtonEnabled:YES];
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
//        _currentFrameView = [_videoCropView.videoView snapshotViewAfterScreenUpdates:YES];
//        _videoCoreSDK.view.hidden = YES;
//        _currentFrameView.frame = _videoCropView.videoView.bounds;
//        [_videoCropView.videoView addSubview:_currentFrameView];
    }
    return _currentFrameView;
}

#pragma mark - 6.Set & Get

-(UIView *)toolView{
    if (!_toolView) {
        if (_cutMmodeType == kCropTypeNone) {
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
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                _toolView.backgroundColor = [VEConfigManager sharedManager].viewBackgroundColor;
            }
        }else {
            _toolView = [[UIView alloc] init];
            if( _selectFile.fileType == kFILEIMAGE && !_selectFile.isGif) {
                _toolView.frame = CGRectMake(0, self.toolBar.frame.origin.y - 60, self.bgView.frame.size.width, 60);
            }else {
                _toolView.frame = CGRectMake(0, self.toolBar.frame.origin.y - 85 - 60, self.bgView.frame.size.width, 60);
            }
//            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
//                _toolView.backgroundColor = [VEConfigManager sharedManager].viewBackgroundColor;
//            }else {
//                _toolView.backgroundColor = TOOLBAR_COLOR;
//            }
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
            _playButton.frame = CGRectMake((CGRectGetWidth(_videoBgRect) - 56)/2.0 + CGRectGetMinX(_videoBgRect), CGRectGetMinY(_videoBgRect) + (iPhone_X ? 44 : 0) + (_videoBgRect.size.height - 56)/2.0, 56, 56);
            [_playButton setImage:[VEHelp imageWithContentOfFile:@"/剪辑_播放_@3x"] forState:UIControlStateNormal];
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
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            _playTimeLabel.textColor = UIColorFromRGB(0x131313);
        }
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
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            _endTimeLabel.textColor = UIColorFromRGB(0x131313);
        }
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

- (void)type_Btn:(UIButton *)sender{
    sender.selected = YES;
    if(sender.tag == 1){
        _typeRotateBtn.selected = NO;
        self.cropTypeScrollView.hidden = NO;
        self.rotateTypeView.hidden = YES;
    }else{
        _typeCropBtn.selected = NO;
        self.cropTypeScrollView.hidden = YES;
        self.rotateTypeView.hidden = NO;
        [self.cropTypeScrollView.superview addSubview:self.rotateTypeView];
    }
}
- (UIScrollView *)rotateTypeView{
    if(!_rotateTypeView){
        UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 90)];
        view.showsVerticalScrollIndicator = NO;
        view.showsHorizontalScrollIndicator = NO;
        _rotateTypeView = view;
        [self.cropTypeScrollView.superview addSubview:_rotateTypeView];
        view.backgroundColor = UIColorFromRGB(0x1a1a1a);
        
        NSMutableArray *items = [NSMutableArray arrayWithObjects:
                                 @{@"name":@"左转90度",@"id":@(1)},
                                 @{@"name":@"右转90度",@"id":@(2)},
                                 @{@"name":@"左右翻转",@"id":@(3)},
                                 @{@"name":@"上下翻转",@"id":@(4)}, nil];
        
        float itemWidth = 90;
        float spanWidth = (_rotateTypeView.frame.size.width - itemWidth * 4)/5.0;
        for(int i = 0; i < items.count; i++){
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.exclusiveTouch = YES;
            btn.backgroundColor = [UIColor clearColor];
            btn.frame = CGRectMake(spanWidth + (itemWidth + spanWidth) * i , 0, itemWidth, itemWidth);
            [btn setTitle:VELocalizedString(items[i][@"name"], nil) forState:UIControlStateNormal];
            [btn setImage:[VEHelp imageWithContentOfFile:[NSString stringWithFormat:@"New_EditVideo/scrollViewChildImage/剪辑_剪辑%@默认_@3x.png",items[i][@"name"]]]  forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.tag = [items[i][@"id"] integerValue];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(10, (itemWidth - 44)/2.0, 36, (itemWidth - 44)/2.0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(50, -44, 20, 0)];
            [btn addTarget:self action:@selector(rotateType_Btn:) forControlEvents:UIControlEventTouchUpInside];
            [_rotateTypeView addSubview:btn];
        }
        
    }
    return _rotateTypeView;
}
- (void)rotateType_Btn:(UIButton *)sender{
    switch (sender.tag) {
        case 1://MARK: 左转
        {
            _selectFile.rotate += 90;
            if (_selectFile.rotate == 360) {
                _selectFile.rotate = 0;
            }
            [self playVideo:NO];
            
            [self refreshPrewFrame];
            
            [self setResetButtonEnabled:YES];
            
        }
            break;
        case 2://MARK: 右转
        {
            if(_selectFile.rotate<=0){
                _selectFile.rotate = 360;
            }
            _selectFile.rotate -=90;
            [self playVideo:NO];
            
            [self refreshPrewFrame];
            
            [self setResetButtonEnabled:YES];
        }
            break;
        case 3://MARK: 左右翻转
        {
            int number = ceil(_rotation/90);
            if( number %2 == 0)
                [self horizontalButtonClicked];
            else{
                [self vertButtonClicked];
            }
            
        }
            break;
        case 4://MARK: 上下翻转
        {
            int number = ceil(_rotation/90);
            if( number %2 == 0)
                [self vertButtonClicked];
            else
                [self horizontalButtonClicked];
        }
            break;
        default:
            break;
    }
}

-(VECropTypeView *)cropTypeView{
    if (_cropTypeView == nil) {
        if( _cutMmodeType == kCropTypeFixed )
        {
            if( _photoView )
                if( _cutMmodeType == kCropTypeFixed ) {
                    _cropTypeView = [[VECropTypeView alloc] initWithFrame:CGRectMake(16, _photoView.frame.size.height - 80, CGRectGetWidth(self.bgView.frame) - 16, 80)];
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
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            _cropTypeView.backgroundColor = [VEConfigManager sharedManager].viewBackgroundColor;
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
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            view.backgroundColor = [VEConfigManager sharedManager].viewBackgroundColor;
        }
    }
    
    [_photoView addSubview:self.cropTypeView];
    if( _isCropTypeViewHidden )
    {
        self.cropTypeView.hidden = YES;
    }
}

- (void)rotateBtnAction:(UIButton *)sender {
    if (sender.tag == 1) {//MARK: 上下
        [self vertButtonClicked];
    }
    else if (sender.tag == 2) {//MARK: 左右
        [self horizontalButtonClicked];
    }
#if 0
    else if (sender.tag == 3) {//重置
        [self resetButtonClicked];
    }
#else
    else if (sender.tag == 3) {//MARK: 旋转
        [self whirlButtonClicked];
    }
    else if (sender.tag == 4) {//MARK: 重置
        [self resetButtonClicked];
    }
#endif
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
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            view.backgroundColor = [VEConfigManager sharedManager].viewBackgroundColor;
        }
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
    if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
        label.textColor = UIColorFromRGB(0x131313);
    }
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
                    if(image){
                        [self.videoTrimiSlider.TrimmerView refreshThumbImage:idx thumbImage:image];
                    }
                    
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

@end

