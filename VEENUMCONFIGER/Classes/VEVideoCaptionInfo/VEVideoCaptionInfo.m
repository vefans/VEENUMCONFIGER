//
//  VEVideoCaptionInfo.m
//  Pods
//
//  Created by iOS VESDK Team on 2021/6/28.
//

#import "VEVideoCaptionInfo.h"
#import "VEHelp.h"

@implementation VEVideoCaptionInfo
- (instancetype)init{
    self = [super init];
    if(self){
        _collageID = -1;
        _timeRange = kCMTimeRangeZero;
        _stickerAnimationTimeRange = kCMTimeRangeZero;
        _animationTimeRange = kCMTimeRangeZero;
        _animationOutTimeRange = kCMTimeRangeZero;
        _stickerAnimationOutTimeRange = kCMTimeRangeZero;
        _collageMaskColorIndex = 11;
        _scale = 1.0;
        _videoVolume = 1.0;
        _isFxFile = NO; //素材下标（特效作用的素材的下标）
        _fxCollageIndex = -1;
        _bgColor = [UIColor clearColor];
    }
    return  self;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    VEVideoCaptionInfo *copy = [[self class] allocWithZone:zone];
    copy.isAICaption = _isAICaption;
    copy.curveSpeedIndex = _curveSpeedIndex;
    copy.isIntelligentKey = _isIntelligentKey;
    copy.maskName = _maskName;
    copy.collageMaskType = _collageMaskType;
    copy.collageMaskColorIndex = _collageMaskColorIndex;
    copy.fxEffect = _fxEffect;
    copy.timeRange = _timeRange;
    copy.caption = [_caption mutableCopy];
    copy.mediaIdentifier = _mediaIdentifier;
    copy.blur = [_blur mutableCopy];
    copy.mosaic = [_mosaic mutableCopy];
    copy.dewatermark = [_dewatermark mutableCopy];
    copy.collage = [_collage mutableCopy];
    copy.doodle = [_doodle mutableCopy];
    copy.customFilter = [_customFilter mutableCopy];
    copy.fxId = _fxId;
    copy.collagethumbnailImagePath = _collagethumbnailImagePath;
    copy.filterIndex = _filterIndex;
    copy.currentFrameTexturePath = _currentFrameTexturePath;
    copy.isErase = _isErase;
    copy.music = [_music mutableCopy];
    copy.captiontypeIndex = _captiontypeIndex;
    copy.fancyWrodsIndex = _fancyWrodsIndex;
    copy.captionColorImagePath = _captionColorImagePath;
    copy.captionText = _captionText;
    copy.attributedString = _attributedString;
    copy.captionTransform = _captionTransform;
    copy.centerPoint = _centerPoint;
    copy.animationTimeRange = _animationTimeRange;
    copy.scale = _scale;
    copy.captionId = _captionId;
    copy.customFilterId = _customFilterId;
    copy.tColor = _tColor;
    copy.strokeColor = _strokeColor;
    copy.shadowColor = _shadowColor;
    copy.bgColor = _bgColor;
    copy.fontName = _fontName;
    copy.fontPath = _fontPath;
    copy.tFontSize = _tFontSize;
    copy.title = _title;
    copy.deleted = _deleted;
    copy.frameSize = _frameSize;
    copy.home = _home;
    copy.thumbnailImage = _thumbnailImage;
    copy.selectTypeId = _selectTypeId;
    copy.selectColorItemIndex = _selectColorItemIndex;
    copy.selectBorderColorItemIndex = _selectBorderColorItemIndex;
    copy.selectShadowColorIndex = _selectShadowColorIndex;
    copy.selectBgColorIndex = _selectBgColorIndex;
    copy.inAnimationIndex = _inAnimationIndex;
    copy.outAnimationIndex = _outAnimationIndex;
    copy.selectFontItemIndex = _selectFontItemIndex;
    copy.alignment  = _alignment;
    copy.pSize = _pSize;
    copy.cSize = _cSize;
    copy.netCover = _netCover;
    copy.rectW = _rectW;
    copy.tonName = _tonName;
    
    
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
    
    return copy;
}

- (id)copyWithZone:(NSZone *)zone{
    VEVideoCaptionInfo *copy = [[self class] allocWithZone:zone];
    copy.tonName = _tonName;
    copy.customFilterId = _customFilterId;
    copy.curveSpeedIndex = _curveSpeedIndex;
    copy.isIntelligentKey = _isIntelligentKey;
    copy.maskName = _maskName;
    copy.collageMaskType = _collageMaskType;
    copy.collageMaskColorIndex = _collageMaskColorIndex;
    copy.fxEffect = _fxEffect;
    copy.isAICaption = _isAICaption;
    copy.timeRange = _timeRange;
    copy.caption = [_caption mutableCopy];
    copy.mediaIdentifier = _mediaIdentifier;
    copy.blur = [_blur mutableCopy];
    copy.mosaic = [_mosaic mutableCopy];
    copy.dewatermark = [_dewatermark mutableCopy];
    copy.collage = [_collage mutableCopy];
    copy.doodle = [_doodle mutableCopy];
    copy.customFilter = [_customFilter mutableCopy];
    copy.fxId = _fxId;
    copy.animationTimeRange = _animationTimeRange;
    copy.collagethumbnailImagePath = _collagethumbnailImagePath;
    copy.filterIndex = _filterIndex;
    copy.currentFrameTexturePath = _currentFrameTexturePath;
    copy.isErase = _isErase;
    copy.music = [_music mutableCopy];
    copy.captiontypeIndex = _captiontypeIndex;
    copy.fancyWrodsIndex = _fancyWrodsIndex;
    copy.captionColorImagePath = _captionColorImagePath;
    copy.captionText = _captionText;
    copy.attributedString = _attributedString;
    copy.captionTransform = _captionTransform;
    copy.centerPoint = _centerPoint;
    copy.scale = _scale;
    copy.captionId = _captionId;
    copy.tColor = _tColor;
    copy.strokeColor = _strokeColor;
    copy.shadowColor = _shadowColor;
    copy.bgColor = _bgColor;
    copy.fontName = _fontName;
    copy.fontPath = _fontPath;
    copy.tFontSize = _tFontSize;
    copy.title = _title;
    copy.deleted = _deleted;
    copy.frameSize = _frameSize;
    copy.home = _home;
    copy.thumbnailImage = _thumbnailImage;
    copy.selectTypeId = _selectTypeId;
    copy.selectColorItemIndex = _selectColorItemIndex;
    copy.selectBorderColorItemIndex = _selectBorderColorItemIndex;
    copy.selectShadowColorIndex = _selectShadowColorIndex;
    copy.selectBgColorIndex = _selectBgColorIndex;
    copy.inAnimationIndex = _inAnimationIndex;
    copy.outAnimationIndex = _outAnimationIndex;
    copy.selectFontItemIndex = _selectFontItemIndex;
    copy.alignment  = _alignment;
    copy.pSize = _pSize;
    copy.cSize = _cSize;
    copy.netCover = _netCover;
    copy.rectW = _rectW;
    
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
    
    return copy;
}

// 当 Model 转为 JSON 完成后，该方法会被调用。
// 你可以在这里对数据进行校验，如果校验不通过，可以返回 NO，则该 Model 会被忽略。
// 你也可以在这里做一些自动转换不能完成的工作。
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (_collage && _keyFrameRectRotateArray.count > 0) {
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
    if (_caption) {
        _caption.imageFolderPath = [VEHelp getFileURLFromAbsolutePath_str:_caption.imageFolderPath];
        _caption.captionImagePath = [VEHelp getFileURLFromAbsolutePath_str:_caption.captionImagePath];
        _caption.tFontPath = [VEHelp getFileURLFromAbsolutePath_str:_caption.tFontPath];
        if (_captionColorImagePath) {
            _captionColorImagePath = [VEHelp getFileURLFromAbsolutePath:_captionColorImagePath].path;
            
            UIImage *image = nil;
            @autoreleasepool {
                image = [UIImage imageWithContentsOfFile:_captionColorImagePath];
            };
            if (_caption.attriStr) {
                NSRange range = NSMakeRange(0, _caption.attriStr.length);
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:_caption.attriStr];
                [attrStr removeAttribute:NSForegroundColorAttributeName range:range];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithPatternImage:image] range:range];
                _caption.attriStr = attrStr;
            }else {
                _caption.tColor = [UIColor colorWithPatternImage:image];
            }
        }
        _fontPath = _caption.tFontPath;
        _fontName = _caption.tFontName;
    }
    if (_collage) {
        _collage.media.url = [NSURL URLWithString:[VEHelp getFileURLFromAbsolutePath_str:_collage.media.url.absoluteString]];
        if (_collage.media.filterUrl) {
            _collage.media.filterUrl = [NSURL fileURLWithPath:[VEHelp getFileURLFromAbsolutePath_str:_collage.media.filterUrl.absoluteString]];
        }
        NSArray *pointsArray = dic[@"keyFrameRectRotateArray"];
        if (pointsArray && [pointsArray isKindOfClass:[NSArray class]]) {
            _keyFrameRectRotateArray = [NSMutableArray array];
            for (NSArray *arr in pointsArray) {
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
                [_keyFrameRectRotateArray addObject:rotateArray];
            }
        }
        if( _collage.media.rotate < 0 )
        {
            float rotate = _collage.media.rotate;
            rotate = 360 + rotate;
            _collage.media.rotate = rotate;
        }
        if (_collagethumbnailImagePath) {
            _collagethumbnailImagePath = [VEHelp getFileURLFromAbsolutePath_str:_collagethumbnailImagePath];
        }
        if (_collage.media.mask) {
            _collage.media.mask.maskImagePath = [VEHelp getFileURLFromAbsolutePath_str:_collage.media.mask.maskImagePath];
            _collage.media.mask.folderPath = [VEHelp getFileURLFromAbsolutePath_str:_collage.media.mask.folderPath];
            
            NSString * path = _collage.media.mask.maskImagePath;
            if( path == nil )
            {
                path = _collage.media.mask.folderPath;
            }
            
//            NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
#ifdef Enable_Config_VE
            NSString *configPath = [VEHelp getConfigPathWithFolderPath:path];
#else
            NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
#endif
            NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
            NSMutableDictionary *configDic = [VEHelp objectForData:jsonData];
            jsonData = nil;
            NSString *fragPath = [path stringByAppendingPathComponent:configDic[@"fragShader"]];
            NSString *vertPath = [path stringByAppendingPathComponent:configDic[@"vertShader"]];
            NSError * error = nil;
            
            _collage.media.mask.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
            _collage.media.mask.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
            _collage.media.mask.name = configDic[@"name"];
            
            if (_collage.media.mask.edgeColor) {
                _collageMaskColorIndex = [VEHelp getColorIndex:_collage.media.mask.edgeColor];
            }
        }
        if( _collage.media.customAnimate )
        {
            if( _collage.media.customAnimate.folderPath )
                _collage.media.customAnimate.folderPath = [VEHelp getFileURLFromAbsolutePath_str:_collage.media.customAnimate.folderPath];
            CustomFilter * filter = [VEHelp getAnimateCustomFilter: _collage.media.customAnimate.folderPath];
            filter.timeRange = _collage.media.customAnimate.timeRange;
            filter.animateType = _collage.media.customAnimate.animateType;
            if (filter.animateType == CustomAnimationTypeOut) {
                filter.cycleDuration = _collage.media.customAnimate.cycleDuration;
            }
            _animationTimeRange = filter.timeRange;
            _collage.media.customAnimate = filter;
        }
        
        if( _collage.media.customOutAnimate )
        {
            if( _collage.media.customOutAnimate.folderPath )
                _collage.media.customOutAnimate.folderPath = [VEHelp getFileURLFromAbsolutePath_str:_collage.media.customOutAnimate.folderPath];
            CustomFilter * filter = [VEHelp getAnimateCustomFilter:  _collage.media.customOutAnimate.folderPath];
            filter.timeRange =  _collage.media.customOutAnimate.timeRange;
            _animationTimeRange = filter.timeRange;
            filter.animateType =  _collage.media.customOutAnimate.animateType;
            _collage.media.customOutAnimate = filter;
        }
        if (_collage.media.curvedSpeedPointArray.count > 0) {
            _curveSpeedIndex = _collage.media.curveSpeedType + 1;
        }
    }
    if (_filters) {
        _filters.filterArray[0].path = [VEHelp getFileURLFromAbsolutePath_str:_filters.filterArray[0].path];
    }
    if (_customFilter) {
        _customFilter.ratingFrameTexturePath = [VEHelp getFileURLFromAbsolutePath_str:_customFilter.ratingFrameTexturePath];
        _customFilter.customFilter.folderPath = [VEHelp getFileURLFromAbsolutePath_str:_customFilter.customFilter.folderPath];
        
        CustomMultipleFilter *filter = [VEHelp getCustomMultipleFilerWithFolderPath:_customFilter.customFilter.folderPath currentFrameImagePath:nil];
//        CustomFilter *filter = [VEHelp getCustomFilterWithFolderPath:_customFilter.customFilter.folderPath currentFrameImagePath:nil ];
        filter.overlayType = _customFilter.customFilter.overlayType;
        filter.timeRange = _customFilter.customFilter.timeRange;
        filter.networkCategoryId = _customFilter.customFilter.networkCategoryId;
        filter.networkResourceId = _customFilter.customFilter.networkResourceId;
        _customFilter.customFilter = filter;
        _customFilter.filterTimeRange = filter.timeRange;
    }
    if (_fxEffect) {
        _fxEffect.path = [VEHelp getFileURLFromAbsolutePath_str:_fxEffect.path];
    }
    if (_music.curvedSpeedPointArray.count > 0) {
        _curveSpeedIndex = _music.curveSpeedType + 1;
    }

    return YES;
}

@end

