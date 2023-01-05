//
//  NSNumber+VESafe.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 04.01.23.
//  Copyright (c) 2023 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSNumber (VESafe)

@property (readonly) NSUInteger length;

- (BOOL)isEqualToString:(NSString *)aString;

@end
