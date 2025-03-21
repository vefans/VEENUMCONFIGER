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
#import "AIConfiguration.h"
#import "VEMediaInfo.h"

typedef NS_ENUM(NSInteger, UIBgStyle) {
    UIBgStyleLightContent = 0, // Light content, for use on dark backgrounds
    UIBgStyleDarkContent  =1, // Dark content, for use on light backgrounds
} API_UNAVAILABLE(tvos);

/**支持的语言
 */
typedef NS_ENUM(NSInteger, SUPPORTLANGUAGE){
    CHINESE = 0,    //中文
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

typedef BOOL (^VEVipJoinBlockHandler) (UIViewController * _Nullable viewController,Boolean isChangeBackground,Boolean isCutout,Boolean isErasePen);
typedef BOOL (^VEEnterAdvancedEditHandler) (UIViewController * _Nullable viewController,int type/*1：无水印导出，2：移除界面水印*/);
//导出前回调
typedef void(^VEPrepareExportHandler) (UIViewController * _Nullable viewController);

//编辑完成导出结束回调
typedef void(^VECompletionHandler) (NSString * _Nullable  videoPath);
//编辑取消回调
typedef void(^VECancelHandler) (void);
//编辑取消回调
typedef void(^VEFailedHandler) (NSError * _Nullable  error);
//云备份中回调
typedef void(^VECloudBackingUpHandler) (int completionCount, int totalCount);
//云备份结束回调
typedef void(^VECloudBackupCompletionHandler) (int completionCount);

typedef void(^VEExporTemplate) (UIViewController * _Nullable  view);



UIKIT_EXTERN NSString * const _Nullable  VEStartExportNotification;
UIKIT_EXTERN NSString * const _Nullable  VERemoveDefaultWatermarkNotification;

@protocol VESDKDelegate <NSObject>

@optional

/** 设置faceU普通道具
 */
- (void)faceUItemChanged:(NSString * _Nullable )itemPath;

/** 设置faceU美颜参数
 */
- (void)faceUBeautyParamChanged:(VEFaceUBeautyParams * _Nullable )beautyParams;

/** 销毁faceU全部道具
 */
- (void)destroyFaceU;

/*
 *录制时，摄像头捕获帧回调，可对帧进行处理
 */
- (void)willOutputCameraSampleBuffer:(CMSampleBufferRef _Nullable )sampleBuffer;

/*
 *如果需要自定义相册则需要实现此函数
 */
- (void)selectVideoAndImageResult:(UINavigationController * _Nullable )nav callbackBlock:(void (^ _Nullable )(NSMutableArray * _Nullable lists))callbackBlock;

/*
 *如果需要自定义相册则需要实现此函数（添加视频）
 */
- (void)selectVideosResult:(UINavigationController * _Nullable )nav callbackBlock:(void (^ _Nullable )(NSMutableArray * _Nullable lists))callbackBlock;

/*
 *如果需要自定义相册则需要实现此函数（添加图片）
 */
- (void)selectImagesResult:(UINavigationController * _Nullable )nav callbackBlock:(void (^ _Nullable )(NSMutableArray * _Nullable lists))callbackBlock;

/** 保存草稿
 */
- (void)saveDraftResult:(NSError * _Nullable )error;

/** 显示截取视频界面
 *  Display video capture interface.
 */
- (void)veShowTrimControllerWithSuperView:(UIViewController *)superViewController
                                     file:(VEMediaInfo *)file
                           isRotateEnable:(BOOL)isRotateEnable
                                 trimType:(TRIMMODE)trimType
              trimDuration_OneSpecifyTime:(double)trimDuration_OneSpecifyTime
                        completionHandler:(void (^)(VEMediaInfo *trimFile, CMTimeRange trimTimeRange))completionHandler;

- (void)veShowTrimControllerWithSuperView:(UIViewController *)superViewController
                                     file:(VEMediaInfo *)file
                           isRotateEnable:(BOOL)isRotateEnable
                                 trimType:(TRIMMODE)trimType
              trimDuration_OneSpecifyTime:(double)trimDuration_OneSpecifyTime
                        completionHandler:(void (^)(VEMediaInfo *trimFile, CMTimeRange trimTimeRange))completionHandler
                              cancelBlock:(void(^)(UIViewController *))cancelBlock;
/** 显示裁剪图片界面
 *  Display Cropping Picture Interface.
 */
- (void)veShowCropControllerWithSuperView:(UIViewController *)superViewController
                                     file:(VEMediaInfo *)file
                             isOnlyRotate:(BOOL)isOnlyRotate
                               isOnlyCrop:(BOOL)isOnlyCrop
                                videoSize:(CGSize)videoSize
                        completionHandler:(void (^)(VEMediaInfo *cropedFile))completionHandler;
- (void)veShowCropControllerWithSuperView:(UIViewController *)superViewController
                                     file:(VEMediaInfo *)file
                             isOnlyRotate:(BOOL)isOnlyRotate
                               isOnlyCrop:(BOOL)isOnlyCrop
                       isSelectBackground:(BOOL)isSelectBackground
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
/** 显示音乐界面回调
 *  @param  defaultType     0: Cloud     1: iTunes      2: Local
 *  Display music interface callback.
 */
- (void)veEnterMusicControllerWithSuperView:(UIViewController *)superViewController
                                defaultType:(NSInteger)defaultType
                          completionHandler:(void (^)(MusicInfo *music))completionHandler
                              cancelHandler:(VECancelHandler)cancelHandler;

- (void)veEnterSoundEffectsView:(CGRect)frame
                      superView:(UIView *)superView
            superViewController:( UIViewController * ) superViewController
              categoryResources:(NSMutableDictionary *)categoryResources
              completionHandler:( void(^)(MusicInfo *music) ) completionHandler
                  cancelHandler:( void(^)(void) ) cancelHandler;

- (UIViewController *)veEnterCloudMusicViewController:(CGRect)frame
                                    completionHandler:( void(^)(MusicInfo *music) ) completionHandler
                                        cancelHandler:( void(^)(void) ) cancelHandler;

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
//vip
@property (nonatomic,assign) bool          isEnableVIP;
@property(nonatomic,copy, nullable) void (^exportVip)(id currentViewController);
@property(nonatomic,copy, nullable) void (^onContinueExport)(bool  isWatermark);
@property(nonatomic,copy, nullable) void ( ^close_SaveDraft )(void);

@property(nonatomic, assign) float  subtiteJsonFontSize;

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
/**  TmeplateRecoder 模版相册 是否打开
 */
@property (nonatomic, assign) BOOL isShowTmeplateRecoder;

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

@property (nonatomic,strong) AIConfiguration *aiConfiguration;

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

@property (nonatomic, assign) BOOL isNoHtmlAutoSegmentImage;

/** 默认为：true
 */
@property (nonatomic, assign) BOOL hasInit;

/** 视频抠像功能的appKey
 */
@property (copy,nonatomic)NSString *videoMattingAppKey;

@property (nonatomic, assign) BOOL       statusBarHidden;
@property (nonatomic, assign) float      videoAverageBitRate;
@property (nonatomic, assign) CGRect     waterLayerRect;

@property (nonatomic, assign) BOOL       isSelectFaces;

@property (nonatomic, assign) BOOL  isOutputAudioPath;
@property (nonatomic, copy) VECompletionHandler   _Nullable  callbackBlock;
@property (nonatomic, copy) void(^ _Nullable newCallImagebackBlock)(NSString * _Nullable path,UIViewController * _Nullable vc);
@property (nonatomic, copy) VECompletionHandler  _Nullable   editLiteVideoCompletionHandler;
@property(nonatomic, copy) void(^ _Nullable completioHandler) (NSString *  _Nullable videoPath, UIViewController * _Nullable controller);
@property(nonatomic,copy) VECancelHandler  _Nullable  cancelHandler;
@property(nonatomic,copy) VEFailedHandler  _Nullable  failedHandler;
@property(nonatomic,copy) VECloudBackingUpHandler  _Nullable  cloudBackingUpHandler;
@property(nonatomic,copy) VECloudBackupCompletionHandler  _Nullable  cloudBackupCompletionHandler;
@property(nonatomic, copy) void(^ _Nullable cloudDraftIDHandler) ( BOOL success,  NSString * _Nullable  cloudDraftID );
@property(nonatomic, copy) void(^ _Nullable cloudDraftProgressHandler) (float  progress );
@property(nonatomic,copy) VEPrepareExportHandler _Nullable  prepareExportHandler;
@property(nonatomic,copy) VEEnterAdvancedEditHandler  _Nullable canEnterAdvancedEditHandler;
@property(nonatomic,copy) VEVipJoinBlockHandler  _Nullable  canVipJoinBlockHandler;
@property(nonatomic,copy) VEExporTemplate  _Nullable  exporTemplate;   //导出模版
@property (nonatomic, copy) VECompletionHandler _Nullable  downloadedVideoCompletionHandler;

@property(nonatomic, copy) void(^ _Nullable enterMusicAlbumTempCompletionHandler) (NSString * _Nullable categoryId,NSDictionary * _Nullable  itemDic,NSInteger selectTypeIndex,NSInteger index, UIViewController * _Nullable controller);

//草稿增删 刷新
@property (nonatomic, copy) void (^ _Nullable refreshDraftView)(void);

/** 显示相机界面回调
 *  Display camera interface callback.
 *  isTakePhoto: Whether to take photos by default.
 */
@property(nonatomic, copy) void(^ _Nullable showCameraControllerHandler) (UIViewController * _Nullable superViewController, BOOL isTakePhoto);

/** 显示音乐界面回调
 *  Display music interface callback.
 *  defaultType: 0(cloud) 1(iTunes)  2(local)
 */
@property(nonatomic, copy) void(^ _Nullable showMusicControllerHandler) (UIViewController * _Nullable superViewController, NSInteger defaultType);

@property (nonatomic, assign) BOOL  isFilmCamera;//是否为方弗相机
@property (nonatomic, copy) void (^ _Nullable filmCameraBlock)(UIViewController * _Nullable viewController);

@property (nonatomic, weak) id<VESDKDelegate> veSDKDelegate;

@property (nonatomic, assign) BOOL isSingleFunc;

/**  语言设置
 */
@property (nonatomic,assign) SUPPORTLANGUAGE language;
@property (nonatomic, assign) BOOL isLanguage;

@property (nonatomic, assign) AUDIO_SPEECH_Type audioSpeechType;
@property (nonatomic, strong) NSString *  _Nullable  model;

/** APP的主色调
 *  默认为：0xffd500
 */
@property (nonatomic, strong) UIColor * _Nullable mainColor;

/** APP中导出按钮的文字颜色
 *  默认为：0x27262c
 */
@property (nonatomic, strong) UIColor * _Nullable exportButtonTitleColor;

/** APP中导出按钮的背景颜色
 *  默认为：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor * _Nullable exportButtonBackgroundColor;

/** APP中界面的背景色
 *  默认为：[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor * _Nullable viewBackgroundColor;

/** APP中的导航栏背景色
 *  默认为：[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor * _Nullable navigationBackgroundColor;

/** APP中的导航栏文字颜色
 *  默认为：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor * _Nullable navigationBarTitleColor;

/** APP中的导航栏文字字体
 *  默认为：[UIFont boldSystemFontOfSize:20]
 */
@property (nonatomic, strong) UIFont * _Nullable navigationBarTitleFont;

/** APP中工具栏文字颜色
 *  默认为：[UIFont boldSystemFontOfSize:20]
 */
@property (nonatomic, strong) UIColor * _Nullable toolsTitleColor;

/** 素材显示控件的背景色
 */
@property (nonatomic, strong) UIColor * _Nullable timelineItemColor;
/** 素材显示控件的背景色
 */
@property (nonatomic, strong) UIColor * _Nullable timelineItemTitleColor;

/** 工具栏的分割线颜色
 */
@property (nonatomic, strong) UIColor *  _Nullable toolLineColor;

/** APP中工具栏文字字体
 *  默认为：[UIFont boldSystemFontOfSize:12]
 */
@property (nonatomic, strong) UIFont * _Nullable toolsTitleFont;
/** APP中自定义Tool图标位置
 */
@property (nonatomic, strong) NSString * _Nullable customToolImageFolder;
/** APP中自定义导出按钮
 */
@property (nonatomic, strong) NSArray * _Nullable exportBtnBgColors;

/** 后台返回的“定格”特效分类id
 *  默认为：57685258
 */
@property (nonatomic, assign) int freezeFXCategoryId;
/** 开始导出
 @param minWH 视频分辨率宽高的最小值；例导出720P视频，则设置为720
 */
- (void)startExportWithMinWH:(int)minWH;
/** 移除默认水印
 */
- (void)removeDefaultWatermark;
@property (nonatomic, assign) BOOL       iPad_HD;
@property (nonatomic, assign) BOOL       enableBtnLikeTemp;
@property (nonatomic, copy) void (^ _Nullable likeNoLoginBlock)(UIViewController * _Nullable viewController);


@property (nonatomic, strong) NSArray * _Nullable selectedTypeColors;
@property (nonatomic, strong) NSArray * _Nullable selectedLineColors;
@property (nonatomic, strong) UIColor * _Nullable textColorOnGradientView; //渐变背景色上面的文字颜色
/** 音乐界面布局样式 (default 0)
 */
@property (nonatomic, assign) int musicViewLayoutStyle;
@property (nonatomic, strong) id  _Nullable exportDraft;

-(void)htmlSegmentation:( UIViewController *  _Nullable ) viewController;

@property(nonatomic,copy) void (^ _Nullable cancelBtnBlock)(UIButton *  _Nullable btn);

@end
