//
//  VEFXFilter.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2019/11/26.
//  Copyright © 2019 iOS VESDK Team. All rights reserved.
//

#import "VEFXFilter.h"

@implementation VEFXFilter

- (id)mutableCopyWithZone:(NSZone *)zone{
    VEFXFilter *copy = [[self class] allocWithZone:zone];
    copy.ratingFrameTexturePath = _ratingFrameTexturePath;
    copy.customFilter = _customFilter;
    copy.timeFilterType = _timeFilterType;
    copy.filterTimeRange = _filterTimeRange;
    copy.FXTypeIndex = _FXTypeIndex;
    copy.nameStr = _nameStr;
    
    return copy;
}
- (id)copyWithZone:(NSZone *)zone{
    VEFXFilter *copy = [[self class] allocWithZone:zone];
    copy.ratingFrameTexturePath = _ratingFrameTexturePath;
    copy.customFilter = _customFilter;
    copy.timeFilterType = _timeFilterType;
    copy.filterTimeRange = _filterTimeRange;
    copy.FXTypeIndex = _FXTypeIndex;
    copy.nameStr = _nameStr;
    
    return copy;
}

- (void)dealloc{
    NSLog(@"_customFilter=>:%d",[[_customFilter valueForKey:@"retainCount"] intValue]);
    _customFilter = nil;
    _nameStr = nil;
    NSLog(@"%s",__func__);
}
@end
