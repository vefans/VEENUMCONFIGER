//
//  VEHelp.m
//  VEENUMCONFIGER
//
//

#import <sys/utsname.h>
#import <sys/mount.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#include <CommonCrypto/CommonHMAC.h>
#import <VEENUMCONFIGER/VEHelp.h>
#import <VEENUMCONFIGER/UIImage+VEGIF.h>
#import <CoreText/CoreText.h>
#import <Reachability/Reachability.h>

@implementation VEHelp
+ (NSString *) system
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (BOOL)isLowDevice {
    NSString* machine = [VEHelp system];
    BOOL isLowDevice = NO;
    if ([machine hasPrefix:@"iPhone"]) {
        if ([machine hasPrefix:@"iPhone3"]
            || [machine hasPrefix:@"iPhone4"]
            || [machine hasPrefix:@"iPhone5"]
            || [machine hasPrefix:@"iPhone6"]
            || [machine hasPrefix:@"iPhone7"])
        {
            isLowDevice = YES;
        }
    }else {//iPad没有适配
        isLowDevice = YES;
    }
    
    return isLowDevice;
}
static CGFloat veVESDKedgeSizeFromCornerRadius(CGFloat cornerRadius) {
    return cornerRadius * 2 + 1;
}

/**进入系统设置
 */
+ (void)enterSystemSetting{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (NSString *) timeFormat: (float) seconds {
    if(seconds<=0){
        seconds = 0;
    }else if (seconds < 1) {//20200825 修复bug:seconds不到1少的情况会显示0
        seconds = 1;
    }
    int hours = seconds / 3600;
    int minutes = seconds / 60;
    int sec = fabs(round((int)seconds % 60));
    NSString *ch = hours <= 9 ? @"0": @"";
    NSString *cm = minutes <= 9 ? @"0": @"";
    NSString *cs = sec <= 9 ? @"0": @"";
    if (hours>=1) {
        return [NSString stringWithFormat:@"%@%i:%@%i:%@%i", ch, hours, cm, minutes, cs, sec];
    }else{
        return [NSString stringWithFormat:@"%@%i:%@%i",cm, minutes, cs, sec];
    }
}

+ (NSString *) timeFormatHours: (float) seconds {
    if(seconds<=0){
        seconds = 0;
    }else if (seconds < 1) {//20200825 修复bug:seconds不到1少的情况会显示0
        seconds = 1;
    }
    int hours = seconds / 3600;
    int minutes = seconds / 60;
    int sec = fabs(round((int)seconds % 60));
    NSString *ch = hours <= 9 ? @"0": @"";
    NSString *cm = minutes <= 9 ? @"0": @"";
    NSString *cs = sec <= 9 ? @"0": @"";
    return [NSString stringWithFormat:@"%@%i:%@%i:%@%i", ch, hours, cm, minutes, cs, sec];
}

+ (NSString *)timeToStringFormat:(float)time{
    @autoreleasepool {
    if(time<=0){
        time = 0;
    }
    int secondsInt  = floorf(time);
    float haomiao=time-secondsInt;
    int hour        = secondsInt/3600;
    secondsInt     -= hour*3600;
    int minutes     =(int)secondsInt/60;
    secondsInt     -= minutes * 60;
    NSString *strText;
    if(haomiao==1){
        secondsInt+=1;
        haomiao=0.f;
    }
    int diff = (int)floorf(haomiao*10);
    if (hour>0)
    {
        strText=[NSString stringWithFormat:@"%02i:%02i:%02i.%d",hour,minutes, secondsInt,diff];
    }else{
        
        strText=[NSString stringWithFormat:@"%02i:%02i.%d",minutes, secondsInt,diff];
    }
    return strText;
    }
}
+ (NSString *)timeToStringFormat_MinSecond:(float)time{
    @autoreleasepool {
    if(time<=0){
        time = 0;
    }
    int secondsInt  = floorf(time);
    float haomiao=time-secondsInt;
    int hour        = secondsInt/3600;
    secondsInt     -= hour*3600;
    int minutes     =(int)secondsInt/60;
    secondsInt     -= minutes * 60;
    NSString *strText;
    if(haomiao==1){
        secondsInt+=1;
        haomiao=0.f;
    }
    if (hour>0)
    {
        strText=[NSString stringWithFormat:@"%02i:%02i:%02i",hour,minutes, secondsInt];
    }else{
        
        strText=[NSString stringWithFormat:@"%02i:%02i",minutes, secondsInt];
    }
    return strText;
    }
}
/**判断URL是视频还是图片
 */
+ (BOOL)isImageUrl:(NSURL *)url{
    NSString *pathExtension = [url.pathExtension lowercaseString];
//    if([self isSystemPhotoUrl:url]){
//        pathExtension = [[[[NSString stringWithFormat:@"%@",url] componentsSeparatedByString:@"ext="] lastObject] lowercaseString];
//    }else{
//        pathExtension = [url.pathExtension lowercaseString];
//    }
    if([pathExtension isEqualToString:@"jpg"]
       || [pathExtension isEqualToString:@"jpeg"]
       || [pathExtension isEqualToString:@"png"]
       || [pathExtension isEqualToString:@"gif"]
       || [pathExtension isEqualToString:@"tiff"]
       || [pathExtension isEqualToString:@"heic"]
       ){
        return YES;
    }else{
        return NO;
    }
}


+(void)animateViewHidden:(UIView *) view atUP:(bool) isUp atBlock:(void(^)(void))completedBlock
{
    [UIView animateWithDuration:0.25 animations:^{
        if( isUp )
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - view.frame.size
                                    .height, view.frame.size.width, view.frame.size.height);
        else
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + view.frame.size
                                    .height, view.frame.size.width, view.frame.size.height);
    } completion:^(BOOL finished) {
        if( finished )
        {
            if( isUp )
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + view.frame.size
                .height, view.frame.size.width, view.frame.size.height);
            else
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - view.frame.size
            .height, view.frame.size.width, view.frame.size.height);
            if( completedBlock )
            {
                completedBlock();
            }
        }
    }];
}


#pragma mark- 计算文字的方法
//获取字符串的文字域的宽
+ (float)widthForString:(NSString *)value andHeight:(float)height fontSize:(float)fontSize
{
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                           options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                           context:nil].size;
    return sizeToFit.width;
}
+ (float)widthForString:(NSString *)value andHeight:(float)height font:(UIFont*)fontSize;
{
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                              options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                           attributes:@{NSFontAttributeName:fontSize}
                                              context:nil].size;
    return sizeToFit.width;
}

//获取字符串的文字域的高
+ (float)heightForString:(NSString *)value andWidth:(float)width fontSize:(float)fontSize
{
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width,CGFLOAT_MAX)
                                           options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                           context:nil].size;
    return sizeToFit.height;
}

//获取最长的一段
+ (NSMutableArray *)getMaxLengthStringArr:(NSString *)string fontSize:(float)fontSize{
    NSMutableArray *arr  = [[string componentsSeparatedByString:@"\n"] mutableCopy];
    
    [arr sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        
        CGFloat obj1X = [self widthForString:obj1 andHeight:30 fontSize:fontSize];
        CGFloat obj2X = [self widthForString:obj2 andHeight:30 fontSize:fontSize];
        
        if (obj1X > obj2X) { // obj1排后面
            return NSOrderedDescending;
        }
        else { // obj1排前面
            return NSOrderedAscending;
        }
    }];
    return arr;
}
+(void)animateView:(UIView *) view atUP:(bool) isUp
{
    CGRect rect = view.frame;
    if( isUp ){
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - view.frame.size
        .height, view.frame.size.width, view.frame.size.height);
    }
    else{
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + view.frame.size
                            .height, view.frame.size.width, view.frame.size.height);
    }
    //[UIView animateWithDuration:0.1 animations:^{
        view.frame = rect;
    //}];
}

+ (UIImage *) veImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = veVESDKedgeSizeFromCornerRadius(cornerRadius);
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (UIImage *) veImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (BOOL)isCameraRollAlbum:(PHAssetCollection *)data {
    PHAssetCollection *metadata = data;
    data = nil;
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1) {
        versionStr = [versionStr stringByAppendingString:@"00"];
    } else if (versionStr.length <= 2) {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    versionStr = nil;
    // 目前已知8.0.0 ~ 8.0.2系统，拍照后的图片会保存在最近添加中
    if (version >= 800 && version <= 802) {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumRecentlyAdded;
    } else {
        return ((PHAssetCollection *)metadata).assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    }
}

+ (NSString *)pathInCacheDirectory:(NSString *)fileName{
    //获取沙盒中缓存文件目录
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    //将传入的文件名加在目录路径后面并返回
    return [cacheDirectory stringByAppendingPathComponent:fileName];
}

+ (UIImage *)assetGetThumImage:(CGFloat)second url:(NSURL * _Nullable) url urlAsset:(AVURLAsset * _Nullable) urlAsset{
    if(!urlAsset){
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        // 初始化媒体文件
        urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    }
    // 根据asset构造一张图
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    // 设定缩略图的方向
    // 如果不设定，可能会在视频旋转90/180/270°时，获取到的缩略图是被旋转过的，而不是正向的（自己的理解）
    generator.appliesPreferredTrackTransform = YES;
    // 设置图片的最大size(分辨率)
    generator.maximumSize = CGSizeMake(100*[UIScreen mainScreen].scale, 80*[UIScreen mainScreen].scale);
    //如果需要精确时间
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    float frameRate = 0.0;
    if ([[urlAsset tracksWithMediaType:AVMediaTypeVideo] count] > 0) {
        AVAssetTrack* clipVideoTrack = [[urlAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        frameRate = clipVideoTrack.nominalFrameRate;
    }
    // 初始化error
    NSError *error = nil;
    // 根据时间，获得第N帧的图片
    // CMTimeMake(a, b)可以理解为获得第a/b秒的frame
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMakeWithSeconds(second, frameRate>0 ? frameRate : 30) actualTime:NULL error:&error];
    // 构造图片
    UIImage *image = [UIImage imageWithCGImage: img];
    CGImageRelease(img);
    
    if(error){
        error = nil;
    }
    urlAsset = nil;
    generator = nil;
    if(image){
        return image;
    }else{
        return nil;
    }
}

+ (float)isGifWithData:(NSData *)imageData {
    if (!imageData) {
        return 0;
    }
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    size_t count = CGImageSourceGetCount(source);
    if (count <= 1) {
        if (source) {
            CFRelease(source);
        }
        return 0;
    }
    else {
        float duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self frameDurationAtIndex:i source:source];
            CGImageRelease(imageRef);
        }
        if (source) {
            CFRelease(source);
        }
        return duration;
    }
}
+ (float)frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
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
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
}

//从URL获取缩率图照片
+ (UIImage *)getThumbImageWithUrl:(NSURL *)url{
    if([self isSystemPhotoUrl:url]){//[self isSystemPhotoUrl:url]
        __block UIImage *image;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;//解决草稿箱获取不到缩略图的问题
        PHFetchResult *phAsset = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
        PHAsset * asset = [phAsset firstObject];
        if(asset){
            [[PHImageManager defaultManager] requestImageForAsset:[phAsset firstObject] targetSize:CGSizeMake(100*[UIScreen mainScreen].scale, 100*[UIScreen mainScreen].scale) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                image = result;
                result  = nil;
                info = nil;
            }];
        }
        
        
        options = nil;
        phAsset = nil;
        return image;
    }else{
        if([self isImageUrl:url]){
           NSData *imagedata = [NSData dataWithContentsOfURL:url];
            return [UIImage imageWithData:imagedata];//[UIImage imageWithContentsOfFile:url.path];
        }else{
            return [self assetGetThumImage:0.5 url:url urlAsset:nil];
        }
    }
}

+ (BOOL)isSystemPhotoUrl:(NSURL *)url {
    BOOL isSystemUrl = YES;
    NSString *path = (NSString *)url;
    if ([url isKindOfClass:[NSURL class]]) {
        path = url.path;
    }
    NSRange range = [path rangeOfString:@"Bundle/Application/"];
    if (range.location != NSNotFound) {
        isSystemUrl = NO;
    }else {
        range = [path rangeOfString:@"Data/Application/"];
        if (range.location != NSNotFound) {
            isSystemUrl = NO;
        }
    }
    return isSystemUrl;
}


+(void)fileImage_Save:(NSMutableArray<VEMediaInfo *> *) fileArray atProgress:(void(^)(float progress))completedBlock atReturn:(void(^)(bool isSuccess))completedReturn
{
    NSMutableArray<VEMediaInfo *> * newFileArray = [fileArray mutableCopy];
    
    NSMutableArray<VEMediaInfo *> * array = [NSMutableArray new];
    
    for (VEMediaInfo *file in newFileArray) {
        if( (!file.isGif) && (file.fileType == kFILEIMAGE)  )
        {
            [array addObject:file];
        }
        else if(![[NSFileManager defaultManager] fileExistsAtPath:file.filtImagePatch]){
            [[NSFileManager defaultManager] createDirectoryAtPath:file.filtImagePatch withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else if ([[NSFileManager defaultManager] contentsOfDirectoryAtPath:file.filtImagePatch error:nil].count > 0)
        {
            [array addObject:file];
        }
    }
    
    for (int i = 0; i < array.count; i++) {
        [newFileArray removeObject:array[i]];
    }
    
    if( newFileArray.count == 0 )
    {
        if( completedBlock )
        {
            completedBlock( 1 );
        }
        if( completedReturn )
        {
            completedReturn(YES);
        }
        return;
    }
    
    int count = 0;
    int currentIndex = 0;
    
    for (int i = 0; i< newFileArray.count; i++) {
        VEMediaInfo *file = newFileArray[i];
        if( file.fileType ==  kFILEVIDEO )
        {
            CMTimeRange timeRange = file.videoActualTimeRange;
            if (CMTimeRangeEqual(timeRange, kCMTimeRangeZero) || CMTimeRangeEqual(timeRange, kCMTimeRangeInvalid)) {
                timeRange = [VECore getActualTimeRange:file.contentURL];
                file.videoActualTimeRange = timeRange;
            }
            int time = ceilf(CMTimeGetSeconds(timeRange.duration));
            count += time+1;
        }
        else if( file.isGif )
        {
            CMTimeRange timeRange = CMTimeRangeMake(kCMTimeZero, file.imageDurationTime);
            int time = ceilf(CMTimeGetSeconds(timeRange.duration));
            count += time+1;
        }
    }
    
    for (int i = 0; i< newFileArray.count; i++) {
        
        VEMediaInfo *file = newFileArray[i];
        if( (file.fileType == kFILEIMAGE) && ( !file.isGif ) )
            continue;
        
        NSString * filtImagePatch = file.filtImagePatch;
        CMTimeRange timeRange = file.videoActualTimeRange;
        
        if( file.isGif )
            timeRange = CMTimeRangeMake(kCMTimeZero, file.imageDurationTime);
        
        float time = ceilf(CMTimeGetSeconds(timeRange.duration)) + 1;
        
        float filCurrentIndex = 0;
        
        float fileImageCount = 50.0;
        int   iFileImageCOunt = ceilf(fileImageCount);
         
        int jCount = ceilf( time/fileImageCount );
        
        for (int j = 0; j < jCount; j++) {
            
            int tCount =  (j==( jCount- 1))?(((int)time)%iFileImageCOunt):iFileImageCOunt;
            
            if( (tCount == 0) && ( jCount == 1 ) )
            {
                tCount = time;
            }

            //获取时间
            NSMutableArray *times = [[NSMutableArray alloc] init];
            for (int t = 0; t < tCount ; t++) {
                
                float currentTime = ( (filCurrentIndex+t) >= time )?CMTimeGetSeconds(timeRange.duration) - 0.2:(filCurrentIndex+t) + CMTimeGetSeconds(timeRange.start);
                
                [times addObject:  [NSValue valueWithCMTime: CMTimeMakeWithSeconds(currentTime, TIMESCALE) ] ];
            }
            
            //获取图片
            if( file.fileType == kFILEVIDEO )
            {
                [VEHelp save_Image:filCurrentIndex atURL:file.contentURL atPatch:filtImagePatch atTimes:times atProgressCurrent:currentIndex atCount:count atProgress:^(float progress) {
                    if( completedBlock )
                    {
                        completedBlock( progress );
                    }
                }];
                filCurrentIndex += times.count;
                currentIndex += times.count;
            }
            else if( file.isGif )
            {
                for (int i = 0; i < times.count; i++) {
                    UIImage* videoScreen = [UIImage getGifThumbImageWithData:file.gifData time:CMTimeGetSeconds( [times[i]  CMTimeValue] )];
                    NSString *filePath = [filtImagePatch stringByAppendingPathComponent:
                    [NSString stringWithFormat:@"%d.png",i]];
                    [UIImagePNGRepresentation(videoScreen) writeToFile:filePath atomically:YES];
                    
                    filCurrentIndex++;
                    currentIndex++;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if( completedBlock )
                        {
                            completedBlock( ((float)currentIndex)/((float)count) );
                        }
                    });
                }
            }
//            filCurrentIndex += times.count;
//            currentIndex += times.count;
            [times removeAllObjects];
            times = nil;
            
            
        }
        
        if( i == (newFileArray.count-1) )
        {
            [newFileArray removeAllObjects];
            break;
        }
    }
    
    if( completedReturn )
    {
        completedReturn(YES);
    }
}

+(void)save_Image:(int) currentIndex atURL:(NSURL *) url atPatch:(NSString *) fileImagePatch atTimes:(NSMutableArray *) times atProgressCurrent:(int) progressIndex  atCount:(int) count atProgress:(void(^)(float progress))completedBlock
{
    CGFloat width = [UIScreen mainScreen].scale * 100;
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:[AVURLAsset assetWithURL:url]];
    imageGenerator.appliesPreferredTrackTransform = YES;
    imageGenerator.maximumSize = CGSizeMake(width, width);
    imageGenerator.requestedTimeToleranceBefore = CMTimeMakeWithSeconds(1.0, TIMESCALE);
    imageGenerator.requestedTimeToleranceAfter = CMTimeMakeWithSeconds(2.0, TIMESCALE);

    __block int currentFileIndex = progressIndex;
    __block int index = currentIndex;
    [imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        
        UIImage* videoScreen = [[UIImage alloc] initWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];        
        NSString *filePath = [fileImagePatch stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%d.png",index]];  // 保存文件的名称
        [UIImagePNGRepresentation(videoScreen) writeToFile:filePath atomically:YES];
        
        videoScreen = nil;
        
        index++;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if( completedBlock )
            {
                completedBlock( ((float)currentFileIndex)/((float)count) );
            }
            currentFileIndex++;
        });
    }];
    
    imageGenerator = nil;
    
    for (; index != ( currentIndex + times.count );) {
        sleep(0.1);
    }
}

+(NSString *)getMaterialThumbnail:(NSURL *) fileUrl
{
    NSString *fileName = @"";
    if ([self isSystemPhotoUrl:fileUrl])
    {
        NSRange range = [fileUrl.absoluteString rangeOfString:@"?id="];
        if (range.location != NSNotFound) {
            fileName = [fileUrl.absoluteString substringFromIndex:range.length + range.location];
            range = [fileName rangeOfString:@"&ext"];
            fileName = [fileName substringToIndex:range.location];
        }
    }else {
        fileName = [NSString stringWithFormat:@"%ld",[fileUrl.path hash]];
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:kThumbnailFolder]){
        [[NSFileManager defaultManager] createDirectoryAtPath:kThumbnailFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString * str = [kThumbnailFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", fileName]];
    
    return str;
}

+ (UIImage *)imageWithContentOfFile:(NSString *)path{
    @autoreleasepool {
        NSBundle *bundle = [self getEditBundle];
        NSString *imagePath = [bundle pathForResource:[NSString stringWithFormat:@"%@@3x",path]  ofType:@"png"];
        if([[path pathExtension] length] > 0){
            imagePath = [bundle pathForResource:[NSString stringWithFormat:@"%@",path]  ofType:@""];
        }
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        NSData *data = nil;
        //如果用以下的方式生成UIImage，图片不会识别@3x,@2x,所以界面图标不要用这个方式，界面图标最好使用ImageName的方式加载
        //[NSData dataWithContentsOfFile:imagePath];
        //UIImage *image = [UIImage imageWithData:data];
        if(image){
            path = nil;
            imagePath = nil;
            bundle = nil;
            data = nil;
            return image;
        }
        imagePath = [bundle pathForResource:[NSString stringWithFormat:@"%@@2x",path] ofType:@"png"];
        //data = [NSData dataWithContentsOfFile:imagePath];
        //image = [UIImage imageWithData:data];
        image = [UIImage imageWithContentsOfFile:imagePath];
        if(image){
            path = nil;
            imagePath = nil;
            bundle = nil;
            data = nil;
            return image;
        }
        imagePath = [bundle pathForResource:[NSString stringWithFormat:@"%@@1x",path] ofType:@"png"];
        //data = [NSData dataWithContentsOfFile:imagePath];
        //image = [UIImage imageWithData:data];
        image = [UIImage imageWithContentsOfFile:imagePath];
        if(image){
            path = nil;
            imagePath = nil;
            bundle = nil;
            data = nil;
            return image;
        }
        imagePath = [bundle pathForResource:[NSString stringWithFormat:@"%@",path] ofType:@"png"];
        //data = [NSData dataWithContentsOfFile:imagePath];
        //image = [UIImage imageWithData:data];
        image = [UIImage imageWithContentsOfFile:imagePath];
        if(image){
            path = nil;
            imagePath = nil;
            bundle = nil;
            data = nil;
            return image;
        }
        path = nil;
        imagePath = nil;
        bundle = nil;
        return nil;
    }
}

+ (UIImage *)composeimage:(UIImage *)image size:(CGSize)size {
    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    [image drawInRect:CGRectMake(5, (size.height - 2)/2.0, size.width - 10, 2)];//再把小图放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    return resultImg;
}

+(NSString*)getTransitionConfigPath:(NSDictionary *)obj
{
    NSString *pExtension = [[obj[@"file"] lastPathComponent] pathExtension];
    NSString *fileName = [[obj[@"file"] lastPathComponent] stringByDeletingPathExtension];
    
    NSString *name = fileName;
    
    if ( [pExtension rangeOfString:@"zip"].location != NSNotFound )
        name = nil;
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *folderName = [NSString stringWithFormat:@"/%@",[[obj[@"file"] stringByDeletingLastPathComponent] lastPathComponent]];
    NSString *path = [NSString stringWithFormat:@"%@%@/%@.%@",kTransitionFolder,folderName,fileName,pExtension];
    NSFileManager *manager = [[NSFileManager alloc] init];
    if(![manager fileExistsAtPath:[path stringByDeletingLastPathComponent]]){
        [manager createDirectoryAtPath:[path stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSArray *fileArray = [manager contentsOfDirectoryAtPath:[path stringByDeletingLastPathComponent] error:nil];
    
    if(fileArray.count > 0){
        for (NSString *fileName in fileArray) {
            if (![fileName isEqualToString:@"__MACOSX"]) {
                NSString *folderPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
                BOOL isDirectory = NO;
                BOOL isExists = [manager fileExistsAtPath:folderPath isDirectory:&isDirectory];
                if (isExists && isDirectory) {
                    name = fileName;
                    break;
                }
            }
        }
    }
    
    NSString *configPath = nil;
    
    if ( [pExtension rangeOfString:@"zip"].location != NSNotFound ) {
        configPath = [NSString stringWithFormat:@"%@/config.json",[[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:name]];
    }else if( ([pExtension rangeOfString:@"jpg"].location != NSNotFound)
             || ([pExtension rangeOfString:@"JPG"].location != NSNotFound)) {
        configPath = [NSString stringWithFormat:@"%@/%@.JPG",[path stringByDeletingLastPathComponent],name];
    }
    else if( ([pExtension rangeOfString:@"glsl"].location != NSNotFound)) {
        configPath = [NSString stringWithFormat:@"%@/%@.glsl",[path stringByDeletingLastPathComponent],name];
    }
    
    return configPath;
}

+ (UIImage *)imageNamed:(NSString *)name{
    return [self imageWithContentOfFile:name];
}

+ (NSString *) getEditResource:(NSString *)name type : (NSString *) type
{
    NSBundle *bdl = [NSBundle bundleForClass:self.class];
    NSString* bundlePath = [bdl.resourcePath stringByAppendingPathComponent:@"VEEditSDK.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [bundle pathForResource:name ofType:type];
}

+ (NSString *) getRecordResource: (NSString *) name type : (NSString *) type
{

    NSBundle *bdl = [NSBundle bundleForClass:self.class];
    NSString* bundlePath = [bdl.resourcePath stringByAppendingPathComponent:@"VideoRecord.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    return [bundle pathForResource:name ofType:type];
}

+ (NSString *)getDemoUseResource:(NSString *)name type:(NSString *)type {
    NSBundle *bundle = [self getDemoUseBundle];
    return [bundle pathForResource:name ofType:type];
}

+ (UIImage *) getBundleImage : (NSString *) name
{
    return [UIImage imageWithContentsOfFile:[self getRecordResource:[NSString stringWithFormat:@"%@",name] type:@"tiff"]];
}

+ (UIImage *) getBundleImagePNG : (NSString *) name
{
    return [UIImage imageWithContentsOfFile:[self getRecordResource:[NSString stringWithFormat:@"%@",name] type:@"png"]];
}

+ (NSBundle *)getEditBundle{
    NSString * bundlePath = [[NSBundle bundleForClass:self.class] pathForResource: @"VEEditSDK" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    return  resourceBundle;
}

+ (NSBundle *)getRecordBundle{
    NSString * bundlePath = [[NSBundle bundleForClass:self.class] pathForResource: @"VideoRecord" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    return  resourceBundle;
}

+ (NSBundle *)getDemoUseBundle {
    NSString * bundlePath = [[NSBundle bundleForClass:self.class] pathForResource: @"VEDemoUse" ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    return  resourceBundle;
}

//+ (NSString *)getLocalizedString:(NSString *)key {
//    NSString *str = [LanguageBundle localizedStringForKey:key value:nil table:@"VEEditSDK_Localizable"];
//    return str;
//}

//--------------------国际化语言简写--------------------------
#define SimplifiedChineseShorthand @"zh-Hans"  //简体中文简写
#define EnglishShorthand @"en"  //英文简写
#define SpanishShorthand @"es"  //西语简写
#define PortugueseShorthand @"pt-PT"  //葡语简写
#define RussianShorthand @"ru"  //俄语简写
#define JapaneseShorthand @"ja"  //日语简写
#define FrenchShorthand @"fr"  //法语简写
#define KoreanShorthand @"ko"  //韩语简写
#define ChineseTraditionalShorthand @"zh-Hant"  //繁体中文简写

/// 获取项目语言简写字符串
+ (NSString *)getProjectLanguageShorthand {
    NSString *rts = @"";
    NSString *appLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppLanguage"];
    NSString *appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
    
    if (appLanguage.length) {
        rts = appLanguage;
    } else {
        if ([appleLanguages hasPrefix:SimplifiedChineseShorthand]) {
            rts = SimplifiedChineseShorthand;
        }
        else if ([appleLanguages hasPrefix:EnglishShorthand]) {
            rts = EnglishShorthand;
        }
        else if ([appleLanguages hasPrefix:SpanishShorthand]) {
            rts = SpanishShorthand;
        }
        else if ([appleLanguages hasPrefix:PortugueseShorthand]) {
            rts = PortugueseShorthand;
        }
        else if ([appleLanguages hasPrefix:RussianShorthand]) {
            rts = RussianShorthand;
        }
        else if ([appleLanguages hasPrefix:JapaneseShorthand]) {
            rts = JapaneseShorthand;
        }
        else if ([appleLanguages hasPrefix:FrenchShorthand]) {
            rts = FrenchShorthand;
        }
        else if ([appleLanguages hasPrefix:KoreanShorthand]) {
            rts = KoreanShorthand;
        }
        else if ([appleLanguages hasPrefix:ChineseTraditionalShorthand]) {
            rts = ChineseTraditionalShorthand;
        }
    }
    return rts;
}

+ (NSString *)getLocalizedString:(NSString *)key {
    NSString *str = [[NSBundle bundleWithPath:[ClassBundle pathForResource:[NSString stringWithFormat:@"VEEditSDK.bundle/%@", [VEHelp getProjectLanguageShorthand].length?[VEHelp getProjectLanguageShorthand]:EnglishShorthand] ofType:@"lproj"]] localizedStringForKey:key value:nil table:@"VEEditSDK_Localizable"];
    return str;
}


/**
 *  获取设备可用容量(G)
 */
+(float)getFreeDiskSize
{
    //    但是在iOS11以上使用这个方法获取剩余空间不准确了，或者跟系统不一样
    //    iOS11上可以使用
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:NSTemporaryDirectory()];
    NSDictionary *results = [fileURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:nil];
    // 这里拿到的值的单位是bytes，iOS11是这样算的1000MB = 1，1000进制算的
    // bytes->KB->MB->G
    
    CGFloat freeSize = [results[NSURLVolumeAvailableCapacityForImportantUsageKey] floatValue]/1000.0f/1000.0f/1000.0f;
    
    return freeSize;
}

+(float)fileSizeWithvideoBitRate:(float) videoBitRate audioBitRate:(float)audioBitRate duration:(float)duration
{
    float fileSize = (videoBitRate + audioBitRate )*duration/8;
    return fileSize;
}
/**
 *  获取设备总容量(G)
 */
+(float)getTotalDiskSize
{
    float totalSize;
    NSError * error;
    NSDictionary * infoDic = [[NSFileManager defaultManager] attributesOfFileSystemForPath: NSHomeDirectory() error: &error];
    if (infoDic) {
        NSNumber * fileSystemSizeInBytes = [infoDic objectForKey: NSFileSystemSize];
        totalSize = [fileSystemSizeInBytes floatValue]/1000.0f/1000.0f/1000.0f;
        return totalSize;
    } else {
        return 0;
    }
}


+ (NSString *)getDivceSize{
    float freeDiskSize = [self getFreeDiskSize];
    float totalFreeSpace = [self getTotalDiskSize];
    NSString * sizeStr = [NSString stringWithFormat:@"内部可用%0.2fGB / 共%0.2fGB",freeDiskSize,totalFreeSpace];
    return sizeStr;
}

//自动换行，计算并添加“\n”进行换行
+(NSString *)setPastTextWith:(float) witdh atText:(NSString *) text atFont:(UIFont *) font
{
    //获取手动换行的次数 及 在text中的位置
    __block NSMutableArray * array = [NSMutableArray new];
    __block NSMutableArray * strArray = [NSMutableArray new];
    __block NSString * str = @"";
    
    [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        if( [substring isEqualToString:@"\n"] )
        {
            [array addObject:[NSNumber numberWithInteger:substringRange.location]];
        }
    }];
    
    [array addObject:[NSNumber numberWithInteger:text.length]];
    
    __block NSInteger startInteger = 0;
    __block NSInteger endInteger = 0;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        endInteger = [obj integerValue];
        NSString * objStr = [text substringWithRange:NSMakeRange(startInteger, endInteger - startInteger)];
        
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:objStr
                                                                             attributes:@{NSFontAttributeName:font}];
        CGSize rectSize = [attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                       context:nil].size;
        
        float fontWith = (float)rectSize.width/(float)objStr.length;
        int lineNumber =  (int)(witdh/fontWith);
        int count = (int)(objStr.length/lineNumber + ((objStr.length%lineNumber)?1:0));
        NSInteger startNumber = 0;
        NSInteger endNumber = 0;
        for (int i = 1; i < count; i++) {
            endNumber = i*lineNumber;
            if( endNumber > objStr.length )
            {
                endNumber = objStr.length;
            }
            NSString * numberStr = [objStr substringWithRange:NSMakeRange(startNumber, endNumber - startNumber)];
            str = [NSString stringWithFormat:@"%@%@\n",str,numberStr];
            startNumber = endNumber;
        }
        
        if( count == 1 )
        {
            if( idx == (array.count-1) )
                str = [NSString stringWithFormat:@"%@%@",str,objStr];
            else
                str = [NSString stringWithFormat:@"%@%@\n",str,objStr];
        }
        
        startInteger = [obj integerValue];
    }];
    
    return str;
    //    }
    //    else{
//        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
//                                                                                 attributes:@{NSFontAttributeName:font}];
//        CGSize rectSize = [attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
//                                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                       context:nil].size;
//        float fontWith = (float)rectSize.width/(float)text.length;
//        int lineNumber =  (int)(witdh/fontWith);
//        int count = (int)(text.length/lineNumber + ((text.length%lineNumber)?1:0));
//        NSInteger startNumber = 0;
//        NSInteger endNumber = 0;
//        for (int i = 1; i < count; i++) {
//            endNumber = i*lineNumber;
//            if( endNumber > text.length )
//            {
//                endNumber = text.length;
//            }
//            NSString * numberStr = [text substringWithRange:NSMakeRange(startNumber, endNumber - startNumber)];
//            str = [NSString stringWithFormat:@"%@%@\n",str,numberStr];
//            startNumber = endNumber;
//        }
//
//        if( count == 1 )
//        {
//            str = text;
//        }
//
//        return str;
//    }
}

+ (NSMutableArray *)getInternetTransitionArray {
    NSMutableArray *transitionList = [NSMutableArray arrayWithContentsOfFile:kTransitionPlistPath];
    return transitionList;
}

+(id)objectForData:(NSData *)data{
    
    if(data){
        NSError *error;
        id objc = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (!objc) {
            //20190821 有的json文件中含有乱码，需要处理一下才能解析
            error = nil;
            NSString *dataString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSData *utf8Data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
            
            objc = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableContainers error:&error];
            utf8Data = nil;
        }
        data = nil;
        if(error){
            return nil;
        }else{
            return objc;
        }
    }else{
        return nil;
    }
}
/**通过字体文件路径加载字体 适用于 ttf ，otf
 */
+(NSString*)customFontWithPath:(NSString*)path fontName:(NSString *)fontName
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    
    if(fontName){
        CFErrorRef error;
        BOOL registrationResult = NO;
        
        
        NSArray* familys = [UIFont familyNames];
        
        NSLog(@"%lu",(unsigned long)familys.count);
        for (int i = 0; i<[familys count]; i++) {
            
            NSString* family = [familys objectAtIndex:i];
            
            NSArray* fonts = [UIFont fontNamesForFamilyName:family];
            
            for (int j = 0; j<[fonts count]; j++) {
                
                //                NSLog(@"FontName:%@",[fonts objectAtIndex:j]);
                if([fontName isEqualToString:[fonts objectAtIndex:j]]){
                    registrationResult = YES;
                    break;
                }
            }
            if(registrationResult){
                break;
            }
        }
        
        familys = nil;
        if(!registrationResult){
            registrationResult = CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontUrl, kCTFontManagerScopeProcess, &error);
            
            if (!registrationResult) {
                NSLog(@"Error with font registration: %@", error);
                CFRelease(error);
            }
            
        }
        return fontName;
    }else{
        
        CFURLRef urlRef = (__bridge CFURLRef)fontUrl;
        
        CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL(urlRef);
        CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
        CGDataProviderRelease(fontDataProvider);
        //CTFontManagerUnregisterGraphicsFont(fontRef, NULL);//每次反注册会增加更多内存
        CTFontManagerRegisterGraphicsFont(fontRef, NULL);
        
        fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
        //    UIFont *font = [UIFont fontWithName:fontName size:size];
        CGFontRelease(fontRef);
        return fontName;//SimHei,SimSun,YouYuan,FZJZJW--GB1-0,FZJLJW--GB1-0,FZSEJW--GB1-0,FZNSTK--GBK1-0,HYy1gj,HYg3gj,HYk1gj,JLinBo,JLuobo,Jpangtouyu,SentyTEA-Platinum
    }    
}

/**通过字体文件路径加载字体, 适用于 ttf ，otf,ttc
 */
+ (NSMutableArray*)customFontArrayWithPath:(NSString*)path
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }
    @autoreleasepool {
        CFStringRef fontPath = CFStringCreateWithCString(NULL, [path UTF8String], kCFStringEncodingUTF8);
        CFURLRef fontUrl = CFURLCreateWithFileSystemPath(NULL, fontPath, kCFURLPOSIXPathStyle, 0);
        if(!fontPath){
            CFRelease(fontUrl);
            return nil;
        }
        CFRelease(fontPath);
        NSMutableArray *customFontArray = [NSMutableArray array];
        CFArrayRef fontArray = CTFontManagerCreateFontDescriptorsFromURL(fontUrl);
        //注册
        CTFontManagerRegisterFontsForURL(fontUrl, kCTFontManagerScopeNone, NULL);
        if(fontUrl)
            CFRelease(fontUrl);
        for (CFIndex i = 0 ; i < CFArrayGetCount(fontArray); i++){
            
            CTFontDescriptorRef  descriptor = CFArrayGetValueAtIndex(fontArray, i);
            CTFontRef fontRef = CTFontCreateWithFontDescriptor(descriptor, 10, NULL);
            NSString *fontName = CFBridgingRelease(CTFontCopyName(fontRef, kCTFontPostScriptNameKey));
            if(fontName)
                [customFontArray addObject:fontName];
            if(fontRef)
                CFRelease(fontRef);
            // if(descriptor)
            //    CFRelease(descriptor);
        }
        CFRelease(fontArray);
        return customFontArray;
        
    }
}

+ (NSURL *)getFileURLFromAbsolutePath:(NSString *)absolutePath {
    if(absolutePath.length==0){
        return nil;
    }
    NSURL *fileURL = [NSURL URLWithString:absolutePath];
    if ([self isSystemPhotoUrl:fileURL])
    {
        return fileURL;
    }else {
        fileURL = nil;
        NSString *filePah;
        NSRange range = [absolutePath rangeOfString:@"Bundle/Application/"];
        if (range.location != NSNotFound) {
            filePah = [absolutePath substringFromIndex:range.length + range.location];
            range = [filePah rangeOfString:@".app/"];
            filePah = [filePah substringFromIndex:range.length + range.location - 1];
            filePah = [[NSBundle mainBundle].bundlePath stringByAppendingString:filePah];
            fileURL = [NSURL fileURLWithPath:filePah];
        }else{
            range = [absolutePath rangeOfString:@"Data/Application/"];
            if (range.location != NSNotFound) {
                filePah = [absolutePath substringFromIndex:range.length + range.location];
                range = [filePah rangeOfString:@"/"];
                filePah = [filePah substringFromIndex:range.length + range.location - 1];
                filePah = [NSHomeDirectory() stringByAppendingString:filePah];
                fileURL = [NSURL fileURLWithPath:filePah];
            }else {
                fileURL = [NSURL URLWithString:absolutePath];
            }
        }
    }
    
    return fileURL;
}

+ (NSString *)getFileURLFromAbsolutePath_str:(NSString *)absolutePath {

    if(absolutePath.length==0){
        return nil;
    }
    NSString *fileURL = absolutePath;
    if ([self isSystemPhotoUrl:fileURL])
    {
        return fileURL;
    }else {
        fileURL = nil;
        NSString *filePah;
        NSRange range = [absolutePath rangeOfString:@"Bundle/Application/"];
        if (range.location != NSNotFound) {
            filePah = [absolutePath substringFromIndex:range.length + range.location];
            range = [filePah rangeOfString:@".app/"];
            filePah = [filePah substringFromIndex:range.length + range.location - 1];
            filePah = [[NSBundle mainBundle].bundlePath stringByAppendingString:filePah];
            fileURL = filePah;
        }else{
            range = [absolutePath rangeOfString:@"Data/Application/"];
            if (range.location != NSNotFound) {
                filePah = [absolutePath substringFromIndex:range.length + range.location];
                range = [filePah rangeOfString:@"/"];
                filePah = [filePah substringFromIndex:range.length + range.location - 1];
                filePah = [NSHomeDirectory() stringByAppendingString:filePah];
                fileURL = filePah;
            }else {
                fileURL = absolutePath;
            }
        }
    }
    
    return fileURL;
}

+(NSMutableArray *)getColorArray
{
    NSMutableArray * colorArray = [NSMutableArray array];
    
    [colorArray addObject:UIColorFromRGB(0xffffff)];
    [colorArray addObject:UIColorFromRGB(0xf9edb1)];
    [colorArray addObject:UIColorFromRGB(0xffa078)];
    [colorArray addObject:UIColorFromRGB(0xfe6c6c)];
    [colorArray addObject:UIColorFromRGB(0xfe4241)];
    [colorArray addObject:UIColorFromRGB(0x7cddfe)];
    [colorArray addObject:UIColorFromRGB(0x41c5dc)];
    
    [colorArray addObject:UIColorFromRGB(0x0695b5)];
    [colorArray addObject:UIColorFromRGB(0x2791db)];
    [colorArray addObject:UIColorFromRGB(0x0271fe)];
    [colorArray addObject:UIColorFromRGB(0xdcffa3)];
    [colorArray addObject:UIColorFromRGB(0x000000)];
    [colorArray addObject:UIColorFromRGB(0xc7fe64)];
    [colorArray addObject:UIColorFromRGB(0x82e23a)];
    [colorArray addObject:UIColorFromRGB(0x25ba66)];
    [colorArray addObject:UIColorFromRGB(0x017e54)];
    
    [colorArray addObject:UIColorFromRGB(0xfdbacc)];
    [colorArray addObject:UIColorFromRGB(0xff5a85)];
    [colorArray addObject:UIColorFromRGB(0xff5ab0)];
    [colorArray addObject:UIColorFromRGB(0xb92cec)];
    [colorArray addObject:UIColorFromRGB(0x7e01ff)];
    [colorArray addObject:UIColorFromRGB(0x848484)];
    [colorArray addObject:UIColorFromRGB(0x88754d)];
    [colorArray addObject:UIColorFromRGB(0x164c6e)];
    
    return colorArray;
}

+ (NSInteger)getColorIndex:(UIColor *)color {
    if (!color) {
        return 0;
    }
    NSMutableArray *colors = [self getColorArray];
    
    float r=0,g=0,b=0;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    r = components[0];
    g = components[1];
    b = components[2];
    
    __block NSInteger colorIndex = 0;
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
#if 0
        if (CGColorEqualToColor(color.CGColor, obj.CGColor)) {//无效
            colorIndex = idx;
            *stop = YES;
        }
#else
        float r1=0,g1=0,b1=0;
        const CGFloat *components = CGColorGetComponents(obj.CGColor);
        r1 = components[0];
        g1 = components[1];
        b1 = components[2];
        if (r == r1 && g == g1 && b == b1) {
            colorIndex = idx;
            *stop = YES;
        }
#endif
    }];
    
    return colorIndex;
}

+ (CGSize )getVideoSizeForTrack:(AVURLAsset *)asset{
    CGSize size = CGSizeZero;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks    count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        size = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
        
        if (CGSizeEqualToSize(size, CGSizeZero) || size.width == 0.0 || size.height == 0.0) {
            NSArray * formatDescriptions = [videoTrack formatDescriptions];
            CMFormatDescriptionRef formatDescription = NULL;
            if ([formatDescriptions count] > 0) {
                formatDescription = (__bridge CMFormatDescriptionRef)[formatDescriptions objectAtIndex:0];
                if (formatDescription) {
                    size = CMVideoFormatDescriptionGetPresentationDimensions(formatDescription, false, false);
                }
            }
        }
    }
    size = CGSizeMake(fabs(size.width), fabs(size.height));
    return size;
}

+ (CGSize)getFileActualSize:(VEMediaInfo *)file {
    CGSize size = CGSizeZero;
    if (file.fileType == kFILEVIDEO) {
        size = [self getVideoSizeForTrack:[AVURLAsset assetWithURL:file.contentURL]];
    }else if ([self isSystemPhotoUrl:file.contentURL]){
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;//解决草稿箱获取不到缩略图的问题
        PHFetchResult *phAsset = [PHAsset fetchAssetsWithALAssetURLs:@[file.contentURL] options:nil];
        if (phAsset.count > 0) {
            PHAsset *asset = [phAsset firstObject];
            size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
        }
    }else {
        UIImage *image = [UIImage imageWithContentsOfFile:file.contentURL.path];
        image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUp];
        size = image.size;
    }
    
    return size;
}

+(VEMediaInfo *)vassetToFile:(MediaAsset *) vvasset
{
    VEMediaInfo * file = [VEMediaInfo new];
    
    file.contentURL = vvasset.url;
    file.speed = vvasset.speed;
    file.crop = vvasset.crop;
    file.rotate = vvasset.rotate;
    file.isHorizontalMirror = vvasset.isHorizontalMirror;
    file.isVerticalMirror = vvasset.isVerticalMirror;
    
    if( vvasset.type == MediaAssetTypeVideo )
    {
        file.videoTimeRange = [VECore getActualTimeRange:file.contentURL];
        file.fileType = kFILEVIDEO;
        file.videoTrimTimeRange  = [VECore getActualTimeRange:file.contentURL];
        file.videoTrimTimeRange = vvasset.timeRange;
    }
    else{
        file.imageTimeRange = vvasset.timeRange;
        file.fileType = kFILEIMAGE;
        if ([self isSystemPhotoUrl:file.contentURL]) {
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
            option.synchronous = YES;
            option.resizeMode = PHImageRequestOptionsResizeModeExact;
            PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithALAssetURLs:@[file.contentURL] options:nil];
            if (result.count > 0) {
                PHAsset* asset = [result objectAtIndex:0];
                if ([[asset valueForKey:@"uniformTypeIdentifier"] isEqualToString:@"com.compuserve.gif"]) {
                    file.isGif = YES;
                    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                                      options:option
                                                                resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                        file.gifData = imageData;
                                                                }];
                }
            }
        }else {
            NSData *data = [NSData dataWithContentsOfURL:file.contentURL];
            if (data) {
                CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
                size_t count = CGImageSourceGetCount(source);
                if (count > 1) {
                    file.isGif = YES;
                }
                if (source) {
                    CFRelease(source);
                }
            }
        }
    }
    
    return file;
}

+(NSString *)createPostURL:(NSMutableDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}

+ (void)getNetworkResourcesWithParams:(NSMutableDictionary *)params
                              urlPath:(NSString *)urlPath
                    completionHandler:(void (^)(NSArray *listArray))completionHandler
                        failedHandler:(void (^)(NSError *error))failedHandler {
    if(!params){
        params = [NSMutableDictionary dictionary];
        [params setObject:@"1" forKey:@"os"];
    }
    if(![[params allKeys] containsObject:@"os"]){
        [params setObject:@"ios" forKey:@"os"];
    }
    
    urlPath = [NSString stringWithString:[urlPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSString *postURL = [self createPostURL:params];
    //=====
    NSData *postData = [postURL dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    request.timeoutInterval = 3;
    //
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    if(error){
        if (failedHandler) {
            failedHandler(error);
        }
        return;
    }
    if(!responseData){
        if (failedHandler) {
            failedHandler(nil);
        }
        return;
    }
    id obj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    responseData = nil;
    urlResponse = nil;
    if(error || !obj){
        if (failedHandler) {
            failedHandler(error);
        }
        return ;
    }else{
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"code"] integerValue] != 0) {
            if (failedHandler) {
                NSString *message = dic[@"msg"];
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:VECustomErrorDomain code:VESDKErrorCode_DownloadMaterial userInfo:userInfo];
                failedHandler(error);
            }
            return;
        }else if (completionHandler){
            completionHandler(dic[@"data"]);
        }
    }
}

+ (void)getCategoryMaterialWithType:(VENetworkMaterialType)materialType
                             appkey:(NSString *)appkey
                        typeUrlPath:(NSString *)typeUrlPath
                    materialUrlPath:(NSString *)materialUrlPath
                  completionHandler:(void (^)(NSArray *, NSMutableArray *))completionHandler
                      failedHandler:(void (^)(NSError *))failedHandler
{
    if (appkey.length == 0 || typeUrlPath.length == 0 || materialUrlPath.length == 0) {
        if (failedHandler) {
            NSString *message;
            if (appkey.length == 0) {
                message = @"appkey为空";
            }else {
                message = @"网络路径为空";
            }
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:VECustomErrorDomain code:VESDKErrorCode_DownloadMaterial userInfo:userInfo];
            failedHandler(error);
        }
        return;
    }
    Reachability *lexiu = [Reachability reachabilityForInternetConnection];
    NSString *type;
    NSString *folderPath;
    NSString *plistPath;
    
    switch (materialType) {
        case VENetworkMaterialType_Subtitle:
            plistPath = kSubtitlePlistPath;
            folderPath = kSubtitleFolder;
            type = @"sub_title";
            break;
        
        case VENetworkMaterialType_Effect:
            plistPath = kNewSpecialEffectPlistPath;
            folderPath = kSpecialEffectFolder;
            type = @"specialeffects";
            break;
            
        case VENetworkMaterialType_Transition:
            plistPath = kTransitionPlistPath;
            folderPath = kTransitionFolder;
            type = @"transition";
            break;
            
        case VENetworkMaterialType_AETemplate:
            plistPath = kMusicAnimatePlistPath;
            folderPath = kMVAnimateFolder;
            type = @"mvae2";
            break;
            
        case VENetworkMaterialType_CameraTemplate:
            plistPath = kTemplateRecordPlist;
            folderPath = kTemplateRecordFolder;
            type = @"recorderae";
            break;
            
        case VENetworkMaterialType_Filter:
            folderPath = kFilterFolder;
            type = @"filter2";
            break;
            
        default:
            break;
    }
    if([lexiu currentReachabilityStatus] != NotReachable) {
        if (failedHandler) {
            NSString *message = @"下载失败，请检查网络!";
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
            NSError *error = [NSError errorWithDomain:VECustomErrorDomain code:VESDKErrorCode_DownloadMaterial userInfo:userInfo];
            failedHandler(error);
        }
        return;
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:appkey forKey:@"appkey"];
    [params setObject:type forKey:@"type"];
    
    WeakSelf(self);
    [self getNetworkResourcesWithParams:params
                                urlPath:typeUrlPath
                      completionHandler:^(NSArray *listArray) {
        if (listArray.count > 0) {
            NSArray *categoryArray = listArray;
            NSMutableArray *array = [NSMutableArray array];
            [categoryArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:type forKey:@"type"];
                [params setObject:obj[@"id"] forKey:@"category"];
                [params setObject:@"0" forKey: @"page_num"];
                
                [weakSelf getNetworkResourcesWithParams:params
                                            urlPath:materialUrlPath
                                  completionHandler:^(NSArray *listArray) {
                    [array addObjectsFromArray:listArray];
                } failedHandler:^(NSError *error) {
                    NSLog(@"%@", error.localizedDescription);
                }];
            }];
            if (completionHandler) {
                completionHandler(categoryArray, array);
            }
        }
    } failedHandler:failedHandler];
}

+ (NSMutableArray *)getFilterArrayWithListArray:(NSMutableArray *)listArray {
    NSString *filterPath = kFilterFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:filterPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:filterPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSMutableArray *filterArray = [NSMutableArray array];
    [listArray enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            [obj enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                Filter * filter = [Filter new];
                if([obj1[@"name"] isEqualToString:VELocalizedString(@"原始", nil)] || [obj1[@"name"] isEqualToString:@"原始"]){
                    filter.type = kFilterTypeNone;
                }else{
                    NSString *itemPath = [self getFilterDownloadPathWithDic:obj1];
                    if (![[itemPath.pathExtension lowercaseString] isEqualToString:@"acv"]){
                        filter.type = kFilterType_LookUp;
                    }else{
                        filter.type = kFilterType_ACV;
                    }
                    filter.filterPath = itemPath;
                }
                filter.netCover = obj1[@"cover"];
                filter.name = obj1[@"name"];
                [filterArray addObject:filter];
            }];
        }else {
            NSDictionary *obj1 = (NSDictionary *)obj;
            Filter * filter = [Filter new];
            if([obj1[@"name"] isEqualToString:VELocalizedString(@"原始", nil)] || [obj1[@"name"] isEqualToString:@"原始"]){
                filter.type = kFilterTypeNone;
            }else{
                NSString *itemPath = [self getFilterDownloadPathWithDic:obj1];
                if (![[itemPath.pathExtension lowercaseString] isEqualToString:@"acv"]){
                    filter.type = kFilterType_LookUp;
                }else{
                    filter.type = kFilterType_ACV;
                }
                filter.filterPath = itemPath;
            }
            filter.netCover = obj1[@"cover"];
            filter.name = obj1[@"name"];
            [filterArray addObject:filter];
        }
    }];
    
    return filterArray;
}

+ (NSString *)getFilterDownloadPathWithDic:(NSDictionary *)itemDic {
    NSString *filterFolderPath = kFilterFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:filterFolderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:filterFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *pathExtension = [[[itemDic[@"file"] pathExtension] componentsSeparatedByString:@"&ufid"] firstObject];
    NSString *itemPath = [[filterFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)[itemDic[@"file"] hash]]] stringByAppendingPathExtension:pathExtension];
    
    return itemPath;
}

+ (NSString *)getMediaIdentifier {
    NSDate *date_ = [NSDate date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    NSString *identifier = [dateformater stringFromDate:date_];
    return identifier;
}

+ (NSMutableArray *)getMaskArray {
    NSMutableArray *maskArray = [NSMutableArray new];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"None",@"title",@(VEMaskType_NONE),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Linear",@"title",@(VEMaskType_LINNEAR),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Mirror",@"title",@(VEMaskType_MIRRORSURFACE),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Round",@"title",@(VEMaskType_ROUNDNESS),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rectangle",@"title",@(VEMaskType_RECTANGLE),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Quadrilateral",@"title",@(VEMaskType_QUADRILATERAL),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Star",@"title",@(VEMaskType_PENTACLE),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Love",@"title",@(VEMaskType_LOVE),@"id", nil]];
    return maskArray;
}

+ (MaskObject *)getMaskWithName:(NSString *)maskName
{
    NSString *path = [[self getEditBundle] pathForResource:[NSString stringWithFormat:@"/New_EditVideo/mask/Json/%@", maskName] ofType:nil];
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *configDic = [self objectForData:jsonData];
    jsonData = nil;
    NSString *fragPath = [path stringByAppendingPathComponent:configDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:configDic[@"vertShader"]];
    NSError * error = nil;
    
    MaskObject *mask = [[MaskObject alloc] init];
    mask.maskImagePath = path;
    mask.folderPath = path;
    mask.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    mask.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    mask.name = configDic[@"name"];
    
    NSArray *uniformParams = configDic[@"uniformParams"];
    [uniformParams enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *paramName = obj[@"paramName"];
        NSDictionary *frameDic = [obj[@"frameArray"] firstObject];
        if ([paramName isEqualToString:@"center"]) {
            NSArray *value = frameDic[@"value"];
            mask.center = CGPointMake([value[0] floatValue], [value[1] floatValue]);
        }
        else if ([paramName isEqualToString:@"size"]) {
            NSArray *value = frameDic[@"value"];
            mask.size = CGSizeMake([value[0] floatValue], [value[1] floatValue]);
        }
        else if ([paramName isEqualToString:@"degrees"]) {
            mask.degrees = [frameDic[@"value"] floatValue];
        }
        else if ([paramName isEqualToString:@"featherStep"]) {
            mask.featherStep = [frameDic[@"value"] floatValue];
        }
        else if ([paramName isEqualToString:@"invert"]) {
            mask.invert = [frameDic[@"value"] boolValue];
        }
        else if ([paramName isEqualToString:@"distance"]) {
            mask.distance = [frameDic[@"value"] floatValue];
        }
        else if ([paramName isEqualToString:@"cornerRadius"]) {
            mask.cornerRadius = [frameDic[@"value"] floatValue];
        }
        else if ([paramName isEqualToString:@"edgeSize"]) {
            mask.edgeSize = [frameDic[@"value"] floatValue];
        }
        else if ([paramName isEqualToString:@"edgeColor"]) {
            NSArray *value = frameDic[@"value"];
            mask.edgeColor = [[UIColor alloc] initWithRed:[value[0] floatValue] green:[value[1] floatValue] blue:[value[2] floatValue] alpha:[value[3] floatValue]];
        }
        else if ([paramName isEqualToString:@"topLeft"])
        {
            NSArray *value = frameDic[@"value"];
            mask.topLeft = CGPointMake([value[0] floatValue], [value[1] floatValue]);
        }
        else if ([paramName isEqualToString:@"topRight"])
        {
            NSArray *value = frameDic[@"value"];
            mask.topRight = CGPointMake([value[0] floatValue], [value[1] floatValue]);
        }
        else if ([paramName isEqualToString:@"bottomRight"])
        {
            NSArray *value = frameDic[@"value"];
            mask.bottomRight = CGPointMake([value[0] floatValue], [value[1] floatValue]);
        }
        else if ([paramName isEqualToString:@"bottomLeft"])
        {
            NSArray *value = frameDic[@"value"];
            mask.bottomLeft = CGPointMake([value[0] floatValue], [value[1] floatValue]);
        }
    }];
    NSArray *textureParams = configDic[@"textureParams"];
    [textureParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        mask.maskImagePath = [path stringByAppendingPathComponent:obj[@"source"]];
    }];
    if( !textureParams || (textureParams.count ==0) )
    {
        mask.maskImagePath = nil;
    }
    return mask;
}

+ (CustomFilter *)getCustomFilterWithFolderPath:(NSString *)folderPath currentFrameImagePath:(NSString *)currentFrameImagePath {
    NSString *configPath = [folderPath stringByAppendingPathComponent:@"config.json"];
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    NSError * error = nil;
    customFilter.folderPath = folderPath;
    customFilter.name = effectDic[@"name"];
    
    NSString *fragPath = [folderPath stringByAppendingPathComponent:effectDic[@"fragShader"]];
    NSString *vertPath = [folderPath stringByAppendingPathComponent:effectDic[@"vertShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    if (effectDic[@"script"]) {
        NSString *scriptPath = [folderPath stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
    }
    NSString *builtIn = effectDic[@"builtIn"];
    if ([builtIn isEqualToString:@"illusion"]) {
        customFilter.builtInType = BuiltInFilter_illusion;
    }
    customFilter.cycleDuration = [effectDic[@"duration"] floatValue];
    NSArray *uniformParams = effectDic[@"uniformParams"];
    [uniformParams enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *type = obj[@"type"];
        NSMutableArray *paramArray = [NSMutableArray array];
        NSArray *frameArray = obj[@"frameArray"];
        [frameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            ShaderParams *param = [[ShaderParams alloc] init];
            param.time = [obj1[@"time"] floatValue];
            if ([type isEqualToString:@"floatArray"]) {
                param.type = UNIFORM_ARRAY;
                param.array = [NSMutableArray array];
                [obj1[@"value"] enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                    [param.array addObject:[NSNumber numberWithFloat:[obj2 floatValue]]];
                }];
            }else if ([type isEqualToString:@"float"]) {
                param.type = UNIFORM_FLOAT;
                if ([obj1[@"value"] isKindOfClass:[NSArray class]]) {
                    param.fValue = [[obj1[@"value"] firstObject] floatValue];
                }else {
                    param.fValue = [obj1[@"value"] floatValue];
                }
            }else if ([type isEqualToString:@"Matrix4x4"]) {
                param.type = UNIFORM_MATRIX4X4;
                GLMatrix4x4 matrix4;
                NSArray *valueArray = obj1[@"value"];
                matrix4.one = (GLVectore4){[valueArray[0][0] floatValue], [valueArray[0][1] floatValue], [valueArray[0][2] floatValue], [valueArray[0][3] floatValue]};
                matrix4.two = (GLVectore4){[valueArray[1][0] floatValue], [valueArray[1][1] floatValue], [valueArray[1][2] floatValue], [valueArray[1][3] floatValue]};
                matrix4.three = (GLVectore4){[valueArray[2][0] floatValue], [valueArray[2][1] floatValue], [valueArray[2][2] floatValue], [valueArray[2][3] floatValue]};
                matrix4.four = (GLVectore4){[valueArray[3][0] floatValue], [valueArray[3][1] floatValue], [valueArray[3][2] floatValue], [valueArray[3][3] floatValue]};
                param.matrix4 = matrix4;
            }else {
                param.type = UNIFORM_INT;
                if ([obj1[@"value"] isKindOfClass:[NSArray class]]) {
                    param.iValue = [[obj1[@"value"] firstObject] intValue];
                }else {
                    param.iValue = [obj1[@"value"] intValue];
                }
            }
            [paramArray addObject:param];
        }];
        [customFilter setShaderUniformParams:paramArray isRepeat:[obj[@"repeat"] boolValue] forUniform:obj[@"paramName"]];
    }];
    NSArray *textureParams = effectDic[@"textureParams"];
    
   for(id  _Nonnull obj in textureParams) {
        @autoreleasepool {
            
            TextureParams *param = [[TextureParams alloc] init];
            param.type = TextureType_Sample2DBuffer;
            param.name = obj[@"paramName"];
            
            NSString *warpMode = obj[@"warpMode"];
            if (warpMode.length > 0) {
                if ([warpMode isEqualToString:@"Repeat"]) {
                    param.warpMode = TextureWarpModeRepeat;
                }else if ([warpMode isEqualToString:@"MirroredRepeat"]) {
                    param.warpMode = TextureWarpModeMirroredRepeat;
                }
            }
            NSString *filterMode = obj[@"filterMode"];
            if (filterMode.length > 0) {
                if ([filterMode isEqualToString:@"Nearest"]) {
                    param.filterMode = TextureFilterNearest;
                }else if ([filterMode isEqualToString:@"Linear"]) {
                    param.filterMode = TextureFilterLinear;
                }
            }
            if ([[obj objectForKey:@"paramName"] isEqualToString:@"currentFrameTexture"]
                && [[NSFileManager defaultManager] fileExistsAtPath:currentFrameImagePath]) {
                param.type = TextureType_Sample2DMain;
                NSMutableArray *paths = [NSMutableArray arrayWithObject:currentFrameImagePath];
                param.pathArray = paths;
            }else {
                NSString *sourceName = obj[@"source"];
                if ([sourceName isKindOfClass:[NSString class]]) {
                    if (sourceName.length > 0) {
                        NSString *newPath = [folderPath stringByAppendingPathComponent:sourceName];
                        NSMutableArray *paths = [NSMutableArray arrayWithObject:newPath];
                        param.pathArray = paths;
                    }
                }
                else if ([sourceName isKindOfClass:[NSArray class]]) {
                    NSMutableArray *sourceArray = [obj[@"source"] mutableCopy];
                    NSMutableArray *arr = [NSMutableArray array];
                    for (NSString * imageName in sourceArray) {
                        NSString *newpath = [folderPath stringByAppendingPathComponent:imageName];

                        [arr addObject:newpath];
                    }
                    param.pathArray = [NSMutableArray arrayWithArray:arr];
                }
            }
            [customFilter setShaderTextureParams:param];
        }
    }
    effectDic = nil;
    return customFilter;
}

+ (void)setApngCaptionFrameArrayWithImagePath:(NSString *)path jsonDic:(NSMutableDictionary *)jsonDic {
    NSString *apngPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", jsonDic[@"name"]]];
    
    NSData *apngData = [NSData dataWithContentsOfFile:apngPath];
    UIImage *apngImage = [UIImage ve_animatedGIFWithData:apngData];
    
    [jsonDic setObject:[NSNumber numberWithFloat:apngImage.duration] forKey:@"duration"];
    NSArray *timeArray = [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0], @"beginTime", [NSNumber numberWithFloat:apngImage.duration], @"endTime", nil]];
    [jsonDic setObject:timeArray forKey:@"timeArray"];
    NSMutableArray *frameArray = [NSMutableArray array];
    if (apngImage.images > 0) {
        [apngImage.images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *imagePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%lu.png", jsonDic[@"name"], (unsigned long)idx]];
            BOOL result = [UIImagePNGRepresentation(obj) writeToFile:imagePath atomically:YES];
            if(!result) {
                NSLog(@"%zd保存失败", idx);
            }else {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0], @"time", [NSNumber numberWithInteger:idx], @"pic", nil];
                [frameArray addObject:dic];
            }
        }];
    }else {
        NSString *imagePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@0.png", jsonDic[@"name"]]];
        
        BOOL result = [UIImagePNGRepresentation(apngImage) writeToFile:imagePath atomically:YES];
        if(!result) {
            NSLog(@"0保存失败");
        }else {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0], @"time", [NSNumber numberWithInteger:0], @"pic", nil];
            [frameArray addObject:dic];
        }
    }
        if (frameArray.count > 0) {
            [jsonDic setObject:frameArray forKey:@"frameArray"];
        }
    apngData = nil;
    apngImage = nil;
}

@end
