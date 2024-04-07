//
//  ICGRulerView.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 1/25/15.
//  Copyright (c) 2015 iOS VESDK Team. All rights reserved.
//

#import "VEHRulerView.h"

@implementation VEHRulerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _stepValue = 10;
        _unitValue = 10;
        _lineWidth = 1.5;
        _minValue = 0;
        _maxValue = frame.size.width - _stepValue + _lineWidth / 2.0;
        _stepLineHeight = 10;
        _unitLineHeight = 10;
        _stepLineColor = UIColorFromRGB(0x656565);
        _unitLineColor = UIColorFromRGB(0xd3d3d3);
        _textColor = [UIColor whiteColor];
        _fontSize = 11;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _lineWidth);
    
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat unitY = (height - _unitLineHeight) / 2.0;
    CGFloat stepY = (height - _stepLineHeight) / 2.0;
    
    int step = 1;
    for (CGFloat x = _minValue; x <= _maxValue; ) {
        CGContextSetLineCap(context, kCGLineCapSquare);
        if (_isFromUnit && x == _minValue) {
            step = 0;
            
            CGContextSetStrokeColorWithColor(context, _unitLineColor.CGColor);
            CGContextMoveToPoint(context, x, unitY);
            CGContextAddLineToPoint(context, x, unitY + _unitLineHeight);
            CGContextStrokePath(context);
        }
        else if (step % _unitValue == 0) {
            CGContextSetStrokeColorWithColor(context, _unitLineColor.CGColor);
            CGContextMoveToPoint(context, x, unitY);
            CGContextAddLineToPoint(context, x, unitY + _unitLineHeight);
            CGContextStrokePath(context);
            
            if (_isShowText) {
                UIFont *font = [UIFont systemFontOfSize:_fontSize];
                NSDictionary *stringAttrs = @{NSFontAttributeName:font, NSForegroundColorAttributeName:_textColor};
                
                NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02i", step] attributes:stringAttrs];
                [attrStr drawAtPoint:CGPointMake(x-7, unitY - 15)];
            }
        } else {
            CGContextSetStrokeColorWithColor(context, _stepLineColor.CGColor);
            CGContextMoveToPoint(context, x, stepY);
            CGContextAddLineToPoint(context, x, stepY + _stepLineHeight);
            CGContextStrokePath(context);
        }
        x += _stepValue;
        
        step++;
    }

}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end
