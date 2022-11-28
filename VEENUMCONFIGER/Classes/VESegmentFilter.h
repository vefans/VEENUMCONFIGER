//
//  VESegmentFilter.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/12/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VESegmentFilter : NSObject


-(int)segmentPixelBuffer:(CVPixelBufferRef)pixel maskPixelBuffer:(CVPixelBufferRef)mask;

@end

NS_ASSUME_NONNULL_END
