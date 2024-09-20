//
//  Adjust_HSLView.m
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/4/24.
//

#import "Adjust_HSLView.h"
#import "CustomColorView.h"
#import "VESlider.h"
#import "VEHelp.h"
#import "VEColorButton.h"

@interface Adjust_HSLView ()
{
    NSArray *_colorArray;
    NSInteger _colorIndex;
    UIScrollView *_colorScrollView;
    UILabel *_valueLbl;
    NSMutableArray <VESlider *>*_sliders;
}

@property (nonatomic, assign) float hueValue;

@property (nonatomic, assign) float saturationValue;

@property (nonatomic, assign) float lightnessValue;

@end

@implementation Adjust_HSLView

- (instancetype)initWithFrame:(CGRect)frame hsl:(HSL *)hsl
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : [VEConfigManager sharedManager].viewBackgroundColor;
        _hsl = hsl;
        
        UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        [self addSubview:toolbarView];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:toolbarView.bounds];
        titleLbl.text = @"HSL";
        titleLbl.textColor = SUBTITLETEXT_COLOR;
        if([VEConfigManager sharedManager].toolsTitleColor){
            titleLbl.textColor = [VEConfigManager sharedManager].toolsTitleColor;
        }
        titleLbl.font = [UIFont boldSystemFontOfSize:[VEConfigManager sharedManager].iPad_HD ? 17 : 14];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [toolbarView addSubview:titleLbl];
        
        UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 80, 44)];
        [resetBtn setTitle:VELocalizedString(@"重置", nil) forState:UIControlStateNormal];
        resetBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [resetBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [resetBtn setTitleColor:DISABLED_COLOR forState:UIControlStateDisabled];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [resetBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
            [resetBtn setTitleColor:UIColorFromRGB(0x727272) forState:UIControlStateDisabled];
        }
        [resetBtn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if([VEConfigManager sharedManager].iPad_HD){
            resetBtn.frame = CGRectMake(5, (CGRectGetHeight(self.frame) - 40), 80, 40);
            [resetBtn setImage:[VEHelp imageNamed:@"ipad_Reset_normal"] forState:UIControlStateNormal];
            [resetBtn setImage:[VEHelp imageNamed:@"ipad_Reset_selected"] forState:UIControlStateDisabled];
            [self addSubview:resetBtn];
        }else{
            [resetBtn setImage:[VEHelp imageNamed:@"剪辑_重置默认_"] forState:UIControlStateNormal];
            [resetBtn setImage:[VEHelp imageNamed:@"剪辑_重置选中_"] forState:UIControlStateDisabled];
            [toolbarView addSubview:resetBtn];
        }
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.frame = CGRectMake(CGRectGetWidth(toolbarView.frame) - 49, 0, 44, 44);
        [finishBtn setImage:[VEHelp imageNamed:@"RoundDownArrow_"] forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarView addSubview:finishBtn];
        
        UIScrollView *colorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(toolbarView.frame), frame.size.width, 80)];
        colorScrollView.showsVerticalScrollIndicator = NO;
        colorScrollView.showsHorizontalScrollIndicator = NO;
        _colorScrollView = colorScrollView;
        [self addSubview:colorScrollView];
        
        _colorArray = [VEHelp getToningHSLColorArray];
        _colorIndex = 1;
        float width = 26.0;
        float space = (colorScrollView.frame.size.width - 40 - width * _colorArray.count) / (_colorArray.count - 1);
        float y = (colorScrollView.frame.size.height - width) / 2.0;
        for (int i = 0; i < _colorArray.count; i++) {
            VEColorButton *itemBtn = [[VEColorButton alloc] initWithFrame:CGRectMake(20 + (width + space) * i, y, width, width)];
            itemBtn.backgroundColor = _colorArray[i];
            itemBtn.tag = i + 1;
            [itemBtn addTarget:self action:@selector(colorItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                itemBtn.selected = YES;
            }
            [colorScrollView addSubview:itemBtn];
        }
        
        _valueLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _valueLbl.font = [UIFont systemFontOfSize:12];
        _valueLbl.textColor = [UIColor whiteColor];
        if([VEConfigManager sharedManager].toolsTitleColor){
            _valueLbl.textColor = [VEConfigManager sharedManager].toolsTitleColor;
        }
        _valueLbl.textAlignment = NSTextAlignmentCenter;
        _valueLbl.hidden = YES;
        [self addSubview:_valueLbl];
        
        _hueValue = [_hsl.hsl_red.firstObject floatValue];
        _saturationValue = [_hsl.hsl_red[1] floatValue];
        _lightnessValue = [_hsl.hsl_red[2] floatValue];
        _sliders = [NSMutableArray array];
        NSArray *array = @[@"色调", @"饱和度", @"HSL亮度"];
        y = CGRectGetMaxY(_colorScrollView.frame);
        float height = (frame.size.height - y - kBottomSafeHeight) / array.count;
        if([VEConfigManager sharedManager].iPad_HD){
            height = 60;
        }
        for (int i = 0; i < array.count; i++) {
            UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, y + height * i, 88 - 20, height)];
            nameLbl.text = VELocalizedString(array[i], nil);
            nameLbl.textColor = SUBTITLETEXT_COLOR;
            if([VEConfigManager sharedManager].toolsTitleColor){
                nameLbl.textColor = [VEConfigManager sharedManager].toolsTitleColor;
            }
            nameLbl.textAlignment = NSTextAlignmentLeft;
            nameLbl.font = [UIFont systemFontOfSize:12];
            [self addSubview:nameLbl];
            
            VESlider *slider = [[VESlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLbl.frame), nameLbl.frame.origin.y, frame.size.width - CGRectGetMaxX(nameLbl.frame) - 30, height)];
            slider.minimumValue = -1.0;
            if (i == 0) {
                slider.value = _hueValue;
            }
            else if (i == 1) {
                slider.value = _saturationValue;
            }
            else {
                slider.value = _lightnessValue;
            }
            slider.tag = i;
            [slider addTarget:self action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
            [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
            [slider addTarget:self action:@selector(endScrub:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside)];
            [self addSubview:slider];
            [_sliders addObject:slider];
        }
    }
    
    return self;
}

- (void)resetBtnAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:VELocalizedString(@"Do you want to reset all current adjustments?", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:VELocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil]];
    WeakSelf(self);
    [alert addAction:[UIAlertAction actionWithTitle:VELocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf reset];
    }]];
    
    [[VEHelp getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)reset {
    for (VESlider *slider in _sliders) {
        slider.value = 0;
    }
    _hueValue = 0;
    _saturationValue = 0;
    _lightnessValue = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(resetAdjustHSL:)]) {
        [_delegate resetAdjustHSL:self];
    }
}

- (void)finishBtnAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(completionAdjustHSL:)]) {
        [_delegate completionAdjustHSL:self];
    }
}

- (void)colorItemBtnAction:(UIButton *)sender {
    if (!sender.selected) {
        VEColorButton *prevBtn = [sender.superview viewWithTag:_colorIndex];
        prevBtn.selected = NO;
        sender.selected = YES;
        _colorIndex = sender.tag;
        
        NSArray *array;
        switch (_colorIndex - 1) {
            case 0:
            {
                array = _hsl.hsl_red;
            }
                break;
            case 1:
            {
                array = _hsl.hsl_orange;
            }
                break;
            case 2:
            {
                array = _hsl.hsl_yellow;
            }
                break;
            case 3:
            {
                array = _hsl.hsl_green;
            }
                break;
#ifdef kJYResources
            case 4:
            {
                array = _hsl.hsl_cyan;
            }
                break;
            case 5:
            {
                array = _hsl.hsl_blue;
            }
                break;
            case 6:
            {
                array = _hsl.hsl_purple;
            }
                break;
            case 7:
            {
                array = _hsl.hsl_magenta;
            }
                break;
#else
            case 4:
            {
                array = _hsl.hsl_blue;
            }
                break;
            case 5:
            {
                array = _hsl.hsl_purple;
            }
                break;
            case 6:
            {
                array = _hsl.hsl_magenta;
            }
                break;
#endif
                
            default:
                break;
        }
        _hueValue = [array.firstObject floatValue];
        _saturationValue = [array[1] floatValue];
        _lightnessValue = [array[2] floatValue];
        for (VESlider *slider in _sliders) {
            if (slider.tag == 0) {
                slider.value = _hueValue;
            }
            else if (slider.tag == 1) {
                slider.value = _saturationValue;
            }
            else {
                slider.value = _lightnessValue;
            }
        }
    }
}

- (void)beginScrub:(UISlider *)slider {
    [self changeValue:slider];
    _valueLbl.hidden = NO;
}

- (void)scrub:(UISlider *)slider {
    [self changeValue:slider];
}

- (void)endScrub:(UISlider *)slider {
    _valueLbl.hidden = YES;
    [self changeValue:slider];
}

- (void)changeValue:(UISlider *)slider {
    if (slider.tag == 0) {
        _hueValue = slider.value;
    }
    else if (slider.tag == 1) {
        _saturationValue = slider.value;
    }
    else {
        _lightnessValue = slider.value;
    }
    CGRect rect = [slider thumbRectForBounds:CGRectMake(0, 0, slider.currentThumbImage.size.width, slider.currentThumbImage.size.height) trackRect:slider.frame value:slider.value];
    _valueLbl.center = CGPointMake(rect.origin.x + slider.currentThumbImage.size.width/2.0, slider.center.y - _valueLbl.frame.size.height + 2);
    _valueLbl.text = [NSString stringWithFormat:@"%.0f",(slider.value * 100.0)];
    
    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:_hueValue], [NSNumber numberWithFloat:_saturationValue], [NSNumber numberWithFloat:_lightnessValue], nil];
    switch (_colorIndex - 1) {
        case 0:
        {
            _hsl.hsl_red = array;
        }
            break;
        case 1:
        {
            _hsl.hsl_orange = array;
        }
            break;
        case 2:
        {
            _hsl.hsl_yellow = array;
        }
            break;
        case 3:
        {
            _hsl.hsl_green = array;
        }
            break;
#ifdef kJYResources
        case 4:
        {
            _hsl.hsl_cyan = array;
        }
            break;
        case 5:
        {
            _hsl.hsl_blue = array;
        }
            break;
        case 6:
        {
            _hsl.hsl_purple = array;
        }
            break;
        case 7:
        {
            _hsl.hsl_magenta = array;
        }
            break;
#else
        case 4:
        {
            _hsl.hsl_blue = array;
        }
            break;
        case 5:
        {
            _hsl.hsl_purple = array;
        }
            break;
        case 6:
        {
            _hsl.hsl_magenta = array;
        }
            break;
#endif
            
        default:
            break;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(changingAdjustHSL)]) {
        [_delegate changingAdjustHSL];
    }
}

@end
