//
//  VEConfigManager.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/21.
//

#import <Foundation/Foundation.h>
#import <VEENUMCONFIGER/VECameraConfiguration.h>
#import <VEENUMCONFIGER/VEEditConfiguration.h>
#import <VEENUMCONFIGER/VEExportConfiguration.h>
#import "VEMediaInfo.h"
typedef NS_ENUM(NSInteger, UIBgStyle) {
    UIBgStyleLightContent = 0, // Light content, for use on dark backgrounds
    UIBgStyleDarkContent  =1, // Dark content, for use on light backgrounds
} API_UNAVAILABLE(tvos);

/**支持的语言
 */
typedef NS_ENUM(NSInteger, SUPPORTLANGUAGE){
    CHINESE,    //中文
    ChineseTraditional,//繁体中文
    ENGLISH,     //英文
    Spanish,//西语
    Portuguese,//葡语
    Russian,//俄语
    Japanese,//日语
    French,//法语
    Korean,//韩语
    OtherLanguages,// 其他语言
};

typedef NS_ENUM(NSInteger, AUDIO_SPEECH_Type){
    AUDIO_SPEECH_Type_System,                    //系统
    AUDIO_SPEECH_Type_TencentCloud,          //腾讯云
    AUDIO_SPEECH_Type_PrivateCloud,            //私有云
    AUDIO_SPEECH_Type_OfflineModel,            //离线模型
};

//导出前回调
typedef void(^VEPrepareExportHandler) (UIViewController *viewController);

//编辑完成导出结束回调
typedef void(^VECompletionHandler) (NSString * videoPath);
//编辑取消回调
typedef void(^VECancelHandler) (void);
//编辑取消回调
typedef void(^VEFailedHandler) (NSError * error);
//云备份中回调
typedef void(^VECloudBackingUpHandler) (int completionCount, int totalCount);
//云备份结束回调
typedef void(^VECloudBackupCompletionHandler) (int completionCount);

typedef void(^VEExporTemplate) (UIViewController * view);


UIKIT_EXTERN NSString * const VEStartExportNotification;

@protocol VESDKDelegate <NSObject>

@optional

/** 设置faceU普通道具
 */
- (void)faceUItemChanged:(NSString *)itemPath;

/** 设置faceU美颜参数
 */
- (void)faceUBeautyParamChanged:(VEFaceUBeautyParams *)beautyParams;

/** 销毁faceU全部道具
 */
- (void)destroyFaceU;

/*
 *录制时，摄像头捕获帧回调，可对帧进行处理
 */
- (void)willOutputCameraSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/*
 *如果需要自定义相册则需要实现此函数
 */
- (void)selectVideoAndImageResult:(UINavigationController *)nav callbackBlock:(void (^)(NSMutableArray *lists))callbackBlock;

/*
 *如果需要自定义相册则需要实现此函数（添加视频）
 */
- (void)selectVideosResult:(UINavigationController *)nav callbackBlock:(void (^)(NSMutableArray *lists))callbackBlock;

/*
 *如果需要自定义相册则需要实现此函数（添加图片）
 */
- (void)selectImagesResult:(UINavigationController *)nav callbackBlock:(void (^)(NSMutableArray *lists))callbackBlock;

/** 保存草稿
 */
- (void)saveDraftResult:(NSError *)error;

/** 显示截取视频界面
 *  Display video capture interface.
 */
- (void)veShowTrimControllerWithSuperView:(UIViewController *)superViewController
                                     file:(VEMediaInfo *)file
                           isRotateEnable:(BOOL)isRotateEnable
                                 trimType:(TRIMMODE)trimType
              trimDuration_OneSpecifyTime:(double)trimDuration_OneSpecifyTime
                        completionHandler:(void (^)(float rotate, CMTimeRange trimTimeRange))completionHandler;

/** 显示裁剪图片界面
 *  Display Cropping Picture Interface.
 */
- (void)veShowCropControllerWithSuperView:(UIViewController *)superViewController
                                     file:(VEMediaInfo *)file
                             isOnlyRotate:(BOOL)isOnlyRotate
                               isOnlyCrop:(BOOL)isOnlyCrop
                                videoSize:(CGSize)videoSize
                        completionHandler:(void (^)(VEMediaInfo *cropedFile))completionHandler;

/** 显示文字板界面
 *  Display the text board interface.
 */
- (void)veShowTextBoardControllerWithSuperView:(UIViewController *)superViewController
                                          file:(VECustomTextPhotoFile *)file
                               videoProportion:(float)videoProportion
                             completionHandler:(void (^)(NSString *textImagePath, VECustomTextPhotoFile *file))completionHandler;

/** 显示相册界面回调
 *  Display album interface callback.
 */
- (void)veShowAlbumControllerWithSuperView:(UIViewController *)superViewController
                            dismissHandler:(void(^)(void))dismissHandler
                         completionHandler:(void (^)(NSMutableArray <id >*filelist))completionHandler
                             cancelHandler:(void(^)(void))cancelHandler;

/** 显示相机界面回调
 *  Display album interface callback.
 */
- (void)veShowCameraControllerWithSuperView:(UIViewController *)superViewController
                                isFromAlbum:(BOOL)isFromAlbum
                         isDefaultTakePhoto:(BOOL)isDefaultTakePhoto
                          completionHandler:(VECompletionHandler)completionHandler
                              cancelHandler:(VECancelHandler)cancelHandler;

/** 开始直播推流
 */
- (void)startLivePush;

/** 停止直播推流
 */
- (void)stopLivePush;

/** 获取推流视频数据
 *  Get streaming video data.
 */
- (void)getInputStreamVideoPixelBuffer:(CVPixelBufferRef)videoPixelBuffer;

/** 获取推流音频数据
 *  Get streaming audio data.
 */
//- (void)getInputStreamAudioData:(NSMutableData *)audioData;
- (void)getInputStreamAudioSampleBuffer:(CMSampleBufferRef)audioSampleBuffer;

@end

@interface VEConfigManager : NSObject
/**文件存放根目录
 */
@property (nonatomic, strong) NSString *directory;


/** 主题样式 默认 亮色字，深色背景 (default  UIBgStyleLightContent ：)
 */
@property (nonatomic, assign) UIBgStyle backgroundStyle;
/**  设置是否为 图片编辑
 */
@property (nonatomic, assign) BOOL isPEPhotoAlbum;
/**  设置是否为 导出后还能继续返回编辑(default false)
 */
@property (nonatomic, assign) BOOL isExportBackEdit;

+ (instancetype)sharedManager;

//是否为新字体
@property (nonatomic, assign) BOOL  isNewFont;
@property (nonatomic, assign) BOOL isPictureEditing;

@property (nonatomic, assign) BOOL  isPEPhoto;

@property (nonatomic,strong) NSMutableArray          *edit_functionLists;
@property (nonatomic,strong) VEExportConfiguration   *exportConfiguration;
@property (nonatomic,strong) VEEditConfiguration     *editConfiguration;
@property (nonatomic,strong) VECameraConfiguration   *cameraConfiguration;

@property (nonatomic,strong) VEExportConfiguration   *peExportConfiguration;
@property (nonatomic,strong) VEEditConfiguration     *peEditConfiguration;
@property (nonatomic,strong) VECameraConfiguration   *peCameraConfiguration;

@property (nonatomic, assign) BOOL  isAndroidTemplate;

/**视频输出路径
 */
@property (copy,nonatomic)NSString  * outPath;
/**API模板输出文件夹路径
 */
@property (copy,nonatomic)NSString  * apiTemplateExportFolerPath;
/**视频输出路径
 */
@property (copy,nonatomic)NSString  * draftPath;

/** 需扫描的缓存文件夹名称
 */
@property (copy,nonatomic)NSString  * appAlbumCacheName;
/** 缓存文件夹类型，默认为kFolderNone
 */
@property (nonatomic, assign) FolderType folderType;

/** 应用APPKey
 *  在官网中注册应用的key
 *  Register the application key on the official website
 */
@property (copy,nonatomic)NSString  * appKey;
@property (copy,nonatomic)NSString  * licenceKey;
@property (copy,nonatomic)NSString  * appSecret;
/** 视频抠像功能的appKey
 */
@property (copy,nonatomic)NSString *videoMattingAppKey;

@property (nonatomic, assign) BOOL       statusBarHidden;
@property (nonatomic, assign) float      videoAverageBitRate;
@property (nonatomic, assign) CGRect     waterLayerRect;

@property (nonatomic, copy) VECompletionHandler   callbackBlock;
@property(nonatomic, copy) void(^completioHandler) (NSString * videoPath, UIViewController *controller);
@property(nonatomic,copy) VECancelHandler cancelHandler;
@property(nonatomic,copy) VEFailedHandler failedHandler;
@property(nonatomic,copy) VECloudBackingUpHandler cloudBackingUpHandler;
@property(nonatomic,copy) VECloudBackupCompletionHandler cloudBackupCompletionHandler;
@property(nonatomic,copy) VEPrepareExportHandler prepareExportHandler;
@property(nonatomic,copy) VEExporTemplate  exporTemplate;   //导出模版

/** 显示相机界面回调
 *  Display camera interface callback.
 *  isTakePhoto: Whether to take photos by default.
 */
@property(nonatomic, copy) void(^showCameraControllerHandler) (UIViewController *superViewController, BOOL isTakePhoto);

/** 显示音乐界面回调
 *  Display music interface callback.
 *  defaultType: 0(cloud) 1(iTunes)  2(local)
 */
@property(nonatomic, copy) void(^showMusicControllerHandler) (UIViewController *superViewController, NSInteger defaultType);

@property (nonatomic, assign) BOOL  isFilmCamera;//是否为方弗相机
@property (nonatomic, copy) void (^filmCameraBlock)(UIViewController *viewController);

@property (nonatomic, weak) id<VESDKDelegate> veSDKDelegate;

@property (nonatomic, assign) BOOL isSingleFunc;

/**  语言设置
 */
@property (nonatomic,assign) SUPPORTLANGUAGE language;

@property (nonatomic, assign) AUDIO_SPEECH_Type audioSpeechType;
@property (nonatomic, strong) NSString *  model;

/** APP的主色调
 *  默认为：0xffd500
 */
@property (nonatomic, strong) UIColor *mainColor;

/** APP中导出按钮的文字颜色
 *  默认为：0x27262c
 */
@property (nonatomic, strong) UIColor *exportButtonTitleColor;

/** APP中导出按钮的背景颜色
 *  默认为：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *exportButtonBackgroundColor;

/** APP中界面的背景色
 *  默认为：[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *viewBackgroundColor;

/** APP中的导航栏背景色
 *  默认为：[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *navigationBackgroundColor;

/** APP中的导航栏文字颜色
 *  默认为：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *navigationBarTitleColor;

/** APP中的导航栏文字字体
 *  默认为：[UIFont boldSystemFontOfSize:20]
 */
@property (nonatomic, strong) UIFont *navigationBarTitleFont;

/** APP中工具栏文字颜色
 *  默认为：[UIFont boldSystemFontOfSize:20]
 */
@property (nonatomic, strong) UIColor *toolsTitleColor;

/** 素材显示控件的背景色
 */
@property (nonatomic, strong) UIColor *timelineItemColor;
/** 素材显示控件的背景色
 */
@property (nonatomic, strong) UIColor *timelineItemTitleColor;

/** 工具栏的分割线颜色
 */
@property (nonatomic, strong) UIColor * toolLineColor;

/** APP中工具栏文字字体
 *  默认为：[UIFont boldSystemFontOfSize:12]
 */
@property (nonatomic, strong) UIFont *toolsTitleFont;
/** APP中自定义Tool图标位置
 */
@property (nonatomic, strong) NSString *customToolImageFolder;
/** APP中自定义导出按钮
 */
@property (nonatomic, strong) NSArray *exportBtnBgColors;

/** 后台返回的“定格”特效分类id
 *  默认为：57685258
 */
@property (nonatomic, assign) int freezeFXCategoryId;
/** 开始导出
 @param minWH 视频分辨率宽高的最小值；例导出720P视频，则设置为720
 */
- (void)startExportWithMinWH:(int)minWH;

@property (nonatomic, assign) BOOL       iPad_HD;
@end
