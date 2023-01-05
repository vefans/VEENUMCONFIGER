//
//  NSObject+VESafe.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 04.01.23.
//  Copyright (c) 2023 iOS VESDK Team. All rights reserved.
//

#import "NSObject+VESafe.h"
#import <objc/runtime.h>

@implementation NSObject (VESafe)

/**
 交换两个对象方法的实现
 
 @param class 被替换方法的类
 @param originalSelector 被替换的方法编号
 @param swizzleSelector 用于替换的方法编号
 */
+ (void)ve_swizzleInstanceMethodWithClass:(Class)class
                         originlaSelector:(SEL)originalSelector
                          swizzleSelector:(SEL)swizzleSelector
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzleSelector);
    if (!class || !originalMethod || !swizzledMethod) {
        return;
    }
    
    //加一层保护措施，如果添加成功，则表示该方法不存在于本类，而是存在于父类中，不能交换父类的方法,否则父类的对象调用该方法会crash；添加失败则表示本类存在该方法
    BOOL isAddMethod = class_addMethod(class, originalSelector ,method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isAddMethod) {
        //添加方法实现IMP成功后，再将原有的实现替换到swizzledMethod方法上，从而实现方法的交换，并且未影响到父类方法的实现
        class_replaceMethod(class, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        //添加失败，调用交互两个方法的实现
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

// 交换某个类的类方法
+ (void)ve_swizzleClassMethodWithClass:(Class)class
                      originlaSelector:(SEL)originalSelector
                       swizzleSelector:(SEL)swizzleSelector
{
    Class metaClass = object_getClass(class);
    Method originalMethod = class_getClassMethod(metaClass, originalSelector);
    Method swizzledMethod = class_getClassMethod(metaClass, swizzleSelector);
    if (!class || !metaClass || !originalMethod || !swizzledMethod) {
        return;
    }
    
    BOOL isAddMethod = class_addMethod(metaClass,originalSelector,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    
    if (isAddMethod) {
        class_replaceMethod(metaClass,swizzleSelector,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

@end
