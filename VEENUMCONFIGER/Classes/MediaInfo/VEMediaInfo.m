//
//  MediaInfo.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/11/3.
//

#import <VEENUMCONFIGER/VEMediaInfo.h>
#import "VEHelp.h"
#import <LibVECore/VECoreYYModel.h>

@implementation VEMediaInfo

- (instancetype)init{
    self = [super init];
    if(self){
        _chromaColor = UIColorFromRGB(0x000000);
        _backgroundColor = UIColorFromRGB(0x000000);
        _rectInFile = CGRectZero;
        _rectInScale = 1.0;
        _filterIntensity = 1.0;
        _filterType = kFilterType_LookUp;
        _isStrip = YES;
        _rectInScene = CGRectMake(0, 0, 1, 1);
        _rectInScale = 1.0;
        _backgroundAlpha = 1.0;
        _videoVolume = 1.0;
        _speed = 1.0;
        _crop = CGRectMake(0, 0, 1, 1);
        _imageTimeRange = kCMTimeRangeZero;
        _animationTimeRange  = kCMTimeRangeZero;
        _animationOutTimeRange = kCMTimeRangeZero;
        _videoActualTimeRange = kCMTimeRangeZero;
        _videoTrimTimeRange = kCMTimeRangeInvalid;
        _reverseVideoTrimTimeRange = kCMTimeRangeInvalid;
        _fileCropModeType = kCropTypeOriginal;
        _transitionTypeIndex = -1;
        _transitionIndex = -1;
        _maskThickColorIndex = 11;
        _pitch = 1.0;
        _adjustments = [[ToningInfo alloc] init];
        _eq = [NSMutableArray new];
        _blur = [Blur new];
        for (int i = 0; i<10; i++) {
            EqObject * object = [[EqObject alloc] init];
            [_eq addObject:object];
            switch (i) {
                case 0:
                    object.frequecy = 31;
                    break;
                case 1:
                    object.frequecy = 63;
                    break;
                case 2:
                    object.frequecy = 125;
                    break;
                case 3:
                    object.frequecy = 250;
                    break;
                case 4:
                    object.frequecy = 500;
                    break;
                case 5:
                    object.frequecy = 1000;
                    break;
                case 6:
                    object.frequecy = 2000;
                    break;
                case 7:
                    object.frequecy = 4000;
                    break;
                case 8:
                    object.frequecy = 8000;
                    break;
                case 9:
                    object.frequecy = 16000;
                    break;
                default:
                    break;
            }
        }
    }
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    VEMediaInfo *copy = [[[self class] allocWithZone:zone] init];
    copy.isPasterAssetViewDrag = _isPasterAssetViewDrag;
    copy.audioSeparate = _audioSeparate;
    copy.pointsInVideoArray = [NSMutableArray new];
    [_pointsInVideoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray * array = [NSMutableArray new];
        [array addObject:((NSMutableArray*)obj)[0]];
        [array  addObject:((NSMutableArray*)obj)[1]];
        [copy.pointsInVideoArray addObject:array];
    }];
    copy.sceneIdentifier = _sceneIdentifier;
    copy.groupId = _groupId;
    copy.fxEffect = _fxEffect;
    copy.fileSoundEffect = _fileSoundEffect;
    copy.beautyBigEyeIntensity = _beautyBigEyeIntensity;
    copy.beautyThinFaceIntensity = _beautyThinFaceIntensity;
    copy.blendType = _blendType;
    copy.chromaColor = _chromaColor;
    copy.cutoutAlphaLower = _cutoutAlphaLower;
    copy.cutoutAlphaUpper = _cutoutAlphaUpper;
    copy.cutoutEdgeSize = _cutoutEdgeSize;
    copy.filterId = _filterId;
    copy.fxEffectTimeRange = _fxEffectTimeRange;
    copy.filterPath = _filterPath;
    copy.voiceFXIndex = _voiceFXIndex;
    copy.pitch = _pitch;
    copy.animation3D = _animation3D;
    copy.customAnimate = _customAnimate;
    copy.customOutAnimate = _customOutAnimate;
    copy.customOtherAnimate = _customOtherAnimate;
    copy.isSelfieSegmentation = _isSelfieSegmentation;
    copy.animate = _animate;
    
    if(  (_keyFrameTimeArray) && (_keyFrameTimeArray.count > 0)  )
    {
        copy.keyFrameTimeArray = [NSMutableArray new];
        [_keyFrameTimeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [copy.keyFrameTimeArray addObject:obj];
        }];
        copy.keyFrameRectRotateArray = [NSMutableArray new];
        [_keyFrameRectRotateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [copy.keyFrameRectRotateArray addObject:obj];
        }];
    }
    
    //降噪
    copy.denoiseLevel = _denoiseLevel;
//    copy.isIntelligentKey = _isIntelligentKey;
    copy.autoSegmentType = _autoSegmentType;
    copy.autoSegmentImageUrl = _autoSegmentImageUrl;
    copy.animationType = _animationType;
    copy.animationIndex= _animationIndex;
    copy.transitionIndex = _transitionIndex;
    copy.transitionTypeIndex = _transitionTypeIndex;
    copy.chromaColor= _chromaColor;
    copy.backgroundColor         = _backgroundColor;
    copy.backgroundType          = _backgroundType;
    copy.backgroundFile = [_backgroundFile mutableCopy];
    copy.backgroundStyle = _backgroundStyle;
    copy.backgroundBlurIntensity = _backgroundBlurIntensity;
    copy.imageInVideoTimeRange = _imageInVideoTimeRange;
    copy.rectInFile = _rectInFile;
    copy.rectInScale    = _rectInScale;
    copy.fileScale          = _fileScale;
    copy.beautyBlurIntensity     = _beautyBlurIntensity;
    copy.beautyToneIntensity     = _beautyToneIntensity;
    copy.beautyBrightIntensity   = _beautyBrightIntensity;
    copy.backgroundAlpha        = _backgroundAlpha;
    copy.fileType                = _fileType;
    copy.filtImagePatch          = _filtImagePatch;
    copy.isGif                   = _isGif;
    copy.reverseAudioType   = _reverseAudioType;
    copy.imageDurationTime       = _imageDurationTime;
    copy.imageTimeRange          = _imageTimeRange;
    copy.coverTime               = _coverTime;
    copy.fileTimeFilterTimeRange = _fileTimeFilterTimeRange;
    copy->_contentURL            = _contentURL;
    copy.draftContentURL         = _draftContentURL;
    copy.gifData                 = _gifData;
    copy.reverseVideoURL         = _reverseVideoURL;
    copy.filterNetworkCategoryId = _filterNetworkCategoryId;
    copy.filterNetworkResourceId = _filterNetworkResourceId;
    copy.filterIndex             = _filterIndex;
    copy.filterIntensity         = _filterIntensity;
    copy.isStrip                 = _isStrip;
    copy.filterType              = _filterType;
    copy.adjustments             = _adjustments;
    copy.speed                   = _speed;
    copy.speedIndex              = _speedIndex;
    copy.videoVolume             = _videoVolume;
    copy.audioFadeInDuration     = _audioFadeInDuration;
    copy.audioFadeOutDuration    = _audioFadeOutDuration;
    copy.videoTimeRange          = _videoTimeRange;
    copy.videoActualTimeRange    = _videoActualTimeRange;
    copy.reverseVideoTimeRange   = _reverseVideoTimeRange;
    copy.videoDurationTime       = _videoDurationTime;
    copy.reverseDurationTime     = _reverseDurationTime;
    copy.crop                    = _crop;
    copy.rotate                  = _rotate;
    copy.isReverse               = _isReverse;
    copy.isVerticalMirror        = _isVerticalMirror;
    copy.isHorizontalMirror      = _isHorizontalMirror;
    copy.transition  = _transition;
    copy.transitionNetworkCategoryId = _transitionNetworkCategoryId;
    copy.transitionNetworkResourceId = _transitionNetworkResourceId;
    copy.transitionDuration      = _transitionDuration;
    copy.transitionTypeName      = _transitionTypeName;
    copy.transitionName          = _transitionName;
    copy.transitionMask          = _transitionMask;
    copy.thumbImage              = _thumbImage;
    copy.cropRect                = _cropRect;
    copy.isMove = _isMove;
    copy.fileCropModeType        = _fileCropModeType;
    copy.customFilterIndex       = _customFilterIndex;
    copy.customFilterId          = _customFilterId;
    copy.fileTimeFilterType      = _fileTimeFilterType;
    copy.videoTrimTimeRange          = _videoTrimTimeRange;
    copy.reverseVideoTrimTimeRange   = _reverseVideoTrimTimeRange;
    copy.customTextPhotoFile         = [_customTextPhotoFile copy];
    copy.rectInScene                 = _rectInScene;
    copy.timeEffectSceneCount        = _timeEffectSceneCount;
    
    if(_curvedSpeedPointArray.count > 0)
    {
        copy.curvedSpeedPointArray = [NSMutableArray<CurvedSpeedPoint *> array];
        copy.curveSpeedIndex = _curveSpeedIndex;
        [_curvedSpeedPointArray enumerateObjectsUsingBlock:^(CurvedSpeedPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CurvedSpeedPoint * speedPoint = [obj mutableCopy];
            [copy.curvedSpeedPointArray addObject:speedPoint];
        }];
    }
    copy.isSlomoVideo = _isSlomoVideo;
    
    if (_mask) {
        copy.maskName = _maskName;
//        MaskObject *mask = [VEHelp getMaskWithName:_maskName];
        copy.maskThickColorIndex =_maskThickColorIndex;
        copy.maskType = _maskType;
        copy.mask = [_mask copy];
    }
    
    if( _keyFrameTimeArray && (_keyFrameTimeArray.count > 0) )
    {
        copy.keyFrameTimeArray = [NSMutableArray new];
        [_keyFrameTimeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber * number = [obj copy];
            [copy.keyFrameTimeArray addObject:number];
        }];
    }
    
    if( _keyFrameRectRotateArray && (_keyFrameRectRotateArray.count > 0) )
    {
        copy.keyFrameRectRotateArray = [NSMutableArray new];
        [_keyFrameRectRotateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray * array = (NSMutableArray*)obj;
            NSMutableArray *objArray = [NSMutableArray new];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if( [obj1 isKindOfClass:[NSNumber class]] )
                {
                    NSNumber * number = [obj1 copy];
                    [objArray  addObject:number];
                }
                else if( [obj1 isKindOfClass:[NSValue class]] )
                {
                    NSValue * value = [obj1 copy];
                    [objArray addObject:value];
                }
                else if( [obj1 isKindOfClass:[NSMutableArray class]] )
                {
                    NSMutableArray *adjustArray = [NSMutableArray array];
                    for (id value1 in obj1) {
                        if ([value1 isKindOfClass:[NSNumber class]]) {
                            [adjustArray addObject:value1];
                        }
                        else if ([value1 isKindOfClass:[NSValue class]]) {
                            [adjustArray addObject:NSStringFromCGPoint(((NSValue *)value1).CGPointValue)];
                        }
                    }
                    [objArray addObject:adjustArray];
                }
            }];
            [copy.keyFrameRectRotateArray addObject:objArray];
        }];
    }
    if (_multipleFaceAttribute.count > 0) {
        copy.multipleFaceAttribute = [NSMutableArray array];
        [_multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [copy.multipleFaceAttribute addObject:[obj copy]];
        }];
    }
    copy.eq = [NSMutableArray new];
    [_eq enumerateObjectsUsingBlock:^(EqObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EqObject * newObject = [EqObject new];
        newObject.frequecy = obj.frequecy;
        newObject.gain = obj.gain;
        [copy.eq addObject:newObject];
    }];
    copy.importMorph = _importMorph;
    copy.speedHoldPitch = _speedHoldPitch;
    copy.panorama = [_panorama mutableCopy];
    
    return copy;
}

- (id)copyWithZone:(NSZone *)zone{
    VEMediaInfo *copy = [[[self class] allocWithZone:zone] init];
    copy.isPasterAssetViewDrag = _isPasterAssetViewDrag;
    copy.audioSeparate = _audioSeparate;
    copy.pointsInVideoArray = [NSMutableArray new];
    [_pointsInVideoArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray * array = [NSMutableArray new];
        [array addObject:((NSMutableArray*)obj)[0]];
        [array  addObject:((NSMutableArray*)obj)[1]];
        [copy.pointsInVideoArray addObject:array];
    }];
    copy.sceneIdentifier = _sceneIdentifier;
    copy.groupId = _groupId;
    copy.fxEffect = _fxEffect;
    copy.fxFileId = _fxFileId;
    copy.isMove = _isMove;
    copy.transition = _transition;
    copy.fileSoundEffect = _fileSoundEffect;
    copy.beautyBigEyeIntensity = _beautyBigEyeIntensity;
    copy.beautyThinFaceIntensity = _beautyThinFaceIntensity;
    copy.voiceFXIndex = _voiceFXIndex;
    copy.pitch = _pitch;
    copy.rectInFile = _rectInFile;
    copy.animation3D = _animation3D;
    copy.customAnimate = _customAnimate;
    copy.customOutAnimate = _customOutAnimate;
    copy.customOtherAnimate = _customOtherAnimate;
    copy.isSelfieSegmentation = _isSelfieSegmentation;
    copy.animate = _animate;
    //降噪
    copy.denoiseLevel = _denoiseLevel;
//    copy.isIntelligentKey = _isIntelligentKey;
    copy.autoSegmentType = _autoSegmentType;
    copy.autoSegmentImageUrl = _autoSegmentImageUrl;
    copy.animationType = _animationType;
    copy.animationIndex= _animationIndex;
    copy.transitionIndex = _transitionIndex;
    copy.transitionTypeIndex = _transitionTypeIndex;
    copy.chromaColor= _chromaColor;
    copy.backgroundColor         = _backgroundColor;
    copy.backgroundType          = _backgroundType;
    copy.backgroundFile = [_backgroundFile mutableCopy];
    copy.backgroundStyle = _backgroundStyle;
    copy.backgroundBlurIntensity = _backgroundBlurIntensity;
    copy.rectInScale    = _rectInScale;
    copy.fileScale          = _fileScale;
    copy.beautyBlurIntensity     = _beautyBlurIntensity;
    copy.beautyToneIntensity     = _beautyToneIntensity;
    copy.beautyBrightIntensity   = _beautyBrightIntensity;
    copy.backgroundAlpha         = _backgroundAlpha;
    copy.fileType                = _fileType;
    copy.filtImagePatch          = _filtImagePatch;
    copy.isGif                   = _isGif;
    copy.fileTimeFilterTimeRange = _fileTimeFilterTimeRange;
    copy.imageDurationTime       = _imageDurationTime;
    copy.imageInVideoTimeRange = _imageInVideoTimeRange;
    copy.imageTimeRange          = _imageTimeRange;
    copy.coverTime               = _coverTime;
    copy->_contentURL            = _contentURL;
    copy.draftContentURL         = _draftContentURL;
    copy.gifData                 = _gifData;
    copy.reverseVideoURL         = _reverseVideoURL;
    copy.filterNetworkCategoryId = _filterNetworkCategoryId;
    copy.filterNetworkResourceId = _filterNetworkResourceId;
    copy.filterIndex             = _filterIndex;
    copy.filterIntensity         = _filterIntensity;
    copy.isStrip                 = _isStrip;
    copy.filterType              = _filterType;
    copy.adjustments             = _adjustments;
    copy.speed                   = _speed;
    copy.speedIndex              = _speedIndex;
    copy.videoVolume             = _videoVolume;
    copy.audioFadeInDuration     = _audioFadeInDuration;
    copy.audioFadeOutDuration    = _audioFadeOutDuration;
    copy.videoTimeRange          = _videoTimeRange;
    copy.videoActualTimeRange    = _videoActualTimeRange;
    copy.reverseVideoTimeRange   = _reverseVideoTimeRange;
    copy.videoDurationTime       = _videoDurationTime;
    copy.reverseDurationTime     = _reverseDurationTime;
    copy.crop                    = _crop;
    copy.fileCropModeType        = _fileCropModeType;
    copy.customFilterIndex       = _customFilterIndex;
    copy.customFilterId          = _customFilterId;
    copy.fileTimeFilterType      = _fileTimeFilterType;
    copy.rotate                  = _rotate;
    copy.reverseAudioType   = _reverseAudioType;
    copy.isReverse               = _isReverse;
    copy.isVerticalMirror        = _isVerticalMirror;
    copy.isHorizontalMirror      = _isHorizontalMirror;
    copy.transitionNetworkCategoryId = _transitionNetworkCategoryId;
    copy.transitionNetworkResourceId = _transitionNetworkResourceId;
    copy.transitionDuration      = _transitionDuration;
    copy.transitionTypeName      = _transitionTypeName;
    copy.transitionName          = _transitionName;
    copy.transitionMask          = _transitionMask;
    copy.thumbImage              = _thumbImage;
    copy.cropRect                = _cropRect;
    copy.videoTrimTimeRange          = _videoTrimTimeRange;
    copy.reverseVideoTrimTimeRange   = _reverseVideoTrimTimeRange;
    copy.customTextPhotoFile         = [_customTextPhotoFile copy];
    copy.rectInScene                 = _rectInScene;
    copy.timeEffectSceneCount        = _timeEffectSceneCount;
    
    if(_curvedSpeedPointArray.count > 0)
    {
        copy.curvedSpeedPointArray = [NSMutableArray<CurvedSpeedPoint *> array];
        copy.curveSpeedIndex = _curveSpeedIndex;
        [_curvedSpeedPointArray enumerateObjectsUsingBlock:^(CurvedSpeedPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CurvedSpeedPoint * speedPoint = [obj copy];
            [copy.curvedSpeedPointArray addObject:speedPoint];
        }];
    }
    copy.isSlomoVideo = _isSlomoVideo;
    
    if (_mask) {
        copy.maskName = _maskName;
//        MaskObject *mask = [VEHelp getMaskWithName:_maskName];
        copy.maskThickColorIndex =_maskThickColorIndex;
        copy.maskType = _maskType;
        copy.mask = [_mask copy];
    }
    
    if( _keyFrameTimeArray && (_keyFrameTimeArray.count > 0) )
    {
        copy.keyFrameTimeArray = [NSMutableArray new];
        [_keyFrameTimeArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber * number = [obj copy];
            [copy.keyFrameTimeArray addObject:number];
        }];
    }
    
    if( _keyFrameRectRotateArray && (_keyFrameRectRotateArray.count > 0) )
    {
        copy.keyFrameRectRotateArray = [NSMutableArray new];
        [_keyFrameRectRotateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSMutableArray * array = (NSMutableArray*)obj;
            NSMutableArray *objArray = [NSMutableArray new];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if( [obj1 isKindOfClass:[NSNumber class]] )
                {
                    NSNumber * number = [obj1 copy];
                    [objArray  addObject:number];
                }
                else if( [obj1 isKindOfClass:[NSValue class]] )
                {
                    NSValue * value = [obj1 copy];
                    [objArray addObject:value];
                }
                else if( [obj1 isKindOfClass:[NSMutableArray class]] )
                {
                    NSMutableArray *adjustArray = [NSMutableArray array];
                    for (id value1 in obj1) {
                        if ([value1 isKindOfClass:[NSNumber class]]) {
                            [adjustArray addObject:value1];
                        }
                        else if ([value1 isKindOfClass:[NSValue class]]) {
                            [adjustArray addObject:NSStringFromCGPoint(((NSValue *)value1).CGPointValue)];
                        }
                    }
                    [objArray addObject:adjustArray];
                }
            }];
            [copy.keyFrameRectRotateArray addObject:objArray];
        }];
    }
    if (_multipleFaceAttribute.count > 0) {
        copy.multipleFaceAttribute = [NSMutableArray array];
        [_multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [copy.multipleFaceAttribute addObject:[obj copy]];
        }];
    }
    copy.eq = [NSMutableArray new];
    [_eq enumerateObjectsUsingBlock:^(EqObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        EqObject * newObject = [EqObject new];
        newObject.frequecy = obj.frequecy;
        newObject.gain = obj.gain;
        [copy.eq addObject:newObject];
    }];
    copy.importMorph = _importMorph;
    copy.speedHoldPitch = _speedHoldPitch;
    copy.panorama = [_panorama copy];
    
    return copy;
}


- (instancetype)initWithMediaAsset:(MediaAsset *)asset {
    NSDictionary *dic = [asset veCore_yy_modelToJSONObject];
    if (dic) {
        self = [VEMediaInfo veCore_yy_modelWithDictionary:dic];
        if (![VEHelp isSystemPhotoUrl:asset.url]) {
            asset.url = [VEHelp getFileURLFromAbsolutePath:asset.url.path];
            if ([asset.url.absoluteString.pathExtension isEqualToString:@"webp"]) {
                NSURL *url = [NSURL fileURLWithPath:[asset.url.path.stringByDeletingPathExtension stringByAppendingPathExtension:@"png"]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:url.path]) {
                    UIImage *image = [VEHelp imageWithWebP:asset.url.path error:nil];
                    if (image) {
                        NSData *imageData = UIImagePNGRepresentation(image);
                        [imageData writeToFile:url.path atomically:YES];
                        [[NSFileManager defaultManager] removeItemAtURL:asset.url error:nil];
                    }
                }
                asset.url = url;
            }
        }
        self.antiShakeUrl = asset.antiShakeUrl;
        self.antiShakeType = asset.antiShakeType;
        self.contentURL = asset.url;
        _thumbImage = [VEHelp getThumbImageWithUrl:_contentURL];
        if ([VEHelp isImageUrl:_contentURL]) {
            _fileType = kFILEIMAGE;
            _imageDurationTime = asset.timeRange.duration;
            _imageTimeRange = asset.timeRange;
            if ([VEHelp isSystemPhotoUrl:_contentURL]) {
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                option.synchronous = YES;
                option.resizeMode = PHImageRequestOptionsResizeModeExact;
                PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithALAssetURLs:@[_contentURL] options:nil];
                if (!result || result.count == 0) {
                    return nil;
                }
                PHAsset* asset = [result objectAtIndex:0];
                if ([[asset valueForKey:@"uniformTypeIdentifier"] isEqualToString:@"com.compuserve.gif"]) {
                    _filtImagePatch = [VEHelp getMaterialThumbnail:_contentURL];
                    _isGif = YES;
                    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                                      options:option
                                                                resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                        self.gifData = imageData;
                        float imageDuration = [VECore isGifWithData:imageData];
                        self.imageDurationTime = CMTimeMakeWithSeconds(imageDuration, NSEC_PER_SEC);
                                                                }];
                }
            }else {
                NSData *data = [NSData dataWithContentsOfURL:_contentURL];
                CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
                size_t count = CGImageSourceGetCount(source);
                if (count > 1) {
                    _filtImagePatch = [VEHelp getMaterialThumbnail:_contentURL];
                    _isGif = YES;
                    _gifData = data;
                    float imageDuration = [VECore isGifWithData:data];
                    _imageDurationTime = CMTimeMakeWithSeconds(imageDuration, NSEC_PER_SEC);
                }
                if (source) {
                    CFRelease(source);
                }
            }
            if (_autoSegmentType) {
                NSString *autoSegmentImagePath = [VEHelp getAutoSegmentImagePath:_contentURL];
                if ([[NSFileManager defaultManager] fileExistsAtPath:autoSegmentImagePath]) {
                    _autoSegmentImageUrl = [NSURL fileURLWithPath:autoSegmentImagePath];
                }
            }
        }else {
            _filtImagePatch = [VEHelp getMaterialThumbnail:_contentURL];
            _fileType = kFILEVIDEO;
            self.videoTrimTimeRange = asset.timeRange;
            self.videoTimeRange = _videoActualTimeRange;
            _reverseVideoTimeRange = _videoTimeRange;
        }
        if (asset.filterUrl) {
            _filterPath = [VEHelp getFileURLFromAbsolutePath_str:asset.filterUrl.absoluteString];
        }
        if (asset.audioFilterType != AudioFilterTypeNormal) {
            _fileSoundEffect = asset.audioFilterType - 1;
        }
        if (asset.curvedSpeedPointArray.count > 0) {
            _curveSpeedIndex = asset.curveSpeedType + 1;
        }
        if (asset.audioFilterType == AudioFilterTypeCustom) {
            _voiceFXIndex = -1;
        }else if (asset.audioFilterType <= AudioFilterTypeCartoon) {
            _voiceFXIndex = asset.audioFilterType;
        }else {
            _voiceFXIndex = asset.audioFilterType - 1;
        }
        [asset.customMultipleFilterArray enumerateObjectsUsingBlock:^(CustomMultipleFilter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.folderPath = [VEHelp getFileURLFromAbsolutePath_str:obj.folderPath];
            CustomMultipleFilter * customMultipleFilter = [VEHelp getCustomMultipleFilerWithFolderPath:obj.folderPath currentFrameImagePath:_contentURL.path];
            customMultipleFilter.timeRange = obj.timeRange;
            customMultipleFilter.networkCategoryId = obj.networkCategoryId;
            customMultipleFilter.networkResourceId = obj.networkResourceId;
            customMultipleFilter.overlayType = obj.overlayType;
            _fxEffect = customMultipleFilter;
            _fxEffectTimeRange = customMultipleFilter.timeRange;
        }];
        if (asset.pointsInVideoArray.count > 0) {
            _pointsInVideoArray = [asset.pointsInVideoArray mutableCopy];
        }
        [asset.animate enumerateObjectsUsingBlock:^(MediaAssetAnimatePosition * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.pointsArray.count > 0) {
                MediaAssetAnimatePosition *animate = _animate[idx];
                [animate setPointsLeftTop:CGPointMake([obj.pointsArray[0][0] floatValue], [obj.pointsArray[0][1] floatValue])
                                 rightTop:CGPointMake([obj.pointsArray[1][0] floatValue], [obj.pointsArray[1][1] floatValue])
                              rightBottom:CGPointMake([obj.pointsArray[2][0] floatValue], [obj.pointsArray[2][1] floatValue])
                               leftBottom:CGPointMake([obj.pointsArray[3][0] floatValue], [obj.pointsArray[3][1] floatValue])];
            }
        }];
        if (!asset.isUseRect && !asset.importMorph) {
            _isPasterAssetViewDrag = YES;
        }
    }
    return self;
}

// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray *)modelPropertyBlacklist {
    return @[@"contentURL", @"thumbImage"];
}

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"fileType" : @"type",
             @"videoVolume" : @"volume",
             @"backgroundAlpha" : @"alpha",
             @"backgroundBlurIntensity" : @"blurIntensity",
             @"rectInScene" : @"rectInVideo",
//             @"autoSegmentType" : @"autoSegmentType"
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"curvedSpeedPointArray" : [CurvedSpeedPoint class],
             @"animate" : [MediaAssetAnimatePosition class],
             @"multipleFaceAttribute" : [FaceAttribute class],
             @"adjustments" : [ToningInfo class],
             @"eq" : [EqObject class]
    };
}

// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (_keyFrameRectRotateArray.count > 0) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSArray *arr in _keyFrameRectRotateArray) {
            NSMutableArray *rotateArray = [NSMutableArray array];
            for (id value in arr) {
                if ([value isKindOfClass:[NSNumber class]]) {
                    [rotateArray addObject:value];
                }
                else if ([value isKindOfClass:[NSValue class]]) {
                    [rotateArray addObject:NSStringFromCGPoint(((NSValue *)value).CGPointValue)];
                }
                else if( [value isKindOfClass:[NSMutableArray class]] )
                {
                    NSMutableArray *adjustArray = [NSMutableArray array];
                    for (id value1 in value) {
                        if ([value1 isKindOfClass:[NSNumber class]]) {
                            [adjustArray addObject:value1];
                        }
                        else if ([value1 isKindOfClass:[NSValue class]]) {
                            [adjustArray addObject:NSStringFromCGPoint(((NSValue *)value1).CGPointValue)];
                        }
                    }
                    [rotateArray addObject:adjustArray];
                }
            }
            [array addObject:rotateArray];
        }
        [dic setObject:array forKey:@"keyFrameRectRotateArray"];
    }
    return YES;
}

// 当 JSON 转为 Model 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    self.contentURL = [VEHelp getFileURLFromAbsolutePath:_contentURL.absoluteString];
    _coverURL = [VEHelp getFileURLFromAbsolutePath:_coverURL.absoluteString];
    if(_filtImagePatch )
        _filtImagePatch = [VEHelp getFileURLFromAbsolutePath_str:_filtImagePatch];
    _reverseVideoURL = [VEHelp getFileURLFromAbsolutePath:_reverseVideoURL.path];
    if (_filterPath) {
        _filterPath = [VEHelp getFileURLFromAbsolutePath_str:_filterPath];
    }
    NSArray *pointsArray = dic[@"keyFrameRectRotateArray"];
    if (pointsArray && [pointsArray isKindOfClass:[NSArray class]]) {
        _keyFrameRectRotateArray = [NSMutableArray array];
        for (NSArray *arr in pointsArray) {
            NSMutableArray *rotateArray = [NSMutableArray array];
            for (id value in arr) {
                if ([value isKindOfClass:[NSString class]]) {
                    [rotateArray addObject:[NSValue valueWithCGPoint:CGPointFromString((NSString *)value)]];
                }
                else if( [value isKindOfClass:[NSMutableArray class]] )
                {
                    NSMutableArray *adjustArray = [NSMutableArray array];
                    for (id value1 in value) {
                        if ([value1 isKindOfClass:[NSString class]]) {
                            [adjustArray addObject:[NSValue valueWithCGPoint:CGPointFromString((NSString *)value1)]];
                        }else {
                            [adjustArray addObject:value1];
                        }
                    }
                    [rotateArray addObject:adjustArray];
                }else {
                    [rotateArray addObject:value];
                }
            }
            [_keyFrameRectRotateArray addObject:rotateArray];
        }
    }
    
    if( _customAnimate )
    {
        if( _customAnimate.folderPath )
            _customAnimate.folderPath = [VEHelp getFileURLFromAbsolutePath_str:_customAnimate.folderPath];
        
        CustomFilter * filter = [VEHelp getCustomFilterWithFolderPath:_customAnimate.folderPath currentFrameImagePath:nil atMedia:self];
        filter.networkCategoryId = _customAnimate.networkCategoryId;
        filter.networkResourceId = _customAnimate.networkResourceId;
        filter.timeRange = _customAnimate.timeRange;
        filter.animateType = _customAnimate.animateType;
        filter.cycleDuration = _customAnimate.cycleDuration;
        
        _animationType = _customAnimate.animateType;
        _customAnimate = filter;
        _animationTimeRange = filter.timeRange;
    }
    
    if( _customOutAnimate )
    {
        if( _customOutAnimate.folderPath )
            _customOutAnimate.folderPath = [VEHelp getFileURLFromAbsolutePath_str:_customOutAnimate.folderPath];
        
        CustomFilter * filter = [VEHelp getAnimateCustomFilter: _customOutAnimate.folderPath];
        filter.networkCategoryId = _customOutAnimate.networkCategoryId;
        filter.networkResourceId = _customOutAnimate.networkResourceId;
        filter.timeRange = _customOutAnimate.timeRange;
        filter.animateType = _customOutAnimate.animateType;
        filter.cycleDuration = _customAnimate.cycleDuration;
        
        _animationOutType = _customOutAnimate.animateType;
        _customOutAnimate = filter;
        _animationOutTimeRange = filter.timeRange;
    }
    
    if( _transition )
    {
        if( _transition.maskURL )
            _transition.maskURL = [VEHelp getFileURLFromAbsolutePath: _transition.maskURL.absoluteString];
        if( _transitionMask )
            _transitionMask =  [VEHelp getFileURLFromAbsolutePath:_transitionMask.absoluteString];
        if (_transition.type == TransitionTypeCustom && [[NSFileManager defaultManager] fileExistsAtPath:_transition.maskURL.path]) {
            _transition.customTransition = [VEHelp getCustomTransitionWithJsonPath:_transition.maskURL.path];
        }
    }
    
    if (_mask) {
        _mask.maskImagePath = [VEHelp getFileURLFromAbsolutePath_str:_mask.maskImagePath];
        _mask.folderPath = [VEHelp getFileURLFromAbsolutePath_str:_mask.folderPath];
        
        _maskName = _mask.folderPath.lastPathComponent;
        MaskObject *mask = [VEHelp getMaskWithName:_maskName];
        _mask.name = mask.name;
        _mask.frag = mask.frag;
        _mask.vert = mask.vert;
        _mask.maskImagePath = mask.maskImagePath;
        if (_mask.edgeColor) {
            _maskThickColorIndex = [VEHelp getColorIndex:_mask.edgeColor];
        }
        NSMutableArray *maskArray = [VEHelp getMaskArray];
        [maskArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([_maskName isEqualToString:obj[@"title"]]) {
                _maskType = idx;
                *stop = YES;
            }
        }];
    }
    
    return YES;
}

//20210106 用于从草稿箱读取
- (void)setDraftContentURL:(NSURL *)draftContentURL {
    _contentURL = draftContentURL;
    _draftContentURL = draftContentURL;
}

- (void)setContentURL:(NSURL *)contentURL {
    _contentURL = contentURL;
    _draftContentURL = contentURL;
    if (_isSlomoVideo && _localIdentifier.length > 0) {
        NSString *directory = [kVEDirectory stringByAppendingPathComponent:@"SlomoVideo"];
        if(![[NSFileManager defaultManager] fileExistsAtPath:directory]){
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *path;
        NSArray *temp = [_localIdentifier componentsSeparatedByString:@"/"];
        if (temp.count > 0) {
            path = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov", [temp firstObject]]];
        }else {
            path = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov", _localIdentifier]];
        }
        if ([_contentURL.absoluteString.lastPathComponent isEqual:path.lastPathComponent] && CMTimeRangeEqual(_videoActualTimeRange, kCMTimeRangeZero)) {
            _videoActualTimeRange = [VECore getActualTimeRange:contentURL];
            if (CMTimeCompare(_videoActualTimeRange.duration, kCMTimeZero) == 1) {
                _videoDurationTime = _videoActualTimeRange.duration;
            }
        }
    }
    else if (contentURL && ![VEHelp isImageUrl:contentURL] && CMTimeRangeEqual(_videoActualTimeRange, kCMTimeRangeZero)) {
        _videoActualTimeRange = [VECore getActualTimeRange:contentURL];
        if (CMTimeCompare(_videoActualTimeRange.duration, kCMTimeZero) == 1) {
            _videoDurationTime = _videoActualTimeRange.duration;
        }
    }
}

- (void)setVideoDurationTime:(CMTime)videoDurationTime {
    _videoDurationTime = CMTimeMakeWithSeconds(CMTimeGetSeconds(videoDurationTime), TIMESCALE);
    if (CMTimeCompare(_videoActualTimeRange.duration, kCMTimeZero) == 1 && CMTimeCompare(_videoDurationTime, _videoActualTimeRange.duration) == 1) {
        _videoDurationTime = _videoActualTimeRange.duration;
    }
}

- (void)setVideoTimeRange:(CMTimeRange)videoTimeRange{
    if(CMTimeRangeEqual(videoTimeRange, kCMTimeRangeInvalid)){
        _videoTimeRange = CMTimeRangeMake(kCMTimeZero, _videoDurationTime);
    }else{
        _videoTimeRange = videoTimeRange;
    }
    if (CMTimeCompare(_videoActualTimeRange.duration, kCMTimeZero) == 1) {
        if (CMTimeCompare(_videoActualTimeRange.start, _videoTimeRange.start) == 1) {
            _videoTimeRange = CMTimeRangeMake(_videoActualTimeRange.start, _videoTimeRange.duration);
        }
        if (CMTimeCompare(_videoTimeRange.duration, _videoActualTimeRange.duration) == 1) {
            _videoTimeRange = _videoActualTimeRange;
        }
    }
}

- (void)setVideoTrimTimeRange:(CMTimeRange)videoTrimTimeRange{
    if(CMTimeRangeEqual(videoTrimTimeRange, kCMTimeRangeInvalid)){
        _videoTrimTimeRange = _videoTimeRange;
    }else{
        _videoTrimTimeRange = videoTrimTimeRange;
    }
    if (CMTimeCompare(_videoTrimTimeRange.duration, kCMTimeZero) == -1) {
        _videoTrimTimeRange = _videoActualTimeRange;
    }
}

- (void)setReverseVideoTimeRange:(CMTimeRange)reverseVideoTimeRange{
    if(CMTimeRangeEqual(reverseVideoTimeRange, kCMTimeRangeInvalid)){
        _reverseVideoTimeRange = CMTimeRangeMake(kCMTimeZero, _reverseDurationTime);
    }else{
        _reverseVideoTimeRange = reverseVideoTimeRange;
    }
}

- (void)setReverseVideoTrimTimeRange:(CMTimeRange)reverseVideoTrimTimeRange{
    if(CMTimeRangeEqual(reverseVideoTrimTimeRange, kCMTimeRangeInvalid)){
        _reverseVideoTrimTimeRange = _reverseVideoTimeRange;
    }else{
        _reverseVideoTrimTimeRange = reverseVideoTrimTimeRange;
    }
}

- (void)setRotate:(double)rotate {
    _rotate = rotate;
    if (_rotate < 0) {
        _rotate += 360;
    }
}

- (MediaAsset *)getMedia {
    MediaAsset *media = [[MediaAsset alloc] init];
    media.url = _contentURL;
    if (_filterPath.length > 0) {
        media.filterUrl = [NSURL fileURLWithPath:_filterPath];
        media.filterType = kFilterType_LookUp;
        media.filterIntensity = _filterIntensity;
    }
    //智能抠图
    media.autoSegmentType = _autoSegmentType;
    //透明度
    media.alpha = _backgroundAlpha;
    //美颜
    media.beautyBlurIntensity =  _beautyBlurIntensity;
    media.beautyBrightIntensity = _beautyBrightIntensity;
    media.beautyToneIntensity = _beautyToneIntensity;
    media.beautyThinFaceIntensity = _beautyThinFaceIntensity;
    media.beautyBigEyeIntensity = _beautyBigEyeIntensity;
    media.multipleFaceAttribute = _multipleFaceAttribute;
    //调色
    media.adjustments = _adjustments;
    
    //降噪
    media.denoiseLevel = _denoiseLevel;
    
    //特效
    if( _fxEffect )
    {
        media.customMultipleFilterArray = [NSMutableArray new];
        [media.customMultipleFilterArray addObject:_fxEffect];
//        media.customFilterArray = [NSMutableArray new];
//        [media.customFilterArray addObject:_fxEffect];
    }
    
    //变声
    if( _fileSoundEffect > 0 )
    {
        media.audioFilterType = _fileSoundEffect;
        float defaultPitch = _pitch;
        if (media.audioFilterType == AudioFilterTypeBoy) {
            defaultPitch = 0.8;
        }else if (media.audioFilterType == AudioFilterTypeGirl) {
            defaultPitch = 1.27;
        }else if (media.audioFilterType == AudioFilterTypeMonster) {
            defaultPitch = 0.6;
        }else if (media.audioFilterType == AudioFilterTypeCartoon) {
            defaultPitch = 0.45;
        }else if (media.audioFilterType == AudioFilterTypeCartoonQuick) {
            defaultPitch = 0.55;
        }
        media.pitch = defaultPitch;
    }
    
    //抠图
    if( _chromaColor )
    {
        media.chromaColor = _chromaColor;
        media.blendType = _blendType;
        media.cutoutAlphaLower = _cutoutAlphaLower;
        media.cutoutAlphaUpper = _cutoutAlphaUpper;
        media.cutoutEdgeSize = _cutoutEdgeSize;
    }
#if 0
    //组合动画
    if( (_animationIndex > 1) )
    {
        NSMutableDictionary * itemDic = self.animationArray[_animationType][@"data"][_animationIndex-2];
        media.customAnimate = [VEHelp getAnimationCustomFilter:itemDic categoryId:_animationArray[_animationType][@"id"]];
        media.customAnimate.networkCategoryId = _animationArray[_animationType][@"id"];
        media.customAnimate.timeRange = _animationTimeRange;
        if( _animationType == 0 )
        {
            media.customAnimate.animateType = CustomAnimationTypeIn;
        }
        else
        {
            media.customAnimate.animateType = CustomAnimationTypeCombined;
        }
    }else if (_customAnimate) {
        if (_animationArray.count > 0 && _customAnimate.networkCategoryId.length > 0 && _customAnimate.networkResourceId.length > 0) {
            [_animationArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if ([obj1[@"typeId"] isEqual:_customAnimate.networkCategoryId]) {
                    [obj1[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                        if ([obj2[@"id"] isEqual:_customAnimate.networkResourceId]) {
                            _animationIndex = idx2 + 2;
                            *stop2 = YES;
                        }
                    }];
                    *stop1 = YES;
                }
            }];
        }
        media.customAnimate = _customAnimate;
    }
    if( (_animationOutIndex > 0) && !( (_animationType == 2) && (_animationIndex > 0) ) )
    {
        NSMutableDictionary * itemDic = self.animationArray[_animationOutType][@"data"][_animationOutIndex-2];
        media.customOutAnimate = [VEHelp getAnimationCustomFilter:itemDic categoryId:_animationArray[_animationOutType][@"id"]];
        media.customOutAnimate.timeRange = _animationOutTimeRange;
        media.customOutAnimate.animateType = CustomAnimationTypeOut;
    }
    else if (_customOutAnimate) {
        if (_animationArray.count > 0 && _customOutAnimate.networkCategoryId.length > 0 && _customOutAnimate.networkResourceId.length > 0) {
            [_animationArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if ([obj1[@"typeId"] isEqual:_customOutAnimate.networkCategoryId]) {
                    [obj1[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                        if ([obj2[@"id"] isEqual:_customOutAnimate.networkResourceId]) {
                            _animationOutIndex = idx2 + 2;
                            *stop2 = YES;
                        }
                    }];
                    *stop1 = YES;
                }
            }];
        }
        media.customOutAnimate = _customOutAnimate;
    }
#endif
    //蒙版
    media.mask = _mask;
    
    //曲线变速
    if( _curvedSpeedPointArray && (_curvedSpeedPointArray.count >= 2) )
    {
        media.curvedSpeedPointArray = _curvedSpeedPointArray;
        media.curveSpeedType = _curveSpeedIndex - 1;
    }
    
    if(_fileType == kFILEVIDEO){
        media.type = MediaAssetTypeVideo;
        media.videoActualTimeRange = _videoActualTimeRange;
        if(_isReverse){
            media.url = _reverseVideoURL;
            if (CMTimeRangeEqual(kCMTimeRangeZero, _reverseVideoTimeRange)) {
                media.timeRange = CMTimeRangeMake(kCMTimeZero, _reverseDurationTime);
            }else{
                media.timeRange = _reverseVideoTimeRange;
            }
            if(CMTimeCompare(media.timeRange.duration, _reverseVideoTrimTimeRange.duration) == 1 && CMTimeGetSeconds(_reverseVideoTrimTimeRange.duration)>0){
                media.timeRange = _reverseVideoTrimTimeRange;
            }
        }
        else{
            if (CMTimeRangeEqual(kCMTimeRangeZero, _videoTimeRange)) {
                media.timeRange = CMTimeRangeMake(kCMTimeZero, _videoDurationTime);
                if(CMTimeRangeEqual(kCMTimeRangeZero, media.timeRange)){
                    media.timeRange = CMTimeRangeMake(kCMTimeZero, [AVURLAsset assetWithURL:_contentURL].duration);
                }
            }else{
                media.timeRange = _videoTimeRange;
            }
            if(!CMTimeRangeEqual(kCMTimeRangeZero, _videoTrimTimeRange) && CMTimeCompare(media.timeRange.duration, _videoTrimTimeRange.duration) == 1){
                media.timeRange = _videoTrimTimeRange;
            }
        }
        media.speed        = _speed;
        media.volume = _videoVolume;
        media.audioFadeInDuration = _audioFadeInDuration;
        media.audioFadeOutDuration = _audioFadeOutDuration;
    }else{
        media.type         = MediaAssetTypeImage;
        if( ((CMTimeCompare(_imageTimeRange.duration, kCMTimeZero) == 1)
             || ( CMTimeGetSeconds(_imageTimeRange.duration) > 0)) && (_isGif)
        ){
            media.timeRange = _imageTimeRange;
        }else {
            media.timeRange    = CMTimeRangeMake(kCMTimeZero, _imageDurationTime);
        }
        media.speed        = _speed;
        media.volume       = _videoVolume;
        
        media.fillType = ImageMediaFillTypeFit;
#if isUseCustomLayer
        if (_fileType == kFILETEXT) {
            media.fillType = ImageMediaFillTypeFull;
        }
#endif
    }
    
    media.rotate = _rotate;
    media.isVerticalMirror = _isVerticalMirror;
    media.isHorizontalMirror = _isHorizontalMirror;
    media.crop = _crop;
    
    if( (_keyFrameTimeArray) && (_keyFrameTimeArray.count > 0) )
    {
//        [VEHelp setAssetAnimationArray_Keyframe:media file:self];
    }else if (_animate.count > 0) {
        media.animate = _animate;
        _keyFrameTimeArray = [NSMutableArray array];
        _keyFrameRectRotateArray = [NSMutableArray array];
        for (int i = 1; i < _animate.count - 1; i++) {
            MediaAssetAnimatePosition *obj1 = _animate[i];
            [_keyFrameTimeArray addObject:[NSNumber numberWithFloat:obj1.atTime]];
            
            NSMutableArray * array = [NSMutableArray array];
            [array addObject:[NSNumber numberWithFloat:obj1.rect.origin.x]];
            [array addObject:[NSNumber numberWithFloat:obj1.rect.origin.y]];
            [array addObject:[NSNumber numberWithFloat:obj1.rect.size.width]];
            [array addObject:[NSNumber numberWithFloat:obj1.rect.size.height]];
            {
                NSMutableArray * adjustArray = [NSMutableArray new];
                [adjustArray addObject:[NSNumber numberWithFloat:obj1.rotate]];
                [adjustArray addObject:[NSNumber numberWithFloat:obj1.opacity]];
                if (obj1.adjustments) {
                    [adjustArray addObject:[obj1.adjustments copy]];
                }
                [array addObject:adjustArray];
            }
//            [array addObject:[NSNumber numberWithFloat:obj1.rotate]];
            [array addObject:[NSNumber numberWithFloat:1.0]];
            
//            [VEHelp getMaskObjectArray:_mask atMaskName:nil atMaskThickColorIndex:0 atMaskType:0 atArray:array atIsKey:YES];
//            [VEHelp setKeyFrameRect_Rotate:_atArray:array atIndex:(i - 1)];
        }
    }
    
    if( _backgroundType !=  KCanvasType_None )
    {
        media.rectInVideo = _rectInScene;
        media.rotate = _rotate;
    }
    if (_pointsInVideoArray) {
        [media setPointsInVideoLeftTop:CGPointMake([_pointsInVideoArray[0][0] floatValue], [_pointsInVideoArray[0][1] floatValue])
                              rightTop:CGPointMake([_pointsInVideoArray[1][0] floatValue], [_pointsInVideoArray[1][1] floatValue])
                           rightBottom:CGPointMake([_pointsInVideoArray[2][0] floatValue], [_pointsInVideoArray[2][1] floatValue])
                            leftBottom:CGPointMake([_pointsInVideoArray[3][0] floatValue], [_pointsInVideoArray[3][1] floatValue])];
    }
    
    return media;
}

- (void)remove {
    NSError *err = nil;
    NSFileManager *fman = [NSFileManager defaultManager];
    //视频
    if (_contentURL
        && ![VEHelp isSystemPhotoUrl:_contentURL]
        && [fman fileExistsAtPath:[[VEHelp getFileURLFromAbsolutePath:_contentURL.absoluteString] path]]
        && ![_contentURL.path containsString:kAPITemplateFolder.lastPathComponent])
    {
        NSURL *url = [VEHelp getFileURLFromAbsolutePath:_contentURL.absoluteString];
        [fman removeItemAtPath:[url path] error:&err];
        if (err) {
            NSLog(@"删除videoURL出错： %@", err);
        }
        _contentURL = nil;
        err = nil;
        NSString *thumbnailPath = [VEHelp getMaterialThumbnail:url];
        [fman removeItemAtPath:thumbnailPath error:&err];
    }
    //倒序视频
    if (_reverseVideoURL && [fman fileExistsAtPath:[[VEHelp getFileURLFromAbsolutePath:_reverseVideoURL.absoluteString] path]]) {
        [fman removeItemAtPath:[[VEHelp getFileURLFromAbsolutePath:_reverseVideoURL.absoluteString] path] error:&err];
        if (err) {
            NSLog(@"删除倒序视频出错： %@", err);
        }
        _reverseVideoURL = nil;
        err = nil;
    }
    //文字板
    if (_customTextPhotoFile.filePath && [fman fileExistsAtPath:[[VEHelp getFileURLFromAbsolutePath:_customTextPhotoFile.filePath] path]]) {
        [fman removeItemAtPath:[[VEHelp getFileURLFromAbsolutePath:_customTextPhotoFile.filePath] path] error:&err];
        if (err) {
            NSLog(@"删除倒序视频出错： %@", err);
        }
        _customTextPhotoFile = nil;
        err = nil;
    }
}

@end
