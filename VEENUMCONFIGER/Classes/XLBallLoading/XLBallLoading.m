//
//  XLBallLoading.m
//  XLBallLoadingDemo
//
//  Created by MengXianLiang on 2017/3/21.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLBallLoading.h"

static CGFloat ballScale = 1.5f;

@interface XLBallLoading ()<CAAnimationDelegate> {
    
    //UIVisualEffectView *_ballContainer;
    UIView *_ballContainer;
    UIView *_ball1;
    
    UIView *_ball2;
    
    UIView *_ball3;
    
    CAAnimationGroup *_animationGroup1;
    CAAnimationGroup *_animationGroup2;
    
    BOOL _stopAnimationByUser;
}
@end

@implementation XLBallLoading

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    _ballContainer = [[UIView alloc] init];
    _ballContainer.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - 44)/2.0, 44, 44);
    _ballContainer.center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    _ballContainer.layer.cornerRadius = 10.0f;
    _ballContainer.layer.masksToBounds = true;
    _ballContainer.backgroundColor = [UIColor clearColor];
    [self addSubview:_ballContainer];
    
    CGFloat ballWidth = 8.0f;
    
    _ball1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ball1.center = CGPointMake(_ballContainer.bounds.size.width/2.0f - ballWidth/2.0, _ballContainer.bounds.size.height/2.0f);
    _ball1.layer.cornerRadius = ballWidth/2.0f;
    _ball1.backgroundColor = UIColorFromRGB(0xa4a4a4);
    [_ballContainer addSubview:_ball1];
    
    _ball3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth, ballWidth)];
    _ball3.center = CGPointMake(_ballContainer.bounds.size.width/2.0f + ballWidth/2.0, _ballContainer.bounds.size.height/2.0f);
    _ball3.layer.cornerRadius = ballWidth/2.0f;
    _ball3.backgroundColor = UIColorFromRGB(0x727272);
    [_ballContainer addSubview:_ball3];
    
    _ball2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ballWidth/2.0f, ballWidth/2.0f)];
    _ball2.center = CGPointMake(_ballContainer.bounds.size.width/2.0f, _ballContainer.bounds.size.height/2.0f);
    _ball2.layer.cornerRadius = ballWidth/4.0f;
    _ball2.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    _ball2.hidden = NO;
    [_ballContainer addSubview:_ball2];
}

-(void)startPathAnimate{
    [_ball1.superview bringSubviewToFront:_ball2];
    [_ball1.superview bringSubviewToFront:_ball1];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:_ball1.center];
    //移动到最右边
    [path1 addLineToPoint:_ball3.center];
    //执行动画
    {
        //位移动画
        CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation1.path = path1.CGPath;
        animation1.removedOnCompletion = YES;
        animation1.duration = [self animationDuration];
        animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //等比例缩放
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        keyAnimation.duration = animation1.duration;
        keyAnimation.values = @[@1.0,@1.5,@1.0];
        //动画均匀进行
        keyAnimation.calculationMode = kCAAnimationCubicPaced;
        //组合动画
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[animation1, keyAnimation];
        animationGroup.duration = animation1.duration;
        animationGroup.repeatCount = CGFLOAT_MAX;
        [_ball1.layer addAnimation:animationGroup forKey:@"animation"];
    }
    
    
    {
            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];//整体变化
//        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];//宽变化
        //    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];//高变化
        animation.duration  = [self animationDuration];// 动画时间
        NSMutableArray *values = [NSMutableArray array];
        // 前两个是控制view的大小的；[放大效果]
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
       
        animation.values = values;
        animation.repeatCount = HUGE;//重复
        [_ball2.layer addAnimation:animation forKey:nil];
    }
    
    
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:_ball3.center];
    //移动到最左边
    [path3 addLineToPoint:_ball1.center];
    {
        //位移动画
        CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation3.path = path3.CGPath;
        animation3.removedOnCompletion = YES;
        animation3.duration = [self animationDuration];
        animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //等比例缩放
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        keyAnimation.duration = animation3.duration;
        keyAnimation.values = @[@1.0,@1.5,@1.0];
        //动画均匀进行
        keyAnimation.calculationMode = kCAAnimationCubicPaced;
        
        //组合动画
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[animation3, keyAnimation];
        animationGroup.duration = animation3.duration;
        animationGroup.repeatCount = CGFLOAT_MAX;
        animationGroup.delegate = self;
        _animationGroup1 = animationGroup;
        [_ball3.layer addAnimation:animationGroup forKey:@"animation_1"];
    }
}

-(void)startPathAnimate2{
    [_ball3.superview bringSubviewToFront:_ball2];
    [_ball3.superview bringSubviewToFront:_ball3];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:_ball3.center];
    //回到原处
    [path1 addLineToPoint:_ball1.center];
    //执行动画
    {
        //位移动画
        CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation1.path = path1.CGPath;
        animation1.removedOnCompletion = YES;
        animation1.duration = [self animationDuration];
        animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //等比例缩放
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        keyAnimation.duration = animation1.duration;
        keyAnimation.values = @[@1.0,@1.5,@1.0];
        //动画均匀进行
        keyAnimation.calculationMode = kCAAnimationCubicPaced;
        //组合动画
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[animation1, keyAnimation];
        animationGroup.duration = animation1.duration;
        animationGroup.repeatCount = CGFLOAT_MAX;
        [_ball1.layer addAnimation:animationGroup forKey:@"animation"];
    }
    
    {
            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];//整体变化
//        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];//宽变化
        //    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];//高变化
        animation.duration  = [self animationDuration];// 动画时间
        NSMutableArray *values = [NSMutableArray array];
        // 前两个是控制view的大小的；[放大效果]
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
       
        animation.values = values;
        animation.repeatCount = HUGE;//重复
        [_ball2.layer addAnimation:animation forKey:nil];
    }
    
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:_ball1.center];
    //回到原处
    [path3 addLineToPoint:_ball3.center];
    //执行动画
    {
        //位移动画
        CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation3.path = path3.CGPath;
        animation3.removedOnCompletion = YES;
        animation3.duration = [self animationDuration];
        animation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        //等比例缩放
        CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        keyAnimation.duration = animation3.duration;
        keyAnimation.values = @[@1.0,@1.5,@1.0];
        //动画均匀进行
        keyAnimation.calculationMode = kCAAnimationCubicPaced;
        
        //组合动画
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[animation3, keyAnimation];
        animationGroup.duration = animation3.duration;
        animationGroup.repeatCount = CGFLOAT_MAX;
        animationGroup.delegate = self;
        _animationGroup2 = animationGroup;
        [_ball3.layer addAnimation:animationGroup forKey:@"animation_2"];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (_stopAnimationByUser) {return;}
    if(anim == _animationGroup1){
        [self startPathAnimate2];
    }else if(anim == _animationGroup2){
        [self startPathAnimate];
    }
}

- (CGFloat)animationDuration {
    return 0.8f;
}

#pragma mark -
#pragma mark 显示隐藏方法
- (void)start {
    [self startPathAnimate];
    _stopAnimationByUser = false;
}

- (void)stop {
    _stopAnimationByUser = true;
    [_ball1.layer removeAllAnimations];
    [_ball1 removeFromSuperview];
    [_ball2.layer removeAllAnimations];
    [_ball2 removeFromSuperview];
    [_ball3.layer removeAllAnimations];
    [_ball3 removeFromSuperview];
}

+(void)showInView:(UIView *)view{
    [self hideInView:view];
    XLBallLoading *loading = [[XLBallLoading alloc] initWithFrame:view.bounds];
    [view addSubview:loading];
    [loading start];
}

+(void)hideInView:(UIView *)view{
    for (XLBallLoading *loading in view.subviews) {
        if ([loading isKindOfClass:[XLBallLoading class]]) {
            [loading stop];
            [loading removeFromSuperview];
        }
    }
}

@end
