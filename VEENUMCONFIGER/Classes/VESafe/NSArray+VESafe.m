//
//  NSArray+VESafe.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 04.01.23.
//  Copyright (c) 2023 iOS VESDK Team. All rights reserved.
//

#import "NSArray+VESafe.h"
#import "NSObject+VESafe.h"

@implementation NSArray (VESafe)

+ (void)load {
    [super load];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //NSArray的真身
        NSString *initStr = @"__NSArray0";
        NSString *singleStr = @"__NSSingleObjectArrayI";
        NSString *oneMoreStr = @"__NSArrayI";
        
        //替换数组的 objectAtIndex 方法
        NSString *tmpStr = @"objectAtIndex:";
        NSString *tmpZeroStr = @"veSafe_zeroObjectAtIndex:";
        NSString *tmpSingleStr = @"veSafe_singleObjectAtIndex:";
        NSString *tmpOneMoreStr = @"veSafe_objectAtIndex:";
        
        //替换数组的 objectAtIndexedSubscript 方法
        NSString *tmpSubscriptStr = @"objectAtIndexedSubscript:";
        NSString *tmpSafeSubscriptStr = @"veSafe_objectAtIndexedSubscript:";
        
        [NSObject ve_swizzleInstanceMethodWithClass:NSClassFromString(initStr) originlaSelector:NSSelectorFromString(tmpStr) swizzleSelector:NSSelectorFromString(tmpZeroStr)];
        [NSObject ve_swizzleInstanceMethodWithClass:NSClassFromString(singleStr) originlaSelector:NSSelectorFromString(tmpStr) swizzleSelector:NSSelectorFromString(tmpSingleStr)];
        [NSObject ve_swizzleInstanceMethodWithClass:NSClassFromString(oneMoreStr) originlaSelector:NSSelectorFromString(tmpStr) swizzleSelector:NSSelectorFromString(tmpOneMoreStr)];
        [NSObject ve_swizzleInstanceMethodWithClass:NSClassFromString(@"") originlaSelector:NSSelectorFromString(tmpSubscriptStr) swizzleSelector:NSSelectorFromString(tmpSafeSubscriptStr)];
    });
}

/**
 取出NSArray 第index个 值 对应 __NSArray0
 
 @param index 索引 index
 @return 返回值
 */
- (id)veSafe_zeroObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self veSafe_zeroObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSSingleObjectArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)veSafe_singleObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self veSafe_singleObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)veSafe_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self veSafe_objectAtIndex:index];
}

/**
 objectAtIndexedSubscript
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param idx 索引 idx
 @return 返回值
 */
- (id)veSafe_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        return nil;
    }
    return [self veSafe_objectAtIndexedSubscript:idx];
}

@end
