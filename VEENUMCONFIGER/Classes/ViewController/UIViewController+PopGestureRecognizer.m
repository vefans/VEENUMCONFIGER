//
//  UIViewController+PopGestureRecognizer.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/12/24.
//

#import "UIViewController+PopGestureRecognizer.h"

@implementation UIViewController (PopGestureRecognizer)
+ (void)popGestureClose:(UIViewController *)VC
{
    // 禁用侧滑返回手势
    if ([VC.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //这里对添加到右滑视图上的所有手势禁用
        for (UIGestureRecognizer *popGesture in VC.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = NO;
        }
        //若开启全屏右滑，不能再使用下面方法，请对数组进行处理
        //VC.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

+ (void)popGestureOpen:(UIViewController *)VC
{
    // 启用侧滑返回手势
    if ([VC.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    //这里对添加到右滑视图上的所有手势启用
        for (UIGestureRecognizer *popGesture in VC.navigationController.interactivePopGestureRecognizer.view.gestureRecognizers) {
            popGesture.enabled = YES;
        }
        //若开启全屏右滑，不能再使用下面方法，请对数组进行处理
        //VC.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
@end
