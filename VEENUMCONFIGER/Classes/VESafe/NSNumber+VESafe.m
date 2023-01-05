//
//  NSNumber+VESafe.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 04.01.23.
//  Copyright (c) 2023 iOS VESDK Team. All rights reserved.
//

#import "NSNumber+VESafe.h"

@implementation NSNumber (VESafe)

- (NSUInteger)length
{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self length];
    } else {
        if ([self isKindOfClass:[NSNumber class]]) {
            NSString *str = [NSString stringWithFormat:@"%@", self];
            return [str length];;
        } else {
            NSLog(@"current type is not match the interface(NSString), please check!!!");
            return -1;
        }
    }
}

- (BOOL)isEqualToString:(NSString *)aString
{
    if ([self isKindOfClass:[NSString class]]) {
        return [(NSString *)self isEqualToString:aString];
    } else {
        if ([self isKindOfClass:[NSNumber class]]) {
            NSString *str = [NSString stringWithFormat:@"%@", self];
            return [str isEqualToString:aString];;
        } else {
            NSLog(@"current type is not match the interface(NSString), please check!!!");
            
            return NO;
        }
    }
}

@end
