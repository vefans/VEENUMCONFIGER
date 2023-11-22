//
//  VEAPITemplateRecordButton.m
//  VEDeluxeSDK
//
//  Created by iOS VESDK Team  on 2021/7/16.
//

#import "VEAPITemplateRecordButton.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation VEAPITemplateRecordButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initData];
    }
    return self;
}

/** 初始化数据*/
- (void)initData
{
    _parity = true;
    _progressWidth = 5.0;
    _progressColor = Main_Color;
    _progressBackgroundColor = [UIColor clearColor];
    _percent = 0.0;
    _clockwise = 0;

}

- (void)setProgressColor:(UIColor *)progressColor{
    _progressColor = progressColor;
}
- (void)setProgressBackgroundColor:(UIColor *)progressBackgroundColor{
    _progressBackgroundColor = progressBackgroundColor;
}
#pragma mark -- 画进度条
- (void)drawRect:(CGRect)rect
{
    NSLog(@"_percent:%f", _percent);
    //获取当前画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat angle = 2 * self.percent * M_PI - M_PI_2;
    /** *  画弧线 */
    CGContextSetShouldAntialias(context, YES);
    if(self.clockwise) {//反方向
        CGContextAddArc(context, WIDTH/2, HEIGHT/2, (WIDTH-self.progressWidth)/2, angle, -M_PI*2, 0);
    }
    else {
        CGContextAddArc(context, WIDTH/2, HEIGHT/2, (WIDTH-self.progressWidth)/2, angle,M_PI *2 - M_PI_2, 0);
    }
    [(_parity== false ? self.progressColor : self.progressBackgroundColor) setStroke];//设置圆描边背景的颜色
    //画线的宽度
    CGContextSetLineWidth(context, self.progressWidth);
    //绘制路径
    CGContextStrokePath(context);

    if(self.percent>0.0)
    {
        if(self.clockwise) {//反方向
            CGContextAddArc(context, WIDTH/2, HEIGHT/2, (WIDTH-self.progressWidth)/2, ((int)self.percent == 1 ? -M_PI_2 : angle), -M_PI_2, 0);
        }
        else {//正方向
            CGContextAddArc(context, WIDTH/2, HEIGHT/2, (WIDTH-self.progressWidth)/2,  - M_PI_2, angle, 0);
        }
        [_parity == true ? self.progressColor : self.progressBackgroundColor setStroke];//设置圆描边的颜色
        CGContextSetLineWidth(context, self.progressWidth);
        CGContextStrokePath(context);
    }
}

- (void)setPercent:(float)percent
{
    _percent = percent;
    __weak typeof(self) wself = self;
    if(self.percent < 0 || wself.percent > 1){
        //dispatch_async(dispatch_get_main_queue(), ^{wself.hidden = YES;});
         return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        wself.hidden = NO;
//        NSLog(@"download:%f",_percent);
        [wself setNeedsDisplay];
    });
}

- (void)dealloc{
//    NSLog(@"%s",__func__);
}

@end
