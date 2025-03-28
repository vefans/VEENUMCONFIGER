//
//  UIImage+GIF.m
//  VEDeluxeDemo
//
//  Created by iOS VESDK Team on 06.01.12.
//  Copyright (c) 2012 iOS VESDK Team. All rights reserved.
//

#import "UIImage+VEGIF.h"
#import <ImageIO/ImageIO.h>

@implementation UIImage (VEGIF)

+ (UIImage *)ve_animatedGIFWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);

    size_t count = CGImageSourceGetCount(source);

    UIImage *animatedImage;

    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];

        NSTimeInterval duration = 0.0f;

        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);

            duration += [self ve_frameDurationAtIndex:i source:source];
            
            UIImage *img = [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
            [images addObject:img];

            CGImageRelease(image);
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    data = nil;
    if (source) {
        CFRelease(source);
    }
    return animatedImage;
}

+ (UIImage *)ve_animatedGIFWithData:(NSData *)data timeArray:(NSMutableArray *)timeArray {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);

    size_t count = CGImageSourceGetCount(source);

    UIImage *animatedImage;

    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    }
    else {
        NSMutableArray *images = [NSMutableArray array];

        NSTimeInterval duration = 0.0f;

        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            float time = [self ve_frameDurationAtIndex:i source:source];
            duration += time;
            
            UIImage *img = [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
            [images addObject:img];

            CGImageRelease(image);
            if (timeArray) {
                [timeArray addObject:[NSNumber numberWithFloat:time]];
            }
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    data = nil;
    if (source) {
        CFRelease(source);
    }
    return animatedImage;
}

+ (float)ve_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    if (!cfFrameProperties) {
        return frameDuration;
    }
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    if (gifProperties) {
        NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
        if (delayTimeUnclampedProp != nil) {
            frameDuration = [delayTimeUnclampedProp floatValue];
        } else {
            NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
            if (delayTimeProp != nil) {
                frameDuration = [delayTimeProp floatValue];
            }
        }
    }
    else if (frameProperties[(NSString *)kCGImagePropertyPNGDictionary]) {
        gifProperties = frameProperties[(NSString *)kCGImagePropertyPNGDictionary];
        
        NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyAPNGUnclampedDelayTime];
        if (delayTimeUnclampedProp != nil) {
            frameDuration = [delayTimeUnclampedProp floatValue];
        } else {
            NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyAPNGDelayTime];
            if (delayTimeProp != nil) {
                frameDuration = [delayTimeProp floatValue];
            }
        }
    }
    else if (@available(iOS 14.0, *)) {
        if (frameProperties[(NSString *)kCGImagePropertyWebPDictionary]) {
            gifProperties = frameProperties[(NSString *)kCGImagePropertyPNGDictionary];
            
            NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyWebPUnclampedDelayTime];
            if (delayTimeUnclampedProp != nil) {
                frameDuration = [delayTimeUnclampedProp floatValue];
            } else {
                NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyWebPDelayTime];
                if (delayTimeProp != nil) {
                    frameDuration = [delayTimeProp floatValue];
                }
            }
        }
    } else {
        // Fallback on earlier versions
    }
    
    // Many annoying ads specify a 0 duration to make an image flash as quickly as possible.
    // We follow Firefox's behavior and use a duration of 100 ms for any frames that specify
    // a duration of <= 10 ms. See <rdar://problem/7689300> and <http://webkit.org/b/36082>
    // for more information.
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

+ (UIImage *)getGifThumbImageWithData:(NSData *)data time:(float)time {
    if (!data) {
        return nil;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *image;
    if (count <= 1) {
        image = [[UIImage alloc] initWithData:data];
    }
    else {
        float duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self ve_frameDurationAtIndex:i source:source];
            if (duration >= time) {
                image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
                CGImageRelease(imageRef);
                break;
            }            
            CGImageRelease(imageRef);
        }
    }
    
    CFRelease(source);
    return image;
}

+ (UIImage *)ve_animatedGIFNamed:(NSString *)name {
    CGFloat scale = [UIScreen mainScreen].scale;

    if (scale > 1.0f) {
        NSString *retinaPath = [[NSBundle mainBundle] pathForResource:[name stringByAppendingString:@"@2x"] ofType:@"gif"];

        NSData *data = [NSData dataWithContentsOfFile:retinaPath];

        if (data) {
            return [UIImage ve_animatedGIFWithData:data];
        }

        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];

        data = [NSData dataWithContentsOfFile:path];

        if (data) {
            return [UIImage ve_animatedGIFWithData:data];
        }

        return [UIImage imageNamed:[NSString stringWithFormat:@"VEUISDK.bundle/%@",name]];
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];

        NSData *data = [NSData dataWithContentsOfFile:path];

        if (data) {
            return [UIImage ve_animatedGIFWithData:data];
        }

        return [UIImage imageNamed:[NSString stringWithFormat:@"VEUISDK.bundle/%@",name]];
    }
}

- (UIImage *)ve_animatedImageByScalingAndCroppingToSize:(CGSize)size {
    if (CGSizeEqualToSize(self.size, size) || CGSizeEqualToSize(size, CGSizeZero)) {
        return self;
    }

    CGSize scaledSize = size;
    CGPoint thumbnailPoint = CGPointZero;

    CGFloat widthFactor = size.width / self.size.width;
    CGFloat heightFactor = size.height / self.size.height;
    CGFloat scaleFactor = (widthFactor > heightFactor) ? widthFactor : heightFactor;
    scaledSize.width = self.size.width * scaleFactor;
    scaledSize.height = self.size.height * scaleFactor;

    if (widthFactor > heightFactor) {
        thumbnailPoint.y = (size.height - scaledSize.height) * 0.5;
    }
    else if (widthFactor < heightFactor) {
        thumbnailPoint.x = (size.width - scaledSize.width) * 0.5;
    }

    NSMutableArray *scaledImages = [NSMutableArray array];

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);

    for (UIImage *image in self.images) {
        [image drawInRect:CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledSize.width, scaledSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

        [scaledImages addObject:newImage];
    }

    UIGraphicsEndImageContext();

    return [UIImage animatedImageWithImages:scaledImages duration:self.duration];
}

@end
