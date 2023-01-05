//
//  NSObject+VESafe.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 04.01.23.
//  Copyright (c) 2023 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (VESafe)

/**
 交换两个对象方法的实现
 
 @param class 被替换方法的类
 @param originalSelector 被替换的方法编号
 @param swizzleSelector 用于替换的方法编号
 */
+ (void)ve_swizzleInstanceMethodWithClass:(Class)class
                         originlaSelector:(SEL)originalSelector
                          swizzleSelector:(SEL)swizzleSelector;

// 交换某个类的类方法
+ (void)ve_swizzleClassMethodWithClass:(Class)class
                      originlaSelector:(SEL)originalSelector
                       swizzleSelector:(SEL)swizzleSelector;

@end
