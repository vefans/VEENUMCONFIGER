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

/**相册选择界面的布局方式
 */
typedef NS_ENUM(NSInteger, ALBUMLAYOUTSTYLE){
    ALBUMLAYOUTSTYLE_ONE,      //布局方式一
    ALBUMLAYOUTSTYLE_TWO,      //布局方式二
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

/**相册返回数据类型
 */
typedef NS_ENUM(NSInteger, SELECTALBUMFILETYPE){
    ALBUMFILETYPE_URL,    //单纯的返回URL
    ALBUMFILETYPE_MediaInfo  //返回带有视频信息数据的一个MediaInfo对象
};

typedef NS_ENUM(NSInteger, BackGroundColorType) {
    BackGroundColorTypeLight,        //亮色
    BackGroundColorTypeDark, //深色
};


typedef NS_ENUM(NSInteger, DefaultErasePenType)
{
    DefaultErasePenType_Manual = 0,  //手动抹除
    DefaultErasePenType_Text = 1,       //文字消除
    DefaultErasePenType_Pedestrian = 2,       //路人消除
};

NS_ASSUME_NONNULL_BEGIN

@interface VEEditConfiguration : NSObject<NSMutableCopying,NSCopying>

@property (nonatomic, assign) int defaultFunction;        //当前功能
/** 字幕样式加入工具栏-音量(default true)
 */
@property(nonatomic, assign)BOOL    enableSubtitleStyleInTool;

/** 配乐-音量(default true)
 */
@property(nonatomic, assign)BOOL    enableSoundVolume;
/** 配乐-淡化(default true)
 */
@property(nonatomic, assign)BOOL    enableSoundFade;
/** 配乐-均衡器(default true)
 */
@property(nonatomic, assign)BOOL    enableSoundEqualizer;
/** 配乐-踩点(default true)
 */
@property(nonatomic, assign)BOOL    enableSoundPlanting;
/** 配乐-分割(default true)
 */
@property(nonatomic, assign)BOOL    enableSoundSplit;
/** 配乐-变声(default true)
 */
@property(nonatomic, assign)BOOL    enableSoundVoice;
/** 配乐-变声(default true)
 */
@property(nonatomic, assign)BOOL    enableSoundSpeed;
/** 配乐-删除(default true)
 */
@property(nonatomic, assign)BOOL    enableSoundDelete;
/** 配乐-复制(default true)
 */
@property(nonatomic, assign)BOOL    enableSoundCopy;


/** 原声(default true)
 */
@property(nonatomic, assign)BOOL    enableSoundorginal;
/** 音频分离(default true)
 */
@property(nonatomic, assign)BOOL    enableSingleAudioSepar;
@property(nonatomic, assign)BOOL    isMultiGridVideo;

/** 分屏排版(default true)
 */
@property(nonatomic, assign)BOOL    isShowSplitScreen;
@property(nonatomic, assign)BOOL    isSplitScreenTypography;
@property(nonatomic, assign)CGSize  SplitScreenSize;
/** 相册选择界面的布局方式
 */
@property(nonatomic, assign)ALBUMLAYOUTSTYLE    albumLayoutStyle;
/** 裁剪页固定裁剪大小
 */
@property(nonatomic, assign)CGSize cropVideoSize;

/** 向导模式 如果需要自己删除一些功能 则需启用此参数  default false
 */
@property (assign, nonatomic)bool enableWizard DEPRECATED_ATTRIBUTE;
/** 编辑视频所支持的文件类型 (default all)
 */
@property (assign, nonatomic)SUPPORTFILETYPE supportFileType;
/** 相册是否禁止显示实况照片 (default false)
 */
@property (assign, nonatomic) BOOL isLivePhotoDisable;

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

/**选择视频最大时长，默认为0s不限制
 */
@property (nonatomic,assign) float maxVideoDuration;

/**启用相册相机 (default true)
 */
@property (nonatomic,assign) bool enableAlbumCamera;
/**点击相册界面相机按钮回调
 */
@property (nonatomic,copy,nullable) void(^clickAlbumCameraBackBlock)(void);

/** 是否禁止编辑(default false)
 */
@property (nonatomic, assign) bool isDisableEdit;
@property (nonatomic, assign) bool isDefaultCrop;
@property (nonatomic, assign) bool isTrimShowClipView;
/** 选取素材进入GIF制作
 */
@property (nonatomic, assign) bool isGIFAlbum;

/** 是否隐藏网络素材(default false)
 */
@property (nonatomic, assign) bool isHiddenNetworkMaterial;

/** 是否显示书单网络素材(default false)
 */
@property (nonatomic, assign) bool isShowBookNetworkMaterial;

/** 返回媒体类型，默认为ALBUMFILETYPE_MediaInfo
 */
@property (nonatomic,assign) SELECTALBUMFILETYPE resultFileType;

/** 相册选中媒体后，是否禁止生成缩略图(default false)
 */
@property (assign, nonatomic)bool thumbDisable;

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
/**单个媒体特效(default true)
  */
@property (nonatomic,assign) bool enableSingleSpecialEffects;
/** 单个媒体调色(default true)
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
/** 智能裁剪 (default true)
 */
@property (nonatomic,assign) bool enableSmartCrop;
/** 基础属性 (default true)
 */
@property (nonatomic,assign) bool enableBasicProperties;
/** 模糊 (default true)
 */
@property (nonatomic,assign) bool enableBlurry;
/** 绑定 (default true)
 */
@property (nonatomic,assign) bool enablePIPBind;
/** 混合模式(default true)
 */
@property (nonatomic,assign) bool enableMixedMode;
/** 动画  (default true)
 */
@property (nonatomic,assign) bool enableAnimation;
/** 特效的作用对象  (default true)
 */
@property (nonatomic,assign) bool enableEffectAccessObject;
/** 替换  (default true)
 */
@property (nonatomic,assign) bool enableReplace;
/** 透明度 (default true)
 */
@property (nonatomic,assign) bool enableTransparency;

/** 文字板 (default false)
 */
@property (nonatomic,assign) bool enableTextTitle;
/** 默认视频输出方式（自动，横屏，1 ：1）
 */
@property (nonatomic,assign) VEPORTIONTYPE  proportionType;
/** 抽帧 (default true)
 */
@property (nonatomic,assign) bool enableExtractFrames;
/** 补帧 (default true)
 */
@property (nonatomic,assign) bool enableMotionflow;
/** 倒放 (default true)
 */
@property (nonatomic,assign) bool enableReverseVideo;
/** 蒙版 (default true)
 */
@property (nonatomic,assign) bool enableMask;
/** 防抖 (default true)
 */
@property (nonatomic,assign) bool enableAntiShake;
/** VR (default true)
 */
@property (nonatomic,assign) bool enableVR;
/** 重置位置大小为(0,0,1,1) (default true)
 *  Reset position size to (0,0,1,1)
 */
@property (nonatomic,assign) bool enableResetRect;
/** 锁定媒体角度大小 (default true)
 */
@property (nonatomic,assign) bool enableLockAngleSize;
/** 可隐藏媒体 (default true)
 */
@property (nonatomic,assign) bool enableHiddenMedia;

#pragma mark- 设置高级编辑界面
/**层级(default true)
  */
@property (nonatomic,assign) bool enableHierarchy;
/** 仅支持片段编辑(default false)
 *  Only supports fragment editing
  */
@property (nonatomic,assign) bool isOnlyFragmentEdit;
/** 草稿 (default false)
 */
@property (nonatomic,assign) bool enableDraft;
/** 云草稿 (default true)
 */
@property (nonatomic,assign) bool enableCloudDraft;
/** 模板草稿 (default true)
 */
@property (nonatomic,assign) bool enableTemplateDraft;
/** 音乐相册草稿 (default false)
 */
@property (nonatomic,assign) bool enableMusicAlbumDraft;

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
/** 网络素材地址
 */
@property (nonatomic,copy)NSString   * _Nonnull netMaterialURL;

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
/** 卡点音乐网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *cardMusicResourceURL;
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
/** 头发网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *changeHairResourceURL;
/** 换装网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *dressUpResourceURL;
/** 字幕网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *subtitleResourceURL;
/** 花字网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *flowerWordResourceURL;
/** 贴纸网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *effectResourceURL;
/** 贴纸网络资源显示的最小版本号，默认为0
 */
@property (nonatomic,assign)int stickerResourceMinVersion;
/** 粒子网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *particleResourceURL;
/** 拍摄粒子网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *shootParticlesResourceURL;
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
/** 模板网络资源分类地址
 */
@property (nonatomic,copy,nullable)NSString    *templateCategoryPath;
/** 模板网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *templatePath;
/** 封面模板网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *coverTemplatePath;
/** 在线相册地址
 */
@property (nonatomic, copy, nullable) NSString *onlineAlbumPath;
/** 涂鸦笔资源地址
 */
@property (nonatomic, copy, nullable) NSString *doodlePenResourcePath;
/** 蒙版资源地址
 */
@property (nonatomic, copy, nullable) NSString *maskResourcePath;
/** 由文字搜索图片/视频地址
 */
@property (nonatomic, copy, nullable) NSString *searchMediaFromTextPath;
/** 解析网络文章文字信息的地址
 */
@property (nonatomic, copy, nullable) NSString *getTextContentFromLinkPath;
/** 骏证功能是否可用的地址
 */
@property (nonatomic, copy, nullable) NSString *functionEnablePath;
/** 放大镜网络资源地址
 */
@property (nonatomic,copy,nullable)NSString    *magnifyingGlassURL;
/** 获取分享的网络地址的音乐信息
 */
@property (nonatomic,copy,nullable)NSString    *getMusicFromLinkPath;
/** 音乐资源配置地址
 */
@property (nonatomic,copy,nullable)NSString    *musicResourcesConfigPath;
/** aiChat 地址
 */
@property (nonatomic,copy,nullable)NSString    *aiChatPath;

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
/** 文字模板(default true)
 */
@property(nonatomic, assign)BOOL    enableSubtitleTemplate;
/** 字幕 (default true)
 */
@property (nonatomic,assign) bool enableSubtitle;

/** 富文本 (default false)
 */
@property (nonatomic,assign) bool enableAttributedString;

/** 字幕转语音 (default false),enableSubtitle为true时，才生效
 */
@property (nonatomic,assign) bool enableSubtitleToSpeech;
/** enableAIRecogSubtitle为true时，才生效
 */
@property (nonatomic,assign) bool enableAIRecogSubtitle;
/** 私有云AI账号配置
 */
@property (nonatomic,strong,nullable) PrivateCloudAIRecogConfig *privateCloudAIRecogConfig;

/** 字幕AI识别 (default true),enableSubtitle为true时，才生效
 *  该功能是以腾讯云为例，须设置tencentAIRecogConfig
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
/** 放大镜 (default true)
 */
@property (nonatomic,assign) bool enableMagnifyingClass;
/** 特效 (default true)
 */
@property (nonatomic,assign) bool enableEffectsVideo;
/** 是否显示定格特效 (default true)
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
/** 单帧导出 (default true)
 */
@property (nonatomic,assign) bool enableSnapshort;
/** 封面 (default true)
 */
@property (nonatomic,assign) bool enableCover;
/** 涂鸦 (default true)
 */
@property (nonatomic,assign) bool enableDoodle;

/** 粒子 (default true)
 */
@property (nonatomic,assign) bool enableOcclusion;

/** 粒子 (default true)
 */
@property (nonatomic,assign) bool enableParticle;

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
/** 涂鸦笔关键帧 (default true)
 */
@property (nonatomic,assign) bool enableDoodlePenKeyframe;

#pragma mark - 剪同款界面设置
/** 是否显示开启循环功能控件 (default true)
 */
@property (nonatomic,assign) bool enableShowRepeatView;

//不截取缩略图
@property (assign, nonatomic)bool isSingletrack;
/** 主题 (default true)
 */
@property (assign, nonatomic)bool enableTemplateTheme;
/** 扣图 (default true)
 */
@property (assign, nonatomic)bool enableCutout;
/** 切画中画 (default true)
 */
@property (assign, nonatomic)bool enableCut_PIP;
/** 降噪 (default true)
 */
@property (assign, nonatomic)bool enableNoise;
/** 边角定位 (default true)
 */
@property (assign, nonatomic)bool enableMorph;
/** 变形 (default true)
 */
@property (assign, nonatomic)bool enableDeformed;
/** 均衡器 (default true)
 */
@property (assign, nonatomic)bool enableEqualizer;

#pragma mark- 拍同款界面设置
@property (nonatomic, assign) BOOL  enableShowReturnBtn;

/**点击相册界面相机按钮回调
 */
@property (nonatomic,copy,nullable) void(^clickAlbumShareBlackBlock)(id obj, bool isSavePhoto, UIViewController *vc);
@property (nonatomic, strong)NSURL   *imagePath;
@property (nonatomic, assign)BOOL      isJPG;


@property (copy,nonatomic)NSString  * sourcesKey;

/**相册选择素材时屏蔽GIF
 */
@property (nonatomic, assign) bool isDisableSelectGif;


/**默认消除方式
 */
@property (nonatomic, assign) DefaultErasePenType defaultErasePenType;

@end

NS_ASSUME_NONNULL_END
