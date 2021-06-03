//
//  MediaInfo.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/11/3.
//

#import "VEMediaInfo.h"
#import "VEHelp.h"
#import <LibVECore/VECoreYYModel.h>

@implementation VEMediaInfo

- (instancetype)init{
    self = [super init];
    if(self){
        _contrast = 1.0;
        _saturation = 1.0;
        _chromaColor = UIColorFromRGB(0x000000);
        _backgroundColor = UIColorFromRGB(0x000000);
        _rectInFile = CGRectZero;
        _rectInScale = 1.0;
        _filterIntensity = 1.0;
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
    }
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    VEMediaInfo *copy = [[[self class] allocWithZone:zone] init];
    copy.fxEffect = _fxEffect;
    copy.isIntelligentKey = _isIntelligentKey;
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
    copy.brightness              = _brightness;
    copy.contrast                = _contrast;
    copy.saturation              = _saturation;
    copy.vignette                = _vignette;
    copy.sharpness               = _sharpness;
    copy.whiteBalance            = _whiteBalance;
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
    copy.transitionNetworkCategoryId = _transitionNetworkCategoryId;
    copy.transitionNetworkResourceId = _transitionNetworkResourceId;
    copy.transitionDuration      = _transitionDuration;
    copy.transitionTypeName      = _transitionTypeName;
    copy.transitionName          = _transitionName;
    copy.transitionMask          = _transitionMask;
    copy.thumbImage              = _thumbImage;
    copy.cropRect                = _cropRect;
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
            }];
            [copy.keyFrameRectRotateArray addObject:objArray];
        }];
    }
    
    return copy;
}

- (id)copyWithZone:(NSZone *)zone{
    VEMediaInfo *copy = [[[self class] allocWithZone:zone] init];
    copy.fxEffect = _fxEffect;
    copy.isIntelligentKey = _isIntelligentKey;
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
    copy.brightness              = _brightness;
    copy.contrast                = _contrast;
    copy.saturation              = _saturation;
    copy.vignette                = _vignette;
    copy.sharpness               = _sharpness;
    copy.whiteBalance            = _whiteBalance;
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
            }];
            [copy.keyFrameRectRotateArray addObject:objArray];
        }];
    }
    
    return copy;
}


- (instancetype)initWithMediaAsset:(MediaAsset *)asset {
    NSDictionary *dic = [asset veCore_yy_modelToJSONObject];
    if (dic) {
        self = [VEMediaInfo veCore_yy_modelWithDictionary:dic];
        self.contentURL = asset.url;
        if (asset.type == MediaAssetTypeVideo) {
            self.videoTimeRange = asset.timeRange;
            _reverseVideoTimeRange = _videoTimeRange;
            
        }else {
            _imageDurationTime = asset.timeRange.duration;
            _imageTimeRange = asset.timeRange;
            NSData *data = [NSData dataWithContentsOfURL:asset.url];
            CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
            size_t count = CGImageSourceGetCount(source);
            if (count > 1) {
                _isGif = YES;
                _gifData = data;
                _imageDurationTime = CMTimeAdd(asset.timeRange.start, asset.timeRange.duration);
            }
            if (source) {
                CFRelease(source);
            }
        }
        if (asset.filterUrl) {
            _filterPath = asset.filterUrl.absoluteString;
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
        if (asset.mask) {
            _maskName = asset.mask.folderPath.lastPathComponent;
            MaskObject *mask = [VEHelp getMaskWithName:_maskName];
            _mask.frag = mask.frag;
            _mask.vert = mask.vert;
            _mask.maskImagePath = mask.maskImagePath;
            _maskThickColorIndex = [VEHelp getColorIndex:_mask.edgeColor];
            NSMutableArray *maskArray = [VEHelp getMaskArray];
            [maskArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([_maskName isEqualToString:obj[@"title"]]) {
                    _maskType = idx;
                    *stop = YES;
                }
            }];
        }
        if (asset.customAnimate) {
            CustomFilter *animate = [VEHelp getCustomFilterWithFolderPath:asset.customAnimate.folderPath currentFrameImagePath:nil];
            animate.timeRange = asset.customAnimate.timeRange;
            animate.cycleDuration = asset.customAnimate.cycleDuration;
            animate.networkCategoryId = asset.customAnimate.networkCategoryId;
            animate.networkResourceId = asset.customAnimate.networkResourceId;
            animate.animateType = asset.customAnimate.animateType;
            
            _animationType = asset.customAnimate.animateType;
            _animationTimeRange = asset.customAnimate.timeRange;
            _customAnimate = animate;
        }
        if (asset.customOutAnimate) {
            CustomFilter *animate = [VEHelp getCustomFilterWithFolderPath:asset.customOutAnimate.folderPath currentFrameImagePath:nil];
            animate.timeRange = asset.customOutAnimate.timeRange;
            animate.cycleDuration = asset.customOutAnimate.cycleDuration;
            animate.networkCategoryId = asset.customOutAnimate.networkCategoryId;
            animate.networkResourceId = asset.customOutAnimate.networkResourceId;
            animate.animateType = asset.customOutAnimate.animateType;
            
            _animationOutType = asset.customOutAnimate.animateType;
            _animationOutTimeRange = asset.customOutAnimate.timeRange;
            _customOutAnimate = animate;
        }
        [asset.customFilterArray enumerateObjectsUsingBlock:^(CustomFilter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CustomFilter *filter = [VEHelp getCustomFilterWithFolderPath:obj.folderPath currentFrameImagePath:asset.url.path];
            filter.timeRange = obj.timeRange;
//                filter.cycleDuration = obj.cycleDuration;
            filter.networkCategoryId = obj.networkCategoryId;
            filter.networkResourceId = obj.networkResourceId;
            _fxEffect = filter;
            _fxEffectTimeRange = filter.timeRange;
        }];
    }
    
    return self;
}

// 如果实现了该方法，则处理过程中会忽略该列表内的所有属性
+ (NSArray *)modelPropertyBlacklist {
    return @[@"contentURL"];
}

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"fileType" : @"type",
             @"videoVolume" : @"volume",
             @"backgroundAlpha" : @"alpha",
             @"backgroundBlurIntensity" : @"blurIntensity",
             @"rectInScene" : @"rectInVideo",
             @"isIntelligentKey" : @"autoSegment"
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"curvedSpeedPointArray" : [CurvedSpeedPoint class],
             @"animate" : [MediaAssetAnimatePosition class]};
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
    _contentURL = [VEHelp getFileURLFromAbsolutePath:_contentURL.absoluteString];
    _coverURL = [VEHelp getFileURLFromAbsolutePath:_coverURL.absoluteString];
    if(_filtImagePatch )
        _filtImagePatch = [VEHelp getFileURLFromAbsolutePath_str:_filtImagePatch];
    _reverseVideoURL = [VEHelp getFileURLFromAbsolutePath:_reverseVideoURL.path];
    
    NSArray *pointsArray = dic[@"keyFrameRectRotateArray"];
    if (pointsArray && [pointsArray isKindOfClass:[NSArray class]]) {
        _keyFrameRectRotateArray = [NSMutableArray array];
        for (NSArray *arr in pointsArray) {
            NSMutableArray *rotateArray = [NSMutableArray array];
            for (id value in arr) {
                if ([value isKindOfClass:[NSString class]]) {
                    [rotateArray addObject:[NSValue valueWithCGPoint:CGPointFromString((NSString *)value)]];
                }else {
                    [rotateArray addObject:value];
                }
            }
            [_keyFrameRectRotateArray addObject:rotateArray];
        }
    }
    if (_mask) {
        _mask.maskImagePath = [VEHelp getFileURLFromAbsolutePath_str:_mask.maskImagePath];
        if (_mask.edgeColor) {
            _maskThickColorIndex = [VEHelp getColorIndex:_mask.edgeColor];
        }
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

- (void)remove {
    NSError *err = nil;
    NSFileManager *fman = [NSFileManager defaultManager];
    //视频
    if (_contentURL && ![VEHelp isSystemPhotoUrl:_contentURL] && [fman fileExistsAtPath:[[VEHelp getFileURLFromAbsolutePath:_contentURL.absoluteString] path]]) {
        [fman removeItemAtPath:[[VEHelp getFileURLFromAbsolutePath:_contentURL.absoluteString] path] error:&err];
        if (err) {
            NSLog(@"删除videoURL出错： %@", err);
        }
        _contentURL = nil;
        err = nil;
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
