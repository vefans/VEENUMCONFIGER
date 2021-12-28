//
//  VEEditConfiguration.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import <Foundation/Foundation.h>
#import <VEENUMCONFIGER/VEThirdpartyConfig.h>

/**支持编辑的文件类型
 */
typedef NS_ENUM(NSInteger, SUPPORTFILETYPE){
    ONLYSUPPORT_VIDEO,      //仅支持视频
    ONLYSUPPORT_IMAGE,      //仅支持图片
    SUPPORT_ALL,             //支持视频和图片
};

/**视频输出方式
 */
typedef NS_ENUM(NSInteger, VEPORTIONTYPE){
    VEPORTIONTYPE_AUTO       = 0,//自动
    VEPORTIONTYPE_LANDSCAPE  = 1,//横
    VEPORTIONTYPE_SQUARE     = 2//正方形
};

/**默认选中视频还是图片
 */
typedef NS_ENUM(NSInteger, VEDEFAULTSELECTALBUM){
    
    VEDEFAULTSELECTALBUM_VIDEO,
    VEDEFAULTSELECTALBUM_IMAGE
};

/**配音方式
 */
typedef NS_ENUM(NSInteger, VEDUBBINGTYPE){
    VEDUBBINGTYPE_FIRST = 0,
    VEDUBBINGTYPE_SECOND
};

/**截取时间模式
 */
typedef NS_ENUM(NSInteger, TRIMMODE){
    TRIMMODEAUTOTIME,           //自由截取
    TRIMMODESPECIFYTIME_ONE,    //单个时间定长截取
    TRIMMODESPECIFYTIME_TWO     //两个时间定长截取
};

/**定长截取:截取后导出视频分辨率类型
 */
typedef NS_ENUM(NSUInteger, TRIMEXPORTVIDEOTYPE) {
    TRIMEXPORTVIDEOTYPE_ORIGINAL,         //与原始一致
    TRIMEXPORTVIDEOTYPE_FIXEDRATIO,       //特定比例
    TRIMEXPORTVIDEOTYPE_SQUARE,           //正方形
    TRIMEXPORTVIDEOTYPE_MIXED_ORIGINAL,   //可切换，默认为与原始一致
    TRIMEXPORTVIDEOTYPE_MIXED_SQUARE      //可切换，默认为正方形
};

/**截取之后返回的类型
 */
typedef NS_ENUM(NSInteger, VETrimVideoReturnType){
    VETrimVideoReturnTypePath,   //真实截取
    VETrimVideoReturnTypeTime,   //返回时间段
    VETrimVideoReturnTypeAuto    //动态截取
    
};
/**截取界面默认选中最大值还是最小值（定长截取才会设置）
 */
typedef NS_ENUM(NSInteger,VEDefaultSelectCutMinOrMax){
    kVEDefaultSelectCutMin,
    kVEDefaultSelectCutMax,
};

//文件夹类型
typedef NS_ENUM(NSInteger,FolderType){
    kFolderNone,
    kFolderDocuments,
    kFolderLibrary,
    kFolderTemp,
};

//选择相册类型
typedef NS_ENUM(NSInteger, ALBUMTYPE){
    kALBUMALL,
    kONLYALBUMVIDEO,
    kONLYALBUMIMAGE
};
typedef NS_ENUM(NSInteger, BackGroundColorType) {
    BackGroundColorTypeLight,        //亮色
    BackGroundColorTypeDark, //深色
};
NS_ASSUME_NONNULL_BEGIN

@interface VEEditConfiguration : NSObject<NSMutableCopying,NSCopying>
//不截取缩略图
@property (assign, nonatomic)bool thumbDisable;
/** 向导模式 如果需要自己删除一些功能 则需启用此参数  default false
 */
@property (assign, nonatomic)bool enableWizard DEPRECATED_ATTRIBUTE;
/** 编辑视频所支持的文件类型 (default all)
 */
@property (assign, nonatomic)SUPPORTFILETYPE supportFileType;

#pragma mark-相册界面
/** 默认选中视频还是图片
 */
@property (nonatomic,assign) VEDEFAULTSELECTALBUM defaultSelectAlbum;

/**选择视频和图片的最大张数
 */
@property (nonatomic,assign) NSInteger mediaCountLimit;

/**选择视频和图片的最小数
 */
@property (nonatomic,assign) int mediaMinCount;

/**选择视频最小时长，默认为0s不限制
 */
@property (nonatomic,assign) float minVideoDuration;

/**启用相册相机 (default true)
 */
@property (nonatomic,assign) bool enableAlbumCamera;
/**点击相册界面相机按钮回调
 */
@property (nonatomic,copy,nullable) void(^clickAlbumCameraBlackBlock)(void);

/** 是否禁止编辑(default false)
 */
@property (nonatomic, assign) bool isDisableEdit;

#pragma mark- 设置截取界面
/** 截取时间模式
 */
@property (nonatomic,assign) TRIMMODE trimMode;
/** 单个时间定长截取：截取时间 默认15s
 */
@property (nonatomic,assign) float trimDuration_OneSpecifyTime;
/** 两个时间定长截取：偏小截取时间 默认12s
 */
@property (nonatomic,assign) float trimMinDuration_TwoSpecifyTime;
/** 两个时间定长截取：偏大截取时间 默认30s
 */
@property (nonatomic,assign) float trimMaxDuration_TwoSpecifyTime;
/** 两个时间定长截取：默认选中小值还是大值
 */
@property (nonatomic,assign) VEDefaultSelectCutMinOrMax  defaultSelectMinOrMax;

/** 定长截取时，截取后视频分辨率类型 默认TRIMVIDEOTYPE_ORIGINAL
 *  自由截取时，始终为TRIMVIDEOTYPE_ORIGINAL，该设置无效
 */
@property (nonatomic,assign) TRIMEXPORTVIDEOTYPE trimExportVideoType;

#pragma mark- 设置视频编辑界面
/**单个媒体特效
  */
@property (nonatomic,assign) bool enableSingleSpecialEffects;
/** 单个媒体调色
 */
@property (nonatomic,assign) bool enableSingleMediaAdjust;
/** 单个媒体滤镜 (default true)
 */
@property (nonatomic,assign) bool enableSingleMediaFilter;
/** 截取 (default true)
 */
@property (nonatomic,assign) bool enableTrim;
/** 分割 (default true)
 */
@property (nonatomic,assign) bool enableSplit;
/** 裁切 (default true)
 */
@property (nonatomic,assign) bool enableEdit;
/** 变速 (default true)
 */
@property (nonatomic,assign) bool enableSpeedcontrol;
/** 复制 (default true)
 */
@property (nonatomic,assign) bool enableCopy;
/** 调整顺序 (default true)
 */
@property (nonatomic,assign) bool enableSort;
/** 调整视频比例 (default true)
 */
@property (nonatomic,assign) bool enableProportion;

/** 调整图片显示时长 (default true)
 */
@property (nonatomic,assign) bool enableImageDurationControl;
/** 旋转 (default true)
 */
@property (nonatomic,assign) bool enableRotate;
/** 镜像 (default true)
 */
@property (nonatomic,assign) bool enableMirror;
/** 上下翻转 (default true)
 */
@property (nonatomic,assign) bool enableFlipUpAndDown;
/** 转场 (default true)
 */
@property (nonatomic,assign) bool enableTransition;
/** 音量 (default true)
 */
@property (nonatomic,assign) bool enableVolume;
/** 调色 (default true)
 */
@property (nonatomic,assign) bool enableTon;

/** 光圈 (default true)
 */
@property (nonatomic,assign) bool enableAperture;
/** HDR (default true)
 */
@property (nonatomic,assign) bool enableHDR;
/** 圣光 (default true)
 */
@property (nonatomic,assign) bool enableHoly;
/** 暗角 (default true)
 */
@property (nonatomic,assign) bool enableSpirit;
/** 锐化 (default true)
 */
@property (nonatomic,assign) bool enableSharpen;

/** 美颜 (default true)
 */
@property (nonatomic,assign) bool enableBeauty;
/** 涂抹 (default true)
 */
@property (nonatomic,assign) bool enableSmear;
/** 模糊 (default true)
 */
@property (nonatomic,assign) bool enableBlurry;
/** 动画  (default true)
 */
@property (nonatomic,assign) bool enableAnimation;
/** 替换  (default true)
 */
@property (nonatomic,assign) bool enableReplace;
/** 透明度 (default true)
 */
@property (nonatomic,assign) bool enableTransparency;

/** 文字板 (default true)
 */
@property (nonatomic,assign) bool enableTextTitle;
/** 默认视频输出方式（自动，横屏，1 ：1）
 */
@property (nonatomic,assign) VEPORTIONTYPE  proportionType;
/** 倒放 (default true)
 */
@property (nonatomic,assign) bool enableReverseVideo;

#pragma mark- 设置高级编辑界面
/** 草稿 (default false)
 */
@property (nonatomic,assign) bool enableDraft;
/** 不显示草稿按钮 (default false)
 */
@property (nonatomic,assign) bool disableShowDraftButton;
/** 点返回按钮自动保存草稿 (default false)
 *  仅当 enableShowBackTipView 为false时有效
 */
@property (nonatomic,assign) bool enableAutoSaveDraft;
/** 退出编辑界面时，是否显示提示控件(保存草稿/丢弃) (default true)
 */
@property (nonatomic,assign) bool enableShowBackTipView;
/** 网络素材分类地址
 */
@property (nonatomic,copy)NSString   * _Nonnull netMaterialTypeURL;

/** 本地音乐 (default true)
 */
@property (nonatomic,assign) bool enableLocalMusic;
/** MV网络资源地址 (需自己构建网络下载API)
 */
@property (nonatomic,copy,nullable)NSString    *mvResourceURL;
/** 音效分类网络资源地址
 */
@property (nonatomic,copy)NSString    * _Nullable soundMusicTypeResourceURL;
/** 音效分类网络资源地址
 */
@property (nonatomic,copy)NSString    * _Nullable soundMusicResourceURL;
/** MV网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *newmvResourceURL;
/** 音乐网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *newmusicResourceURL;
/** 音乐家
 */
@property (nonatomic,copy,nullable)NSString    *newartist;
/** 音乐家主页标题
 */
@property (nonatomic,copy,nullable)NSString    *newartistHomepageTitle;
/** 音乐家主页Url
 */
@property (nonatomic,copy,nullable)NSString    *newartistHomepageUrl;
/** 音乐授权证书标题
 */
@property (nonatomic,copy,nullable)NSString    *newmusicAuthorizationTitle;
/** 音乐授权证书Url
 */
@property (nonatomic,copy,nullable)NSString    *newmusicAuthorizationUrl;
/** 滤镜网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *filterResourceURL;
/** 字幕网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *subtitleResourceURL;
/** 贴纸网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *effectResourceURL;
/** 贴纸网络资源显示的最小版本号，默认为0
 */
@property (nonatomic,assign)int stickerResourceMinVersion;
/** 特效网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *specialEffectResourceURL;
/** 字体网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *fontResourceURL;
/** 转场网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *transitionURL;
/** 动画网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *animationURL;
/** 背景视频网络资源地址
 */
@property (nonatomic,copy)NSString    *canvasVideosURL;
/** 模板网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *templatePath;

/** MV (default false)
 */
@property (nonatomic,assign) bool enableMV;
/** 配乐 (default true)
 */
@property (nonatomic,assign) bool enableMusic;
/** 变声 (default true)
 */
@property (nonatomic,assign) bool enableSoundEffect;
/** 配音 (default true)
 */
@property (nonatomic,assign) bool enableDubbing;
/** 配音类型 (default 方式一(配音不放在配乐里面))
 */
@property (nonatomic,assign) VEDUBBINGTYPE dubbingType;
/** 字幕 (default true)
 */
@property (nonatomic,assign) bool enableSubtitle;
/** 字幕转语音 (default false),enableSubtitle为true时，才生效
 *  该功能是以阿里云智能语音为例，须设置nuiSDKConfig
 */
@property (nonatomic,assign) bool enableSubtitleToSpeech;
/** 字幕AI识别 (default true),enableSubtitle为true时，才生效
 *  该功能是以腾讯云为例，须设置tencentAIRecogConfig
 */
@property (nonatomic,assign) bool enableAIRecogSubtitle;
/** enableAIRecogSubtitle为true时，才生效
 */
@property (nonatomic,strong,nullable) TencentCloudAIRecogConfig *tencentAIRecogConfig;
/** 百度云AI账号配置
*/
@property (nonatomic,strong,nullable) BaiDuCloudAIConfig *baiDuCloudAIConfig;
/** 阿里云智能语音账号配置
 */
@property (nonatomic,strong,nullable) NuiSDKConfig *nuiSDKConfig;
/** 滤镜 (default true)
 */
@property (nonatomic,assign) bool enableFilter;
/** 贴纸 (default true)
 */
@property (nonatomic,assign) bool enableSticker;
@property (nonatomic,assign) bool enableEffect DEPRECATED_MSG_ATTRIBUTE("Use enableSticker instead.");
/** 特效 (default true)
 */
@property (nonatomic,assign) bool enableEffectsVideo;
/** 是否显示定格特效 (default false)
 *  后台返回的定格特效分类ID接口：freezeFXCategoryId
 */
@property (nonatomic,assign) bool enableFreezeEffects;
/** 加水印 (default true)
 */
@property (nonatomic,assign) bool enableWatermark;
/** 马赛克 (default true)
 */
@property (nonatomic,assign) bool enableMosaic;
/** 去水印 (default true)
 */
@property (nonatomic,assign) bool enableDewatermark;
/** 片段编辑 (default true)
 */
@property (nonatomic,assign) bool enableFragmentedit;

/** 图片动画 (default true)
 */
@property (nonatomic,assign) bool enablePicZoom;
/** 背景 (default true)
 */
@property (nonatomic,assign) bool enableBackgroundEdit;
/** 封面 (default true)
 */
@property (nonatomic,assign) bool enableCover;
/** 涂鸦 (default true)
 */
@property (nonatomic,assign) bool enableDoodle;

/** 进入SDK界面是否需要动画 (default true)
 */
@property (nonatomic,assign) bool presentAnimated;
/** 退出SDK界面是否需要动画 (default true)
 */
@property (nonatomic,assign) bool dissmissAnimated;
/** 画中画 (default true)
 */
@property (nonatomic,assign) bool enableCollage;

/** 音频曲线变速 (default true)
 */
@property (nonatomic,assign) bool enableAuidoCurveSpeed;
/** 媒体曲线变速 (default true)
 */
@property (nonatomic,assign) bool enableMediaCurveSpeed;
/** 字幕，贴纸关键帧 (default true)
 */
@property (nonatomic,assign) bool enableCaptionKeyframe;
/** 字幕，贴纸跟踪 (default true)
 */
@property (nonatomic,assign) bool enableCaptionTrack;
/** 媒体关键帧 (default true)
 */
@property (nonatomic,assign) bool enableMediaKeyframe;
/** 音频关键帧 (default true)
 */
@property (nonatomic,assign) bool enableAudioKeyframe;

#pragma mark - 剪同款界面设置
/** 是否显示开启循环功能控件 (default true)
 */
@property (nonatomic,assign) bool enableShowRepeatView;

@end

NS_ASSUME_NONNULL_END
