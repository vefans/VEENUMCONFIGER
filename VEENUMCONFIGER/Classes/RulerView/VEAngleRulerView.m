//
//  VEAngleRulerView.m
//  VEENUMCONFIGER
//
//  Created by mac on 2024/1/24.
//

#import "VEAngleRulerView.h"

@implementation VEAngleRulerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _value = 0.0;
        {
            self.valueSelectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds) * 0.4 - 1.0, 2.5, CGRectGetMaxY(self.bounds) * 0.6 + 1.0)];
            self.valueSelectedImage.backgroundColor = Main_Color;
            [self addSubview:self.valueSelectedImage];
            self.valueSelectedImage.layer.cornerRadius = self.valueSelectedImage.frame.size.width/2.0;
            self.valueSelectedImage.layer.masksToBounds = true;
            [self updateValueCoordinate];
        }
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged || gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint translation = [gestureRecognizer translationInView:self];
        CGFloat distance = translation.x;
        // 根据滑动距离更新 value 的增减
        CGFloat scale = 0.0035; // 调整滑动速度的比例因子
        self.value += distance * scale;
        // 限制 value 的范围在 [0, 1] 内
        self.value = MAX(-0.5, MIN(0.5, self.value));
        // 清空滑动距离的累积
        [gestureRecognizer setTranslation:CGPointZero inView:self];
        [self updateValueCoordinate]; // 更新 value 坐标
        // 执行其他操作，如刷新界面或处理 value 变化等
    }
}

- (void)drawRect:(CGRect)rect {
    // 获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 设置大刻度线的长度和间距
    CGFloat largeTickHeight = 12; // 大刻度线的高度
    // 计算刻度线的数量
    NSInteger numberOfLargeTicks = 6;
    CGFloat largeTickSpacing = rect.size.width / numberOfLargeTicks; // 大刻度线之间的间距
    
    // 设置小刻度线的长度和间距
    CGFloat smallTickHeight = 10;// 小刻度线的高度
    CGFloat smallTickSpacing = largeTickSpacing / 5.0; // 小刻度线之间的间距
    
    // 绘制刻度线
    for (NSInteger i = 0; i <= numberOfLargeTicks; i++) {
        // 设置刻度线的颜色和宽度
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.7 alpha:1.0].CGColor);
        CGContextSetLineWidth(context, 1.5);
        CGFloat x = i * largeTickSpacing;
        
        // 绘制大刻度线
        CGPoint largeStartPoint = CGPointMake(x, CGRectGetMaxY(self.bounds) - largeTickHeight);
        CGPoint largeEndPoint = CGPointMake(x, CGRectGetMaxY(self.bounds));
        CGContextMoveToPoint(context, largeStartPoint.x, largeStartPoint.y);
        CGContextAddLineToPoint(context, largeEndPoint.x, largeEndPoint.y);
        CGContextStrokePath(context);
        
        // 绘制小刻度线
        for (NSInteger j = 1; j < 5; j++) {
            // 设置刻度线的颜色和宽度
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.5 alpha:1.0].CGColor);
            CGContextSetLineWidth(context, 1.0);
            CGFloat smallX = x + j * smallTickSpacing;
            CGPoint smallStartPoint = CGPointMake(smallX, CGRectGetMaxY(self.bounds) - smallTickHeight);
            CGPoint smallEndPoint = CGPointMake(smallX, CGRectGetMaxY(self.bounds));
            CGContextMoveToPoint(context, smallStartPoint.x, smallStartPoint.y);
            CGContextAddLineToPoint(context, smallEndPoint.x, smallEndPoint.y);
            CGContextStrokePath(context);
        }
    }
}

- (void)updateValueCoordinate {
    CGFloat xPosition = CGRectGetMinX(self.bounds) + (self.value + 0.5) * (CGRectGetWidth(self.bounds) - 0.5);
    CGPoint center = CGPointMake(xPosition, CGRectGetMidY(self.bounds) + CGRectGetMaxY(self.bounds) * 0.4/2.0);
    self.valueSelectedImage.center = center;
    if( _delegate && [_delegate respondsToSelector:@selector(rulerView_Value:RulerView:)] )
    {
        [_delegate rulerView_Value:self.value RulerView:self];
    }
}

@end
