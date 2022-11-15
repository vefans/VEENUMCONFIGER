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
#import <VEENUMCONFIGER/VEReachability.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIImage+MultiFormat.h>
#import <SDWebImage/UIImage+GIF.h>
#import <ZipArchive/ZipArchive.h>
#import <VEENUMCONFIGER/VEFileDownloader.h>
#import <VEENUMCONFIGER/VECircleView.h>
#import <LibVECore/VECoreYYModel.h>

VENetworkResourceType const VENetworkResourceType_CardMusic = @"cardpoint_music";//卡点音乐
VENetworkResourceType const VENetworkResourceType_CloudMusic = @"cloud_music";//配乐
VENetworkResourceType const VENetworkResourceType_OnlineAlbum = @"cloud_video";//在线相册
VENetworkResourceType const VENetworkResourceType_SoundEffect = @"audio";//音效
VENetworkResourceType const VENetworkResourceType_MediaAnimation = @"animate";//媒体动画
VENetworkResourceType const VENetworkResourceType_Text = @"sub_title";//文字
VENetworkResourceType const VENetworkResourceType_TextAnimation = @"ani_subtitle";//文字动画
VENetworkResourceType const VENetworkResourceType_TextTemplate = @"text_template";//文字模板
VENetworkResourceType const VENetworkResourceType_Sticker = @"stickers";//贴纸
VENetworkResourceType const VENetworkResourceType_StickerAnimation = @"ani_sticker";//贴纸动画
VENetworkResourceType const VENetworkResourceType_Filter = @"filter2";//滤镜
VENetworkResourceType const VENetworkResourceType_Transition = @"transition";//转场
VENetworkResourceType const VENetworkResourceType_ScreenEffect = @"specialeffects";//画面特效
VENetworkResourceType const VENetworkResourceType_Font = @"font_family_2";//字体
VENetworkResourceType const VENetworkResourceType_APITemplate = @"templateapi";//API剪同款
VENetworkResourceType const VENetworkResourceType_Canvas = @"bg_style";//画布
VENetworkResourceType const VENetworkResourceType_ParticleEffect = @"particle";//粒子特效
VENetworkResourceType const VENetworkResourceType_ShootParticle = @"shoot_particle";//拍摄粒子
VENetworkResourceType const VENetworkResourceType_CoverTemplate = @"templatecover";//封面模板
VENetworkResourceType const VENetworkResourceType_DoodlePen = @"doodleeffect";//涂鸦笔
VENetworkResourceType const VENetworkResourceType_Mask = @"mask";//蒙版
VENetworkResourceType const VENetworkResourceType_MaskShape = @"mask_shape";//形状蒙版

//亮度
float const VEAdjust_MinValue_Brightness = -1.0;
float const VEAdjust_MaxValue_Brightness = 1.0;
float const VEAdjust_DefaultValue_Brightness = 0.0;
//对比度
float const VEAdjust_MinValue_Contrast = 0.0;
float const VEAdjust_MaxValue_Contrast = 2.0;
float const VEAdjust_DefaultValue_Contrast = 1.0;
//饱和度
float const VEAdjust_MinValue_Saturation = 0.0;
float const VEAdjust_MaxValue_Saturation = 2.0;
float const VEAdjust_DefaultValue_Saturation = 1.0;
//锐度
float const VEAdjust_MinValue_Sharpness = 0.0;
float const VEAdjust_MaxValue_Sharpness = 1.0;
float const VEAdjust_DefaultValue_Sharpness = 0.0;
//色温
float const VEAdjust_MinValue_WhiteBalance = -1.0;
float const VEAdjust_MaxValue_WhiteBalance = 1.0;
float const VEAdjust_DefaultValue_WhiteBalance = 0.0;
//暗角
float const VEAdjust_MinValue_Vignette = 0.0;
float const VEAdjust_MaxValue_Vignette = 1.0;
float const VEAdjust_DefaultValue_Vignette = 0.0;
//高光
float const VEAdjust_MinValue_Highlight = -1.0;
float const VEAdjust_MaxValue_Highlight = 1.0;
float const VEAdjust_DefaultValue_Highlight = 0.0;
//阴影
float const VEAdjust_MinValue_Shadow = 0.0;
float const VEAdjust_MaxValue_Shadow = 1.0;
float const VEAdjust_DefaultValue_Shadow = 0.0;
//颗粒
float const VEAdjust_MinValue_Granule = 0.0;
float const VEAdjust_MaxValue_Granule = 1.0;
float const VEAdjust_DefaultValue_Granule = 0.0;
//光感
float const VEAdjust_MinValue_LightSensation = -1.0;
float const VEAdjust_MaxValue_LightSensation = 1.0;
float const VEAdjust_DefaultValue_LightSensation = 0.0;
//色调
float const VEAdjust_MinValue_Tint = -1.0;
float const VEAdjust_MaxValue_Tint = 1.0;
float const VEAdjust_DefaultValue_Tint = 0.0;
//褪色
float const VEAdjust_MinValue_Fade = 0.0;
float const VEAdjust_MaxValue_Fade = 1.0;
float const VEAdjust_DefaultValue_Fade = 0.0;
//曝光
float const VEAdjust_MinValue_Exposure = -1.0;
float const VEAdjust_MaxValue_Exposure = 1.0;
float const VEAdjust_DefaultValue_Exposure = 0.0;

@implementation VEHelp

+ (UIEdgeInsets) safeAreaInsets{

    UIEdgeInsets safeAreaInsets = UIEdgeInsetsZero;

    if (@available(iOS 11.0, *)) {

        safeAreaInsets = [[[[UIApplication sharedApplication] delegate]window]safeAreaInsets];

    }

    return safeAreaInsets;

}

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
    }else {//iPad运行内存小于等于3个G的都算低配
        if([self totalMemory] < 1024 * 2){
            isLowDevice = YES;
        }
    }
    
    return isLowDevice;
}
+ (double)totalMemory {
    // Find the total amount of memory
    @try {
        // Set up the variables
        double totalMemory = 0.00;
        double allMemory = [[NSProcessInfo processInfo] physicalMemory];
        
        // Total Memory (formatted)
        totalMemory = (allMemory / 1024.0) / 1024.0;
        
        // Round to the nearest multiple of 256mb - Almost all RAM is a multiple of 256mb (I do believe)
        int toNearest = 256;
        int remainder = (int)totalMemory % toNearest;
        
        if (remainder >= toNearest / 2) {
            // Round the final number up
            totalMemory = ((int)totalMemory - remainder) + 256;
        } else {
            // Round the final number down
            totalMemory = (int)totalMemory - remainder;
        }
        
        // Check to make sure it's valid
        if (totalMemory <= 0) {
            // Error, invalid memory value
            return -1;
        }
        
        // Completed Successfully
        return totalMemory;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
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
//        haomiao=0.f;
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
       || [pathExtension isEqualToString:@"webp"]
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
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:0.2 animations:^{
        view.frame = rect;
    }];
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
            UIImage *image = [UIImage imageWithData:imagedata];
            if (MIN(image.size.width, image.size.height) > IMAGE_MAX_SIZE_WIDTH) {
                float scale;
                if (image.size.width >= image.size.height) {
                    scale = IMAGE_MAX_SIZE_WIDTH / image.size.width;
                }else {
                    scale = IMAGE_MAX_SIZE_WIDTH / image.size.height;
                }
                image = [self scaleImage:image toScale:(scale*(480.0/1080.0))];
            }
            image = [self fixOrientation:image];
            return image;//[UIImage imageWithContentsOfFile:url.path];
        }else{
            UIImage *image = [VEHelp imageWithWebP:url.path error:nil];
            if( !image )
                return [self assetGetThumImage:0.5 url:url urlAsset:nil];
            else{
                if (MIN(image.size.width, image.size.height) > IMAGE_MAX_SIZE_WIDTH) {
                    float scale;
                    if (image.size.width >= image.size.height) {
                        scale = IMAGE_MAX_SIZE_WIDTH / image.size.width;
                    }else {
                        scale = IMAGE_MAX_SIZE_WIDTH / image.size.height;
                    }
                    image = [self scaleImage:image toScale:(scale*(480.0/1080.0))];
                }
                image = [self fixOrientation:image];
                return image;//[UIImage imageWithContentsOfFile:url.path];
            }
        }
    }
}

+ (BOOL)isSystemPath:(NSString *)path {
    BOOL isSystemPath = YES;
    NSRange range = [path rangeOfString:@"Bundle/Application/"];
    if (range.location != NSNotFound) {
        isSystemPath = NO;
    }else {
        range = [path rangeOfString:@"Data/Application/"];
        if (range.location != NSNotFound) {
            isSystemPath = NO;
        }
    }
    return isSystemPath;
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
        }else {
            range = [path rangeOfString:@"/var/mobile"];//LivePhotos
            if (range.location != NSNotFound) {
                isSystemUrl = NO;
            }
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

+(UIImage *)imageWithContentOfFile:(NSString *)path atBundle:( NSBundle * ) bundle
{
    NSString *imagePath = nil;
    if([[path pathExtension] length] > 0){
        imagePath = [bundle pathForResource:[NSString stringWithFormat:@"%@",path]  ofType:@""];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if(image){
        return image;
    }
    imagePath = [bundle pathForResource:[NSString stringWithFormat:@"%@@3x",path]  ofType:@"png"];
    if([[path pathExtension] length] > 0){
        imagePath = [bundle pathForResource:[NSString stringWithFormat:@"%@",path]  ofType:@""];
    }
    image = [UIImage imageWithContentsOfFile:imagePath];
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

+ (NSString *)getSourcePath:(NSString *)path{
    
    NSBundle *bundle = [self getEditBundle];
    
    return [bundle pathForResource:path  ofType:@"mp4"];
}

+ (UIImage *)imageWithContentOfFile:(NSString *)path{
    @autoreleasepool {
        NSBundle *bundle = [self getEditBundle];
        return [self imageWithContentOfFile:path atBundle:bundle];
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

+( UIImage * )imageNamed:(NSString *)name atBundle:( NSBundle * ) bundle
{
    return [self imageWithContentOfFile:name atBundle:bundle];
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
    return [VEHelp getEditBundle];
}

+(void)getStickerAnimation:( NSString * ) path atCaption:( Caption * ) caption atCustomFiler:( CustomFilter * ) customFilter
{
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *folderName;
    for (NSString *fileName in files) {
        if (![fileName isEqualToString:@"__MACOSX"]) {
            NSString *folderPath = [path stringByAppendingPathComponent:fileName];
            BOOL isDirectory = NO;
            BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDirectory];
            if (isExists && isDirectory) {
                folderName = fileName;
                break;
            }
        }
    }
    if (folderName.length > 0) {
        path = [path stringByAppendingPathComponent:folderName];
    }
    
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
//    CustomFilter *customFilter = [[CustomFilter alloc] init];
    customFilter.folderPath = path;

    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    NSError * error = nil;
    customFilter.name = effectDic[@"name"];
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
    NSString *fragPath = [path stringByAppendingPathComponent:effectDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:effectDic[@"vertShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    
    if (effectDic[@"script"]) {
        NSString *scriptPath = [path stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
        customFilter.scriptName = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
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
    
    if( [caption isKindOfClass:[Caption class]] )
    {
        if( effectDic[@"other"] )
        {
            if( [effectDic[@"other"] isKindOfClass:[NSArray class]] )
            {
                caption.otherAnimates = [NSMutableArray new];
                NSArray *array = effectDic[@"other"];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [caption.otherAnimates addObject:[VEHelp getAnmationDic:(NSMutableDictionary*)obj atPath:path]];
                }];
            }
            else
            {
                [caption.otherAnimates addObject:[VEHelp getAnmationDic:(NSMutableDictionary*)effectDic[@"other"] atPath:path]];
            }
        }
        else{
            if( customFilter.animateType == CustomAnimationTypeIn )
            {
                [caption.otherAnimates enumerateObjectsUsingBlock:^(CustomFilter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj = nil;
                }];
                caption.otherAnimates = nil;
            }
        }
    }
    else if( [caption isKindOfClass:[CaptionEx class]] )
    {
        if( effectDic[@"other"] )
        {
            if( [effectDic[@"other"] isKindOfClass:[NSArray class]] )
            {
                NSArray *array = effectDic[@"other"];
                ((CaptionEx*)caption).captionImage.otherAnimates = [VEHelp getAnmationDic:array[0] atPath:path];
            }
            else
            {
                ((CaptionEx*)caption).captionImage.otherAnimates  = [VEHelp getAnmationDic:(NSMutableDictionary*)effectDic[@"other"] atPath:path];
            }
        }
        else{
            if( customFilter.animateType == CustomAnimationTypeIn )
            {
                ((CaptionEx*)caption).captionImage.otherAnimates = nil;
            }
        }
    }
}


+ (NSBundle *)getBundleName:( NSString * ) name
{
    NSString * bundlePath = [[NSBundle bundleForClass:self.class] pathForResource: name  ofType :@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
    return  resourceBundle;
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

//判断是否已经缓存过这个URL
+(BOOL) hasCachedFont:(NSString *)code url:(NSString *)fontUrl{
    
    if(fontUrl.length==0 || !fontUrl){
        return NO;
    }
//    fontUrl = [NSString stringWithString:[fontUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    fontUrl = [NSString stringWithString:[fontUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self pathForURL_font:code url:fontUrl]]) {
        return YES;
    }
    else return NO;
}

+ (NSString *)pathForURL_font_WEBP_down:(NSString *)name extStr:(NSString *)extStr{
    return [NSString stringWithFormat:@"%@/%@.%@",kFontFolder,name,extStr];
}

+(NSString *)pathForURL_font:(NSString *)code url:(NSString *)fontUrl{
//    fontUrl = [NSString stringWithString:[fontUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    fontUrl = [NSString stringWithString:[fontUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    if(fontUrl.length>0){
        NSString *exString = [fontUrl substringFromIndex:fontUrl.length-3];
        return [NSString stringWithFormat:@"%@/%@.%@",kFontFolder,code,exString];//cachedFont-%d
    }else{
        return nil;
    }
    
}

+ (UIImage *) imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = cornerRadius * 2 + 1;
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

+ (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC {
//    CGFloat x1 = pointA.x - pointB.x;
//    CGFloat y1 = pointA.y - pointB.y;
//    CGFloat x2 = pointC.x - pointB.x;
//    CGFloat y2 = pointC.y - pointB.y;
//
//    CGFloat x = x1 * x2 + y1 * y2;
//    CGFloat y = x1 * y2 - x2 * y1;
//
//    CGFloat angle = acos(x/sqrt(x*x+y*y));
    double theta = atan2(pointA.x - pointB.x, pointA.y - pointB.y) - atan2(pointC.x - pointB.x, pointC.y - pointB.y);
    if (theta > M_PI)
        theta -= 2 * M_PI;
    if (theta < -M_PI)
        theta += 2 * M_PI;
    
    theta = (theta * 180.0 / M_PI);
//    if( theta > 90.0 )
//    {
//        theta = 180.0 - theta;
//    }
//    else if( theta > 180.0 )
//    {
//        theta = 270 - theta;
//    }
//    else if( theta < -90.0 )
//    {
//        theta = 180 + theta;
//    }
//    else if( theta < -180.0 )
//    {
//        theta = 270 + theta;
//    }
//    else if( theta > -90.0 )
//    {
//        theta = 90.0 + theta;
//    }
//
    if( pointB.x > pointA.x )
    {
        if( theta > 0 )
            theta = -theta;
    }
    else if( pointB.x < pointA.x )
    {
        if( theta < 0 )
            theta = -theta;
    }
    
    return theta;
}

/**
 *  获取设备可用容量(G)
 */
+(float)getFreeDiskSize
{
    //    但是在iOS11以上使用这个方法获取剩余空间不准确了，或者跟系统不一样
    //    iOS11上可以使用
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:NSTemporaryDirectory()];
    CGFloat freeSize = 0;
    if (@available(iOS 11.0, *)) {
        NSDictionary *results = [fileURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:nil];
        // 这里拿到的值的单位是bytes，iOS11是这样算的1000MB = 1，1000进制算的
        // bytes->KB->MB->G
        
        freeSize = [results[NSURLVolumeAvailableCapacityForImportantUsageKey] floatValue]/1000.0f/1000.0f/1000.0f;
    } else {
        // Fallback on earlier versions
    }
    
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
    NSString * sizeStr = [NSString stringWithFormat:VELocalizedString(@"内存可用%0.2fGB / 共%0.2fGB", nil),freeDiskSize,totalFreeSpace];
    return sizeStr;
}

//自动换行，计算并添加“\n”进行换行
+(NSString *)setPastTextWith:(float) witdh atText:(NSString *) text atFont:(UIFont *) font
{
    //获取手动换行的次数 及 在text中的位置
    __block NSMutableArray * array = [NSMutableArray new];
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
    if ([self isSystemPhotoUrl:fileURL] || [absolutePath containsString:@"mobile/Media"])
    {
        if ([absolutePath containsString:@"mobile/Media"]) {
            fileURL = [NSURL fileURLWithPath:absolutePath];
        }
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
            if ([filePah hasPrefix:@"/private"]) {
                filePah = [filePah substringFromIndex:[@"/private" length]];
            }
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
            if ([filePah hasPrefix:@"/private"]) {
                filePah = [filePah substringFromIndex:[@"/private" length]];
            }
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

+ (UIColor *)colorWithHexStr:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
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

+ (NSMutableArray *)getDoodlePenColors {
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:UIColorFromRGB(0xffffff)];//0
    [colors addObject:UIColorFromRGB(0xbfbfbf)];//1
    [colors addObject:UIColorFromRGB(0x878787)];//2
    [colors addObject:UIColorFromRGB(0x535353)];//3
    [colors addObject:UIColorFromRGB(0x000000)];//4
    [colors addObject:UIColorFromRGB(0xf8bfc7)];//5
    [colors addObject:UIColorFromRGB(0xf1736d)];//06
    [colors addObject:UIColorFromRGB(0xee3842)];//7
    [colors addObject:UIColorFromRGB(0xed002b)];//预设效果_02 //08
    [colors addObject:UIColorFromRGB(0xa50816)];//09
    [colors addObject:UIColorFromRGB(0xfad9a2)];//010
    [colors addObject:UIColorFromRGB(0xf4c76c)];//011
    [colors addObject:UIColorFromRGB(0xf17732)];//012
    [colors addObject:UIColorFromRGB(0xed260b)];//013
    [colors addObject:UIColorFromRGB(0xaf160d)];//014
    [colors addObject:UIColorFromRGB(0xfdf9b8)];//015
    [colors addObject:UIColorFromRGB(0xfeff7a)];//016
    [colors addObject:UIColorFromRGB(0xfbe80d)];//预设效果_03 //017
    [colors addObject:UIColorFromRGB(0xf5af0a)];//018
    [colors addObject:UIColorFromRGB(0xef5409)];//019
    [colors addObject:UIColorFromRGB(0xf5aac4)];//020
    [colors addObject:UIColorFromRGB(0xf1679a)];//021
    [colors addObject:UIColorFromRGB(0xee246e)];//022
    [colors addObject:UIColorFromRGB(0xed0045)];//023
    [colors addObject:UIColorFromRGB(0x94004f)];//024
    [colors addObject:UIColorFromRGB(0xd9aee1)];//025
    [colors addObject:UIColorFromRGB(0xe261fa)];//026
    [colors addObject:UIColorFromRGB(0xd40dfa)];//027
    [colors addObject:UIColorFromRGB(0xb000f5)];//028
    [colors addObject:UIColorFromRGB(0x4900a1)];//029
    [colors addObject:UIColorFromRGB(0xc6b4e2)];//030
    [colors addObject:UIColorFromRGB(0xa36bff)];//031
    [colors addObject:UIColorFromRGB(0x723cff)];//032
    [colors addObject:UIColorFromRGB(0x5000fe)];//033
    [colors addObject:UIColorFromRGB(0x2e00a9)];//034
    [colors addObject:UIColorFromRGB(0xaed6fa)];//035
    [colors addObject:UIColorFromRGB(0x6f9eff)];//036
    [colors addObject:UIColorFromRGB(0x3671ff)];//037
    [colors addObject:UIColorFromRGB(0x2353fd)];//038
    [colors addObject:UIColorFromRGB(0x162cbd)];//039
    [colors addObject:UIColorFromRGB(0xa4e6ed)];//040
    [colors addObject:UIColorFromRGB(0x76fffc)];//041
    [colors addObject:UIColorFromRGB(0x51ffff)];//042
    [colors addObject:UIColorFromRGB(0x47dfff)];//043
    [colors addObject:UIColorFromRGB(0x1f6469)];//044
    [colors addObject:UIColorFromRGB(0xa3d9a0)];//045
    [colors addObject:UIColorFromRGB(0xa4d7d3)];//046
    [colors addObject:UIColorFromRGB(0x9aff82)];//047
    [colors addObject:UIColorFromRGB(0x59ffd0)];//048
    [colors addObject:UIColorFromRGB(0x47e6a6)];//预设效果_04 //049
    [colors addObject:UIColorFromRGB(0x206750)];//050
    [colors addObject:UIColorFromRGB(0xbce2bc)];//051
    [colors addObject:UIColorFromRGB(0xacf5bc)];//052
    [colors addObject:UIColorFromRGB(0x5cf19d)];//预设效果_04 //053
    [colors addObject:UIColorFromRGB(0x44e462)];//054
    [colors addObject:UIColorFromRGB(0x247930)];//055
    [colors addObject:UIColorFromRGB(0xecf3b6)];//056
    [colors addObject:UIColorFromRGB(0xf1ff6e)];//057
    [colors addObject:UIColorFromRGB(0xeaff33)];//058
    [colors addObject:UIColorFromRGB(0xbcff0b)];//059
    [colors addObject:UIColorFromRGB(0x5c7e04)];//060
    [colors addObject:UIColorFromRGB(0xccbfbc)];//061
    [colors addObject:UIColorFromRGB(0x8f746b)];//062
    [colors addObject:UIColorFromRGB(0x654338)];//063
    [colors addObject:UIColorFromRGB(0x4a302a)];//064
    [colors addObject:UIColorFromRGB(0x2f1c1b)];//065
    
    return colors;
}

+(NSString *)pathAssetVideoForURL:(NSURL *)aURL{
    return [NSString stringWithFormat:@"%@/cachedAsset_video-%lu.mp4",[self returnEditorVideoPath],(unsigned long)[[aURL description] hash]];
}

- (NSString *)returnEditorVideoPath{
    NSString *docmentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *editorvideoPath = [NSString stringWithFormat:@"%@/EDITORVIDEO",docmentsPath];
    return editorvideoPath;
}

+ (NSDictionary *) getVideoInformation:( NSURL * ) url
{
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:url];
    CGSize videoSize = [VEHelp getVideoSizeForTrack:urlAsset];
    AVAssetTrack *videoTrack = nil;
    
    NSArray *videoTracks = [urlAsset tracksWithMediaType:AVMediaTypeVideo];
    

    if ([videoTracks count] > 0)
        videoTrack = [videoTracks objectAtIndex:0];
    
    int width = videoSize.width;
    int height = videoSize.height;
    
    float frameRate = [videoTrack nominalFrameRate];
    float bitrate = [videoTrack estimatedDataRate];
    
    return @{
             @"width":@(width),
             @"height":@(height),
             @"fps":@(frameRate),
             @"bitrate":@(bitrate)};
    
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
    int width = size.width;
    int height = size.height;
    //保证宽高为2的倍数，防止导出画面出现其他颜色的边线
    if(width%2 != 0)
        width -= 1;
    if(height%2 != 0)
        height -= 1;
    
    return CGSizeMake(width, height);
}
+(MediaAsset *)canvasFile:(VEMediaInfo *) file
{
    MediaAsset * vvasset = [[MediaAsset alloc] init];

    vvasset.url = file.contentURL;
    if(file.fileType == kFILEVIDEO){
        vvasset.type = MediaAssetTypeVideo;
        vvasset.videoActualTimeRange = file.videoActualTimeRange;
        if(file.isReverse){
            vvasset.url = file.reverseVideoURL;
            if (CMTimeRangeEqual(kCMTimeRangeZero, file.reverseVideoTimeRange)) {
                vvasset.timeRange = CMTimeRangeMake(kCMTimeZero, file.reverseDurationTime);
            }else{
                vvasset.timeRange = file.reverseVideoTimeRange;
            }
            if(CMTimeCompare(vvasset.timeRange.duration, file.reverseVideoTrimTimeRange.duration) == 1 && CMTimeGetSeconds(file.reverseVideoTrimTimeRange.duration)>0){
                vvasset.timeRange = file.reverseVideoTrimTimeRange;
            }
            NSLog(@"timeRange : %f : %f ",CMTimeGetSeconds(vvasset.timeRange.start),CMTimeGetSeconds(vvasset.timeRange.duration));
        }
        else{
            if (CMTimeRangeEqual(kCMTimeRangeZero, file.videoTimeRange)) {
                vvasset.timeRange = CMTimeRangeMake(kCMTimeZero, file.videoDurationTime);
            }else{
                vvasset.timeRange = file.videoTimeRange;
            }
            if(CMTimeGetSeconds(file.videoTrimTimeRange.duration) > 0.0){
                vvasset.timeRange = file.videoTrimTimeRange;
            }
            NSLog(@"timeRange : %f : %f ",CMTimeGetSeconds(vvasset.timeRange.start),CMTimeGetSeconds(vvasset.timeRange.duration));
        }
        vvasset.speed        = file.speed;
//        vvasset.volume       = file.videoVolume;
        vvasset.audioFadeInDuration = file.audioFadeInDuration;
        vvasset.audioFadeOutDuration = file.audioFadeOutDuration;
        
        vvasset.videoFillType = VideoMediaFillTypeFit;
    }else{
        vvasset.type         = MediaAssetTypeImage;
        if (CMTimeCompare(file.imageTimeRange.duration, kCMTimeZero) == 1) {
            vvasset.timeRange = file.imageTimeRange;
            
            
        }else {
            vvasset.timeRange    = CMTimeRangeMake(kCMTimeZero, file.imageDurationTime);
        }
        NSLog(@"场景背景时长：%.2f s",CMTimeGetSeconds(vvasset.timeRange.duration));
        vvasset.speed        = file.speed;
#if isUseCustomLayer
        if (file.fileType == kFILETEXT) {
            file.imageTimeRange = vvasset.timeRange;
            vvasset.fillType = ImageMediaFillTypeFit;
        }
#endif
        vvasset.fillType = ImageMediaFillTypeFit;
    }
    vvasset.blurIntensity = file.backgroundBlurIntensity;
    vvasset.rotate = file.rotate;
    vvasset.isVerticalMirror = file.isVerticalMirror;
    vvasset.isHorizontalMirror = file.isHorizontalMirror;
    vvasset.adjustments = file.adjustments;
    vvasset.mask = file.mask;
    vvasset.crop = file.crop;
    vvasset.rectInVideo = file.rectInFile;
    vvasset.volume = 0;
    
    return vvasset;
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
#if 0
                uint8_t c;
                [data getBytes:&c length:1];
                if (c == 0x47) {
                    file.isGif = YES;
                }
#else
                size_t count = CGImageSourceGetCount(source);
                if (count > 1) {
                    file.isGif = YES;
                }
#endif
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
    if (isEnglish) {
        [params setObject:@"en" forKey:@"lang"];
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
    VEReachability *lexiu = [VEReachability reachabilityForInternetConnection];
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
    if([lexiu currentReachabilityStatus] != VEReachabilityStatus_NotReachable) {
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
                    if ([[[obj1[@"file"] pathExtension] lowercaseString] isEqualToString:@"acv"]){
                        filter.type = kFilterType_ACV;
                    }else if ([[[obj1[@"file"] pathExtension] lowercaseString] isEqualToString:@"zip"]) {
                        filter.type = kFilterType_Mosaic;
                    }else {
                        filter.type = kFilterType_LookUp;
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
                if ([[[obj1[@"file"] pathExtension] lowercaseString] isEqualToString:@"acv"]){
                    filter.type = kFilterType_ACV;
                }else if ([[[obj1[@"file"] pathExtension] lowercaseString] isEqualToString:@"zip"]) {
                    filter.type = kFilterType_Mosaic;
                }else {
                    filter.type = kFilterType_LookUp;
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

+ (NSString *)getlocalFileMusicPathWithDic:(NSString *)filename{
    NSString *scaleFolderPath = kLocalMusicFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:scaleFolderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:scaleFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
//    NSString *pathExtension = [[[filename pathExtension] componentsSeparatedByString:@"&ufid"] firstObject];
//    NSString *itemPath = [[scaleFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)[filename hash]]] stringByAppendingPathExtension:pathExtension];
    NSString *itemPath = [[scaleFolderPath stringByAppendingString:@"/"] stringByAppendingString:filename];
    return itemPath;
}

+ (NSString *)getScaleDownloadPathWithDic:(NSDictionary *)itemDic{
    NSString *scaleFolderPath = kScaleFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:scaleFolderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:scaleFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *pathExtension = [[[itemDic[@"file"] pathExtension] componentsSeparatedByString:@"&ufid"] firstObject];
    NSString *itemPath = [[scaleFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)[itemDic[@"file"] hash]]] stringByAppendingPathExtension:pathExtension];
    return itemPath;
}

+ (NSString *)getMaskDownloadPathWithDic:(NSDictionary *)itemDic {
    NSString *filterFolderPath = KChangeMaskFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:filterFolderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:filterFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *pathExtension = [[[itemDic[@"file"] pathExtension] componentsSeparatedByString:@"&ufid"] firstObject];
    NSString *itemPath = [[filterFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)[itemDic[@"file"] hash]]] stringByAppendingPathExtension:pathExtension];
    
    return itemPath;
}

+ (NSString *)getchangeHairDownloadPathWithDic:(NSDictionary *)itemDic {
    NSString *filterFolderPath = kHairFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:filterFolderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:filterFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *pathExtension = [[[itemDic[@"file"] pathExtension] componentsSeparatedByString:@"&ufid"] firstObject];
    NSString *itemPath = [[filterFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)[itemDic[@"file"] hash]]] stringByAppendingPathExtension:pathExtension];
    
    return itemPath;
}


+ (NSString *)getFilterDownloadPathWithDic:(NSDictionary *)itemDic {
    NSString *filterFolderPath = kFilterFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:filterFolderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:filterFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *file = itemDic[@"file"];
    NSString *pathExtension = [[[file pathExtension] componentsSeparatedByString:@"&ufid"] firstObject];
    NSString *itemPath = [[filterFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)[file hash]]] stringByAppendingPathExtension:pathExtension];
    if ([file.pathExtension isEqualToString:@"zip"]) {
        itemPath = [itemPath stringByDeletingPathExtension];
    }
    return itemPath;
}
+ (NSString *)getCollageDownloadPathWithDic:(NSDictionary *)itemDic {
    NSString *folderPath = kFlowCollageFolder;
    NSString *itemPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)[itemDic[@"file"] hash]]];
    if(![[NSFileManager defaultManager] fileExistsAtPath:itemPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:itemPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
//    NSString *pathExtension = [[[itemDic[@"file"] pathExtension] componentsSeparatedByString:@"&ufid"] firstObject];
//    NSString *itemPath = [[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)[itemDic[@"file"] hash]]] stringByAppendingPathExtension:pathExtension];
    
    return itemPath;
}

+ (NSString *)getMusicDownloadPathWithDic:(NSDictionary *)itemDic {
    NSString *folderPath = kFlowMusicFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *pathExtension = [[[itemDic[@"file"] pathExtension] componentsSeparatedByString:@"&ufid"] firstObject];
    NSString *itemPath = [[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)[itemDic[@"file"] hash]]] stringByAppendingPathExtension:pathExtension];
    
    return itemPath;
}

+ (NSString *)getMusicDownloadFolderWithDic:(NSDictionary *)itemDic{
    NSString *folderPath = kFlowMusicFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *pathExtension = [[[itemDic[@"file"] pathExtension] componentsSeparatedByString:@"&ufid"] firstObject];
    NSString *itemPath = [[[folderPath stringByAppendingString:@"/"] stringByAppendingString:itemDic[@"name"]] stringByAppendingPathExtension:pathExtension];
    
    return itemPath;
}

+ (NSString *)getCoverTemplateDownloadFolderWithDic:(NSDictionary *)itemDic{
    NSString *folderPath = kCoverTemplateFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *itemPath = [folderPath stringByAppendingPathComponent:itemDic[@"ufid"]];
    
    return itemPath;
}

+ (NSString *)getMediaIdentifier {
    NSDate *date_ = [NSDate date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd_HH-mm-ss-sss"];
    NSString *identifier = [dateformater stringFromDate:date_];
    return identifier;
}

+ (NSString *)geCaptionExSubtitleIdentifier{
    NSDate *date_ = [NSDate date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd_HH-mm-ss-sss"];
    NSString *identifier = [dateformater stringFromDate:date_];
    return [NSString stringWithFormat:@"subtitle_%@",identifier];
}

+ (NSMutableArray *)getMaskArray {
    NSMutableArray *maskArray = [NSMutableArray new];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"None",@"title",@(VEMaskType_NONE),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Linear",@"title",@(VEMaskType_LINNEAR),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Mirror",@"title",@(VEMaskType_MIRRORSURFACE),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Round",@"title",@(VEMaskType_ROUNDNESS),@"id", nil]];
#if 0
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Text",@"title",@(VEMaskType_LOVE),@"id", nil]];
#endif
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Rectangle",@"title",@(VEMaskType_RECTANGLE),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Quadrilateral",@"title",@(VEMaskType_QUADRILATERAL),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Star",@"title",@(VEMaskType_PENTACLE),@"id", nil]];
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Love",@"title",@(VEMaskType_LOVE),@"id", nil]];
#if 0
    [maskArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Shape",@"title",@(VEMaskType_LOVE),@"id", nil]];
#endif
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
    mask.maskName = maskName;
    
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

+ (VEMaskType)getMaskTypeWithPath:(NSString *)path {
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configPath]) {
        for (NSString *fileName in [[NSFileManager defaultManager] enumeratorAtPath:path].allObjects) {
            if ([fileName.pathExtension isEqualToString:@"json"]) {
                configPath = [path stringByAppendingPathComponent:fileName];
                break;
            }
        }
    }
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *configDic = [self objectForData:jsonData];
    jsonData = nil;
    
    NSString *name = configDic[@"name"];
    VEMaskType maskType = VEMaskType_NONE;
    if ([name isEqualToString:@"maskL"]) {
        maskType = VEMaskType_LINNEAR;
    }
    else if ([name isEqualToString:@"maskM"]) {
        maskType = VEMaskType_MIRRORSURFACE;
    }
    else if ([name isEqualToString:@"maskC"]) {
        maskType = VEMaskType_ROUNDNESS;
    }
    else if ([name isEqualToString:@"maskR"]) {
        maskType = VEMaskType_RECTANGLE;
    }
    else if ([name isEqualToString:@"maskQuadRangle"]) {
        maskType = VEMaskType_QUADRILATERAL;
    }
    else if ([name isEqualToString:@"maskS"]) {
        maskType = VEMaskType_PENTACLE;
    }
    else if ([name isEqualToString:@"maskH"]) {
        maskType = VEMaskType_LOVE;
    }
    else if ([name isEqualToString:@"maskText"]) {
        maskType = VEMaskType_TEXT;
    }
    else if (name.length > 0) {
        maskType = VEMaskType_SHAPE;
    }
    
    return maskType;
}

+ (MaskObject *)getMaskWithPath:(NSString *) path
{
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configPath]) {
        for (NSString *fileName in [[NSFileManager defaultManager] enumeratorAtPath:path].allObjects) {
            if ([fileName.pathExtension isEqualToString:@"json"]) {
                configPath = [path stringByAppendingPathComponent:fileName];
                path = configPath.stringByDeletingLastPathComponent;
                break;
            }
        }
    }
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *configDic = [self objectForData:jsonData];
    jsonData = nil;
    if (![configDic.allKeys containsObject:@"fragShader"]) {
        return [self getMaskShapeWithPath:path];
    }
    NSString *fragPath = [path stringByAppendingPathComponent:configDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:configDic[@"vertShader"]];
    NSError * error = nil;
    
    MaskObject *mask = [[MaskObject alloc] init];
    mask.folderPath = path;
    mask.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    mask.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    mask.name = configDic[@"name"];
    mask.maskName = mask.name;
    
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

+ (MaskObject *)getMaskShapeWithPath:(NSString *)path {
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:configPath]) {
        for (NSString *fileName in [[NSFileManager defaultManager] enumeratorAtPath:path].allObjects) {
            if ([fileName.pathExtension isEqualToString:@"json"]) {
                configPath = [path stringByAppendingPathComponent:fileName];
                path = configPath.stringByDeletingLastPathComponent;
                break;
            }
        }
    }
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *configDic = [self objectForData:jsonData];
    jsonData = nil;
    
    MaskObject *mask = [[MaskObject alloc] init];
    mask.folderPath = path;
    if ([configDic[@"name"] length] > 0) {
        mask.maskImagePath = [path stringByAppendingPathComponent:configDic[@"name"]];
    }
    mask.isRepeat = [configDic[@"repeat"] boolValue];
    
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
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
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
            if (currentFrameTexturePath && [[obj objectForKey:@"paramName"] isEqualToString:@"currentFrameTexture"]) {
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

+(CustomFilter *)copyCustomCaption:( CustomFilter * ) Animate atCpation:( Caption * ) caption
{
    NSString *folderPath = Animate.folderPath;
    CustomFilter *animate = [VEHelp getCustomFilterWithFolderPath:folderPath currentFrameImagePath:nil caption:caption];
    animate.timeRange = Animate.timeRange;
    if (Animate.animateType == CustomAnimationTypeCombined) {
        animate.cycleDuration = Animate.cycleDuration;
    }
    animate.networkCategoryId = Animate.networkCategoryId;
    animate.networkResourceId = Animate.networkResourceId;
    animate.animateType = Animate.animateType;
    return animate;
}

+(CustomFilter *)copyCustomCaptionEx:( CustomFilter * ) Animate atCpationItem:( CaptionItem * ) item
{
    NSString *folderPath = Animate.folderPath;
    CustomFilter *animate = [VEHelp getSubtitleAnimation:nil categoryId:nil atAnimationPath:folderPath  atCaptionItem:item];
    animate.timeRange = Animate.timeRange;
    animate.cycleDuration = Animate.cycleDuration;
    animate.networkCategoryId = Animate.networkCategoryId;
    animate.networkResourceId = Animate.networkResourceId;
    animate.animateType = Animate.animateType;
    
    return animate;
}

+(CustomFilter *)copyCustomMediaAsset:( CustomFilter * ) Animate atMedia:( MediaAsset * ) asset
{
    NSString *folderPath = Animate.folderPath;
    CustomFilter *animate = [VEHelp getCustomFilterWithFolderPath:folderPath currentFrameImagePath:nil  atMedia:asset];
    animate.timeRange = Animate.timeRange;
    animate.networkCategoryId = Animate.networkCategoryId;
    animate.networkResourceId = Animate.networkResourceId;
    animate.animateType = Animate.animateType;
    return animate;
}

#pragma mark- 单脚本json加载
+ (CustomFilter *)getCustomFilterWithFolderPath:(NSString *)folderPath currentFrameImagePath:(NSString *)currentFrameImagePath atMedia:(id) mediaOrFile{
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
        customFilter.scriptName = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
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
            if (currentFrameImagePath && [[obj objectForKey:@"paramName"] isEqualToString:@"currentFrameTexture"]
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
    if( mediaOrFile )
    {
        __block CustomFilter *animate;
        if( effectDic[@"other"] )
        {
            if( [effectDic[@"other"] isKindOfClass:[NSArray class]] )
            {
                NSArray *array = effectDic[@"other"];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    animate = [VEHelp getAnmationDic:(NSMutableDictionary*)obj atPath:folderPath];
                }];
            }
            else
            {
                animate = [VEHelp getAnmationDic:(NSMutableDictionary*)effectDic[@"other"] atPath:folderPath];
            }
        }
        if ([mediaOrFile isKindOfClass:[MediaAsset class]]) {
            MediaAsset *asset = (MediaAsset *)mediaOrFile;
            asset.customOtherAnimate = animate;
        }else if ([mediaOrFile isKindOfClass:[VEMediaInfo class]]) {
            VEMediaInfo *file = (VEMediaInfo *)mediaOrFile;
            file.customOtherAnimate = animate;
        }
    }
    effectDic = nil;
    return customFilter;
}

+ (CustomFilter *)getCustomFilterWithFolderPath:(NSString *)folderPath currentFrameImagePath:(NSString *)currentFrameImagePath caption:(Caption *)caption
{
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
        customFilter.scriptName = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
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
            if (currentFrameImagePath && [[obj objectForKey:@"paramName"] isEqualToString:@"currentFrameTexture"]
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
    if( caption )
    {
        if( effectDic[@"other"] )
        {
            if( [effectDic[@"other"] isKindOfClass:[NSArray class]] )
            {
                caption.otherAnimates = [NSMutableArray new];
                NSArray *array = effectDic[@"other"];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [caption.otherAnimates addObject:[VEHelp getAnmationDic:(NSMutableDictionary*)obj atPath:folderPath]];
                }];
            }
            else
            {
                [caption.otherAnimates addObject:[VEHelp getAnmationDic:(NSMutableDictionary*)effectDic[@"other"] atPath:folderPath]];
            }
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

+ (UIImage *)getFullImageWithUrl:(NSURL *)url {
    if([self isSystemPhotoUrl:url]){//
        UIImage * image = [VEHelp getSystemPhotoImage:url];
        return image;
    }else{
        if([self isImageUrl:url]){
            UIImage * image = [self imageWithContentOfPathFull:url.path];
            return image;
        }else{
            return [self assetGetThumImage:0.0 url:url urlAsset:nil];
        }
    }
}

+ (UIImage *)getFullScreenImageWithUrl:(NSURL *)url {
    if([self isSystemPhotoUrl:url]){//
        __block UIImage *image;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;//解决草稿箱获取不到缩略图的问题
        PHFetchResult *phAsset = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
        if (phAsset.count > 0) {
            [[PHImageManager defaultManager] requestImageForAsset:[phAsset firstObject] targetSize:CGSizeMake(IMAGE_MAX_SIZE_WIDTH, IMAGE_MAX_SIZE_HEIGHT) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                image = result;
                result = nil;
                info = nil;
            }];
        }        
        options = nil;
        phAsset = nil;
        return image;
    }else{
        if([self isImageUrl:url]){
            UIImage * image = [self imageWithContentOfPath:url.path];
            if (MIN(image.size.width, image.size.height) > IMAGE_MAX_SIZE_WIDTH) {
                float scale;
                if (image.size.width >= image.size.height) {
                    scale = IMAGE_MAX_SIZE_WIDTH / image.size.width;
                }else {
                    scale = IMAGE_MAX_SIZE_WIDTH / image.size.height;
                }
                image = [self scaleImage:image toScale:(scale*(480.0/1080.0))];
            }
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
        if (MIN(image.size.width, image.size.height) > IMAGE_MAX_SIZE_WIDTH) {
            float scale;
            if (image.size.width >= image.size.height) {
                scale = IMAGE_MAX_SIZE_WIDTH / image.size.width;
            }else {
                scale = IMAGE_MAX_SIZE_WIDTH / image.size.height;
            }
            image = [self scaleImage:image toScale:(scale*(480.0/1080.0))];
        }
        image = [self fixOrientation:image];
        return image;
    }
}

+ (UIImage *)imageWithContentOfPathFull:(NSString *)path{
    @autoreleasepool {
        NSData *image_data = [NSData dataWithContentsOfFile:path];
        UIImage *image = [UIImage imageWithData:image_data];
        image_data = nil;
        image = [self fixOrientation:image];
        return image;
    }
}

+ (UIImage *)imageWithWebP:(NSString *)filePath error:(NSError **)error
{
    // If passed `filepath` is invalid, return nil to caller and log error in console
   
    NSError *dataError = nil;
    NSData *imgData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&dataError];
    if (dataError != nil) {
        if (error) {
            *error = dataError;
        }        
        return nil;
    }
    return [UIImage sd_imageWithData:imgData];
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
        if(rotate == -90 || rotate == -270 || rotate == 90 || rotate == 270){
            newSize  = CGSizeMake(MAX(size.width, size.height), MIN(size.width, size.height));
        }
    }else{
        if(rotate == -90 || rotate == -270 || rotate == 90 || rotate == 270){
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

+ (CGSize)trackSize:(NSURL *)contentURL rotate:(float)rotate{
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
    
    CGSize newSize = size;
    
    BOOL isportrait = [self isVideoPortrait:asset];
    
    if(size.height == size.width){
        
        newSize        = size;
        
    }else if(isportrait){
        newSize = size;
        
        if(size.height < size.width){
            newSize  = CGSizeMake(size.height, size.width);
        }
        if(rotate == -90 || rotate == -270 || rotate == 90 || rotate == 270){
            newSize  = CGSizeMake(size.width, size.height);
        }
    }else{
        if(rotate == -90 || rotate == -270 || rotate == 90 || rotate == 270){
            newSize  = CGSizeMake(size.height, size.width);
        }
    }
    if (newSize.width > kVIDEOWIDTH || newSize.height > kVIDEOWIDTH) {
        if(newSize.width>newSize.height){
            CGSize tmpsize = newSize;
            newSize.width  = kVIDEOWIDTH;
            newSize.height = kVIDEOWIDTH * tmpsize.height/tmpsize.width;
        }else{
            CGSize tmpsize = newSize;
            newSize.height  = kVIDEOWIDTH;
            newSize.width = kVIDEOWIDTH * tmpsize.width/tmpsize.height;
        }
    }
    
    return newSize;
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

+(UIView *)initReversevideoProgressView:(  UIView * ) reverseView atLabelTag:(int *) labelTag atCancel:(SEL)cancel
{
    UIView * view = [[UIView alloc] initWithFrame:reverseView.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [reverseView addSubview:view];
    
//    UIView * reverseVideoView = [[UIView alloc] initWithFrame:CGRectMake( (view.frame.size.width-150.0)/2.0, (view.frame.size.height-150.0)/2.0, 150.0, 150.0)];
//    reverseVideoView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];;
//    reverseVideoView.layer.cornerRadius = 5.0;
//    reverseVideoView.layer.masksToBounds = YES;
//    [view addSubview:reverseVideoView];
    
//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( (reverseVideoView.frame.size.width - 100)/2.0, 10, 100, 100)];
//    [imageView sd_setImageWithURL:[NSURL fileURLWithPath:[[VEHelp getEditBundle] pathForResource:@"/New_EditVideo/animatSchedule_@3x" ofType:@"png"]]];
//    [reverseVideoView addSubview:imageView];
//
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0 , imageView.frame.size.height + imageView.frame.origin.y, reverseVideoView.frame.size.width, 20)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:12];
//    label.textColor = [UIColor whiteColor];
//    label.tag = 30121;
//    *labelTag = 30121;
//    [reverseVideoView addSubview:label];

    return view ;
}

+(UIView *)initAgainTrackView:(  UIViewController * ) viewController atTitle:( NSString * ) title atConfirm:(SEL) confirm atCancel:(SEL) cancel
{
    UIView * view = [[UIView alloc] initWithFrame:viewController.view.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    [viewController.view addSubview:view];
    
    UIView * reverseVideoView = [[UIView alloc] initWithFrame:CGRectMake( (view.frame.size.width-290)/2.0, (view.frame.size.height-200)/2.0, 290, 190)];
    reverseVideoView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    reverseVideoView.layer.cornerRadius = 5.0;
    reverseVideoView.layer.masksToBounds = YES;
    [view addSubview:reverseVideoView];
    
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, reverseVideoView.frame.size.width - 40, 60)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = title;
        //下面两行设置UILabel多行显示
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.numberOfLines = 0;
        //设置大小自适应
        [label sizeToFit];
        [reverseVideoView addSubview:label];
    }
    
    {
        UIButton * confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30 + 60 + 0, reverseVideoView.frame.size.width - 40, 40)];
        confirmBtn.backgroundColor = Main_Color;
        confirmBtn.layer.cornerRadius = 5.0;
        confirmBtn.layer.masksToBounds = true;
        [confirmBtn setTitle:VELocalizedString(@"确认", nil) forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [confirmBtn addTarget:viewController action:confirm forControlEvents:UIControlEventTouchUpInside];
        [reverseVideoView addSubview:confirmBtn];
    }
    
    {
        UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 30 + 60 + 10 + 30 + 10, reverseVideoView.frame.size.width - 40, 40)];
        cancelBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        cancelBtn.layer.cornerRadius = 5.0;
        cancelBtn.layer.masksToBounds = true;
        [cancelBtn setTitle:VELocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn addTarget:viewController action:cancel forControlEvents:UIControlEventTouchUpInside];
        [reverseVideoView addSubview:cancelBtn];
    }
    return view;
}

+ (NSString *) getResourceFromBundle : (NSString *) bundleName resourceName:(NSString *)name Type : (NSString *) type
{
    NSBundle *bundle = nil;
    bundle = [VEHelp getBundleName:bundleName];
    return [bundle pathForResource:name ofType:type];
}

+(UIView *)initReversevideoProgress:(  UIViewController * ) viewController atLabelTag:(int *) labelTag atCancel:(SEL)cancel
{
    UIView * view = [[UIView alloc] initWithFrame:viewController.view.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
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
    label.text = [NSString stringWithFormat:VELocalizedString(@"倒放中%0.1f%%", nil),0];
    label.textColor = [UIColor whiteColor];
    label.tag = 30121;
    *labelTag = 30121;
    [reverseVideoView addSubview:label];
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(reverseVideoView.frame.size.width - 30,  0, 30, 30)];
    btn.layer.cornerRadius = btn.frame.size.width/2.0;
    btn.layer.masksToBounds = YES;
//    btn.backgroundColor = [UIColor  colorWithWhite:0.6 alpha:1.0];
    [btn setImage:[VEHelp imageNamed:@"jianji/music/剪辑-剪辑-音乐_关闭默认_"] forState:UIControlStateNormal];
    if( cancel )
        [btn addTarget:viewController action:cancel forControlEvents:UIControlEventTouchUpInside];
    [reverseVideoView addSubview:btn];
    if( cancel == nil )
    {
        btn.hidden = YES;
    }
    return view ;
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
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    NSDate *date_ = [NSDate date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd_HH-mm-ss-SSS"];
    return [dateformater stringFromDate:date_];
}
+ (NSString *)getNowTimeToString{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
//    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    NSDate *date_ = [NSDate date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateformater stringFromDate:date_];
}

+ (NSURL *)getUrlWithFolderPath:(NSString *)folderPath fileName:(NSString *)fileName {
    if(![[NSFileManager defaultManager] fileExistsAtPath:folderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath;
    BOOL isExists = NO;
    filePath = [[folderPath stringByAppendingPathComponent:fileName.stringByDeletingPathExtension] stringByAppendingPathExtension:fileName.pathExtension];
    return [NSURL fileURLWithPath:filePath];
}

+ (NSURL *)getFileUrlWithFolderPath:(NSString *)folderPath fileName:(NSString *)fileName {
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
    return [NSURL fileURLWithPath:filePath];
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
    
    return  [VEHelp getFileUrlWithFolderPath:folder fileName:[NSString stringWithFormat:@"%@.png",[self getFileNameForNowTime]]].path;
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
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
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
    __block NSInteger index = -1;
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

+ (NSInteger)getSubtitlePresetTypeIndexWithTextColor:(UIColor *)textColor
                                         strokeColor:(UIColor *)strokeColor
                                             bgColor:(UIColor *)bgColor
{
    NSInteger presetTypeIndex = 0;
    if (textColor) {
        UIColor *presetTextColor = [UIColor clearColor];
        UIColor *presetStrokeColor = [UIColor clearColor];
        UIColor *presetBGColor = [UIColor clearColor];
        if (bgColor && (!strokeColor || CGColorEqualToColor(strokeColor.CGColor, [UIColor clearColor].CGColor))) {
            for (int i = 9; i < 14; i++) {
                [self getPresetTypeIndex:i
                         presetTextColor:&presetTextColor
                       presetStrokeColor:&presetStrokeColor
                           presetBgColor:&presetBGColor];
                
                if ([self colorIsEqual:bgColor color2:presetBGColor]) {
                    if ([self colorIsEqual:textColor color2:presetTextColor]) {
                        presetTypeIndex = i;
                        break;
                    }
                }
            }
        }else if (strokeColor && (!bgColor || CGColorEqualToColor(bgColor.CGColor, [UIColor clearColor].CGColor))) {
            for (int i = 1; i < 19; i++) {
                if (i >= 9 && i <= 13) {
                    continue;
                }
                [self getPresetTypeIndex:i
                         presetTextColor:&presetTextColor
                       presetStrokeColor:&presetStrokeColor
                           presetBgColor:&presetBGColor];
                
                if ([self colorIsEqual:strokeColor color2:presetStrokeColor]) {
                    if ([self colorIsEqual:textColor color2:presetTextColor]) {
                        presetTypeIndex = i;
                        break;
                    }
                }
            }
        }
    }
    
    return presetTypeIndex;
}

+ (void)getPresetTypeIndex:(NSInteger )index
           presetTextColor:(UIColor **)presetTextColor
         presetStrokeColor:(UIColor **)presetStrokeColor
             presetBgColor:(UIColor **)presetBgColor
{
    UIColor *sutbtitleColor;
    UIColor *strokeColor;
    UIColor *bgColor;
    switch (index) {
        case 1:
        {
            sutbtitleColor = UIColorFromRGB(0xffffff);
            strokeColor =  UIColorFromRGB(0x000000);
        }
            break;
        case 2:
        {
            sutbtitleColor =  UIColorFromRGB(0x000000);
            strokeColor =  UIColorFromRGB(0xffffff);
        }
            break;
        case 3:
        {
            sutbtitleColor =  UIColorFromRGB(0xf8dd4a);
            strokeColor =  UIColorFromRGB(0x000000);
        }
            break;
        case 4:
        {
            sutbtitleColor =  UIColorFromRGB(0xffffff);
            strokeColor =  UIColorFromRGB(0xed7667);
        }
            break;
        case 5:
        {
            sutbtitleColor =  UIColorFromRGB(0xc1dcf8);
            strokeColor =  UIColorFromRGB(0x000000);
        }
            break;
        case 6:
        {
            sutbtitleColor =  UIColorFromRGB(0xac5125);
            strokeColor =  UIColorFromRGB(0xffffff);
        }
            break;
        case 7:
        {
            sutbtitleColor =  UIColorFromRGB(0xefe1ac);
            strokeColor =  UIColorFromRGB(0x4a4238);
        }
            break;
        case 8:
        {
            sutbtitleColor =  UIColorFromRGB(0xecc5bc);
            strokeColor =  UIColorFromRGB(0x510b06);
        }
            break;
        case 9:
        {
            sutbtitleColor =  UIColorFromRGB(0xffffff);
            bgColor =  UIColorFromRGB(0x000000);
        }
            break;
        case 10:
        {
            sutbtitleColor =  UIColorFromRGB(0x000000);
            bgColor =  UIColorFromRGB(0xffffff);
        }
            break;
        case 11:
        {
            sutbtitleColor =  UIColorFromRGB(0x000000);
            bgColor =  UIColorFromRGB(0xffde00);
        }
            break;
        case 12:
        {
            sutbtitleColor =  UIColorFromRGB(0xffffff);
            bgColor =  UIColorFromRGB(0xa74f59);
        }
            break;
        case 13:
        {
            sutbtitleColor =  UIColorFromRGB(0x69f0ae);
            bgColor =  UIColorFromRGB(0x000000);
        }
            break;
        case 14:
        {
            sutbtitleColor =  UIColorFromRGB(0xffd9e8);
            strokeColor =  UIColorFromRGB(0xff619d);
        }
            break;
        case 15:
        {
            sutbtitleColor =  UIColorFromRGB(0xc0f1f5);
            strokeColor =  UIColorFromRGB(0x037cff);
        }
            break;
        case 16:
        {
            sutbtitleColor =  UIColorFromRGB(0xc3cf47);
            strokeColor =  UIColorFromRGB(0x3c5c37);
        }
            break;
        case 17:
        {
            sutbtitleColor =  UIColorFromRGB(0x90c2cd);
            strokeColor =  UIColorFromRGB(0x465773);
        }
            break;
        case 18:
        {
            sutbtitleColor =  UIColorFromRGB(0xfffff0);
            strokeColor =  UIColorFromRGB(0xff1837);
        }
            break;
        default:
            break;
    }
    if (sutbtitleColor && *presetTextColor) {
        *presetTextColor = sutbtitleColor;
    }
    if (strokeColor && *presetStrokeColor) {
        *presetStrokeColor = strokeColor;
    }
    if (bgColor && *presetBgColor) {
        *presetBgColor = bgColor;
    }
}

+ (BOOL)colorIsEqual:(UIColor *)color1 color2:(UIColor *)color2 {
    BOOL isEqual = NO;
    if (color1 && color2) {
        float r=0,g=0,b=0;
        const CGFloat *components = CGColorGetComponents(color1.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        
        float r1=0,g1=0,b1=0;
        const CGFloat *pComponents = CGColorGetComponents(color2.CGColor);
        r1 = pComponents[0];
        g1 = pComponents[1];
        b1 = pComponents[2];
        if (r == r1 && g == g1 && b == b1) {
            isEqual = YES;
        }
    }
    return isEqual;
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
    if(!uploadUrl){
        return nil;
    }
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
        if ([params[@"type"] isEqualToString:@"stickers"]) {
            [params setValue:[NSNumber numberWithInt:[VEConfigManager sharedManager].editConfiguration.stickerResourceMinVersion] forKey:@"ver_min"];//用于控制最小版本号,只对素材生效
        }
        if (isEnglish) {
            [params setObject:@"en" forKey:@"lang"];
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
    if(![[params allKeys] containsObject:@"ver"])
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
+ (BOOL)OpenZip:(NSString*)zipPath  unzipto:(NSString*)_unzipto
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
        if (ret) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:_unzipto error:nil];
            [fileArray enumerateObjectsUsingBlock:^(NSString * _Nonnull fileName, NSUInteger idx, BOOL * _Nonnull stop) {
                if([fileName containsString:@"__MACOSX"]) {
                    [fileManager removeItemAtPath:[_unzipto stringByAppendingPathComponent:fileName] error:nil];
                }
            }];
        }
        return YES;
    }
    return NO;
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
//            if( fileArray == nil )
//            {
//                NSString *path1 = [_unzipto stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/file",fileName.lastPathComponent]];
//                NSFileManager *manager = [[NSFileManager alloc] init];
//                [manager moveItemAtPath:path toPath:path1 error:nil];
//                fileArray = [fileManager contentsOfDirectoryAtPath:path1 error:nil];
//            }
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

+(NSDictionary *)getConfig_Dic:( NSString * ) configPath
{
    NSString *path = configPath;
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
            ppCaption.imageFolderPath = configPath;
            
            // [[NSBundle mainBundle].bundlePath  stringByAppendingString:@"/"];
            ppCaption.type = (CaptionType)[[subtitleEffectConfig objectForKey:@"type"] integerValue];
            ppCaption.angle = 0;
            ppCaption.position= CGPointMake(x, y);
            ppCaption.size = CGSizeMake(w, h);
            ppCaption.duration = [subtitleEffectConfig[@"duration"] floatValue];
            if( ppCaption.duration == 0 )
            {
                ppCaption.duration = 1.0;
            }
            ppCaption.imageName = subtitleEffectConfig[@"name"];
            
//            ppCaption.tFontSize = 10;
            
            ppCaption.scale = 1;
            ppCaption.angle = 0;
//            if([subtitleEffectConfig[@"music"] isKindOfClass:[NSMutableDictionary class]]){
//                ppCaption.music.name = subtitleEffectConfig[@"music"][@"src"];
//            }else{
//                ppCaption.music.name = nil;
//            }
            if(ppCaption.type == CaptionTypeHasText){
                if( captionType == 2 ){
//                    [self.stickerScrollview setContentTextFieldText:subtitleEffectConfig[@"textContent"]];
                }else{
//                    if( ![self.subtitleView isFieldChanged] ){
//                        ppCaption.pText = VELocalizedString(@"", nil);
////                        [self.subtitleView setContentTextFieldText:ppCaption.pText];
//                    }else{
                        ppCaption.pText = VELocalizedString(@"点击输入文字", nil);
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
            if( (ppCaption.frameArray == nil) || ( ppCaption.frameArray.count == 0 ) )
            {
                ppCaption.captionImagePath = [configPath stringByAppendingString:[NSString stringWithFormat:@"/%@.png",ppCaption.imageName]];
            }
            
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
    if(![[params allKeys] containsObject:@"ver"])
        [params setObject:[NSNumber numberWithInt:[VECore getSDKVersion]] forKey:@"ver"];
    return [self updateInfomation:params andUploadUrl:urlPath];
}

+(void)downloadFonts:(void(^)(NSError *error))callBack
{
    VEEditConfiguration *editConfig =  [VEConfigManager sharedManager].peEditConfiguration;
    BOOL hasNewFont =  editConfig.fontResourceURL.length>0;
    NSString *uploadUrl = (hasNewFont ? editConfig.fontResourceURL : getFontTypeUrl);
    NSMutableDictionary *fontListDic;
    if(hasNewFont){
        
        if( [VEConfigManager sharedManager].isNewFont )
            fontListDic = [VEHelp getNetworkMaterialWithType:kPESDKFontType
                                                             appkey:[VEConfigManager sharedManager].appKey
                                                      urlPath:uploadUrl];
        else
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
            if ([updateTime isKindOfClass:[NSNumber class]]) {
                updateTime = [obj1[@"updatetime"] stringValue];
            }
            [oldList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                if ([obj2[@"id"] intValue] == [obj1[@"id"] intValue]) {
                    if( [obj2[@"updatetime"] isKindOfClass:[NSString class]] )
                    {
                        if (![obj2[@"updatetime"] isEqualToString:updateTime]) {
                            NSString *file = [[obj2[@"file"] stringByDeletingLastPathComponent] lastPathComponent];
                            NSString *path = [folderPath stringByAppendingPathComponent:file];
                            if ([fileManager fileExistsAtPath:path]) {
                                [fileManager removeItemAtPath:path error:nil];
                            }
                        }
                    }
                    else  if (!([obj2[@"updatetime"] longLongValue] == [updateTime longLongValue])) {
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

+ (void)getCurrentImage:(BOOL)screenshot callBack:(void (^)(UIImage *))imageBlock {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        NSLog(@"相册权限未开放");
        return;
    }
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestImageForAsset:[assetsFetchResults firstObject] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage *resultImage, NSDictionary *info)
     {
        UIImage *image = resultImage;
        if( imageBlock )
        {
            imageBlock(image);
        }
    }];
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

//压缩图片至指定尺寸
+ (UIImage *)rescaleImage:(UIImage *)image size:(CGSize)size
{
    if (size.width <= 0 || size.height <= 0) {
        return nil;
    }
    CGRect rect = (CGRect){CGPointZero, size};
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
    
    [image drawInRect:rect];
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

//压缩图片至指定尺寸
+ (UIImage *)rescaleImageArray:(NSMutableArray *)imageArray size:(CGSize)size
{
    @autoreleasepool {
        CGRect rect = (CGRect){CGPointZero, size};

        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1.0);
        
        [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage * image = (UIImage*)obj;
            [image drawInRect:rect];
        }];
        
        UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return resImage;
    };
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    CIImage *originalImage = [[CIImage imageWithCGImage:img.CGImage] imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, size.width/img.size.width, size.height/img.size.height)];
    UIImage * image =  [UIImage imageWithCIImage:originalImage];
    return image;
}

+ (UIImage *)drawImage:(UIImage *)image bgImage:(UIImage *)bgImage
{
    @autoreleasepool {
        UIGraphicsBeginImageContext(CGSizeMake(((int)bgImage.size.width), ((int)bgImage.size.height)));
        [bgImage drawInRect:CGRectMake(0, 0, ((int)bgImage.size.width), ((int)bgImage.size.height))];
        [image drawInRect:CGRectMake((bgImage.size.width - image.size.width)/2.0, (bgImage.size.height - image.size.height)/2.0, ((int)image.size.width), ((int)image.size.height))];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
}

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
#if 1   //20220105 使用保存到沙盒后再使用的方法iPhone6s（iOS13.7）会崩溃
    @autoreleasepool {
        UIGraphicsBeginImageContext(CGSizeMake(((int)(image.size.width * scaleSize))/2*2.0, ((int)(image.size.height * scaleSize))/2*2.0));
        [image drawInRect:CGRectMake(0, 0, ((int)(image.size.width * scaleSize))/2*2.0, ((int)(image.size.height * scaleSize))/2*2.0)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
#else
    UIGraphicsBeginImageContext(CGSizeMake(((int)(image.size.width * scaleSize))/2*2.0, ((int)(image.size.height * scaleSize))/2*2.0));
    [image drawInRect:CGRectMake(0, 0, ((int)(image.size.width * scaleSize))/2*2.0, ((int)(image.size.height * scaleSize))/2*2.0)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //20210323 多次调用drawInRect:会有内存泄露，保存到沙盒后再使用没有内存泄露
    NSString *imagePath = [NSTemporaryDirectory() stringByAppendingString:@"veTempScaleImage.png"];
    unlink([imagePath UTF8String]);
    NSData *data = UIImagePNGRepresentation(scaledImage);
    [data writeToFile:imagePath atomically:YES];
    data = nil;
    UIImage *ratioImage = [UIImage imageWithContentsOfFile:imagePath];
    return ratioImage;
#endif
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
//        float duration = 0;
        if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] > 0) {
            AVAssetTrack* clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
            frameRate = clipVideoTrack.nominalFrameRate;
            if (CMTimeCompare(time, clipVideoTrack.timeRange.duration) == 1) {
                time = clipVideoTrack.timeRange.duration;
            }
//            duration = CMTimeGetSeconds(clipVideoTrack.timeRange.duration);
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

+ (BOOL)isSystemPhotoPath:(NSString *)path {
    BOOL isSystemUrl = YES;
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

#pragma mark- 美颜设置
+ (void)setMediaBeauty:(MediaAsset *)asset beautyType:(KBeautyType)type faceRect:(CGRect)faceRect beautyValue:(float) value
{
    if( !asset.multipleFaceAttribute )
    {
        asset.multipleFaceAttribute = [NSMutableArray array];
    }
    
    __block FaceAttribute *faceAttribute = nil;
    
    if( asset.type == MediaAssetTypeVideo )
    {
        if( asset.multipleFaceAttribute.count > 0 )
        {
            faceAttribute = asset.multipleFaceAttribute[0];
        }
    }
    else
    {
        [asset.multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (CGRectEqualToRect(faceRect, obj.faceRect) ||  CGRectContainsPoint(faceRect, CGPointMake(obj.faceRect.origin.x+obj.faceRect.size.width/2.0, obj.faceRect.origin.y+obj.faceRect.size.height/2.0)) ) {
                faceAttribute = obj;
                *stop = YES;
            }
        }];
    }
    
    if( !faceAttribute )
    {
        faceAttribute = [FaceAttribute new];
        faceAttribute.faceRect = faceRect;
        [asset.multipleFaceAttribute addObject:faceAttribute];
    }
    
    if( faceAttribute == nil )
        return;
    
    switch (type) {
        case KBeauty_FaceWidth://MARK: 脸的宽度
        {
            faceAttribute.faceWidth = value;
        }
            break;
        case KBeauty_Forehead://MARK: 额头高度
        {
            faceAttribute.forehead = value;
        }
            break;
        case KBeauty_ChinWidth://MARK: 下颚的宽度
        {
            faceAttribute.chinWidth = value;
        }
            break;
        case KBeauty_ChinHeight://MARK: 下巴的高度
        {
            faceAttribute.chinHeight = value;
        }
            break;
        case KBeauty_EyeSize://MARK: 眼睛大小
        {
            faceAttribute.eyeWidth = value;
            faceAttribute.eyeHeight = value;
        }
            break;
        case KBeauty_EyeWidth://MARK: 眼睛宽度
        {
            faceAttribute.eyeWidth = value;
        }
            break;
        case KBeauty_EyeHeight://MARK: 眼睛高度
        {
            faceAttribute.eyeHeight = value;
        }
            break;
        case KBeauty_EyeSlant://MARK: 眼睛倾斜
        {
            faceAttribute.eyeSlant = value;
        }
            break;
        case KBeauty_EyeDistance://MARK: 眼睛距离
        {
            faceAttribute.eyeDistance = value;
        }
            break;
        case KBeauty_NoseSize://MARK: 鼻子大小
        {
            faceAttribute.noseWidth = value;
            faceAttribute.noseHeight = value;
        }
            break;
        case KBeauty_NoseWidth://MARK: 鼻子宽度
        {
            faceAttribute.noseWidth = value;
        }
            break;
        case KBeauty_NoseHeight://MARK: 鼻子高度
        {
            faceAttribute.noseHeight = value;
        }
            break;
        case KBeauty_MouthWidth://MARK: 嘴巴宽度
        {
            faceAttribute.mouthWidth = value;
        }
            break;
        case KBeauty_LipUpper://MARK: 上嘴唇
        {
            faceAttribute.lipUpper = value;
        }
            break;
        case KBeauty_LipLower://MARK: 下嘴唇
        {
            faceAttribute.lipLower = value;
        }
            break;
        case KBeauty_Smile://MARK: 微笑
        {
            faceAttribute.smile = value;
        }
            break;
        case KBeauty_BlurIntensity://MARK: 磨皮
        {
            asset.beautyBlurIntensity = value;
        }
            break;
        case KBeauty_ToneIntensity://MARK: 红润
        {
            asset.beautyToneIntensity = value;
        }
            break;
        case KBeauty_BrightIntensity://MARK: 美白
        {
            asset.beautyBrightIntensity = value;
        }
            break;
        case KBeauty_BigEyes://MARK: 大眼
        {
            faceAttribute.beautyBigEyeIntensity = value;
//            asset.beautyBigEyeIntensity = value;
        }
            break;
        case KBeauty_FaceLift://MARK: 瘦脸
        {
            faceAttribute.beautyThinFaceIntensity = value;
//            asset.beautyThinFaceIntensity = value;
        }
            break;
        case KBeauty_beauty://MARK: 一键美颜
        {
            asset.beautyBlurIntensity = value;
            asset.beautyToneIntensity = value;
            asset.beautyBrightIntensity = value;
            faceAttribute.beautyBigEyeIntensity = value;
            faceAttribute.beautyThinFaceIntensity = value;
        }
            break;
        default:
            break;
    }
}
#pragma mark - 转场
+ (NSMutableArray *)getTransitionArray {
    NSMutableArray *transitionList = [NSMutableArray arrayWithContentsOfFile:kTransitionPlistPath];
    return transitionList;
}

+ (NSString *)getTransitionIconPath:(NSString *)typeName itemName:(NSString *)itemName {
    NSString *iconPath = [[[kLocalTransitionFolder stringByAppendingPathComponent:typeName] stringByAppendingPathComponent:@"Icon"] stringByAppendingPathComponent:itemName];
    return [iconPath stringByAppendingPathExtension:@"jpg"];
}

+ (NSString *)getTransitionPath:(NSString *)typeName itemName:(NSString *)itemName {
    NSString *path = [[[[kLocalTransitionFolder stringByAppendingPathComponent:typeName] stringByAppendingPathComponent:@"Json"] stringByAppendingPathComponent:itemName] stringByAppendingPathComponent:@"config.json"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        path = nil;
    }
    if (!path && ![typeName isEqualToString:kDefaultTransitionTypeName]) {
        path = [[[[kLocalTransitionFolder stringByAppendingPathComponent:typeName] stringByAppendingPathComponent:@"Icon"] stringByAppendingPathComponent:itemName] stringByAppendingPathExtension:@"jpg"];
    }
    return path;
}

+ (void)setTransition_Network:(Transition *)transition file:(VEMediaInfo *)file
{
    if( file.transitionIndex < 0 || file.transitionDuration == 0) {
        return;
    }
    
    NSMutableArray *transitionList = [VEHelp getTransitionArray];
    if( transitionList && (transitionList.count > 0) )
    {
        if(transitionList.count < file.transitionTypeIndex)
        {
            return;
        }
        if(file.transitionTypeIndex <=0)
        {
            transition.type = TransitionTypeNone;
            file.transitionMask = nil;
            file.transition.type = TransitionTypeNone;
            [VEHelp setTransition:transition file:file atConfigPath:nil];
            
            file.transitionNetworkCategoryId = transition.networkCategoryId = @"";
            file.transitionNetworkResourceId = transition.networkResourceId = @"";
            return;
        }
        if( ((NSMutableArray*)[transitionList[file.transitionTypeIndex - 1] objectForKey:@"data"]).count <= file.transitionIndex )
        {
            return;
        }
        
        NSDictionary *obj = [[transitionList[file.transitionTypeIndex - 1] objectForKey:@"data"] objectAtIndex:file.transitionIndex];
        NSString *configPath = [VEHelp getTransitionConfigPath:obj];
        
        if( configPath == nil )
            return;
        
        NSFileManager *manager = [[NSFileManager alloc] init];
        if(![manager fileExistsAtPath:configPath] && [manager fileExistsAtPath:file.transition.maskURL.path]){
            configPath = file.transition.maskURL.path;
        }
        if ([manager fileExistsAtPath:configPath]) {
            NSString *maskpath = configPath;
            NSURL *maskUrl = maskpath.length == 0 ? nil : [NSURL fileURLWithPath:maskpath];
            file.transitionMask = maskUrl;
            
            [VEHelp setTransition:transition file:file atConfigPath:configPath];
            
            file.transitionNetworkCategoryId = transition.networkCategoryId = [transitionList[file.transitionTypeIndex - 1] objectForKey:@"id"];
            file.transitionNetworkResourceId = transition.networkResourceId = obj[@"id"];
            
        }else if (file.transition && file.transition.type != TransitionTypeNone) {
            transition.type = file.transition.type;
            transition.duration = file.transitionDuration;
        }
    }
}

+ (void)setTransition:(Transition *)transition file:(VEMediaInfo *)file atConfigPath:(NSString *) configPath
{
    if ([file.transitionMask.pathExtension isEqualToString:@"jpg"] || [file.transitionMask.pathExtension isEqualToString:@"JPG"] ) {
        transition.type = TransitionTypeMask;
    }
    else if (file.transitionMask)
    {
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
        NSMutableDictionary *configDic = [VEHelp objectForData:jsonData];
        jsonData = nil;
        NSString *builtIn = configDic[@"builtIn"];
        if (builtIn.length > 0) {
            if ([builtIn isEqualToString:@"blinkblack"]) {//闪黑
                transition.type = TransitionTypeBlinkBlack;
            }
            else if ([builtIn isEqualToString:@"blinkwhite"]) {//闪白
                transition.type = TransitionTypeBlinkWhite;
            }
            else if ([builtIn isEqualToString:@"up"]) {//上移
                transition.type = TransitionTypeUp;
            }
            else if ([builtIn isEqualToString:@"down"]) {//下移
                transition.type = TransitionTypeDown;
            }
            else if ([builtIn isEqualToString:@"left"]) {//左移
                transition.type = TransitionTypeLeft;
            }
            else if ([builtIn isEqualToString:@"right"]) {//右移
                transition.type = TransitionTypeRight;
            }
            else if ([builtIn isEqualToString:@"overlap"]) {//交叠
                transition.type = TransitionTypeFade;
            }
        }else {
            transition.type = TransitionTypeCustom;
            transition.customTransition = [self getCustomTransitionWithJsonPath:configPath];
        }
    }
    else {
        transition.type = TransitionTypeNone;
    }
    transition.maskURL = file.transitionMask;
    transition.duration = file.transitionDuration;
}

+(NSString *)getCollageIdentifier:( NSInteger ) idx
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    return  [NSString stringWithFormat:@"collage_%@+%lu", [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]], idx];
}

+(NSString *)getCollageIdentifier
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    return  [NSString stringWithFormat:@"collage_%@", [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]]];
}

+(NSString *)getSuperposiIdentifier
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmssSSS";
    return  [NSString stringWithFormat:@"superposi_%@", [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]]];
}

+ (NSString *) getVideoUUID {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

+ (void)refreshVeCoreSDK:(VECore *)veCoreSDK
        withTemplateInfo:(VECoreTemplateInfo *)templateInfo
              folderPath:(NSString *)folderPath
                isExport:(BOOL)isExport
                coverUrl:(NSURL *)coverUrl
{
    [veCoreSDK setEditorVideoSize:CGSizeMake(templateInfo.size.width, templateInfo.size.height)];
    [self setVeCoreSDKSecens:veCoreSDK withTemplateInfo:templateInfo folderPath:folderPath];
    
    NSMutableArray *overlays = [NSMutableArray array];
    //MARK: 画中画
    if (templateInfo.overlays.count > 0) {
        [templateInfo.overlays enumerateObjectsUsingBlock:^(VECoreTemplateOverlay * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Overlay *overlay = [obj getOverlayWithFolderPath:folderPath];
            if (overlay) {
                if (!folderPath && ![VEHelp isSystemPhotoUrl:overlay.media.url]) {
                    overlay.media.url = [VEHelp getFileURLFromAbsolutePath:overlay.media.url.path];
                }
                if ([VEHelp isSystemPhotoUrl:overlay.media.url]) {
                    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                    option.synchronous = YES;
                    option.resizeMode = PHImageRequestOptionsResizeModeExact;
                    PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithALAssetURLs:@[overlay.media.url] options:nil];
                    if (result.count > 0) {
                        PHAsset* phAsset = [result objectAtIndex:0];
                        if ([[phAsset valueForKey:@"uniformTypeIdentifier"] isEqualToString:@"com.compuserve.gif"]) {
                            overlay.media.isGIF = YES;
                        }
                    }
                }else {
                    NSData *data = [NSData dataWithContentsOfURL:overlay.media.url];
                    if (data) {
                        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
                        size_t count = CGImageSourceGetCount(source);
                        if (count > 1) {
                            overlay.media.isGIF = YES;
                        }
                        if (source) {
                            CFRelease(source);
                        }
                        data = nil;
                    }
                }
                overlay.identifier = [NSString stringWithFormat:@"overlay%lu", (unsigned long)idx];
                overlay.media.fillType = ImageMediaFillTypeFit;
                if (templateInfo.ver < 4.0) {
                    overlay.media.adjustments.sharpness = (overlay.media.adjustments.sharpness + 4)/8.0;//old:-4~4 new:0~1
                    overlay.media.adjustments.highlight = (overlay.media.adjustments.highlight + 1)/2.0;//old:-1~1 new:0~1
                    [overlay.media.animate enumerateObjectsUsingBlock:^(MediaAssetAnimatePosition * _Nonnull obj1, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj1.adjustments = [overlay.media.adjustments copy];
                    }];
                }
                if (overlay.media.mask) {
                    if (!folderPath) {
                        overlay.media.mask.folderPath = [VEHelp getFileURLFromAbsolutePath_str:overlay.media.mask.folderPath];
                    }
#ifndef kNewMask
                    MaskObject *mask = [VEHelp getMaskWithName:overlay.media.mask.folderPath.lastPathComponent];
#else
                    MaskObject *mask = [VEHelp getMaskWithPath:overlay.media.mask.folderPath];
#endif
                    overlay.media.mask.name = mask.name;
                    overlay.media.mask.frag = mask.frag;
                    overlay.media.mask.vert = mask.vert;
                    overlay.media.mask.maskImagePath = mask.maskImagePath;
                }
                if (overlay.media.customAnimate) {
                    if (!folderPath) {
                        overlay.media.customAnimate.folderPath = [VEHelp getFileURLFromAbsolutePath_str:overlay.media.customAnimate.folderPath];
                    }
                    CustomFilter *animate = [VEHelp getCustomFilterWithFolderPath:overlay.media.customAnimate.folderPath currentFrameImagePath:nil atMedia:overlay.media];
                    animate.timeRange = overlay.media.customAnimate.timeRange;
                    animate.networkCategoryId = overlay.media.customAnimate.networkCategoryId;
                    animate.networkResourceId = overlay.media.customAnimate.networkResourceId;
                    animate.animateType = overlay.media.customAnimate.animateType;
                    
                    overlay.media.customAnimate = animate;
                }
                if (overlay.media.customOutAnimate) {
                    if (!folderPath) {
                        overlay.media.customOutAnimate.folderPath = [VEHelp getFileURLFromAbsolutePath_str:overlay.media.customOutAnimate.folderPath];
                    }
                    CustomFilter *animate = [VEHelp getCustomFilterWithFolderPath:overlay.media.customOutAnimate.folderPath currentFrameImagePath:nil atMedia:overlay.media];
                    animate.timeRange = overlay.media.customOutAnimate.timeRange;
                    animate.networkCategoryId = overlay.media.customOutAnimate.networkCategoryId;
                    animate.networkResourceId = overlay.media.customOutAnimate.networkResourceId;
                    animate.animateType = overlay.media.customOutAnimate.animateType;
                    
                    overlay.media.customOutAnimate = animate;
                }
                if (overlay.media.customMultipleFilterArray.count > 0) {
                    NSMutableArray *customMultipleFilterArray = [NSMutableArray array];
                    [overlay.media.customMultipleFilterArray enumerateObjectsUsingBlock:^(CustomMultipleFilter * _Nonnull multipleFilter, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (!folderPath) {
                            multipleFilter.folderPath = [VEHelp getFileURLFromAbsolutePath_str:multipleFilter.folderPath];
                        }
                        CustomMultipleFilter *filter = [VEHelp getCustomMultipleFilerWithFolderPath:multipleFilter.folderPath currentFrameImagePath:nil];
                        filter.timeRange = multipleFilter.timeRange;
                        filter.networkCategoryId = multipleFilter.networkCategoryId;
                        filter.networkResourceId = multipleFilter.networkResourceId;
                        filter.overlayType = CustomFilterOverlayTypePIP;
                        [customMultipleFilterArray addObject:filter];
                    }];
                    if (customMultipleFilterArray.count > 0) {
                        overlay.media.customMultipleFilterArray = customMultipleFilterArray;
                    }
                }
                [overlays addObject:overlay];
            }
        }];
    }
    //MARK: 封面
    if (templateInfo.coverPath.length > 0 || (coverUrl && [self isImageUrl:coverUrl])) {
        Overlay *coverOverlay = [[Overlay alloc] init];
        coverOverlay.type = OverlayTypeCover;
        coverOverlay.isRepeat = NO;
        coverOverlay.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(0.3, TIMESCALE));
        if (templateInfo.coverPath.length > 0) {
            if (folderPath.length > 0) {
                coverOverlay.media.url = [NSURL fileURLWithPath:[folderPath stringByAppendingPathComponent:templateInfo.coverPath]];
            }else if ([VEHelp isSystemPath:templateInfo.coverPath]) {
                coverOverlay.media.url = [NSURL URLWithString:templateInfo.coverPath];
            }else {
                coverOverlay.media.url = [NSURL fileURLWithPath:templateInfo.coverPath];
            }
            if (!folderPath && ![VEHelp isSystemPhotoUrl:coverOverlay.media.url]) {
                coverOverlay.media.url = [VEHelp getFileURLFromAbsolutePath:coverOverlay.media.url.path];
            }
        }else if (coverUrl) {
            if (folderPath.length > 0) {
                coverOverlay.media.url = [NSURL fileURLWithPath:[folderPath stringByAppendingPathComponent:coverUrl.absoluteString]];
            }else {
                coverOverlay.media.url = coverUrl;
            }
        }
        coverOverlay.media.type = MediaAssetTypeImage;
        coverOverlay.media.fillType = ImageMediaFillTypeFull;
        coverOverlay.media.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(KPICDURATION, TIMESCALE));
        [overlays addObject:coverOverlay];
    }
    //MARK: 涂鸦
    if (templateInfo.doodles.count > 0) {
        [templateInfo.doodles enumerateObjectsUsingBlock:^(VECoreTemplateOverlay * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Overlay *doodle = [obj getOverlayWithFolderPath:folderPath];
            if (doodle) {
                if (!folderPath && ![VEHelp isSystemPhotoUrl:doodle.media.url]) {
                    doodle.media.url = [VEHelp getFileURLFromAbsolutePath:doodle.media.url.path];
                }
                doodle.type = OverlayTypeDoodle;
                [overlays addObject:doodle];
            }
        }];
    }
    //MARK: 涂鸦笔
    if (templateInfo.doodlePens.count > 0) {
        NSMutableArray *doodlePens = [NSMutableArray array];
        [templateInfo.doodlePens enumerateObjectsUsingBlock:^(VECoreTemplateDoodleEx * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DoodleEx *doodleEx = [obj getDoodleExWithFolderPath:folderPath];
            if (doodleEx) {
                NSMutableArray *options = [NSMutableArray array];
                [doodleEx.optionArrays enumerateObjectsUsingBlock:^(DoodleOption * _Nonnull option, NSUInteger idx, BOOL * _Nonnull stop) {
                    option.folderPath = [VEHelp getFileURLFromAbsolutePath_str:option.folderPath];
                    DoodleOption *op = [VEHelp getDoodleOptionWithPath:option.folderPath];
                    op.autoBrush.fade = option.autoBrush.fade;
                    op.pngBrush.fade = option.autoBrush.fade;
                    op.networkCategoryId = option.networkCategoryId;
                    op.networkResourceId = option.networkResourceId;
                    op.folderPath = option.folderPath;
                    op.opacityValue = option.opacityValue;
                    op.paintSize = option.paintSize;
                    if (option.color) {
                        op.color = option.color;
                    }
                    op.eventArray = option.eventArray;
                    [options addObject:op];
                }];
                [doodleEx.optionArrays removeAllObjects];
                doodleEx.optionArrays = nil;
                doodleEx.optionArrays = options;
                
                [doodlePens addObject:doodleEx];
            }
        }];
        if (doodlePens.count > 0) {
            veCoreSDK.doodleArray = doodlePens;
        }
    }
    //MARK: 水印
    if (isExport && templateInfo.logoOverlay.path.length > 0) {
        Overlay *logoOverlay = [templateInfo.logoOverlay getOverlayWithFolderPath:folderPath];
        if (logoOverlay) {
            if (!folderPath && ![VEHelp isSystemPhotoUrl:logoOverlay.media.url]) {
                logoOverlay.media.url = [VEHelp getFileURLFromAbsolutePath:logoOverlay.media.url.path];
            }
            logoOverlay.type = OverlayTypeLogo;
            logoOverlay.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(templateInfo.duration, TIMESCALE));
            logoOverlay.media.timeRange = logoOverlay.timeRange;
            [overlays addObject:logoOverlay];
        }
    }
    if (overlays.count > 0) {
        veCoreSDK.overlayArray = overlays;
    }
    //MARK: 滤镜、特效
    NSMutableArray *customMultipleFilterArray = [NSMutableArray array];
    if (templateInfo.customFilters.count > 0) {
        [templateInfo.customFilters enumerateObjectsUsingBlock:^(VECoreTemplateCustomFilter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CustomMultipleFilter *filter = [obj getCustomMultipleFilterWithFolderPath:folderPath];
            if (filter) {
                if (!folderPath) {
                    filter.folderPath = [VEHelp getFileURLFromAbsolutePath_str:filter.folderPath];
                }
                filter.overlayType = CustomFilterOverlayTypeVirtualVideo;
                CustomFilter *customFilter = filter.filterArray.firstObject;
                customFilter.overlayType = CustomFilterOverlayTypeVirtualVideo;
                [customMultipleFilterArray addObject:filter];
            }
        }];
    }
    if (templateInfo.specialEffects.count > 0) {
        [templateInfo.specialEffects enumerateObjectsUsingBlock:^(VECoreTemplateSpecialEffect * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CustomMultipleFilter *customFilter = [obj getCustomMultipleFilterWithFolderPath:folderPath];
            if (customFilter) {
                if (!folderPath) {
                    customFilter.folderPath = [VEHelp getFileURLFromAbsolutePath_str:customFilter.folderPath];
                }
                CustomMultipleFilter *filter = [VEHelp getCustomMultipleFilerWithFolderPath:customFilter.folderPath currentFrameImagePath:nil];
                filter.timeRange = customFilter.timeRange;
                filter.networkCategoryId = customFilter.networkCategoryId;
                filter.networkResourceId = customFilter.networkResourceId;
                filter.overlayType = customFilter.overlayType;
                [customMultipleFilterArray addObject:filter];
            }
        }];
    }
    if (customMultipleFilterArray.count > 0) {
        veCoreSDK.customMultipleFilterArray = customMultipleFilterArray;
    }
    NSMutableArray *captions = [NSMutableArray array];
    //MARK: 字幕
    if (templateInfo.subtitles.count > 0) {
        [templateInfo.subtitles enumerateObjectsUsingBlock:^(VECoreTemplateSubtitle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Caption *caption = [obj getSubtitleWithFolderPath:folderPath videoSize:templateInfo.size];
            if (caption) {
                caption.imageFolderPath = [VEHelp getFileURLFromAbsolutePath_str:caption.imageFolderPath];
                if (caption.tFontPath.length > 0) {
                    caption.tFontPath = [VEHelp getFileURLFromAbsolutePath_str:caption.tFontPath];
                }
                caption.type = CaptionTypeHasText;
                
                NSArray *images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:caption.imageFolderPath error:nil];
                [images enumerateObjectsUsingBlock:^(NSString * _Nonnull imageName, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([imageName.pathExtension isEqualToString:@"webp"]) {
                        [VEHelp webpToPng:[caption.imageFolderPath stringByAppendingPathComponent:imageName]];
                    }
                }];
                
                NSString *configPath = [caption.imageFolderPath stringByAppendingPathComponent:@"config.json"];
                NSData *data = [[NSData alloc] initWithContentsOfFile:configPath];
                if(data){
                    NSError *error = nil;
                    NSMutableDictionary *configDic = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
                    if (!error) {
                        caption.isVerticalText = [configDic[@"vertical"] boolValue];
                        if ([configDic[@"apng"] boolValue]) {
                            [VEHelp setApngCaptionFrameArrayWithImagePath:configPath.stringByDeletingLastPathComponent jsonDic:configDic];
                        }
                        caption.frameArray = configDic[@"frameArray"];
                        caption.timeArray = configDic[@"timeArray"];
                        caption.imageName = configDic[@"name"];
                        caption.duration = [configDic[@"duration"] floatValue];
                        caption.isVerticalText = [configDic[@"vertical"] boolValue];
                        caption.tAngle = [configDic[@"tAngle"] floatValue];
                        caption.isStretch = [[configDic objectForKey:@"stretchability"] boolValue];
                        if (caption.isStretch) {
                            float imageW = [configDic[@"width"] floatValue];
                            float imageH = [configDic[@"height"] floatValue];
                            NSArray *borderPadding = configDic[@"borderPadding"];
                            double contentsCenter_x = [borderPadding[0] doubleValue];
                            double contentsCenter_w = imageW - contentsCenter_x - [borderPadding[2] doubleValue];
                            double contentsCenter_y = [borderPadding[1] doubleValue];
                            double contentsCenter_h = imageH -contentsCenter_y - [borderPadding[3] doubleValue];
                            CGRect contentsCenter = CGRectMake(contentsCenter_x/imageW, contentsCenter_y/imageH, contentsCenter_w/imageW, contentsCenter_h/imageH);
                            caption.stretchRect = contentsCenter;
                        }
                    }
                }
                if (caption.flowerTextType > 0) {
                    switch (caption.flowerTextType) {
                        case 1:
                        {
                            NSString *path = [VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"New_EditVideo/flower/color_1" Type:@"png"];
                            UIImage *image = [UIImage imageWithContentsOfFile:path];
                            caption.tColor = [UIColor colorWithPatternImage:image];
                            caption.strokeColor = UIColorFromRGB(0xffffff);
                            caption.strokeWidth = 26.0;
                            caption.innerStrokeColor = UIColorFromRGB(0x0000ff);
                            caption.innerStrokeWidth = 12.0;
                            caption.isShadow = NO;
                        }
                            break;
                        case 2:
                        {
                            NSString *path = [VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"New_EditVideo/flower/color_2" Type:@"png"];
                            UIImage *image = [UIImage imageWithContentsOfFile:path];
                            caption.tColor = [UIColor colorWithPatternImage:image];
                            caption.strokeColor = UIColorFromRGB(0xffffff);
                            caption.strokeWidth = 26.0;
                            caption.innerStrokeColor = UIColorFromRGB(0x000000);
                            caption.innerStrokeWidth = 12.0;
                            caption.isShadow = NO;
                        }
                            break;
                        case 3:
                        {
                            NSString *path = [VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"New_EditVideo/flower/color_3" Type:@"png"];
                            UIImage *image = [UIImage imageWithContentsOfFile:path];
                            caption.tColor = [UIColor colorWithPatternImage:image];
                            caption.isStroke = NO;
                            caption.strokeWidth = 0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            NSString *str = caption.pText;
                            NSRange range = NSMakeRange(0, str.length);
                            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                            [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithPatternImage:image] range:range];
                            [attrString addAttribute:NSStrokeWidthAttributeName value:@-2 range:range];
                            [attrString addAttribute:NSStrokeColorAttributeName value:[UIColor whiteColor] range:range];
                            
                            NSShadow *shadow = [[NSShadow alloc]init];
                            shadow.shadowBlurRadius = 15.0;
                            shadow.shadowOffset = CGSizeMake(0, 0);
                            shadow.shadowColor = UIColorFromRGB(0x162cbd);
                            [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
                            [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:range];
                            caption.attriStr = attrString;
                            caption.backgroundCaption = nil;
                        }
                            break;
                        case 4:
                        {
                            caption.tColor = UIColorFromRGB(0xffffff);
                            caption.strokeColor = UIColorFromRGB(0x000000);
                            caption.strokeWidth = 12.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                        }
                            break;
                        case 5:
                        {
                            caption.tColor = UIColorFromRGB(0xfdf9b8);
                            caption.strokeColor = UIColorFromRGB(0xffffff);
                            caption.strokeWidth = 26.0;
                            caption.innerStrokeColor = UIColorFromRGB(0xbfbfbf);
                            caption.innerStrokeWidth = 12.0;
                            caption.isShadow = NO;
                        }
                            break;
                        case 6:
                        {
                            caption.tColor = UIColorFromRGB(0xd05881);
                            caption.strokeColor = UIColorFromRGB(0x000000);
                            caption.strokeWidth = 12.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            caption.backgroundCaption = [Caption new];
                            caption.backgroundCaption.networkCategoryId = caption.networkCategoryId;
                            caption.backgroundCaption.networkResourceId = caption.networkResourceId;
                            caption.backgroundCaptionOffset = CGSizeMake(1, 0);
                            caption.backgroundCaption.tColor = UIColorFromRGB(0xd05881);
                            caption.backgroundCaption.textAlpha = caption.textAlpha;
                            caption.backgroundCaption.strokeColor = UIColorFromRGB(0x000000);
                            caption.backgroundCaption.strokeWidth = 12.0;
                            caption.backgroundCaption.innerStrokeWidth = 0.0;
                        }
                            break;
                        case 7:
                        {
                            caption.tColor = UIColorFromRGB(0xbcff0b);
                            caption.strokeColor = UIColorFromRGB(0xd05881);
                            caption.strokeWidth = 12.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            NSString *str = caption.pText;
                            NSRange range = NSMakeRange(0, str.length);
                            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbcff0b) range:range];
                            
                            NSShadow *shadow = [[NSShadow alloc]init];
                            shadow.shadowOffset = CGSizeMake(0, 4);
                            shadow.shadowColor = UIColorFromRGB(0xd05881);
                            [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
                            [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:NSMakeRange(0, str.length)];
                            
                            caption.backgroundCaption = [Caption new];
                            caption.backgroundCaption.networkCategoryId = caption.networkCategoryId;
                            caption.backgroundCaption.networkResourceId = caption.networkResourceId;
                            caption.backgroundCaptionOffset = CGSizeMake(0, 1);
                            caption.backgroundCaption.attriStr = attrString;
                        }
                            break;
                        case 8:
                        {
                            caption.tColor = [UIColor clearColor];
                            caption.strokeWidth = 0.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            NSString *str = caption.pText;
                            NSRange range = NSMakeRange(0, str.length);
                            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x162cbd) range:range];
                            [attrString addAttribute:NSStrokeWidthAttributeName value:@-2 range:range];
                            [attrString addAttribute:NSStrokeColorAttributeName value:UIColorFromRGB(0xffffff) range:range];
                            
                            NSShadow *shadow = [[NSShadow alloc]init];
                            shadow.shadowBlurRadius = 15.0;
                            shadow.shadowOffset = CGSizeMake(0, 0);
                            shadow.shadowColor = UIColorFromRGB(0x162cbd);
                            [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
                            [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:range];
                            caption.attriStr = attrString;
                            caption.backgroundCaption = nil;
                        }
                            break;
                        case 9:
                        {
                            caption.tColor = [UIColor clearColor];
                            caption.strokeWidth = 0.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            NSString *str = caption.pText;
                            NSRange range = NSMakeRange(0, str.length);
                            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4dff05) range:range];
                            [attrString addAttribute:NSStrokeWidthAttributeName value:@-2 range:range];
                            [attrString addAttribute:NSStrokeColorAttributeName value:UIColorFromRGB(0xffffff) range:range];
                            
                            NSShadow *shadow = [[NSShadow alloc]init];
                            shadow.shadowBlurRadius = 15.0;
                            shadow.shadowOffset = CGSizeMake(0, 0);
                            shadow.shadowColor = UIColorFromRGB(0x4dff05);
                            [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
                            [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:range];
                            caption.attriStr = attrString;
                            caption.backgroundCaption = nil;
                        }
                            break;
                        case 10:
                        {
                            caption.tColor = [UIColor clearColor];
                            caption.strokeWidth = 0.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            NSString *str = caption.pText;
                            NSRange range = NSMakeRange(0, str.length);
                            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf1ff6e) range:range];
                            [attrString addAttribute:NSStrokeWidthAttributeName value:@-2 range:range];
                            [attrString addAttribute:NSStrokeColorAttributeName value:UIColorFromRGB(0x000000) range:range];
                            
                            NSShadow *shadow = [[NSShadow alloc]init];
                            shadow.shadowBlurRadius = 15.0;
                            shadow.shadowOffset = CGSizeMake(0, 0);
                            shadow.shadowColor = UIColorFromRGB(0xffffff);
                            [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
                            [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:range];
                            caption.attriStr = attrString;
                            caption.backgroundCaption = nil;
                        }
                            break;
                        case 11:
                        {
                            NSString *path = [VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"New_EditVideo/flower/color_11" Type:@"png"];
                            UIImage *image = [UIImage imageWithContentsOfFile:path];
                            caption.tColor = [UIColor colorWithPatternImage:image];
                            caption.strokeColor = UIColorFromRGB(0x162cbd);
                            caption.strokeWidth = 12.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            caption.backgroundCaption = [Caption new];
                            caption.backgroundCaption.networkCategoryId = caption.networkCategoryId;
                            caption.backgroundCaption.networkResourceId = caption.networkResourceId;
                            caption.backgroundCaptionOffset = CGSizeMake(1, -1);
                            caption.backgroundCaption.tColor = UIColorFromRGB(0xffffff);
                            caption.backgroundCaption.textAlpha = caption.textAlpha;
                            caption.backgroundCaption.strokeColor = UIColorFromRGB(0x162cbd);
                            caption.backgroundCaption.strokeWidth = 12.0;
                            caption.backgroundCaption.innerStrokeWidth = 0.0;
                        }
                            break;
                        case 12:
                        {
                            caption.tColor = [UIColor clearColor];
                            caption.strokeWidth = 0.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            NSString *str = caption.pText;
                            NSRange range = NSMakeRange(0, str.length);
                            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x605124) range:range];
                            [attrString addAttribute:NSStrokeWidthAttributeName value:@-2 range:range];
                            [attrString addAttribute:NSStrokeColorAttributeName value:UIColorFromRGB(0xffffff) range:range];
                            
                            NSShadow *shadow = [[NSShadow alloc]init];
                            shadow.shadowBlurRadius = 15.0;
                            shadow.shadowOffset = CGSizeMake(0, 0);
                            shadow.shadowColor = UIColorFromRGB(0x605124);
                            [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
                            [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:range];
                            caption.attriStr = attrString;
                            caption.backgroundCaption = nil;
                        }
                            break;
                        case 13:
                        {
                            caption.tColor = [UIColor clearColor];
                            caption.strokeWidth = 0.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            NSString *str = caption.pText;
                            NSRange range = NSMakeRange(0, str.length);
                            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x000000) range:range];
                            
                            NSShadow *shadow = [[NSShadow alloc]init];
                            shadow.shadowOffset = CGSizeMake(3, 0);
                            shadow.shadowColor = UIColorFromRGB(0xffffff);
                            [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
                            [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:range];
                            caption.attriStr = attrString;
                            caption.backgroundCaption = nil;
                        }
                            break;
                        case 14:
                        {
                            caption.tColor = UIColorFromRGB(0xffffff);
                            caption.strokeColor = UIColorFromRGB(0x4dff05);
                            caption.strokeWidth = 12.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            NSString *str = caption.pText;
                            NSRange range = NSMakeRange(0, str.length);
                            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:range];
                            
                            NSShadow *shadow = [[NSShadow alloc]init];
                            shadow.shadowBlurRadius = 15.0;
                            shadow.shadowOffset = CGSizeMake(0, 0);
                            shadow.shadowColor = UIColorFromRGB(0x4dff05);
                            [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
                            [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:range];
                            
                            caption.backgroundCaption = [Caption new];
                            caption.backgroundCaption.networkCategoryId = caption.networkCategoryId;
                            caption.backgroundCaption.networkResourceId = caption.networkResourceId;
                            caption.backgroundCaptionOffset = CGSizeMake(0, 2);
                            caption.backgroundCaption.attriStr = attrString;
                        }
                            break;
                        case 15:
                        {
                            caption.tColor = UIColorFromRGB(0xffffff);
                            caption.strokeColor = UIColorFromRGB(0xd05881);
                            caption.strokeWidth = 12.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            NSString *str = caption.pText;
                            NSRange range = NSMakeRange(0, str.length);
                            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xffffff) range:range];
                            
                            NSShadow *shadow = [[NSShadow alloc]init];
                            shadow.shadowBlurRadius = 15.0;
                            shadow.shadowOffset = CGSizeMake(0, 0);
                            shadow.shadowColor = UIColorFromRGB(0xd05881);
                            [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
                            [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:range];
                            
                            caption.backgroundCaption = [Caption new];
                            caption.backgroundCaption.networkCategoryId = caption.networkCategoryId;
                            caption.backgroundCaption.networkResourceId = caption.networkResourceId;
                            caption.backgroundCaptionOffset = CGSizeMake(0, 2);
                            caption.backgroundCaption.attriStr = attrString;
                        }
                            break;
                        case 16:
                        {
                            caption.tColor = [UIColor clearColor];
                            caption.strokeWidth = 0.0;
                            caption.innerStrokeWidth = 0;
                            caption.isShadow = NO;
                            
                            NSString *str = caption.pText;
                            NSRange range = NSMakeRange(0, str.length);
                            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
                            [attrString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xf1ff6e) range:range];
                            [attrString addAttribute:NSStrokeWidthAttributeName value:@-2 range:range];
                            [attrString addAttribute:NSStrokeColorAttributeName value:UIColorFromRGB(0x000000) range:range];
                            
                            NSShadow *shadow = [[NSShadow alloc]init];
                            shadow.shadowBlurRadius = 15.0;
                            shadow.shadowOffset = CGSizeMake(0, 0);
                            shadow.shadowColor = UIColorFromRGB(0xffffff);
                            [attrString addAttribute:NSShadowAttributeName value:shadow range:range];
                            [attrString addAttribute:NSBaselineOffsetAttributeName value:@1 range:range];
                            caption.attriStr = attrString;
                            caption.backgroundCaption = nil;
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                [captions addObject:caption];
            }
        }];
    }
    NSMutableArray *captionExs = [NSMutableArray array];
    //MARK: 新版字幕
    if (templateInfo.subtitleExs.count > 0) {
        [templateInfo.subtitleExs enumerateObjectsUsingBlock:^(VECoreTemplateSubtitleEx * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CaptionEx *caption = [self getCaptionExWithTemplateSubtitleEx:obj folderPath:folderPath videoSize:templateInfo.size];
            if (caption) {
                [captionExs addObject:caption];
            }
        }];
    }
    //MARK: 语音转文字
    if (templateInfo.speechSubtitles.count > 0) {
        [templateInfo.speechSubtitles enumerateObjectsUsingBlock:^(VECoreTemplateSubtitleEx * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CaptionEx *caption = [self getCaptionExWithTemplateSubtitleEx:obj folderPath:folderPath videoSize:templateInfo.size];
            if (caption) {
                caption.type = CaptionExTypeSpeech;
                [captionExs addObject:caption];
            }
        }];
    }
    //MARK: 文字模板
    if (templateInfo.subtitlesTemplate.count > 0) {
        CGRect videoFrame = CGRectMake(0, 0, kWIDTH, kHEIGHT - kPlayerViewOriginX - 234 - 44 - (kToolbarHeight+16) );
        CGRect videoRect = AVMakeRectWithAspectRatioInsideRect(templateInfo.size, videoFrame);
        float scaleValue = ((templateInfo.size.width > templateInfo.size.height)?templateInfo.size.width/videoRect.size.width:templateInfo.size.height/videoRect.size.height);
        [templateInfo.subtitlesTemplate enumerateObjectsUsingBlock:^(VECoreTemplateSubtitleTemplate * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CaptionEx *caption = [obj getSubtitleWithFolderPath:folderPath videoSize:templateInfo.size];
            if (caption) {
                caption.imageFolderPath = [VEHelp getFileURLFromAbsolutePath_str:caption.imageFolderPath];
                if (caption.speechPath) {
                    caption.speechPath = [VEHelp getFileURLFromAbsolutePath_str:caption.speechPath];
                }
                
                NSArray *images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:caption.imageFolderPath error:nil];
                [images enumerateObjectsUsingBlock:^(NSString * _Nonnull imageName, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([imageName.pathExtension isEqualToString:@"webp"]) {
                        [VEHelp webpToPng:[caption.imageFolderPath stringByAppendingPathComponent:imageName]];
                    }
                }];
                CaptionEx *textTemplate = [VEHelp getTextTemplateCaptionConfig:caption.imageFolderPath atStart:0 atConfig:nil atName:nil];
                if (textTemplate) {
                    textTemplate.type = CaptionExTypeTemplate;
                    textTemplate.timeRange = caption.timeRange;
                    textTemplate.position = caption.position;
                    textTemplate.originalSize = CGSizeMake(textTemplate.originalSize.width / videoRect.size.width, textTemplate.originalSize.height / videoRect.size.height);
                    textTemplate.angle = caption.angle;
                    CGSize templateOriginalSize = CGSizeMake(obj.showRectF.size.width / obj.scale, obj.showRectF.size.height / obj.scale);
                    float scale = templateOriginalSize.width / textTemplate.originalSize.width;
                    if (textTemplate.originalSize.width <= 0) {
                        if (textTemplate.originalSize.height > 0) {
                            scale = templateOriginalSize.height / textTemplate.originalSize.height;
                        }else {
                            scale = 1.0;
                        }
                    }
                    textTemplate.scale = caption.scale*scale;
                    textTemplate.networkCategoryId = caption.networkCategoryId;
                    textTemplate.networkResourceId = caption.networkResourceId;
                    textTemplate.identifier = caption.identifier;
                    textTemplate.groupId = caption.groupId;
                    [textTemplate.texts enumerateObjectsUsingBlock:^(CaptionItem * _Nonnull item, NSUInteger idx1, BOOL * _Nonnull stop1) {
                        if (obj.content.count > idx1) {
                            item.text = obj.content[idx1];
                        }
                        item.frame = CGRectMake((item.frame.origin.x + item.frame.size.width/2.0)*scaleValue, (item.frame.origin.y + item.frame.size.height/2.0)*scaleValue, item.frame.size.width*scaleValue, item.frame.size.height*scaleValue);
                    }];
                    textTemplate.keyFrameAnimate = caption.keyFrameAnimate;
                    textTemplate.speechPath = caption.speechPath;
                    [captionExs addObject:textTemplate];
                }
            }
        }];
    }
    if (captionExs.count > 0) {
        veCoreSDK.captionExs = captionExs;
    }
    //MARK: 贴纸
    if (templateInfo.stickers.count > 0) {
        [templateInfo.stickers enumerateObjectsUsingBlock:^(VECoreTemplateSticker * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Caption *caption = [obj getStickerWithFolderPath:folderPath];
            if (caption) {
                caption.imageFolderPath = [VEHelp getFileURLFromAbsolutePath_str:caption.imageFolderPath];
                caption.type = CaptionTypeNoText;
                                    
                NSArray *images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:caption.imageFolderPath error:nil];
                [images enumerateObjectsUsingBlock:^(NSString * _Nonnull imageName, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([imageName.pathExtension isEqualToString:@"webp"]) {
                        [VEHelp webpToPng:[caption.imageFolderPath stringByAppendingPathComponent:imageName]];
                    }
                }];
                
                NSString *configPath = [caption.imageFolderPath stringByAppendingPathComponent:@"config.json"];
                NSData *data = [[NSData alloc] initWithContentsOfFile:configPath];
                if(data){
                    NSError *error = nil;
                    NSMutableDictionary *configDic = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
                    if (!error) {
                        if ([configDic[@"apng"] boolValue]) {
                            [VEHelp setApngCaptionFrameArrayWithImagePath:configPath.stringByDeletingLastPathComponent jsonDic:configDic];
                        }
                        caption.frameArray = configDic[@"frameArray"];
                        caption.timeArray = configDic[@"timeArray"];
                        caption.imageName = configDic[@"name"];
                        caption.duration = [configDic[@"duration"] floatValue];
                    }
                }
                if (caption.customAnimate) {
                    CustomFilter *animate = [VEHelp getCustomFilterWithFolderPath:caption.customAnimate.folderPath currentFrameImagePath:nil caption:caption];
                    animate.timeRange = caption.customAnimate.timeRange;
                    animate.cycleDuration = caption.customAnimate.cycleDuration;
                    animate.networkCategoryId = caption.customAnimate.networkCategoryId;
                    animate.networkResourceId = caption.customAnimate.networkResourceId;
                    animate.animateType = caption.customAnimate.animateType;
                    
                }
                if (caption.customOutAnimate) {
                    CustomFilter *animate = [VEHelp getCustomFilterWithFolderPath:caption.customOutAnimate.folderPath currentFrameImagePath:nil caption:caption];
                    animate.timeRange = caption.customOutAnimate.timeRange;
                    animate.cycleDuration = caption.customOutAnimate.cycleDuration;
                    animate.networkCategoryId = caption.customOutAnimate.networkCategoryId;
                    animate.networkResourceId = caption.customOutAnimate.networkResourceId;
                    animate.animateType = caption.customOutAnimate.animateType;
                    
                }
                [captions addObject:caption];
            }
        }];
    }
    if (captions.count > 0) {
        veCoreSDK.captions = captions;
    }
    //MARK: 配乐
    NSMutableArray *multiTrackMusics = [NSMutableArray array];
    if (templateInfo.musics.count > 0) {
        [templateInfo.musics enumerateObjectsUsingBlock:^(VECoreTemplateMusic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MusicInfo *music = [obj getMusicInfoWithFolderPath:folderPath];
            if (music) {
                if (!folderPath && ![VEHelp isSystemPhotoUrl:music.url]) {
                    music.url = [VEHelp getFileURLFromAbsolutePath:music.url.path];
                }
                [multiTrackMusics addObject:music];
            }
        }];
    }
    if (templateInfo.dubbings.count > 0) {
        [templateInfo.dubbings enumerateObjectsUsingBlock:^(VECoreTemplateMusic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MusicInfo *music = [obj getMusicInfoWithFolderPath:folderPath];
            if (music) {
                music.type = MusicTypeDubbing;
                if (!folderPath) {
                    music.url = [VEHelp getFileURLFromAbsolutePath:music.url.path];
                }
                [multiTrackMusics addObject:music];
            }
        }];
    }
    if (templateInfo.soundEffects.count > 0) {
        [templateInfo.soundEffects enumerateObjectsUsingBlock:^(VECoreTemplateMusic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MusicInfo *music = [obj getMusicInfoWithFolderPath:folderPath];
            if (music) {
                music.type = MusicTypeSoundEffect;
                if (!folderPath) {
                    music.url = [VEHelp getFileURLFromAbsolutePath:music.url.path];
                }
                [multiTrackMusics addObject:music];
            }
        }];
    }
    if (templateInfo.speechs.count > 0) {
        [templateInfo.speechs enumerateObjectsUsingBlock:^(VECoreTemplateMusic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MusicInfo *music = [obj getMusicInfoWithFolderPath:folderPath];
            if (music) {
                music.type = MusicTypeSpeech;
                if (!folderPath) {
                    music.url = [VEHelp getFileURLFromAbsolutePath:music.url.path];
                }
                [multiTrackMusics addObject:music];
            }
        }];
    }
    if (multiTrackMusics.count > 0) {
        [veCoreSDK setMusics:multiTrackMusics];
    }
    //MARK: 马赛克
    NSMutableArray *mosaics = [NSMutableArray array];
    NSMutableArray *blurs = [NSMutableArray array];
    NSMutableArray *dewatermarks = [NSMutableArray array];
    [templateInfo.mosaics enumerateObjectsUsingBlock:^(VECoreTemplateMosaic * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id object = [obj getMosaicWithFolderPath:folderPath];
        if (object) {
            if ([object isKindOfClass:[Mosaic class]]) {
                Mosaic *mosaic = (Mosaic *)object;
                [mosaics addObject:mosaic];
            }
            else if ([object isKindOfClass:[MediaAssetBlur class]]) {
                MediaAssetBlur *blur = (MediaAssetBlur *)object;
                [blurs addObject:blur];
            }else {
                Dewatermark *dewatermark = (Dewatermark *)object;
                [dewatermarks addObject:dewatermark];
            }
        }
    }];
    if (mosaics.count > 0) {
        veCoreSDK.mosaics = mosaics;
    }
    if (blurs.count > 0) {
        veCoreSDK.blurs = blurs;
    }
    if (dewatermarks.count > 0) {
        veCoreSDK.dewatermarks = dewatermarks;
    }
    
    //MARK: 色调
    if (templateInfo.tonings.count > 0) {
        NSMutableArray *tonings = [NSMutableArray array];
        [templateInfo.tonings enumerateObjectsUsingBlock:^(VECoreTemplateToningInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ToningInfo *toning = [obj getToningInfo];
            if (toning) {
                if (templateInfo.ver < 4.0) {
                    toning.sharpness = (toning.sharpness + 4)/8.0;//old:-4~4 new:0~1
                    toning.highlight = (toning.highlight + 1)/2.0;//old:-1~1 new:0~1
                }
                [tonings addObject:toning];
            }
        }];
        if (tonings.count > 0) {
            veCoreSDK.toningArray = tonings;
        }
    }
    
    //MARK: 粒子
    if (templateInfo.particles.count > 0) {
        NSMutableArray *particles = [NSMutableArray array];
        [templateInfo.particles enumerateObjectsUsingBlock:^(VECoreTemplateParticle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Particle *particle = [obj getCustomParticleWithFolderPath:folderPath];
            if (particles) {
                [particles addObject:particle];
            }
        }];
        if (particles.count > 0) {
            veCoreSDK.particleArray = particles;
        }
    }
    
    [veCoreSDK build];
}

+ (void)setVeCoreSDKSecens:(VECore *)veCoreSDK
          withTemplateInfo:(VECoreTemplateInfo *)templateInfo
                folderPath:(NSString *)folderPath
{
    NSMutableArray *scenes = [NSMutableArray array];
    [templateInfo.scenes enumerateObjectsUsingBlock:^(VECoreTemplateScene * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Scene *scene = [obj getSceneWithFolderPath:folderPath];
        if (scene) {
            if (scene.transition && scene.transition.type != TransitionTypeNone) {
                if (!folderPath && scene.transition.maskURL.path.length > 0) {
                    scene.transition.maskURL = [VEHelp getFileURLFromAbsolutePath:scene.transition.maskURL.path];
                }
                if (scene.transition.type == TransitionTypeCustom && [[NSFileManager defaultManager] fileExistsAtPath:scene.transition.maskURL.path]) {
                    scene.transition.customTransition = [VEHelp getCustomTransitionWithJsonPath:scene.transition.maskURL.path];
                }
            }
            if (!folderPath && scene.backgroundAsset && ![VEHelp isSystemPhotoUrl:scene.backgroundAsset.url]) {
                scene.backgroundAsset.url = [VEHelp getFileURLFromAbsolutePath:scene.backgroundAsset.url.path];
            }
            [scene.media enumerateObjectsUsingBlock:^(MediaAsset * _Nonnull asset, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if (!folderPath && ![VEHelp isSystemPhotoUrl:asset.url]) {
                    asset.url = [VEHelp getFileURLFromAbsolutePath:asset.url.path];
                }
                if ([VEHelp isSystemPhotoUrl:asset.url]) {
                    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                    option.synchronous = YES;
                    option.resizeMode = PHImageRequestOptionsResizeModeExact;
                    PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithALAssetURLs:@[asset.url] options:nil];
                    if (result.count > 0) {
                        PHAsset* phAsset = [result objectAtIndex:0];
                        if ([[phAsset valueForKey:@"uniformTypeIdentifier"] isEqualToString:@"com.compuserve.gif"]) {
                            asset.isGIF = YES;
                        }
                    }
                }else {
                    NSData *data = [NSData dataWithContentsOfURL:asset.url];
                    if (data) {
                        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
                        size_t count = CGImageSourceGetCount(source);
                        if (count > 1) {
                            asset.isGIF = YES;
                        }
                        if (source) {
                            CFRelease(source);
                        }
                        data = nil;
                    }
                }
                asset.identifier = [NSString stringWithFormat:@"media%lu", (unsigned long)idx];
                if (templateInfo.ver < 4.0) {
                    asset.adjustments.sharpness = (asset.adjustments.sharpness + 4)/8.0;//old:-4~4 new:0~1
                    asset.adjustments.highlight = (asset.adjustments.highlight + 1)/2.0;//old:-1~1 new:0~1
                    [asset.animate enumerateObjectsUsingBlock:^(MediaAssetAnimatePosition * _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj2.adjustments = [asset.adjustments copy];
                    }];
                }
                if (asset.mask) {
                    if (!folderPath) {
                        asset.mask.folderPath = [VEHelp getFileURLFromAbsolutePath_str:asset.mask.folderPath];
                    }
#ifndef kNewMask
                    NSString *maskName = asset.mask.folderPath.lastPathComponent;
                    MaskObject *mask = [VEHelp getMaskWithName:maskName];
#else
                    MaskObject *mask = [VEHelp getMaskWithPath:asset.mask.folderPath];
#endif
                    asset.mask.frag = mask.frag;
                    asset.mask.vert = mask.vert;
                    asset.mask.maskImagePath = mask.maskImagePath;
                }
                if (asset.customAnimate) {
                    if (!folderPath) {
                        asset.customAnimate.folderPath = [VEHelp getFileURLFromAbsolutePath_str:asset.customAnimate.folderPath];
                    }
                    CustomFilter *animate = [VEHelp getCustomFilterWithFolderPath:asset.customAnimate.folderPath currentFrameImagePath:nil atMedia:asset];
                    animate.timeRange = asset.customAnimate.timeRange;
                    animate.networkCategoryId = asset.customAnimate.networkCategoryId;
                    animate.networkResourceId = asset.customAnimate.networkResourceId;
                    animate.animateType = asset.customAnimate.animateType;
                    
                    asset.customAnimate = animate;
                }
                if (asset.customOutAnimate) {
                    if (!folderPath) {
                        asset.customOutAnimate.folderPath = [VEHelp getFileURLFromAbsolutePath_str:asset.customOutAnimate.folderPath];
                    }
                    CustomFilter *animate = [VEHelp getCustomFilterWithFolderPath:asset.customOutAnimate.folderPath currentFrameImagePath:nil atMedia:asset];
                    animate.timeRange = asset.customOutAnimate.timeRange;
                    animate.networkCategoryId = asset.customOutAnimate.networkCategoryId;
                    animate.networkResourceId = asset.customOutAnimate.networkResourceId;
                    animate.animateType = asset.customOutAnimate.animateType;
                    
                    asset.customOutAnimate = animate;
                }
                if( asset.customMultipleFilterArray.count > 0 )
                {
                    NSMutableArray *customMultipleFilterArray = [NSMutableArray array];
                    [asset.customMultipleFilterArray enumerateObjectsUsingBlock:^(CustomMultipleFilter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (!folderPath) {
                            obj.folderPath = [VEHelp getFileURLFromAbsolutePath_str:obj.folderPath];
                        }
                        CustomMultipleFilter * customMultipleFilter = [VEHelp getCustomMultipleFilerWithFolderPath:obj.folderPath currentFrameImagePath:asset.url.path];
                        customMultipleFilter.timeRange = obj.timeRange;
                        customMultipleFilter.networkCategoryId = obj.networkCategoryId;
                        customMultipleFilter.networkResourceId = obj.networkResourceId;
                        customMultipleFilter.overlayType = obj.overlayType;
                        [customMultipleFilterArray addObject:customMultipleFilter];
                    }];
                    asset.customMultipleFilterArray = customMultipleFilterArray;
                }
            }];
            [scenes addObject:scene];
        }
    }];
    if(templateInfo.isHasEndScene)
    {
        NSURL *url = [NSURL fileURLWithPath:[[VEHelp getBundle] pathForResource:@"ending" ofType:@"mp4"]];
        Scene *scene = [[Scene alloc] init];
        MediaAsset *asset = [[MediaAsset alloc] init];
        asset.url = url;
        asset.type = MediaAssetTypeVideo;
        asset.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(3, TIMESCALE));
        scene.media = [NSMutableArray arrayWithObject:asset];
        
        [scenes addObject:scene];
    }
    [veCoreSDK setScenes:scenes];
}

+ (CaptionEx *)getCaptionExWithTemplateSubtitleEx:(VECoreTemplateSubtitleEx *)obj folderPath:(NSString *)folderPath videoSize:(CGSize)videoSize {
    CaptionEx *caption = [obj getSubtitleWithFolderPath:folderPath videoSize:videoSize];
    if (caption) {
        caption.imageFolderPath = [VEHelp getFileURLFromAbsolutePath_str:caption.imageFolderPath];
        if (caption.imageFolderPath.length == 0 || ![[NSFileManager defaultManager] fileExistsAtPath:caption.imageFolderPath]) {
            NSBundle *bundle = [VEHelp getEditBundle];
            caption.imageFolderPath = [bundle pathForResource:@"New_EditVideo/text_sample" ofType:@""];
        }
        if (caption.speechPath) {
            caption.speechPath = [VEHelp getFileURLFromAbsolutePath_str:caption.speechPath];
        }
        NSArray *images = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:caption.imageFolderPath error:nil];
        [images enumerateObjectsUsingBlock:^(NSString * _Nonnull imageName, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([imageName.pathExtension isEqualToString:@"webp"]) {
                [VEHelp webpToPng:[caption.imageFolderPath stringByAppendingPathComponent:imageName]];
            }
        }];
        [caption.texts enumerateObjectsUsingBlock:^(CaptionItem * _Nonnull item, NSUInteger idx, BOOL * _Nonnull stop) {
            if (item.fontPath.length > 0) {
                item.fontPath = [VEHelp getFileURLFromAbsolutePath_str:item.fontPath];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:item.fontPath]) {
                    item.fontName = [VEHelp customFontArrayWithPath:item.fontPath].firstObject;
                }else {
                    item.fontPath = nil;
                    item.fontName = [UIFont systemFontOfSize:10].fontName;
                }
            }
            if (item.flowerTextType > 0) {
                if (item.flowerPath.length > 0) {
                    item.flowerPath = [VEHelp getFileURLFromAbsolutePath_str:item.flowerPath];
                }
                CaptionEffectCfg * fancyWrodsCfg = [VEHelp getFLowerWordConfigWithIndex:item.flowerTextType];
                if (fancyWrodsCfg) {
                    item.effectCfg = fancyWrodsCfg;
                }
            }
            if (item.animate) {
                NSString *animateFolderPath = item.animate.folderPath;
                if (!folderPath) {
                    animateFolderPath = [VEHelp getFileURLFromAbsolutePath_str:item.animate.folderPath];
                }
                CustomFilter *animate = [VEHelp getSubtitleAnimation:nil categoryId:nil atAnimationPath:animateFolderPath atCaptionItem:item];
                animate.timeRange = item.animate.timeRange;
                animate.cycleDuration = item.animate.cycleDuration;
                animate.networkCategoryId = item.animate.networkCategoryId;
                animate.networkResourceId = item.animate.networkResourceId;
                animate.animateType = item.animate.animateType;
                
                item.animate = animate;
            }
            if (item.animateOut) {
                NSString *animateFolderPath = item.animateOut.folderPath;
                if (!folderPath) {
                    animateFolderPath = [VEHelp getFileURLFromAbsolutePath_str:item.animateOut.folderPath];
                }
                CustomFilter *animate = [VEHelp getSubtitleAnimation:nil categoryId:nil atAnimationPath:animateFolderPath atCaptionItem:nil];
                animate.timeRange = item.animateOut.timeRange;
                animate.cycleDuration = item.animateOut.cycleDuration;
                animate.networkCategoryId = item.animateOut.networkCategoryId;
                animate.networkResourceId = item.animateOut.networkResourceId;
                animate.animateType = item.animateOut.animateType;
                
                item.animateOut = animate;
            }
        }];
        NSString *configPath = [caption.imageFolderPath stringByAppendingPathComponent:@"config.json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:configPath];
        if(data){
            NSError *error = nil;
            NSMutableDictionary *configDic = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingMutableContainers
                                                                          error:&error];
            if (!error) {
                CaptionItem *item = caption.texts.firstObject;
                if ([configDic[@"apng"] boolValue]) {
                    [VEHelp setApngCaptionFrameArrayWithImagePath:configPath.stringByDeletingLastPathComponent jsonDic:configDic];
                }
                caption.frameArray = configDic[@"frameArray"];
                caption.timeArray = configDic[@"timeArray"];
                caption.imageName = configDic[@"name"];
                caption.duration = [configDic[@"duration"] floatValue];
                item.angle = [configDic[@"tAngle"] floatValue];
                
                float imageW = [configDic[@"width"] floatValue];
                float imageH = [configDic[@"height"] floatValue];
//                if (obj.folderPath.length == 0)
                if( [VEConfigManager sharedManager].isAndroidTemplate )
                {
                    caption.originalSize = CGSizeMake(obj.showRectF.size.width / obj.scale, obj.showRectF.size.height / obj.scale);//20210914 跟安卓统一
                }else {
                    caption.originalSize = CGSizeMake(imageW / videoSize.width, imageH / videoSize.height);
                }
                caption.isStretch = [[configDic objectForKey:@"stretchability"] boolValue];
                if (caption.isStretch) {
                    NSArray *borderPadding = configDic[@"borderPadding"];
                    double contentsCenter_x = [borderPadding[0] doubleValue];
                    double contentsCenter_w = imageW - contentsCenter_x - [borderPadding[2] doubleValue];
                    double contentsCenter_y = [borderPadding[1] doubleValue];
                    double contentsCenter_h = imageH -contentsCenter_y - [borderPadding[3] doubleValue];
                    CGRect contentsCenter = CGRectMake(contentsCenter_x/imageW, contentsCenter_y/imageH, contentsCenter_w/imageW, contentsCenter_h/imageH);
                    caption.stretchRect = contentsCenter;
                    
                    NSArray *textPadding = configDic[@"textPadding"];
                    double t_left = [textPadding[0] doubleValue];
                    double t_right = [textPadding[2] doubleValue];
                    double t_top = [textPadding[1] doubleValue];
                    double t_buttom = [textPadding[3] doubleValue];
                    //20210914 跟安卓统一
//                    if (obj.folderPath.length == 0)
                    if( [VEConfigManager sharedManager].isAndroidTemplate )
                    {
                        item.padding = CGRectMake(0, 0, 1, 1);
                    }else {
                        CGRect textLabelRect = CGRectMake(t_left + 8, t_top + 8, imageW - t_left - t_right, imageH - t_top - t_buttom);
                        CGRect textRect = CGRectMake(textLabelRect.origin.x, textLabelRect.origin.y, textLabelRect.size.width, textLabelRect.size.height);
                        item.padding = CGRectMake(textRect.origin.x/imageW, textRect.origin.y/imageH, textRect.size.width/imageW, textRect.size.height/imageH);
                    }
                    item.frame = CGRectZero;
                    
                    NSArray* lines = [item.text componentsSeparatedByString:@"\n"];
                    NSInteger lineCount = MAX(1, lines.count);
                    
                    //20210914 跟安卓统一
//                    if (!CGRectEqualToRect(obj.wordItem.firstObject.showRectF, CGRectZero))
                    if( [VEConfigManager sharedManager].isAndroidTemplate )
                    {
                        if(item.isVertical)
                        {
                            double width = ((obj.showRectF.size.width/ obj.scale * videoSize.width) -  t_left - t_right)/lineCount + t_left + t_right;
                            width = width / videoSize.width;
                            double scale = width / caption.originalSize.width;
                            caption.scale *= scale;
                        }
                        else{
                            double height = ((obj.showRectF.size.height/ obj.scale * videoSize.height) -  t_top - t_buttom)/lineCount + t_top + t_buttom;
                            height = height / videoSize.height;
                            double scale = height / caption.originalSize.height;
                            caption.scale *= scale;
                            if (caption.scale > 1.0) {
                                caption.scale *= 0.826;
                            }
                        }
                    }
                }else {
                    int fx = 0,fy = 0,fw = 0,fh = 0;
                    NSArray *textPadding = configDic[@"textPadding"];
                    fx =  [textPadding[0] intValue];
                    fy =  [textPadding[1] intValue];
                    fw =  [configDic[@"textWidth"] intValue];
                    fh =  [configDic[@"textHeight"] intValue];
                    item.frame = CGRectMake(fx, fy, fw, fh);
                }
            }
        }
        
        if (caption.animate) {
            NSString *animateFolderPath = caption.animate.folderPath;
            if (!folderPath) {
                animateFolderPath = [VEHelp getFileURLFromAbsolutePath_str:caption.animate.folderPath];
            }
            CustomFilter *animate = [VEHelp getSubtitleAnimation:nil categoryId:nil atAnimationPath:animateFolderPath atCaptionItem:nil];
            animate.timeRange = caption.animate.timeRange;
            animate.cycleDuration = caption.animate.cycleDuration;
            animate.networkCategoryId = caption.animate.networkCategoryId;
            animate.networkResourceId = caption.animate.networkResourceId;
            animate.animateType = caption.animate.animateType;
            
            caption.animate = animate;
        }
        if (caption.animateOut) {
            NSString *animateFolderPath = caption.animateOut.folderPath;
            if (!folderPath) {
                animateFolderPath = [VEHelp getFileURLFromAbsolutePath_str:caption.animateOut.folderPath];
            }
            CustomFilter *animate =  [VEHelp getSubtitleAnimation:nil categoryId:nil atAnimationPath:animateFolderPath atCaptionItem:nil];
            animate.timeRange = caption.animateOut.timeRange;
            animate.cycleDuration = caption.animateOut.cycleDuration;
            animate.networkCategoryId = caption.animateOut.networkCategoryId;
            animate.networkResourceId = caption.animateOut.networkResourceId;
            animate.animateType = caption.animateOut.animateType;
            
            caption.animateOut = animate;
        }
        return caption;
    }
    return nil;
}

+ (void)replaceMedia:(MediaAsset *)media withVEMediaInfo:(VEMediaInfo *)file videoSize:(CGSize)videoSize {
    if (file.fileType == kFILEVIDEO) {
        media.type = MediaAssetTypeVideo;
    }else{
        media.type = MediaAssetTypeImage;
        media.fillType = ImageMediaFillTypeFit;
    }
    media.timeRange = CMTimeRangeMake(kCMTimeZero, media.timeRange.duration);
    if (!CGRectEqualToRect(media.crop, CGRectMake(0, 0, 1, 1))) {
        UIImage *image = [VEHelp getThumbImageWithUrl:media.url];
        media.crop = [VEHelp getFixedRatioCropWithMediaSize:file.thumbImage.size newSize:CGSizeMake(media.crop.size.width * image.size.width, media.crop.size.height * image.size.height)];
    }
    else if (!CGRectEqualToRect(media.rectInVideo, CGRectMake(0, 0, 1, 1))) {
        media.crop = [VEHelp getFixedRatioCropWithMediaSize:file.thumbImage.size newSize:CGSizeMake(media.rectInVideo.size.width * videoSize.width, media.rectInVideo.size.height * videoSize.height)];
    }else {
        UIImage *image = [VEHelp getThumbImageWithUrl:media.url];
        media.crop = [VEHelp getFixedRatioCropWithMediaSize:file.thumbImage.size newSize:image.size];
    }
    [media.animate enumerateObjectsUsingBlock:^(MediaAssetAnimatePosition * _Nonnull animate, NSUInteger idx, BOOL * _Nonnull stop) {
        animate.crop = media.crop;
    }];

    media.url = file.contentURL;
}

#pragma mark - 字幕动画
+ (CustomFilter *)getSubtitleAnimation:(NSMutableDictionary *) itemDic categoryId:(NSString *)categoryId atAnimationPath:(NSString *) animationPath atCaptionItem:( CaptionItem * ) captionItem
{
    NSString *path = animationPath;
    NSInteger fileCount = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] count];
    if (fileCount == 0) {
        return nil;
    }
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *folderName;
    if (files.count == 1) {
        for (NSString *fileName in files) {
            if (![fileName isEqualToString:@"__MACOSX"]) {
                NSString *folderPath = [path stringByAppendingPathComponent:fileName];
                BOOL isDirectory = NO;
                BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDirectory];
                if (isExists && isDirectory) {
                    folderName = fileName;
                    break;
                }
            }
        }
    }
    
    if (folderName.length > 0) {
        path = [path stringByAppendingPathComponent:folderName];
    }
    
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    CustomFilter *customFilter =[self getSubtitleAnmation:configPath atPath:path atCaptionItem:captionItem];
    customFilter.networkCategoryId = categoryId;
    customFilter.networkResourceId = itemDic[@"id"];
    customFilter.folderPath = path;
    
    return customFilter;
}


#pragma mark- 字幕花字
+ (CaptionEffectCfg *)getFLowerWordConfigWithIndex:(NSInteger)index {
    NSString *configPath = [[VEHelp getEditBundle] pathForResource:[NSString stringWithFormat:@"/New_EditVideo/flowerWord/colortext%ld.json", index] ofType:nil];
    return [self getFLowerWordConfig:configPath];
}

+(CaptionEffectColorParam *)getShadowStrokes:( NSDictionary * ) obj
{
    CaptionEffectColorParam *stroke = [CaptionEffectColorParam new];
    if( obj[@"gradient"]  )
        stroke.gradient = [obj[@"gradient"] boolValue];
    stroke.colors = [NSMutableArray new];
    if( obj[@"width"] )
        stroke.outlineWidth = [obj[@"width"] floatValue];
    
    if( obj[@"colorAngleFactor"] )
    {
        NSArray *colorAngleFactor = obj[@"colorAngleFactor"];
        CGVec3 angleFactor = {[colorAngleFactor[0] floatValue],[colorAngleFactor[1] floatValue],[colorAngleFactor[2] floatValue]};
        stroke.colorAngleFactor  = angleFactor;
    }
    
    if( obj[@"color"]  )
    {
        NSArray *colors = obj[@"color"];
        [colors enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop) {
            CaptionEffectColor *color = [CaptionEffectColor new];
            if( obj1[@"color"] )
            {
                NSArray *strokeColors = obj1[@"color"];
                float r = [(strokeColors[0]) floatValue]/255.0;
                float g = [(strokeColors[1]) floatValue]/255.0;
                float b = [(strokeColors[2]) floatValue]/255.0;
                float a = [(strokeColors[3]) floatValue]/255.0;
                color.color =  [UIColor colorWithRed:r green:g blue:b alpha:a];
            }
            
            if( obj1[@"factor"] )
                color.factor = [obj1[@"factor"] floatValue];
            [stroke.colors addObject:color];
        }];
    }
    return stroke;
}

+ (NSString *)createFilename {
    NSDate *date_ = [NSDate date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd_HH-mm-ss-sss"];
    NSString *timeFileName = [dateformater stringFromDate:date_];
    return timeFileName;
}

#pragma mark- 文字模版
+(NSDictionary *)getTextTemplateEffectConfig:( NSString * ) configPath
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
            if(err) {
                NSLog(@"json解析失败：%@",err);
            }
            
            return  subtitleEffectConfig;
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    return nil;
}

+(CaptionEx *)getTextTemplateCaptionConfig:( NSString * ) configPath atStart:(float) startTime atConfig:(NSDictionary **) config atName:(NSString *) name
{
    @try {
        NSString *path = [[NSString stringWithFormat:@"%@",configPath] stringByAppendingPathComponent:@"config.json"];
        NSFileManager *manager = [[NSFileManager alloc] init];
        if([manager fileExistsAtPath:path]){
            NSLog(@"have");
        }else{
            NSLog(@"nohave");
            NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:configPath error:nil];
            NSString *folderName;
            for (NSString *fileName in files) {
                if (![fileName isEqualToString:@"__MACOSX"]) {
                    NSString *folderPath = [configPath stringByAppendingPathComponent:fileName];
                    BOOL isDirectory = NO;
                    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDirectory];
                    if (isExists && isDirectory) {
                        folderName = fileName;
                        break;
                    }
                }
            }
            if (folderName.length > 0) {
                path = [[configPath stringByAppendingPathComponent:folderName] stringByAppendingPathComponent:@"config.json"];
            }
        }
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
        
        NSError *err;
        if(data){
            NSDictionary *subtitleEffectConfig = [NSJSONSerialization JSONObjectWithData:data
                           options:NSJSONReadingMutableContainers
                             error:&err];
            if (config) {
                (*config) = subtitleEffectConfig;
            }
            
            if(err) {
                NSLog(@"json解析失败：%@",err);
            }
            
            CaptionEx *ppCaption = [[CaptionEx alloc]init];
            ppCaption.type = CaptionExTypeTemplate;
            //大小
            float width = [subtitleEffectConfig[@"width"] floatValue];
            float height = [subtitleEffectConfig[@"height"] floatValue];
            ppCaption.originalSize = CGSizeMake(width, height);
            float captionExDuariton = [subtitleEffectConfig[@"duration"] floatValue];
            if( captionExDuariton == 0 )
            {
                captionExDuariton = 3;
            }
            ppCaption.duration = captionExDuariton;
            ppCaption.timeRange = CMTimeRangeMake( CMTimeMakeWithSeconds(startTime, TIMESCALE), CMTimeMakeWithSeconds(captionExDuariton, TIMESCALE));
            //文字参数处理
            NSMutableArray * textArray = subtitleEffectConfig[@"text"];
            NSMutableArray *texts = [NSMutableArray new];
            ppCaption.texts = texts;
            
            [textArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CaptionItem *captionItem = [CaptionItem new];
                [texts addObject:captionItem];
                float textStartTime = [obj[@"startTime"] floatValue];
                textStartTime = MAX(0, textStartTime);
                float textDuraiton = [obj[@"duration"] floatValue];
                if( textDuraiton == 0 )
                {
                    textDuraiton = captionExDuariton - textStartTime;
                }
                captionItem.timeRange = CMTimeRangeMake( CMTimeMakeWithSeconds(textStartTime, TIMESCALE), CMTimeMakeWithSeconds(textDuraiton, TIMESCALE));
                
                captionItem.text = obj[@"textContent"];                //文字颜色
                {
                    NSArray *textColors = obj[@"textColor"];
                    float r = [(textColors[0]) floatValue]/255.0;
                    float g = [(textColors[1]) floatValue]/255.0;
                    float b = [(textColors[2]) floatValue]/255.0;
                    captionItem.textColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
                }
                //字体处理
                NSString *fontFile = obj[@"fontFile"];

                if( fontFile == nil || (fontFile.length == 0)  )
                {
                    captionItem.fontName = [[UIFont systemFontOfSize:10] fontName];
                }
                else
                {
                    NSString *fontPath = [configPath stringByAppendingString:@"/"];
                    fontPath = [NSString stringWithFormat:@"%@%@",fontPath,fontFile];
                    NSArray *fontNames = [VEHelp customFontArrayWithPath:fontPath];
                    NSLog(@"fontName:%@",fontNames);
                    if( fontNames )
                    {
                        captionItem.fontName = [fontNames firstObject];
                        captionItem.fontPath = fontPath;
                    }
                    else{
                        captionItem.fontName = [[UIFont systemFontOfSize:10] fontName];
                    }
                }
#if 0
                //测试文字模版没有底图的情况
                captionItem.fontSize = 20;
#else
                captionItem.fontSize = [obj[@"fontSize"] floatValue];
#endif
                CGRect tFrame = CGRectZero;
                //文字显示区域
                {
                    NSMutableArray * showRecct = obj[@"showRect"];
                    float x = [showRecct[0] floatValue];
                    float y = [showRecct[1] floatValue];
                    float x1 = [showRecct[2] floatValue];
                    float y1 = [showRecct[3] floatValue];
                    tFrame = CGRectMake(x, y, x1 - x, y1 - y);
                    captionItem.frame = tFrame;
                }
                //文字对齐方式
                NSString * alignment = obj[@"alignment"];
                
                
                if( [alignment isEqualToString:@"center"] )
                {
                    captionItem.textAlignment = CaptionTextAlignmentCenter;
                }
                else if( [alignment isEqualToString:@"left"] )
                {
                    captionItem.textAlignment = CaptionTextAlignmentLeft;
                }
                else if( [alignment isEqualToString:@"right"] )
                {
                    captionItem.textAlignment = CaptionTextAlignmentRight;
                }
                //是否文字竖排
                float vertical = [obj[@"vertical"] floatValue];
                captionItem.isVertical = vertical;
                //加粗
                float bold = [obj[@"bold"] floatValue];
                captionItem.isBold = bold;
                //斜体
                float italic = [obj[@"italic"] floatValue];
                captionItem.isItalic = italic;
                float underline = [obj[@"underline"] floatValue];
                captionItem.isUnderline = underline;
                //阴影
                float shadow = [obj[@"shadow"] floatValue];
                if( shadow )
                {
                    CaptionShadow *shadow = [CaptionShadow new];
                    captionItem.shadow = shadow;
                    CaptionEffectColorParam *shadowColors = [CaptionEffectColorParam new];
                    shadow.shadowColors = shadowColors;
                    shadowColors.colors = [NSMutableArray new];
                    shadow.shadowAutoColor = [obj[@"shadowAutoColor"] boolValue];
                    shadow.shadowAngle =  [obj[@"shadowAngle"] floatValue];
                    shadow.shadowBlur =  [obj[@"shadowBlur"] floatValue];
                    shadow.shadowDistance =  [obj[@"shadowDistance"] floatValue];
                    if( obj[@"shadowColor"] )
                    {
                        CaptionEffectColor * color = [CaptionEffectColor new];
                        NSArray *outlineColor = obj[@"shadowColor"];
                        float r = [(outlineColor[0]) floatValue]/255.0;
                        float g = [(outlineColor[1]) floatValue]/255.0;
                        float b = [(outlineColor[2]) floatValue]/255.0;
                        color.color = [UIColor colorWithRed:r green:g blue:b alpha:1];
                        [shadowColors.colors addObject:color];
                    }
                    //描边
//                    if( obj[@"shadow"][@"stroke"] )
//                    {
//                        NSArray *strokeColors = obj[@"shadow"][@"stroke"];
//                        shadow.shadowStrokes = [NSMutableArray new];
//                        [strokeColors enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
//                            [shadow.shadowStrokes addObject:[self getShadowStrokes:obj1]];
//                        }];
//                    }
                }
                //文字镂空
                captionItem.maskType = [obj[@"mask"] intValue];
                //文字透明度
                float alpha = [obj[@"alpha"] floatValue];
                captionItem.alpha = alpha;
                //文字旋转角度
                float angle = [obj[@"angle"] floatValue];
                captionItem.angle = angle;
                //字间距
                if( [obj[@"space"] floatValue] )
                {
                    captionItem.wordSpacing = [obj[@"space"] floatValue];
                }
                //描边
                if( [obj[@"outline"] floatValue] )
                {
                    CaptionEffectColorParam *stroke = [CaptionEffectColorParam new];
                    captionItem.stroke = stroke;
                    if( obj[@"outlineWidth"] )
                    {
                        stroke.outlineWidth = [obj[@"outlineWidth"] floatValue];
                    }
                    stroke.colors = [NSMutableArray new];
                    if( obj[@"outlineColor"] )
                    {
                        CaptionEffectColor * color = [CaptionEffectColor new];
                        NSArray *outlineColor = obj[@"outlineColor"];
                        float r = [(outlineColor[0]) floatValue]/255.0;
                        float g = [(outlineColor[1]) floatValue]/255.0;
                        float b = [(outlineColor[2]) floatValue]/255.0;
                        color.color = [UIColor colorWithRed:r green:g blue:b alpha:1];
                        [stroke.colors addObject:color];
                    }
                }
                
                //标签
                bool background = [obj[@"background"] boolValue];
                if( background )
                {
                    NSArray *backgroundColor = obj[@"backgroundColor"];
                    float r = [(backgroundColor[0]) floatValue]/255.0;
                    float g = [(backgroundColor[1]) floatValue]/255.0;
                    float b = [(backgroundColor[2]) floatValue]/255.0;
                    captionItem.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
                }
                else
                {
                    captionItem.backgroundColor = nil;
                }
                
                //MARK: 文字模版 花字
                {
                    NSString *flowerWordPath = obj[@"color_text"];
                    [self getTextTemplateFlowerWord:captionItem atPath:configPath atFlowerWordName:flowerWordPath];
                }
        
                //KTV
                if( obj[@"ktvColor"] )
                {
                    NSArray *ktvColor = obj[@"ktvColor"];
                    float r = [(ktvColor[0]) floatValue]/255.0;
                    float g = [(ktvColor[1]) floatValue]/255.0;
                    float b = [(ktvColor[2]) floatValue]/255.0;
                    UIColor * color = [UIColor colorWithRed:r green:g blue:b alpha:1];
                    captionItem.ktvColor = color;
                }
#if 0
                {
                    NSArray *ktvOutlineColor = obj[@"ktvOutlineColor"];
                    float r = [(ktvOutlineColor[0]) floatValue]/255.0;
                    float g = [(ktvOutlineColor[1]) floatValue]/255.0;
                    float b = [(ktvOutlineColor[2]) floatValue]/255.0;
                    ppCaption.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
                }
                {
                    NSArray *ktvShadowColor = obj[@"ktvShadowColor"];
                    float r = [(ktvShadowColor[0]) floatValue]/255.0;
                    float g = [(ktvShadowColor[1]) floatValue]/255.0;
                    float b = [(ktvShadowColor[2]) floatValue]/255.0;
                    ppCaption.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
                }
#endif
                //文字动画
                {
                    NSMutableArray * anims = obj[@"anims"];
                    [anims enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString * animsType = obj[@"anim_type"];
                        NSString * anim_resource = obj[@"anim_resource"];
                        float animDuration = [obj[@"duration"] floatValue];
                        //如果没有设置 [@"duration"] ，那么默认动画时间就是字幕的时间
//                        if( animDuration == 0 )
//                        {
//                            animDuration = 3.0;
//                        }
                        
                        NSString *animsName = [anim_resource stringByReplacingOccurrencesOfString:@".zip" withString:@""];
                        
                        CMTimeRange timeRage = CMTimeRangeMake(CMTimeMakeWithSeconds(0, TIMESCALE), CMTimeMakeWithSeconds(animDuration, TIMESCALE));
                        
                        CustomFilter *filter  = [VEHelp getTextTemplateAnimation:[NSString stringWithFormat:@"%@/%@",configPath,animsName] atFileName:animsName atCaptionItem:captionItem];
                        
                        if( [animsType isEqualToString:@"out"] )
                        {
                            timeRage = CMTimeRangeMake(CMTimeMakeWithSeconds(textDuraiton - animDuration, TIMESCALE), CMTimeMakeWithSeconds(animDuration, TIMESCALE));
                            captionItem.animateOut = filter;
                            filter.timeRange = timeRage;
//                            captionItem.animate = nil;
                        }
                        else if( [animsType isEqualToString:@"cycle"] ){
                            captionItem.animate = filter;
                            captionItem.animate.cycleDuration = animDuration;
                            timeRage = CMTimeRangeMake(CMTimeMakeWithSeconds(0, TIMESCALE),CMTimeMakeWithSeconds(textDuraiton, TIMESCALE));
                            captionItem.animate.timeRange = timeRage;
                        }
                        else{
                            captionItem.animate = filter;
                            captionItem.animate.timeRange = timeRage;
                        }
                    }];
                }
            }];
            
            //时间
//                float startTime = [obj[@"startTime"] floatValue];
//            float duration = [subtitleEffectConfig[@"duration"] floatValue];
//            if( duration == 0 )
//            {
//                duration = 3;
//            }
//            ppCaption.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(startTime, TIMESCALE), CMTimeMakeWithSeconds(duration, TIMESCALE));
            
            //气泡
            ppCaption.imageName = subtitleEffectConfig[@"name"];
            
            if( subtitleEffectConfig[@"background"] )
            {
                NSString * backgroundType = subtitleEffectConfig[@"background"][@"type"];
                ppCaption.imageFolderPath = configPath;
                if( [backgroundType isEqualToString:@"image"] )
                {
                    NSMutableArray *frameArray = subtitleEffectConfig[@"background"][@"frameArray"];
                    ppCaption.frameArray = frameArray;
                    NSMutableArray *timeArray = subtitleEffectConfig[@"background"][@"timeArray"];
                    ppCaption.timeArray = timeArray;
                }
   
                
//                NSInteger stretchability = [subtitleEffectConfig[@"background"][@"stretchability"] integerValue];
//                NSMutableArray * anims = subtitleEffectConfig[@"background"][@"anims"];
            }
            
            return ppCaption;
        }
        return nil;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}
+(CaptionEffectCfg *)getFLowerWordConfig:( NSString * ) configPath
{
    if (!configPath) {
        return nil;
    }
    CaptionEffectCfg * fancyWrodsCfg;
    NSData *data = [[NSData alloc] initWithContentsOfFile:configPath];
    if(data){
        NSError *error = nil;
        NSMutableDictionary *subtitleEffectConfig = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&error];
        if (!error) {
            fancyWrodsCfg = [CaptionEffectCfg new];
            //文字颜色
            if( subtitleEffectConfig[@"normal"] )
            {
                CaptionEffectColorParam *normal = [CaptionEffectColorParam new];
                if( subtitleEffectConfig[@"normal"][@"gradient"] )
                    normal.gradient = [subtitleEffectConfig[@"normal"][@"gradient"] boolValue];
                normal.colors = [NSMutableArray new];
                if( subtitleEffectConfig[@"normal"][@"color"] )
                {
                    NSArray *colors = subtitleEffectConfig[@"normal"][@"color"];
                    [colors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        CaptionEffectColor *color = [CaptionEffectColor new];
                        if( obj[@"factor"]  )
                        {
                            NSArray *strokeColors = obj[@"color"];
                            float r = [(strokeColors[0]) floatValue]/255.0;
                            float g = [(strokeColors[1]) floatValue]/255.0;
                            float b = [(strokeColors[2]) floatValue]/255.0;
                            float a = [(strokeColors[3]) floatValue]/255.0;
                            color.color =  [UIColor colorWithRed:r green:g blue:b alpha:a];
                        }
                        if( obj[@"factor"]  )
                            color.factor = [obj[@"factor"] floatValue];
                        [normal.colors addObject:color];
                    }];
                }
                fancyWrodsCfg.normal = normal;
            }
            //描边
            if( subtitleEffectConfig[@"stroke"] )
            {
                NSArray *strokeColors = subtitleEffectConfig[@"stroke"];
                fancyWrodsCfg.strokes = [NSMutableArray new];
                [strokeColors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    CaptionEffectColorParam *stroke = [CaptionEffectColorParam new];
                    if( obj[@"gradient"]  )
                        stroke.gradient = [obj[@"gradient"] boolValue];
                    stroke.colors = [NSMutableArray new];
                    
                    if( obj[@"width"] )
                        stroke.outlineWidth = [obj[@"width"] floatValue];
                    
                    if( obj[@"colorAngleFactor"] )
                    {
                        NSArray *colorAngleFactor = obj[@"colorAngleFactor"];
                        CGVec3 angleFactor = {[colorAngleFactor[0] floatValue],[colorAngleFactor[1] floatValue],[colorAngleFactor[2] floatValue]};
                        stroke.colorAngleFactor  = angleFactor;
                    }
                    
                    if( obj[@"color"]  )
                    {
                        NSArray *colors = obj[@"color"];
                        [colors enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop) {
                            CaptionEffectColor *color = [CaptionEffectColor new];
                            if( obj1[@"color"] )
                            {
                                NSArray *strokeColors = obj1[@"color"];
                                float r = [(strokeColors[0]) floatValue]/255.0;
                                float g = [(strokeColors[1]) floatValue]/255.0;
                                float b = [(strokeColors[2]) floatValue]/255.0;
                                float a = [(strokeColors[3]) floatValue]/255.0;
                                color.color =  [UIColor colorWithRed:r green:g blue:b alpha:a];
                            }
                            
                            if( obj1[@"factor"] )
                                color.factor = [obj1[@"factor"] floatValue];
                            [stroke.colors addObject:color];
                        }];
                    }
                    [fancyWrodsCfg.strokes addObject:stroke];
                }];
            }
            //多层阴影
            if( subtitleEffectConfig[@"shadows"] )
            {
                NSArray *strokeColors = subtitleEffectConfig[@"shadows"];
                fancyWrodsCfg.shadows = [NSMutableArray new];
                [strokeColors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    CaptionShadow * shadow =  [CaptionShadow new];
                    if( obj[@"auto"] )
                        shadow.shadowAutoColor = [obj[@"auto"] boolValue];
                    if( obj[@"distance"] )
                        shadow.shadowDistance = [obj[@"distance"] floatValue];
                    if( obj[@"angle"] )
                        shadow.shadowAngle = [obj[@"angle"] floatValue];
                    if( obj[@"blur"] )
                        shadow.shadowBlur = [obj[@"blur"] floatValue];
                    if( obj[@"color"] )
                    {
                        NSArray *strokeColors = obj[@"color"];
                        float r = [(strokeColors[0]) floatValue]/255.0;
                        float g = [(strokeColors[1]) floatValue]/255.0;
                        float b = [(strokeColors[2]) floatValue]/255.0;
                        float a = [(strokeColors[3]) floatValue]/255.0;
                        shadow.shadowColor =  [UIColor colorWithRed:r green:g blue:b alpha:a];
                    }
                    if( obj[@"angle"] )
                        shadow.shadowAngle = [obj[@"angle"] floatValue];
                    
                    //描边
                    if( obj[@"stroke"] )
                    {
                        NSArray *strokeColors = obj[@"stroke"];
                        shadow.shadowStrokes = [NSMutableArray new];
                        [strokeColors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [shadow.shadowStrokes addObject:[self getShadowStrokes:obj]];
                        }];
                    }
                    [fancyWrodsCfg.shadows addObject:shadow];
                }];
            }
            //阴影
            if( subtitleEffectConfig[@"shadow"] )
            {
                CaptionShadow * shadow =  [CaptionShadow new];
                if( subtitleEffectConfig[@"shadow"][@"auto"] )
                    shadow.shadowAutoColor = [subtitleEffectConfig[@"shadow"][@"auto"] boolValue];
                if( subtitleEffectConfig[@"shadow"][@"distance"] )
                    shadow.shadowDistance = [subtitleEffectConfig[@"shadow"][@"distance"] floatValue];
                if( subtitleEffectConfig[@"shadow"][@"angle"] )
                    shadow.shadowAngle = [subtitleEffectConfig[@"shadow"][@"angle"] floatValue];
                if( subtitleEffectConfig[@"shadow"][@"blur"] )
                    shadow.shadowBlur = [subtitleEffectConfig[@"shadow"][@"blur"] floatValue];
                if( subtitleEffectConfig[@"shadow"][@"color"] )
                {
                    NSArray *strokeColors = subtitleEffectConfig[@"shadow"][@"color"];
                    float r = [(strokeColors[0]) floatValue]/255.0;
                    float g = [(strokeColors[1]) floatValue]/255.0;
                    float b = [(strokeColors[2]) floatValue]/255.0;
                    float a = [(strokeColors[3]) floatValue]/255.0;
                    shadow.shadowColor =  [UIColor colorWithRed:r green:g blue:b alpha:a];
                }
                if( subtitleEffectConfig[@"shadow"][@"angle"] )
                    shadow.shadowAngle = [subtitleEffectConfig[@"shadow"][@"angle"] floatValue];
                
                //描边
                if( subtitleEffectConfig[@"shadow"][@"stroke"] )
                {
                    NSArray *strokeColors = subtitleEffectConfig[@"shadow"][@"stroke"];
                    shadow.shadowStrokes = [NSMutableArray new];
                    [strokeColors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [shadow.shadowStrokes addObject:[self getShadowStrokes:obj]];
                    }];
                }
                
                fancyWrodsCfg.shadow = shadow;
            }
        }
    }
    return fancyWrodsCfg;
}

+(void)getTextTemplateFlowerWord:(  CaptionItem * ) captionItem atPath:( NSString * ) configPath atFlowerWordName:( NSString * ) flowerWordName
{
    
    NSString *path = [[NSString stringWithFormat:@"%@",configPath] stringByAppendingPathComponent:flowerWordName];
    captionItem.effectCfg = [self getFLowerWordConfig:path];
}

#pragma mark- 动画（字幕 文字模版）
+(  CustomFilter * )getSubtitleAnmation:( NSString * ) configPath atPath:( NSString * ) path atCaptionItem:( CaptionItem * ) captionItem
{
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    if (captionItem) {
        if( effectDic[@"other"] )
        {
            captionItem.otherAnimates = [NSMutableArray new];
            NSArray *array = effectDic[@"other"];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [captionItem.otherAnimates addObject:[VEHelp getAnmationDic:(NSMutableDictionary*)obj atPath:path]];
            }];
        }
        else{
            [captionItem.otherAnimates enumerateObjectsUsingBlock:^(CustomFilter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj = nil;
            }];
            captionItem.otherAnimates = nil;
        }
    }
    
    return [VEHelp getAnmationDic:effectDic atPath:path];
}

+(CustomFilter *)getAnmationDic:( NSMutableDictionary * ) effectDic atPath:(NSString *)path
{
    NSError * error = nil;
    
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    customFilter.cycleDuration = 0.0;
    if (effectDic[@"duration"]) {
        customFilter.cycleDuration = [effectDic[@"duration"] floatValue];
    }
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
    customFilter.name = effectDic[@"name"];
    customFilter.folderPath = path;
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
    NSString *fragPath = [path stringByAppendingPathComponent:effectDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:effectDic[@"vertShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    
    if (effectDic[@"script"]) {
        NSString *scriptPath = [path stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
        customFilter.scriptName = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
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

+(CustomFilter *)getTextTemplateAnimation:( NSString * ) configPath atFileName:(NSString *) fileName atCaptionItem:( CaptionItem * ) captionItem
{
//    CustomFilter * advCustomFIlter = [[CustomFilter alloc] init];
    
    NSString *path = [[NSString stringWithFormat:@"%@",configPath] stringByAppendingFormat:@"/config.json"];
    NSFileManager *manager = [[NSFileManager alloc] init];
    if([manager fileExistsAtPath:path]){
        NSLog(@"have");
    }else{
        NSLog(@"nohave");
    }
    
    return  [self getSubtitleAnmation:path atPath:configPath atCaptionItem:captionItem];
//    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//    data = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
//
//    NSError *err;
//    if(data){
//        NSDictionary *textTemplateEffectConfig = [NSJSONSerialization JSONObjectWithData:data
//                       options:NSJSONReadingMutableContainers
//                         error:&err];
//        advCustomFIlter.cycleDuration = 0;
//        if (textTemplateEffectConfig[@"duration"]) {
//            advCustomFIlter.cycleDuration = [textTemplateEffectConfig[@"duration"] floatValue];
//        }
//#if 0
//        {
//            NSArray *colors = textTemplateEffectConfig[@"color"];
//            float r = [(colors[0]) floatValue]/255.0;
//            float g = [(colors[1]) floatValue]/255.0;
//            float b = [(colors[2]) floatValue]/255.0;
//        }
//#endif
//        NSString * name = textTemplateEffectConfig[@"name"];
//        if( textTemplateEffectConfig[@"repeatMode"] )
//            advCustomFIlter.repeatMode = textTemplateEffectConfig[@"repeatMode"];
//        advCustomFIlter.name = name;
//        if (textTemplateEffectConfig[@"script"]) {
//            NSError * error = nil;
//            NSString *scriptPath = [configPath stringByAppendingPathComponent:textTemplateEffectConfig[@"script"]];
//            advCustomFIlter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
//            advCustomFIlter.scriptName = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
//        }
//    }
//
//    return advCustomFIlter;
}

+ (BOOL)CGImageRefContainsAlpha:(CGImageRef)imageRef {
    if (!imageRef) {
        return NO;
    }
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                      alphaInfo == kCGImageAlphaNoneSkipFirst ||
                      alphaInfo == kCGImageAlphaNoneSkipLast);
    return hasAlpha;
}

#pragma mark- 贴纸
+(void)getConfig_CaptionStickerEx:( CaptionEx * ) captionEx atCaptionConfig:( NSString * ) configPath atConfig:( NSDictionary** ) config
{
    @try {
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
                (*config) = subtitleEffectConfig;
                if(err) {
                    NSLog(@"json解析失败：%@",err);
                }
                
                captionEx.type =  CaptionExTypeStickers;
                CaptionImage * captionImage = [CaptionImage new];
                float   x = [subtitleEffectConfig[@"centerX"] floatValue];
                float   y = [subtitleEffectConfig[@"centerY"] floatValue];
                int     w = [subtitleEffectConfig[@"width"] intValue];
                int     h = [subtitleEffectConfig[@"height"] intValue];
                captionImage.imageFolderPath =[configPath stringByAppendingString:@"/"];
                captionImage.captionImagePath = captionImage.imageFolderPath;
                NSString * str = subtitleEffectConfig[@"blendMode"];
                if(  [str isEqualToString:@"screen"] )
                {
                    captionImage.blendType =  FilterBlendTypeScreen;
                }
                captionEx.position= CGPointMake(x, y);
//                captionEx.originalSize = CGSizeMake(w, h);
                captionImage.imageName = subtitleEffectConfig[@"name"];
                captionEx.scale = 1;
                captionImage.frameArray = subtitleEffectConfig[@"frameArray"];
                captionImage.timeArray = subtitleEffectConfig[@"timeArray"];
                captionEx.captionImage = captionImage;
                {
                    float duration = [subtitleEffectConfig[@"duration"] floatValue];
                    if( duration == 0 )
                    {
                        duration = 3.0;
                    }
                    captionEx.duration = duration;
                }
            }
        }
    }@catch (NSException * exception)
    {
        NSLog(@"%@",exception);
    }
}

#pragma mark- 气泡
+(void)getConfig_CaptionEx:( CaptionEx * ) captionEx atCaptionConfig:( NSString * ) configPath atConfig:( NSDictionary** ) config
{
    @try {
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
                if (config) {
                    (*config) = subtitleEffectConfig;
                }                
                if(err) {
                    NSLog(@"json解析失败：%@",err);
                }
                CaptionItem * captionItem = [CaptionItem new];
                
                captionEx.identifier = [VEHelp geCaptionExSubtitleIdentifier];
                
                float   x = [subtitleEffectConfig[@"centerX"] floatValue];
                float   y = [subtitleEffectConfig[@"centerY"] floatValue];
                int     w = [subtitleEffectConfig[@"width"] intValue];
                int     h = [subtitleEffectConfig[@"height"] intValue];
                captionItem.isVertical =  [subtitleEffectConfig[@"vertical"] boolValue];
                
                captionEx.imageFolderPath =[configPath stringByAppendingString:@"/"];
                captionEx.position= CGPointMake(x, y);
                captionEx.originalSize = CGSizeMake(w, h);
                captionEx.imageName = subtitleEffectConfig[@"name"];
                captionEx.scale = 1;
                captionItem.fontSize = 0.0;
                {
                    int fx = 0,fy = 0,fw = 0,fh = 0;
                    NSArray *textPadding = subtitleEffectConfig[@"textPadding"];
                    fx =  [textPadding[0] intValue];
                    fy =  [textPadding[1] intValue]+3;
                    fw =  [subtitleEffectConfig[@"textWidth"] intValue];
                    fh =  [subtitleEffectConfig[@"textHeight"] intValue];
                    captionEx.frameArray = subtitleEffectConfig[@"frameArray"];
                    captionEx.timeArray = subtitleEffectConfig[@"timeArray"];
                    captionItem.angle = 0;
                    captionEx.texts = [NSMutableArray<CaptionItem *> new];
                    captionEx.isStretch = [[subtitleEffectConfig objectForKey:@"stretchability"] boolValue];
                    if (captionEx.isStretch) {
                        double contentsCenter_x = [textPadding[0] doubleValue];
                        double contentsCenter_w = w - contentsCenter_x - [textPadding[2] doubleValue];
                        double contentsCenter_y = [textPadding[1] doubleValue];
                        double contentsCenter_h = h -contentsCenter_y - [textPadding[3] doubleValue];
                        captionEx.stretchRect = CGRectMake(contentsCenter_x/h, contentsCenter_y/h, contentsCenter_w/w, contentsCenter_h/h);
                        captionItem.frame = CGRectZero;
                        double t_left = [textPadding[0] doubleValue];
                        double t_right = [textPadding[2] doubleValue];
                        double t_top = [textPadding[1] doubleValue];
                        double t_buttom = [textPadding[3] doubleValue];
                        CGRect textRect = CGRectMake(t_left, t_top, w - t_left - t_right, h - t_top - t_buttom);
                        captionItem.padding = CGRectMake(textRect.origin.x/w, textRect.origin.y/h, textRect.size.width/w, textRect.size.height/h);
                    }else {
                        captionItem.frame = CGRectMake(fx, fy, fw, fh);
                    }
                    
                    {
                        captionItem.text = VELocalizedString(@"点击输入文字", nil);
                        if ([[NSFileManager defaultManager] fileExistsAtPath:kDefaultFontPath]) {
                            captionItem.fontPath = kDefaultFontPath;
                            captionItem.fontName = [VEHelp customFontArrayWithPath:kDefaultFontPath].firstObject;
                        }else {
                            captionItem.fontName = [[UIFont systemFontOfSize:10] fontName];
                        }
                        
                        NSArray *textColors = subtitleEffectConfig[@"textColor"];
                        float r = [(textColors[0]) floatValue]/255.0;
                        float g = [(textColors[1]) floatValue]/255.0;
                        float b = [(textColors[2]) floatValue]/255.0;
                        captionItem.textColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
                        captionItem.alpha = 1.0;
                        {
                            CaptionEffectColorParam * stroke = [CaptionEffectColorParam new];
                            stroke.colors = [NSMutableArray<CaptionEffectColor*> new];
                            stroke.gradient = false;
                            stroke.outlineWidth = [[subtitleEffectConfig objectForKey:@"strokeWidth"] floatValue]/2;
                            {
                                NSArray *strokeColors = subtitleEffectConfig[@"strokeColor"];
                                CaptionEffectColor * strokerColor = [CaptionEffectColor new];
                                strokerColor.color = [UIColor colorWithRed:[(strokeColors[0]) floatValue]/255.0
                                                                     green:[(strokeColors[0]) floatValue]/255.0
                                                                      blue:[(strokeColors[0]) floatValue]/255.0
                                                                     alpha:1];
                                strokerColor.factor = 1.0;
                                [stroke.colors addObject:strokerColor];
                            }
                            captionItem.stroke = stroke;
                        }
                        
                        if([subtitleEffectConfig objectForKey:@"tAngle"])
                            captionItem.angle = [[subtitleEffectConfig objectForKey:@"tAngle"] floatValue];
                        
                        float duration = [subtitleEffectConfig[@"duration"] floatValue];
                        if( duration == 0 )
                        {
                            duration = 3.0;
                        }
                        captionItem.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(duration, TIMESCALE));
                        captionEx.duration = duration;
                        [captionEx.texts addObject:captionItem];
                    }
                }
            }
        }
    }@catch (NSException * exception)
    {
        NSLog(@"%@",exception);
    }
}

+ (NSString *)getVerBationAnimationFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime {
    NSString *cachedFilePath = [KSubtitleAnimationFolder stringByAppendingPathComponent:[VEHelp cachedFileNameForKey:urlPath]];
    
    if([updatetime isKindOfClass:[NSString class]]){
        if( updatetime )
            cachedFilePath = [cachedFilePath stringByAppendingString:updatetime];
    }else{
        cachedFilePath = [cachedFilePath stringByAppendingString:[NSString stringWithFormat:@"%lld",[updatetime longLongValue]]];
    }
    return cachedFilePath;
}

+ (NSString *)getTransitionCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime {
    NSString *cachedFilePath = [kTransitionFolder stringByAppendingPathComponent:[VEHelp cachedFileNameForKey:urlPath]];
    cachedFilePath = [cachedFilePath stringByAppendingString:updatetime];
    return cachedFilePath;
}

+ (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}

#pragma mark- 特效创建
+(CustomMultipleFilter *)getCustomMultipleFilter:( NSDictionary * ) itemDic atPath:( NSString * ) path atTimeRange:( CMTimeRange ) timeRange atImage:( UIImage * ) FXFrameTexture atFXFrameTexturePath:( NSString * )  fXFrameTexturePath atEffectArray:( NSMutableArray * ) effectArray
{
    NSString *itemConfigPath = [path stringByAppendingPathComponent:@"config.json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:itemConfigPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    
    float duration = [effectDic[@"duration"] floatValue];
    if (duration > 0) {
        timeRange = CMTimeRangeMake(timeRange.start, CMTimeMakeWithSeconds(duration, TIMESCALE));
    }
    
    //图片截取 （ 定格 ）
    NSArray *textureParams = effectDic[@"textureParams"];
    __block UIImage *currentFrameTexture;
    [textureParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj objectForKey:@"paramName"] isEqualToString:@"currentFrameTexture"]) {
            //需要先截取当前帧
            currentFrameTexture = FXFrameTexture;
            *stop = YES;
        }
    }];
    
    CustomMultipleFilter * filterCustomFilter = nil;
    if (currentFrameTexture) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:kCurrentFrameTextureFolder]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:kCurrentFrameTextureFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString * ratingFrameTexturePath = fXFrameTexturePath;
//        [VEHelp getFileUrlWithFolderPath:kCurrentFrameTextureFolder fileName:@"currentFrameTexture.png"].path;
        if(ratingFrameTexturePath)
        {
            UIImage *image = [VEHelp image:currentFrameTexture withBackgroundColor:[UIColor blackColor]];//20210926 如获取的图片是带有alpha通道的，则需要填充背景色
            NSData* imagedata = UIImagePNGRepresentation(image);
            [[NSFileManager defaultManager] createFileAtPath:ratingFrameTexturePath contents:imagedata attributes:nil];
            imagedata = nil;
            
            filterCustomFilter = [VEHelp getCustomMultipleFilerWithFxId:[itemDic[@"id"] intValue] filterFxArray:effectArray timeRange:timeRange currentFrameTexturePath:ratingFrameTexturePath atPath:path];
        }
    }else {
        filterCustomFilter = [VEHelp getCustomMultipleFilerWithFxId:[itemDic[@"id"] intValue] filterFxArray:effectArray timeRange:timeRange currentFrameTexturePath:nil atPath:path];
    }
    
    return filterCustomFilter;
}
#pragma mark - 多脚本json加载 特效
+ (CustomMultipleFilter *)getCustomMultipleFilerWithFxId:(int)fxId
                             filterFxArray:(NSArray *)filterFxArray
                                 timeRange:(CMTimeRange)timeRange
                                 currentFrameTexturePath:(NSString *)currentFrameTexturePath
                                                  atPath:( NSString * ) path
{
    CustomMultipleFilter *customMultipleFilter = nil;
    NSMutableArray<CustomFilter*>* filterArray = [[NSMutableArray alloc] init];
    __block NSString *categoryId;
    __block NSString *resourceId;
    if (fxId == 0) {
//        NSString *bundlePath = [[NSBundle bundleForClass:self.class] pathForResource: @"VEEditSDK" ofType :@"bundle"];
//        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSBundle *resourceBundle =[VEHelp getBundle];
        path = [[resourceBundle resourcePath] stringByAppendingPathComponent:@"/jianji/effect_icon/shear/无"];
    }else {
        if (!filterFxArray || filterFxArray.count == 0) {
            return nil;
        }
        __block NSDictionary *itemDic;
        [filterFxArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj[@"data"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if ([obj1[@"id"] intValue] == fxId) {
                    categoryId = obj[@"typeId"];
                    resourceId = obj1[@"id"];
                    itemDic = obj1;
                    *stop1 = YES;
                    *stop = YES;
                }
            }];
        }];
        
        if( itemDic == nil )
        {
            return nil;
        }
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:currentFrameTexturePath]) {
        currentFrameTexturePath = [currentFrameTexturePath.stringByDeletingPathExtension stringByAppendingPathExtension:@"png"];
    }
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"]; // ok
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    NSArray* shaderArray = effectDic[@"effect"];
    if (shaderArray.count) {
        [shaderArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [filterArray addObject:[self getCustomFilterWithDictionary:obj folderPath:path categoryId:categoryId resourceId:resourceId fxId:fxId filterFxArray:filterFxArray timeRange:timeRange currentFrameTexturePath:currentFrameTexturePath]];
        }];
    }
    else
        [filterArray addObject:[self getCustomFilerWithFxId:fxId filterFxArray:filterFxArray timeRange:timeRange currentFrameTexturePath:currentFrameTexturePath atPath:path]];
    
    customMultipleFilter = [[CustomMultipleFilter alloc] initWithFilterArray:filterArray];
    
    customMultipleFilter.networkCategoryId = categoryId;
    customMultipleFilter.networkResourceId = resourceId;
    customMultipleFilter.folderPath = path;
    
    customMultipleFilter.timeRange = timeRange;
    
    return customMultipleFilter;
}

+ (CustomFilter *)getCustomFilerWithFxId:(int)fxId
                             filterFxArray:(NSArray *)filterFxArray
                                 timeRange:(CMTimeRange)timeRange
                   currentFrameTexturePath:(NSString *)currentFrameTexturePath
                                  atPath:( NSString * ) path
{
//    NSString *path;
    __block NSString *categoryId;
    __block NSString *resourceId;
    if (fxId == 0) {
//        NSString *bundlePath = [[NSBundle bundleForClass:self.class] pathForResource: @"VEEditSDK" ofType :@"bundle"];
//        NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
        NSBundle *resourceBundle =[VEHelp getBundle];
        path = [[resourceBundle resourcePath] stringByAppendingPathComponent:@"/jianji/effect_icon/shear/无"];
    }else {
        if (!filterFxArray || filterFxArray.count == 0) {
            return nil;
        }
        __block NSDictionary *itemDic;
        [filterFxArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj[@"data"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if ([obj1[@"id"] intValue] == fxId) {
                    categoryId = obj[@"typeId"];
                    resourceId = obj1[@"id"];
                    itemDic = obj1;
                    *stop1 = YES;
                    *stop = YES;
                }
            }];
        }];
//        path = [VEHelp getEffectCachedFilePath:itemDic[@"file"] updatetime:itemDic[@"updatetime"]];
//        NSInteger fileCount = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] count];
//        if (fileCount == 0) {
//            return nil;
//        }
//        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
//        NSString *folderName;
//        for (NSString *fileName in files) {
//            if (![fileName isEqualToString:@"__MACOSX"]) {
//                NSString *folderPath = [path stringByAppendingPathComponent:fileName];
//                BOOL isDirectory = NO;
//                BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDirectory];
//                if (isExists && isDirectory) {
//                    folderName = fileName;
//                    break;
//                }
//            }
//        }
//        if (folderName.length > 0) {
//            path = [path stringByAppendingPathComponent:folderName];
//        }
    }
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    customFilter.networkCategoryId = categoryId;
    customFilter.networkResourceId = resourceId;
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    NSError * error = nil;
    customFilter.folderPath = path;
    customFilter.name = effectDic[@"name"];
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
    NSString *fragPath = [path stringByAppendingPathComponent:effectDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:effectDic[@"vertShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    if (effectDic[@"script"]) {
        NSString *scriptPath = [path stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
    }
    
    NSString *builtIn = effectDic[@"builtIn"];
    if ([builtIn isEqualToString:@"illusion"]) {
        customFilter.builtInType = BuiltInFilter_illusion;
    }
    customFilter.timeRange = timeRange;
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
    [textureParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @autoreleasepool {
            TextureParams *param = [[TextureParams alloc] init];
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
            if (currentFrameTexturePath && [[obj objectForKey:@"paramName"] isEqualToString:@"currentFrameTexture"]) {
                param.type = TextureType_Sample2DMain;
                NSMutableArray *paths = [NSMutableArray arrayWithObject:currentFrameTexturePath];
                param.pathArray = paths;
            }else {
                NSString *sourceName = obj[@"source"];
                if ([sourceName isKindOfClass:[NSString class]]) {
                    if (sourceName.length > 0) {
                        param.type = TextureType_Sample2DBuffer;
                        NSMutableArray *paths = [NSMutableArray arrayWithObject:[path stringByAppendingPathComponent:sourceName]];
                        param.pathArray = paths;
                    }
                }else if ([sourceName isKindOfClass:[NSArray class]]) {
                    NSArray *sourceArray = obj[@"source"];
                    NSMutableArray *paths = [NSMutableArray array];
                    param.type = TextureType_Sample2DBuffer;
                    [sourceArray enumerateObjectsUsingBlock:^(NSString * _Nonnull imageName, NSUInteger idx1, BOOL * _Nonnull stop1) {
                        @autoreleasepool {
                            [paths addObject:[path stringByAppendingPathComponent:imageName]];
                        }
                    }];
                    param.pathArray = paths;
                }
            }
            [customFilter setShaderTextureParams:param];
        }
    }];
    
    return customFilter;
}

+ (CustomFilter *)getCustomFilterWithDictionary:(NSMutableDictionary*)effectDic
                                     folderPath:(NSString*)path
                                     categoryId:(NSString*)categoryId
                                     resourceId:(NSString*)resourceId
                                           fxId:(int)fxId
                                  filterFxArray:(NSArray *)filterFxArray
                                      timeRange:(CMTimeRange)timeRange
                        currentFrameTexturePath:(NSString *)currentFrameTexturePath
{
    //TODO:解析json新增的字段
    NSError * error = nil;
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    customFilter.networkCategoryId = categoryId;
    customFilter.networkResourceId = resourceId;
    
    customFilter.folderPath = path;
    customFilter.name = effectDic[@"name"];
    if(!customFilter.name) //必须设置名字，多脚本滤镜根据名字确定绘制顺序
        customFilter.name = @"linghunchuqiao";
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
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
    customFilter.timeRange = timeRange;
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
            if (currentFrameTexturePath && [[obj objectForKey:@"paramName"] isEqualToString:@"currentFrameTexture"]) {
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

+ (UIImage *)image:(UIImage *)image withBackgroundColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0);
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    UIRectFill(bounds);
    [image drawInRect:bounds blendMode:kCGBlendModeNormal alpha:1.0];
            
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
            
    return tintedImage;
}

+ (NSString *)getEffectCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime {
    NSString *cachedFilePath = [kSpecialEffectFolder stringByAppendingPathComponent:[VEHelp cachedFileNameForKey:urlPath]];
    cachedFilePath = [cachedFilePath stringByAppendingString:updatetime];
    return cachedFilePath;
}

+ (NSString *)getBoxCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime {
    NSString *cachedFilePath = [kBoxEffectFolder stringByAppendingPathComponent:[VEHelp cachedFileNameForKey:urlPath]];
    cachedFilePath = [cachedFilePath stringByAppendingString:updatetime];
    return cachedFilePath;
}

+ (NSString *)getSuperposiCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime {
    NSString *cachedFilePath = [kSuperposiEffectFolder stringByAppendingPathComponent:[VEHelp cachedFileNameForKey:urlPath]];
    cachedFilePath = [cachedFilePath stringByAppendingString:updatetime];
    return cachedFilePath;
}

+ (NSString *)getNetworkResourceCachedPathWithFolderPath:(NSString *)folderPath networkResourcePath:(NSString *)networkResourcePath updatetime:(NSString *)updatetime {
    NSString *cachedFilePath = [folderPath stringByAppendingPathComponent:[VEHelp cachedFileNameForKey:networkResourcePath]];
    cachedFilePath = [cachedFilePath stringByAppendingString:updatetime];
    return cachedFilePath;
}

+(MaskObject * )getMaskObject:(NSString *) maskName
{
    return [VEHelp getMaskWithName:maskName];
}

+(NSArray *)getShowFiles:( NSString * ) path
{
    NSArray * dirArray = nil;
    
    // 1.判断文件还是目录
    NSFileManager * fileManger = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL isExist = [fileManger fileExistsAtPath:path isDirectory:&isDir];
    
    if (isExist) {
        // 2. 判断是不是目录
        if (isDir) {
            dirArray = [fileManger contentsOfDirectoryAtPath:path error:nil];
        }
    }
    return dirArray;
}

+(NSString*)getBackgroundStyleConfigPath:(NSDictionary *)obj atPath:( NSString * ) folderPath
{
    NSString *pExtension = [[obj[@"file"] lastPathComponent] pathExtension];
    NSString *fileName = [[obj[@"file"] lastPathComponent] stringByDeletingPathExtension];
    
    NSString *name = fileName;
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *folderName = [NSString stringWithFormat:@"/%@",[[obj[@"file"] stringByDeletingLastPathComponent] lastPathComponent]];
    NSString *path = [NSString stringWithFormat:@"%@%@/%@.%@",folderPath,folderName,fileName,pExtension];
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
    
    configPath = [NSString stringWithFormat:@"%@/%@.%@",[path stringByDeletingLastPathComponent],name,pExtension];
    
    return configPath;
}

+(float)getMediaAssetScale:( CGSize ) size atRect:(CGRect) rect atCorp:(CGRect) corp atSyncContainerHeihgt:(CGSize) syncContainerSize atIsWatermark:(BOOL) isWatermark
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
    
    CGSize screenWidthSize = CGSizeMake(syncContainerSize.height*( size.width /size.height ) , syncContainerSize.height);
    
    if( size.width < size.height )
    {
        scale = rect.size.height*syncContainerSize.height/size.height;
    }
    else{
//        screenWidthSize = CGSizeMake(syncContainerSize.width, syncContainerSize.width*( size.height /size.width ) );
//        if( screenWidthSize.height < syncContainerSize.height )
//        {
//            scale = rect.size.width*syncContainerSize.width/size.width;
//        }
//        else{
//            if( size.width < size.height )
//                scale = rect.size.height*syncContainerSize.height/size.height;
//            else
        scale = rect.size.width*syncContainerSize.width/size.width;
//        }
    }
//    if( syncContainerSize.width < syncContainerSize.height )
//    {
//        cgsizs
//
//        if( size.width < size.height )
//            scale = rect.size.height*syncContainerSize.height/size.height;
//        else
//            scale = rect.size.width*syncContainerSize.width/size.width;
//    }
//    else
//    {
//        if( size.width > size.height )
//            scale = rect.size.width*syncContainerSize.width/size.width;
//        else
//            scale = rect.size.height*syncContainerSize.height/size.height;
//    }
    
    return scale;
}

+(CGSize)URL_ImageSize:(NSURL *) url atCrop:(CGRect) crop
{
    UIImage *image = [VEHelp getFullScreenImageWithUrl:url];
    
    CGSize size = CGSizeZero;
    
    if( ![VEHelp isImageUrl:url] )
    {
        image = [VEHelp geScreenShotImageFromVideoURL:url atTime:CMTimeMakeWithSeconds(0.1, TIMESCALE) atSearchDirection:FALSE];
        
        AVURLAsset *asset = [AVURLAsset assetWithURL:url];
        
        NSArray *tracks = [asset tracksWithMediaType:AVMediaTypeVideo];
        if([tracks count] > 0) {
            AVAssetTrack *videoTrack = [tracks objectAtIndex:0];
            size = CGSizeApplyAffineTransform(videoTrack.naturalSize, videoTrack.preferredTransform);
        }
    }
    
    image = [VEHelp image:image rotation:0 cropRect:crop];
    return image.size;
}

+(CGRect)pasterView_RectinScene:(CGSize) size atRect:(CGRect) rect atSyncContainerSize:(CGSize) syncContainerSize atScale:(float *) scale atOtherSyncontainerSize:(CGSize) otherSyncContainerSize
{
//    float scale;
    float width;
    float height;
    if (syncContainerSize.width == syncContainerSize.height) {
        width = syncContainerSize.width/4.0;
        height = width / (size.width / size.height);
    }else if (syncContainerSize.width < syncContainerSize.height) {
        width = syncContainerSize.width/2.0;
        height = width / (size.width / size.height);
    }else {
        height = syncContainerSize.height/2.0;
        width = height * (size.width / size.height);
    }
    
    float fwidth = otherSyncContainerSize.width*rect.size.width/(*scale);
    float fheight = otherSyncContainerSize.height*rect.size.height/(*scale);
    
    CGPoint point = CGPointMake(rect.origin.x +  rect.size.width/2.0, rect.origin.y + rect.size.height/2.0);
    
    if( fwidth > fheight )
    {
        (*scale) = rect.size.width*syncContainerSize.width/width;
        rect.size = CGSizeMake(rect.size.width, height*(*scale)/ syncContainerSize.height);
    }
    else{
        (*scale) = rect.size.height*syncContainerSize.height/height;
        rect.size = CGSizeMake(width*(*scale)/ syncContainerSize.width, rect.size.height);
    }
    rect.origin = CGPointMake(point.x - rect.size.width/2.0, point.y - rect.size.height/2.0);
//    CGPoint point = CGPointMake(rect.origin.x +  rect.size.width/2.0, rect.origin.y + rect.size.height/2.0);
//
//    rect.size = CGSizeMake(width*scale/syncContainerSize.width, height*scale / syncContainerSize.height);
//    rect.origin = CGPointMake(point.x - rect.size.width/2.0, point.y - rect.size.height/2.0);
    return rect;
}

+(CGRect)getCrop:( CGSize ) size atOriginalSize:( CGSize ) originalSize
{
    float videoR = size.width / size.height;
    
    CGRect rect = CGRectZero;
    if ( originalSize.width > originalSize.height) {
        
        if( videoR > 1.0 ){
            float croporiginX = 0;
            float croporiginY = 0+ (originalSize.height -originalSize.width/videoR)/2;
            float cropWidth = originalSize.width;
            float cropHeight = originalSize.width /videoR;
            rect = CGRectMake(croporiginX/originalSize.width, croporiginY/originalSize.height, cropWidth/originalSize.width, cropHeight/originalSize.height);
        }else{
            float croporiginX = 0+ (originalSize.width - originalSize.height *size.width/size.height)/2;
            float croporiginY = 0;
            float cropWidth = originalSize.height *size.width/size.height;
            float cropHeight = originalSize.height;
            rect = CGRectMake(croporiginX/originalSize.width, croporiginY/originalSize.height, cropWidth/originalSize.width, cropHeight/originalSize.height);
        }
    }else{
        if (videoR > originalSize.width / originalSize.height) {
            float  croporiginX = 0;
            float  croporiginY = 0 + (originalSize.height - originalSize.width* size.height/size.width)/2;
            float  cropWidth = originalSize.width;
            float  cropHeight = originalSize.width* size.height/size.width;
            rect = CGRectMake(croporiginX/originalSize.width, croporiginY/originalSize.height, cropWidth/originalSize.width, cropHeight/originalSize.height);
        }else{
            
            float  croporiginX = 0+ (originalSize.width - originalSize.height *size.width/size.height)/2;
            float  croporiginY = 0;
            float  cropWidth = originalSize.height *size.width/size.height;
            float  cropHeight = originalSize.height;
            rect = CGRectMake(croporiginX/originalSize.width, croporiginY/originalSize.height, cropWidth/originalSize.width, cropHeight/originalSize.height);
        }
    }
    return rect;
}

+(UIImage*) imageWithColor:(UIColor*)color atSize:( CGSize ) size
{

    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

   CGContextSetFillColorWithColor(context, [color CGColor]);

    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return image;
}

+(void )getOriginaImage:( CVPixelBufferRef  ) originaImage atGrayscaleImage:( CVPixelBufferRef ) grayscaleImage atSize:( CGSize ) size
{
    @autoreleasepool {
        NSAssert(CVPixelBufferGetPixelFormatType(originaImage) == kCVPixelFormatType_32BGRA,
                 @"Image buffer must have 32BGRA pixel format type");
        size_t width = CVPixelBufferGetWidth(grayscaleImage);
        size_t height = CVPixelBufferGetHeight(grayscaleImage);
        NSAssert(CVPixelBufferGetWidth(originaImage) == width, @"Height must match");
        NSAssert(CVPixelBufferGetHeight(originaImage) == height, @"Width must match");
        
        CVPixelBufferLockBaseAddress(originaImage, 0);
        CVPixelBufferLockBaseAddress(grayscaleImage, 0);
        
        unsigned char *tempAddress = (unsigned char *)CVPixelBufferGetBaseAddress(grayscaleImage);
        size_t maskBytesPerRow = CVPixelBufferGetBytesPerRow(grayscaleImage);
        
        unsigned char *imageAddress = (unsigned char *)CVPixelBufferGetBaseAddress(originaImage);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(originaImage);
        static const int kBGRABytesPerPixel = 4;
        
        for (int row = 0; row < height; ++row) {
            for (int col = 0; col < width; ++col) {
                int pixelOffset = col * kBGRABytesPerPixel;
                int alphaOffset = pixelOffset + 3;
                
                float tempAddressAlpha = tempAddress[alphaOffset];
                
                imageAddress[alphaOffset] = tempAddressAlpha;
            }
            imageAddress += bytesPerRow / sizeof(unsigned char);
            tempAddress += maskBytesPerRow / sizeof(unsigned char);
        }
        CVPixelBufferUnlockBaseAddress(originaImage, 0);
        CVPixelBufferUnlockBaseAddress(grayscaleImage, 0);
        if (grayscaleImage) {
            CVPixelBufferRelease(grayscaleImage);
        }
    }
}




+ (NSMutableArray *)getAnimationArrayWithAppkey:(NSString *)appKey
                             typeUrlPath:(NSString *)typeUrlPath
                    specialEffectUrlPath:(NSString *)specialEffectUrlPath{
    return [self getCategoryMaterialWithAppkey:appKey typeUrlPath:typeUrlPath materialUrlPath:specialEffectUrlPath materialType:kVEANIMATION];
}

+ (NSMutableArray *)getCategoryMaterialWithAppkey:(NSString *)appKey
                                      typeUrlPath:(NSString *)typeUrlPath
                                  materialUrlPath:(NSString *)materialUrlPath
                                     materialType:(VECustomizationFunctionType)materialType{
    __block NSMutableArray *materialArray = [NSMutableArray array];
    NSString *type;
    NSString *folderPath;
    NSString *plistPath;
    if(appKey == nil){
        return  nil;
    }
    VEReachability *lexiu = [VEReachability reachabilityForInternetConnection];
    if (materialType == kVEEFFECTS) {
        plistPath = kNewSpecialEffectPlistPath;
        folderPath = kSpecialEffectFolder;
        type = @"specialeffects";
    }
    else if (materialType == KTRANSITION) {
        plistPath = kTransitionPlistPath;
        folderPath = kTransitionFolder;
        type = @"transition";
    }else if (materialType == kVETEXTTITLE) {//字幕
        plistPath = kSubtitlePlistPath;
        folderPath = kSubtitleFolder;
        type = @"sub_title";
    }else if (materialType == kVEMUSICAE) {
        plistPath = kMusicAnimatePlistPath;
        folderPath = kMVAnimateFolder;
        type = @"mvae2";
    }else if (materialType == kTEMPLATERECORD) {
        plistPath = kTemplateRecordPlist;
        folderPath = kTemplateRecordFolder;
        type = @"recorderae";
    } else if(materialType ==  KSTICKERANIMATION)//贴纸动画
    {
        plistPath = kStickerAnimationPath;
        folderPath = KStickerAnimationFolder;
        type = @"ani_sticker";
    }
    else if( kVEANIMATION == materialType )//动画
    {
        plistPath = kAnimationPath;
        folderPath = KAnimationFolder;
        type = @"animate";
    }
    NSMutableArray *oldMaterialArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
    if ([lexiu currentReachabilityStatus] == VEReachabilityStatus_NotReachable) {
        materialArray = oldMaterialArray;
    }else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:appKey forKey:@"appkey"];
        [params setObject:type forKey:@"type"];
        NSDictionary *typeDic = [self getNetworkMaterialWithParams:params
                                                                   appkey:appKey
                                                                  urlPath:typeUrlPath];
        if (typeDic && [typeDic[@"code"] intValue] == 0) {
            NSMutableArray *typeArray = typeDic[@"data"];
            if(KBGSTYLE == materialType)
            {
                if( (oldMaterialArray == nil) || (oldMaterialArray.count == 0) || (oldMaterialArray.count != typeArray.count ) )
                {
                    materialArray = typeArray;
                }
                else
                {
                    [typeArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        NSString *updateTime = obj[@"updatetime"];
                        if ([updateTime isKindOfClass:[NSNumber class]]) {
                            updateTime = [obj[@"updatetime"] stringValue];
                        }
                        int ID = [obj[@"id"] intValue];
                        NSString *oldUpdateTime = oldMaterialArray[idx][@"updatetime"];
                        if ([oldUpdateTime isKindOfClass:[NSNumber class]]) {
                            oldUpdateTime = [oldMaterialArray[idx][@"updatetime"] stringValue];
                        }
                        int oldID = [oldMaterialArray[idx][@"id"] intValue];
                        if( (oldUpdateTime && ![oldUpdateTime isEqualToString:updateTime]) || (ID != oldID) )
                        {
                            [materialArray addObject:obj];
                        }
                        else
                        {
                            if( oldMaterialArray.count > idx )
                            {
                                [materialArray addObject:oldMaterialArray[idx]];
                            }
                        }
                        
                        
                    }];
                }
            }
            else if( (materialType == kVETEXTTITLE) || (materialType == KTRANSITION)  )
            {
                if( (oldMaterialArray == nil) || (oldMaterialArray.count == 0) || (oldMaterialArray.count != typeArray.count )  )
                {
                    materialArray = typeArray;
                }
                else
                {
                    [typeArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        NSString *updateTime = obj[@"updatetime"];
                        if ([updateTime isKindOfClass:[NSNumber class]]) {
                            updateTime = [obj[@"updatetime"] stringValue];
                        }
                        int ID = [obj[@"id"] intValue];
                        NSString *oldUpdateTime = oldMaterialArray[idx][@"updatetime"];
                        if ([oldUpdateTime isKindOfClass:[NSNumber class]]) {
                            oldUpdateTime = [oldMaterialArray[idx][@"updatetime"] stringValue];
                        }
                        int oldID = [oldMaterialArray[idx][@"id"] intValue];
                        if( (oldUpdateTime && ![oldUpdateTime isEqualToString:updateTime]) || (ID != oldID) )
                        {
                            [materialArray addObject:obj];
                        }
                        else
                        {
                            if( oldMaterialArray.count > idx )
                                [materialArray addObject:oldMaterialArray[idx]];
                        }
                    }];
                }
            }
            else
            {
                [typeArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setObject:type forKey:@"type"];
                    [params setObject:[NSNumber numberWithInt:[obj[@"id"] intValue]] forKey:@"category"];
                    NSDictionary *resultDic = [self getNetworkMaterialWithParams:params
                                                                                 appkey:appKey
                                                                                urlPath:materialUrlPath];
                    if (resultDic && [resultDic[@"code"] intValue] == 0) {
                        NSMutableArray *array = [resultDic[@"data"] mutableCopy];
                        
                        if (materialType == kVEEFFECTS) {
                            NSString *coverPath = [VEHelp getEditResource:@"/jianji/effect_icon/剪辑-编辑-特效-无" type:@"png"];
                            NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
                            [itemDic setObject:coverPath forKey:@"cover"];
                            [itemDic setObject:@"无" forKey:@"name"];
                            [itemDic setObject:[NSNumber numberWithInt:0] forKey:@"id"];
                            [itemDic setObject:@"1546936928" forKey:@"updatetime"];
                            [array insertObject:itemDic atIndex:0];
                        }
                        
                        NSMutableDictionary *materialDic = [NSMutableDictionary new];
                        if(obj[@"name"])
                        [materialDic setObject:obj[@"name"] forKey:@"typeName"];
                        if(obj[@"icon_checked"])
                        [materialDic setObject:obj[@"icon_checked"] forKey:@"icon_checked"];
                        if(obj[@"icon_unchecked"])
                        [materialDic setObject:obj[@"icon_unchecked"] forKey:@"icon_unchecked"];
                        [materialDic setObject:[NSNumber numberWithInt:[obj[@"id"] intValue]] forKey:@"typeId"];
                        if(array)
                        [materialDic setObject:array forKey:@"data"];
                        [materialArray addObject:materialDic];
                        
                        if (oldMaterialArray.count > 0) {
                            NSFileManager *fileManager = [NSFileManager defaultManager];
                            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                                NSString *file = [obj1[@"file"] stringByDeletingPathExtension];
                                NSString *updateTime = [NSString stringWithFormat:@"%lld",[obj1[@"updatetime"] longLongValue]];
                                __block NSString *oldUpdateTime;
                                __block NSString *oldFile;
                                [oldMaterialArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                                    if ([obj2[@"typeId"] intValue] ==[obj[@"id"] intValue]) {
                                        [obj2[@"data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
                                            if ([[obj3[@"file"] stringByDeletingPathExtension] isEqualToString:file]) {
                                                oldFile = obj3[@"file"];
                                                oldUpdateTime = [NSString stringWithFormat:@"%lld",[obj3[@"updatetime"] longLongValue]];
                                                *stop3 = YES;
                                                *stop2 = YES;
                                            }
                                        }];
                                    }
                                }];
                                if(oldUpdateTime && ![oldUpdateTime isEqualToString:updateTime])
                                {
                                    NSString *path;
                                    if (materialType == kVETEXTTITLE) {//字幕
                                        path = [kSubtitlePlistPath stringByAppendingPathComponent:file];
                                    }else {
                                        path = [self getMaterialCachedFilePath:materialType netFilePath:oldFile updatetime:oldUpdateTime];
                                    }
                                    if ([fileManager fileExistsAtPath:path]) {
                                        [fileManager removeItemAtPath:path error:nil];
                                    }
                                }
                            }];
                        }
                    }
                }];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            BOOL suc = [materialArray writeToFile:plistPath atomically:YES];
            if (!suc) {
                //NSLog(@"写入失败");
            }
        }
        [oldMaterialArray removeAllObjects];
        oldMaterialArray = nil;
    }
    return materialArray;
}

+ (NSString *)getMaterialCachedFilePath:(VECustomizationFunctionType)materialType netFilePath:(NSString *)netFilePath updatetime:(NSString *)updatetime {
    NSString *folderPath;
    switch (materialType) {
        case kVEMUSICAE:
            folderPath = kMVAnimateFolder;
            break;
            
        case kVEEFFECTS:
            folderPath = kSpecialEffectFolder;
            break;
        
        case KTRANSITION:
            folderPath = kTransitionFolder;
            break;
            
        case kTEMPLATERECORD:
            folderPath = kTemplateRecordFolder;
            break;
            
        default:
            break;
    }
    if (folderPath.length == 0) {
        return nil;
    }
    NSString *cachedFilePath = [folderPath stringByAppendingPathComponent:[self cachedFileNameForKey:netFilePath]];
    cachedFilePath = [NSString stringWithFormat:@"%@%@", cachedFilePath, updatetime];
    return cachedFilePath;
}


+ (void)downloadIconFile:(VEAdvanceEditType)type
              editConfig:(VEEditConfiguration *)editConfig
                  appKey:(NSString *)appKey
               cancelBtn:(UIButton *)cancelBtn
           progressBlock:(void(^)(float progress))progressBlock
                callBack:(void(^)(NSError *error))callBack
             cancelBlock:(void(^)(void))cancelBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //创建文件夹
        if(![[NSFileManager defaultManager] fileExistsAtPath:kSubtitleEffectFolder]){
            [[NSFileManager defaultManager] createDirectoryAtPath:kSubtitleEffectFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
        switch (type) {
            case VEAdvanceEditType_Subtitle:
            {
                [self getCategoryMaterialWithAppkey:appKey
                                        typeUrlPath:editConfig.netMaterialTypeURL
                                    materialUrlPath:editConfig.subtitleResourceURL
                                       materialType:kVETEXTTITLE];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (callBack) {
                        callBack(nil);
                    }
                });
            }
                break;
            case VEAdvanceEditType_Sticker:
            {
                if (editConfig.netMaterialTypeURL.length > 0 && editConfig.effectResourceURL.length > 0) {
                    __block NSDictionary *dic;
                    __block BOOL hasValue = NO;
                    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"stickers",@"type", nil];
                     [self getNetworkMaterialWithParams:params
                                                             appkey:appKey
                                                            urlPath:editConfig.netMaterialTypeURL completed:^(id result, NSError *error) {
                        
                         dic = result;
                        hasValue = [[dic objectForKey:@"code"] integerValue]  == 0;
                       if( (hasValue && [[dic objectForKey:@"data"] count] > 0) ){
                           NSMutableArray *resultList;
                           if([[dic allKeys] containsObject:@"result"]){
                               resultList = [[dic objectForKey:@"result"] objectForKey:@"bgmusic"];
                           }else{
                               if([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]]){
                                   resultList = [dic objectForKey:@"data"];
                               }else{
                                   resultList = [dic objectForKey:@"data"][@"data"];
                               }
                           }
                           if(resultList){
                               if(![[NSFileManager defaultManager] fileExistsAtPath:kStickerFolder]){
                                   [[NSFileManager defaultManager] createDirectoryAtPath:kStickerFolder withIntermediateDirectories:YES attributes:nil error:nil];
                               }

                               BOOL suc = [resultList writeToFile:kStickerTypesPath atomically:YES];
                             
                               if ([[NSFileManager defaultManager] fileExistsAtPath:kStickerPlistPath]) {
                                   [[NSFileManager defaultManager] removeItemAtPath:kStickerPlistPath error:nil];
                               }
                               if (!suc) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       if (callBack) {
                                           NSString *message = VELocalizedString(@"贴纸分类信息，保存失败！", nil);
                                           NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
                                           NSError *error = [NSError errorWithDomain:VECustomErrorDomain code:VESDKErrorCode_DownloadSubtitle userInfo:userInfo];
                                           callBack(error);
                                       }
                                   });
                               }

                               NSMutableArray * stickerArray = [NSMutableArray new];

                               for (int i = 0; i < resultList.count; i++) {

                                   NSMutableDictionary *params = [NSMutableDictionary dictionary];
                                   [params setObject:@"stickers" forKey:@"type"];
                                   [params setObject:[resultList[i] objectForKey:@"id"]  forKey:@"category"];
                                   [params setObject:[NSString stringWithFormat:@"%d" ,0] forKey: @"page_num"];
                                   NSDictionary *dic2 = [VEHelp getNetworkMaterialWithParams:params
                                                                                           appkey:appKey urlPath:editConfig.effectResourceURL];
                                   if(dic2 && [[dic2 objectForKey:@"code"] integerValue] == 0)
                                   {
                                       NSMutableArray * currentStickerList = [dic2 objectForKey:@"data"];
                                       [stickerArray addObject:currentStickerList];
                                   }
                                   else
                                   {
                                       if (callBack) {
                                           NSString *message;
                                           if (dic) {
                                               if ([[dic2 objectForKey:@"code"] integerValue]) {
                                                   message = dic2[@"msg"];
                                               }else {
                                                   message = dic2[@"message"];
                                               }
                                           }
                                           if (!message || message.length == 0) {
                                               message = VELocalizedString(@"下载失败，请检查网络!", nil);
                                           }
                                           NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
                                           NSError *error = [NSError errorWithDomain:VECustomErrorDomain code:VESDKErrorCode_DownloadSubtitle userInfo:userInfo];
                                           callBack(error);
                                       }
                                   }
                               }

                               [self updateLocalMaterialWith:VEAdvanceEditType_Sticker newList:stickerArray];
                               suc = [stickerArray writeToFile:kNewStickerPlistPath atomically:YES];

                               dispatch_async(dispatch_get_main_queue(), ^{
                                   if (callBack) {
                                       callBack(nil);
                                   }
                               });
                           }
                           else
                           {
                               if (callBack) {
                                   NSString *message;
                                   if (dic) {
                                       if (hasValue) {
                                           message = dic[@"msg"];
                                       }else {
                                           message = dic[@"message"];
                                       }
                                   }
                                   if (!message || message.length == 0) {
                                       message = VELocalizedString(@"下载失败，请检查网络!", nil);
                                   }
                                   NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
                                   NSError *error = [NSError errorWithDomain:VECustomErrorDomain code:VESDKErrorCode_DownloadSubtitle userInfo:userInfo];
                                   callBack(error);
                               }
                           }
                       }
                       else
                       {
                           [self oldDownloadIconFileSticker:type editConfig:editConfig appKey:appKey cancelBtn:cancelBtn progressBlock:progressBlock callBack:callBack cancelBlock:cancelBlock];
                       }
                     }];
                   
                }else
                {
                    [self oldDownloadIconFileSticker:type editConfig:editConfig appKey:appKey cancelBtn:cancelBtn progressBlock:progressBlock callBack:callBack cancelBlock:cancelBlock];
                }
            }
                break;
                
            case VEAdvanceEditType_None:
            {
                BOOL hasNewFont =  editConfig.fontResourceURL.length>0;
                NSString *uploadUrl = (hasNewFont ? editConfig.fontResourceURL : getFontTypeUrl);
                NSMutableDictionary *fontListDic;
                if(hasNewFont){
                    fontListDic = [self getNetworkMaterialWithType:kFontType
                                                                   appkey:appKey
                                                                  urlPath:uploadUrl];
                }else{
                    fontListDic = [self updateInfomation:nil andUploadUrl:uploadUrl];
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
                            NSError *error = [NSError errorWithDomain:VECustomErrorDomain code:VESDKErrorCode_DownloadSubtitle userInfo:userInfo];
                            callBack(error);
                        }
                    });
                    return;
                }
                NSArray *fontList = [fontListDic objectForKey:@"data"];
                NSDictionary *fontIconDic = [fontListDic objectForKey:@"icon"];
                NSString *iconUrl = [fontIconDic objectForKey:@"caption"];
                NSString *cacheFolderPath = [[self pathFontForURL:[NSURL URLWithString:iconUrl]] stringByDeletingLastPathComponent];
                NSString *cacheIconPath = [cacheFolderPath stringByAppendingPathComponent:@"icon"];
                if(![[NSFileManager defaultManager] fileExistsAtPath:cacheFolderPath]){
                    [[NSFileManager defaultManager] createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                
                if([[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheIconPath error:nil].count==0 && !hasNewFont){
                    //将plist文件写入文件夹
                    BOOL suc = [fontList writeToFile:kFontPlistPath atomically:YES];
                    suc = [fontIconDic writeToFile:kFontIconPlistPath atomically:YES];
                    
                    [VEFileDownloader downloadFileWithURL:iconUrl cachePath:cacheFolderPath HTTPMethod:VEGET cancelBtn:cancelBtn progress:^(NSNumber *numProgress) {
                        NSLog(@"progress:%f",[numProgress floatValue]);
                        if(progressBlock){
                            progressBlock([numProgress floatValue]);
                        }
                    } finish:^(NSString *fileCachePath) {
                        [VEHelp OpenZipp:fileCachePath unzipto:cacheFolderPath];
                        if (callBack) {
                            callBack(nil);
                        }
                    } fail:^(NSError *error) {
                        if (callBack) {
                            callBack(error);
                        }
                    } cancel:^{
                        if (cancelBlock) {
                            cancelBlock();
                        }
                    }];
                }else{
                    [self updateLocalMaterialWithType:type newList:fontList];
                    BOOL suc = [fontList writeToFile:kFontPlistPath atomically:YES];
                    suc = [fontIconDic writeToFile:kFontIconPlistPath atomically:YES];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (callBack) {
                            callBack(nil);
                        }
                    });
                }
            }
                break;
                
            default:
                break;
        }
    });
}

+(void)updateLocalMaterialWith:(VEAdvanceEditType)type newList:( NSArray * ) newList
{
    NSString *folderPath;
    if (type == VEAdvanceEditType_Subtitle) {
        folderPath = kSubtitleFolder;
    }else if (type == VEAdvanceEditType_Sticker) {
        folderPath = kStickerFolder;
    }else {
        folderPath = kFontFolder;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *oldList = nil;
    if (type == VEAdvanceEditType_Sticker) {
        oldList = [[NSArray alloc] initWithContentsOfFile:kNewStickerPlistPath];
    }else {
        return;
    }
    [oldList enumerateObjectsUsingBlock:^(NSArray * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            NSString *oldId = obj1[@"id"];
            NSString *oldUpdateTime = obj1[@"updatetime"];
            if ([oldUpdateTime isKindOfClass:[NSNumber class]]) {
                oldUpdateTime = [obj1[@"updatetime"] stringValue];
            }
            __block NSString *newUpdateTime;
            [newList enumerateObjectsUsingBlock:^(NSArray * _Nonnull newObj, NSUInteger newIdx, BOOL * _Nonnull newStop) {
                [newObj enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull newObj1, NSUInteger newIdx1, BOOL * _Nonnull newStop1) {
                    if ([newObj1[@"id"] isEqual:oldId]) {
                        newUpdateTime = newObj1[@"updatetime"];
                        if ([newUpdateTime isKindOfClass:[NSNumber class]]) {
                            newUpdateTime = [newObj1[@"updatetime"] stringValue];
                        }
                        *newStop1 = YES;
                        *newStop = YES;
                    }
                }];
            }];
            if (!newUpdateTime || ![newUpdateTime isEqualToString:oldUpdateTime]) {
                NSString *file = [[obj1[@"file"] stringByDeletingLastPathComponent] lastPathComponent];
                NSString *path = [folderPath stringByAppendingPathComponent:file];
                if ([fileManager fileExistsAtPath:path]) {
                    [fileManager removeItemAtPath:path error:nil];
                }
            }
        }];
    }];
}

+ (void)oldDownloadIconFileSticker:(VEAdvanceEditType)type
                     editConfig:(VEEditConfiguration *)editConfig
                         appKey:(NSString *)appKey
                      cancelBtn:(UIButton *)cancelBtn
                  progressBlock:(void(^)(float progress))progressBlock
                       callBack:(void(^)(NSError *error))callBack
                    cancelBlock:(void(^)(void))cancelBlock
{
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:kStickerTypesPath]) {
            [fileManager removeItemAtPath:kStickerTypesPath error:nil];
        }
        if ([fileManager fileExistsAtPath:kNewStickerPlistPath]) {
            [fileManager removeItemAtPath:kNewStickerPlistPath error:nil];
        }
        
    }
    
    
    BOOL hasNewEffect =  editConfig.effectResourceURL.length>0;
    NSString *uploadUrl = (hasNewEffect ? editConfig.effectResourceURL : getEffectTypeUrl);
    NSMutableDictionary *effectTypeList;
    if(hasNewEffect){
        effectTypeList = [self getNetworkMaterialWithType:@"effects"
                                                          appkey:appKey
                                                         urlPath:uploadUrl];
    }else{
        effectTypeList = [self updateInfomation:nil andUploadUrl:uploadUrl];
    }
    
    if(![effectTypeList isKindOfClass:[NSMutableDictionary class]] || !effectTypeList || (hasNewEffect ? ([effectTypeList[@"code"] intValue] != 0) : ([effectTypeList[@"code"] intValue] != 200))){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callBack) {
                NSString *message;
                if (effectTypeList) {
                    if (hasNewEffect) {
                        message = effectTypeList[@"msg"];
                    }else {
                        message = effectTypeList[@"message"];
                    }
                }
                if (!message || message.length == 0) {
                    message = VELocalizedString(@"下载失败，请检查网络!", nil);
                }
                NSDictionary *userInfo = [NSDictionary dictionaryWithObject:message forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:VECustomErrorDomain code:VESDKErrorCode_DownloadSubtitle userInfo:userInfo];
                callBack(error);
            }
        });
        return ;
    }
    NSArray *effectList = [effectTypeList objectForKey:@"data"];
    NSDictionary *effectIconDic = [effectTypeList objectForKey:@"icon"];
    
    NSString *effectIconUrl = [effectIconDic objectForKey:@"caption"];
    NSString *cacheEffectFolderPath = [[self pathEffectForURL:[NSURL URLWithString:effectIconUrl]] stringByDeletingLastPathComponent];
    NSString *cacheIconPath = [cacheEffectFolderPath stringByAppendingPathComponent:@"icon"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:cacheEffectFolderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheEffectFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if([[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheIconPath error:nil].count==0 && !hasNewEffect){
        //将plist文件写入文件夹
        BOOL suc = [effectList writeToFile:kStickerPlistPath atomically:YES];
        suc = [effectIconDic writeToFile:kStickerIconPlistPath atomically:YES];
        
        [VEFileDownloader downloadFileWithURL:effectIconUrl cachePath:cacheEffectFolderPath HTTPMethod:VEGET cancelBtn:cancelBtn progress:^(NSNumber *numProgress) {
            NSLog(@"progress:%f",[numProgress floatValue]);
            if(progressBlock){
                progressBlock([numProgress floatValue]);
            }
        } finish:^(NSString *fileCachePath) {
            [VEHelp OpenZipp:fileCachePath unzipto:cacheEffectFolderPath];
            if (callBack) {
                callBack(nil);
            }
        } fail:^(NSError *error) {
            if (callBack) {
                callBack(error);
                
            }
        } cancel:^{
            if (cancelBlock) {
                cancelBlock();
                
            }
        }];
    }else{
        [self updateLocalMaterialWithType:type newList:effectList];
        BOOL suc = [effectList writeToFile:kStickerPlistPath atomically:YES];
        suc = [effectIconDic writeToFile:kStickerIconPlistPath atomically:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callBack) {
                callBack(nil);
            }
        });
    }
}
+(NSString *)pathEffectForURL:(NSURL *)aURL{
    return [kStickerFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"EffectType-%lu.zip", (unsigned long)[[aURL description] hash]]];
}

+ (NSMutableArray *)getStickerAnimationArrayWithAppkey:(NSString *)appKey
                             typeUrlPath:(NSString *)typeUrlPath
                    specialEffectUrlPath:(NSString *)specialEffectUrlPath{
    
    return [self getCategoryMaterialWithAppkey:appKey typeUrlPath:typeUrlPath materialUrlPath:specialEffectUrlPath materialType:KSTICKERANIMATION];
}
+ (NSString *)getStickerAnimationFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime {
    NSString *cachedFilePath = [KStickerAnimationFolder stringByAppendingPathComponent:[self cachedFileNameForKey:urlPath]];
    cachedFilePath = [cachedFilePath stringByAppendingString:updatetime];
    return cachedFilePath;
}
+ (CustomFilter *)getOverlayAnimationCustomFilterWithPath:(NSString *) path typeIndex:(NSInteger)typeIndex atCaption:( Overlay *) overlay
{
    NSInteger fileCount = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] count];
    if (fileCount == 0) {
        return nil;
    }
    
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    if( typeIndex == 0 )
    {
        customFilter.animateType = CustomAnimationTypeIn;
    }
    else if( typeIndex == 1 )
    {
        customFilter.animateType = CustomAnimationTypeOut;
    }
    else
        customFilter.animateType = CustomAnimationTypeCombined;
    customFilter.folderPath = path;

    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [self objectForData:jsonData];
    jsonData = nil;
    NSError * error = nil;
    customFilter.name = effectDic[@"name"];
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
    NSString *fragPath = [path stringByAppendingPathComponent:effectDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:effectDic[@"vertShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    
    if (effectDic[@"script"]) {
        NSString *scriptPath = [path stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
        customFilter.scriptName = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
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
    
    if( overlay )
    {
        if( effectDic[@"other"] )
        {
            if( [effectDic[@"other"] isKindOfClass:[NSArray class]] )
            {
                NSArray *array = effectDic[@"other"];
//                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [captionex.captionImage.otherAnimates addObject:[VEHelp getAnmationDic:(NSMutableDictionary*)obj atPath:path]];
//                }];
                overlay.media.customOtherAnimate = [VEHelp getAnmationDic:(NSMutableDictionary*)[array firstObject] atPath:path];
            }
            else
            {
                overlay.media.customOtherAnimate = [VEHelp getAnmationDic:(NSMutableDictionary*)effectDic[@"other"] atPath:path];
            }
        }
        else{
            if( customFilter.animateType == CustomAnimationTypeIn )
            {
                overlay.media.customOtherAnimate = nil;
            }
        }
    }
    
    return  customFilter;
}
+ (CustomFilter *)getOverlayAnimationCustomFilter:(NSMutableDictionary *) itemDic categoryId:(NSString *)categoryId atType:(NSInteger) typeIndex atCaption:( Overlay *) overlay
{
    NSString *path = [self getStickerAnimationFilePath:itemDic[@"file"] updatetime:[NSString stringWithFormat:@"%lld",[itemDic[@"updatetime"] longLongValue]]];
    NSInteger fileCount = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] count];
    if (fileCount == 0) {
        return nil;
    }
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *folderName;
    for (NSString *fileName in files) {
        if (![fileName isEqualToString:@"__MACOSX"]) {
            NSString *folderPath = [path stringByAppendingPathComponent:fileName];
            BOOL isDirectory = NO;
            BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDirectory];
            if (isExists && isDirectory) {
                folderName = fileName;
                break;
            }
        }
    }
    if (folderName.length > 0) {
        path = [path stringByAppendingPathComponent:folderName];
    }
    
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    if( typeIndex == 0 )
    {
        customFilter.animateType = CustomAnimationTypeIn;
    }
    else if( typeIndex == 1 )
    {
        customFilter.animateType = CustomAnimationTypeOut;
    }
    else
        customFilter.animateType = CustomAnimationTypeCombined;
    customFilter.networkCategoryId = categoryId;
    customFilter.networkResourceId = itemDic[@"id"];
    customFilter.folderPath = path;

    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [self objectForData:jsonData];
    jsonData = nil;
    NSError * error = nil;
    customFilter.name = effectDic[@"name"];
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
    NSString *fragPath = [path stringByAppendingPathComponent:effectDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:effectDic[@"vertShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    
    if (effectDic[@"script"]) {
        NSString *scriptPath = [path stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
        customFilter.scriptName = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
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
    
    if( overlay )
    {
        if( effectDic[@"other"] )
        {
            if( [effectDic[@"other"] isKindOfClass:[NSArray class]] )
            {
                NSArray *array = effectDic[@"other"];
//                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [captionex.captionImage.otherAnimates addObject:[VEHelp getAnmationDic:(NSMutableDictionary*)obj atPath:path]];
//                }];
                overlay.media.customOtherAnimate = [VEHelp getAnmationDic:(NSMutableDictionary*)[array firstObject] atPath:path];
            }
            else
            {
                overlay.media.customOtherAnimate = [VEHelp getAnmationDic:(NSMutableDictionary*)effectDic[@"other"] atPath:path];
            }
        }
        else{
            if( customFilter.animateType == CustomAnimationTypeIn )
            {
                overlay.media.customOtherAnimate = nil;
            }
        }
    }
    
    return  customFilter;
}

+ (CustomFilter *)getStickerAnimationCustomFilter:(NSMutableDictionary *) itemDic categoryId:(NSString *)categoryId atType:(NSInteger) typeIndex atCaption:( CaptionEx *) captionex
{
    NSString *path = [self getStickerAnimationFilePath:itemDic[@"file"] updatetime:[NSString stringWithFormat:@"%lld",[itemDic[@"updatetime"] longLongValue]]];
    NSInteger fileCount = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] count];
    if (fileCount == 0) {
        return nil;
    }
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *folderName;
    for (NSString *fileName in files) {
        if (![fileName isEqualToString:@"__MACOSX"]) {
            NSString *folderPath = [path stringByAppendingPathComponent:fileName];
            BOOL isDirectory = NO;
            BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDirectory];
            if (isExists && isDirectory) {
                folderName = fileName;
                break;
            }
        }
    }
    if (folderName.length > 0) {
        path = [path stringByAppendingPathComponent:folderName];
    }
    
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    if( typeIndex == 0 )
    {
        customFilter.animateType = CustomAnimationTypeIn;
    }
    else if( typeIndex == 1 )
    {
        customFilter.animateType = CustomAnimationTypeOut;
    }
    else
        customFilter.animateType = CustomAnimationTypeCombined;
    customFilter.networkCategoryId = categoryId;
    customFilter.networkResourceId = itemDic[@"id"];
    customFilter.folderPath = path;

    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [self objectForData:jsonData];
    jsonData = nil;
    NSError * error = nil;
    customFilter.name = effectDic[@"name"];
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
    NSString *fragPath = [path stringByAppendingPathComponent:effectDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:effectDic[@"vertShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    
    if (effectDic[@"script"]) {
        NSString *scriptPath = [path stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
        customFilter.scriptName = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
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
    
    if( captionex )
    {
        if( effectDic[@"other"] )
        {
            if( [effectDic[@"other"] isKindOfClass:[NSArray class]] )
            {
                NSArray *array = effectDic[@"other"];
//                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [captionex.captionImage.otherAnimates addObject:[VEHelp getAnmationDic:(NSMutableDictionary*)obj atPath:path]];
//                }];
                captionex.captionImage.otherAnimates = [VEHelp getAnmationDic:(NSMutableDictionary*)[array firstObject] atPath:path];
            }
            else
            {
                captionex.captionImage.otherAnimates = [VEHelp getAnmationDic:(NSMutableDictionary*)effectDic[@"other"] atPath:path];
            }
        }
        else{
            if( customFilter.animateType == CustomAnimationTypeIn )
            {
                captionex.captionImage.otherAnimates = nil;
            }
        }
    }
    
    return  customFilter;
}

+ (CustomFilter *)getStickerAnimationCustomFilterWithPath:(NSString *) path atType:(NSInteger) typeIndex atCaption:( CaptionEx *) captionex
{
    NSInteger fileCount = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] count];
    if (fileCount == 0) {
        return nil;
    }
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *folderName;
    for (NSString *fileName in files) {
        if (![fileName isEqualToString:@"__MACOSX"]) {
            NSString *folderPath = [path stringByAppendingPathComponent:fileName];
            BOOL isDirectory = NO;
            BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDirectory];
            if (isExists && isDirectory) {
                folderName = fileName;
                break;
            }
        }
    }
    if (folderName.length > 0) {
        path = [path stringByAppendingPathComponent:folderName];
    }
    
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    if( typeIndex == 0 )
    {
        customFilter.animateType = CustomAnimationTypeIn;
    }
    else if( typeIndex == 1 )
    {
        customFilter.animateType = CustomAnimationTypeOut;
    }
    else
        customFilter.animateType = CustomAnimationTypeCombined;
    customFilter.folderPath = path;

    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [self objectForData:jsonData];
    jsonData = nil;
    NSError * error = nil;
    customFilter.name = effectDic[@"name"];
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
    NSString *fragPath = [path stringByAppendingPathComponent:effectDic[@"fragShader"]];
    NSString *vertPath = [path stringByAppendingPathComponent:effectDic[@"vertShader"]];
    customFilter.frag = [NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:&error];
    customFilter.vert = [NSString stringWithContentsOfFile:vertPath encoding:NSUTF8StringEncoding error:&error];
    
    if (effectDic[@"script"]) {
        NSString *scriptPath = [path stringByAppendingPathComponent:effectDic[@"script"]];
        customFilter.script = [NSString stringWithContentsOfFile:scriptPath encoding:NSUTF8StringEncoding error:&error];
        customFilter.scriptName = [[scriptPath lastPathComponent] stringByDeletingPathExtension];
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
    
    if( captionex )
    {
        if( effectDic[@"other"] )
        {
            if( [effectDic[@"other"] isKindOfClass:[NSArray class]] )
            {
                NSArray *array = effectDic[@"other"];
//                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [captionex.captionImage.otherAnimates addObject:[VEHelp getAnmationDic:(NSMutableDictionary*)obj atPath:path]];
//                }];
                captionex.captionImage.otherAnimates = [VEHelp getAnmationDic:(NSMutableDictionary*)[array firstObject] atPath:path];
            }
            else
            {
                captionex.captionImage.otherAnimates = [VEHelp getAnmationDic:(NSMutableDictionary*)effectDic[@"other"] atPath:path];
            }
        }
        else{
            if( customFilter.animateType == CustomAnimationTypeIn )
            {
                captionex.captionImage.otherAnimates = nil;
            }
        }
    }
    
    return  customFilter;
}

+ (CustomFilter *)getAnimationCustomFilter:(NSMutableDictionary *) itemDic categoryId:(NSString *)categoryId
{
    NSString *path = [self getAnimationFilePath:itemDic[@"file"] updatetime:[NSString stringWithFormat:@"%lld",[itemDic[@"updatetime"] longLongValue]]];
    NSInteger fileCount = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil] count];
    if (fileCount == 0) {
        return nil;
    }
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *folderName;
    for (NSString *fileName in files) {
        if (![fileName isEqualToString:@"__MACOSX"]) {
            NSString *folderPath = [path stringByAppendingPathComponent:fileName];
            BOOL isDirectory = NO;
            BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:folderPath isDirectory:&isDirectory];
            if (isExists && isDirectory) {
                folderName = fileName;
                break;
            }
        }
    }
    if (folderName.length > 0) {
        path = [path stringByAppendingPathComponent:folderName];
    }
    CustomFilter *customFilter = [self getAnimationCustomFilterWithPath:path];
    customFilter.networkCategoryId = categoryId;
    customFilter.networkResourceId = itemDic[@"id"];
    return customFilter;
}

+ (CustomFilter *)getAnimationCustomFilterWithPath:(NSString *) path{
    
    NSString *configPath = [path stringByAppendingPathComponent:@"config.json"];
    CustomFilter *customFilter = [[CustomFilter alloc] init];
    
    customFilter.folderPath = path;
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
    NSMutableDictionary *effectDic = [self objectForData:jsonData];
    jsonData = nil;
    NSError * error = nil;
    customFilter.cycleDuration = 0.0;
    
    customFilter.name = effectDic[@"name"];
    customFilter.folderPath = path;
    if( effectDic[@"repeatMode"] )
        customFilter.repeatMode = effectDic[@"repeatMode"];
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

+ (NSString *)getAnimationFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime {
    NSString *cachedFilePath = [KAnimationFolder stringByAppendingPathComponent:[self cachedFileNameForKey:urlPath]];
    if( updatetime )
        cachedFilePath = [cachedFilePath stringByAppendingString:updatetime];
    return cachedFilePath;
}

+ (NSString *)timeToStringNoSecFormat:(float)time{
    if(time<=0){
        time = 0;
    }
    int secondsInt  = floorf(time);
    //    float haomiao=time-secondsInt;
    int hour        = secondsInt/3600;
    secondsInt     -= hour*3600;
    int minutes     =(int)secondsInt/60;
    secondsInt     -= minutes * 60;
    NSString *strText;
    //    if(haomiao==1){
    //        secondsInt+=1;
    //        haomiao=0.f;
    //    }
    if (hour>0)
    {
        strText=[NSString stringWithFormat:@"%02i:%02i:%02if",hour,minutes, secondsInt];
    }else{
        
        strText=[NSString stringWithFormat:@"%02i:%02i",minutes, secondsInt];
    }
    return strText;
}

//MARK: 提示
+(void)initCommonAlertViewWithTitle:(nullable NSString *)title
                            message:(nullable NSString *)message
                  cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                  otherButtonTitles:(nullable NSString *)otherButtonTitles
                   atViewController:( UIViewController * ) viewController
                      atCancelBlock:(void(^_Nullable)(void))cancelBlock atOtherBlock:(void(^_Nullable)(void))otherBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if(cancelButtonTitle != nil)
    {
        [alert addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if( cancelBlock )
                cancelBlock();
        }]];
    }
    if( otherButtonTitles != nil )
    {
        [alert addAction:[UIAlertAction actionWithTitle:otherButtonTitles style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if( otherBlock )
                otherBlock();
            
        }]];
    }
    [viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark 读取视频文件大小
+ (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        // 总大小
            unsigned long long size = 0;
            NSFileManager *manager = [NSFileManager defaultManager];
            
            BOOL isDir = NO;
            BOOL exist = [manager fileExistsAtPath:filePath isDirectory:&isDir];
            
            // 判断路径是否存在
            if (!exist)
                return size;
            if (isDir) { // 是文件夹
                NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:filePath];
                for (NSString *subPath in enumerator.allObjects) {
                    if (subPath.pathExtension.length > 0) {
                        NSString *fullPath = [filePath stringByAppendingPathComponent:subPath];
                        size += [manager attributesOfItemAtPath:fullPath error:nil].fileSize;
                    }
                }
            }else{ // 是文件
                size += [manager attributesOfItemAtPath:filePath error:nil].fileSize;
            }
        return size;
    }
    return 0;
}

+ (long long)getNetworkFileBytesWithURLStr:(NSString*)urlStr

{
    if ( urlStr.length == 0 )
    {
        return 0;
    }

    NSURL* URL = [NSURL URLWithString:urlStr ];
    NSMutableURLRequest* request = [[ NSMutableURLRequest alloc ] initWithURL:URL ];

    //设置请求方式，@“HEAD”请求方式只是获取服务器返回的response响应头数据，这个数据量相当小，并不需要服务器返回响应体(文件数据)，用同步方式相应很快
    [request setHTTPMethod:@"HEAD"];
    request.timeoutInterval = 5.0;
    [request setValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    __block NSHTTPURLResponse *resp = nil;
    NSError *err = nil;

    //同步方式发送网络请求
    dispatch_semaphore_t disp = dispatch_semaphore_create(0);
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error1) {
        resp = (NSHTTPURLResponse*)response;
        dispatch_semaphore_signal(disp);
    }];
    [dataTask resume];
    dispatch_semaphore_wait(disp, DISPATCH_TIME_FOREVER);

    if (err != nil) {
        NSLog(@"===%@", err);
        return 0;
    }

    //从响应头获取文件大小
    return resp.expectedContentLength;
}
+ (BOOL)createZip:(NSString *)path zipPath:(NSString *)zipPath {
    NSFileManager * fileManager = [NSFileManager defaultManager];
    unlink([zipPath UTF8String]);
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *files = [fileManager subpathsOfDirectoryAtPath:path error:nil];
        if (files.count > 0) {
            ZipArchive *zip = [[ZipArchive alloc] init];
            [zip CreateZipFile2:zipPath];
            [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.pathExtension.length > 0) {
                    [zip addFileToZip:[path stringByAppendingPathComponent:obj] newname:[path.lastPathComponent stringByAppendingPathComponent:obj]];
                }
            }];
            [zip CloseZipFile2];
            return YES;
        }
    }
    
    return NO;
}

+ (NSString *)getCachedAPITemplatePathWithUrlStr:(NSString *)urlStr {
    NSString *file = [[[urlStr stringByDeletingLastPathComponent] lastPathComponent] stringByAppendingString: [NSString stringWithFormat:@"%lu",[[[urlStr lastPathComponent] stringByDeletingPathExtension] hash]]];
    return [kAPITemplateFolder stringByAppendingPathComponent:file];
}

+(void)saveUserInfo:(id) obj forKey:(NSString*) key
{
    NSFileManager *fman = [NSFileManager defaultManager];
    NSError *error = nil;
    if(![fman fileExistsAtPath:kVEDraftDirectory]){
        [fman createDirectoryAtPath:kVEDraftDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    if ( ![fman fileExistsAtPath:key] ) {
        [fman createFileAtPath:key contents:nil attributes:nil];
    }
    
    NSMutableDictionary *dictionary =[[NSMutableDictionary alloc]init];
    
    [dictionary setValue:obj forKey:@"isUndone"];
    
    [dictionary writeToFile:key atomically:YES];
}
+(BOOL)readUserInfoBoolForKey:(NSString*) key
{
    NSDictionary *dictionary1 = [[NSDictionary alloc]initWithContentsOfFile:key];
    bool switchFlag = [(NSNumber*)[dictionary1 objectForKey:@"isUndone"] boolValue];
    return switchFlag;
}

+ (NSString *)getPathFolderName:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileArray = [manager contentsOfDirectoryAtPath:path error:nil];
    NSString *folderName;
    if(fileArray.count > 0){
        for (NSString *fileName in fileArray) {
            if (![fileName isEqualToString:@"__MACOSX"]) {
                NSString *folderPath = [path stringByAppendingPathComponent:fileName];
                BOOL isDirectory = NO;
                BOOL isExists = [manager fileExistsAtPath:folderPath isDirectory:&isDirectory];
                if (isExists && isDirectory) {
                    folderName = fileName;
                    break;
                }
            }
        }
    }
    return folderName;
}

#pragma mark- 获取图片图像数据
// alpha的判断
BOOL help_CGImageRefContainsAlpha(CGImageRef imageRef) {
    if (!imageRef) {
        return NO;
    }
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    BOOL hasAlpha = !(alphaInfo == kCGImageAlphaNone ||
                      alphaInfo == kCGImageAlphaNoneSkipFirst ||
                      alphaInfo == kCGImageAlphaNoneSkipLast);
    return hasAlpha;
}

static uint32_t help_bitmapInfoWithPixelFormatType(OSType inputPixelFormat, bool hasAlpha){
    
    if (inputPixelFormat == kCVPixelFormatType_32BGRA) {
        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
        if (!hasAlpha) {
            bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host;
        }
        return bitmapInfo;
    }else if (inputPixelFormat == kCVPixelFormatType_32ARGB) {
        uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
        return bitmapInfo;
    }else{
        NSLog(@"不支持此格式");
        return 0;
    }
}

static OSType help_inputPixelFormat(){
    return kCVPixelFormatType_32BGRA;
}

+ (CVPixelBufferRef)pixelBufferFromCGImage:(UIImage *)img{
    @autoreleasepool {
//        CGSize size = img.size;
        CGImageRef image = [img CGImage];
        CGSize size = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
        
        BOOL hasAlpha = help_CGImageRefContainsAlpha(image);
        uint32_t  _bitmapInfo  = help_bitmapInfoWithPixelFormatType(help_inputPixelFormat(), (bool)hasAlpha);
        
        CFDictionaryRef empty = CFDictionaryCreate(kCFAllocatorDefault, NULL, NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                                 [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                                 empty, kCVPixelBufferIOSurfacePropertiesKey,
                                 nil];
        CVPixelBufferRef pxbuffer = NULL;
        CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, help_inputPixelFormat(), (__bridge CFDictionaryRef) options, &pxbuffer);
        
        NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
        
        CVPixelBufferLockBaseAddress(pxbuffer, 0);
        void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
        NSParameterAssert(pxdata != NULL);
        
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        
        CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, CVPixelBufferGetBytesPerRow(pxbuffer), rgbColorSpace, _bitmapInfo);
        NSParameterAssert(context);
        
        CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
        CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
        
        CGColorSpaceRelease(rgbColorSpace);
        CGContextRelease(context);
        
        return pxbuffer;
    }
}

+ (CVPixelBufferRef)pixelBufferFromCIImage:(CIImage *)image {
    CFDictionaryRef empty = CFDictionaryCreate(kCFAllocatorDefault,
                                               NULL,
                                               NULL,
                                               0,
                                               &kCFTypeDictionaryKeyCallBacks,
                                               &kCFTypeDictionaryValueCallBacks);
    CFMutableDictionaryRef attributes = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                                             1,
                                                             &kCFTypeDictionaryKeyCallBacks,
                                                             &kCFTypeDictionaryValueCallBacks);

    CFDictionarySetValue(attributes,kCVPixelBufferIOSurfacePropertiesKey,empty);

    CVPixelBufferRef resultPixelBuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,
                                          image.extent.size.width,
                                          image.extent.size.height,
                                          kCVPixelFormatType_32BGRA,
                                          attributes,
                                          &resultPixelBuffer);

    if (status == kCVReturnSuccess && resultPixelBuffer != NULL) {

        CVPixelBufferLockBaseAddress(resultPixelBuffer, 0);
        CIContext *context = [CIContext new];
        [context render:image toCVPixelBuffer:resultPixelBuffer];
        CVPixelBufferUnlockBaseAddress(resultPixelBuffer, 0);
    }
    
    return resultPixelBuffer;
}

+ (void)copyPixelBuffer:(CVPixelBufferRef)copyedPixelBuffer toPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    @autoreleasepool {
        NSAssert(CVPixelBufferGetPixelFormatType(pixelBuffer) == kCVPixelFormatType_32BGRA,
                 @"Image buffer must have 32BGRA pixel format type");
        size_t width = CVPixelBufferGetWidth(copyedPixelBuffer);
        size_t height = CVPixelBufferGetHeight(copyedPixelBuffer);
        size_t width1 = CVPixelBufferGetWidth(pixelBuffer);
        size_t height1 = CVPixelBufferGetHeight(pixelBuffer);
        if (width != width1 || height != height1) {
            NSLog(@"width:%zu width1:%zu height:%zu height1:%zu", width, width1, height, height1);
//            NSAssert(CVPixelBufferGetWidth(pixelBuffer) == width, @"Width must match");
//            NSAssert(CVPixelBufferGetHeight(pixelBuffer) == height, @"Height must match");
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        CVPixelBufferLockBaseAddress(copyedPixelBuffer, 0);
        
        //    float *maskAddress = (float *)CVPixelBufferGetBaseAddress(copyedPixelBuffer);
        unsigned char *tempAddress = (unsigned char *)CVPixelBufferGetBaseAddress(copyedPixelBuffer);
        size_t maskBytesPerRow = CVPixelBufferGetBytesPerRow(copyedPixelBuffer);
        
        unsigned char *imageAddress = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
        static const int kBGRABytesPerPixel = 4;
#if 0
        for (int row = 0; row < height; ++row) {
            for (int col = 0; col < width; ++col) {
                int pixelOffset = col * kBGRABytesPerPixel;
                int alphaOffset = pixelOffset + 3;
                imageAddress[alphaOffset] = tempAddress[alphaOffset];
            }
            imageAddress += bytesPerRow / sizeof(unsigned char);
            tempAddress += maskBytesPerRow / sizeof(unsigned char);
        }
#else
        //2022.02.18 修复数据边缘锯齿问题
        if(maskBytesPerRow == bytesPerRow)
            memcpy(imageAddress, tempAddress, bytesPerRow*height);
        else
        {
            for (int row = 0; row < height; row++)
                memcpy(imageAddress+bytesPerRow, tempAddress+maskBytesPerRow, bytesPerRow);
        }
#endif
        CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
        CVPixelBufferUnlockBaseAddress(copyedPixelBuffer, 0);
    }
}
//MARK:添加区域权限
/**添加区域权限
 */
+ (CALayer *)arealayerWithView:(UIView *)view size:(CGSize)size{
    if (size.height < view.frame.size.height || size.width == size.height) {//20220321   只确保字幕不会被下面的视频信息遮挡即可
        return nil;
    }
    CALayer *layer = [[CALayer alloc] init];
    float width = size.width;
    float height = size.height;
    CGRect rect = CGRectMake((CGRectGetWidth(view.frame) - width)/2.0, (CGRectGetHeight(view.frame) - height)/2.0, width, height);
    layer.frame = rect;
    layer.position = CGPointMake(view.frame.size.width/2.0, view.frame.size.height/2.0);
    layer.masksToBounds = YES;
    [view.layer addSublayer:layer];
    {
        UIImage *image = [VEHelp imageNamed:@"ArealayerImages/区域1_18"];
        float itemWidth = image.size.width / 331.0 * size.width;
        float itemHeight = iPhone_X ? 75 : 63;
        CALayer *layer1 = [[CALayer alloc] init];
        layer1.frame = CGRectMake(3, CGRectGetHeight(view.frame) - itemHeight - (iPhone_X ? 6 : 15)/* - layer.frame.origin.y*/, itemWidth, itemHeight);
        layer1.contents = (id)(image.CGImage);
        [layer addSublayer:layer1];
    }
    {
        UIImage *image = [VEHelp imageNamed:@"ArealayerImages/区域1_03"];
        float itemWidth = 40;//iPhone_X ? image.size.width : 35;
        float itemHeight = 38;
        CALayer *layer1 = [[CALayer alloc] init];
        layer1.frame = CGRectMake(CGRectGetWidth(layer.frame) - itemWidth, CGRectGetHeight(view.frame) * (iPhone_X ? 0.51 : 0.35)/* - layer.frame.origin.y*/, itemWidth, itemHeight);
        layer1.contents = (id)(image.CGImage);
        [layer addSublayer:layer1];
        
        UIImage *image2 = [VEHelp imageNamed:@"ArealayerImages/区域1_07"];
        float itemWidth2 = 24;//iPhone_X ? image2.size.width : 25;
        CALayer *layer2 = [[CALayer alloc] init];
        layer2.frame = CGRectMake(CGRectGetMidX(layer1.frame) - itemWidth2/2.0, CGRectGetMaxY(layer1.frame) + view.frame.size.height * 0.021, itemWidth2, itemWidth2);
        layer2.contents = (id)(image2.CGImage);
        [layer addSublayer:layer2];
        CALayer *layer3 = [[CALayer alloc] init];
        layer3.frame = CGRectMake(layer2.frame.origin.x, CGRectGetMaxY(layer2.frame) + view.frame.size.height * 0.042, itemWidth2, itemWidth2);
        UIImage *image3 = [VEHelp imageNamed:@"ArealayerImages/区域1_07-11"];
        layer3.contents = (id)(image3.CGImage);
        [layer addSublayer:layer3];
        CALayer *layer4 = [[CALayer alloc] init];
        layer4.frame = CGRectMake(layer2.frame.origin.x, CGRectGetMaxY(layer3.frame) + view.frame.size.height * 0.056, itemWidth2, itemWidth2);
        UIImage *image4 = [VEHelp imageNamed:@"ArealayerImages/区域1_15"];
        layer4.contents = (id)(image4.CGImage);
        [layer addSublayer:layer4];
        
        UIImage *image5 = [VEHelp imageNamed:@"ArealayerImages/区域1_21"];
        float itemWidth3 = 29;//iPhone_X ? (image5.size.width - 4) : 33;
        CALayer *layer5 = [[CALayer alloc] init];
        layer5.frame = CGRectMake(CGRectGetMidX(layer1.frame) - itemWidth3/2.0, CGRectGetMaxY(layer4.frame) + view.frame.size.height * 0.05, itemWidth3, itemWidth3);
        layer5.contents = (id)(image5.CGImage);
        [layer addSublayer:layer5];
    }
    layer.hidden = NO;
    return layer;
}

+(CGRect)getOverlayBackgroundImageCrop:( CGSize ) imageSize atBackgroundImageSize:( CGSize ) backgroundImageSize
{
    float imageScale = imageSize.width/imageSize.height;

    float widthScale = 1.0;
    float heightScale = 1.0;
    
    {
        float width = backgroundImageSize.height*imageScale;
        widthScale = width/backgroundImageSize.width;
    }
    
    {
        float height = backgroundImageSize.width/imageScale;
        heightScale = height/backgroundImageSize.height;
    }
    
    CGRect crop = CGRectMake(0, 0, 1, 1);
    if( (widthScale <= 1.0) && (heightScale <= 1.0) )
    {
        if( widthScale > heightScale )
        {
            crop = CGRectMake((1.0-widthScale)/2.0, 0, widthScale, 1.0);
        }
        else{
            crop = CGRectMake(0, (1.0 - heightScale)/2.0, 1.0, heightScale);
        }
    }
    else if( widthScale <= 1.0 )
    {
        crop = CGRectMake((1.0-widthScale)/2.0, 0, widthScale, 1.0);
    }
    else{
        crop = CGRectMake(0, (1.0 - heightScale)/2.0, 1.0, heightScale);
    }
    return crop;
}

+ (NSString *)getAutoSegmentImagePath:(NSURL *)url {
    if (![[NSFileManager defaultManager] fileExistsAtPath:kAutoSegmentImageFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:kAutoSegmentImageFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = @"";
    if ([url.scheme.lowercaseString isEqualToString:@"ipod-library"]
        || [url.scheme.lowercaseString isEqualToString:@"assets-library"])
    {
        NSRange range = [url.absoluteString rangeOfString:@"?id="];
        if (range.location != NSNotFound) {
            fileName = [url.absoluteString substringFromIndex:range.length + range.location];
            range = [fileName rangeOfString:@"&ext"];
            fileName = [fileName substringToIndex:range.location];
        }
    }else {
        fileName = [NSString stringWithFormat:@"%ld",[url.path hash]];
    }
    NSString *autoSegmentImagePath = [[kAutoSegmentImageFolder stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"png"];
    return autoSegmentImagePath;
}
 
+(void)getRemoveTranslucent:( CVPixelBufferRef ) maskPixelBuffer
{
    @autoreleasepool {
        size_t width = CVPixelBufferGetWidth(maskPixelBuffer);
        size_t height = CVPixelBufferGetHeight(maskPixelBuffer);
        CVPixelBufferLockBaseAddress(maskPixelBuffer, 0);
        
        unsigned char *imageAddress = (unsigned char *)CVPixelBufferGetBaseAddress(maskPixelBuffer);
        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(maskPixelBuffer);
        static const int kBGRABytesPerPixel = 4;
        
        for (int row = 0; row < height; ++row) {
            for (int col = 0; col < width; ++col) {
                int pixelOffset = col * 1;
                int alphaOffset = pixelOffset;
                
                float tempAddressAlpha = imageAddress[alphaOffset];
                if( (tempAddressAlpha/255.0) > 0.001 )
                {
                    imageAddress[alphaOffset] = 1.0;
                }
            }
            imageAddress += bytesPerRow / sizeof(unsigned char);
        }
        CVPixelBufferUnlockBaseAddress(maskPixelBuffer, 0);
    }
}

+ (NSString *)getErasePenImagePath:(NSURL *)url {
    if (![[NSFileManager defaultManager] fileExistsAtPath:kErasePenFolder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:kErasePenFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = @"";
    if ([url.scheme.lowercaseString isEqualToString:@"ipod-library"]
        || [url.scheme.lowercaseString isEqualToString:@"assets-library"])
    {
        NSRange range = [url.absoluteString rangeOfString:@"?id="];
        if (range.location != NSNotFound) {
            fileName = [url.absoluteString substringFromIndex:range.length + range.location];
            range = [fileName rangeOfString:@"&ext"];
            fileName = [fileName substringToIndex:range.location];
        }
    }else {
        fileName = [NSString stringWithFormat:@"%ld",[url.path hash]];
    }
    NSString *autoSegmentImagePath = [[kErasePenFolder stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"png"];
    return autoSegmentImagePath;
}


+ (UIImage *)screenCapture{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(mainWindow.frame.size, NO, 0);
    [mainWindow drawViewHierarchyInRect:mainWindow.frame afterScreenUpdates:YES];
    UIImage *inputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return inputImage;
}
+ (UIImage *)blurScreenCapture{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(mainWindow.frame.size, NO, 0);
    [mainWindow drawViewHierarchyInRect:mainWindow.frame afterScreenUpdates:YES];
    UIImage *inputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [VEHelp boxblurImage:inputImage withBlurNumber:0.6];
}
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
     
    CGImageRef img = image.CGImage;
     
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
     
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(img);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
     
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
     
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
     
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
     
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
     
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
     
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));

    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
     
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
     
    free(pixelBuffer);
    CFRelease(inBitmapData);
     
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
     
    return returnImage;
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(img);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    //CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();//CGColorSpaceCreateDeviceRGB
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}

+ (BOOL)isVideoUrl:(NSURL *)url {
    AVAsset *asset = [AVAsset assetWithURL:url];
    NSArray *videoTracks = [asset tracksWithMediaType:AVMediaTypeVideo];
    if (videoTracks.count > 0) {
        return YES;
    }else {
        return NO;;
    }
}

+ (Particle *)getParticle:( NSString * ) path atFramePath:( NSString * ) framePath
{
    Particle * particle = [Particle new];
    
    
    NSString *jsonPath = [NSString stringWithFormat:@"%@/file/config.json", path];
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    
    if( effectDic[@"sourceRendingMode"]  )
        particle.sourceRendingMode = [effectDic[@"sourceRendingMode"]  intValue];
    
    if( effectDic[@"atlas"]  )
        particle.maskAtlas = [effectDic[@"atlas"]  boolValue];
    
//    if( effectDic[@"mask"]  )
//        particle.mask = [effectDic[@"mask"]  boolValue];
    
    if( effectDic[@"blendFuncSource"]  )
        particle.blendFuncSource = [effectDic[@"blendFuncSource"]  intValue];
    
    if( effectDic[@"emitterType"]  )
        particle.emitterType = [effectDic[@"emitterType"]  intValue];
    
        if( effectDic[@"particleLifespan"]  )
            particle.particleLifespan = [effectDic[@"particleLifespan"]  floatValue];

    if( effectDic[@"duration"]  )
        particle.duration = [effectDic[@"duration"]  floatValue];
    
    if( effectDic[@"angle"]  )
        particle.angle = [effectDic[@"angle"]  floatValue];
    
    if( effectDic[@"particleLifespanVariance"]  )
        particle.particleLifespanVariance = [effectDic[@"particleLifespanVariance"]  floatValue];
    
    if( effectDic[@"angleVariance"]  )
        particle.angleVariance = [effectDic[@"angleVariance"]  floatValue];
    
    if( effectDic[@"rotationStart"]  )
        particle.rotationStart = [effectDic[@"rotationStart"]  floatValue];
    
    if( effectDic[@"rotationStartVariance"]  )
        particle.rotationStartVariance = [effectDic[@"rotationStartVariance"]  floatValue];
    
    if( effectDic[@"rotationEnd"]  )
        particle.rotationEnd = [effectDic[@"rotationEnd"]  floatValue];
    
    if( effectDic[@"rotationEndVariance"]  )
        particle.rotationEndVariance = [effectDic[@"rotationEndVariance"]  floatValue];
    
    if( effectDic[@"startColorAlpha"]  )
        particle.startColorAlpha = [effectDic[@"startColorAlpha"]  floatValue];
    
    if( effectDic[@"startColorRed"]  )
        particle.startColorRed = [effectDic[@"startColorRed"]  floatValue];
    
    if( effectDic[@"startColorGreen"]  )
        particle.startColorGreen = [effectDic[@"startColorGreen"]  floatValue];
    
    if( effectDic[@"startColorBlue"]  )
        particle.startColorBlue = [effectDic[@"startColorBlue"]  floatValue];
    
    if( effectDic[@"startColorVarianceAlpha"]  )
        particle.startColorVarianceAlpha = [effectDic[@"startColorVarianceAlpha"]  floatValue];
    
    if( effectDic[@"startColorVarianceRed"]  )
        particle.startColorVarianceRed = [effectDic[@"startColorVarianceRed"]  floatValue];
    
    if( effectDic[@"startColorVarianceGreen"]  )
        particle.startColorVarianceGreen = [effectDic[@"startColorVarianceGreen"]  floatValue];
    
    if( effectDic[@"startColorVarianceBlue"]  )
        particle.startColorVarianceBlue = [effectDic[@"startColorVarianceBlue"]  floatValue];
    
    if( effectDic[@"finishColorAlpha"]  )
        particle.finishColorAlpha = [effectDic[@"finishColorAlpha"]  floatValue];
    
    if( effectDic[@"finishColorRed"]  )
        particle.finishColorRed = [effectDic[@"finishColorRed"]  floatValue];
    
    if( effectDic[@"finishColorGreen"]  )
        particle.finishColorGreen = [effectDic[@"finishColorGreen"]  floatValue];
    
    if( effectDic[@"finishColorBlue"]  )
        particle.startColorVarianceAlpha = [effectDic[@"finishColorBlue"]  floatValue];
    
    if( effectDic[@"finishColorVarianceAlpha"]  )
        particle.finishColorVarianceAlpha = [effectDic[@"finishColorVarianceAlpha"]  floatValue];
    
    if( effectDic[@"finishColorVarianceRed"]  )
        particle.finishColorVarianceRed = [effectDic[@"finishColorVarianceRed"]  floatValue];
    
    if( effectDic[@"finishColorVarianceGreen"]  )
        particle.finishColorVarianceGreen = [effectDic[@"finishColorVarianceGreen"]  floatValue];
    
    if( effectDic[@"startParticleSize"]  )
        particle.startParticleSize = [effectDic[@"startParticleSize"]  floatValue];
    
    if( effectDic[@"startParticleSizeVariance"]  )
        particle.startParticleSizeVariance = [effectDic[@"startParticleSizeVariance"]  floatValue];
    
    if( effectDic[@"finishParticleSize"]  )
        particle.finishParticleSize = [effectDic[@"finishParticleSize"]  floatValue];
    
    if( effectDic[@"finishParticleSizeVariance"]  )
        particle.finishParticleSizeVariance = [effectDic[@"finishParticleSizeVariance"]  floatValue];
    
    if( effectDic[@"gravityx"]  )
        particle.gravityx = [effectDic[@"gravityx"]  floatValue];
    
    if( effectDic[@"gravityy"]  )
        particle.gravityy = [effectDic[@"gravityy"]  floatValue];
    
    if( effectDic[@"sourcePositionVariancex"]  )
        particle.sourcePositionVariancex = [effectDic[@"sourcePositionVariancex"]  floatValue];
    
    if( effectDic[@"sourcePositionVariancey"]  )
        particle.sourcePositionVariancey = [effectDic[@"sourcePositionVariancey"]  floatValue];
    
    if( effectDic[@"maxParticles"]  )
        particle.maxParticles = [effectDic[@"maxParticles"]  intValue];
    
    if( effectDic[@"speed"]  )
           particle.speed = [effectDic[@"speed"]  floatValue];
    
    if( effectDic[@"speedVariance"]  )
           particle.speedVariance = [effectDic[@"speedVariance"]  floatValue];
    
    if( effectDic[@"radialAcceleration"]  )
           particle.radialAcceleration = [effectDic[@"radialAcceleration"]  floatValue];
    
    if( effectDic[@"radialAccelVariance"]  )
           particle.radialAccelVariance = [effectDic[@"radialAccelVariance"]  floatValue];
    
    if( effectDic[@"tangentialAcceleration"]  )
           particle.tangentialAcceleration = [effectDic[@"tangentialAcceleration"]  floatValue];
    
    if( effectDic[@"tangentialAccelVariance"]  )
           particle.tangentialAccelVariance = [effectDic[@"tangentialAccelVariance"]  floatValue];
    
    if( effectDic[@"minRadius"]  )
           particle.minRadius = [effectDic[@"minRadius"]  floatValue];
    
    if( effectDic[@"minRadiusVariance"]  )
           particle.minRadiusVariance = [effectDic[@"minRadiusVariance"]  floatValue];
    
    if( effectDic[@"maxRadius"]  )
           particle.maxRadius = [effectDic[@"maxRadius"]  floatValue];
    
    if( effectDic[@"maxRadiusVariance"]  )
           particle.maxRadiusVariance = [effectDic[@"maxRadiusVariance"]  floatValue];
    
    if( effectDic[@"rotatePerSecond"]  )
           particle.rotatePerSecond = [effectDic[@"rotatePerSecond"]  floatValue];
    
    if( effectDic[@"rotatePerSecondVariance"]  )
           particle.rotatePerSecondVariance = [effectDic[@"rotatePerSecondVariance"]  floatValue];
    
    if( effectDic[@"rotationIsDir"]  )
           particle.rotationIsDir = [effectDic[@"rotationIsDir"]  boolValue];
    
    if( effectDic[@"yCoordFlipped"]  )
           particle.yCoordFlipped = [effectDic[@"yCoordFlipped"]  floatValue];
    
    if( effectDic[@"maskPath"] )
    {
        NSString * maskName = effectDic[@"maskPath"];
        NSString *maskPath = [NSString stringWithFormat:@"%@/%@", path,maskName];
        particle.maskPath = maskPath;
        particle.textureFileName = framePath;
    }
    else{
        NSString * textureFileName = effectDic[@"textureFileName"];
        NSString *maskPath = [NSString stringWithFormat:@"%@/file/%@", path,textureFileName];
        particle.textureFileName = maskPath;
    }
    
    return particle;
}

+ (NSMutableArray *)getCameraParticle:( NSString * ) path atFramePath:( NSString * ) framePath atSize:( CGSize ) size
{
    NSString *jsonPath = [NSString stringWithFormat:@"%@/config.json", path];
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
    jsonData = nil;
    
    NSArray* effects = effectDic[@"effects"];
    
    NSMutableArray * array = [NSMutableArray new];
    
    [effects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[self getVEParticleS:path atFramePath:framePath  atObj:obj]];
    }];
    
    return array;
}
+ (Particle *)getVEParticle:( NSString * ) path atFramePath:( NSString * ) framePath  atObj:( NSMutableDictionary * ) obj
{
    NSMutableDictionary *effectDic = nil;
    if( obj )
    {
        effectDic = obj;
    }
    else{
        NSString *jsonPath = [NSString stringWithFormat:@"%@/config.json", path];
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
        effectDic = [VEHelp objectForData:jsonData];
        jsonData = nil;
    }
    Particle* p = nil;
    if( effectDic )
    {
        NSMutableDictionary * effect = effectDic;
        p = [[Particle alloc] init];
        p.sourceRendingMode = [effect[@"sourceRendingMode"] floatValue];
        p.startColorAlpha = [effect[@"startColorAlpha"] floatValue];
        p.startParticleSizeVariance = [effect[@"startParticleSizeVariance"] floatValue]/720.0;
        p.startColorGreen = [effect[@"startColorGreen"] floatValue];
        p.startColorBlue = [effect[@"startColorBlue"] floatValue];
        p.rotatePerSecond = [effect[@"rotatePerSecond"] floatValue];
        p.radialAcceleration = [effect[@"radialAcceleration"] floatValue];
        p.yCoordFlipped = [effect[@"yCoordFlipped"] floatValue];
        p.emitterType = [effect[@"emitterType"] floatValue];
        p.blendFuncSource = [effect[@"blendFuncSource"] floatValue];
        p.finishColorVarianceAlpha = [effect[@"finishColorVarianceAlpha"] floatValue];
        p.rotationEnd = [effect[@"rotationEnd"] floatValue];
        p.startColorVarianceBlue = [effect[@"startColorVarianceBlue"] floatValue];
        p.rotatePerSecondVariance = [effect[@"rotatePerSecondVariance"] floatValue];
        p.particleLifespan = [effect[@"particleLifespan"] floatValue];
        p.minRadius = [effect[@"minRadius"] floatValue];
        p.tangentialAcceleration = [effect[@"tangentialAcceleration"] floatValue]/720.0;
        p.rotationStart = [effect[@"rotationStart"] floatValue];
        p.startColorVarianceGreen = [effect[@"startColorVarianceGreen"] floatValue];
        p.speed = [effect[@"speed"] floatValue]/720.0;
        
        p.minRadiusVariance = [effect[@"minRadiusVariance"] floatValue];
        p.finishColorVarianceBlue = [effect[@"finishColorVarianceBlue"] floatValue];
        p.finishColorBlue = [effect[@"finishColorBlue"] floatValue];
        p.finishColorGreen = [effect[@"finishColorGreen"] floatValue];
    //            p.blendFuncDestination = [effect[@"blendFuncDestination"] floatValue]/size.width;
        p.finishColorAlpha = [effect[@"finishColorAlpha"] floatValue];

        p.startParticleSize = [effect[@"startParticleSize"] floatValue]/720.0;
        p.sourcePositionVariancex = [effect[@"sourcePositionVariancex"] floatValue]/720.0;
        p.sourcePositionVariancey = [effect[@"sourcePositionVariancey"] floatValue]/720.0;
        p.sourcePositionx = [effect[@"sourcePositionx"] floatValue]/720.0;
        p.sourcePositiony = [effect[@"sourcePositiony"] floatValue]/720.0;
        p.startColorRed = [effect[@"startColorRed"] floatValue];
        p.finishColorVarianceRed = [effect[@"finishColorVarianceRed"] floatValue];
        {
            NSString * textureFileName = effect[@"textureFileName"];
            NSString *maskPath = [NSString stringWithFormat:@"%@/%@", path,textureFileName];
            p.textureFileName = maskPath;
        }
        
        p.startColorVarianceAlpha = [effect[@"startColorVarianceAlpha"] floatValue];
        p.maxParticles = [effect[@"maxParticles"] floatValue];
        p.finishColorVarianceGreen = [effect[@"finishColorVarianceGreen"] floatValue];
        p.finishParticleSize = [effect[@"finishParticleSize"] floatValue]/720.0;
        p.duration = [effect[@"duration"] floatValue];
        p.startColorVarianceRed = [effect[@"startColorVarianceRed"] floatValue];
        p.finishColorRed = [effect[@"finishColorRed"] floatValue];
        p.gravityx = [effect[@"gravityx"] floatValue]/720.0;
        p.maxRadiusVariance = [effect[@"maxRadiusVariance"] floatValue];
        p.gravityy = [effect[@"gravityy"] floatValue]/720.0;
        p.finishParticleSizeVariance = [effect[@"finishParticleSizeVariance"] floatValue]/720.0;
        p.rotationEndVariance = [effect[@"rotationEndVariance"] floatValue];
        p.rotationStartVariance = [effect[@"rotationStartVariance"] floatValue];
        p.speedVariance = [effect[@"speedVariance"] floatValue]/720.0;
        p.radialAccelVariance = [effect[@"radialAccelVariance"] floatValue];
        p.tangentialAccelVariance = [effect[@"tangentialAccelVariance"] floatValue]/720.0;
        p.particleLifespanVariance = [effect[@"particleLifespanVariance"] floatValue];
        p.angleVariance = [effect[@"angleVariance"] floatValue];
        p.angle = [effect[@"angle"] floatValue];
        p.maxRadius = [effect[@"maxRadius"] floatValue];
    }
    return p;
}

+ (Particle *)getVEParticleS:( NSString * ) path atFramePath:( NSString * ) framePath  atObj:( NSMutableDictionary * ) obj
{
    Particle * particle = nil;
    if( obj == nil )
    {
        NSString *jsonPath = [NSString stringWithFormat:@"%@/config.json", path];
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
        NSMutableDictionary *effectDic = [VEHelp objectForData:jsonData];
        jsonData = nil;
        obj = effectDic;
    }
    
    NSMutableDictionary* effect = obj[@"effect"];
    NSMutableDictionary* location = obj[@"location"];
    if(effect)
    {
        particle = [self getVEParticle:path atFramePath:framePath  atObj:effect];
        particle.sourceRendingMode = [obj[@"sourceRendingMode"] floatValue];
    }
    return particle;
}


+(void)impactOccurred:( float ) intensity
{
    if (@available(iOS 10.0, *)) {
        if (@available(iOS 13.0, *)) {
            UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
            [generator impactOccurredWithIntensity:intensity];
        } else {
            // Fallback on earlier versions
        }
    } else {
        // Fallback on earlier versions
    }
}

+ (long long) freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    NSLog(@"%@",[NSString stringWithFormat:@"手机剩余存储空间为：%qi MB" ,freespace/1024/1024]);
    return freespace/1024/1024;
}

+ (UIColor *)getCategoryFilterBgColorWithDic:(NSDictionary *)dic categoryIndex:(NSInteger)categoryIndex {
    UIColor *backgroundColor;
    if (dic && dic[@"extra"] && [dic[@"extra"] count] > 0 && [dic[@"extra"][@"bg"] length] > 0) {
        backgroundColor = [self colorWithHexString:[NSString stringWithFormat:@"0x%@", dic[@"extra"][@"bg"]]];
    }
    if (!backgroundColor) {
        switch (categoryIndex) {
            case 1:
                backgroundColor = UIColorFromRGB(0xb96e77);
                break;
            case 2:
                backgroundColor = UIColorFromRGB(0x284742);
                break;
            case 3:
                backgroundColor = UIColorFromRGB(0x6c8464);
                break;
            case 4:
                backgroundColor = UIColorFromRGB(0x333333);
                break;
            case 5:
                backgroundColor = UIColorFromRGB(0xb4984f);
                break;
            case 6:
                backgroundColor = UIColorFromRGB(0x614285);
                break;
            case 7:
                backgroundColor = UIColorFromRGB(0x2b2e78);
                break;
            case 8:
                backgroundColor = UIColorFromRGB(0x965141);
                break;
                
            default:
                backgroundColor = UIColorFromRGB(0x5f4b44);
                break;
        }
    }
    return backgroundColor;
}

+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+(UIView *)loadCircleProgressView:(CGRect) rect
{
    
    UIColor *color = [UIColor colorWithWhite:0.0 alpha:0.3];
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.backgroundColor = color;
    CGRect rect1 = CGRectMake((rect.size.width - 14)/2.0, (rect.size.width - 14)/2.0,14,14);
    VECircleView * progressLabel = [[VECircleView alloc] initWithFrame:rect1];
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.progressBackgroundColor = [TEXT_COLOR colorWithAlphaComponent:0.9];
    progressLabel.progressColor = Main_Color;
    progressLabel.progressWidth = 2.0;
    progressLabel.percent = 0.01;
    progressLabel.tag = 10;
    progressLabel.hidden = NO;
    [view addSubview:progressLabel];
    return view;
}

+ (Float64)getOriginalTime:( Float64 ) currentTime atOriginalTimeArray:(NSMutableArray *) originalTimeArray atShiftTimeArray:(NSMutableArray *) shiftTimeArray atCurveSpeedPointArray:( NSMutableArray<CurvedSpeedPoint*> *) curveSpeedPointArray
{
    int index = -1;
    for (int i = 0; i < shiftTimeArray.count; i++) {
        CMTime time = kCMTimeZero;
        NSValue* value = shiftTimeArray[i];
        [value getValue:&time];
         if( CMTimeGetSeconds(time) >  currentTime )
         {
             index = i;
             break;
         }
    }
    if( index == -1 )
    {
        index = (int)shiftTimeArray.count - 1;
    }
    
    Float64 startTime = 0.0;
    Float64 endTime = 0.0;
    Float64 shifitCurrentTime = 0.0;
    {
        CMTime time = kCMTimeZero;
        NSValue* value = originalTimeArray[index];
        [value getValue:&time];
        endTime = CMTimeGetSeconds(time);
    }
    {
        CMTime time = kCMTimeZero;
        if(index > 0)
        {
            NSValue* value = originalTimeArray[index - 1];
            [value getValue:&time];
        }
        else{
            time = CMTimeMakeWithSeconds(0, 10000);
        }
        startTime = CMTimeGetSeconds(time);
    }
    
    {
        CMTime time = kCMTimeZero;
        if(index > 0)
        {
            NSValue* value = shiftTimeArray[index - 1];
            [value getValue:&time];
        }
        else{
            time = CMTimeMakeWithSeconds(0, 10000);
        }
        shifitCurrentTime = CMTimeGetSeconds(time);
        shifitCurrentTime = currentTime - shifitCurrentTime;
    }
    
//    NSLog(@"当前时间：%.2f,时长：%.2f",shifiCurrentTime,endTime - startTime);
    Float64 time = [self getCurrentTime:shifitCurrentTime atDuration:endTime - startTime atObj:curveSpeedPointArray[index] atNextObj:curveSpeedPointArray[index + 1]];
//    time = startTime+time;
    
//    NSLog(@"原始时间：%.2f,原始启始时间：%.2f",startTime+time,startTime);
    return  startTime+time;
}

+ (Float64)getCurrentTime:( Float64 ) currentTime atDuration:(Float64) duration atObj:(CurvedSpeedPoint *) obj atNextObj:(CurvedSpeedPoint *) nextObj
{
    Float64 startSpeed = obj.speed;
    Float64 durationSpeed = nextObj.speed - obj.speed;
    Float64 fCurveStart = 0.0;
    Float64 fCurveEnd = 1.0;
    if( durationSpeed != 0.0 )
    {
        if(obj.speed > nextObj.speed )
        {
            startSpeed = nextObj.speed;
            durationSpeed = obj.speed - nextObj.speed;
            
            fCurveStart = 1.0;
            fCurveEnd = 0.0;
        }
        
        Float64 perDuration = 0.01;//10ms分块
        int count = ceilf(duration/perDuration);
        Float64 passThroughTime = 0.0;
        Float64 originalPassThroughTime = 0.0;
        for (int i = 0; i < count; i++) {
            Float64 t = ((Float64)i)/((Float64)count);
            Float64 tempT =  1.0 - t;
            Float64 pointY = (fCurveStart * tempT * tempT * tempT + 3.0 * 0.5 * t * tempT * tempT + 3.0 * 0.5 * t * t * tempT + fCurveEnd * t * t * t) * durationSpeed + startSpeed;
            
            Float64 scaleDur = perDuration/pointY;
            originalPassThroughTime += perDuration;
            passThroughTime += scaleDur;
            
            if( passThroughTime >= currentTime )
            {
                break;
            }
        }
//        NSLog(@"当前时间original：%.2f",originalPassThroughTime);
        return originalPassThroughTime;
    }
    else{
//        NSLog(@"当前时间original：%.2f",currentTime*startSpeed);
        return currentTime*startSpeed;
    }
}

+(Float64)getCurveSpeedTime:(Float64) originalTime atOriginalTimeArray:(NSMutableArray *) originalTimeArray atShiftTimeArray:(NSMutableArray *) shiftTimeArray atCurveSpeedPointArray:( NSMutableArray<CurvedSpeedPoint*> *) curveSpeedPointArray
{
    int index = -1;
    for (int i = 0; i < originalTimeArray.count; i++) {
        CMTime time = kCMTimeZero;
        NSValue* value = originalTimeArray[i];
        [value getValue:&time];
         if( CMTimeGetSeconds(time) >  originalTime )
         {
             index = i;
             break;
         }
    }
    if( index == -1 )
    {
        index = (int)shiftTimeArray.count - 1;
    }
    
    Float64 startTime = 0.0;
    Float64 endTime = 0.0;
    Float64 originalCurrentTime = 0.0;
    {
        CMTime time = kCMTimeZero;
        NSValue* value = originalTimeArray[index];
        [value getValue:&time];
        endTime = CMTimeGetSeconds(time);
    }
    {
        CMTime time = kCMTimeZero;
        if(index > 0)
        {
            NSValue* value = shiftTimeArray[index - 1];
            [value getValue:&time];
        }
        else{
            time = CMTimeMakeWithSeconds(0, 10000);
        }
        startTime = CMTimeGetSeconds(time);
    }
    
    {
        CMTime time = kCMTimeZero;
        if(index > 0)
        {
            NSValue* value = originalTimeArray[index - 1];
            [value getValue:&time];
        }
        else{
            time = CMTimeMakeWithSeconds(0, 10000);
        }
        originalCurrentTime = CMTimeGetSeconds(time);
    }
    
//    NSLog(@"当前时间：%.2f,时长：%.2f",shifiCurrentTime,endTime - startTime);
    Float64 time = [self getShifitCurrentTime:originalTime - originalCurrentTime atDuration:endTime - originalCurrentTime atObj:curveSpeedPointArray[index] atNextObj:curveSpeedPointArray[index + 1]];
//    time = startTime+time;
    
    NSLog(@"变速后时间：%.2f,变速后启始时间：%.2f",startTime+time,startTime);
    return  startTime+time;
}

+ (Float64)getShifitCurrentTime:( Float64 ) currentTime atDuration:(Float64) duration atObj:(CurvedSpeedPoint *) obj atNextObj:(CurvedSpeedPoint *) nextObj
{
    Float64 startSpeed = obj.speed;
    Float64 durationSpeed = nextObj.speed - obj.speed;
    Float64 fCurveStart = 0.0;
    Float64 fCurveEnd = 1.0;
    if( durationSpeed != 0.0 )
    {
        if(obj.speed > nextObj.speed )
        {
            startSpeed = nextObj.speed;
            durationSpeed = obj.speed - nextObj.speed;
            
            fCurveStart = 1.0;
            fCurveEnd = 0.0;
        }
        
        Float64 perDuration = 0.01;//10ms分块
        int count = ceilf(duration/perDuration);
        Float64 passThroughTime = 0.0;
        Float64 originalPassThroughTime = 0.0;
        for (int i = 0; i < count; i++) {
            Float64 t = ((Float64)i)/((Float64)count);
            Float64 tempT =  1.0 - t;
            Float64 pointY = (fCurveStart * tempT * tempT * tempT + 3.0 * 0.5 * t * tempT * tempT + 3.0 * 0.5 * t * t * tempT + fCurveEnd * t * t * t) * durationSpeed + startSpeed;
            
            Float64 scaleDur = perDuration/pointY;
            originalPassThroughTime += perDuration;
            passThroughTime += scaleDur;
            
            if( originalPassThroughTime >= currentTime )
            {
                break;
            }
        }
//        NSLog(@"当前时间original：%.2f",originalPassThroughTime);
        return passThroughTime;
    }
    else{
//        NSLog(@"当前时间original：%.2f",currentTime*startSpeed);
        return currentTime/startSpeed;
    }
}

+ (BOOL)isEqualGraphArray:(NSArray *)graphArray1 graphArray2:(NSArray *)graphArray2 {
    BOOL isEqual = YES;
    if (graphArray1.count != graphArray2.count) {
        isEqual = NO;
    }else {
        for (int i = 0; i < graphArray1.count; i++) {
            CurvedSpeedPoint *point1 = graphArray1[i];
            CurvedSpeedPoint *point2 = graphArray2[i];
            if (point1.timeFactor != point2.timeFactor || point1.speed != point2.speed) {
                isEqual = NO;
                break;
            }
        }
    }
    
    return isEqual;
}

+ (DoodleOption *)getDoodleOptionWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        return nil;
    }
    NSArray *files = [fm contentsOfDirectoryAtPath:path error:nil];
    
    NSString *directoryName;
    NSString *jsonPath;
    if (files.count == 1) {
        for (NSString *fileName in files) {
            if (![fileName isEqualToString:@"__MACOSX"]) {
                if(files.count == 1){
                    NSString *folderPath = [path stringByAppendingPathComponent:fileName];
                    BOOL isDirectory = NO;
                    BOOL isExists = [fm fileExistsAtPath:folderPath isDirectory:&isDirectory];
                    if (isExists && isDirectory) {
                        directoryName = fileName;
                        break;
                    }
                }
            }
        }
    }
    if (path.pathExtension.length == 0) {
        if (directoryName.length > 0) {
            jsonPath = [[path stringByAppendingPathComponent:directoryName] stringByAppendingPathComponent:@"config.json"];
        }else {
            jsonPath = [path stringByAppendingPathComponent:@"config.json"];
        }
    }else {
        jsonPath = path;
    }
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSDictionary *effectDic = [VEHelp objectForData:jsonData];
    if (!effectDic) {
        return nil;
    }
    NSDictionary *configDic = effectDic[@"config"];
    DoodleOption *option = [DoodleOption new];
    if (configDic[@"opacityValue"]) {
        option.opacityValue = [configDic[@"opacityValue"] floatValue];
    }
    if (configDic[@"paintSize"]) {
        option.paintSize = [configDic[@"paintSize"] floatValue];
    }
    if (configDic[@"blendFunc"]) {
        option.blendFunc = [configDic[@"blendFunc"] intValue];
    }
    if (configDic[@"angleSensor"]) {
        option.angleSensor = [configDic[@"angleSensor"] boolValue];
    }
    if (configDic[@"distanceSensor"]) {
        option.distanceSensor = [configDic[@"distanceSensor"] boolValue];
    }
    if (configDic[@"hardness"]) {
        option.hardness = [configDic[@"hardness"] boolValue];
    }
    if(configDic[@"usePaintedColor"]){
        option.usePaintedColor = [configDic[@"usePaintedColor"] boolValue];
    }
    if(configDic[@"strokeMask"]){
        option.strokeMask = [configDic[@"strokeMask"] intValue];
    }
    if (configDic[@"autoBrush"]) {
        option.autoBrush = [AutoBrush veCore_yy_modelWithDictionary:configDic[@"autoBrush"]];
    }
    if (configDic[@"pngBrush"]) {
        option.pngBrush = [PNGBrush veCore_yy_modelWithDictionary:configDic[@"pngBrush"]];
        if (option.pngBrush.filename.length > 0) {
            option.pngBrush.filename = [jsonPath.stringByDeletingLastPathComponent stringByAppendingPathComponent:option.pngBrush.filename];
        }
        if (option.pngBrush.distMask.length > 0) {
            option.pngBrush.distMask = [jsonPath.stringByDeletingLastPathComponent stringByAppendingPathComponent:option.pngBrush.distMask];
        }
    }
    if (configDic[@"textureGrain"]) {
        option.textureGrain = [TextureGrain veCore_yy_modelWithDictionary:configDic[@"textureGrain"]];
        if (option.textureGrain.filename.length > 0) {
            option.textureGrain.filename = [jsonPath.stringByDeletingLastPathComponent stringByAppendingPathComponent:option.textureGrain.filename];
        }
    }
    
    return option;
}

+ (BOOL)doodlePenIsHardnessEnableWithPath:(NSString *)path {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        return NO;
    }
    NSArray *files = [fm contentsOfDirectoryAtPath:path error:nil];
    
    NSString *directoryName;
    NSString *jsonPath;
    if (files.count == 1) {
        for (NSString *fileName in files) {
            if (![fileName isEqualToString:@"__MACOSX"]) {
                if(files.count == 1){
                    NSString *folderPath = [path stringByAppendingPathComponent:fileName];
                    BOOL isDirectory = NO;
                    BOOL isExists = [fm fileExistsAtPath:folderPath isDirectory:&isDirectory];
                    if (isExists && isDirectory) {
                        directoryName = fileName;
                        break;
                    }
                }
            }
        }
    }
    
    if (directoryName.length > 0) {
        jsonPath = [[path stringByAppendingPathComponent:directoryName] stringByAppendingPathComponent:@"config.json"];
    }else {
        jsonPath = [path stringByAppendingPathComponent:@"config.json"];
    }
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    NSDictionary *effectDic = [VEHelp objectForData:jsonData];
    if (!effectDic) {
        return NO;
    }
    NSDictionary *configDic = effectDic[@"config"];
    return [configDic[@"hardness"] boolValue];
}

//获取图片某一点的颜色
+ (UIColor *)colorAtPixel:(CGPoint)point source:(UIImage *)image{
     if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
         return nil;
     }
     
     NSInteger pointX = trunc(point.x);
     NSInteger pointY = trunc(point.y);
     CGImageRef cgImage = image.CGImage;
     NSUInteger width = image.size.width;
     NSUInteger height = image.size.height;
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     int bytesPerPixel = 4;
     int bytesPerRow = bytesPerPixel * 1;
     NSUInteger bitsPerComponent = 8;
     unsigned char pixelData[4] = { 0, 0, 0, 0 };
     CGContextRef context = CGBitmapContextCreate(pixelData,
                                                  1,
                                                  1,
                                                  bitsPerComponent,
                                                  bytesPerRow,
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
     CGColorSpaceRelease(colorSpace);
     CGContextSetBlendMode(context, kCGBlendModeCopy);
     
     CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
     CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
     CGContextRelease(context);
     
     CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
     CGFloat green = (CGFloat)pixelData[1] / 255.0f;
     CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
     CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
     return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
 }

+ (UIImage *)getOriginalImageWithUrl:(NSURL *)url {
    if ([self isSystemPhotoUrl:url]) {
        __block UIImage *image;
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;//解决草稿箱获取不到缩略图的问题
        PHFetchResult *phAsset = [PHAsset fetchAssetsWithALAssetURLs:@[url] options:nil];
        
        @try {
            [[PHImageManager defaultManager] requestImageForAsset:[phAsset firstObject] targetSize:CGSizeZero contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
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
    if([self isImageUrl:url]){
        UIImage * image = [self imageWithContentOfPathFull:url.path];
        return image;
    }else{
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                         forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        // 初始化媒体文件
        AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
        
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
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMakeWithSeconds(0, frameRate>0 ? frameRate : 30) actualTime:NULL error:&error];
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
}
+ (void)addShadowToView:(UIView *)view withColor:(UIColor *)theColor {
    [self addShadowToView:view withColor:theColor shadowRadius:8.0 cornerRadii:CGSizeMake(15, 15)];
}
+ (void)addShadowToView:(UIView *)view withColor:(UIColor *)theColor shadowRadius:(float)shadowRadius{
    [self addShadowToView:view withColor:theColor shadowRadius:shadowRadius cornerRadii:CGSizeMake(15, 15)];
}
+ (void)addShadowToView:(UIView *)view withColor:(UIColor *)theColor cornerRadii:(CGSize)cornerRadii{
    [self addShadowToView:view withColor:theColor shadowRadius:8.0 cornerRadii:cornerRadii];
}
+ (void)addShadowToView:(UIView *)view withColor:(UIColor *)theColor shadowRadius:(float)shadowRadius cornerRadii:(CGSize)cornerRadii{
//    //阴影
       if( theColor )
       {
           view.backgroundColor = nil;
           view.layer.shadowColor = theColor.CGColor;
           view.layer.shadowOpacity = 0.3;
           view.layer.shadowRadius = 8.0;
           view.layer.shadowOffset = CGSizeMake(0,0);
           view.layer.masksToBounds = NO;
       }

       //圆角
       UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
       CALayer *maskLayer = [[CAShapeLayer alloc] init];
       maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
       maskLayer.frame = view.bounds;
       CAShapeLayer *lay = [CAShapeLayer layer];
       lay.path = maskPath.CGPath;
       maskLayer.mask = lay;
       [view.layer insertSublayer:maskLayer atIndex:0];
}

+ (UIImage *)getScreenshotWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (NSString *)getAnitionPenConfigDownloadPathWithDic:(NSDictionary *)itemDic {
    NSString *filterFolderPath = kFilterFolder;
    if(![[NSFileManager defaultManager] fileExistsAtPath:filterFolderPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:filterFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *file = itemDic[@"file"];
    NSString *pathExtension = [[[file pathExtension] componentsSeparatedByString:@"&ufid"] firstObject];
    NSString *itemPath = [[filterFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu",(unsigned long)[file hash]]] stringByAppendingPathExtension:pathExtension];
    if ([file.pathExtension isEqualToString:@"zip"]) {
        itemPath = [itemPath stringByDeletingPathExtension];
    }
    return itemPath;
}

@end
