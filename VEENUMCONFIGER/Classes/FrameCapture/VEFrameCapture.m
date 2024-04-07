//
//  VEFrameCapture.m
//  VEENUMCONFIGER
//
//  Created by mac on 2024/1/27.
//

#import "VEFrameCapture.h"

@implementation VEFrameCapture{
    AVAssetReader *_assetReader;
    AVAssetReaderTrackOutput *_trackOutput;
    dispatch_queue_t _processingQueue;
    PixelBufferCallback _pixelBufferCallback;
}

- (instancetype)initWithURL:(NSURL *)assetURL {
    self = [super init];
    if (self) {
        AVAsset *asset = [AVAsset assetWithURL:assetURL];
        AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
        NSDictionary *outputSettings = @{
            (NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)
        };
        
        _trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:outputSettings];
        NSError *error;
        _assetReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
        if (error) {
            NSLog(@"Error initializing asset reader: %@", error);
            return nil;
        }
        
        [_assetReader addOutput:_trackOutput];
        _processingQueue = dispatch_queue_create("com.example.frameextractor.processing", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)startFromTime:(CMTime)startTime toTime:(CMTime)endTime callback:(PixelBufferCallback)callback {
    _pixelBufferCallback = [callback copy];
    [_assetReader startReading];
    
    dispatch_async(_processingQueue, ^{
        while (_assetReader.status == AVAssetReaderStatusReading) {
            CMSampleBufferRef sampleBuffer = [_trackOutput copyNextSampleBuffer];
            
            if (sampleBuffer) {
                CMTime sampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
                if (CMTIME_COMPARE_INLINE(sampleTime, >=, startTime) && CMTIME_COMPARE_INLINE(sampleTime, <=, endTime)) {
                    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                    CVPixelBufferRetain(imageBuffer);
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
                        _pixelBufferCallback(imageBuffer, sampleTime);
                        CVPixelBufferRelease(imageBuffer);
//                    });
                }
                CFRelease(sampleBuffer);
                
                if (CMTIME_COMPARE_INLINE(sampleTime, >, endTime)) {
                    break;
                }
            } else {
                break;
            }
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
            _pixelBufferCallback(nil, endTime);
//        });
    });
}

- (void)stop {
    [_assetReader cancelReading];
}

+(CVPixelBufferRef)getPixelBufferAtTime:(NSURL *)assetURL atTime:(CMTime) time {
    AVAsset *asset = [AVAsset assetWithURL:assetURL];
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    NSDictionary *outputSettings = @{
        (NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)
    };
    
    AVAssetReaderTrackOutput *trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:outputSettings];
    NSError *error;
    AVAssetReader *assetReader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    if (error) {
        NSLog(@"Error initializing asset reader: %@", error);
        return NULL;
    }
    
    [assetReader addOutput:trackOutput];
    [assetReader startReading];
    
    while (assetReader.status == AVAssetReaderStatusReading) {
        CMSampleBufferRef sampleBuffer = [trackOutput copyNextSampleBuffer];
        if (sampleBuffer) {
            CMTime sampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
            if (CMTIME_COMPARE_INLINE(sampleTime, >=, time)) {
                CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
                CVPixelBufferRetain(imageBuffer);
                CFRelease(sampleBuffer);
                [assetReader cancelReading];
                return imageBuffer;
            }
            CFRelease(sampleBuffer);
        } else {
            break;
        }
    }
    
    [assetReader cancelReading];
    return NULL;
}
@end
