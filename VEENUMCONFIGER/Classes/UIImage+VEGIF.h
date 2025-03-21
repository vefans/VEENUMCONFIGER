//
//  UIImage+GIF.h
//  VEDeluxeDemo
//
//  Created by iOS VESDK Team on 06.01.12.
//  Copyright (c) 2012 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage (VEGIF)

+ (UIImage *)ve_animatedGIFNamed:(NSString *)name;

+ (UIImage *)ve_animatedGIFWithData:(NSData *)data;
+ (UIImage *)ve_animatedGIFWithData:(NSData *)data timeArray:(NSMutableArray *)timeArray;

- (UIImage *)ve_animatedImageByScalingAndCroppingToSize:(CGSize)size;

+ (UIImage *)getGifThumbImageWithData:(NSData *)data time:(float)time;

@end
