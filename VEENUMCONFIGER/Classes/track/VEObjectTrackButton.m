//
//  VEObjectTrackButton.m
//  VEENUMCONFIGER
//
//  Created by mac on 2024/1/29.
//

#import "VEObjectTrackButton.h"

@implementation VEObjectTrackButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] )
    {
        _fillColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // 获取绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置线条颜色和宽度
     UIColor *lineColor = _fillColor;
     CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
     CGContextSetLineWidth(context, 2.0);
//    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
//    CGContextSetLineWidth(context, 2.0);
    
    float height = rect.size.height/5.0;
    float width  = rect.size.width/5.0;
    
    // 绘制左上角直角
    CGContextMoveToPoint(context, 0, height);
    CGContextAddLineToPoint(context, 0, 0);
    
    CGContextMoveToPoint(context, width, 0);
    CGContextAddLineToPoint(context, 0, 0);
    
    // 绘制右上角直角
    CGContextMoveToPoint(context, rect.size.width - width, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    
    CGContextMoveToPoint(context, rect.size.width, height);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    
    // 绘制左下角直角
    CGContextMoveToPoint(context, 0, rect.size.height - height);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    
    CGContextMoveToPoint(context, width, rect.size.height);
    CGContextAddLineToPoint(context, 0, rect.size.height);
    
    // 绘制右下角直角
    CGContextMoveToPoint(context, rect.size.width - width, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    
    CGContextMoveToPoint(context, rect.size.width, rect.size.height - height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    
    // 绘制线条
    CGContextStrokePath(context);
}
@end
