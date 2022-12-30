//
//  VEOvalView.m
//  libVEDeluxe
//
//  Created by iOS VESDK Team on 2020/10/29.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEOvalView.h"
#define th M_PI/180

@implementation VEOvalView

- (instancetype)initWithFrame:(CGRect)frame atType:(int) type atColor:( UIColor * ) color
{
    if (self = [super initWithFrame:frame]) {
        _type = type;
        _mainColor = color;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect{
    
    switch (_type) {
        case VEMaskType_ROUNDNESS:
            [self drawOver:rect];
            break;
        case VEMaskType_PENTACLE:
            [self drawPentacle:rect];
            break;
        case VEMaskType_LOVE:
            [self draw_Love:rect];
            break;
        case VEMaskType_QUADRILATERAL:
        case VEMaskType_InterQUADRILATERAL:
        {
            [self darwQuadrilateral:rect];
        }
        default:
            break;
    }
    
}

-(void)darwQuadrilateral:(CGRect) rect
{
    NSMutableArray * array = nil;
    if( _delegate && [_delegate respondsToSelector:@selector(getQuadrilateralPointArray)] )
    {
        array = [_delegate getQuadrilateralPointArray];
    }
    
    if( array && (array.count > 0) )
    {
        CGPoint topLeftPoint = [array[0] CGPointValue];
        CGPoint topRightPoint = [array[1] CGPointValue];
        CGPoint bottomRightPoint = [array[2] CGPointValue];
        CGPoint bottomLeftPoint = [array[3] CGPointValue];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGMutablePathRef startPath = CGPathCreateMutable();
        CGPathMoveToPoint(startPath, NULL, topLeftPoint.x, topLeftPoint.y);
        CGPathAddLineToPoint(startPath, NULL, topRightPoint.x, topRightPoint.y);
        CGPathAddLineToPoint(startPath, NULL, bottomRightPoint.x, bottomRightPoint.y);
        CGPathAddLineToPoint(startPath, NULL, bottomLeftPoint.x, bottomLeftPoint.y);
        CGPathAddLineToPoint(startPath, NULL, topLeftPoint.x, topLeftPoint.y);
        CGPathCloseSubpath(startPath);
        
        CGContextAddPath(context, startPath);
        CGContextSetLineWidth(context, 1.5);
        CGContextSetFillColorWithColor(context, _mainColor.CGColor);
        CGContextSetStrokeColorWithColor(context, _mainColor.CGColor);
        CGContextStrokePath(context);
        
        CGContextAddPath(context, startPath);
        CGContextClip(context);
        
        CFRelease(startPath);
    }
}

-(void)drawOver:(CGRect) rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(2,2,rect.size.width - 4,rect.size.height - 4)];
    [[UIColor clearColor] setStroke];
    [_mainColor setStroke];
    [path stroke];
}
-(void)drawPentacle:(CGRect) rect
{
    CGFloat radius = (rect.size.width) / 2+ rect.size.width/10.0/4.0;
    
    CGFloat centerX = (rect.size.width) / 2;
    CGFloat centerY = (rect.size.height) / 2 + rect.size.width/10.0/2.0;
    
    CGFloat r0 = radius * sin(18 * th)/cos(36 * th)  + rect.size.width/10.0; /*计算小圆半径r0 */
    r0 = r0 - r0/10.0;
    CGFloat x1[5]={0},y1[5]={0},x2[5]={0},y2[5]={0};
    
    for (int i = 0; i < 5; i ++)
    {
        x1[i] = centerX + radius * cos((90 + i *72) * th); /* 计算出大圆上的五个平均分布点的坐标*/
        y1[i]=centerY - radius * sin((90 + i * 72) * th);
        x2[i]=centerX + r0 * cos((54  + i *72) * th); /* 计算出小圆上的五个平均分布点的坐标*/
        y2[i]=centerY - r0 * sin((54 + i * 72) * th);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef startPath = CGPathCreateMutable();
    CGPathMoveToPoint(startPath, NULL, x1[0], y1[0]);
    
    for (int i = 1; i < 5; i ++) {
        CGPathAddLineToPoint(startPath, NULL, x2[i], y2[i]);
        CGPathAddLineToPoint(startPath, NULL, x1[i], y1[i]);
    }
    
    CGPathAddLineToPoint(startPath, NULL, x2[0], y2[0]);
    CGPathCloseSubpath(startPath);
    
    CGContextAddPath(context, startPath);
    CGContextSetLineWidth(context, 1.5);
    CGContextSetFillColorWithColor(context, _mainColor.CGColor);
    CGContextSetStrokeColorWithColor(context, _mainColor.CGColor);
    CGContextStrokePath(context);
    
    CGRect range = CGRectMake(x1[1], 0, (x1[4] - x1[1]) * 0.0 , y1[2]);
    
    CGContextAddPath(context, startPath);
    CGContextClip(context);
    CGContextFillRect(context, range);
    
    CFRelease(startPath);
}
-(void)draw_Love:(CGRect) rect
{
    float spaceWidth = 2;
    //上面的两个半圆 半径为整个frame的四分之一
    CGFloat radius = MIN((self.frame.size.width-spaceWidth*2)/4, (self.frame.size.height-spaceWidth*2)/4);
    
    //左侧圆心 位于左侧边距＋半径宽度
    CGPoint leftCenter = CGPointMake(spaceWidth+radius, spaceWidth+radius + radius/5.0);
    //右侧圆心 位于左侧圆心的右侧 距离为两倍半径
    CGPoint rightCenter = CGPointMake(spaceWidth+radius*3, spaceWidth+radius + radius/5.0);
    
    //左侧半圆
    UIBezierPath *heartLine = [UIBezierPath bezierPathWithArcCenter:leftCenter radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //右侧半圆
    [heartLine addArcWithCenter:rightCenter radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //曲线连接到新的底部顶点 为了弧线的效果，控制点，坐标x为总宽度减spaceWidth，刚好可以相切，平滑过度 y可以根据需要进行调整，y越大，所画出来的线越接近内切圆弧
    [heartLine addQuadCurveToPoint:CGPointMake((self.frame.size.width/2), self.frame.size.height-spaceWidth*2 - radius/4.5) controlPoint:CGPointMake(self.frame.size.width-spaceWidth, self.frame.size.height*0.6)];
    
    //用曲线 底部的顶点连接到左侧半圆的左起点 为了弧线的效果，控制点，坐标x为spaceWidth，刚好可以相切，平滑过度。y可以根据需要进行调整，y越大，所画出来的线越接近内切圆弧（效果是越胖）
    [heartLine addQuadCurveToPoint:CGPointMake(spaceWidth, spaceWidth + radius + radius/5.0) controlPoint:CGPointMake(spaceWidth, self.frame.size.height*0.6)];
    
    //线条处理
    [heartLine setLineCapStyle:kCGLineCapRound];
    //线宽
    [heartLine setLineWidth:1.5];
    //线条的颜色
    [_mainColor set];
    
    //根据坐标点连线
    [heartLine stroke];
    //clipToBounds 切掉多余的部分
    [heartLine addClip];
}
@end
