//
//  VEColorView.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2019/12/26.
//  Copyright © 2019 iOS VESDK Team. All rights reserved.
//

#import "VEColorControlView.h"

@interface VEColorControlView() {
    UIScrollView *colorScrollView;
    UIButton    *currentColorButton;
    float       currentColorButtonWidth;
    VEColorControlViewType _style;
}

@end

@implementation VEColorControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        currentColorButton = nil;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(VEColorControlViewType)style {
    if (self = [super initWithFrame:frame]) {
        _style = style;
    }
    return self;
}

- (void)setColorArray:(NSArray *)colorArray {
    _colorArray = colorArray;
    if (!colorScrollView) {
        colorScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        colorScrollView.showsVerticalScrollIndicator = NO;
        colorScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:colorScrollView];
        if (_style == VEColorControlViewType_Square) {
            float width = self.frame.size.height / 2.0;
            colorScrollView.contentSize = CGSizeMake(_colorArray.count * width + 20 + 4, 0);
            @autoreleasepool {
                [_colorArray enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UIButton *colorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    colorBtn.frame = CGRectMake(width * idx + 2, 2, width, self.frame.size.height - 4);
                    colorBtn.backgroundColor = obj;
                    if (idx == 0 || idx == _colorArray.count - 1) {
                        UIRectCorner corners;
                        if (idx == 0) {
                            corners = UIRectCornerTopLeft|UIRectCornerBottomLeft;
                        }else {
                            corners = UIRectCornerTopRight|UIRectCornerBottomRight;
                        }
                        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:colorBtn.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(4.0, 4.0)];
                        CAShapeLayer *maskLayer = [CAShapeLayer layer];
                        maskLayer.frame = colorBtn.bounds;
                        maskLayer.path = maskPath.CGPath;
                        colorBtn.layer.mask = maskLayer;
                    }
                    colorBtn.tag = idx + 1;
                    [colorBtn addTarget:self action:@selector(colorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                    [colorScrollView addSubview:colorBtn];
                }];
            }
        }else if (_style == VEColorControlViewType_Circle) {
            colorScrollView.contentSize = CGSizeMake(10 + (self.frame.size.height + 10) * _colorArray.count, 0);
            [_colorArray enumerateObjectsUsingBlock:^(UIColor * _Nonnull color, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (self.frame.size.height + 10) * idx, 0, self.frame.size.height, self.frame.size.height)];
                colorBtn.backgroundColor = color;
                colorBtn.layer.cornerRadius = colorBtn.frame.size.height / 2.0;
                colorBtn.layer.masksToBounds = YES;
                colorBtn.layer.borderColor = Main_Color.CGColor;
                colorBtn.tag = idx + 1;
                [colorBtn addTarget:self action:@selector(colorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                [colorScrollView addSubview:colorBtn];
            }];
        }
    }
}

- (void)colorBtnAction:(UIButton *)sender {
    
    [self setColor_CurrentBtn:sender];
    
    if (_delegate && [_delegate respondsToSelector:@selector(colorChanged:index:colorControlView:)]) {
        [_delegate colorChanged:sender.backgroundColor index:(sender.tag - 1) colorControlView:self];
    }
}

- (void)refreshFrame:(CGRect)frame {
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = frame;
        self->colorScrollView.frame = self.bounds;
    }];
}

-(void)getColor:(UIColor *) color atColorIndex:(void (^)(int index))colorIndex
{
    __block NSUInteger index = -1;
    if( color )
    {
        CGFloat red1,green1,blue1,alpha1;
        __block CGFloat red2 = 0.0, green2 = 0.0, blue2 = 0.0,alpha2 = 0.0;
        //取出color1的背景颜色的RGBA值
        [color getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
        
        [_colorArray enumerateObjectsUsingBlock:^(UIColor * _Nonnull objColor, NSUInteger idx, BOOL * _Nonnull stop) {
            [objColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
            
            NSString *red1_str = [NSString stringWithFormat:@"%.6f", red1];
            NSString *red2_str = [NSString stringWithFormat:@"%.6f", red2];
            NSString *green1_str = [NSString stringWithFormat:@"%.6f", green1];
            NSString *green2_str = [NSString stringWithFormat:@"%.6f", green2];
            NSString *blue1_str = [NSString stringWithFormat:@"%.6f", blue1];
            NSString *blue2_str = [NSString stringWithFormat:@"%.6f", blue2];
            if ([red1_str isEqualToString:red2_str]
                && [green1_str isEqualToString:green2_str]
                && [blue1_str isEqualToString:blue2_str])
            {
                index = idx;
                *stop = TRUE;
                if( colorIndex )
                {
                    colorIndex( (int)index );
                }
            }
        }];
    }
}

-(NSInteger)setCurrentColorButtonColor:(UIColor *) color
{
    __block NSUInteger index = 0;
    if( color )
    {
        CGFloat red1,green1,blue1,alpha1;
        __block CGFloat red2 = 0.0, green2 = 0.0, blue2 = 0.0,alpha2 = 0.0;
        //取出color1的背景颜色的RGBA值
        [color getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
        if (alpha1 > 0) {
            [_colorArray enumerateObjectsUsingBlock:^(UIColor * _Nonnull objColor, NSUInteger idx, BOOL * _Nonnull stop) {
                [objColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
                
                NSString *red1_str = [NSString stringWithFormat:@"%.6f", red1];
                NSString *red2_str = [NSString stringWithFormat:@"%.6f", red2];
                NSString *green1_str = [NSString stringWithFormat:@"%.6f", green1];
                NSString *green2_str = [NSString stringWithFormat:@"%.6f", green2];
                NSString *blue1_str = [NSString stringWithFormat:@"%.6f", blue1];
                NSString *blue2_str = [NSString stringWithFormat:@"%.6f", blue2];
                if ([red1_str isEqualToString:red2_str]
                    && [green1_str isEqualToString:green2_str]
                    && [blue1_str isEqualToString:blue2_str])
                {
                    index = idx;
                    *stop = TRUE;
                }
            }];
        }
    }
    
    if( index > 0 )
    {
        [self setColor_CurrentBtn:[colorScrollView viewWithTag:index + 1]];
    }
    else
    {
        if( currentColorButton != nil )
        {
            currentColorButton.frame = CGRectMake(currentColorButton.frame.origin.x + 2, currentColorButton.frame.origin.y + 2, currentColorButton.frame.size.width - 4, currentColorButton.frame.size.height - 4);
            
            if ( (currentColorButton.tag-1) == 0 || (currentColorButton.tag-1) == _colorArray.count - 1) {
                UIRectCorner corners;
                if ((currentColorButton.tag-1) == 0) {
                    corners = UIRectCornerTopLeft|UIRectCornerBottomLeft;
                }else {
                    corners = UIRectCornerTopRight|UIRectCornerBottomRight;
                }
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:currentColorButton.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(4.0, 4.0)];
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.frame = currentColorButton.bounds;
                maskLayer.path = maskPath.CGPath;
                currentColorButton.layer.mask = maskLayer;
                
            }
            currentColorButton = nil;
        }
    }
    return index;
}

-(void)setColor_CurrentBtn:(UIButton *) sender
{
    if( currentColorButton != nil )
     {
         if (_style == VEColorControlViewType_Square) {
             currentColorButton.frame = CGRectMake(currentColorButton.frame.origin.x + 2, currentColorButton.frame.origin.y + 2, currentColorButton.frame.size.width - 4, currentColorButton.frame.size.height - 4);
             
             if ( (currentColorButton.tag-1) == 0 || (currentColorButton.tag-1) == _colorArray.count - 1) {
                 UIRectCorner corners;
                 if ((currentColorButton.tag-1) == 0) {
                     corners = UIRectCornerTopLeft|UIRectCornerBottomLeft;
                 }else {
                     corners = UIRectCornerTopRight|UIRectCornerBottomRight;
                 }
                 UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:currentColorButton.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(4.0, 4.0)];
                 CAShapeLayer *maskLayer = [CAShapeLayer layer];
                 maskLayer.frame = currentColorButton.bounds;
                 maskLayer.path = maskPath.CGPath;
                 currentColorButton.layer.mask = maskLayer;
                 
             }
         }else if (_style == VEColorControlViewType_Circle) {
             currentColorButton.layer.borderWidth = 0;
         }
     }
    
     currentColorButton = sender;
    if (_style == VEColorControlViewType_Square) {
         currentColorButton.frame = CGRectMake(currentColorButton.frame.origin.x - 2, currentColorButton.frame.origin.y - 2, currentColorButton.frame.size.width + 4, currentColorButton.frame.size.height + 4);
         
         if ( (currentColorButton.tag-1) == 0 || (currentColorButton.tag-1) == _colorArray.count - 1) {
             UIRectCorner corners;
             if ((currentColorButton.tag-1) == 0) {
                 corners = UIRectCornerTopLeft|UIRectCornerBottomLeft;
             }else {
                 corners = UIRectCornerTopRight|UIRectCornerBottomRight;
             }
             UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:currentColorButton.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(4.0, 4.0)];
             CAShapeLayer *maskLayer = [CAShapeLayer layer];
             maskLayer.frame = currentColorButton.bounds;
             maskLayer.path = maskPath.CGPath;
             currentColorButton.layer.mask = maskLayer;
         }
        [colorScrollView addSubview:currentColorButton];
    }else if (_style == VEColorControlViewType_Circle) {
        currentColorButton.layer.borderWidth = 2;
    }
    float maxX = colorScrollView.contentSize.width - colorScrollView.frame.size.width;
    float x = MIN(maxX, sender.frame.origin.x);
    if (sender.frame.origin.x >= maxX) {
        colorScrollView.contentOffset = CGPointMake(maxX, 0);
    }
    else if (sender.frame.origin.x < colorScrollView.frame.size.width) {
        colorScrollView.contentOffset = CGPointZero;
    }
    else if (!(x >= colorScrollView.contentOffset.x && x <= colorScrollView.contentOffset.x + colorScrollView.frame.size.width)) {
        colorScrollView.contentOffset = CGPointMake(MAX(x - sender.frame.size.width, 0), 0);
    }
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
