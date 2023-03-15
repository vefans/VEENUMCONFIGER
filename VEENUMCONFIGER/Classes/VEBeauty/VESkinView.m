//
//  VESkinView.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/7/28.
//

#import "VESkinView.h"
#import "VEHelp.h"
#import "VESlider.h"

@implementation VESkinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        self.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : VIEW_COLOR;
        // 左上和右上为圆角
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
        cornerRadiusLayer.frame = self.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        self.layer.mask = cornerRadiusLayer;
        [self initToolbarView];
        [self initAdjustmentView];
    }
    return self;
}

-(void)initToolbarView {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 44)];
    _toolbarView = view;
    [self addSubview:view];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.5, self.frame.size.width, 0.5)];
    imageView.backgroundColor = UIColorFromRGB(0x2a2a2a);
    [_toolbarView addSubview:imageView];
    
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((44 - 40)/2.0, (44 - 40)/2.0, 40, 40)];
        [_toolbarView addSubview:btn];
        [btn setImage:[VEHelp imageNamed:@"/jianji/music/剪辑-剪辑-音乐_关闭默认_@3x"] forState:UIControlStateNormal];
        [btn setImage:[VEHelp imageNamed:@"/jianji/music/剪辑-剪辑-音乐_关闭默认_@3x"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(close_Btn:) forControlEvents:UIControlEventTouchUpInside];
    }
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 44 + (44 - 40)/2.0, (44 - 40)/2.0, 40, 40)];
        [_toolbarView addSubview:btn];
        [btn setImage:[VEHelp imageNamed:@"/PESDKImage/PESDK_勾@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]]  forState:UIControlStateNormal];
        [btn setImage:[VEHelp imageNamed:@"/PESDKImage/PESDK_勾@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]]  forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(return_Btn:) forControlEvents:UIControlEventTouchUpInside];
    }
    {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, self.frame.size.width - 88, 44)];
        _titleLbl.textColor = TEXT_COLOR;
        _titleLbl.font = [UIFont systemFontOfSize:14];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        [_toolbarView addSubview:_titleLbl];
    }
}

#pragma mark- 调整界面
-(void)initAdjustmentView
{
    UIView * adjustmentView = [[UIView alloc] initWithFrame:CGRectMake(0, _toolbarView.frame.size.height + _toolbarView.frame.origin.y, self.frame.size.width,  self.frame.size.height - kPlayerViewOriginX - (_toolbarView.frame.size.height + _toolbarView.frame.origin.y + ([VEConfigManager sharedManager].peEditConfiguration.isSingletrack ? 20 : 0))  )];
    [self addSubview:adjustmentView];
    
    UIButton * resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, adjustmentView.frame.size.height -  ([VEConfigManager sharedManager].peEditConfiguration.isSingletrack ? 20 : 0) - 28, 50, 28)];
    [resetBtn setTitle:VELocalizedString(@"还原", nil) forState:UIControlStateNormal];
    [resetBtn setTitleColor:UIColorFromRGB(0xbebebe) forState:UIControlStateNormal];
    [resetBtn setTitleColor:Main_Color forState:UIControlStateHighlighted];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    resetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [resetBtn addTarget:self action:@selector(resetAdjustment_Btn:) forControlEvents:UIControlEventTouchUpInside];
    [adjustmentView addSubview:resetBtn];
    
    UIButton *compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    compareBtn.frame = CGRectMake(adjustmentView.frame.size.width - (64 + 15), resetBtn.frame.origin.y, 64, 28);
    [compareBtn setTitle:VELocalizedString(@"toning_compare", nil) forState:UIControlStateNormal];
    [compareBtn setTitleColor:Main_Color forState:UIControlStateNormal];
    [compareBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    compareBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    compareBtn.layer.cornerRadius = 28/2.0;
    compareBtn.layer.borderColor = UIColorFromRGB(0x626267).CGColor;
    compareBtn.layer.borderWidth = 1.0;
    [compareBtn addTarget:self action:@selector(compareBtnDown:) forControlEvents:UIControlEventTouchDown];
    [compareBtn addTarget:self action:@selector(compareBtnUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [adjustmentView addSubview:compareBtn];

    VESlider * slider = [[VESlider alloc] initWithFrame:CGRectMake(40, (adjustmentView.frame.size.height-35)/2.0 -  ([VEConfigManager sharedManager].peEditConfiguration.isSingletrack ? 20 : 0), self.frame.size.width - 40*2, 35)];
    _adjustmentSlider = slider;
    
    [slider setMinimumValue:0];
    [slider setMaximumValue:1.0];
    [slider setValue:0.5];
    [slider addTarget:self action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(endScrub:) forControlEvents:UIControlEventTouchUpInside];
    [slider addTarget:self action:@selector(endScrub:) forControlEvents:UIControlEventTouchCancel];
    [adjustmentView addSubview:slider];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_adjustmentSlider.frame.size.width + _adjustmentSlider.frame.origin.x + 10, (adjustmentView.frame.size.height-25)/2.0, 30, 25)];
    label.text  = @"50";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    _adjustmentNumberLabel = label;
    [adjustmentView addSubview:label];
}

-(void)setCurrentMedia:(MediaAsset *)currentMedia
{
    _currentMedia = currentMedia;
    
    __block FaceAttribute *faceAttribute = nil;
    [_currentMedia.multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( CGRectContainsPoint(_currentFaceRect, CGPointMake(obj.faceRect.origin.x+obj.faceRect.size.width/2.0, obj.faceRect.origin.y+obj.faceRect.size.height/2.0)) || CGRectEqualToRect(_currentFaceRect, obj.faceRect)) {
            faceAttribute = obj;
            *stop = YES;
        }
    }];
    
    if (_beautyCategoryType == KBeautyCategory_Rosy) {
        _adjustmentSlider.value = _currentMedia.beautyToneIntensity;
    }
    else if (_beautyCategoryType == KBeautyCategory_WHitening) {
        _adjustmentSlider.value = _currentMedia.beautyBrightIntensity;
    }else if (_beautyCategoryType == KBeautyCategory_BlurIntensity) {
        _adjustmentSlider.value = _currentMedia.beautyBlurIntensity;
    }else if (_beautyCategoryType == KBeautyCategory_BigEyes) {
        _adjustmentSlider.value = faceAttribute.beautyBigEyeIntensity;
    }
    else if (_beautyCategoryType == KBeautyCategory_FaceLift) {
        _adjustmentSlider.value = faceAttribute.beautyThinFaceIntensity;
    }
    
    _adjustmentNumberLabel.text = [NSString stringWithFormat:@"%d",(int)(_adjustmentSlider.value*100)];
}

#pragma mark-滑动进度条
- (void)beginScrub:(UISlider *)slider{
    [self sliderValueChanged:slider];
}

- (void)scrub:(UISlider *)slider{
    [self sliderValueChanged:slider];
    int value = slider.value*100;
    _adjustmentNumberLabel.text = [NSString stringWithFormat:@"%d",value];
}

- (void)endScrub:(UISlider *)slider{
    [self sliderValueChanged:slider];
    int value = slider.value*100;
    _adjustmentNumberLabel.text = [NSString stringWithFormat:@"%d",value];
}

-(void)sliderValueChanged:(UISlider *) slider
{
    if( _delegate && [_delegate respondsToSelector:@selector(skinValueChanged: atVIew:)] )
    {
        [_delegate skinValueChanged:slider atVIew:self];
    }
}

-(void)resetAdjustment_Btn:( UIButton * ) sender
{
    if( _delegate && [_delegate respondsToSelector:@selector(skinReset:atVIew:)] )
    {
        [_delegate skinReset:_adjustmentSlider atVIew:self];
    }
}

- (void)compareBtnDown:(UIButton *)sender {
    _editMedia = [_currentMedia copy];
    _adjustmentSlider.value = 0;
    _adjustmentNumberLabel.text = @"0";
    
    if( _delegate && [_delegate respondsToSelector:@selector(skinCompare:)] )
    {
        [_delegate skinCompare:self];
    }
}

- (void)compareBtnUp:(UIButton *)sender {
    __block FaceAttribute *faceAttribute = nil;
    [_editMedia.multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( CGRectContainsPoint(_currentFaceRect, CGPointMake(obj.faceRect.origin.x+obj.faceRect.size.width/2.0, obj.faceRect.origin.y+obj.faceRect.size.height/2.0)) || CGRectEqualToRect(_currentFaceRect, obj.faceRect)) {
            faceAttribute = obj;
            *stop = YES;
        }
    }];
    if (_beautyCategoryType == KBeautyCategory_Rosy) {
        _adjustmentSlider.value = _editMedia.beautyToneIntensity;
    }
    else if (_beautyCategoryType == KBeautyCategory_WHitening) {
        _adjustmentSlider.value = _editMedia.beautyBrightIntensity;
    }else if (_beautyCategoryType == KBeautyCategory_BlurIntensity) {
        _adjustmentSlider.value = _editMedia.beautyBlurIntensity;
    }else if (_beautyCategoryType == KBeautyCategory_BigEyes) {
        _adjustmentSlider.value = faceAttribute.beautyBigEyeIntensity;
    }
    else if (_beautyCategoryType == KBeautyCategory_FaceLift) {
        _adjustmentSlider.value = faceAttribute.beautyThinFaceIntensity;
    }
    _adjustmentNumberLabel.text = [NSString stringWithFormat:@"%d",(int)(_adjustmentSlider.value*100)];
    
    if( _delegate && [_delegate respondsToSelector:@selector(skinCompareCompletion:atVIew:)] )
    {
        [_delegate skinCompareCompletion:_adjustmentSlider atVIew:self];
    }
}

-(void)close_Btn:(UIButton *) sender
{
    if( _delegate && [_delegate respondsToSelector:@selector(skinCancelEdit:slider:)] )
    {
        [_delegate skinCancelEdit:self slider:_adjustmentSlider];
    }
}

-(void)return_Btn:(UIButton *) sender
{
    if( _delegate && [_delegate respondsToSelector:@selector(skinEditCompletion:)] )
    {
        [_delegate skinEditCompletion:self];
    }
}
- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
}
@end
