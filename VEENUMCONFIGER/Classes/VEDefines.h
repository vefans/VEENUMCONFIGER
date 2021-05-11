
#import <UIKit/UIKit.h>
#import <VEENUMCONFIGER/VEMusicInfo.h>
#import "VEConfigManager.h"

typedef NS_ENUM(NSInteger ,MediaType) {
    kFILEVIDEO,
    kFILEIMAGE,
    kFILETEXT
};

typedef NS_ENUM(NSInteger,CanvasType){
    KCanvasType_None                = 0, //无
    KCanvasType_Color               = 1, //场景背景颜色
    KCanvasType_Style               = 2, //场景图片样式
    KCanvasType_Blurry              = 3, //场景模糊
};

typedef NS_ENUM(NSInteger,ContentAlignment) {
    kContentAlignmentCenter,
    kContentAlignmentLeft,
    kContentAlignmentRight
};

//选择本地还是音乐库类型
typedef NS_ENUM(NSInteger, VESELECTMUSICTYPE){
    kVEMUSICLIBRARY,
    kVEMUSICOLLECTION,
    kVELOCALMUSIC
};

typedef NS_ENUM(NSInteger,FileCropModeType)
{
    kCropTypeNone       = 0,
    kCropTypeOriginal,      /**< 原始 */
    kCropTypeFreedom,       /**< 自由 */
    kCropType1v1,           /**< 1v1 */
    kCropType16v9,
    kCropType9v16,
    kCropType4v3,
    kCropType3v4,
    kCropTypeFixed,         /**< 固定裁切范围 */
    kCropTypeFixedRatio,    /**< 固定比例裁切*/
};

typedef NS_ENUM(NSInteger, VECropType){
    VE_VECROPTYPE_FREE = 0,      //自由
    VE_VECROPTYPE_ORIGINAL = 1,  //原比例
    VE_VECROPTYPE_9TO16 = 2,      //9:16
    VE_VECROPTYPE_16TO9 = 3,      //16:9
    VE_VECROPTYPE_1TO1 = 4,      //1:1
    VE_VECROPTYPE_6TO7 = 5,      //6:7
    VE_VECROPTYPE_4TO5 = 6,      //4:5
    VE_VECROPTYPE_4TO3 = 7,      //4:3
    VE_VECROPTYPE_3TO4 = 8,      //3:4
    VE_VECROPTYPE_FIXEDRATIO = 9,    /**< 固定比例裁切*/
};

typedef NS_ENUM(NSInteger,TimeFilterType)
{
    kTimeFilterTyp_None             = 0, //无
    kTimeFilterTyp_Slow             = 1, //慢动作
    kTimeFilterTyp_Repeat           = 2, //反复
    kTimeFilterTyp_Reverse          = 3, //倒序
};

/**方向
 */
typedef NS_ENUM(NSInteger, DeviceOrientation){
    DeviceOrientationUnknown,
    DeviceOrientationPortrait,
    DeviceOrientationLandscape
};

typedef NS_ENUM(NSInteger, VEAdvanceEditType){
    VEAdvanceEditType_None          =  0,   //无
    VEAdvanceEditType_MV            =  1,   //MV
    VEAdvanceEditType_Music         =  2,   //配乐
    VEAdvanceEditType_Dubbing       =  3,   //配音
    VEAdvanceEditType_Subtitle      =  4,   //字幕
    VEAdvanceEditType_Filter        =  5,   //滤镜
    VEAdvanceEditType_Sticker       =  6,   //贴纸
    VEAdvanceEditType_Effect        =  7,   //特效
    VEAdvanceEditType_SoundEffect   =  8,   //变声
    VEAdvanceEditType_Dewatermark   =  9,   //去水印
    VEAdvanceEditType_Proportion    =  10,  //比例
    VEAdvanceEditType_PicZoom       =  11,  //图片动画
    VEAdvanceEditType_BG            =  12,  //背景
    VEAdvanceEditType_Sort          =  13,  //排序
    VEAdvanceEditType_Collage       =  14,  //画中画
    VEAdvanceEditType_Doodle        =  15,  //涂鸦
    VEAdvanceEditType_Cover         =  16,  //封面
    VEAdvanceEditType_Sound         =  17,  //音效
    VEAdvanceEditType_Multi_track   =  18,  //多段配乐
    VEAdvanceEditType_Volume        =  19,  //音量
    VEAdvanceEditType_FragmentEdit  =  20,  //片段编辑
    VEAdvanceEditType_SoundSettings =  21,  //声音
    VEAdvanceEditType_Setting       =  22,  //设置
    VEAdvanceEditType_Watermark     =  23,  //加水印
    VEAdvanceEditType_Mosaic        =  24,  //马赛克
    VEAdvanceEditType_Local_track   =  25,  //本地配乐
    VEAdvanceEditType_EndFile       =  26,  //片尾
    VEAdvanceEditType_EDIT          =  27,  //编辑
    
    VEAdvanceEditType_WatermarkEdit     =  28,  //水印
    VEAdvanceEditType_Localmusic        =  29,  //本地音乐
    VEAdvanceEditType_SoundOriginal     =  30,  //原声
    VEAdvanceEditType_VideoSound        =  31,  //提取视频声音
    
    VEAdvanceEditType_Ton               =  32,  //调色
    VEAdvanceEditType_Canvas            =  33,  //画布
    VEAdvanceEditType_Split            =  34,  //分割
    VEAdvanceEditType_SubtitleToAudio = 35,   //文字转语音
};

/*
 *定制功能
 */
typedef NS_ENUM(NSInteger, VECustomizationFunctionType){
    kVESORT             =0, //排序
    kVETRIM             =1, //截取
    kVESPLIT            =2, //分割
    kVEEDIT             =3, //编辑
    kVECHANGESPEED      =4, //视频变速/图片时长
    kVECOPY             =5, //复制
    kVETEXTTITLE        =6, //文字板
    kVEREVERSEVIDEO     =7, //倒序
    kVECHANGEDURATION   =8,  //调整图片显示时长
    kVESINGLEFILTER     =10, //滤镜
    kVEADJUST           =11, //调色
    kVEEFFECTS          =12, //特效
    KTRANSITION         =13, //转场
    KROTATE             =14, //旋转
    KFLIPUPANDDOWN      =15, //上下镜像
    KMIRROR             =16, //左右镜像
    KVOLUME             =17, //音量
    KREPLACE            =18, //替换
    KTRANSPARENCY       =19, //透明度
    kVEANIMATION        =20, //动画
    KBEAUTY             =21, //美颜
    kVEMUSICAE          =22, //音乐相册(AE)
    kTEMPLATERECORD     =23, //模板拍摄(AE)
    KDELETE             =24, //删除
    KVOICEFX            =25, //变声
    
    kCROP               =26,  //裁剪
    KVERATING           =27, //定格
    KMUTEVOLUME         = 28,//静音
    KSOUNDORGINAL       = 29,//原声
    KMASK               = 30,//蒙版
    KENTRANCEANIMATION  = 31,//入场动画
    KAPPEARANCEANIMATION= 32,//出场动画
    KCOMBINEDANIMATION  = 33,//组合动画
    KRECT               = 34,//移动参数保存
    KADD                = 35,//添加
    KEYFRAME            = 36,//关键帧
    KSTICKERANIMATION   = 37,//贴纸动画
    KSUBTITLEANIMATION  = 38,//字幕动画
    KCUTOUT             = 39,//抠图
    KBGSTYLE            = 40,//画布样式
    KCUT_PIP            = 41,//切画中画
    KINTELLIGENT_KEY    = 42,//智能抠像
    KNOISE              = 43,//降噪
};

typedef NS_ENUM(NSInteger, VESDKErrorCode) {
    VESDKErrorCode_NillOutputPath     = 1000, //无视频输出地址
    VESDKErrorCode_NillInput          = 1001, //无视频源
    VESDKErrorCode_NillDraft          = 1002, //无草稿
    VESDKErrorCode_DownloadSubtitle   = 1003, //下载字幕失败
    VESDKErrorCode_SaveDraft          = 1004, //保存草稿失败
    VESDKErrorCode_TrimVideo          = 1005, //截取视频失败
    VESDKErrorCode_FilePath           = 1006, //文件路径错误
    VESDKErrorCode_NotReachable       = 1007, //无可用的网络
};

typedef NS_ENUM(NSInteger, CaptionAnimateType) {
    CaptionAnimateTypeNone          = 0,  //无
    CaptionAnimateTypeLeft ,              //左推
    CaptionAnimateTypeRight,              //右推
    CaptionAnimateTypeUp,                 //上推
    CaptionAnimateTypeDown,               //下推
    CaptionAnimateTypeScaleInOut,         //缩放入出
    CaptionAnimateTypeScrollInOut,        //滚动入出
    CaptionAnimateTypeFadeInOut,          //淡入淡出
};

/*
 *画中画编辑功能
 */
typedef NS_ENUM(NSInteger, VEPIPFunctionType){
    kPIP_SINGLEFILTER  =0, //滤镜
    kPIP_ADJUST        =1, //调色
    kPIP_MIXEDMODE     =2, //混合模式
    kPIP_CUTOUT        =3, //抠图
    kPIP_VOLUME        =4, //音量
    kPIP_BEAUTY        =5, //美颜
    kPIP_TRANSPARENCY  = 6, //透明度
    kPIP_ROTATE        = 7, //旋转
    kPIP_MIRROR        = 8, //左右镜像
    kPIP_FLIPUPANDDOWN = 9, //上下镜像
    KPIP_REPLACE       = 10,//替换
    KPIP_TRIM          = 11,//截取
    KPIP_CHANGESPEED   = 12,//变速
    
    KPIP_DELETE        = 13,//删除
    KPIP_EDIT          = 14,//裁剪
    
    kPIP_VEEDIT        =15, //编辑
    KPIP_SPLIT         =16, //分割
    KPIP_COPY          =17, //复制
    KPIP_RATING        =18, //定格
    KPIP_MASK          =19, //蒙版
    KPIP_ANIMATION     =20, //动画
    KPIP_HIERARCHY     =21, //层级
    KPIP_SOUNDEFFECT   =22, //变声
    kPIP_ENTRANCEANIMATION  = 31,//入场动画
    kPIP_APPEARANCEANIMATION= 32,//出场动画
    kPIP_COMBINEDANIMATION  = 33,//组合动画
    kPIP_ADD                = 34,//添加
    KPIP_RECT               = 35,//调整位置大小
    KPIP_STARTTIME          = 36,//调整在主轴的起始时间
    KPIP_KEYFRAME           = 37,//关键帧
    kPIP_CUTSPINDLE         = 38,//切主轴
    kPIP_INTELLIGENT_KEY    = 39,//智能抠像
    kPIP_SHIFTING_SPEED     = 40,//曲线变速
    KPIP_NOISE              = 41,//降噪
};

//去水印类型
typedef NS_ENUM(NSInteger, VEDewatermarkType){
    VEDewatermarkType_Blur          = 1,    //高斯模糊
    VEDewatermarkType_Mosaic        = 2,    //马赛克
    VEDewatermarkType_Dewatermark   = 3,    //去水印
};

//去水印类型
typedef NS_ENUM(NSInteger, VEVideoCropType){
    VEVideoCropType_Crop          = 1,    //裁剪
    VEVideoCropType_Dewatermark        = 2,    //去水印
};

typedef NS_ENUM(NSInteger, VESubtitleContentType) {
    VESubtitleContentType_text = 0,
    VESubtitleContentType_stroke,
    VESubtitleContentType_shadow,
    VESubtitleContentType_bg,
    VESubtitleContentType_alpha,
    VESubtitleContentType_innerStroke
};

/**调色
*/
typedef NS_ENUM(NSInteger,AdjustType){
    Adjust_Brightness,      //亮度
    Adjust_Contrast,        //对比度
    Adjust_Saturation,      //饱和度
    Adjust_Sharpness,       //锐度
    Adjust_WhiteBalance,    //色温
    Adjust_Vignette,        //暗角
};

/**相册返回数据类型
 */
typedef NS_ENUM(NSInteger, SELECTALBUMFILETYPE){
    ALBUMFILETYPE_URL,    //单纯的返回URL
    ALBUMFILETYPE_MediaInfo  //返回带有视频信息数据的一个MediaInfo对象
};

//字幕对齐方式
typedef NS_ENUM(NSInteger, UICaptionTextAlignment) {
    UICaptionTextAlignmentLeft = 0,
    UICaptionTextAlignmentCenter,
    UICaptionTextAlignmentRight
};

typedef void(^VERecordCompletionHandler) (int result,NSString *path,VEMusicInfo *music);

/**相册选择完成返回一个URL数组
 */
typedef void(^VEAlbumCompletionHandler) (NSMutableArray <NSURL*> * urls);

//调用拍同款
typedef void(^RecordCallbackBlock) ( int index );

//拍摄 录像使用
typedef void(^PhotoPathCancelBlock) (NSString *path);
typedef void(^ChangeFaceCancelBlock) (int type, float value);
typedef void(^AddFinishCancelBlock) (NSString *videoPath, int type);
//视频截取
typedef void(^TrimAndRotateVideoFinishBlock)(float rotate,CMTimeRange timeRange);
//图片裁剪
typedef void(^EditVideoForOnceFinishAction)(CGRect crop,CGRect cropRect,BOOL verticalMirror,BOOL horizontalMirror,float rotation, int cropmodeType);

#define TIMESCALE 600
#define kRECORDAAC //直接录制AAC，如果录制MP3则注释掉这一行
#define KPICDURATION 3  //图片显示时长
#define VIDEOMINDURATION 0.1 //视频最短时长，用于分割、截取

//判断是否为iPad
#define iPad ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define kThumbnailFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnailFolder"]

#define WeakSelf(obj) __weak typeof(obj) weakSelf = obj;
#define StrongSelf(obj) __strong typeof(obj) strongSelf = weakSelf;

#define iPhone4s ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.width == 480)
#define LASTIPHONE_5 [UIScreen mainScreen].bounds.size.height > 480
#define LastIphone5 [UIScreen mainScreen].bounds.size.width > 320
#define VE_isIPhone_iPhone12 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone12 Pro Max
#define VE_isIPhone_iPhone12_ProMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) : NO)

//#define iPhone_X (  (([[UIScreen mainScreen] bounds].size.height == 812.0 && [[UIScreen mainScreen] bounds].size.width == 375.0) || ([[UIScreen mainScreen] bounds].size.height == 375.0 && [[UIScreen mainScreen] bounds].size.width == 812.0))   ||   (([[UIScreen mainScreen] bounds].size.height == 896.0 && [[UIScreen mainScreen] bounds].size.width == 414.0) || ([[UIScreen mainScreen] bounds].size.height == 414.0 && [[UIScreen mainScreen] bounds].size.width == 896.0)) ||VE_isIPhone_iPhone12|| VE_isIPhone_iPhone12_ProMax)

#define iPhone_X (MAX([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) >= 780 && (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad))
#define Color(r,g,b,a)   [UIColor colorWithRed:(r/(float)255) green:(g/(float)255) blue:(b/(float)255) alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define VE_EXPORTBTN_TITLE_COLOR [VEConfigManager sharedManager].exportButtonTitleColor
#define Main_Color [VEConfigManager sharedManager].mainColor
#define kFreezeFrameFxId [VEConfigManager sharedManager].freezeFXCategoryId
#define VE_NAV_TITLE_COLOR [VEConfigManager sharedManager].navigationBarTitleColor
#define NAVIBGCOLOR [VEConfigManager sharedManager].navigationBackgroundColor
#define NAVIBARTITLEFONT [VEConfigManager sharedManager].navigationBarTitleFont

#define VIEW_COLOR UIColorFromRGB(0x1a1a1a)

#define NV_Color 0x27262c
#define SCREEN_BACKGROUND_COLOR [VEConfigManager sharedManager].viewBackgroundColor
#define TOOLBAR_COLOR UIColorFromRGB(0x101010)
#define CUSTOM_GRAYCOLOR UIColorFromRGB(0xb2b2b2)
#define TEXT_COLOR UIColorFromRGB(0xb3b3b3)
#define BOTTOM_COLOR [UIColor blackColor]//UIColorFromRGB(0x33333b)
#define ADDEDMATERIALCOLOR UIColorFromRGB(0x8cb27b) //字幕等遮罩的颜色//58bb9d
#define MATERIALMASKCOLOR ADDEDMATERIALCOLOR//[ADDEDMATERIALCOLOR colorWithAlphaComponent:0.9]

#define ipadToolBarHeight (iPad?20:0)

//视频导出帧率
#define kEXPORTFPS 24
//视频导出分辨率
#define kVIDEOHEIGHT ([VEHelp isLowDevice] ? 480 : 720)
#define kVIDEOWIDTH ([VEHelp isLowDevice] ? 852 : 1280)
#define kSQUAREVIDEOWIDTH 720
//设备屏幕宽高
#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height
#define kNavigationBarHeight (iPhone_X ? 88 : 44)
#define kToolbarHeight (iPhone_X ? 78 : 44 + ipadToolBarHeight )
#define kPlayerViewHeight (iPad ? (kHEIGHT - 223) : (kHEIGHT - (iPhone_X ? (44 + 34) : (0  + ipadToolBarHeight)) - ( 0.523 * kWIDTH ) - (iPad?0:20)))
//#define kToolbarHeight (iPhone_X ? 78 : 44)
//#define kPlayerViewHeight (kHEIGHT - (iPhone_X ? 44 + 34 : 0) - ( 0.523 * kWIDTH ) - 20)
#define kPlayerViewOriginX (iPhone_X ? 44 : 0)
#define kIs_iPhoneX kWIDTH >=375.0f && kHEIGHT >=812.0f&& kIs_iphone
#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/*状态栏高度+ NavgationBar高度*/
#define kNavgationBar_Height   (kIs_iPhoneX ? 88:64)

/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))

/*底部安全区域远离高度*/
#define kBottomSafeHeight (CGFloat)(kIs_iPhoneX?(34.0):(0))




#define getEffectTypeUrl @"http://kx.56show.com/kuaixiu/openapi/video/getcaption3"
#define getCaptionTypeNoIdUrl @"http://kx.56show.com/kuaixiu/openapi/video/getzimu4"
#define getFontTypeUrl @"http://kx.56show.com/kuaixiu/openapi/video/getfont3"

#define kBundName @"VEEditSDK"
#define kVELanguage @"VELanguage"

#define ClassBundle [NSBundle bundleForClass:self.class]
#define VEEditResourceBundle [VEHelp getEditBundle]
#define VEEditBundlePath VEEditResourceBundle.bundlePath
#define VERecordResourceBundle [VEHelp getRecordBundle]
#define VEDemoUseBundle [VEHelp getDemoUseBundle]
#define isEnglish [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] hasPrefix:@"en"] || [[[NSUserDefaults standardUserDefaults] objectForKey:kVELanguage] isEqualToString:@"en"]
#define LanguageBundle [NSBundle bundleWithPath:[ClassBundle pathForResource:[NSString stringWithFormat:@"VEEditSDK.bundle/%@", isEnglish ? @"en" : @"zh-Hans"] ofType:@"lproj"]]
//#define VELocalizedString(key,des) [LanguageBundle localizedStringForKey:(key) value:des table:@"VEEditSDK_Localizable"]
#define VELocalizedString(key,des) [VEHelp getLocalizedString:key]

#define kLocalTransitionFolder [VEEditBundlePath stringByAppendingPathComponent:@"transitions"]

#define kVEDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define LibtaryAblumPath [NSTemporaryDirectory() stringByAppendingString:@"LibtaryAblum"]

#define kMusicFolder_old [NSTemporaryDirectory() stringByAppendingString:@"music/"]
#define kMusicIconPath_old [NSTemporaryDirectory() stringByAppendingString:@"music/musicIcon/"]
#define kMusicPath_old [NSTemporaryDirectory() stringByAppendingString:@"music/musics/"]

#define kThemeMVPath_old [NSTemporaryDirectory() stringByAppendingString:@"MV/"]
#define kThemeMVIconPath_old [NSTemporaryDirectory() stringByAppendingString:@"MV/MVIcon/"]
#define kThemeMVEffectPath_old [NSTemporaryDirectory() stringByAppendingString:@"MV/MVEffects/"]

#define kComminuteFolder [kVEDirectory stringByAppendingPathComponent:@"Comminute"]

#define kMusicFolder [kVEDirectory stringByAppendingPathComponent:@"music"]
#define kMusicIconPath [kMusicFolder stringByAppendingPathComponent:@"musicIcon"]
#define kMusicPath [kMusicFolder stringByAppendingPathComponent:@"musics"]

#define kThemeMVPath [kVEDirectory stringByAppendingPathComponent:@"MV"]
#define kThemeMVIconPath [kThemeMVPath stringByAppendingPathComponent:@"MVIcon"]
#define kThemeMVEffectPath [kThemeMVPath stringByAppendingPathComponent:@"MVEffects"]

#define kMVAnimateFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MVAnimate/"]
#define kMVAnimatePlistPath [kMVAnimateFolder stringByAppendingPathComponent:@"animationlist_videoae.plist"]
#define kMusicAnimatePlistPath [kMVAnimateFolder stringByAppendingPathComponent:@"musicAnimation.plist"]
#define kTextAnimateFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TextAnimate/"]
#define kTempTextAnimateFolder [NSTemporaryDirectory() stringByAppendingPathComponent:@"TextAnimate/"]

#define kSpecialEffectFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SpecialEffect"]
#define kNewSpecialEffectPlistPath [kSpecialEffectFolder stringByAppendingPathComponent:@"SpecialEffectList_New.plist"]

#define kTransitionFolder [kVEDirectory stringByAppendingPathComponent:@"transitionFiles"]
#define kTransitionPlistPath [kTransitionFolder stringByAppendingPathComponent:@"TransitionList.plist"]

#define kLocalTransitionPlist [kLocalTransitionFolder stringByAppendingPathComponent:@"Transition.plist"]
#define kDefaultTransitionTypeName @"基础"

#define kWatermarkFolder [NSTemporaryDirectory() stringByAppendingString:@"watermark/"]

#define kCoverFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cover"]
#define kCanvasFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Canvas"]

#define kDoodleFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/doodle"]
#define kTextboardFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/textboard"]
#define kCurrentFrameTextureFolder  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/currentFrameTexture"]

#define kAEJsonMVEffectPath [NSTemporaryDirectory() stringByAppendingString:@"AEJsonAnimation/"]
#define kAEPreProgressFolder [kAEJsonMVEffectPath stringByAppendingPathComponent:@"AEPreProgress"]
#define kAEJsonSubtitsPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SubtitleAnimations/Effects"]

#define kVEDraftDirectory [kVEDirectory stringByAppendingPathComponent:@"VEDraft"]
#define kVEDraftListPath [kVEDraftDirectory stringByAppendingPathComponent:@"veDraft.plist"]
#define kVEDraftUndonePath [kVEDraftDirectory stringByAppendingPathComponent:@"veDraftUndone.plist"]

#define kSubtitleEffectFolder [kVEDirectory stringByAppendingPathComponent:@"SubtitleEffect"]
#define kSubtitleFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"Subtitle"]
#define kSubtitleIconPath [kSubtitleFolder stringByAppendingPathComponent:@"icon"]
#define kSubtitlePlistPath [kSubtitleFolder stringByAppendingPathComponent:@"SubtitleListType.plist"]
#define kSubtitleIconPlistPath [kSubtitleFolder stringByAppendingPathComponent:@"SubtitleIconList.plist"]
#define kSubtitleCategoryPlistPath [kSubtitleFolder stringByAppendingPathComponent:@"SubtitleCategoryListType.plist"]

#define kFontFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"Font"]
#define kFontIconPath [kFontFolder stringByAppendingPathComponent:@"icon"]
#define kFontPlistPath [kFontFolder stringByAppendingPathComponent:@"fontList2020.plist"]
#define kFontIconPlistPath [kFontFolder stringByAppendingPathComponent:@"fontIconList2020.plist"]
#define kFontCheckPlistPath [kFontFolder stringByAppendingPathComponent:@"fontCheckList2020.plist"]
#define kFontType @"font_family_2"

#define kStickerFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"Effect"]
#define kStickerIconPath [kStickerFolder stringByAppendingPathComponent:@"icon"]
#define kStickerPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectList.plist"]

#define kStickerIconPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectIconList.plist"]

#define kStickerTypesPath [kStickerFolder stringByAppendingPathComponent:@"EffectTypesList.plist"]
#define kNewStickerPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectPlistList.plist"]
#define kNewStickerCategoryPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectCategoryPlistList.plist"]

#define kFilterFolder [kVEDirectory stringByAppendingPathComponent:@"filters"]
#define kFilterCategoryPlist [kFilterFolder stringByAppendingPathComponent:@"filterCategory.plist"]

#define kTemplateRecordFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TemplateRecord"]
#define kTemplateRecordPlist [kTemplateRecordFolder stringByAppendingPathComponent:@"TemplateRecord.plist"]

#define kStickerMinScale   0.1
#define kStickerMaxScale   4.0
#define kTransitionMinValue   0.1

#define kVERecordSet @"VERecordSet"
#define kVEProportionIndex  @"VEProportionIndex"    //视频比例
#define kVEBgColorIndex  @"VEBgColorIndex"  //背景颜色
#define kVEVideoBgColorIndex  @"VEVideoBgColorIndex"  //背景颜色
#define kVEEnableVague  @"VEEnableVague"    //模糊背景
#define kVEAVCaptureDevicePosition @"VEAVCaptureDevicePosition"

//#define USEDYNAMICCOVER

#define kLRFlipTransform CGAffineTransformMakeScale(-1.0, 1.0)  //左右
#define kUDFlipTransform CGAffineTransformMakeScale(1.0,-1.0)   //上下
#define kLRUPFlipTransform CGAffineTransformScale(CGAffineTransformMakeScale(1.0,-1.0), -1.0, 1.0)  //上下左右

#define isUseCustomLayer 1
#define BuildAutoSeek 1

#define  KScrollHeight   60
#define kDefaultFontSize 20.0

#define kHandleHeight 50.0    //把手高度

#define MAX_DETECT_NUM 21 //最大检测次数
