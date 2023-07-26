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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = UIColorFromRGB(0x1a1a1a);
    [VEHelp addShadowToView:self withColor:UIColorFromRGB(0x000000)];
   
    _colorBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44 - 44, self.frame.size.width, 44)];
    [self addSubview:_colorBottomView];
    {
        _customColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, CGRectGetMinY(_colorBottomView.frame) - 20 - kBottomSafeHeight)];
        _customShowColorView = [[ColorDragView alloc] initWithFrame:CGRectMake(20, 20, _customColorView.frame.size.width - 40, _customColorView.frame.size.height - 64)];
        _customShowColorView.layer.cornerRadius = 10;
        _customShowColorView.layer.masksToBounds = YES;
        _customShowColorView.layer.borderWidth = 1;
        _customShowColorView.delegate = self;
        _customShowColorView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
        [_customColorView addSubview:_customShowColorView];
        _customColorView.hidden = NO;
        [self addSubview:_customColorView];
    }
    
    {
        _sliderBgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_customShowColorView.frame) + 10 + 14, self.frame.size.width - 40, 2)];
        _sliderBgView.image = [VEHelp imageNamed:@"色带.png" atBundle:[VEHelp getEditBundle]];
        _sliderBgView.contentMode = UIViewContentModeScaleAspectFill;
        _sliderBgView.layer.masksToBounds = YES;
        [_customColorView addSubview:_sliderBgView];
//        [VEHelp insertColorGradient:_sliderBgView colors:self.colors];
        _moreColorSlider = [[VESlider alloc] initWithFrame:CGRectMake(CGRectGetMinX(_sliderBgView.frame), CGRectGetMinY(_sliderBgView.frame) - 15, CGRectGetWidth(_sliderBgView.frame), 30)];
        _moreColorSlider.minimumValue = 0.0;
        _moreColorSlider.maximumValue = 1.0;
        [_moreColorSlider setMinimumTrackTintColor:UIColor.clearColor];
        [_moreColorSlider setMaximumTrackTintColor:UIColor.clearColor];
        _moreColorSlider.value = 1.0;
        [_customColorView addSubview:_moreColorSlider];
        [_moreColorSlider addTarget:self action:@selector(colorSliderChange) forControlEvents:UIControlEventValueChanged];
        [self colorSliderChange];
    }
    
    {
        {
            _otherColorAddBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(self.frame)  - 44 - 44 - 12 - kBottomSafeHeight, 28, 28)];
            _otherColorAddBtn.layer.cornerRadius = 14;
            _otherColorAddBtn.layer.masksToBounds = YES;
            _otherColorAddBtn.layer.borderWidth = 0;
            [_otherColorAddBtn setImage:[VEHelp imageNamed:@"jianji/剪辑_添加1默认_" atBundle:[VEHelp getBundleName:@"VEEditSDK"]] forState:UIControlStateNormal];
            [_otherColorAddBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_otherColorAddBtn addTarget:self action:@selector(otherColorAddAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_otherColorAddBtn];
            [_customShowColorView setdefaultColor:nil];
        }
        
        _otherColorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_otherColorAddBtn.frame) + 10, CGRectGetMinY(_otherColorAddBtn.frame) - 1 , self.frame.size.width - (CGRectGetMaxX(_otherColorAddBtn.frame) + 10), 30)];
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
            line.image =  [VEHelp imageNamed:@"颜色-过度" atBundle:[VEHelp getBundleName:@"VEEditSDK"]];
            [self addSubview:line];
        }
        
    }
    
    {
        _doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetHeight(self.frame)  - 44 - kBottomSafeHeight , self.frame.size.width - 40, 34)];
        _doneBtn.backgroundColor = UIColorFromRGB(0x272727);
        _doneBtn.layer.cornerRadius = 17;
        _doneBtn.layer.masksToBounds = YES;
        [_doneBtn setTitle:VELocalizedString(@"完成", nil) forState:UIControlStateNormal];
        [_doneBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        _doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_doneBtn];
    }
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
    float contentx = 0;
    float contenty = 1;
    for (int i = 0; i < 20; i++) {
        ColorButton *btn = [[ColorButton alloc] initWithFrame:CGRectMake( contentx, contenty, 28, 28)];
        btn.layer.cornerRadius = 14;
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
        }else{
            
            btn.layer.cornerRadius = CGRectGetWidth(btn.bounds)/2;
            CAShapeLayer *borderLayer = [CAShapeLayer layer];
            borderLayer.bounds = CGRectMake(0, 0, CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame));
            borderLayer.position = CGPointMake(CGRectGetMidX(btn.bounds), CGRectGetMidY(btn.bounds));
            //圆形,圆角
            borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:CGRectGetWidth(borderLayer.bounds)/2].CGPath;
            borderLayer.lineWidth = 1;
            //虚线边框
            borderLayer.lineDashPattern = @[@2, @2];
            //实线边框
            //    borderLayer.lineDashPattern = nil;
            borderLayer.fillColor = [UIColor clearColor].CGColor;
            borderLayer.strokeColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
            [btn.layer addSublayer:borderLayer];
        }
        [_otherColorScrollView addSubview:btn];
        
        btn.tag = 100 + i;
        contentx += 40;
    }
    _otherColorScrollView.contentSize = CGSizeMake( contentx, _otherColorScrollView.frame.size.height);
}

- (void)lastColorBtnAction:(UIButton *)sender{
    if (_selectColorIndex != sender.tag - 100) {
        UIButton *prevBtn = [_otherColorScrollView viewWithTag:(100 + _selectColorIndex)];
        prevBtn.selected = NO;
        
        _selectColorIndex = sender.tag - 100;
        sender.selected = YES;
        
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
//        [_colors addObject:UIColorFromRGB(0xffffff)];//0
//        [_colors addObject:UIColorFromRGB(0xbfbfbf)];//1
//        [_colors addObject:UIColorFromRGB(0x878787)];//2
//        [_colors addObject:UIColorFromRGB(0x535353)];//3
//        [_colors addObject:UIColorFromRGB(0x000000)];//4
//        [_colors addObject:UIColorFromRGB(0xf8bfc7)];//5
//        [_colors addObject:UIColorFromRGB(0xf1736d)];//06
//        [_colors addObject:UIColorFromRGB(0xee3842)];//7
//        [_colors addObject:UIColorFromRGB(0xed002b)];//预设效果_02 //08
//        [_colors addObject:UIColorFromRGB(0xa50816)];//09
//        [_colors addObject:UIColorFromRGB(0xfad9a2)];//010
//        [_colors addObject:UIColorFromRGB(0xf4c76c)];//011
//        [_colors addObject:UIColorFromRGB(0xf17732)];//012
//        [_colors addObject:UIColorFromRGB(0xed260b)];//013
//        [_colors addObject:UIColorFromRGB(0xaf160d)];//014
//        [_colors addObject:UIColorFromRGB(0xfdf9b8)];//015
//        [_colors addObject:UIColorFromRGB(0xfeff7a)];//016
//        [_colors addObject:UIColorFromRGB(0xfbe80d)];//预设效果_03 //017
//        [_colors addObject:UIColorFromRGB(0xf5af0a)];//018
//        [_colors addObject:UIColorFromRGB(0xef5409)];//019
//        [_colors addObject:UIColorFromRGB(0xf5aac4)];//020
//        [_colors addObject:UIColorFromRGB(0xf1679a)];//021
//        [_colors addObject:UIColorFromRGB(0xee246e)];//022
//        [_colors addObject:UIColorFromRGB(0xed0045)];//023
//        [_colors addObject:UIColorFromRGB(0x94004f)];//024
//        [_colors addObject:UIColorFromRGB(0xd9aee1)];//025
//        [_colors addObject:UIColorFromRGB(0xe261fa)];//026
//        [_colors addObject:UIColorFromRGB(0xd40dfa)];//027
//        [_colors addObject:UIColorFromRGB(0xb000f5)];//028
//        [_colors addObject:UIColorFromRGB(0x4900a1)];//029
//        [_colors addObject:UIColorFromRGB(0xc6b4e2)];//030
//        [_colors addObject:UIColorFromRGB(0xa36bff)];//031
//        [_colors addObject:UIColorFromRGB(0x723cff)];//032
//        [_colors addObject:UIColorFromRGB(0x5000fe)];//033
//        [_colors addObject:UIColorFromRGB(0x2e00a9)];//034
//        [_colors addObject:UIColorFromRGB(0xaed6fa)];//035
//        [_colors addObject:UIColorFromRGB(0x6f9eff)];//036
//        [_colors addObject:UIColorFromRGB(0x3671ff)];//037
//        [_colors addObject:UIColorFromRGB(0x2353fd)];//038
//        [_colors addObject:UIColorFromRGB(0x162cbd)];//039
//        [_colors addObject:UIColorFromRGB(0xa4e6ed)];//040
//        [_colors addObject:UIColorFromRGB(0x76fffc)];//041
//        [_colors addObject:UIColorFromRGB(0x51ffff)];//042
//        [_colors addObject:UIColorFromRGB(0x47dfff)];//043
//        [_colors addObject:UIColorFromRGB(0x1f6469)];//044
//        [_colors addObject:UIColorFromRGB(0xa3d9a0)];//045
//        [_colors addObject:UIColorFromRGB(0xa4d7d3)];//046
//        [_colors addObject:UIColorFromRGB(0x9aff82)];//047
//        [_colors addObject:UIColorFromRGB(0x59ffd0)];//048
//        [_colors addObject:UIColorFromRGB(0x47e6a6)];//预设效果_04 //049
//        [_colors addObject:UIColorFromRGB(0x206750)];//050
//        [_colors addObject:UIColorFromRGB(0xbce2bc)];//051
//        [_colors addObject:UIColorFromRGB(0xacf5bc)];//052
//        [_colors addObject:UIColorFromRGB(0x5cf19d)];//预设效果_04 //053
//        [_colors addObject:UIColorFromRGB(0x44e462)];//054
//        [_colors addObject:UIColorFromRGB(0x247930)];//055
//        [_colors addObject:UIColorFromRGB(0xecf3b6)];//056
//        [_colors addObject:UIColorFromRGB(0xf1ff6e)];//057
//        [_colors addObject:UIColorFromRGB(0xeaff33)];//058
//        [_colors addObject:UIColorFromRGB(0xbcff0b)];//059
//        [_colors addObject:UIColorFromRGB(0x5c7e04)];//060
//        [_colors addObject:UIColorFromRGB(0xccbfbc)];//061
//        [_colors addObject:UIColorFromRGB(0x8f746b)];//062
//        [_colors addObject:UIColorFromRGB(0x654338)];//063
//        [_colors addObject:UIColorFromRGB(0x4a302a)];//064
//        [_colors addObject:UIColorFromRGB(0x2f1c1b)];//065
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
    UIImage *imgCircleMask = [VEHelp imageNamed:@"拖动球1@3x.png"];
    CGSize size = CGSizeMake(imgCircleMask.size.width*3.0, imgCircleMask.size.height*3.0);
    UIImage *imgToBeMasked = [VEHelp imageWithColor:color size:CGSizeMake(size.width - 6, size.height - 6) cornerRadius:(size.width - 6)/2.0];

    UIImage * finalImage = [self drawImage:imgToBeMasked bgImage:imgCircleMask size:(CGSize)size];

    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"imgCircleMask@3x.png"];
    unlink([path UTF8String]);
    [UIImagePNGRepresentation(finalImage) writeToFile:path atomically:YES];
    
    UIImage * newFinalImage = [UIImage imageWithContentsOfFile:path];
    [_moreColorSlider setThumbImage:newFinalImage forState:UIControlStateNormal];
    _otherColorAddBtn.backgroundColor = color;
    if (_delegate && [_delegate respondsToSelector:@selector(colorViewChangeColor:)]) {
        [_delegate colorViewChangeColor:color];
    }
}

- (NSBundle *)pictureDrawBundle
{
    NSString * bundlePath = [[NSBundle bundleForClass:self.class] pathForResource: @"PEPictureDraw"  ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    return  resourceBundle;
}


@end
