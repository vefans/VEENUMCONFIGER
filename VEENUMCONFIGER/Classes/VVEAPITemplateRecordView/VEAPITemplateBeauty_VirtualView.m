//
//  VEAPITemplateBeauty_VirtualView.m
//  VEDeluxe
//
//  Created by iOS VESDK Team on 2020/3/27.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEAPITemplateBeauty_VirtualView.h"
#import <VEENUMCONFIGER/VEFiveCameraView.h>
#import <VEENUMCONFIGER/VEPlaySlider.h>
#import <VEENUMCONFIGER/UIButton+VECustomLayout.h>
#import <VEENUMCONFIGER/VECustomButton.h>
#import "VESlider.h"
#import "VEHelp.h"

@interface VEAPITemplateBeauty_VirtualView()<VEFiveCameraViewDelegate>
{
    NSArray *_beautyTypeArray;
    MediaAsset *_originalMedia;
    VESlider *_adjustmentSlider;
    UILabel *_adjustmentNumberLabel;
    UIButton *_seleTypeBtn;
}

@property (nonatomic, strong) VEFiveCameraView *fiveSensesView;
/** VECore美颜  美白参数 0.0 - 1.0 默认 0.3
 */
@property (nonatomic, assign) float brightness;
/** VECore美颜  磨皮参数 0.0 - 1.0 默认0.6
 */
@property (nonatomic, assign) float blur;

/** VECore美颜  红润参数0.0~1.0,默认为0.0
 */
@property (nonatomic, assign) float beautyToneIntensity;

/** VECore大眼  大眼参数0.0~1.0,默认为0.3
    只支持iOS11.0以上
 */
@property (nonatomic, assign) float beautyBigEye;

/** VECore廋脸  廋脸参数0.0~1.0,默认为0.5
    只支持iOS11.0以上
 */
@property (nonatomic, assign) float beautyThinFace;
@property(nonatomic, assign) NSInteger          selectedBeautyTypeIndex;
@property(nonatomic, weak) UIScrollView         *beautyTypeView;
//美颜
@property(nonatomic, weak) UIView               *beautyView;
@property(nonatomic, weak) UIButton             *beautyConfirmBtn;

@end

@implementation VEAPITemplateBeauty_VirtualView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : VIEW_COLOR;
        
        _selectedBeautyTypeIndex = KBeautyCategory_BlurIntensity;
        
         UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 49, 0, 44, 44)];
         _beautyConfirmBtn = btn;
         [_beautyConfirmBtn setImage:[VEHelp imageNamed:([VEConfigManager sharedManager].iPad_HD ? @"ipad/剪辑_勾_" : @"剪辑_勾_")] forState:UIControlStateNormal];
         [_beautyConfirmBtn addTarget:self action:@selector(beautyConfirm_Btn) forControlEvents:UIControlEventTouchUpInside];
         [self addSubview:_beautyConfirmBtn];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _beautyConfirmBtn.frame.origin.y, frame.size.width, 1.0/[UIScreen mainScreen].scale)];
        line.backgroundColor = UIColorFromRGB(0x1f1f1f);
        if([VEConfigManager sharedManager].toolLineColor){
            line.backgroundColor = [VEConfigManager sharedManager].toolLineColor;
        }
        [self addSubview:line];
        
        
        {
            VETabButton *btn = [[VETabButton alloc] init];
            btn.frame = CGRectMake(10, 0, 60, 44);
            btn.tag = 2;
            [btn setTitleColor:UIColorFromRGB(0xa4a4a4) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTitle:VELocalizedString(@"美颜", nil) forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(tapCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.selected = YES;
            [self addSubview:btn];
            _seleTypeBtn  = btn;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
            
            VETabButton *btn1 = [[VETabButton alloc] init];
            btn1.frame = CGRectMake(CGRectGetMaxX(btn.frame), 0, 60, 44);
            btn1.tag = 1;
            [btn1 setTitleColor:UIColorFromRGB(0xa4a4a4) forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn1 setTitle:VELocalizedString(@"五官", nil) forState:UIControlStateNormal];
            btn1.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn1 addTarget:self action:@selector(tapCategoryBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn1.selected = NO;
            [self addSubview:btn1];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn1.frame), frame.size.width, 1.0/[UIScreen mainScreen].scale)];
            line.backgroundColor = UIColorFromRGB(0x1f1f1f);
            if([VEConfigManager sharedManager].toolLineColor){
                line.backgroundColor = [VEConfigManager sharedManager].toolLineColor;
            }
            [self addSubview:line];
            
        }
        self.beautyView.hidden = NO;        
    }
    return self;
}

- (void)tapCategoryBtn:(UIButton *)sender{
    if(sender.selected){
        return;
    }
    if(_seleTypeBtn)
    {
        _seleTypeBtn.selected = NO;
        _seleTypeBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    sender.selected = YES;
    sender.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    switch (sender.tag) {
        case 1:
            _beautyView.hidden = YES;
            self.fiveSensesView.hidden = NO;
            break;
        case 2:
            _fiveSensesView.hidden = YES;
            self.beautyView.hidden = NO;
            break;
        default:
            break;
    }
    
    _seleTypeBtn = sender;
}
#pragma mark- 美颜
-(void)beautyConfirm_Btn
{
    
    if( _delegate && [_delegate respondsToSelector:@selector(beautyConfirm_Btn:)] )
    {
        [_delegate beautyConfirm_Btn:self];
    }
}

- (UIView *)beautyView {
    if (!_beautyView) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.bounds.size.width, self.frame.size.height - 44 - 8)];
        _beautyView = view;
        _beautyView.backgroundColor = [UIColor clearColor];
        [self addSubview:_beautyView];
        if([VEConfigManager sharedManager].iPad_HD){
            _beautyView.frame = CGRectMake(0, 35, self.bounds.size.width, self.frame.size.height - 35);
            [_beautyView addSubview:self.fiveSensesView];
        }else{
            _blur = 0.6;
            _brightness = 0.3;
            _beautyThinFace = 0.5;
            _beautyBigEye = 0.3;
            
            UIScrollView * typeView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (_beautyView.frame.size.height - 44 - (iPhone_X ? 34 : 0) - ([VEConfigManager sharedManager].editConfiguration.isSingletrack ? 20 : 0) - 65)/2.0, CGRectGetWidth(self.frame), 65)];
            typeView.showsHorizontalScrollIndicator = NO;
            _beautyTypeView = typeView;
            [_beautyView addSubview:_beautyTypeView];
                    
            _beautyTypeArray = [NSArray arrayWithObjects:@"磨皮", @"美白", @"红润",@"大眼",@"瘦脸", nil];
            float width = _beautyTypeView.frame.size.width / 5.5;
            [_beautyTypeArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(idx * width, 0, width, 60)];
                typeBtn.backgroundColor = [UIColor clearColor];
                
                [typeBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"/New_EditVideo/Beauty/剪辑-美颜_%@默认",obj]] forState:UIControlStateNormal];
                [typeBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"/New_EditVideo/Beauty/剪辑-美颜_%@选中",obj]] forState:UIControlStateSelected];
                [typeBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
                [typeBtn setTitleColor:Main_Color forState:UIControlStateSelected];
                [typeBtn setTitle:VELocalizedString(obj, nil) forState:UIControlStateNormal];
                typeBtn.titleLabel.font = [UIFont systemFontOfSize:10.0];
                [typeBtn layoutButtonWithEdgeInsetsStyle:VEButtonEdgeInsetsStyleTop imageTitleSpace:0];
                
                typeBtn.tag = idx + 2;
                [typeBtn addTarget:self action:@selector(beautyTypeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [_beautyTypeView addSubview:typeBtn];
                if (typeBtn.tag == _selectedBeautyTypeIndex) {
                    typeBtn.selected = YES;
                }
            }];
            _beautyTypeView.contentSize = CGSizeMake(width * _beautyTypeArray.count, 0);
            if(_beautyTypeView.contentSize.width < _beautyTypeView.frame.size.width){
                CGRect rect = _beautyTypeView.frame;
                rect.size.width = _beautyTypeView.contentSize.width;
                rect.origin.x = (_beautyTypeView.frame.size.width - rect.size.width)/2.0;
                _beautyTypeView.frame = rect;
            }
            VESlider * slider = [[VESlider alloc] initWithFrame:CGRectMake(90, _beautyView.frame.size.height - 44 - (iPhone_X ? 34 : 0) - ([VEConfigManager sharedManager].editConfiguration.isSingletrack ? 20 : 0) + (44 - 35)/2.0, self.frame.size.width - 100 - 44 - 15, 35)];
            _adjustmentSlider = slider;
            
            [slider setMinimumValue:0];
            [slider setMaximumValue:1.0];
            [slider setValue:_blur];
            [slider addTarget:self action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
            [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
            [slider addTarget:self action:@selector(endScrub:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside)];
            [_beautyView addSubview:slider];

            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(_adjustmentSlider.frame.size.width + _adjustmentSlider.frame.origin.x + 10, _adjustmentSlider.frame.origin.y - 20, 30, 25)];
            label.text = [NSString stringWithFormat:@"%.f", _blur * 100];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.hidden = YES;
            _adjustmentNumberLabel = label;
            
            CGRect frame = _adjustmentNumberLabel.frame;
            frame.origin.x = _adjustmentSlider.value * _adjustmentSlider.frame.size.width + _adjustmentSlider.frame.origin.x - frame.size.width / 2.0;
            _adjustmentNumberLabel.frame = frame;
            [_beautyView addSubview:label];
            
            UIButton *compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            compareBtn.frame = CGRectMake(self.frame.size.width - (44 + 15), _beautyView.frame.size.height - 44 - (iPhone_X ? 34 : 0) - ([VEConfigManager sharedManager].editConfiguration.isSingletrack ? 20 : 0), 44, 44);
            [compareBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/skin/%@默认",@"对比"]] forState:UIControlStateNormal];
            [compareBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/skin/%@选中",@"对比"]] forState:UIControlStateSelected];
            [compareBtn addTarget:self action:@selector(compareBtnDown:) forControlEvents:UIControlEventTouchDown];
            [compareBtn addTarget:self action:@selector(compareBtnUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
            [_beautyView addSubview:compareBtn];
            
            UIButton * resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, compareBtn.frame.origin.y, 80, 44)];
            [resetBtn setImage:[VEHelp imageNamed:@"VirtualLive/美颜重置默认@3x"] forState:UIControlStateNormal];
            [resetBtn setImage:[VEHelp imageNamed:@"VirtualLive/美颜重置选中@3x"] forState:UIControlStateHighlighted];
            [resetBtn setTitle:VELocalizedString(@"重置", nil) forState:UIControlStateNormal];
            [resetBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            [resetBtn setTitleColor:Main_Color forState:UIControlStateHighlighted];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                [resetBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
                [resetBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateHighlighted];
            }
            resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            resetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [resetBtn addTarget:self action:@selector(resetAdjustment_Btn:) forControlEvents:UIControlEventTouchUpInside];
            [_beautyView addSubview:resetBtn];
        }
    }
    
    return _beautyView;
}

- (VEFiveCameraView *)fiveSensesView {
    if (!_fiveSensesView) {
        _fiveSensesView = [[VEFiveCameraView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44 - 8)];
        _fiveSensesView.backgroundColor = [UIColor clearColor];
        [self addSubview:_fiveSensesView];
        _fiveSensesView.delegate = self;
    }
    
    return _fiveSensesView;
}

- (void)resetAdjustment_Btn:(UIButton *)sender{
    float value = 0.0;
#if 1
    switch (_selectedBeautyTypeIndex) {
        case KBeautyCategory_BlurIntensity://MARK: 磨皮
        {
            value = 0.6;
        }
            break;
        case KBeautyCategory_WHitening://MARK: 亮肤
        {
            value = 0.3;
        }
            break;
        case KBeautyCategory_Rosy://MARK: 红润
        {
            value = 0;
        }
            break;
        case KBeautyCategory_BigEyes://MARK: 大眼
        {
            value = 0.3;
        }
            break;
        default://MARK: 瘦脸
        {
            value = 0.5;
        }
            break;
    }
#endif
    _adjustmentSlider.value = value;
    _adjustmentNumberLabel.text = [NSString stringWithFormat:@"%d",(int)(_adjustmentSlider.value*100)];
    CGRect frame = _adjustmentNumberLabel.frame;
    frame.origin.x = _adjustmentSlider.value * _adjustmentSlider.frame.size.width + _adjustmentSlider.frame.origin.x - frame.size.width / 2.0;
    _adjustmentNumberLabel.frame = frame;
#if 0
    if (_delegate && [_delegate respondsToSelector:@selector(refreshBeautyValue:beautyType:)]) {
        [_delegate refreshBeautyValue:value beautyType:_selectedBeautyTypeIndex - 2];
    }
#else   //20220721 重置/对比是恢复原始状态
#if 1
    _blur = 0.6;
    _brightness = 0.3;
    _beautyThinFace = 0.5;
    _beautyBigEye = 0.3;
    _beautyToneIntensity = 0;
#else
    _blur = 0;
    _brightness = 0;
    _beautyThinFace = 0;
    _beautyBigEye = 0;
    _beautyToneIntensity = 0;
#endif
    if (_delegate && [_delegate respondsToSelector:@selector(resetBeauty)]) {
        [_delegate resetBeauty];
    }
    if( _delegate && [_delegate respondsToSelector:@selector(resetBeautyWithArray:atView:)] )
    {
        NSMutableArray *array = [NSMutableArray new];
        [array addObject:[NSNumber numberWithFloat:_blur]];
        [array addObject:[NSNumber numberWithFloat:_brightness]];
        [array addObject:[NSNumber numberWithFloat:_beautyThinFace]];
        [array addObject:[NSNumber numberWithFloat:_beautyBigEye]];
        [array addObject:[NSNumber numberWithFloat:_beautyToneIntensity]];
        [_delegate resetBeautyWithArray:array atView:self];
    }
#endif
}

- (void)compareBtnDown:(UIButton *)sender {
#if 1   //20220721 重置/对比是恢复原始状态
    if (_delegate && [_delegate respondsToSelector:@selector(resetBeauty)]) {
        [_delegate resetBeauty];
    }
#else
    float value = 0.5;
    _adjustmentSlider.value = value;
    _adjustmentNumberLabel.text = [NSString stringWithFormat:@"%d",(int)(_adjustmentSlider.value*100)];
    CGRect frame = _adjustmentNumberLabel.frame;
    frame.origin.x = _adjustmentSlider.value * _adjustmentSlider.frame.size.width + _adjustmentSlider.frame.origin.x - frame.size.width / 2.0;
    _adjustmentNumberLabel.frame = frame;
    
    if (_delegate && [_delegate respondsToSelector:@selector(refreshBeautyValue:beautyType:)]) {
        [_delegate refreshBeautyValue:value beautyType:_selectedBeautyTypeIndex - 2];
    }
#endif
}

- (void)compareBtnUp:(UIButton *)sender {
#if 0
    float value;
    switch (_selectedBeautyTypeIndex) {
        case KBeautyCategory_BlurIntensity://MARK: 磨皮
        {
            value = _blur;
        }
            break;
        case KBeautyCategory_WHitening://MARK: 亮肤
        {
            value = _brightness;
        }
            break;
        case KBeautyCategory_Rosy://MARK: 红润
        {
            value = _beautyToneIntensity;
        }
            break;
        case KBeautyCategory_BigEyes://MARK: 大眼
        {
            value = _beautyBigEye;
        }
            break;
        default://MARK: 瘦脸
        {
            value = _beautyThinFace;
        }
            break;
    }
    _adjustmentSlider.value = value;
    _adjustmentNumberLabel.text = [NSString stringWithFormat:@"%d",(int)(_adjustmentSlider.value*100)];
    CGRect frame = _adjustmentNumberLabel.frame;
    frame.origin.x = _adjustmentSlider.value * _adjustmentSlider.frame.size.width + _adjustmentSlider.frame.origin.x - frame.size.width / 2.0;
    _adjustmentNumberLabel.frame = frame;
    if (_delegate && [_delegate respondsToSelector:@selector(refreshBeautyValue:beautyType:)]) {
        [_delegate refreshBeautyValue:value beautyType:_selectedBeautyTypeIndex - 2];
    }
#else
    float value = 0;
    for (int i = 0; i < _beautyTypeArray.count; i++) {
        switch (i) {
            case 0:
                value = _blur;
                break;
            case 1:
                value = _brightness;
                break;
            case 2:
                value = _beautyToneIntensity;
                break;
            case 3:
                value = _beautyBigEye;
                break;
            case 4:
                value = _beautyThinFace;
                break;
                
            default:
                break;
        }
        if (_delegate && [_delegate respondsToSelector:@selector(refreshBeautyValue:beautyType:)]) {
            [_delegate refreshBeautyValue:value beautyType:i];
        }
    }
#endif
}

- (void)beautyTypeBtnAction:(UIButton *)sender {
    [self beautyTypeIndexAction:sender.tag];
}
- (void)beautyTypeIndexAction:(NSInteger)sender_tag{
    if (_selectedBeautyTypeIndex > 0) {
        UIButton *prevBtn = [_beautyTypeView viewWithTag:_selectedBeautyTypeIndex];
        prevBtn.selected = NO;
    }
    UIButton *currentBtn = [_beautyTypeView viewWithTag:sender_tag];
    currentBtn.selected = YES;
    _selectedBeautyTypeIndex = sender_tag;
    
    if (_selectedBeautyTypeIndex == KBeautyCategory_FiveSenses ) {
        _adjustmentSlider.enabled = NO;
        self.fiveSensesView.hidden = NO;
    }else {
        if ( _selectedBeautyTypeIndex == KBeautyCategory_BigEyes
            || _selectedBeautyTypeIndex == KBeautyCategory_FaceLift)
        {
            if (_selectedBeautyTypeIndex == KBeautyCategory_BigEyes) {
                _adjustmentSlider.value = _beautyBigEye;
                if (_delegate && [_delegate respondsToSelector:@selector(beginChangeBeautyBigEye)]) {
                    [_delegate beginChangeBeautyBigEye];
                }
            }
            else if (_selectedBeautyTypeIndex == KBeautyCategory_FaceLift) {
                _adjustmentSlider.value = _beautyThinFace;
                if (_delegate && [_delegate respondsToSelector:@selector(beginChangeBeautyThinFace)]) {
                    [_delegate beginChangeBeautyThinFace];
                }
            }
        }else {
            if (_selectedBeautyTypeIndex == KBeautyCategory_Rosy) {
                _adjustmentSlider.value = _beautyToneIntensity;
            }
            else if (_selectedBeautyTypeIndex == KBeautyCategory_WHitening) {
                _adjustmentSlider.value = _brightness;
            }else if (_selectedBeautyTypeIndex == KBeautyCategory_BlurIntensity) {
                _adjustmentSlider.value = _blur;
            }
        }
        _adjustmentNumberLabel.text = [NSString stringWithFormat:@"%d",(int)(_adjustmentSlider.value*100)];
        CGRect frame = _adjustmentNumberLabel.frame;
        frame.origin.x = _adjustmentSlider.value * _adjustmentSlider.frame.size.width + _adjustmentSlider.frame.origin.x - frame.size.width / 2.0;
        _adjustmentNumberLabel.frame = frame;
        _adjustmentSlider.enabled = YES;
    }
}

- (void)beginScrub:(UISlider *)slider{
    [self sliderValueChanged:slider];
    _adjustmentNumberLabel.hidden = NO;
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
    _adjustmentNumberLabel.hidden = YES;
}

-(void)sliderValueChanged:(UISlider *) slider
{
    switch (_selectedBeautyTypeIndex) {
        case KBeautyCategory_BlurIntensity://MARK: 磨皮
        {
            _blur = slider.value;
        }
            break;
        case KBeautyCategory_WHitening://MARK: 亮肤
        {
            _brightness = slider.value;
        }
            break;
        case KBeautyCategory_Rosy://MARK: 红润
        {
            _beautyToneIntensity = slider.value;
        }
            break;
        case KBeautyCategory_BigEyes://MARK: 大眼
        {
            _beautyBigEye = slider.value;
        }
            break;
        default://MARK: 瘦脸
        {
            _beautyThinFace = slider.value;
        }
            break;
    }
    CGRect frame = _adjustmentNumberLabel.frame;
    frame.origin.x =  _adjustmentSlider.thumbRect.origin.x + _adjustmentSlider.frame.origin.x - (frame.size.width - _adjustmentSlider.thumbRect.size.width)/2.0;
    _adjustmentNumberLabel.frame = frame;
    if (_delegate && [_delegate respondsToSelector:@selector(refreshBeautyValue:beautyType:)]) {
        [_delegate refreshBeautyValue:slider.value beautyType:_selectedBeautyTypeIndex - 2];
    }
}

#pragma mark - VEFiveCameraViewDelegate
- (void)fiveSensesEditCompletion:(VEFiveCameraView *)view {
    view.hidden = YES;
}

- (void)fiveSenses_ValueChanged:(UISlider *)slider atVIew:(VEFiveCameraView *)view {
    
    if([VEConfigManager sharedManager].iPad_HD){
        if(slider.tag < KBeauty_BlurIntensity){
            [self setBeautyType:slider.tag beautyValue:slider.value];
        }else{
            if (_delegate && [_delegate respondsToSelector:@selector(refreshBeautyValue:beautyType:)]) {
                [_delegate refreshBeautyValue:slider.value beautyType:(slider.tag - 16)];
            }
        }
    }else{
        [self setBeautyType:slider.tag beautyValue:slider.value];
    }
}

- (void)fiveSensesResetAll {
    if (_delegate && [_delegate respondsToSelector:@selector(resetFiveSenses)]) {
        [_delegate resetFiveSenses];
    }
}

- (void)fiveSensesCompareCompletionAll:(FaceAttribute *)faceAttribute {
    if (_delegate && [_delegate respondsToSelector:@selector(refreshFiveSenses:)]) {
        [_delegate refreshFiveSenses:faceAttribute];
    }
}

- (void)fiveSenses_Reset:(NSInteger)type value:(float)value {
    [self setBeautyType:type beautyValue:value];
}

- (void)fiveSensesCompare:(NSInteger) type value:(float)value {
    [self setBeautyType:type beautyValue:value];
}

- (void)fiveSensesCompareCompletion:(NSInteger)type value:(float)value {
    [self setBeautyType:type beautyValue:value];
}

- (void)setBeautyType:(KBeautyType)type beautyValue:(float) value
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshFiveSensesValue:beautyType:)]) {
        [_delegate refreshFiveSensesValue:value beautyType:type];
    }
}

- (void)dealloc{
    NSLog(@"%s", __func__);
}

@end
