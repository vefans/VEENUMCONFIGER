
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <VEENUMCONFIGER/VEMediaInfo.h>
#import <VEENUMCONFIGER/UIImage+VEGIF.h>

@interface VEHelp : NSObject

+(id)objectForData:(NSData *)data;

+ (BOOL)isLowDevice;
/**进入系统设置
 */
+ (void)enterSystemSetting;
/**时间格式化
 */
+ (NSString * ) timeFormat: (float) seconds;
/**时间格式化  hh:mm:ss
 */
+ (NSString *) timeFormatHours: (float) seconds;
/**判断URL是视频还是图片
 */
+ (BOOL)isImageUrl:(NSURL * )url;
/**时间格式化
 */
+ (NSString * )timeToStringFormat:(float)time;
/**时间格式 （最小以秒计算）
 */
+ (NSString * )timeToStringFormat_MinSecond:(float)time;
//控件隐藏动画
+(void)animateViewHidden:(UIView * ) view atUP:(bool) isUp atBlock:(void(^)(void))completedBlock;
//获取字符串的文字域的宽
+ (float)widthForString:(NSString * )value andHeight:(float)height fontSize:(float)fontSize;
+ (float)widthForString:(NSString * )value andHeight:(float)height font:(UIFont*)fontSize;
//获取字符串的文字域的高
+ (float)heightForString:(NSString * )value andWidth:(float)width fontSize:(float)fontSize;
/**颜色转图片
 */
+ (UIImage * ) veImageWithColor:(UIColor * )color cornerRadius:(CGFloat)cornerRadius;
+ (UIImage * ) veImageWithColor:(UIColor * )color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

+(NSString*)getTransitionConfigPath:(NSDictionary *)obj;

//控件显示动画
+(void)animateView:(UIView * ) view  atUP:(bool) isUp;

+ (BOOL)isCameraRollAlbum:(PHAssetCollection * )metadata;

+ (NSString * )pathInCacheDirectory:(NSString * )fileName;
+ (UIImage * )assetGetThumImage:(CGFloat)second url:(NSURL * ) url urlAsset:(AVURLAsset * ) urlAsset;
/**Gif 时长
 */
+ (float)isGifWithData:(NSData * )imageData;
/**从URL获取缩率图照片
 */
+ (UIImage * )getThumbImageWithUrl:(NSURL * )url;

+(NSString * )getMaterialThumbnail:(NSURL * ) fileUrl;
//多线程保存缩略图
+(void)fileImage_Save:(NSMutableArray<VEMediaInfo *> * ) fileArray atProgress:(void(^)(float progress))completedBlock atReturn:(void(^)(bool isSuccess))completedReturn;
+(void)save_Image:(int) currentIndex atURL:(NSURL * ) url atPatch:(NSString * ) fileImagePatch atTimes:(NSMutableArray *) times atProgressCurrent:(int) progressIndex  atCount:(int) count atProgress:(void(^)(float progress))completedBlock;

/**加载图片
 */
+ (UIImage *)imageWithContentOfFile:(NSString *)path;
+ (UIImage *)composeimage:(UIImage *)image size:(CGSize)size;
+ (UIImage *)imageNamed:(NSString *)name;

+ (NSString *) getEditResource:(NSString *)name type: (NSString *) type;
+ (NSString *) getRecordResource: (NSString *) name type: (NSString *) type;
+ (NSString *) getDemoUseResource:(NSString *)name type: (NSString *) type;
+ (UIImage *) getBundleImage : (NSString *) name;
+ (UIImage *) getBundleImagePNG : (NSString *) name;
+ (NSBundle *)getEditBundle;
+ (NSBundle *)getRecordBundle;
+ (NSBundle *)getDemoUseBundle;
+ (NSString *)getLocalizedString:(NSString *)key;
/**
 *  获取设备可用容量(G)
 */
+(float)getFreeDiskSize;
/**获取可用空间和总空间
 */
+ (NSString *)getDivceSize;
/**获取视频需要占用的空间
 */
+(float)fileSizeWithvideoBitRate:(float) videoBitRate audioBitRate:(float)audioBitRate duration:(float)duration;
//自动换行，计算并添加“\n”进行换行
+(NSString *)setPastTextWith:(float) witdh atText:(NSString *) text atFont:(UIFont *) font;

+ (NSMutableArray *)getInternetTransitionArray;
/**通过字体文件路径加载字体 适用于 ttf ，otf
 */
+(NSString *)customFontWithPath:(NSString *)path fontName:(NSString *)fontName;

//从保存到plist文件中的绝对路径获取URL
+ (NSURL *)getFileURLFromAbsolutePath:(NSString *)absolutePath;
+ (NSString *)getFileURLFromAbsolutePath_str:(NSString *)absolutePath;

/**判断URL是否为本地相册
 */
+ (BOOL)isSystemPhotoUrl:(NSURL *)url;

+(NSMutableArray *)getColorArray;

+ (void)getNetworkResourcesWithParams:(NSMutableDictionary *)params
                            urlPath:(NSString *)urlPath
                  completionHandler:(void (^)(NSArray *listArray))completionHandler
                      failedHandler:(void (^)(NSError *error))failedHandler;;

+ (void)getCategoryMaterialWithType:(VENetworkMaterialType)materialType
                             appkey:(NSString *)appkey
                        typeUrlPath:(NSString *)typeUrlPath
                    materialUrlPath:(NSString *)materialUrlPath
                  completionHandler:(void (^)(NSArray *categoryArray, NSMutableArray *listArray))completionHandler
                      failedHandler:(void (^)(NSError *error))failedHandler;

+ (NSMutableArray *)getFilterArrayWithListArray:(NSMutableArray *)listArray;

+ (NSString *)getFilterDownloadPathWithDic:(NSDictionary *)itemDic;

@end
