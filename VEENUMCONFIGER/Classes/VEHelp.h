
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <VEENUMCONFIGER/VEMediaInfo.h>
#import <VEENUMCONFIGER/UIImage+VEGIF.h>

typedef NSString *VENetworkResourceType NS_STRING_ENUM;

FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_CardMusic;//卡点音乐
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_CloudMusic;//配乐
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_OnlineAlbum;//在线相册
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_SoundEffect;//音效
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_MediaAnimation;//媒体动画
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_Text;//文字
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_TextAnimation;//文字动画
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_TextTemplate;//文字模板
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_Sticker;//贴纸
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_StickerAnimation;//贴纸动画
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_Filter;//滤镜
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_Transition;//转场
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_ScreenEffect;//画面特效
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_Font;//字体
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_APITemplate;//API剪同款
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_Canvas;//画布
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_ParticleEffect;//粒子特效
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_ShootParticle;//拍摄粒子
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_CoverTemplate;//封面模板
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_DoodlePen;//涂鸦笔
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_Mask;//蒙版
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_MaskShape;//形状蒙版
FOUNDATION_EXPORT VENetworkResourceType const VENetworkResourceType_Matting;//抠图

//亮度
extern float const VEAdjust_MinValue_Brightness;
extern float const VEAdjust_MaxValue_Brightness;
extern float const VEAdjust_DefaultValue_Brightness;
//对比度
extern float const VEAdjust_MinValue_Contrast;
extern float const VEAdjust_MaxValue_Contrast;
extern float const VEAdjust_DefaultValue_Contrast;
//饱和度
extern float const VEAdjust_MinValue_Saturation;
extern float const VEAdjust_MaxValue_Saturation;
extern float const VEAdjust_DefaultValue_Saturation;
//锐度
extern float const VEAdjust_MinValue_Sharpness;
extern float const VEAdjust_MaxValue_Sharpness;
extern float const VEAdjust_DefaultValue_Sharpness;
//色温
extern float const VEAdjust_MinValue_WhiteBalance;
extern float const VEAdjust_MaxValue_WhiteBalance;
extern float const VEAdjust_DefaultValue_WhiteBalance;
//暗角
extern float const VEAdjust_MinValue_Vignette;
extern float const VEAdjust_MaxValue_Vignette;
extern float const VEAdjust_DefaultValue_Vignette;
//高光
extern float const VEAdjust_MinValue_Highlight;
extern float const VEAdjust_MaxValue_Highlight;
extern float const VEAdjust_DefaultValue_Highlight;
//阴影
extern float const VEAdjust_MinValue_Shadow;
extern float const VEAdjust_MaxValue_Shadow;
extern float const VEAdjust_DefaultValue_Shadow;
//颗粒
extern float const VEAdjust_MinValue_Granule;
extern float const VEAdjust_MaxValue_Granule;
extern float const VEAdjust_DefaultValue_Granule;
//光感
extern float const VEAdjust_MinValue_LightSensation;
extern float const VEAdjust_MaxValue_LightSensation;
extern float const VEAdjust_DefaultValue_LightSensation;
//色调
extern float const VEAdjust_MinValue_Tint;
extern float const VEAdjust_MaxValue_Tint;
extern float const VEAdjust_DefaultValue_Tint;
//褪色
extern float const VEAdjust_MinValue_Fade;
extern float const VEAdjust_MaxValue_Fade;
extern float const VEAdjust_DefaultValue_Fade;
//曝光
extern float const VEAdjust_MinValue_Exposure;
extern float const VEAdjust_MaxValue_Exposure;
extern float const VEAdjust_DefaultValue_Exposure;

@interface VEHelp : NSObject
+ (NSString *)createFilename;

+ (UIEdgeInsets) safeAreaInsets;
+(NSString *)pathFontForURL:(NSURL *)aURL;

+ (CGSize)getEditOrginSizeCropWithFile:(VEMediaInfo *)file;

+ (void)getCurrentImage:(BOOL)screenshot callBack:(void (^)(UIImage *))imageBlock;

//获取最长的一段
+ (NSMutableArray *)getMaxLengthStringArr:(NSString *)string fontSize:(float)fontSize;

+ (NSString *)pathForURL_font_WEBP_down:(NSString *)name extStr:(NSString *)extStr;

+(BOOL) hasCachedFont:(NSString *)code url:(NSString *)fontUrl;

+ (UIImage *) imageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

/// 获取项目语言简写字符串
+ (NSString *)getProjectLanguageShorthand;

+(UIImage*) imageWithColor:(UIColor*)color atSize:( CGSize ) size;

+ (void)webpToPng:(NSString *)webpPath;

+ (UIImage *)geScreenShotImageFromVideoURL:(NSURL *)fileURL atTime:(CMTime)time  atSearchDirection:(bool) isForward;

+ (CGFloat)getAnglesWithThreePoint:(CGPoint)pointA pointB:(CGPoint)pointB pointC:(CGPoint)pointC;

+ (NSString *)geCaptionExSubtitleIdentifier;

+ (NSMutableArray *)getCategoryMaterialWithAppkey:(NSString *)appKey
                                      typeUrlPath:(NSString *)typeUrlPath
                                  materialUrlPath:(NSString *)materialUrlPath
                                     materialType:(VECustomizationFunctionType)materialType;

/** 获取媒体添加时默认大小
 */
+ (CGSize)getMediaDefaultSizeWithSyncContainerSize:(CGSize)syncContainerSize
                                         mediaSize:(CGSize)size
                                         mediaType:(VEAdvanceEditType)mediaType;

+(float)getMediaAssetScale_File:( CGSize ) size
                         atRect:(CGRect) rect
                         atCorp:(CGRect) corp
          atSyncContainerHeihgt:(CGSize) syncContainerSize
                      mediaType:(VEAdvanceEditType)mediaType;

+(NSMutableAttributedString *)getAttrString:(NSString *) string atForegroundColor:(UIColor *) foregroundColor atStrokeColor:(UIColor *) strokeColor atShadowBlurRadius:(float) shadowBlurRadius atShadowOffset:(CGSize) shadowOffset atShadowColor:(UIColor *) shadowColor;

+(NSString *)pathForURL_font:(NSString *)name extStr:(NSString *)extStr hasNew:(BOOL)hasNew;
+ (UIImage *)image:(UIImage *)image withBackgroundColor:(UIColor *)color;
//MARK: 添加特效
+(CustomMultipleFilter *)getCustomMultipleFilter:( NSDictionary * ) itemDic atPath:( NSString * ) path atTimeRange:( CMTimeRange ) timeRange atImage:( UIImage * ) FXFrameTexture atFXFrameTexturePath:( NSString * )  fXFrameTexturePath atEffectArray:( NSMutableArray * ) effectArray;
+ (NSString *)getEffectCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;
+ (NSString *)getSuperposiCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;
+ (NSString *)getBoxCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;
+ (NSString *)getNetworkResourceCachedPathWithFolderPath:(NSString *)folderPath networkResourcePath:(NSString *)networkResourcePath updatetime:(NSString *)updatetime;
+(id)objectForData:(NSData *)data;

+ (BOOL)isSystemPhotoPath:(NSString *)path;
+ (NSString *) system;
+ (BOOL)isLowDevice;
+ (double)totalMemory;
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

+(NSString *)getMaterialTTSAudioPath:( NSString * ) fileName;
/**从URL获取缩率图照片
 */
+ (UIImage * )getThumbImageWithUrl:(NSURL * )url;
+ (UIImage * )getThumbImageWithPath:(NSString *)path;
+(NSString * )getMaterialThumbnail:(NSURL * ) fileUrl;
+(NSString *)getMaterialWebmMp3:(NSURL *) fileUrl;
+(BOOL)getWebmAudioWithMp3:( NSURL * ) webmURL;
+(NSString *)getWhisperModelPath:(NSString *) name;
//多线程保存缩略图
+(void)fileImage_Save:(NSMutableArray<VEMediaInfo *> * ) fileArray atProgress:(void(^)(float progress))completedBlock atReturn:(void(^)(bool isSuccess))completedReturn;
+(void)save_Image:(int) currentIndex atURL:(NSURL * ) url atPatch:(NSString * ) fileImagePatch atTimes:(NSMutableArray *) times atProgressCurrent:(int) progressIndex  atCount:(int) count atProgress:(void(^)(float progress))completedBlock;

+ (NSBundle *)getBundleName:( NSString * ) name atViewController:( UIViewController * ) viewController;
+ (NSBundle *)getBundleName:( NSString * ) name;
+( UIImage * )imageNamed:(NSString *)name atBundle:( NSBundle * ) bundle;
+(UIImage *)imageWithContentOfFile:(NSString *)path atBundle:( NSBundle * ) bundle;
+(UIImage *)imageWithContentOfFile:(NSString *)path atBundleName:(NSString *)bundleName;
+( UIViewController * )getCurrentViewController;
/**加载图片
 */

+ (NSString *)getSourcePath:(NSString *)path;
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

+(void)getStickerAnimation:( NSString * ) path atCaption:( Caption * ) caption atCustomFiler:( CustomFilter * ) customFilter;
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
+ (NSString *)HexStrWithcolor:(UIColor *)color;
+ (UIColor *)colorWithHexStr:(NSString *)hexString;
+ (NSMutableArray *)getDoodlePenColors;
+ (BOOL)colorIsEqual:(UIColor *)color1 color2:(UIColor *)color2;
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

+ (NSString *)getMaskDownloadPathWithDic:(NSDictionary *)itemDic;
+ (NSString *)getchangeHairDownloadPathWithDic:(NSDictionary *)itemDic;
+ (NSString *)getFilterDownloadPathWithDic:(NSDictionary *)itemDic;
+ (NSString *)getlocalFileMusicPathWithDic:(NSString *)filename;
+ (NSString *)getScaleDownloadPathWithDic:(NSDictionary *)itemDic;
+ (NSString *)getMusicDownloadPathWithDic:(NSDictionary *)itemDic;
+ (NSString *)getMusicDownloadFolderWithDic:(NSDictionary *)itemDic;
+ (NSString *)getMediaIdentifier;
+ (NSString *)getCollageDownloadPathWithDic:(NSDictionary *)itemDic;
+ (NSString *)getCoverTemplateDownloadFolderWithDic:(NSDictionary *)itemDic;

+ (NSMutableArray *)getMaskArray;

+ (MaskObject *)getMaskWithName:(NSString *)maskName;
+ (VEMaskType)getMaskTypeWithPath:(NSString *)path;
+ (MaskObject *)getMaskWithPath:(NSString *) path;
+ (MaskObject *)getMaskShapeWithPath:(NSString *) path;

+ (NSDictionary *) getVideoInformation:( NSURL * ) url;

+(CustomFilter *)copyCustomCaption:( CustomFilter * ) Animate atCpation:( Caption * ) caption;
+(CustomFilter *)copyCustomCaptionEx:( CustomFilter * ) Animate atCpationItem:( CaptionItem * ) item;
+(CustomFilter *)copyCustomMediaAsset:( CustomFilter * ) Animate atMedia:( MediaAsset * ) asset;
+ (CustomFilter *)getCustomFilterWithFolderPath:(NSString *)folderPath currentFrameImagePath:(NSString *)currentFrameImagePath atMedia:( id ) mediaOrFile;
+ (CustomFilter *)getCustomFilterWithFolderPath:(NSString *)folderPath currentFrameImagePath:(NSString *)currentFrameImagePath caption:(Caption *)caption;
#pragma mark- 多脚本json加载
+ (CustomMultipleFilter *)getCustomMultipleFilerWithFolderPath:(NSString *) folderPath currentFrameImagePath:(NSString *)currentFrameImagePath;

+ (CustomTransition *)getCustomTransitionWithJsonPath:(NSString *)configPath;

+ (void)setApngCaptionFrameArrayWithImagePath:(NSString *)path jsonDic:(NSMutableDictionary *)jsonDic;
+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)gradientImageWithColors:(NSArray *)colors size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (BOOL)exportSlomoVideoFile:(VEMediaInfo *)file;
+ (BOOL)createSaveTmpFileFolder;

+(CGSize)getPEexpSize:(NSMutableArray *) peMediaInfos;
+ (UIImage *)getFullScreenImageWithUrl:(NSURL *)url;
+ (UIImage *)getFullImageWithUrl:(NSURL *)url;

#pragma mark- 居中处理，计算对应的Crop
+ (CGRect)getFixedRatioCropWithMediaSize:(CGSize)mediaSize newSize:(CGSize)newSize;

+ (CGSize)getEditOrginSizeWithFile:(VEMediaInfo *)file ;
+ (CGSize)getEditSizeWithFile:(VEMediaInfo *)file;

+(UIView *)initAgainTrackView:(  UIViewController * ) viewController atTitle:( NSString * ) title atConfirm:(SEL) confirm atCancel:(SEL) cancel;
+(UIView *)initReversevideoProgress:(  UIViewController * ) viewController atLabelTag:(int *) labelTag atCancel:(SEL)cancel;
+(UIView *)initReversevideoProgressView:(  UIView * ) reverseView atLabelTag:(int *) labelTag atCancel:(SEL)cancel;
+(UIView *)initSpeechRecognitionProgress:(  UIViewController * ) viewController atLabelTag:(int *) labelTag atCancel:(SEL)cancel;
+ (NSString *) getResourceFromBundle : (NSString *) bundleName resourceName:(NSString *)name Type : (NSString *) type;
+ (UIImage *)imageWithContentOfPath:(NSString *)path;
+ (UIImage *)imageWithContentOfPathFull:(NSString *)path;
+ (UIImage *)imageWithWebP:(NSString *)filePath error:(NSError **)error;


//日期转字符串
+(NSString *)dateToTimeString:(NSDate *)date;
+(NSString *)dateToTimeString1:(NSDate *)date;
//获取当前时间戳（毫秒级）
+(long)getNowTimeTimestamp;
///获取当前时间戳作为文件名
+ (NSString *)getFileNameForNowTime;
+ (NSString *)getNowTimeToString;
+ (NSString *)getNowShareTimeToString;
//获取
+(NSString *)getPEImagePathForNowTime;

+(UIImage *)getSystemPhotoImage:( NSURL * ) url;

+ (UIImage *)image:(UIImage *)image rotation:(float)rotation cropRect:(CGRect)cropRect;

+(CustomFilter *)getAnimateCustomFilter:(NSString *) path;

+(NSInteger)setFontIndex:( NSString * ) name;

+ (NSInteger)getSubtitlePresetTypeIndexWithTextColor:(UIColor *)textColor
                                         strokeColor:(UIColor *)strokeColor
                                             bgColor:(UIColor *)bgColor;

+ (NSURL *)getUrlWithFolderPath:(NSString *)folderPath fileName:(NSString *)fileName;
+ (NSURL *)getFileUrlWithFolderPath:(NSString *)folderPath fileName:(NSString *)fileName;
+ (id)getNetworkMaterialWithType:(NSString *)type
                          appkey:(NSString *)appkey
                         urlPath:(NSString *)urlPath;

+(NSArray *)classificationParams:( NSString * ) type atAppkey:( NSString * ) appkey atURl:( NSString * ) netMaterialTypeURL;
+(NSString *)createPostURL:(NSMutableDictionary *)params;
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

#pragma mark - 多脚本json加载 特效
+ (CustomMultipleFilter *)getCustomMultipleFilerWithFxId:(NSString *)fxId
                             filterFxArray:(NSArray *)filterFxArray
                                 timeRange:(CMTimeRange)timeRange
                                 currentFrameTexturePath:(NSString *)currentFrameTexturePath
                                                  atPath:( NSString * ) path;
+ (CustomMultipleFilter *)getCustomMultipleFilerWithPath:(NSString *)path
                                              categoryId:(NSString *)categoryId
                                              resourceId:(NSString *)resourceId
                                               timeRange:(CMTimeRange)timeRange
                                               currentFrameTexturePath:(NSString *)currentFrameTexturePath;
+(CaptionEffectColorParam *)getShadowStrokes:( NSDictionary * ) obj;
+(NSDictionary *)getConfig_Dic:( NSString * ) configPath;
+(NSDictionary *)getCaptionConfig_Dic:( NSString * ) configPath;
+(NSMutableDictionary *)jsonToObject:( NSString * ) jsonStr;
+(Caption *)getCaptionConfig:( NSString * ) configPath atStart:(float) startTime atConfig:(NSDictionary **) config atType:(NSInteger) captionType;

//字体
+(void)downloadFonts:(void(^)(NSError *error))callBack;
+ (UIImage *)drawImage:(UIImage *)image bgImage:(UIImage *)bgImage;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+ (UIImage *)rescaleImage:(UIImage *)image size:(CGSize)size;

+ (UIImage *)rescaleImageArray:(NSMutableArray *)imageArray size:(CGSize)size;

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

+(NSString *)getCollageIdentifier:( NSInteger ) idx;
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

//处理封面作为媒体（改变虚拟视频的总时长）
+ (void)refreshVECore:(VECore *)videoCoreSDK isExport:(BOOL)isExport coverFile:(VEMediaInfo *)coverFile fps:(int)fps;

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

+(float)getMediaAssetScale:( CGSize ) size
                    atRect:(CGRect) rect
                    atCorp:(CGRect) corp
     atSyncContainerHeihgt:(CGSize) syncContainerSize
                 mediaType:(VEAdvanceEditType)mediaType;

+(CGSize)URL_ImageSize:(NSURL *) url atCrop:(CGRect) crop;

+(CGRect)pasterView_RectinScene:(CGSize) size atRect:(CGRect) rect atSyncContainerSize:(CGSize) syncContainerSize atScale:(float *) scale atOtherSyncontainerSize:(CGSize) otherSyncContainerSize;

+(CGRect)getCrop:( CGSize ) size atOriginalSize:( CGSize ) originalSize;

+(void )getOriginaImage:( CVPixelBufferRef  ) originaImage atGrayscaleImage:( CVPixelBufferRef ) grayscaleImage atSize:( CGSize ) size;
+(void )getOriginaImageCutout:( CVPixelBufferRef  ) originaImage atGrayscaleImage:( unsigned char * ) imgData atSize:( CGSize ) size;

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

+ (NSString *)getCachedFileNameWithUrlStr:(NSString *)urlStr;

+ (NSString *)getPathFolderName:(NSString *)path;

+ (CVPixelBufferRef)pixelBufferFromCGImage:(UIImage *)img;
+ (CVPixelBufferRef)pixelBufferFromCIImage:(CIImage *)image;
+ (void)copyPixelBuffer:(CVPixelBufferRef)copyedPixelBuffer toPixelBuffer:(CVPixelBufferRef)pixelBuffer;
+(void)saveUserInfo:(id) obj forKey:(NSString*) key;
+(BOOL)readUserInfoBoolForKey:(NSString*) key;


+ (NSString *)cachedFileNameForKey:(NSString *)key;

//MARK: 添加区域权限
/**添加区域权限
 */
+ (CALayer *)arealayerWithView:(UIView *)view size:(CGSize)size;

+(CGRect)getOverlayBackgroundImageCrop:( CGSize ) imageSize atBackgroundImageSize:( CGSize ) backgroundImageSize;

+(void)getRemoveTranslucent:( CVPixelBufferRef ) maskPixelBuffer;

+ (BOOL) isVideoPortrait:(AVURLAsset *)asset;

+ (NSString *)getTransitionCachedFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;

+ (UIImage *)imageRotatedByDegrees:(UIImage *)cImage rotation:(float)rotation;

+(NSString *)pathAssetVideoForURL:(NSURL *)aURL;

+ (CGSize )getVideoSizeForTrack:(AVURLAsset *)asset;

+ (CGSize)trackSize:(NSURL *)contentURL rotate:(float)rotate;
+ (CGSize)trackSize:(NSURL *)contentURL rotate:(float)rotate crop:(CGRect)crop;

+ (NSString *)getAutoSegmentImagePath_Sky:(NSURL *)url;
+ (NSString *)getAutoSegmentImagePath:(NSURL *)url;
+ (NSString *)getAutoSegmentMaskImagePath:(NSURL *)autoSegmentImageUrl;
+ (NSString *)getAutoSegmentImagePath_Time:(NSURL *)url atUUID:( NSString * ) uuid;
+ (NSString *)getAutoSegmentImageFolder_Time:(NSURL *)url atUUID:( NSString * ) uuid;
+ (NSString *)getErasePenImagePath:(NSURL *)url;

+ (NSString *)getMaterialCachedFilePath:(VECustomizationFunctionType)materialType netFilePath:(NSString *)netFilePath updatetime:(NSString *)updatetime;
+ (UIImage *)screenCapture;
+ (UIImage *)blurScreenCapture;
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
+ (BOOL)isVideoUrl:(NSURL *)url;

+ (Particle *)getParticle:( NSString * ) path atFramePath:( NSString * ) framePath;
+ (NSMutableArray *)getCameraParticle:( NSString * ) path atFramePath:( NSString * ) framePath atSize:( CGSize ) size;
+ (Particle *)getVEParticle:( NSString * ) path atFramePath:( NSString * ) framePath  atObj:( NSMutableDictionary * ) obj;

+(void)impactOccurred:( float ) intensity;

+ (long long) freeDiskSpaceInBytes;
+ (UIColor *)getCategoryFilterBgColorWithDic:(NSDictionary *)dic categoryIndex:(NSInteger)categoryIndex;

+(UIView *)loadCircleProgressView:(CGRect) rect;


+ (Float64)getOriginalTime:( Float64 ) currentTime atOriginalTimeArray:(NSMutableArray *) originalTimeArray atShiftTimeArray:(NSMutableArray *) shiftTimeArray atCurveSpeedPointArray:( NSMutableArray<CurvedSpeedPoint*> *) curveSpeedPointArray;

+ (BOOL)isEqualGraphArray:(NSArray *)graphArray1 graphArray2:(NSArray *)graphArray2;

+(Float64)getCurveSpeedTime:(Float64) originalTime atOriginalTimeArray:(NSMutableArray *) originalTimeArray atShiftTimeArray:(NSMutableArray *) shiftTimeArray atCurveSpeedPointArray:( NSMutableArray<CurvedSpeedPoint*> *) curveSpeedPointArray;

+ (DoodleOption *)getDoodleOptionWithPath:(NSString *)path;

+ (BOOL)doodlePenIsHardnessEnableWithPath:(NSString *)path;
//获取图片某一点的颜色
+ (UIColor *)colorAtPixel:(CGPoint)point source:(UIImage *)image;
+ (UIImage *)getOriginalImageWithUrl:(NSURL *)url;

+ (void)addShadowToView:(UIView *)view withColor:(UIColor *)theColor;
+ (void)addShadowToView:(UIView *)view withColor:(UIColor *)theColor shadowRadius:(float)shadowRadius;
+ (void)addShadowToView:(UIView *)view withColor:(UIColor *)theColor cornerRadii:(CGSize)cornerRadii;
+ (UIImage *)getScreenshotWithView:(UIView *)view;

+ (NSString *)getAnitionSubtitlePenConfigDownloadPathWithDic:(NSDictionary *)itemDic;
+ (NSString *)getAnitionStickerPenConfigDownloadPathWithDic:(NSDictionary *)itemDic;
+ (NSString *)getAnitionSubtitlePenConfigFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;
+ (NSString *)getAnitionStickerPenConfigFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;
+ (NSString *)getTemplateThemeFilePath:(NSString *)urlPath updatetime:(NSString *)updatetime;

+ (NSString *)getConfigPathWithFolderPath:(NSString *)folderPath;

+(void)getTextAndPhotoWith:( MediaAsset * ) asset atTextList:( NSMutableArray * ) textList atGettingImage:(void(^)(UIImage *image))gettingImage;
+(void)getTextAndPhotoWithFile:( VEMediaInfo * ) file atTextList:( NSMutableArray * ) textList atGettingImage:(void(^)(UIImage *image))gettingImage;
+(void)drawTextAndPhotoWith:(void(^)(NSMutableArray * textLists))gettingImage;
+ (CGFloat)getAlphaPixelPercent:(UIImage *)image;
/**左右渐变的背景
 * view : 需要添加渐变的控件
 * colors：渐变色
 */
+ (void) insertColorGradient:(UIView *)view colors:(NSMutableArray <UIColor *>*)colors;
/**获取新的颜色列表
 */
+(NSMutableArray *)getColorList;

#pragma mark- webm测试
+(VEMediaInfo *)testWebmWidthMediaInfo;

+ (NSArray *)getToningHSLColorArray;
+ (NSArray *)getToningSeparationColorArray;
+ (NSArray *)getToningCurveColorArray;

+ (BOOL)isHSLInitialValue:(NSArray *)array;
+ (BOOL)isRGBCurveInitialValue:(NSMutableArray *)array;

/**  文本转语音
 *  @abstract text-to-speech
 *
 *  @param locale       语言
 *  @param ShortName 人物角色
 *  @param text        文字
 *  @param saveAudioPath     mp3文件地址
 *  @param isOnlyReturnAudioPath     是否只返回mp3地址
 *
 * 获取MP3文件（ 后缀 .mp3）
 */
+ (id)updateInfomation_TTSAtLocale:(NSString *)locale
                       atShortName:(NSString *)ShortName
                            atText:(NSString *)text
                     saveAudioPath:(NSString *)saveAudioPath isOnlyReturnAudioPath:(BOOL)isOnlyReturnAudioPath;

/**录制音频时候根据当前数据返回音量大小
 */
+(float)volumeForData:(NSData *)pcmData;

+(NSString *)getChineseFirstLetter:(NSString *)text;

+ (NSMutableData *)getAudioDataWithAssetReader_Customization:( NSURL * ) url atTimeRange:( CMTimeRange ) timeRange atSampleRate:( int ) sampleRate  atChannels:( NSInteger ) channels atBit:( NSInteger ) bit atIsFloat:( BOOL ) isFloat;

//获取音频文件所有数据
+ (NSMutableData *)getAudioDataWithAssetReader:( NSURL * ) url atTimeRange:( CMTimeRange ) timeRange atSampleRate:( int ) sampleRate;

+(NSString *)getUploadToken;
+(NSString *)getPrivateCloud_UploadAudioFile:(NSString *)audioFilePath atToken:( NSString * ) token   atURL:( NSString * ) url;
+(NSMutableArray *)getPrivateCloud_StartASR:( NSMutableArray * ) uploadFileURLs atLanguage:( NSString * ) language  atIsCancel:( BOOL * ) isCancel   atURL:( NSString * ) url atAppkey:( NSString * ) appkey;
//分句
+ (NSMutableArray *)breakSentenceWithText:(NSString *)sentence lineMaxTextLength:(int)lineMaxTextLength;

+ (BOOL)isEmptyStr:(NSString *)str;

+(BOOL)createDocXWithFilePath:( NSString * ) filePath atString:( NSAttributedString * ) attributedString;

+(NSMutableArray *)getTextWordAudioWithFilePath_PrivateCloud:( NSString * ) filePath;

+(NSMutableArray *)createStickerImagePathWithGIF:( NSURL * ) gifURL;

+ (UIImage *) filteredImage:(CIImage *)ciImage isInvert:(BOOL )isInvert;
+ (BOOL)isAllAlphaImage:(CGImageRef)imgref;
+ (UIImage *)drawSelectTextImage:(CGSize )size rects:(NSMutableArray <NSValue *>*)rects;
#pragma mark- 适配比例 按指定比例计算素材裁剪比例
+ (void)getNewfileCrop:(VEMediaInfo *) file atfileCropModeType:(FileCropModeType) ProportionIndex atEditSize:(CGSize) editSize fileCrop:(CGRect)fileCrop;

+ (UIImage *)getImageWithPixelBuffer:(CVPixelBufferRef)pixelBufffer;

@end
