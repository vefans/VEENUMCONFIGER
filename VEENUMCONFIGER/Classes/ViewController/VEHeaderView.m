//
//  VEHeaderView.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 15/12/24.
//  Copyright © 2015 iOS VESDK Team. All rights reserved.
//

#import "VEHeaderView.h"

@implementation VEHeaderView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        //将坐标由当前视图发送到 指定视图 fromView是无法响应的范围小父视图
        CGPoint stationPoint = [_transitionBtn convertPoint:point fromView:self];
        if (CGRectContainsPoint(_transitionBtn.bounds, stationPoint))
        {
            view = _transitionBtn;
        }
    }
    return view;
}
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//
//    if([self pointInside:point withEvent:event]){
//        for (UIView *subView in self.subviews) {
//            CGPoint subPoint = CGPointMake(point.x - subView.frame.origin.x,point.y - subView.frame.origin.y);
//            UIView *subTouchView = [subView hitTest:subPoint withEvent:event];
//            if(subTouchView){
//                return subTouchView;
//            }
//        }
//    }
//    return self;
//}
//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if (CGRectContainsPoint(CGRectMake(-10, 0, 20, self.frame.size.height), point)) {
//        return YES;
//    }
//    return NO;
//}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end
