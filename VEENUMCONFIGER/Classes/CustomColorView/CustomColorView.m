//
//  CustomColorView.m
//  PEImageInfo
//
//  Created by emmet-mac on 2023/4/23.
//

#import "CustomColorView.h"
#import <VEENUMCONFIGER/VEENUMCONFIGER.h>
@implementation ColorButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.cornerRadius = frame.size.height / 2.0;
        self.layer.masksToBounds = YES;
        self.selectedView.hidden = YES;
    }
    return self;
}

- (UIView *)selectedView{
    if(!_selectedView){
        _selectedView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4)];
        _selectedView.layer.borderColor = UIColorFromRGB(0x111111).CGColor;
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            _selectedView.layer.borderColor = UIColorFromRGB(0xf9f9f9).CGColor;
        }
        _selectedView.layer.borderWidth = 3;
        _selectedView.layer.cornerRadius = CGRectGetWidth(_selectedView.frame)/2.0;
        _selectedView.layer.masksToBounds = YES;
        _selectedView.hidden = YES;
        [self addSubview:_selectedView];
    }
    return _selectedView;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.selectedView.frame = CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4);
    _selectedView.layer.cornerRadius = CGRectGetWidth(_selectedView.frame)/2.0;
    if([self.backgroundColor isEqual:UIColorFromRGB(0x000000)] || [self.backgroundColor isEqual:UIColorFromRGB(0x111111)]){
        self.selectedView.layer.borderColor = UIColorFromRGB(0x272727).CGColor;
    }else{
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            self.selectedView.layer.borderColor = UIColorFromRGB(0xf9f9f9).CGColor;
        }else{
            self.selectedView.layer.borderColor = UIColorFromRGB(0x111111).CGColor;
        }
    }
    if(selected){
        self.selectedView.hidden = NO;
    }else{
        self.selectedView.hidden = YES;
    }
}
@end


@implementation CustomColorView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = UIColorFromRGB(0x1a1a1a);
    if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
        self.backgroundColor = [VEConfigManager sharedManager].viewBackgroundColor;
    }
    [VEHelp addShadowToView:self withColor:UIColorFromRGB(0x000000)];
   
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    [self addSubview:titleView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:titleView.bounds];
    titleLbl.text = VELocalizedString(@"Color Palette", nil);
    titleLbl.textColor = TEXT_COLOR;
    if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
        titleLbl.textColor = UIColorFromRGB(0x131313);
    }
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:16];
    [titleView addSubview:titleLbl];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, 0, 44, 44)];
    [closeBtn setImage:[VEHelp imageWithContentOfFile:@"background/Close_Bottom_44_@3x"] forState:UIControlStateNormal];
    if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
        [closeBtn setImage:[VEHelp imageWithContentOfFile:@"左上角叉_默认_@3x"] forState:UIControlStateNormal];
    }
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeBtn];
    
    UIButton *finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 48, 0, 44, 44)];
    [finishBtn setImage:[VEHelp imageWithContentOfFile:@"/剪辑_勾_@3x"] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:finishBtn];
    {
        _customColorView = [[UIView alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(titleView.frame) + 12, self.frame.size.width - 24 * 2, self.frame.size.height * 0.47)];
        [self addSubview:_customColorView];
        
        _customShowColorView = [[ColorDragView alloc] initWithFrame:_customColorView.bounds];
        _customShowColorView.delegate = self;
        [_customColorView addSubview:_customShowColorView];
    }
    
    {
        _sliderBgView = [[UIImageView alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(_customColorView.frame) + ((self.frame.size.height - CGRectGetMaxY(_customColorView.frame)) / 2.0 - 12) / 2.0, self.frame.size.width - 24 * 2, 12)];
        _sliderBgView.image = [VEHelp imageNamed:@"色带.png" atBundle:[VEHelp getEditBundle]];
        _sliderBgView.contentMode = UIViewContentModeScaleAspectFill;
        _sliderBgView.layer.cornerRadius = 6;
        _sliderBgView.layer.masksToBounds = YES;
        [self addSubview:_sliderBgView];
//        [VEHelp insertColorGradient:_sliderBgView colors:self.colors];
        _moreColorSlider = [[VESlider alloc] initWithFrame:CGRectMake(CGRectGetMinX(_sliderBgView.frame), CGRectGetMinY(_sliderBgView.frame) - (30 - _sliderBgView.frame.size.height) / 2.0, CGRectGetWidth(_sliderBgView.frame), 30)];
        _moreColorSlider.minimumValue = 0.0;
        _moreColorSlider.maximumValue = 1.0;
        [_moreColorSlider setMinimumTrackTintColor:UIColor.clearColor];
        [_moreColorSlider setMaximumTrackTintColor:UIColor.clearColor];
        [_moreColorSlider setThumbImage:[VEHelp imageWithContentOfFile:@"background/Color_ThumbImage_@3x"] forState:UIControlStateNormal];
        _moreColorSlider.value = 1.0;
        [self addSubview:_moreColorSlider];
        [_moreColorSlider addTarget:self action:@selector(colorSliderChange) forControlEvents:UIControlEventValueChanged];
        [self colorSliderChange];
    }
    
    {
        {
            _otherColorAddBtn = [[UIButton alloc] initWithFrame:CGRectMake(_sliderBgView.frame.origin.x, self.frame.size.height - (self.frame.size.height - CGRectGetMaxY(_customShowColorView.frame)) / 2.0 + ((self.frame.size.height - CGRectGetMaxY(_customShowColorView.frame)) / 2.0 - 28) / 2.0, 60, 28)];
            _otherColorAddBtn.layer.cornerRadius = 14;
            _otherColorAddBtn.layer.masksToBounds = YES;
            _otherColorAddBtn.layer.borderWidth = 0;
            [_otherColorAddBtn setImage:[VEHelp imageNamed:@"background/Add_Color_@3x" atBundle:[VEHelp getBundleName:@"VEEditSDK"]] forState:UIControlStateNormal];
            [_otherColorAddBtn setTitle:VELocalizedString(@"添加", nil) forState:UIControlStateNormal];
            [_otherColorAddBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            _otherColorAddBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            _otherColorAddBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
            _otherColorAddBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            [_otherColorAddBtn addTarget:self action:@selector(otherColorAddAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_otherColorAddBtn];
            [_customShowColorView setdefaultColor:nil];
        }
        
        _otherColorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_otherColorAddBtn.frame) + 20, CGRectGetMinY(_otherColorAddBtn.frame), self.frame.size.width - (CGRectGetMaxX(_otherColorAddBtn.frame) + 20) - _customShowColorView.frame.origin.x, 28)];
        _otherColorScrollView.showsVerticalScrollIndicator = NO;
        _otherColorScrollView.showsHorizontalScrollIndicator = NO;
        _otherColorScrollView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        NSString *path = [kVEDirectory stringByAppendingPathComponent:@"otherColors.plist"];
        self.otherColors = [NSMutableArray arrayWithContentsOfFile:path];
        if(!self.otherColors){
            self.otherColors = [NSMutableArray new];
        }
        [self refreshOtherColorScrollView];
        [self addSubview:_otherColorScrollView];
        {
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_otherColorScrollView.frame), CGRectGetMinY(_otherColorAddBtn.frame), 10, 28)];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                line.image =  [VEHelp imageNamed:@"颜色-过度1" atBundle:[VEHelp getBundleName:@"VEEditSDK"]];
            }else{
                line.image =  [VEHelp imageNamed:@"颜色-过度" atBundle:[VEHelp getBundleName:@"VEEditSDK"]];
            }
            [self addSubview:line];
        }
        
    }
}

- (void)closeView {
    [_customShowColorView.strawLayer removeFromSuperlayer];
    if([_delegate respondsToSelector:@selector(colorViewCancelChangeColor:)]){
        [_delegate colorViewCancelChangeColor:self];
    }
    CGRect rect = self.frame;
    if([VEConfigManager sharedManager].iPad_HD){
        rect.origin.x += rect.size.width;
    }else{
        rect.origin.y += rect.size.height;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)doneAction:(UIButton *)sender{
    [_customShowColorView.strawLayer removeFromSuperlayer];
    if([_delegate respondsToSelector:@selector(colorViewClose_View:)]){
        [_delegate colorViewClose_View:self];
    }
    CGRect rect = self.frame;
    if([VEConfigManager sharedManager].iPad_HD){
        rect.origin.x += rect.size.width;
    }else{
        rect.origin.y += rect.size.height;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)colorSliderChange{
    float centerx = MIN(_moreColorSlider.value * _sliderBgView.image.size.width, _sliderBgView.image.size.width - 5);
    UIColor *color = [VEHelp colorAtPixel:CGPointMake(centerx, _sliderBgView.image.size.height/2.0) source:_sliderBgView.image];
    [self setSelectDragColor:color];
}

- (void)setSelectDragColor:(UIColor *)color{
    
    [self setOtherColor:color];
    
    _otherColorAddBtn.backgroundColor = color;
    
    [_customShowColorView resetColor];
}

- (UIImage *)drawImage:(UIImage *)image bgImage:(UIImage *)bgImage size:(CGSize)size
{
   @autoreleasepool {
       UIGraphicsBeginImageContext(CGSizeMake(((int)size.width), ((int)size.height)));
       [bgImage drawInRect:CGRectMake(0, 0, ((int)size.width), ((int)size.height))];
       [image drawInRect:CGRectMake((size.width - image.size.width)/2.0, (size.height - image.size.height)/2.0, ((int)image.size.width), ((int)image.size.height))];
       UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
       UIGraphicsEndImageContext();
       return scaledImage;
   }
}
- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    CGImageRef imgRef = [image CGImage];
    CGImageRef maskRef = [maskImage CGImage];
    CGImageRef actualMask = CGImageMaskCreate(
              CGImageGetWidth(maskRef),
              CGImageGetHeight(maskRef),
              CGImageGetBitsPerComponent(maskRef),
              CGImageGetBitsPerPixel(maskRef),
              CGImageGetBytesPerRow(maskRef),
              CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef masked = CGImageCreateWithMask(imgRef, actualMask);
    return [UIImage imageWithCGImage:masked];
}

- (void)refreshOtherColorScrollView{
    [_otherColorScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    float space = 12;
    int count = _otherColorScrollView.frame.size.width / (_otherColorScrollView.frame.size.height + space);
    for (int i = 0; i < count; i++) {
        ColorButton *btn = [[ColorButton alloc] initWithFrame:CGRectMake((_otherColorScrollView.frame.size.height + space) * i, 0, _otherColorScrollView.frame.size.height, _otherColorScrollView.frame.size.height)];
        btn.layer.cornerRadius = btn.frame.size.width / 2.0;
        btn.layer.masksToBounds = YES;
        if(self.otherColors.count > i){
            btn.backgroundColor = [self RedoColorWithHexString:_otherColors[i]];
            btn.layer.borderWidth = 0;
            if (i == _selectColorIndex) {
                btn.selected = YES;
            }else {
                btn.selected = NO;
            }
            [btn addTarget:self action:@selector(lastColorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [btn setBackgroundImage:[VEHelp imageWithContentOfFile:@"background/Color_none_@3x"] forState:UIControlStateNormal];
        }
        [_otherColorScrollView addSubview:btn];
        
        btn.tag = 100 + i;
    }
    _otherColorScrollView.contentSize = CGSizeMake(MAX(_otherColorScrollView.frame.size.width, (_otherColorScrollView.frame.size.height + space) * count - space), 0);
}

- (void)lastColorBtnAction:(UIButton *)sender{
    if (_selectColorIndex != sender.tag - 100) {
        UIButton *prevBtn = [_otherColorScrollView viewWithTag:(100 + _selectColorIndex)];
        prevBtn.selected = NO;
        
        _selectColorIndex = sender.tag - 100;
        sender.selected = YES;
        _currentColor = sender.backgroundColor;
        if (_delegate && [_delegate respondsToSelector:@selector(colorViewChangeColor:)]) {
            [_delegate colorViewChangeColor:sender.backgroundColor];
        }
    }
}

// 自定义： rgb -> hsv
- (NSMutableArray *)getHSVWithRGB:(UIColor *)color{
    
    CGFloat h = 0.0;
    CGFloat s = 0.0;
    CGFloat v = 0.0;
    
    CGFloat var_R = 0.0;                    //RGB from 0 to 255
    CGFloat var_G = 0.0;
    CGFloat var_B = 0.0;
    CGFloat var_A = 0.0;
    [color getRed:&var_R green:&var_G blue:&var_B alpha:&var_A];

    CGFloat var_Min = MIN(var_R, MIN(var_G, var_B));    //Min. value of RGB
    CGFloat var_Max = MAX(var_R, MAX(var_G, var_B));  //Max. value of RGB
    CGFloat del_Max = var_Max - var_Min;             //Delta RGB value

    v = var_Max;

    if ( del_Max == 0 ){                     //This is a gray, no chroma...{
        h = 0;                                //HSV results from 0 to 1
        s = 0;
    }else{                                    //Chromatic data...
        s = del_Max / var_Max;
        CGFloat del_R = ( ( ( var_Max - var_R ) / 6.0 ) + ( del_Max / 2.0 ) ) / del_Max;
        CGFloat del_G = ( ( ( var_Max - var_G ) / 6.0 ) + ( del_Max / 2.0 ) ) / del_Max;
        CGFloat del_B = ( ( ( var_Max - var_B ) / 6.0 ) + ( del_Max / 2.0 ) ) / del_Max;
        if( var_R == var_Max ){
            h = del_B - del_G;
        }else if ( var_G == var_Max ){
            h = ( 1 / 3.0 ) + del_R - del_B;
        }else if (var_B == var_Max) {
            h = ( 2 / 3.0 ) + del_G - del_R;
        }
        if ( h < 0 )  {
            h += 1;
        }else if (h > 1){
            h -= 1;
        }
    }
    
    NSMutableArray *hsv = [NSMutableArray new];
    [hsv addObject:[NSNumber numberWithFloat:h]];
    [hsv addObject:[NSNumber numberWithFloat:s]];
    [hsv addObject:[NSNumber numberWithFloat:v]];
    return hsv;
}

- (void)setSelectColor:(UIColor *) color
{
    NSMutableArray *hsv = [self getHSVWithRGB:color];
    CGFloat hue = [hsv[0] floatValue];            //H
    CGFloat saturation = [hsv[1] floatValue];  //S
    CGFloat brightness = [hsv[2] floatValue]; //V
    CGFloat alpha  = 0.0;
    
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    _moreColorSlider.value = (1.0 - hue);
    [self colorSliderChange];
    float centerX = _customShowColorView.bounds.size.width*(saturation*0.9 + 0.1);
    float centerY = _customShowColorView.bounds.size.height*((1.0 - (0.9 *brightness)));
    CGPoint center = CGPointMake(centerX, centerY);
    
    [_customShowColorView setFocusViewCenter:center];
    
    
}

- (void)otherColorAddAction:(UIButton *)sender{
    if (_selectColorIndex != 100) {
        UIButton *prevBtn = [_colorView viewWithTag:(100 + _selectColorIndex)];
        prevBtn.selected = NO;
        
        _selectColorIndex = 0;
        _currentColor = sender.backgroundColor;
        if (_delegate && [_delegate respondsToSelector:@selector(colorViewChangeColor:)]) {
            [_delegate colorViewChangeColor:sender.backgroundColor];
        }
    }
    NSString *str = [self UIColorToHexString:sender.backgroundColor];
    if([self.otherColors containsObject:str]){
        [self.otherColors removeObject:str];
    }
    [self.otherColors insertObject:str atIndex:0];
    if(self.otherColors.count > 20){
        [self.otherColors removeObjectsInRange:NSMakeRange(20, self.otherColors.count - 20)];
    }
    NSString *path = [kVEDirectory stringByAppendingPathComponent:@"otherColors.plist"];
    BOOL suc = [self.otherColors writeToFile:path atomically:YES];
    if(suc){
        NSLog(@"suc:%d",suc);
    }
    [self refreshOtherColorScrollView];
    //[self setOtherColor:sender.backgroundColor];
    
}
- (NSString *) UIColorToHexString:(UIColor *)uiColor{
    CGFloat red,green,blue,alpha;
    [uiColor getRed:&red green:&green blue:&blue alpha:&alpha];

    NSString *hexString  = [NSString stringWithFormat:@"%f:%f:%f:%f",red,green,blue,alpha];
    return hexString;
}

- (UIColor *) RedoColorWithHexString:(NSString *)strColor{
    NSArray *colorList = [strColor componentsSeparatedByString:@":"];
    UIColor *color = [UIColor blackColor];
    if(colorList.count == 4){
        color = [UIColor colorWithRed:[colorList[0] floatValue] green:[colorList[1] floatValue] blue:[colorList[2] floatValue] alpha:[colorList[3] floatValue]];
    }
    return color;
}

- (void)moreColorsBtnAction:(UIButton *)sender{
    _moreColorsBtn.selected = !_moreColorsBtn.selected;
}

- (NSMutableArray *)colors{
    if(!_colors){
        _colors = [VEHelp getColorList];
    }
    return _colors;
}

- (NSMutableArray *)otherColors{
    if(!_otherColors){
        _otherColors = [NSMutableArray new];
    }
    return _otherColors;
}
- (void)setOtherColor:(UIColor *)color{
    UIColor *colorOne = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    UIColor *colorTwo = color;
    
    if(_customShowColorView.endlayer){
        [_customShowColorView.endlayer removeFromSuperlayer];
        _customShowColorView.endlayer = nil;
    }
    if(_customShowColorView.headerLayer){
        [_customShowColorView.headerLayer removeFromSuperlayer];
        _customShowColorView.headerLayer = nil;
    }
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor,nil];
    _customShowColorView.headerLayer = [CAGradientLayer layer];
    _customShowColorView.headerLayer.colors = colors;
    colors = nil;
    colorOne = nil;
    colorTwo = nil;
    _customShowColorView.headerLayer.frame = CGRectMake(0, 0, _customShowColorView.frame.size.width, _customShowColorView.frame.size.height);
    _customShowColorView.headerLayer.startPoint = CGPointMake(0, 0);
    _customShowColorView.headerLayer.endPoint = CGPointMake(1.0, 0);
    
    NSArray *color1s = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, [UIColor blackColor].CGColor,nil];
    _customShowColorView.endlayer = [CAGradientLayer layer];
    _customShowColorView.endlayer.colors = color1s;
    _customShowColorView.endlayer.frame = CGRectMake(0, 0, _customShowColorView.frame.size.width, _customShowColorView.frame.size.height + 5);
    _customShowColorView.endlayer.startPoint = CGPointMake(0, 0);
    _customShowColorView.endlayer.endPoint = CGPointMake(0, 1);
    _customShowColorView.endlayer.locations = @[@0.1,@1.0];
    _customShowColorView.endlayer.masksToBounds = YES;
    [_customShowColorView.headerLayer addSublayer:_customShowColorView.endlayer];
    [_customShowColorView.layer insertSublayer:_customShowColorView.headerLayer atIndex:0];
}

- (void)changeDragViewColorIndex:(NSInteger )selectColorIndex{
    
    [self lastColorBtnAction:[_colorView viewWithTag:selectColorIndex + 100]];

}
- (void)changeDragViewColor:(UIColor *)color isDragEnd:(BOOL)isDragEnd{
#if 0
    UIImage *imgCircleMask = [VEHelp imageNamed:@"拖动球1@3x.png"];
    CGSize size = CGSizeMake(imgCircleMask.size.width*3.0, imgCircleMask.size.height*3.0);
    UIImage *imgToBeMasked = [VEHelp imageWithColor:color size:CGSizeMake(size.width - 6, size.height - 6) cornerRadius:(size.width - 6)/2.0];

    UIImage * finalImage = [self drawImage:imgToBeMasked bgImage:imgCircleMask size:(CGSize)size];

    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"imgCircleMask@3x.png"];
    unlink([path UTF8String]);
    [UIImagePNGRepresentation(finalImage) writeToFile:path atomically:YES];
    
    UIImage * newFinalImage = [UIImage imageWithContentsOfFile:path];
    [_moreColorSlider setThumbImage:newFinalImage forState:UIControlStateNormal];
#endif
    _currentColor = color;
    _otherColorAddBtn.backgroundColor = color;
    if (_delegate && [_delegate respondsToSelector:@selector(colorViewChangeColor:)]) {
        [_delegate colorViewChangeColor:color];
    }
}

- (void)dealloc {
    [_customShowColorView.strawLayer removeFromSuperlayer];    
}

@end
