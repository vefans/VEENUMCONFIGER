//
//  UIImage+Tint.h
//  VEDeluxe
//
//  Created by iOS VESDK Team on 2018/12/11.
//  Copyright © 2018年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

- (UIImage *) imageWithTintColor;

- (UIImage *)imageWithBlendMode:(CGBlendMode)blendMode tintColor:(UIColor *)tintColor;

@end
