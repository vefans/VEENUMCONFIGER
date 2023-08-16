//
//  VENavigationController.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2016/11/4.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import "VENavigationController.h"
#import "VEConfigManager.h"
@interface VENavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation VENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle =  UIModalPresentationFullScreen;
    self.navigationBarHidden = YES;
    // 获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)gesture{
    NSLog(@"%s",__func__);
}
// 什么时候调用：每次触发手势之前都会询问下代理，是否触发。
// 作用：拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // 注意：只有非根控制器才有滑动返回功能，根控制器没有。
    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        // 表示用户在根控制器界面，就不需要触发滑动手势，
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setIpadInterfaceOrientation:(UIInterfaceOrientation)ipadInterfaceOrientation{
    _ipadInterfaceOrientation = ipadInterfaceOrientation;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if([VEConfigManager sharedManager].iPad_HD){
        if(_ipadInterfaceOrientation != 0){
            return _ipadInterfaceOrientation;
        }else{
            if(self.ipadInterfaceOrientation != UIInterfaceOrientationLandscapeRight){
                self.ipadInterfaceOrientation = UIInterfaceOrientationLandscapeLeft;
            }
            return _ipadInterfaceOrientation;
        }
    }else{
        return UIInterfaceOrientationPortrait;
    }
    //(UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight);
}
- (BOOL)shouldAutorotate{
    return YES;
}

/// 所支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    if([VEConfigManager sharedManager].iPad_HD){
//        return UIInterfaceOrientationMaskLandscape;
//    }else{
//        return UIInterfaceOrientationMaskPortrait;
//    }
//
//}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UIDevice *device = [UIDevice currentDevice]; //Get the device object
    [nc removeObserver:self name:UIDeviceOrientationDidChangeNotification object:device];
}

- (void)viewDidAppear:(BOOL)animated {
      UIDevice *device = [UIDevice currentDevice]; //Get the device object
      [device beginGeneratingDeviceOrientationNotifications]; //Tell it to start monitoring the accelerometer for orientation
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; //Get the notification centre for the app
      [nc addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:device];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

- (void)orientationChanged:(NSNotification *)notification{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(!iPad){
        self.ipadInterfaceOrientation = UIInterfaceOrientationPortrait;
    }else{
        if(orientation == UIInterfaceOrientationLandscapeLeft){
            self.ipadInterfaceOrientation = UIInterfaceOrientationLandscapeLeft;
        // 左横屏
        }else {
            self.ipadInterfaceOrientation = UIInterfaceOrientationLandscapeRight;
            //右横屏
        }
    }
}
@end
