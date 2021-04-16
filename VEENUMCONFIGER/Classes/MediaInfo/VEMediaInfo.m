//
//  MediaInfo.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/11/3.
//

#import "VEMediaInfo.h"

@implementation VEMediaInfo
- (instancetype)init{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    VEMediaInfo *copy = [[[self class] allocWithZone:zone] init];
    
    copy.fileType                = _fileType;
    copy.filtImagePatch          = _filtImagePatch;
    copy.isGif                   = _isGif;
    copy.imageDurationTime       = _imageDurationTime;
    copy->_contentURL            = _contentURL;
    copy->_localIdentifier       = _localIdentifier;
    copy.gifData                 = _gifData;
    copy.videoActualTimeRange    = _videoActualTimeRange;
    copy.imageTimeRange = _imageTimeRange;
    copy.thumbImage = _thumbImage;
    return copy;
}

- (id)copyWithZone:(NSZone *)zone{
    VEMediaInfo *copy = [[[self class] allocWithZone:zone] init];
    copy.fileType                = _fileType;
    copy.filtImagePatch          = _filtImagePatch;
    copy.isGif                   = _isGif;
    copy.imageDurationTime       = _imageDurationTime;
    copy->_contentURL            = _contentURL;
    copy->_localIdentifier       = _localIdentifier;
    copy.gifData                 = _gifData;
    copy.videoActualTimeRange    = _videoActualTimeRange;
    copy.imageTimeRange = _imageTimeRange;
    copy.thumbImage = _thumbImage;
    return copy;
}

@end
