//
//  UIImageView+LongCachePrivate.m
//  VEENUMCONFIGER
//
//  Created by emmet-mac on 2021/10/22.
//

#import "LongCacheImageView.h"
//#import <objc/runtime.h>
//static NSString *LongGifDataKey = @"LongGifDataKey";
@implementation LongCacheImageView
//
//- (void)setLongGifData:(NSData *)longGifData{
//    objc_setAssociatedObject(self, &LongGifDataKey, longGifData, OBJC_ASSOCIATION_COPY);
//}
//
//- (NSData *)longGifData{
//    return  objc_getAssociatedObject(self, &LongGifDataKey);
//}

- (void)playGif
{
    NSData *gifData = self.longGifData;
    if (gifData == nil) {
        [self stopAnimating];
        return;
    }
    
    if (!self.imageSourceRef) {
        self.imageSourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)(gifData), NULL);
    }
    
    NSUInteger numberOfFrames = CGImageSourceGetCount(self.imageSourceRef);
    NSInteger index = self.longIndex.integerValue;
    if (index >= numberOfFrames) {
        index = 0;
    }
    
    NSTimeInterval time = [self.timeDuration doubleValue];
    time += self.displayLink.duration;
    if (time <= [self _frameDurationAtIndex:index source:self.imageSourceRef]) {
        self.timeDuration = @(time);
        return;
    }
    self.timeDuration = 0;
    
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(self.imageSourceRef, index, NULL);
    self.image = [UIImage imageWithCGImage:imageRef];
//    [self.layer setNeedsDisplay];
    CFRelease(imageRef);
    [self setLongIndex:@(++index)];
}

- (void)long_startAnimating
{
    BOOL ret = self.longGifData != nil;
    
    if (ret) {
        if (!self.displayLink) {
            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(playGif)];
            [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        }
        self.displayLink.paused = NO;
    }
//    else {
//        [self long_startAnimating];
//    }
}

- (void)long_stopAnimating
{
    BOOL ret = self.displayLink != nil;
    
    if (ret) {
        self.displayLink.paused = YES;
        [self.displayLink invalidate];
        self.displayLink = nil;
    } else {
        //[self long_stopAnimating];
    }
}



- (float)_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    if (!cfFrameProperties) {
        return frameDuration;
    }
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp != nil) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp != nil) {
            frameDuration = [delayTimeProp floatValue];
        }
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

- (void)dealloc{
    if(_imageSourceRef){
        CFRelease(_imageSourceRef);
//        NSLog(@"释放");
    }
    self.image = nil;
//    NSLog(@"%s",__FUNCTION__);
}
@end
