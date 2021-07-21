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
}

@end

@implementation VEColorControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        currentColorButton = nil;
    }
    return self;
}

- (void)setColorArray:(NSArray *)colorArray {
    _colorArray = colorArray;
    if (!colorScrollView) {
        float width = self.frame.size.height / 2.0;
        colorScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        colorScrollView.showsVerticalScrollIndicator = NO;
        colorScrollView.showsHorizontalScrollIndicator = NO;
        colorScrollView.contentSize = CGSizeMake(_colorArray.count * width + 20 + 4                           , 0);
        [self addSubview:colorScrollView];
        
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
        
        [_colorArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIColor *objColor = (UIColor *)obj;
            [objColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
            if ((red1 == red2)&&(green1 == green2)&&(blue1 == blue2)&&(alpha1 == alpha2)) {
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

-(void)setCurrentColorButtonColor:(UIColor *) color
{
    __block NSUInteger index = 0;
    if( color )
    {
        CGFloat red1,green1,blue1,alpha1;
        __block CGFloat red2 = 0.0, green2 = 0.0, blue2 = 0.0,alpha2 = 0.0;
        //取出color1的背景颜色的RGBA值
        [color getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
        
        [_colorArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIColor *objColor = (UIColor *)obj;
            [objColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
            if ((red1 == red2)&&(green1 == green2)&&(blue1 == blue2)&&(alpha1 == alpha2)) {
                index = idx;
                *stop = TRUE;
            }
        }];
    }
    
    if( index > 0 )
    {
        [self setColor_CurrentBtn:[colorScrollView viewWithTag:index]];
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
}

-(void)setColor_CurrentBtn:(UIButton *) sender
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
     }
    
     currentColorButton = sender;
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
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
