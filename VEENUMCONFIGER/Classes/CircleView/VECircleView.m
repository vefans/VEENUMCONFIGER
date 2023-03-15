//
//  CircleView.m
//  VELiteSDK
//
//  Created by iOS VESDK Team. on 2017/3/21.
//  Copyright © 2017年 iOS VESDK Team. All rights reserved.
//

#import "VECircleView.h"

#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height

@implementation VECircleView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initData];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self initData];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initData];
    }
    return self;
}

/** 初始化数据*/
- (void)initData
{
    _progressWidth = 3.0;
    UIColor *color = [UIColor redColor];
    _progressColor = color;
    UIColor *bColor = [UIColor grayColor];
    _progressBackgroundColor = bColor;
    _percent = 0.0;
    _clockwise = 0;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark -- 画进度条

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.backgroundColor = [UIColor clearColor];
    //获取当前画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, YES);
    CGContextAddArc(context, WIDTH/2, HEIGHT/2, (WIDTH-self.progressWidth)/2, 0, M_PI*2, 0);
    [self.progressBackgroundColor setStroke];//设置圆描边背景的颜色
    //画线的宽度
    CGContextSetLineWidth(context, self.progressWidth);
    //绘制路径
    CGContextStrokePath(context);
    
    if(self.percent)
    {
        CGFloat angle = 2 * self.percent * M_PI - M_PI_2;
        if(self.clockwise) {//反方向
            CGContextAddArc(context, WIDTH/2, HEIGHT/2, (WIDTH-self.progressWidth)/2, ((int)self.percent == 1 ? -M_PI_2 : angle), -M_PI_2, 0);
        }
        else {//正方向
            CGContextAddArc(context, WIDTH/2, HEIGHT/2, (WIDTH-self.progressWidth)/2, -M_PI_2, angle, 0);
        }
        [self.progressColor setStroke];//设置圆描边的颜色
        CGContextSetLineWidth(context, self.progressWidth);
        CGContextStrokePath(context);
    }
}

- (void)setPercent:(float)percent
{
    _percent = percent;
    __weak typeof(self) wself = self;
    if(self.percent <= 0 || wself.percent > 1){
        dispatch_async(dispatch_get_main_queue(), ^{wself.hidden = YES;});
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
