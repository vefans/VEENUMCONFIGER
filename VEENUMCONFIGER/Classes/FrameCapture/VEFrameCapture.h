//
//  VEFrameCapture.h
//  VEENUMCONFIGER
//
//  Created by mac on 2024/1/27.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PixelBufferCallback)(CVPixelBufferRef pixelBuffer, CMTime currentTimp);

@interface VEFrameCapture : NSObject
@property (nonatomic, copy) void (^frameCallback)(CVPixelBufferRef pixelBuffer);

- (instancetype)initWithURL:(NSURL *)assetURL;
- (void)startFromTime:(CMTime)startTime toTime:(CMTime)endTime callback:(PixelBufferCallback)callback;
- (void)stop;

+(CVPixelBufferRef)getPixelBufferAtTime:(NSURL *)assetURL atTime:(CMTime) time;;

@end

NS_ASSUME_NONNULL_END
