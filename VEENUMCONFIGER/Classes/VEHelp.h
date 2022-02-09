
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <VEENUMCONFIGER/VEMediaInfo.h>
#import <VEENUMCONFIGER/UIImage+VEGIF.h>

@interface VEHelp : NSObject

+ (void)webpToPng:(NSString *)webpPath;

+ (UIImage *)geScreenShotImageFromVideoURL:(NSURL *)fileURL atTime:(CMTime)time  atSearchDirection:(bool) isForward;

+ (NSString *)geCaptionExSubtitleIdentifier;

+(float)getMediaAssetScale_File:( CGSize ) size atRect:(CGRect) rect atCorp:(CGRect) corp atSyncContainerHeihgt:(CGSize) syncContainerSize atIsWatermark:(BOOL) isWatermark;

+(NSMutableAttributedString *)getAttrString:(NSString *) string atForegroundColor:(UIColor *) foregroundColor atStrokeColor:(UIColor *) strokeColor atShadowBlurRadius:(float) shadowBlurRadius atShadowOffset:(CGSize) shadowOffset atShadowColor:(UIColor *) shadowColor;

+(NSString *)pathForURL_font:(NSString *)name extStr:(NSString *)extStr hasNew:(BOOL)hasNew;
+ (UIImage *)image:(UIImage *)image withBackgroundColor:(UIColor *)color;
//MARK: 添加特效
+(CustomMultipleFilter *)getCustomMultipleFilter:( NSDictionary * ) itemDic atPath:( NSString * ) path atTimeRange:( CMTimeRange ) timeRange atImage:( UIImage * ) FXFrameTexture atFXFrameTexturePath:( NSString * )  fXFrameTexturePath atEffectArray:( NSMutableArray * ) effectArray;
+ (NSString *)getEffectCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;
+ (NSString *)getSuperposiCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;
+ (NSString *)getBoxCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;
+(id)objectForData:(NSData *)data;

+ (BOOL)isSystemPhotoPath:(NSString *)path;

+ (BOOL)isLowDevice;
/**进入系统设置
 */
+ (void)enterSystemSetting;
/**时间格式化
 */
+ (NSString * ) timeFormat: (float) seconds;
+ (NSString *)timeToSecFormat:(float)time;
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

+ (NSBundle *)getBundleName:( NSString * ) name;
+( UIImage * )imageNamed:(NSString *)name atBundle:( NSBundle * ) bundle;
+(UIImage *)imageWithContentOfFile:(NSString *)path atBundle:( NSBundle * ) bundle;

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
+ (NSBundle *)getBundle;
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

/**通过字体文件路径加载字体, 适用于 ttf ，otf,ttc
 */
+ (NSMutableArray*)customFontArrayWithPath:(NSString*)path;

//从保存到plist文件中的绝对路径获取URL
+ (NSURL *)getFileURLFromAbsolutePath:(NSString *)absolutePath;
+ (NSString *)getFileURLFromAbsolutePath_str:(NSString *)absolutePath;

/**判断URL是否为本地相册
 */
+ (BOOL)isSystemPath:(NSString *)path;
+ (BOOL)isSystemPhotoUrl:(NSURL *)url;

+(NSMutableArray *)getColorArray;
+ (NSInteger)getColorIndex:(UIColor *)color;
+(NSMutableArray *)getGroupColorArray;
+ (UIColor *)colorWithHexStr:(NSString *)hexString;
/**获取媒体的实际大小
 */
+ (CGSize)getFileActualSize:(VEMediaInfo *)file;

/**MediaAsset转为VEMediaInfo
 */
+ (VEMediaInfo *)vassetToFile:(MediaAsset *) vvasset;

/**VEMediaInfo转为MediaAsset
 */
+(MediaAsset *)canvasFile:(VEMediaInfo *) file;

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
+ (NSString *)getMusicDownloadPathWithDic:(NSDictionary *)itemDic;
+ (NSString *)getMediaIdentifier;
+ (NSString *)getCollageDownloadPathWithDic:(NSDictionary *)itemDic;
+ (NSMutableArray *)getMaskArray;

+ (MaskObject *)getMaskWithName:(NSString *)maskName;

+ (CustomFilter *)getCustomFilterWithFolderPath:(NSString *)folderPath currentFrameImagePath:(NSString *)currentFrameImagePath atMedia:( id ) mediaOrFile;
+ (CustomFilter *)getCustomFilterWithFolderPath:(NSString *)folderPath currentFrameImagePath:(NSString *)currentFrameImagePath caption:(Caption *)caption;
#pragma mark- 多脚本json加载
+ (CustomMultipleFilter *)getCustomMultipleFilerWithFolderPath:(NSString *) folderPath currentFrameImagePath:(NSString *)currentFrameImagePath;

+ (CustomTransition *)getCustomTransitionWithJsonPath:(NSString *)configPath;

+ (void)setApngCaptionFrameArrayWithImagePath:(NSString *)path jsonDic:(NSMutableDictionary *)jsonDic;
+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (BOOL)exportSlomoVideoFile:(VEMediaInfo *)file;
+ (BOOL)createSaveTmpFileFolder;

+(CGSize)getPEexpSize:(NSMutableArray *) peMediaInfos;
+ (UIImage *)getFullScreenImageWithUrl:(NSURL *)url;
+ (UIImage *)getFullImageWithUrl:(NSURL *)url;

#pragma mark- 居中处理，计算对应的Crop
+ (CGRect)getFixedRatioCropWithMediaSize:(CGSize)mediaSize newSize:(CGSize)newSize;

+ (CGSize)getEditOrginSizeWithFile:(VEMediaInfo *)file ;
+ (CGSize)getEditSizeWithFile:(VEMediaInfo *)file;

+(UIView *)initReversevideoProgress:(  UIViewController * ) viewController atLabelTag:(int *) labelTag atCancel:(SEL)cancel;
+ (NSString *) getResourceFromBundle : (NSString *) bundleName resourceName:(NSString *)name Type : (NSString *) type;
+ (UIImage *)imageWithContentOfPath:(NSString *)path;
+ (UIImage *)imageWithContentOfPathFull:(NSString *)path;
+ (UIImage *)imageWithWebP:(NSString *)filePath error:(NSError **)error;
///获取当前时间戳作为文件名
+ (NSString *)getFileNameForNowTime;

//获取
+(NSString *)getPEImagePathForNowTime;

+(UIImage *)getSystemPhotoImage:( NSURL * ) url;

+ (UIImage *)image:(UIImage *)image rotation:(float)rotation cropRect:(CGRect)cropRect;

+(CustomFilter *)getAnimateCustomFilter:(NSString *) path;

+(NSInteger)setFontIndex:( NSString * ) name;

+ (NSURL *)getFileUrlWithFolderPath:(NSString *)folderPath fileName:(NSString *)fileName;
+ (id)getNetworkMaterialWithType:(NSString *)type
                          appkey:(NSString *)appkey
                         urlPath:(NSString *)urlPath;

+(NSArray *)classificationParams:( NSString * ) type atAppkey:( NSString * ) appkey atURl:( NSString * ) netMaterialTypeURL;
+ (id)updateInfomation:(NSMutableDictionary *)params andUploadUrl:(NSString *)uploadUrl;
+ (id)getNetworkMaterialWithParams:(NSMutableDictionary *)params
                            appkey:(NSString *)appkey
                           urlPath:(NSString *)urlPath;

+(UILabel *)loadProgressView:(CGRect) rect;

#pragma mark- 压缩
+ (void)OpenZip:(NSString*)zipPath  unzipto:(NSString*)_unzipto caption:(BOOL)caption;
+ (BOOL)OpenZip:(NSString*)zipPath unzipto:(NSString*)_unzipto fileName:(NSString *)fileName;
+ (BOOL)OpenZipp:(NSString*)zipPath  unzipto:(NSString*)_unzipto;
+ (BOOL)OpenZip:(NSString*)zipPath  unzipto:(NSString*)_unzipto;
+(NSString *)objectToJson:(id)obj;


+(NSDictionary *)getCaptionConfig_Dic:( NSString * ) configPath;
+(Caption *)getCaptionConfig:( NSString * ) configPath atStart:(float) startTime atConfig:(NSDictionary **) config atType:(NSInteger) captionType;

//字体
+(void)downloadFonts:(void(^)(NSError *error))callBack;

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage *)rescaleImage:(UIImage *)image size:(CGSize)size;

+ (UIImage*)drawImages:(NSMutableArray *)images size:(CGSize)size animited:(BOOL)animited;

+ (CaptionAnimationType)captionAnimateToCaptionAnimation:(CaptionAnimateType)type;

#pragma mark- 美颜设置
+ (void)setMediaBeauty:(MediaAsset *)asset beautyType:(KBeautyType)type faceRect:(CGRect)faceRect beautyValue:(float)value;

//获取转场
+ (NSMutableArray *)getTransitionArray;
//获取转场缩略图路径
+ (NSString *)getTransitionIconPath:(NSString *)typeName itemName:(NSString *)itemName;
//获取转场文件路径
+ (NSString *)getTransitionPath:(NSString *)typeName itemName:(NSString *)itemName;
//设置转场
+ (void)setTransition_Network:(Transition *)transition file:(VEMediaInfo *)file;
+ (void)setTransition:(Transition *)transition file:(VEMediaInfo *)file atConfigPath:(NSString *) configPath;

+(NSString *)getCollageIdentifier;
+(NSString *)getSuperposiIdentifier;

+ (NSString *) getVideoUUID;

+ (void)refreshVeCoreSDK:(VECore *)veCoreSDK
        withTemplateInfo:(VECoreTemplateInfo *)templateInfo
              folderPath:(NSString *)folderPath
                isExport:(BOOL)isExport
                coverUrl:(NSURL *)coverUrl;

+ (void)setVeCoreSDKSecens:(VECore *)veCoreSDK
          withTemplateInfo:(VECoreTemplateInfo *)templateInfo
                folderPath:(NSString *)folderPath;

//替换媒体
+ (void)replaceMedia:(MediaAsset *)media withVEMediaInfo:(VEMediaInfo *)file videoSize:(CGSize)videoSize;

#pragma mark - 字幕动画
+ (CustomFilter *)getSubtitleAnimation:(NSMutableDictionary *) itemDic categoryId:(NSString *)categoryId atAnimationPath:(NSString *) animationPath atCaptionItem:( CaptionItem * ) captionItem;
#pragma mark- 花字
+ (CaptionEffectCfg *)getFLowerWordConfigWithIndex:(NSInteger)index;
+(CaptionEffectCfg *)getFLowerWordConfig:( NSString * ) configPath;

#pragma mark- 文字模版
+(NSDictionary *)getTextTemplateEffectConfig:( NSString * ) configPath;
+(CaptionEx *)getTextTemplateCaptionConfig:( NSString * ) configPath atStart:(float) startTime atConfig:(NSDictionary **) config atName:(NSString *) name;
+(CustomFilter *)getTextTemplateAnimation:( NSString * ) configPath  atFileName:(NSString *) fileName atCaptionItem:( CaptionItem * ) captionItem;

//判断图片是否有alpha通道
+ (BOOL)CGImageRefContainsAlpha:(CGImageRef)imageRef;

#pragma mark- 气泡
+(void)getConfig_CaptionEx:( CaptionEx * ) captionEx atCaptionConfig:( NSString * ) configPath atConfig:( NSDictionary** ) config;
#pragma mark- 贴纸
+(void)getConfig_CaptionStickerEx:( CaptionEx * ) captionEx atCaptionConfig:( NSString * ) configPath atConfig:( NSDictionary** ) config;

+ (NSString *)getVerBationAnimationFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;

+(  CustomFilter * )getSubtitleAnmation:( NSString * ) configPath atPath:( NSString * ) path atCaptionItem:( CaptionItem * ) captionItem;
+(CustomFilter *)getAnmationDic:( NSMutableDictionary * ) effectDic atPath:(NSString *)path;
+(MaskObject * )getMaskObject:(NSString *) maskName;

+(NSArray *)getShowFiles:( NSString * ) path;

+(NSString*)getBackgroundStyleConfigPath:(NSDictionary *)obj atPath:( NSString * ) path;

+(float)getMediaAssetScale:( CGSize ) size atRect:(CGRect) rect atCorp:(CGRect) corp atSyncContainerHeihgt:(CGSize) syncContainerSize atIsWatermark:(BOOL) isWatermark;

+(CGSize)URL_ImageSize:(NSURL *) url atCrop:(CGRect) crop;

+(CGRect)pasterView_RectinScene:(CGSize) size atRect:(CGRect) rect atSyncContainerSize:(CGSize) syncContainerSize atScale:(float *) scale atOtherSyncontainerSize:(CGSize) otherSyncContainerSize;

+(CGRect)getCrop:( CGSize ) size atOriginalSize:( CGSize ) originalSize;

+(void )getOriginaImage:( CVPixelBufferRef  ) originaImage atGrayscaleImage:( CVPixelBufferRef ) grayscaleImage atSize:( CGSize ) size;


+ (NSMutableArray *)getAnimationArrayWithAppkey:(NSString *)appKey
                             typeUrlPath:(NSString *)typeUrlPath
                           specialEffectUrlPath:(NSString *)specialEffectUrlPath;
+ (NSMutableArray *)getStickerAnimationArrayWithAppkey:(NSString *)appKey
                             typeUrlPath:(NSString *)typeUrlPath
                                  specialEffectUrlPath:(NSString *)specialEffectUrlPath;
+ (NSString *)getStickerAnimationFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;
+ (CustomFilter *)getStickerAnimationCustomFilter:(NSMutableDictionary *) itemDic categoryId:(NSString *)categoryId atType:(NSInteger) typeIndex atCaption:( CaptionEx *) captionex;
+ (CustomFilter *)getOverlayAnimationCustomFilter:(NSMutableDictionary *) itemDic categoryId:(NSString *)categoryId atType:(NSInteger) typeIndex atCaption:( Overlay *) overlay;
+ (CustomFilter *)getOverlayAnimationCustomFilterWithPath:(NSString *) path typeIndex:(NSInteger)typeIndex atCaption:( Overlay *) overlay;
+ (CustomFilter *)getStickerAnimationCustomFilterWithPath:(NSString *) path atType:(NSInteger) typeIndex atCaption:( CaptionEx *) captionex;
+ (void)downloadIconFile:(VEAdvanceEditType)type
              editConfig:(VEEditConfiguration *)editConfig
                  appKey:(NSString *)appKey
               cancelBtn:(UIButton *)cancelBtn
           progressBlock:(void(^)(float progress))progressBlock
                callBack:(void(^)(NSError *error))callBack
             cancelBlock:(void(^)(void))cancelBlock;
+ (void)getNetworkMaterialWithParams:(NSMutableDictionary *)params
                            appkey:(NSString *)appkey
                           urlPath:(NSString *)urlPath
                           completed:(void(^)(id result,NSError *))completed;

+ (CustomFilter *)getAnimationCustomFilter:(NSMutableDictionary *) itemDic categoryId:(NSString *)categoryId;
+ (CustomFilter *)getAnimationCustomFilterWithPath:(NSString *) path;
+ (NSString *)getAnimationFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;
#pragma mark 读取视频文件大小
+ (long long) fileSizeAtPath:(NSString*) filePath;
+ (long long)getNetworkFileBytesWithURLStr:(NSString*)urlStr;//获取网络文件大小

//MARK: 提示
+(void)initCommonAlertViewWithTitle:(NSString *)title
                            message:(NSString *)message
                  cancelButtonTitle:(NSString *)cancelButtonTitle
                  otherButtonTitles:(NSString *)otherButtonTitles
                   atViewController:( UIViewController * ) viewController
                      atCancelBlock:(void(^)(void))cancelBlock atOtherBlock:(void(^)(void))otherBlock;
+ (NSString *)timeToStringNoSecFormat:(float)time;

+ (BOOL)createZip:(NSString *)path zipPath:(NSString *)zipPath;

//剪同款
+ (NSString *)getCachedAPITemplatePathWithUrlStr:(NSString *)urlStr;

+ (NSString * _Nullable)getPathFolderName:(NSString * _Nullable)path;

+ (CVPixelBufferRef)pixelBufferFromCGImage:(UIImage *)img;
+(void)saveUserInfo:(id) obj forKey:(NSString*) key;
+(BOOL)readUserInfoBoolForKey:(NSString*) key;
//MARK: 添加区域权限
/**添加区域权限
 */
+ (CALayer *)arealayerWithView:(UIView *)view size:(CGSize)size;

+(CGRect)getOverlayBackgroundImageCrop:( CGSize ) imageSize atBackgroundImageSize:( CGSize ) backgroundImageSize;

@end
