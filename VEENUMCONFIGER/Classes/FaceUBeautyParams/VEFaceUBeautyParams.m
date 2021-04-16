//
//  VEFaceUBeautyParams.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import "VEFaceUBeautyParams.h"

@implementation VEFaceUBeautyParams

- (instancetype)init{
    if(self = [super init]){
        _cheekThinning                      = 0.68;
        _eyeEnlarging                       = 0.5;
        _colorLevel                         = 0.48;
        _blurLevel                          = 3.0;
        _faceShapeLevel                     = 1.0;
        _redLevel                           = 0.5;
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone{
    VEFaceUBeautyParams *copy   = [[[self class] allocWithZone:zone] init];
    copy.cheekThinning                      = _cheekThinning;
    copy.eyeEnlarging                       = _eyeEnlarging;
    copy.colorLevel                         = _colorLevel;
    copy.blurLevel                          = _blurLevel;
    copy.faceShapeLevel                     = _faceShapeLevel;
    copy.faceShape                          = _faceShape;
    copy.redLevel                          = _redLevel;

    return copy;
}

@end
