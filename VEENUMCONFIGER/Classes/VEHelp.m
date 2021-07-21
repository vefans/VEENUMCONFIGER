//
//  VEHelp.m
//  VEENUMCONFIGER
//
//

#import <sys/utsname.h>
#import <sys/mount.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import <CoreText/CoreText.h>
#import <VEENUMCONFIGER/VEHelp.h>
#import <VEENUMCONFIGER/UIImage+VEGIF.h>
#import <Reachability/Reachability.h>
#import <SDWebImage/SDWebImage.h>
#import <SDWebImageWebPCoder/UIImage+WebP.h>
#import <SDWebImage/UIImage+GIF.h>
#import <ZipArchive/ZipArchive.h>
#import <VEENUMCONFIGER/VEFileDownloader.h>

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

+ (NSString *)timeToSecFormat:(float)time{
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
        minutes += hour*60;
    }
    secondsInt += minutes*60;
    strText=[NSString stringWithFormat:@"%i.%d", secondsInt,diff];
    return strText;
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

+(NSBundle *)getBundle
{
    return [VEHelp getEditBundle];;
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

+(NSMutableArray *)getGroupColorArray
{
    NSMutableArray * colorArray = [NSMutableArray array];
    
    [colorArray addObject:UIColorFromRGB(0xF11145)];
    [colorArray addObject:UIColorFromRGB(0xEDBE1C)];
    [colorArray addObject:UIColorFromRGB(0x47E0B4)];
    [colorArray addObject:UIColorFromRGB(0xDA503F)];
    [colorArray addObject:UIColorFromRGB(0x277AFE)];
    [colorArray addObject:UIColorFromRGB(0x41BD45)];
    
    [colorArray addObject:UIColorFromRGB(0xA851FE)];
    [colorArray addObject:UIColorFromRGB(0x9B5A2C)];
    [colorArray addObject:UIColorFromRGB(0x505DB2)];
    [colorArray addObject:UIColorFromRGB(0xEB3C7F)];
    [colorArray addObject:UIColorFromRGB(0xFF00FF)];
    [colorArray addObject:UIColorFromRGB(0xFFB6C1)];
    [colorArray addObject:UIColorFromRGB(0x0000FF)];
    [colorArray addObject:UIColorFromRGB(0x87CEFA)];
    [colorArray addObject:UIColorFromRGB(0x00FFFF)];
    
    [colorArray addObject:UIColorFromRGB(0xFFA500)];
    [colorArray addObject:UIColorFromRGB(0xA52A2A)];
    [colorArray addObject:UIColorFromRGB(0xEE82EE)];
    [colorArray addObject:UIColorFromRGB(0x1E90FF)];
    [colorArray addObject:UIColorFromRGB(0x008000)];
    [colorArray addObject:UIColorFromRGB(0xA0522D)];
    [colorArray addObject:UIColorFromRGB(0x008B8B)];
    [colorArray addObject:UIColorFromRGB(0x164c6e)];
    
    return colorArray;
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

#pragma mark- 多脚本json加载
+ (CustomMultipleFilter *)getCustomMultipleFilerWithFolderPath:(NSString *) folderPath currentFrameImagePath:(NSString *)currentFrameImagePath
{
    CustomMultipleFilter *customMultipleFilter = nil;
    NSMutableArray<CustomFilter*>* filterArray = [[NSMutableArray alloc] init];
    
    NSString *configPath = [folderPath stringByAppendingPathComponent:@"config.json"]; // ok
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    NSArray* shaderArray = effectDic[@"effect"];
    if (shaderArray.count) {
        [shaderArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary* shaderDic = obj;
            NSLog(@"name:%@",shaderDic[@"name"]);
            [filterArray addObject:[self getCustomFilterWithDictionary:shaderDic folderPath:folderPath currentFrameTexturePath:currentFrameImagePath]];
        }];
    }
    else
        [filterArray addObject:[self getCustomFilterWithDictionary:effectDic folderPath:folderPath currentFrameTexturePath:currentFrameImagePath]];
    customMultipleFilter = [[CustomMultipleFilter alloc] initWithFilterArray:filterArray];
    customMultipleFilter.folderPath = folderPath;
    return customMultipleFilter;
}

+ (CustomFilter *)getCustomFilterWithDictionary:(NSMutableDictionary*)effectDic
                                     folderPath:(NSString*)path
                        currentFrameTexturePath:(NSString *)currentFrameTexturePath
{
    //TODO:解析json新增的字段
    NSError * error = nil;
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    
    customFilter.folderPath = path;
    customFilter.name = effectDic[@"name"];
    if(!customFilter.name) //必须设置名字，多脚本滤镜根据名字确定绘制顺序
        customFilter.name = @"linghunchuqiao";
    
    NSString *fragPath = [path stringByAppendingPathComponent:effectDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:effectDic[@"vertShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    if (effectDic[@"script"]) {
        NSString *scriptPath = [path stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
    }
//    customFilter.name = effectDic[@"name"];
    

    //输入纹理
    NSArray* inputFilterName = effectDic[@"inputEffect"];
    [inputFilterName enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [customFilter.inputFilterName addObject:obj];
    }];
    
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
            
            //输入纹理对应的索引号
            if(obj[@"inputEffectIndex"])
                param.index = [obj[@"inputEffectIndex"] intValue];
            
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
            if ([[obj objectForKey:@"paramName"] isEqualToString:@"currentFrameTexture"]) {
                param.type = TextureType_Sample2DMain;
                NSMutableArray *paths = [NSMutableArray arrayWithObject:currentFrameTexturePath];
                param.pathArray = paths;
            }else {
                NSString *sourceName = obj[@"source"];
                if ([sourceName isKindOfClass:[NSString class]]) {
                    if (sourceName.length > 0) {
                        __weak NSString *newPath = path;
                        newPath = [newPath stringByAppendingPathComponent:sourceName];
                        
                        NSMutableArray *paths = [NSMutableArray arrayWithObject:newPath];
                        param.pathArray = paths;
                    }
                }
                else if ([sourceName isKindOfClass:[NSArray class]]) {
                    NSMutableArray *sourceArray = [obj[@"source"] mutableCopy];
                    NSMutableArray *arr = [NSMutableArray array];
                    for (NSString * _Nonnull imageName in sourceArray) {
                        NSString *newpath = [path stringByAppendingPathComponent:imageName];
                        [arr addObject:newpath];
                    }
                    param.pathArray = [NSMutableArray arrayWithArray:arr];//
                }
            }
            [customFilter setShaderTextureParams:param];
        }
    }
    effectDic = nil;
    return customFilter;
 
}


#pragma mark- 单脚本json加载
+ (CustomFilter *)getCustomFilterWithFolderPath:(NSString *)folderPath currentFrameImagePath:(NSString *)currentFrameImagePath {
    NSString *configPath = [folderPath stringByAppendingPathComponent:@"config.json"];
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    NSError * error = nil;
    customFilter.folderPath = folderPath;
    customFilter.name = effectDic[@"name"];
    if(!customFilter.name) //必须设置名字，多脚本滤镜根据名字确定绘制顺序
        customFilter.name = @"linghunchuqiao";
    
    NSString *fragPath = [folderPath stringByAppendingPathComponent:effectDic[@"fragShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    if (effectDic[@"vertShader"]) {
        NSString *vertPath = [folderPath stringByAppendingPathComponent:effectDic[@"vertShader"]];
        customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    }    
    if (effectDic[@"script"]) {
        NSString *scriptPath = [folderPath stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
    }
    
    //输入纹理
    NSArray* inputFilterName = effectDic[@"inputEffect"];
    [inputFilterName enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [customFilter.inputFilterName addObject:obj];
    }];
    
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
            
            //输入纹理对应的索引号
            if(obj[@"inputEffectIndex"])
                param.index = [obj[@"inputEffectIndex"] intValue];
            
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

+ (CustomTransition *)getCustomTransitionWithJsonPath:(NSString *)configPath {
    NSString *path = [configPath stringByDeletingLastPathComponent];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *configDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    
    CustomTransition *transition = [[CustomTransition alloc] init];
    transition.folderPath = path;
    NSError * error = nil;
    if (![configPath.pathExtension isEqualToString:@"json"]) {
        transition.frag = [NSString stringWithContentsOfFile:configPath encoding:NSUTF8StringEncoding error:&error];
        return transition;
    }
    NSString *fragPath = [path stringByAppendingPathComponent:configDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:configDic[@"vertShader"]];
    transition.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    transition.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    transition.name = configDic[@"name"];
    
    NSArray *uniformParams = configDic[@"uniformParams"];
    [uniformParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *type = obj[@"type"];
        NSDictionary *frameDic = [obj[@"frameArray"] firstObject];
        TranstionShaderParams *param = [[TranstionShaderParams alloc] init];
        if ([type isEqualToString:@"floatArray"]) {
            param.type = UNIFORM_ARRAY;
            param.array = [NSMutableArray array];
            [frameDic[@"value"] enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                [param.array addObject:[NSNumber numberWithFloat:[obj1 floatValue]]];
            }];
        }else if ([type isEqualToString:@"float"]) {
            param.type = UNIFORM_FLOAT;
            if ([frameDic[@"value"] isKindOfClass:[NSArray class]]) {
                param.fValue = [[frameDic[@"value"] firstObject] floatValue];
            }else {
                param.fValue = [frameDic[@"value"] floatValue];
            }
        }else if ([type isEqualToString:@"Matrix4x4"]) {
            param.type = UNIFORM_MATRIX4X4;
            GLMatrix4x4 matrix4;
            NSArray *valueArray = frameDic[@"value"];
            matrix4.one = (GLVectore4){[valueArray[0][0] floatValue], [valueArray[0][1] floatValue], [valueArray[0][2] floatValue], [valueArray[0][3] floatValue]};
            matrix4.two = (GLVectore4){[valueArray[1][0] floatValue], [valueArray[1][1] floatValue], [valueArray[1][2] floatValue], [valueArray[1][3] floatValue]};
            matrix4.three = (GLVectore4){[valueArray[2][0] floatValue], [valueArray[2][1] floatValue], [valueArray[2][2] floatValue], [valueArray[2][3] floatValue]};
            matrix4.four = (GLVectore4){[valueArray[3][0] floatValue], [valueArray[3][1] floatValue], [valueArray[3][2] floatValue], [valueArray[3][3] floatValue]};
            param.matrix4 = matrix4;
        }else {
            param.type = UNIFORM_INT;
            if ([frameDic[@"value"] isKindOfClass:[NSArray class]]) {
                param.iValue = [[frameDic[@"value"] firstObject] intValue];
            }else {
                param.iValue = [frameDic[@"value"] intValue];
            }
        }
        [transition setShaderUniformParams:param forUniform:obj[@"paramName"]];
    }];
    
    NSArray *textureParams = configDic[@"textureParams"];
    [textureParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TranstionTextureParams *param = [[TranstionTextureParams alloc] init];
        NSString *sourceName = obj[@"source"];
        if( [sourceName isKindOfClass:[NSString class]] )
        {
            if (sourceName.length > 0) {
                param.type = TextureType_Sample2DBuffer;
                param.pathArray = [NSMutableArray new];
                [param.pathArray addObject:[[configPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:sourceName]];
                NSString *warpMode = obj[@"warpMode"];
                if ([warpMode isEqualToString:@"Repeat"]) {
                    param.warpMode = TextureWarpModeRepeat;
                }else if ([warpMode isEqualToString:@"MirroredRepeat"]) {
                    param.warpMode = TextureWarpModeMirroredRepeat;
                }
            }
            param.name = obj[@"paramName"];
            [transition setShaderTextureParams:param];
        }
        else
        {
            NSMutableArray *sourceArray = (NSMutableArray*)sourceName;
            if( sourceArray && (sourceArray.count>0) )
            {
                NSString *paramName = obj[@"paramName"];
                if( [paramName isKindOfClass:[NSString class]] )
                {
                    param.name = paramName;
                }
                param.pathArray = [NSMutableArray new];
                [sourceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [param.pathArray addObject:[[configPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:obj]];
                }];
                
                if( param.pathArray.count > 0 )
                    [transition setShaderTextureParams:param];
            }
        }
    }];
    return transition;
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
+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius {
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

+ (BOOL)exportSlomoVideoFile:(VEMediaInfo *)file
{
    __block BOOL isSuccess = YES;
    NSString *directory = [kVEDirectory stringByAppendingPathComponent:@"SlomoVideo"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:directory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path;
    NSArray *temp = [file.localIdentifier componentsSeparatedByString:@"/"];
    if (temp.count > 0) {
        path = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov", [temp firstObject]]];
    }else {
        path = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov", file.localIdentifier]];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if (![file.contentURL.absoluteString.lastPathComponent isEqual:path.lastPathComponent]) {
            file.videoActualTimeRange = kCMTimeRangeZero;
            file.contentURL = [NSURL fileURLWithPath:path];
            file.videoTimeRange = CMTimeRangeMake(kCMTimeZero,file.videoDurationTime);
            file.reverseVideoTimeRange = file.videoTimeRange;
            file.videoTrimTimeRange = kCMTimeRangeInvalid;
            file.reverseVideoTrimTimeRange = kCMTimeRangeInvalid;
        }
    }else {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[file.localIdentifier] options:options];
        if (fetchResult.count == 0) {
            isSuccess = NO;
        }else {
            PHAsset *asset = [fetchResult firstObject];
            PHVideoRequestOptions *opt_s = [[PHVideoRequestOptions alloc] init]; // assets的配置设置
            opt_s.version = PHVideoRequestOptionsVersionCurrent;
            opt_s.networkAccessAllowed = NO;
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:opt_s resultHandler:^(AVAsset * _Nullable asset_l, AVAudioMix * _Nullable audioMix_l, NSDictionary * _Nullable info_l) {
                NSURL *url = [NSURL fileURLWithPath:path];

                //Begin slomo video export
                AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset_l presetName:AVAssetExportPresetHighestQuality];
                exportSession.outputURL = url;
                exportSession.outputFileType = AVFileTypeQuickTimeMovie;
                exportSession.shouldOptimizeForNetworkUse = YES;
                
                [exportSession exportAsynchronouslyWithCompletionHandler:^{
                    if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                        file.videoActualTimeRange = kCMTimeRangeZero;
                        file.contentURL = url;
                        file.videoTimeRange = CMTimeRangeMake(kCMTimeZero,file.videoDurationTime);
                        file.reverseVideoTimeRange = file.videoTimeRange;
                        file.videoTrimTimeRange = kCMTimeRangeInvalid;
                        file.reverseVideoTrimTimeRange = kCMTimeRangeInvalid;
                    }else if (exportSession.status == AVAssetExportSessionStatusFailed || exportSession.status == AVAssetExportSessionStatusCancelled) {
                        isSuccess = NO;
                    }
                    dispatch_semaphore_signal(semaphore);
                }];
            }];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
    }
    return isSuccess;
}

+ (NSString *)returnEditorVideoPath{
    NSString *docmentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *editvideoPath = [NSString stringWithFormat:@"%@/EDITORVIDEO",docmentsPath];
    if(![[NSFileManager defaultManager] fileExistsAtPath:editvideoPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:editvideoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return editvideoPath;
}

+ (BOOL)createSaveTmpFileFolder{
    return YES;//不能删除，草稿要用
    NSError *error = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self returnEditorVideoPath]]) {
        [fm removeItemAtPath:[self returnEditorVideoPath] error:&error];
        if(error){
            fm = nil;
            return NO;
        }
        [fm createDirectoryAtPath:[self returnEditorVideoPath] withIntermediateDirectories:YES attributes:nil error:&error];
        if(error){
            NSLog(@"error:%@",error);
            fm = nil;
            return NO;
        }
    }else{
        [fm createDirectoryAtPath:[self returnEditorVideoPath] withIntermediateDirectories:YES attributes:nil error:&error];
        if(error){
            NSLog(@"error:%@",error);
            fm = nil;
            return NO;
        }
    }
    if(error){
        NSLog(@"error:%@",error);
        fm = nil;
        return NO;
    }
    fm = nil;
    return YES;
}

+(CGSize)getPEexpSize:(NSMutableArray *) peMediaInfos
{
    __block CGSize expSize = CGSizeZero;
    [peMediaInfos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VEMediaInfo * mediaInfo = (VEMediaInfo*)obj;
        UIImage * image = [self getFullScreenImageWithUrl:mediaInfo.contentURL];
        if( image.size.width > expSize.width )
        {
            expSize.width =  image.size.width;
        }
        if( image.size.height > expSize.height )
        {
            expSize.height =  image.size.height;
        }
    }];
    return expSize;
}

+ (UIImage *)getFullScreenImageWithUrl:(NSURL *)url {
    if([self isSystemPhotoUrl:url]){//
        __block UIImage *image;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;//解决草稿箱获取不到缩略图的问题
        PHFetchResult *phAsset = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
        
        [[PHImageManager defaultManager] requestImageForAsset:[phAsset firstObject] targetSize:CGSizeMake(IMAGE_MAX_SIZE_WIDTH, IMAGE_MAX_SIZE_HEIGHT) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            image = result;
            result = nil;
            info = nil;
        }];
        options = nil;
        phAsset = nil;
        return image;
    }else{
        if([self isImageUrl:url]){
            UIImage * image = [self imageWithContentOfPath:url.path];
            image = [self fixOrientation:image];
            return image;
        }else{
            return [self assetGetThumImage:0.0 url:url urlAsset:nil];
        }
    }
}

+ (UIImage *)imageWithContentOfPath:(NSString *)path{
    @autoreleasepool {
        NSData *image_data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage imageWithData:image_data];
        image_data = nil;
        return image;
    }
}

+ (UIImage *)imageWithWebP:(NSString *)filePath error:(NSError **)error
{
    // If passed `filepath` is invalid, return nil to caller and log error in console
   
    NSError *dataError = nil;
    NSData *imgData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&dataError];
    if (dataError != nil) {
        *error = dataError;
        return nil;
    }
    return [UIImage sd_imageWithWebPData:imgData];
}

/// 修正图片转向
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    //if (!self.shouldFixOrientation) return aImage;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark- 居中处理，计算对应的Crop
+ (CGRect)getFixedRatioCropWithMediaSize:(CGSize)mediaSize newSize:(CGSize)newSize {
    float newSizePro = newSize.width/newSize.height;
    float imageSizePro = mediaSize.width/mediaSize.height;
    CGRect crop = CGRectMake(0, 0, 1, 1);
    if (imageSizePro != newSizePro) {
        float x,y,w,h;
        if (newSizePro == 1.0) {
            w = MIN(mediaSize.width, mediaSize.height);
            h = w;
        }else if (newSizePro > 1.0) {
            w = mediaSize.width;
            h = w/newSizePro;
            if (h > mediaSize.height) {
                h = mediaSize.height;
                w = h*newSizePro;
            }
        }else {
            h = mediaSize.height;
            w = h*newSizePro;
            if (w > mediaSize.width) {
                w = mediaSize.width;
                h = w / newSizePro;
            }
        }
        x = fabs(mediaSize.width - w)/2.0;
        y = fabs(mediaSize.height - h)/2.0;
        
        CGRect clipRect = CGRectMake(x, y, w, h);
        crop.origin.x = clipRect.origin.x/mediaSize.width;
        crop.origin.y = clipRect.origin.y/mediaSize.height;
        crop.size.width = clipRect.size.width/mediaSize.width;
        crop.size.height = clipRect.size.height/mediaSize.height;
    }
    return crop;
}

+ (CGSize)getEditSizeWithFile:(VEMediaInfo *)file {
    CGSize editSize;
    if (file.fileType == kFILEIMAGE || file.fileType == kFILETEXT) {
        UIImage *image = [VEHelp getFullScreenImageWithUrl:file.contentURL];
        if(file.isHorizontalMirror && file.isVerticalMirror){
            float rotate = 0;
            if(file.rotate == 0){
                rotate = -180;
            }else if(file.rotate == -90){
                rotate = -270;
            }else if(file.rotate == -180){
                rotate = -0;
            }else if(file.rotate == -270){
                rotate = -90;
            }
            image = [VEHelp imageRotatedByDegrees:image rotation:rotate];
        }else{
            image = [VEHelp imageRotatedByDegrees:image rotation:file.rotate];
        }
        editSize = CGSizeMake(image.size.width*file.crop.size.width, image.size.height*file.crop.size.height);
        image = nil;
    }else {
        if(file.isReverse){
            editSize = [VEHelp trackSize:file.reverseVideoURL rotate:file.rotate crop:file.crop];
        }else{
            editSize = [VEHelp trackSize:file.contentURL rotate:file.rotate crop:file.crop];
        }
    }
    if (editSize.width > kVIDEOWIDTH || editSize.height > kVIDEOWIDTH) {
        if(editSize.width > editSize.height){
            CGSize tmpsize = editSize;
            editSize.width  = kVIDEOWIDTH;
            editSize.height = kVIDEOWIDTH * tmpsize.height/tmpsize.width;
        }else{
            CGSize tmpsize = editSize;
            editSize.height  = kVIDEOWIDTH;
            editSize.width = kVIDEOWIDTH * tmpsize.width/tmpsize.height;
        }
    }
    return editSize;
}
+ (CGSize)getEditOrginSizeWithFile:(VEMediaInfo *)file {
    CGSize editSize;
    if (file.fileType == kFILEIMAGE || file.fileType == kFILETEXT) {
        UIImage *image = [VEHelp getFullScreenImageWithUrl:file.contentURL];
        if(file.isHorizontalMirror && file.isVerticalMirror){
            float rotate = 0;
            if(file.rotate == 0){
                rotate = -180;
            }else if(file.rotate == -90){
                rotate = -270;
            }else if(file.rotate == -180){
                rotate = -0;
            }else if(file.rotate == -270){
                rotate = -90;
            }
            image = [VEHelp imageRotatedByDegrees:image rotation:rotate];
        }else{
            image = [VEHelp imageRotatedByDegrees:image rotation:file.rotate];
        }
        editSize = CGSizeMake(image.size.width, image.size.height);
        image = nil;
    }else {
        if(file.isReverse){
            editSize = [VEHelp trackSize:file.reverseVideoURL rotate:file.rotate crop:CGRectMake(0, 0, 1, 1)];
        }else{
            editSize = [VEHelp trackSize:file.contentURL rotate:file.rotate crop:CGRectMake(0, 0, 1, 1)];
        }
    }
    if (editSize.width > kVIDEOWIDTH || editSize.height > kVIDEOWIDTH) {
        if(editSize.width > editSize.height){
            CGSize tmpsize = editSize;
            editSize.width  = kVIDEOWIDTH;
            editSize.height = kVIDEOWIDTH * tmpsize.height/tmpsize.width;
        }else{
            CGSize tmpsize = editSize;
            editSize.height  = kVIDEOWIDTH;
            editSize.width = kVIDEOWIDTH * tmpsize.width/tmpsize.height;
        }
    }
    return editSize;
}
+ (CGSize)trackSize:(NSURL *)contentURL rotate:(float)rotate crop:(CGRect)crop{
    CGSize size = CGSizeZero;
    AVURLAsset *asset = [AVURLAsset assetWithURL:contentURL];
    
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks count] > 0) {
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
    
    CGSize newSize;
    
    BOOL isportrait = [self isVideoPortrait:asset];
    
    if(size.height == size.width){
        
        newSize        = size;
        
    }else if(isportrait){
        newSize = size;
        
        if(size.height < size.width){
            //newSize  = CGSizeMake(size.height, size.width);
            newSize  = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
        }
        if(rotate == -90 || rotate == -270){
            newSize  = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
        }
    }else{
        if(rotate == -90 || rotate == -270){
            //newSize  = CGSizeMake(size.height, size.width);
            newSize  = CGSizeMake(MIN(size.width, size.height), MAX(size.width, size.height));
        }else{
            newSize  = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
            
        }
    }
    if(!isnan(crop.size.width) && !isnan(crop.size.height)){
        newSize = CGSizeMake(newSize.width * crop.size.width, newSize.height * crop.size.height);
    }
    if(newSize.width>newSize.height){
        CGSize tmpsize = newSize;
        newSize.width  = kVIDEOWIDTH;
        newSize.height = kVIDEOWIDTH * tmpsize.height/tmpsize.width;
    }else{
        CGSize tmpsize = newSize;
        newSize.height  = kVIDEOWIDTH;
        newSize.width = kVIDEOWIDTH * tmpsize.width/tmpsize.height;
    }
    
    return newSize;
}
/**图片旋转
 */
+ (UIImage *)imageRotatedByDegrees:(UIImage *)cImage rotation:(float)rotation
{
        CGSize size = CGSizeZero;
    if(cImage.size.width>cImage.size.height){
        if(rotation == 90 || rotation == -90 || rotation == 270 || rotation == -270){
            size = CGSizeMake(MIN(cImage.size.width, cImage.size.height), MAX(cImage.size.width, cImage.size.height));
        }else{
            size = CGSizeMake(MAX(cImage.size.width, cImage.size.height), MIN(cImage.size.width, cImage.size.height));
        }
    }else{
        if(rotation == 90 || rotation == -90 || rotation == 270 || rotation == -270){
            size = CGSizeMake(MAX(cImage.size.width, cImage.size.height), MIN(cImage.size.width, cImage.size.height));
        }else{
            size = CGSizeMake(MIN(cImage.size.width, cImage.size.height), MAX(cImage.size.width, cImage.size.height));
        }
    }
    
//    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height)];
//    CGAffineTransform t = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(rotation));
//    rotatedViewBox.transform = t;
    CGSize rotatedSize = size;//rotatedViewBox.frame.size;
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, DEGREES_TO_RADIANS(-rotation));
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    //CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), [cImage CGImage]);
    CGContextDrawImage(bitmap, CGRectMake(-cImage.size.width / 2, -cImage.size.height / 2, cImage.size.width, cImage.size.height), [cImage CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

/**判断视频是横屏还是竖屏
 */
+ (BOOL) isVideoPortrait:(AVURLAsset *)asset
{
    BOOL isPortrait = NO;
    NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if([tracks    count] > 0) {
        AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
        CGSize size = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
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
        CGAffineTransform t = videoTrack.preferredTransform;
        if(fabs(size.height)>fabs(size.width)){
            return YES;
        }
        
        //        CGAffineTransform t = videoTrack.preferredTransform;
        // Portrait
        if(t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0)
        {
            isPortrait = YES;
        }
        // PortraitUpsideDown
        if(t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0)  {
            
            isPortrait = YES;
        }
        // LandscapeRight
        if(t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0)
        {
            isPortrait = NO;
        }
        // LandscapeLeft
        if(t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0)
        {
            isPortrait = NO;
        }
        if((size.width<0 || size.height<0)){
            return NO;
        }
    }
    return isPortrait;
}

+(UIView *)initReversevideoProgress:(  UIViewController * ) viewController atLabelTag:(int *) labelTag atCancel:(SEL)cancel
{
    UIView * view = [[UIView alloc] initWithFrame:viewController.view.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [viewController.view addSubview:view];
    
    UIView * reverseVideoView = [[UIView alloc] initWithFrame:CGRectMake( (view.frame.size.width-150.0)/2.0, (view.frame.size.height-150.0)/2.0, 150.0, 150.0)];
    reverseVideoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];;
    reverseVideoView.layer.cornerRadius = 5.0;
    reverseVideoView.layer.masksToBounds = YES;
    [view addSubview:reverseVideoView];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( (reverseVideoView.frame.size.width - 100)/2.0, 10, 100, 100)];
    [imageView sd_setImageWithURL:[NSURL fileURLWithPath:[[VEHelp getEditBundle] pathForResource:@"/New_EditVideo/animatSchedule_@3x" ofType:@"png"]]];
    [reverseVideoView addSubview:imageView];

    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0 , imageView.frame.size.height + imageView.frame.origin.y, reverseVideoView.frame.size.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.text = VELocalizedString(@"倒放中0%", nil);
    label.textColor = [UIColor whiteColor];
    label.tag = 30121;
    *labelTag = 30121;
    [reverseVideoView addSubview:label];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(reverseVideoView.frame.size.width - 30,  0, 30, 30)];
    btn.layer.cornerRadius = btn.frame.size.width/2.0;
    btn.layer.masksToBounds = YES;
//    btn.backgroundColor = [UIColor  colorWithWhite:0.6 alpha:1.0];
    [btn setImage:[VEHelp imageNamed:@"jianji/music/剪辑-剪辑-音乐_关闭默认_"] forState:UIControlStateNormal];
    [btn addTarget:viewController action:cancel forControlEvents:UIControlEventTouchUpInside];
    [reverseVideoView addSubview:btn];
    
    return view ;
}

+ (NSString *) getResourceFromBundle : (NSString *) bundleName resourceName:(NSString *)name Type : (NSString *) type
{
    NSBundle *bundle = nil;
    bundle = [VEHelp getEditBundle];
    return [bundle pathForResource:name ofType:type];
}

///获取当前时间戳作为文件名
+ (NSString *)getFileNameForNowTime{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    NSDate *date_ = [NSDate date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd_HH-mm-ss-SSS"];
    return [dateformater stringFromDate:date_];
}

+ (NSString *)getFileUrlWithFolderPath:(NSString *)folderPath fileName:(NSString *)fileName {
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath;
    BOOL isExists = NO;
    NSInteger index = 0;
    do {
        filePath = [[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%ld", fileName.stringByDeletingPathExtension, (long)index]] stringByAppendingPathExtension:fileName.pathExtension];
        index ++;
        isExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    } while (isExists);
    return filePath;
}

+(NSString *)getPEImagePathForNowTime
{
    NSString *folder;
    if(!folder){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        folder =[[paths objectAtIndex:0] stringByAppendingPathComponent:@"Documents/PEImage"];
    }
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[folder stringByDeletingLastPathComponent]]){
        [[NSFileManager defaultManager] createDirectoryAtPath:[folder stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return  [VEHelp getFileUrlWithFolderPath:folder fileName:[NSString stringWithFormat:@"%@.png",[self getFileNameForNowTime]]];
}

+(UIImage *)getSystemPhotoImage:( NSURL * ) url
{
    __block UIImage *image;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.networkAccessAllowed = YES;//解决草稿箱获取不到缩略图的问题
    PHFetchResult *phAsset = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
    
    @try {
        [[PHImageManager defaultManager] requestImageForAsset:[phAsset firstObject] targetSize:CGSizeMake(2048, 2048) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            image = result;
            result = nil;
            info = nil;
        }];
    } @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    } @finally {
        options = nil;
        phAsset = nil;
    }
    return image;
}

+ (UIImage *)image:(UIImage *)image rotation:(float)rotation cropRect:(CGRect)cropRect {
    @autoreleasepool {
        if (CGRectEqualToRect(cropRect, CGRectZero)) {
            cropRect = CGRectMake(0, 0, 1, 1);
        }
        
        CGSize size = CGSizeZero;
        if(image.size.width>image.size.height){
            if(rotation == 90 || rotation == -90 || rotation == 270 || rotation == -270){
                size = CGSizeMake(MIN(image.size.width, image.size.height), MAX(image.size.width, image.size.height));
            }else{
                size = CGSizeMake(MAX(image.size.width, image.size.height), MIN(image.size.width, image.size.height));
            }
        }else{
            if(rotation == 90 || rotation == -90 || rotation == 270 || rotation == -270){
                size = CGSizeMake(MAX(image.size.width, image.size.height), MIN(image.size.width, image.size.height));
            }else{
                size = CGSizeMake(MIN(image.size.width, image.size.height), MAX(image.size.width, image.size.height));
            }
        }
        
        UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height)];
        CGAffineTransform t = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(rotation));
        rotatedViewBox.transform = t;
        
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, size.width/2, size.height/2);
        CGContextRotateCTM(context, DEGREES_TO_RADIANS(-rotation));
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGRectMake((-image.size.width / 2), (-image.size.height / 2), image.size.width, image.size.height), [image CGImage]);
        
        UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGRect rect = CGRectMake(resultImage.size.width * cropRect.origin.x, resultImage.size.height * cropRect.origin.y, resultImage.size.width * cropRect.size.width, resultImage.size.height * cropRect.size.height);
        CGImageRef newImageRef = CGImageCreateWithImageInRect(resultImage.CGImage, rect);
        resultImage = [UIImage imageWithCGImage:newImageRef];
        if (newImageRef) {
            CGImageRelease(newImageRef);
        }
        return resultImage;
    }
}

+(CustomFilter *)getAnimateCustomFilter:(NSString *) path
{
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    CustomFilter * customFilter = [CustomFilter new];
    
    customFilter.folderPath = path;
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    NSError * error = nil;
    customFilter.cycleDuration = 0.0;
    customFilter.name = effectDic[@"name"];
    customFilter.folderPath = path;
    NSString *fragPath = [path stringByAppendingPathComponent:effectDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:effectDic[@"vertShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    
    if (effectDic[@"script"]) {
        NSString *scriptPath = [path stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
    }
    
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
            NSString *sourceName = obj[@"source"];
            if ([sourceName isKindOfClass:[NSString class]]) {
                if (sourceName.length > 0) {
                    __weak NSString *newPath = path;
                    newPath = [newPath stringByAppendingPathComponent:sourceName];
                     
                    NSMutableArray *paths = [NSMutableArray arrayWithObject:newPath];
                    param.pathArray = paths;
                }
            }
            else if ([sourceName isKindOfClass:[NSArray class]]) {
                NSMutableArray *sourceArray = [obj[@"source"] mutableCopy];
                NSMutableArray *arr = [NSMutableArray array];
                for (NSString * _Nonnull imageName in sourceArray) {
                    NSString *newpath = [path stringByAppendingPathComponent:imageName];

                    [arr addObject:newpath];
                }
                param.pathArray = [NSMutableArray arrayWithArray:arr];//
                
            }
            [customFilter setShaderTextureParams:param];
        }
    }
    return  customFilter;
}
+(NSInteger)setFontIndex:( NSString * ) name
{
    NSMutableArray * fonts = [NSMutableArray arrayWithContentsOfFile:kFontPlistPath];
    __block NSInteger index = 0;
    [fonts enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *itemDic = obj;
        BOOL hasNew = [[itemDic allKeys] containsObject:@"cover"] ? YES : NO;
        NSString *fontCode = hasNew ? [[itemDic[@"file"] lastPathComponent] stringByDeletingPathExtension] : itemDic[@"name"];
        if( [name isEqualToString:[NSString stringWithFormat:@"%@.%@",fontCode,@"ttf" ]] )
        {
            index = idx;
            *stop = true;
        }
    }];
    return index;
}

#pragma mark-滤镜
+(NSArray *)classificationParams:( NSString * ) type atAppkey:( NSString * ) appkey atURl:( NSString * ) netMaterialTypeURL
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:type,@"type", nil];
    if( appkey.length>0)
        [params setObject:appkey forKey:@"appkey"];
    NSDictionary *dic = [VEHelp updateInfomation:params andUploadUrl:netMaterialTypeURL];
    BOOL hasValue = [[dic objectForKey:@"code"] integerValue]  == 0;
    if( hasValue )
        return [dic objectForKey:@"data"];
    else
        return nil;
}

+ (id)updateInfomation:(NSMutableDictionary *)params andUploadUrl:(NSString *)uploadUrl{
    @autoreleasepool {
        if(!params){
            params  = [[NSMutableDictionary alloc] init];
            [params setObject:@"1" forKey:@"os"];
            [params setObject:@"2" forKey:@"product"];
            
        }
        if(![[params allKeys] containsObject:@"os"]){
            [params setObject:@"ios" forKey:@"os"];
        }
        if(![[params allKeys] containsObject:@"ver"]){
            [params setObject:[NSNumber numberWithInt:[VECore getSDKVersion]] forKey:@"ver"];
        }
//        uploadUrl=[NSString stringWithString:[uploadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        uploadUrl=[NSString stringWithString:[uploadUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        NSURL *url=[NSURL URLWithString:uploadUrl];
        NSString *postURL= [VEHelp createPostURL:params];
        //=====
        NSData *postData = [postURL dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        
//        NSHTTPURLResponse* urlResponse = nil;
//        NSError *error;
//
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        
        __block NSHTTPURLResponse* urlResponse = nil;
        __block NSError *error;
        __block NSData *responseData = nil;
        dispatch_semaphore_t disp = dispatch_semaphore_create(0);
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error1) {
            //处理model
            urlResponse = (NSHTTPURLResponse*)response;
            responseData = data;
            error = error1;
            dispatch_semaphore_signal(disp);
        }];
        [dataTask resume];
        dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);
        
        if(error){
            NSLog(@"error:%@",[error description]);
        }
        if(!responseData){
            return nil;
        }
        id obj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
        responseData = nil;
        urlResponse = nil;
        if(error || !obj){
            error = nil;
            return nil;
        }else{
            return obj;
        }
        
    }
}
+ (id)getNetworkMaterialWithParams:(NSMutableDictionary *)params
                            appkey:(NSString *)appkey
                           urlPath:(NSString *)urlPath
{
    if (!params) {
        params = [NSMutableDictionary dictionary];
    }
    if (appkey.length > 0) {
        [params setObject:appkey forKey:@"appkey"];
    }
    [params setObject:@"ios" forKey:@"os"];
    [params setObject:[NSNumber numberWithInt:[VECore getSDKVersion]] forKey:@"ver"];
    return [self updateInfomation:params andUploadUrl:urlPath];
}

+(UILabel *)loadProgressView:(CGRect) rect
{
    UIColor *color = [UIColor colorWithWhite:0.0 alpha:0.3];
    UILabel * progressLabel = [[UILabel alloc] initWithFrame:rect];
    progressLabel.backgroundColor = color;
    progressLabel.textAlignment = NSTextAlignmentCenter;
    progressLabel.font = [UIFont systemFontOfSize:12];
    progressLabel.textColor = Main_Color;
    
    return progressLabel;
}
#pragma mark- 压缩
+ (void)OpenZip:(NSString*)zipPath  unzipto:(NSString*)_unzipto caption:(BOOL)caption
{
    ZipArchive* zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:zipPath] )
    {
        //NSInteger index =0;
        BOOL ret = [zip UnzipFileTo:_unzipto overWrite:YES];
        if( NO==ret )
        {
            NSLog(@"error");
        }else{
            unlink([zipPath UTF8String]);
        }
        [zip UnzipCloseFile];
    }
}
+ (BOOL)OpenZipp:(NSString*)zipPath  unzipto:(NSString*)_unzipto
{
    ZipArchive* zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:zipPath] )
    {
        //NSInteger index =0;
        BOOL ret = [zip UnzipFileTo:_unzipto overWrite:YES];
        if( NO==ret )
        {
            NSLog(@"error");
        }else{
            unlink([zipPath UTF8String]);
        }
        [zip UnzipCloseFile];
        return YES;
    }
    return NO;
}

+(NSString *)pathForURL_font:(NSString *)name extStr:(NSString *)extStr hasNew:(BOOL)hasNew{
    NSString *filePath = nil;
    if(!hasNew){
        filePath = [NSString stringWithFormat:@"%@/%@/%@.%@",kFontFolder,name,name,extStr];
    }else{
        filePath = [NSString stringWithFormat:@"%@/%@.%@",kFontFolder,name,extStr];
    }
    return filePath;
}

/** 压缩 相关函数
 */
+ (BOOL)OpenZip:(NSString*)zipPath unzipto:(NSString*)_unzipto fileName:(NSString *)fileName
{
    ZipArchive* zip = [[ZipArchive alloc] init];
    if( [zip UnzipOpenFile:zipPath] )
    {
        //NSInteger index =0;
        BOOL ret = [zip UnzipFileTo:_unzipto overWrite:YES];
        if( NO==ret )
        {
            NSLog(@"error");
        }else{
            unlink([zipPath UTF8String]);
        }
        [zip UnzipCloseFile];
        if (ret && fileName.length > 0) {
            NSString *path = [_unzipto stringByAppendingPathComponent:fileName];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:path error:nil];
            [fileArray enumerateObjectsUsingBlock:^(NSString * _Nonnull fileName, NSUInteger idx, BOOL * _Nonnull stop) {
                if([[[fileName pathExtension] lowercaseString] isEqualToString:@"webp"] && ![fileName containsString:@"__MACOSX"]) {
                    [self webpToPng:[path stringByAppendingPathComponent:fileName]];
                }
            }];
        }
        return YES;
    }
    return NO;
}

+ (void)webpToPng:(NSString *)webpPath {
    @autoreleasepool {
        NSFileManager* fman = [NSFileManager defaultManager];
        NSError *error = nil;
        UIImage *result = [self imageWithWebP:webpPath error:&error];
        //UIImage *result = [UIImage ve_imageWithWebP:webpPath error:&error];
         if (error) {
         NSLog(@"%@", error.localizedDescription);
         }else{
             NSData *pngData;
             @try {
                 pngData =  UIImagePNGRepresentation(result);
             }@catch (NSException *exception) {
                     NSLog(@"exception: %@",exception);
             }
             result = nil;
             if (pngData) {
                 if ([pngData writeToFile:[[webpPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"png"] options:NSAtomicWrite error:&error])
                 {
                     [fman removeItemAtPath:webpPath error:&error];
                 }else {
                     NSLog(@"%@", error.localizedDescription);
                 }
             }else {
                 NSLog(@"");
             }
        }
    }
}


+(NSString *)objectToJson:(id)obj {
    if (!obj || ![NSJSONSerialization isValidJSONObject:obj]) {
        return nil;
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj
                                                       options:0
                                                         error:&error];
    
    if ([jsonData length] && !error){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}

+(NSDictionary *)getCaptionConfig_Dic:( NSString * ) configPath
{
    NSString *path = [[NSString stringWithFormat:@"%@",configPath] stringByAppendingFormat:@"/config.json"];
    NSFileManager *manager = [[NSFileManager alloc] init];
    if([manager fileExistsAtPath:path]){
        NSLog(@"have");
    }else{
        NSLog(@"nohave");
    }
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    data = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
    
    NSError *err;
    if(data){
        NSDictionary *subtitleEffectConfig = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingMutableContainers
                                                                                      error:&err];
        return subtitleEffectConfig;
    }
    else
    {
        return nil;
    }
}

+(Caption *)getCaptionConfig:( NSString * ) configPath atStart:(float) startTime atConfig:(NSDictionary **) config atType:(NSInteger) captionType
{
    @try {
        NSString *path = [[NSString stringWithFormat:@"%@",configPath] stringByAppendingFormat:@"/config.json"];
        NSFileManager *manager = [[NSFileManager alloc] init];
        if([manager fileExistsAtPath:path]){
            NSLog(@"have");
        }else{
            NSLog(@"nohave");
        }
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        data = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
        
        NSError *err;
        if(data){
            NSDictionary *subtitleEffectConfig = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingMutableContainers
                                                                                          error:&err];
            (*config) = subtitleEffectConfig;
            
            if(err) {
                NSLog(@"json解析失败：%@",err);
            }
            
            float   x = [subtitleEffectConfig[@"centerX"] floatValue];
            float   y = [subtitleEffectConfig[@"centerY"] floatValue];
            int     w = [subtitleEffectConfig[@"width"] intValue];
            int     h = [subtitleEffectConfig[@"height"] intValue];
            
            int fx = 0,fy = 0,fw = 0,fh = 0;
            NSArray *textPadding = subtitleEffectConfig[@"textPadding"];
            fx =  [textPadding[0] intValue];
            fy =  [textPadding[1] intValue]+3;
            fw =  [subtitleEffectConfig[@"textWidth"] intValue];
            fh =  [subtitleEffectConfig[@"textHeight"] intValue];
            
            Caption *ppCaption = [[Caption alloc]init];
            ppCaption.isVerticalText = [subtitleEffectConfig[@"vertical"] boolValue];
//            ppCaption.captionImagePath =
            ppCaption.imageFolderPath =[configPath stringByAppendingString:@"/"];
            
            // [[NSBundle mainBundle].bundlePath  stringByAppendingString:@"/"];
            ppCaption.type = (CaptionType)[[subtitleEffectConfig objectForKey:@"type"] integerValue];
            ppCaption.angle = 0;
            ppCaption.position= CGPointMake(x, y);
            ppCaption.size = CGSizeMake(w, h);
            ppCaption.duration = [subtitleEffectConfig[@"duration"] floatValue];
            ppCaption.imageName = subtitleEffectConfig[@"name"];
            
//            ppCaption.tFontSize = 10;
            
            ppCaption.scale = 1;
            ppCaption.angle = 0;
            if([subtitleEffectConfig[@"music"] isKindOfClass:[NSMutableDictionary class]]){
                ppCaption.music.name = subtitleEffectConfig[@"music"][@"src"];
            }else{
                ppCaption.music.name = nil;
            }
            if(ppCaption.type == CaptionTypeHasText){
                if( captionType == 2 ){
//                    [self.stickerScrollview setContentTextFieldText:subtitleEffectConfig[@"textContent"]];
                }else{
//                    if( ![self.subtitleView isFieldChanged] ){
//                        ppCaption.pText = VELocalizedString(@"", nil);
////                        [self.subtitleView setContentTextFieldText:ppCaption.pText];
//                    }else{
                        ppCaption.pText = VELocalizedString(@"点击输入字幕", nil);
//                        [self.subtitleView setContentTextFieldText:ppCaption.pText];
//                    }
                }
                
                ppCaption.tFontName = subtitleEffectConfig[@"textFont"];//@"Helvetica-Bold";//
                
                ppCaption.tFontName = [[UIFont systemFontOfSize:10] fontName];
                ppCaption.tFrame = CGRectMake(fx, fy, fw, fh);
                NSArray *textColors = subtitleEffectConfig[@"textColor"];
                float r = [(textColors[0]) floatValue]/255.0;
                float g = [(textColors[1]) floatValue]/255.0;
                float b = [(textColors[2]) floatValue]/255.0;
                
                ppCaption.tColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
                
                NSArray *strokeColors = subtitleEffectConfig[@"strokeColor"];
                
                ppCaption.strokeColor =  [UIColor colorWithRed:[(strokeColors[0]) floatValue]/255.0
                                                         green:[(strokeColors[0]) floatValue]/255.0
                                                          blue:[(strokeColors[0]) floatValue]/255.0
                                                         alpha:1];
                
                
                if([subtitleEffectConfig objectForKey:@"tAngle"])
                    ppCaption.tAngle = [[subtitleEffectConfig objectForKey:@"tAngle"] floatValue];
                
                ppCaption.strokeWidth = [[subtitleEffectConfig objectForKey:@"strokeWidth"] floatValue]/2;
                
            }
            ppCaption.frameArray = subtitleEffectConfig[@"frameArray"];
            ppCaption.timeArray = subtitleEffectConfig[@"timeArray"];
            
            ppCaption.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(startTime/*+0.1*/, TIMESCALE), CMTimeMakeWithSeconds(ppCaption.duration, TIMESCALE));
            
            ppCaption.textAnimate = nil;
            ppCaption.imageAnimate = nil;
            ppCaption.customAnimate = nil;
            
            ppCaption.customOutAnimate = nil;
            return ppCaption;
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

+ (id)getNetworkMaterialWithType:(NSString *)type
                          appkey:(NSString *)appkey
                         urlPath:(NSString *)urlPath
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:type forKey:@"type"];
    if (appkey.length > 0) {
        [params setObject:appkey forKey:@"appkey"];
    }
    [params setObject:@"ios" forKey:@"os"];
    [params setObject:[NSNumber numberWithInt:[VECore getSDKVersion]] forKey:@"ver"];
    return [self updateInfomation:params andUploadUrl:urlPath];
}

+(void)downloadFonts:(void(^)(NSError *error))callBack
{
    VEEditConfiguration *editConfig =  [VEConfigManager sharedManager].editConfiguration;
    BOOL hasNewFont =  editConfig.fontResourceURL.length>0;
    NSString *uploadUrl = (hasNewFont ? editConfig.fontResourceURL : getFontTypeUrl);
    NSMutableDictionary *fontListDic;
    if(hasNewFont){
        fontListDic = [VEHelp getNetworkMaterialWithType:kFontType
                                                             appkey:[VEConfigManager sharedManager].appKey
                                                      urlPath:uploadUrl];
    }else{
        fontListDic = [VEHelp updateInfomation:nil andUploadUrl:uploadUrl];
    }
    if (hasNewFont ? ([fontListDic[@"code"] intValue] != 0) : ([fontListDic[@"code"] intValue] != 200)){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callBack) {
                NSString *message;
                if (fontListDic) {
                    if (hasNewFont) {
                        message = fontListDic[@"msg"];
                    }else {
                        message = fontListDic[@"message"];
                    }
                }
                if (!message || message.length == 0) {
                    message = VELocalizedString(@"下载失败，请检查网络!", nil);
                }
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"com.PESDK.ErrorDomain" code:VESDKErrorCode_DownloadSubtitle userInfo:userInfo];
                callBack(error);
            }
        });
        return;
    }
    NSArray *fontList = [fontListDic objectForKey:@"data"];
    NSDictionary *fontIconDic = [fontListDic objectForKey:@"icon"];
    NSString *iconUrl = [fontIconDic objectForKey:@"caption"];
    NSString *cacheFolderPath = [[VEHelp pathFontForURL:[NSURL URLWithString:iconUrl]] stringByDeletingLastPathComponent];
    NSString *cacheIconPath = [cacheFolderPath stringByAppendingPathComponent:@"icon"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cacheFolderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if([[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheIconPath error:nil].count==0 && !hasNewFont){
        //将plist文件写入文件夹
        BOOL suc = [fontList writeToFile:kFontPlistPath atomically:YES];
        suc = [fontIconDic writeToFile:kFontIconPlistPath atomically:YES];
        [VEFileDownloader downloadFileWithURL:iconUrl cachePath:cacheFolderPath HTTPMethod:VEGET cancelBtn: nil progress:^(NSNumber *numProgress) {
            NSLog(@"progress:%f",[numProgress floatValue]);
//            if(progressBlock){
//                progressBlock([numProgress floatValue]);
//            }
        } finish:^(NSString *fileCachePath) {
            [VEHelp OpenZipp:fileCachePath unzipto:cacheFolderPath];
        } fail:^(NSError *error) {
        }cancel:^{
        }];
    }else{
        [self updateLocalMaterialWithType:VEAdvanceEditType_None newList:fontList];
        BOOL suc = [fontList writeToFile:kFontPlistPath atomically:YES];
        suc = [fontIconDic writeToFile:kFontIconPlistPath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callBack) {
                callBack(nil);
            }
        });
    }
}

+ (void)updateLocalMaterialWithType:(VEAdvanceEditType)type newList:(NSArray *)newList {
    NSString *folderPath;
    if (type == VEAdvanceEditType_Subtitle) {
        folderPath = kSubtitlePlistPath;
    }else if (type == VEAdvanceEditType_Sticker) {
        folderPath = kStickerPlistPath;
    }else {
        folderPath = kFontPlistPath;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *oldList = [[NSArray alloc] initWithContentsOfFile:folderPath];
    if (oldList.count > 0) {
        [newList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            NSString *updateTime = obj1[@"updatetime"];
            [oldList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                if ([obj2[@"id"] intValue] == [obj1[@"id"] intValue]) {
                    if (![obj2[@"updatetime"] isEqualToString:updateTime]) {
                        NSString *file = [[obj2[@"file"] stringByDeletingLastPathComponent] lastPathComponent];
                        NSString *path = [folderPath stringByAppendingPathComponent:file];
                        if ([fileManager fileExistsAtPath:path]) {
                            [fileManager removeItemAtPath:path error:nil];
                        }
                    }
                    *stop2 = YES;
                }
            }];
        }];
    }
}

+(NSString *)pathFontForURL:(NSURL *)aURL{
    return [kFontFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"Font-%lu.zip", (unsigned long)[[aURL description] hash]]];
}

+(NSMutableAttributedString *)getAttrString:(NSString *) string atForegroundColor:(UIColor *) foregroundColor atStrokeColor:(UIColor *) strokeColor atShadowBlurRadius:(float) shadowBlurRadius atShadowOffset:(CGSize) shadowOffset atShadowColor:(UIColor *) shadowColor
{
    NSString *str = string;
    NSRange range = NSMakeRange(0, str.length);
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    [attrString addAttribute:NSForegroundColorAttributeName value:foregroundColor range:range];
    [attrString addAttribute:NSStrokeWidthAttributeName value:@-2 range:range];
    [attrString addAttribute:NSStrokeColorAttributeName value:strokeColor range:range];
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowBlurRadius = shadowBlurRadius;
    shadow.shadowOffset = shadowOffset;
    shadow.shadowColor = shadowColor;
    [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
    [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:range];
    return  attrString;
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage*)drawImages:(NSMutableArray *)images size:(CGSize)size animited:(BOOL)animited{
    if(images.count>0){
        float width=0;
        float height;
        if(animited){
            height = ((UIImage *)images[0]).size.height/2;
        }else{
            height = ((UIImage *)images[0]).size.height;
        }
        for(int i=0;i<images.count;i++){
            if(animited){
                width = width + ((UIImage *)images[i]).size.width/2;
            }else{
                width = width + ((UIImage *)images[i]).size.width;
            }
        }
        size = CGSizeMake(width, height);

        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        UIGraphicsGetCurrentContext();
        float x=0;
        for (NSInteger i =0;i<images.count;i++) {
            UIImage *imagees = images[i];
            float width = imagees.size.width;
//            NSLog(@"%s : %f",__func__,imagees.size.width);
            if(animited){
                width = imagees.size.width/2;
            }
            [imagees drawInRect:CGRectMake(x,0,width,size.height)];
            x+=width;
        }
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }else{
        return nil;
    }
    
}

+ (CaptionAnimationType)captionAnimateToCaptionAnimation:(CaptionAnimateType)type {
    CaptionAnimationType resultType;
    switch (type) {
        case CaptionAnimateTypeUp:
        case CaptionAnimateTypeDown:
        case CaptionAnimateTypeLeft:
        case CaptionAnimateTypeRight:
            resultType = CaptionAnimationTypeMove;
            break;
            
        case CaptionAnimateTypeScaleInOut:
            resultType = CaptionAnimationTypeScaleInOut;
            break;
            
        case CaptionAnimateTypeScrollInOut:
            resultType = CaptionAnimationTypeScrollInOut;
            break;
            
        case CaptionAnimateTypeFadeInOut:
            resultType = CaptionAnimationTypeFadeInOut;
            break;
            
        default:
            resultType = CaptionAnimationTypeNone;
            break;
    }
    return resultType;
}

+ (UIImage *)getLastScreenShotImageFromVideoURL:(NSURL *)fileURL atTime:(CMTime)time {
    if (CMTimeCompare(time, kCMTimeZero) < 0) {
        return nil;
    }
    @autoreleasepool {
        AVURLAsset *asset = [AVURLAsset assetWithURL:fileURL];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        //如果需要精确时间
        gen.requestedTimeToleranceAfter = kCMTimeZero;
        gen.requestedTimeToleranceBefore = kCMTimeZero;
        
        NSError *error = nil;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:nil error:&error];
        float frameRate = 0.0;
        if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] > 0) {
            AVAssetTrack* clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            frameRate = clipVideoTrack.nominalFrameRate;
            if (CMTimeCompare(time, clipVideoTrack.timeRange.duration) == 1) {
                time = clipVideoTrack.timeRange.duration;
            }
        }
        while (!image) {
            error = nil;
            time = CMTimeSubtract(time, CMTimeMake(1, frameRate>0 ? frameRate : 30));
            image = [gen copyCGImageAtTime:time actualTime:nil error:&error];
            if (image || CMTimeCompare(kCMTimeZero, time) == 0) {
                break;
            }
        }
        UIImage *shotImage = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        
        if(error){
            NSLog(@"error:%@",error);
            error = nil;
        }
        gen = nil;
        asset = nil;
        return shotImage;
    }
}

+ (UIImage *)geScreenShotImageFromVideoURL:(NSURL *)fileURL atTime:(CMTime)time  atSearchDirection:(bool) isForward{
    
    if( isForward )
    {
        return  [VEHelp getLastScreenShotImageFromVideoURL:fileURL atTime:time];
    }
    
    if (CMTimeCompare(time, kCMTimeZero) < 0) {
        time = kCMTimeZero;
    }
    @autoreleasepool {
        AVURLAsset *asset = [AVURLAsset assetWithURL:fileURL];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        gen.apertureMode =AVAssetImageGeneratorApertureModeEncodedPixels;
        //如果需要精确时间
        gen.requestedTimeToleranceAfter = kCMTimeZero;
        gen.requestedTimeToleranceBefore = kCMTimeZero;
        
        NSError *error = nil;
        CGImageRef image = [gen copyCGImageAtTime:time actualTime:nil error:&error];
        
        float frameRate = 0.0;
        float duration = 0;
        if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] > 0) {
            AVAssetTrack* clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            frameRate = clipVideoTrack.nominalFrameRate;
            if (CMTimeCompare(time, clipVideoTrack.timeRange.duration) == 1) {
                time = clipVideoTrack.timeRange.duration;
            }
            duration = CMTimeGetSeconds(clipVideoTrack.timeRange.duration);
        }
        while (!image) {
            error = nil;
            time = CMTimeAdd(time, CMTimeMake(1, frameRate>0 ? frameRate : 30));
            image = [gen copyCGImageAtTime:time actualTime:nil error:&error];
            if (image || CMTimeCompare(kCMTimeZero, time) == 0) {
                break;
            }
            
//            if( duration < CMTimeGetSeconds(time) )
//            {
//                break;
//            }
            
        }
        UIImage *shotImage = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        
        if(error){
            NSLog(@"error:%@",error);
            error = nil;
        }
        gen = nil;
        asset = nil;
        return shotImage;
    }
}

+(float)getMediaAssetScale_File:( CGSize ) size atRect:(CGRect) rect atCorp:(CGRect) corp atSyncContainerHeihgt:(CGSize) syncContainerSize atIsWatermark:(BOOL) isWatermark
{
    if (CGRectEqualToRect(corp, CGRectZero)) {
        corp = CGRectMake(0, 0, 1, 1);
    }
    
    float scale = 1;
    
    
    float width;
    float height;
    if (syncContainerSize.width == syncContainerSize.height) {
        if( isWatermark )
            width = syncContainerSize.width/4.0/4.0;
        else
            width = syncContainerSize.width/4.0;
        height = width / (size.width / size.height);
    }else if (syncContainerSize.width < syncContainerSize.height) {
        if( isWatermark )
            width = syncContainerSize.width/2.0/4.0;
        else
            width = syncContainerSize.width/2.0;
        height = width / (size.width / size.height);
    }else {
        if( isWatermark )
            height = syncContainerSize.height/2.0/4.0;
        else
            height = syncContainerSize.height/2.0;
        width = height * (size.width / size.height);
    }
    
    size = CGSizeMake(width * corp.size.width, height * corp.size.height);
    
    scale = rect.size.height*syncContainerSize.height/size.height;
    
    return scale;
}
@end
