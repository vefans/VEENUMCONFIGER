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
    NSString *path = url.path;
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
    
    for (int i = 0; i< newFileArray.count; i++) {
        if( (!fileArray[i].isGif) && (fileArray[i].fileType == kFILEIMAGE)  )
        {
            [array addObject:newFileArray[i]];
        }
        else if(![[NSFileManager defaultManager] fileExistsAtPath:fileArray[i].filtImagePatch]){
            [[NSFileManager defaultManager] createDirectoryAtPath:fileArray[i].filtImagePatch withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else
        {
            [array addObject:newFileArray[i]];
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
    if ([fileUrl.scheme.lowercaseString isEqualToString:@"ipod-library"]
        || [fileUrl.scheme.lowercaseString isEqualToString:@"assets-library"])
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

+ (NSURL *)getFileURLFromAbsolutePath:(NSString *)absolutePath {
    if(absolutePath.length==0){
        return nil;
    }
    NSURL *fileURL = [NSURL URLWithString:absolutePath];
    if ([fileURL.scheme.lowercaseString isEqualToString:@"ipod-library"]
        || [fileURL.scheme.lowercaseString isEqualToString:@"assets-library"])
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
    if ([fileURL isEqualToString:@"ipod-library"]
        || [fileURL isEqualToString:@"assets-library"])
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
@end
