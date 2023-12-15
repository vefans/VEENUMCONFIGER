//
//  Adjust_SeparationView.m
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/4/24.
//

#import "Adjust_SeparationView.h"
#import "CustomColorView.h"
#import "VESlider.h"
#import "VEHelp.h"
#import "VEColorButton.h"

@interface Adjust_SeparationView ()
{
    NSArray *_colorArray;
    UIScrollView *_colorScrollView;
    UILabel *_valueLbl;
    NSInteger _separationTypeIndex;
    VESlider *_slider;
}

@end

@implementation Adjust_SeparationView

- (instancetype)initWithFrame:(CGRect)frame highLight_shadow:(HighLightShadow *)highLight_shadow
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : [VEConfigManager sharedManager].viewBackgroundColor;
        _highLight_shadow = highLight_shadow;
        
        UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        [self addSubview:toolbarView];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:toolbarView.bounds];
        titleLbl.text = VELocalizedString(@"色调分离", nil);
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
        
        _colorArray = [VEHelp getToningSeparationColorArray];
        float width = 26.0;
        float space = 25;
        float x = (colorScrollView.frame.size.width - ((width + space) * _colorArray.count - space)) / 2.0;
        float y = (colorScrollView.frame.size.height - width) / 2.0;
        for (int i = 0; i < _colorArray.count; i++) {
            VEColorButton *itemBtn = [[VEColorButton alloc] initWithFrame:CGRectMake(x + (width + space) * i, y, width, width)];
            itemBtn.backgroundColor = _colorArray[i];
            itemBtn.tag = i + 1;
            [itemBtn addTarget:self action:@selector(colorItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == _highLight_shadow.light_mode) {
                itemBtn.selected = YES;
            }
            [colorScrollView addSubview:itemBtn];
        }
        
        _valueLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _valueLbl.font = [UIFont systemFontOfSize:12];
        _valueLbl.textColor = [UIColor whiteColor];
        _valueLbl.textAlignment = NSTextAlignmentCenter;
        _valueLbl.hidden = YES;
        [self addSubview:_valueLbl];
                
        VESlider *slider = [[VESlider alloc] initWithFrame:CGRectMake(63, CGRectGetMaxY(_colorScrollView.frame), frame.size.width - 63 * 2, 80)];
        slider.value = _highLight_shadow.light_value;
        [slider addTarget:self action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
        [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(endScrub:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside)];
        _slider = slider;
        [self addSubview:slider];
        
        _separationTypeIndex = 1;
        NSArray *array = @[@"高光色调", @"阴影色调"];
        UIView *tabBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 64 - kBottomSafeHeight, self.frame.size.width, 64)];
        [self addSubview:tabBarView];
        for (int i = 0; i < array.count; i++) {
            NSString *title = array[i];
            UIButton *toolItemBtn = [[UIButton alloc] init];
            if (i == 0) {
                toolItemBtn.frame = CGRectMake(frame.size.width / 2.0 - 90, 0, 80, 64);
                toolItemBtn.selected = YES;
            }else {
                toolItemBtn.frame = CGRectMake(frame.size.width / 2.0 + 10, 0, 80, 64);
            }
            NSString *imagePath = [NSString stringWithFormat:@"/jianji/Adjust/剪辑-调色_%@默认", title];
            [toolItemBtn setImage:[VEHelp imageNamed:imagePath] forState:UIControlStateNormal];
            imagePath = [NSString stringWithFormat:@"/jianji/Adjust/剪辑-调色_%@选中", title];
            UIImage *selectedImage = [VEHelp imageNamed:imagePath];
            if([VEConfigManager sharedManager].toolsTitleColor){
                [toolItemBtn setImage:selectedImage forState:UIControlStateSelected];
            }else{
                selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [toolItemBtn setImage:selectedImage forState:UIControlStateSelected];
                if(![VEConfigManager sharedManager].iPad_HD)
                toolItemBtn.imageView.tintColor = Main_Color;
            }
            [toolItemBtn setTitle:VELocalizedString(title, nil) forState:UIControlStateNormal];
            [toolItemBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            [toolItemBtn setTitleColor:Main_Color forState:UIControlStateSelected];
            if([VEConfigManager sharedManager].toolsTitleColor){
                [toolItemBtn setTitleColor:[VEConfigManager sharedManager].toolsTitleColor forState:UIControlStateNormal];
            }
            toolItemBtn.titleLabel.font = [UIFont systemFontOfSize:10];
            [toolItemBtn layoutButtonWithEdgeInsetsStyle:VEButtonEdgeInsetsStyleTop imageTitleSpace:0];
            toolItemBtn.tag = i + 1;
            [toolItemBtn addTarget:self action:@selector(clickToolItemBtn:) forControlEvents:UIControlEventTouchUpInside];
            [tabBarView addSubview:toolItemBtn];
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
    if (_separationTypeIndex == 1) {
        VEColorButton *prevBtn = [_colorScrollView viewWithTag:(_highLight_shadow.light_mode + 1)];
        prevBtn.selected = NO;
    }else {
        VEColorButton *prevBtn = [_colorScrollView viewWithTag:(_highLight_shadow.shadow_mode + 1)];
        prevBtn.selected = NO;
    }
    VEColorButton *currentBtn = [_colorScrollView viewWithTag:1];
    currentBtn.selected = YES;
    _highLight_shadow.light_mode = 0;
    _highLight_shadow.light_value = 0;
    _highLight_shadow.shadow_mode = 0;
    _highLight_shadow.shadow_value = 0;
    _slider.value = 0;
    if (_delegate && [_delegate respondsToSelector:@selector(resetAdjustSeparation:)]) {
        [_delegate resetAdjustSeparation:self];
    }
}

- (void)finishBtnAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(completionAdjustSeparation:)]) {
        [_delegate completionAdjustSeparation:self];
    }
    WeakSelf(self);
    CGRect rect = self.frame;
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.frame = CGRectMake(rect.origin.x, rect.size.height + rect.origin.y, rect.size.width, 0);
    } completion:^(BOOL finished) {
        weakSelf.frame = rect;
        [weakSelf removeFromSuperview];
    }];
}

- (void)colorItemBtnAction:(UIButton *)sender {
    if (!sender.selected) {
        if (_separationTypeIndex == 1) {
            VEColorButton *prevBtn = [sender.superview viewWithTag:(_highLight_shadow.light_mode + 1)];
            prevBtn.selected = NO;
            
            _highLight_shadow.light_mode = (int)sender.tag - 1;
            _highLight_shadow.light_value = 0;
            _slider.value = 0;
        }else {
            VEColorButton *prevBtn = [sender.superview viewWithTag:(_highLight_shadow.shadow_mode + 1)];
            prevBtn.selected = NO;
            
            _highLight_shadow.shadow_mode = (int)sender.tag - 1;
            _highLight_shadow.shadow_value = 0;
            _slider.value = 0;
        }
        sender.selected = YES;
        
        if (_delegate && [_delegate respondsToSelector:@selector(changingAdjustSeparation)]) {
            [_delegate changingAdjustSeparation];
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
    if (_separationTypeIndex == 1) {
        _highLight_shadow.light_value = slider.value;
    }
    else {
        _highLight_shadow.shadow_value = slider.value;
    }
    CGRect rect = [slider thumbRectForBounds:CGRectMake(0, 0, slider.currentThumbImage.size.width, slider.currentThumbImage.size.height) trackRect:slider.frame value:slider.value];
    _valueLbl.center = CGPointMake(rect.origin.x + slider.currentThumbImage.size.width/2.0, slider.center.y - _valueLbl.frame.size.height + 2);
    _valueLbl.text = [NSString stringWithFormat:@"%.0f",(slider.value * 100.0)];
    
    if (_delegate && [_delegate respondsToSelector:@selector(changingAdjustSeparation)]) {
        [_delegate changingAdjustSeparation];
    }
}

- (void)clickToolItemBtn:(UIButton *)sender {
    if (!sender.selected) {
        UIButton *prevBtn = [sender.superview viewWithTag:_separationTypeIndex];
        prevBtn.selected = NO;
        sender.selected = YES;
        _separationTypeIndex = sender.tag;
        if (_separationTypeIndex == 1) {
            VEColorButton *prevBtn = [_colorScrollView viewWithTag:(_highLight_shadow.shadow_mode + 1)];
            prevBtn.selected = NO;
            
            VEColorButton *currentBtn = [_colorScrollView viewWithTag:(_highLight_shadow.light_mode + 1)];
            currentBtn.selected = YES;
            _slider.value = _highLight_shadow.light_value;
        }else {
            VEColorButton *prevBtn = [_colorScrollView viewWithTag:(_highLight_shadow.light_mode + 1)];
            prevBtn.selected = NO;
            
            VEColorButton *currentBtn = [_colorScrollView viewWithTag:(_highLight_shadow.shadow_mode + 1)];
            currentBtn.selected = YES;
            _slider.value = _highLight_shadow.shadow_value;
        }
    }
}

@end
