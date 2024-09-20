
#import <UIKit/UIKit.h>
#import <VEENUMCONFIGER/VEMusicInfo.h>
#import "VEConfigManager.h"
#import <LibVECore/Scene.h>
#import "VEAuthorizationView.h"
#import "UIButton+VECustomLayout.h"

#define EnableSDWebImage
#define EnableVESpecialCamera

#define HEXCOLOR(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 green:((c>>16)&0xFF)/255.0 blue:((c>>8)&0xFF)/255.0  alpha:((c)&0xFF)/255.0]
#define ANDROID_COLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0  alpha:((c>>24)&0xFF)/255.0]

//画笔
typedef NS_ENUM(NSInteger, VEDoodleType){
    VEDoodleType_rectangle,   //矩形
    VEDoodleType_arrow,       //箭头
    VEDoodleType_pencil,      //画笔
};

typedef NS_ENUM(NSInteger,VLSegmentType){
    KVLSegment_None = 0, //无
    KVLSegment_AI, //智能
    KVLSegment_Green, //绿幕
    KVLSegment_ChromaColor, //色度抠图
};
typedef NS_ENUM(NSInteger,KVLBeautyType){
    KVLBeautyType_Blur = 0, //磨皮
    KVLBeautyType_Brightness, //美白
    KVLBeautyType_ToneIntensity, //红润
    KVLBeautyType_Bigeye, //大眼
    KVLBeautyType_ThinFace, //瘦脸
};

typedef NS_ENUM(NSInteger ,KBeautyCategoryType) {
    KBeautyCategory_None = 0,             //无
    KBeautyCategory_FiveSenses,          //五官
    KBeautyCategory_BlurIntensity,        //磨皮
    KBeautyCategory_WHitening,           //美白
    KBeautyCategory_Rosy,                  //红润
    KBeautyCategory_BigEyes,             //大眼
    KBeautyCategory_FaceLift,             //瘦脸
    KBeautyCategory_Hair,                   //头发
    KBeautyCategory_DressUp,                   //换装
};

typedef NS_ENUM(NSInteger ,KBeautyType) {
    KBeauty_FaceWidth           = 0,    //脸的宽度
    KBeauty_Forehead            = 1,    //额头高度
    KBeauty_ChinWidth           = 2,    //下颚的宽度
    KBeauty_ChinHeight          = 3,    //下巴的高度
    KBeauty_EyeSize             = 4,    //眼睛大小
    KBeauty_EyeWidth            = 5,    //眼睛宽度
    KBeauty_EyeHeight           = 6,    //眼睛高度
    KBeauty_EyeSlant            = 7,    //眼睛倾斜
    KBeauty_EyeDistance         = 8,    //眼睛距离
    KBeauty_NoseSize            = 9,    //鼻子大小
    KBeauty_NoseWidth           = 10,   //鼻子宽度
    KBeauty_NoseHeight          = 11,   //鼻子高度
    KBeauty_MouthWidth          = 12,   //嘴巴宽度
    KBeauty_LipUpper            = 13,   //上嘴唇
    KBeauty_LipLower            = 14,   //下嘴唇
    KBeauty_Smile               = 15,   //微笑
    KBeauty_BlurIntensity       = 16,   //磨皮
    KBeauty_BrightIntensity     = 17,   //美白
    KBeauty_ToneIntensity       = 18,   // 红润
    KBeauty_BigEyes             = 19,   //大眼
    KBeauty_FaceLift            = 20,   //瘦脸
    KBeauty_beauty              = 21,   //一键美颜
};

//选择本地还是音乐类型
typedef NS_ENUM(NSInteger, VESELECTMUSICTYPE){
    kVEMUSICLIBRARY,
    kVEMUSICOLLECTION,
    kVELOCALMUSIC
};

typedef NS_ENUM(NSInteger,FileCropModeType)
{
    kCropTypeNone       = 0,
    kCropTypeOriginal   = 1,      /**< 原始 */
    kCropTypeFreedom    = 2,      /**< 自由 */
    kCropType9v16       = 3,      /**< 9v16 */
    kCropType16v9       = 4,      /**< 16v9*/
    kCropType1v1        = 5,      /**< 1v1 */
    
    kCropType6v7        = 6,
    kCropType5v8        = 7,
    kCropType4v5        = 8,
    kCropType4v3        = 9,
    kCropType3v5        = 10,
    kCropType3v4        = 11,
    kCropType3v2        = 12,
    kCropType235v1      = 13,
    kCropType2v3        = 14,
    kCropType2v1        = 15,
    kCropType185v1      = 16,
    kCropTypeFixed      = 17,    /**< 固定裁切范围 */
    kCropTypeFixedRatio = 18,    /**< 固定比例裁切*/
};

//typedef NS_ENUM(NSInteger,FileCropModeType)
//{
//    kCropTypeNone       = 0,
//    kCropTypeOriginal   = 1,      /**< 原始 */
//    kCropTypeFreedom    = 2,      /**< 自由 */
//    kCropType1v1        = 3,      /**< 1v1 */
//    kCropType16v9       = 4,
//    kCropType9v16       = 5,
//    kCropType4v3        = 6,
//    kCropType3v4        = 7,
//    kCropType6v7        = 8,
//    kCropType4v5        = 9,
//    kCropTypeFixed      = 10,    /**< 固定裁切范围 */
//    kCropTypeFixedRatio = 11,    /**< 固定比例裁切*/
//};

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
    VEAdvanceEditType_Split             =  34,  //分割
    VEAdvanceEditType_SubtitleToAudio   = 35,   //文字转语音
    //PESDK
    VEAdvanceEditType_Beauty            = 36,   //美颜
    VEAdvanceEditType_Smear             = 37,   //涂抹
    VEAdvanceEditType_Blurry            = 38,   //模糊
    VEAdvanceEditType_Aperture          = 39,   //光圈
    VEAdvanceEditType_HDR               = 40,   //HDR
    VEAdvanceEditType_Holy              = 41,   //圣光
    VEAdvanceEditType_Spirit            = 42,   //暗角
    VEAdvanceEditType_Sharpen           = 43,   //锐化
    VEAdvanceEditType_INTELLIGENT_KEY   = 44,   //智能抠像
    VEAdvanceEditType_Layer             = 45,   //图层
    VEAdvanceEditType_REPLACE           = 46,   //替换
    VEAdvanceEditType_TRANSPARENCY      = 47,   //透明度
    VEAdvanceEditType_ChangeBackground  = 48,   //换背景
    VEAdvanceEditType_ErasePen          = 49,   //消除笔
    VEAdvanceEditType_EdgeFeathering    = 50,   //边缘羽
    VEAdvanceEditType_Fillet            = 51,   //圆角
    VEAdvanceEditType_MIXEDMODE         = 52,   //混合模式
    VEAdvanceEditType_MASK              = 53,   //蒙版
    VEAdvanceEditType_DOF               = 54,   //景深
    VEAdvanceEditType_BOX               = 55,   //边框
    VEAdvanceEditType_Superposi         = 56,   //叠加
    VEAdvanceEditType_Sky               = 57,   //天空
    VEAdvanceEditType_Cato              = 58,   //加图
    VEAdvanceEditType_Cutout            = 59,   //抠图
    VEAdvanceEditType_MergeLayers       = 60,   //图层合并
    VEAdvanceEditType_Hair              = 61,   //头发
    VEAdvanceEditType_FineTun           = 62,   //微调
    VEAdvanceEditType_Particle          = 63,   //粒子
    VEAdvanceEditType_DoodlePen         = 64,   //涂鸦笔
    VEAdvanceEditType_Snapshort         = 66,   //视频截图
    VEAdvanceEditType_BlurBackground    = 67,   //背景虚化
    VEAdvanceEditType_MaskDoodlePen     = 68,   //马赛克涂鸦笔
    VEAdvanceEditType_TemplatedTheme    = 69,   //主题
    VEAdvanceEditType_Camera            = 70,   //摄像头
    VEAdvanceEditType_ImageOcclusion    = 71,   //画面遮挡
    VEAdvanceEditType_Delete            = 72,   //删除
    VEAdvanceEditType_Dehaze            = 73,   //去雾
    VEAdvanceEditType_AutoCaptions      = 74,   //识别字幕
    VEAdvanceEditType_EraseRepair       = 75,   //消除和修补
    VEAdvanceEditType_MagnifyingGlass   = 76,   //放大镜
    VEAdvanceEditType_SmartCrop         = 77,   //智能裁剪
    VEAdvanceEditType_RemoveSmartCrop   = 78,   //移除智能裁剪
};

/*
 *文字素材二级菜单编辑功能
 */
typedef NS_ENUM(NSInteger, PESubtitleEditType){
    PESubtitleEditType_Add         = 10000,//添加
    PESubtitleEditType_Edit        = 10001,//编辑文字
    PESubtitleEditType_Copy        = 10002,//复制
    PESubtitleEditType_Hierarchy   = 10003,//层级
    PESubtitleEditType_Style       = 10004,//样式
    PESubtitleEditType_Delete      = 10005,//删除
    PESubtitleEditType_Material    = 10006,//气泡
    PESubtitleEditType_FancyWord   = 10007,//花字
    PESubtitleEditType_Font        = 10008,//字体
    PESubtitleEditType_FineTun     = 10009,//微调
    PESubtitleEditType_Template    = 10010,//文字模板
    PESubtitleEditType_AddTemplate = 10011,//添加模板
    PESubtitleEditType_Animation   = 10012,//动画
};

/*
 *贴纸素材二级菜单编辑功能
 */
typedef NS_ENUM(NSInteger, PEStickerEditType){
    PEStickerEditType_Add          = 20000,//添加
    PEStickerEditType_Edit         = 20001,//编辑文字
    PEStickerEditType_Copy         = 20002,//复制
    PEStickerEditType_Hierarchy    = 20003,//层级
    PEStickerEditType_TRANSPARENCY = 20004,//透明度
    PEStickerEditType_Flip         = 20005,//镜像
    PEStickerEditType_Delete       = 20006,//删除
    PEStickerEditType_FineTun      = 20007,//微调
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
    KMONGOLIANKEYFRAME  = 44,//蒙板关键帧
    kVEUSEDSINGLEFILTER = 45, //所有滤镜
    KDEFORMED           = 46,   //变形
    KEQUALIZER          = 47, //均衡器
    KBLURRY             = 48, //模糊
    KOPACITY            = 50,//隐藏
    KAUDIOSEPAR         = 51,//音频分离
    KAUDIOPLANTED       = 52,//
    KANTI_SHAKE         = 53,//防抖
    KMORPH              = 54,//边角定位
    KMORPH_DELETE       = 55,//删除边角定位
    kVEVR               = 60, //全景
    kVEEXPORTFRAME      = 61,//单帧导出
    kVEEFFECTS2         = 62, //特效2
    kBasicProperties    = 63,//基础属性
    KCorrection         = 64,//矫正
    KLensTracking       = 65,//镜头追踪
    KLensTracking_Reset = 66,//镜头追踪_重置
    KLensTracking_Adjustment = 67,//镜头追踪_调整
    KLensTracking_Cancel = 68,//镜头追踪_取消
    KSmartCrop          = 69,//智能裁剪
    kExtractFrames      = 70, //抽帧
    kMotionflow         = 71, //补帧
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
    VESDKErrorCode_DownloadMaterial   = 1008, //下载素材失败
    VESDKErrorCode_NoUserID           = 1009, //无用户ID
    VESDKErrorCode_GetResources       = 1010, //获取资源失败
    VESDKErrorCode_UploadResources    = 1011, //获取资源失败
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
    KPIP_MONGOLIANKEYFRAME  = 42,//蒙板关键帧
    KPIP_SOUNDORGINAL       = 43,//原声
    KPIP_MUTEVOLUME         = 44,//静音
    
    kPIP_DEFORMED           = 45,//变形
    KPIP_EQUALIZER          = 46,//均衡器
    KPIP_BLURRY             = 47,//模糊
    KPIP_AUDIOSEPAR         = 48,//aduio Sepateted
    kPIP_REVERSEVIDEO       = 49,//倒放
    KPIP_ANTI_SHAKE         = 50,// 防抖
    
    KPIP_CUTLEFT            =60, //截掉左边部分
    KPIP_CUTRIGHT           =61, //截掉右边部分
    KPIP_ALIGNMENTLEFT      =62,//靠左
    KPIP_ALIGNMENTRIGHT     =63,//靠右
    KPIP_ADJSTLEFT          =64,//延长到左
    KPIP_ADJSTRIGHT         =65,//延长到右
    KPIP_MORPH              =66,//边角定位
    KPIP_MORPH_DELETE       =67,//删除边角定位
    KPIP_VR                 =70,//全景
    KPIP_Bind               =71,//绑定
    KPIP_Record             =72,//record
    KPIP_TextImage            =73,//文字
    kPIP_BasicProperties    = 74,//基础属性
    kPIP_Correction           =  75,//矫正
    kPIP_LensTracking       = 76,//镜头追踪
    kPIP_ExtractFrames      = 77,//抽帧
    kPIP_Motionflow         = 78,//补帧
};

/*
 *素材编辑功能
 */
typedef NS_ENUM(NSInteger, VEMaterialEditType){
    VEMaterialEditType_Add         = 0,//添加
    VEMaterialEditType_Copy        = 1,//复制
    VEMaterialEditType_Delete      = 2,//删除
    VEMaterialEditType_Time        = 3,//调整起始时间
    VEMaterialEditType_Trim        = 4,//截取
    VEMaterialEditType_Split       = 5,//分割
    VEMaterialEditType_Rect        = 6,//调整位置
    VEMaterialEditType_Keyframe    = 7,//关键帧
    VEMaterialEditType_Hierarchy    = 8,//层级
    VEMaterialEditType_BasicProperties = 9,//基础属性
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
    VEVideoCropType_FixedCrop = 3,         //固定比例裁剪
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
    Adjust_Separation,      //色调分离
    Adjust_HSL,
    Adjust_Curve,           //曲线
    Adjust_Contrast,        //对比度
    Adjust_Saturation,      //饱和度
    Adjust_Sharpness,       //锐度
    Adjust_WhiteBalance,    //色温
    Adjust_Vignette,        //暗角
    Adjust_Highlight,       //高光
    Adjust_Shadow,          //阴影
    Adjust_Granule,         //颗粒
    Adjust_LightSensation,  //光感
    Adjust_Tint,            //色调
    Adjust_Fade,            //褪色
    Adjust_Exposure,      //曝光
    
    Adjust_Clarity,      //清晰度
    Adjust_NaturalSaturation,      //自然饱和度
    Adjust_SoftLight,        //柔光
};

//字幕对齐方式
typedef NS_ENUM(NSInteger, UICaptionTextAlignment) {
    UICaptionTextAlignmentLeft = 0,
    UICaptionTextAlignmentCenter,
    UICaptionTextAlignmentRight
};

//网络素材类型
typedef NS_ENUM(NSInteger, VENetworkMaterialType){
    VENetworkMaterialType_Subtitle          = 0,    //字幕
    VENetworkMaterialType_Font              = 1,    //字体
    VENetworkMaterialType_SubtitleAnimation = 2,    //字幕动画
    VENetworkMaterialType_Sticker           = 3,    //贴纸
    VENetworkMaterialType_StickerAnimation  = 4,    //贴纸动画
    VENetworkMaterialType_Filter            = 5,    //滤镜
    VENetworkMaterialType_Effect            = 6,    //特效
    VENetworkMaterialType_Music             = 7,    //音乐
    VENetworkMaterialType_SoundEffect       = 8,    //音效
    VENetworkMaterialType_MediaAnimation    = 9,    //媒体动画
    VENetworkMaterialType_Transition        = 10,   //转场
    VENetworkMaterialType_AETemplate        = 11,   //剪同款
    VENetworkMaterialType_CameraTemplate    = 12,   //拍同款
};

//画笔
typedef NS_ENUM(NSInteger, SystemAuthorizationType){
    SystemAuthorizationType_Album,              //相册
    SystemAuthorizationType_Camera,             //相机
    SystemAuthorizationType_Microphone,         //麦克风
    SystemAuthorizationType_CameraAndMic,       //相机和麦克风
    SystemAuthorizationType_SpeechRecognition,  //语音识别
    SystemAuthorizationType_SpeechAndMic,       //语音识别和麦克风
    SystemAuthorizationType_MediaLibrary,       //媒体库
};

typedef void(^VERecordCompletionHandler) (int result,NSString *path,VEMusicInfo *music);

/** 录制完后不合并视频的回调
 */
typedef void(^VERecordDisableMergeCompletionHandler) (int type, NSMutableArray <NSURL *>*urls, VEMusicInfo *music);

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

#define EDITTAG     20101       //功能编辑区tag值

#define TIMESCALE 600
#define kRECORDAAC //直接录制AAC，如果录制MP3则注释掉这一行
#define KPICDURATION 3  //图片显示时长
#define VIDEOMINDURATION 0.1 //视频最短时长，用于分割、截取

//判断是否为iPad
#define iPad ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//#define iPad_HD ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
#define iPadToolWidth 130
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

#define WeakSelf(obj) __weak typeof(obj) weakSelf = obj;
#define StrongSelf(obj) __strong typeof(obj) strongSelf = weakSelf;
#define iPhone4s ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.width == 480)
#define LASTIPHONE_5 [UIScreen mainScreen].bounds.size.height > 480
#define LastIphone5 [UIScreen mainScreen].bounds.size.width > 320
#define VE_isIPhone_iPhone12 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1170, 2532), [[UIScreen mainScreen] currentMode].size) : NO)
//判断iPhone12 Pro Max
#define VE_isIPhone_iPhone12_ProMax ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) : NO)
//#define iPhone_X (  (([[UIScreen mainScreen] bounds].size.height == 812.0 && [[UIScreen mainScreen] bounds].size.width == 375.0) || ([[UIScreen mainScreen] bounds].size.height == 375.0 && [[UIScreen mainScreen] bounds].size.width == 812.0))   ||   (([[UIScreen mainScreen] bounds].size.height == 896.0 && [[UIScreen mainScreen] bounds].size.width == 414.0) || ([[UIScreen mainScreen] bounds].size.height == 414.0 && [[UIScreen mainScreen] bounds].size.width == 896.0)) ||VE_isIPhone_iPhone12|| VE_isIPhone_iPhone12_ProMax)
#define iPhone_X ({\
BOOL isPhoneX = NO;\
if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {\
    if (@available(iOS 11.0, *)) {\
        if ([[UIApplication sharedApplication].windows firstObject].safeAreaInsets.bottom > 0) {\
            isPhoneX = YES;\
        }\
    }\
}\
isPhoneX;\
})
#define Color(r,g,b,a)   [UIColor colorWithRed:(r/(float)255) green:(g/(float)255) blue:(b/(float)255) alpha:a]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define VE_EXPORTBTN_TITLE_COLOR [VEConfigManager sharedManager].exportButtonTitleColor
#define VE_EXPORTBTN_BG_COLOR [VEConfigManager sharedManager].exportButtonBackgroundColor
#define Main_Color [VEConfigManager sharedManager].mainColor
#define kRedColor UIColorFromRGB(0xef313f)
#define kFreezeFrameFxId [VEConfigManager sharedManager].freezeFXCategoryId
#define VE_NAV_TITLE_COLOR [VEConfigManager sharedManager].navigationBarTitleColor
#define NAVIBGCOLOR [VEConfigManager sharedManager].navigationBackgroundColor
#define NAVIBARTITLEFONT [VEConfigManager sharedManager].navigationBarTitleFont
#define SliderMinimumTrackTintColor [UIColor whiteColor]
#define SliderMaximumTrackTintColor UIColorFromRGB(0x434343)
#pragma mark-PESDK颜色配比
#define PEDrawMain_Color UIColorFromRGB(0xf74660)//UIColorFromRGB(0x9600ff)
#define PEDrawTEXT_COLOR UIColorFromRGB(0x3a3a3a)
#define PESDKMain_Color Main_Color //

#define PESDKTEXT_COLOR UIColorFromRGB(0xcccccc)//
#define VIEW_COLOR UIColorFromRGB(0x111111)
#define VIEW_IPAD_COLOR UIColorFromRGB(0x1a1a1a)
#define SCREEN_IPAD_BACKGROUND_COLOR UIColorFromRGB(0x070709)
#define NV_Color 0x27262c
#define SCREEN_BACKGROUND_COLOR [VEConfigManager sharedManager].viewBackgroundColor
#define BACKGROUND_WHITE_COLOR UIColorFromRGB(0xefefef)
#define TOOLBAR_COLOR UIColorFromRGB(0x101010)
#define CUSTOM_GRAYCOLOR UIColorFromRGB(0xb2b2b2)
#define TEXT_COLOR UIColorFromRGB(0xcccccc)
#define HIGHLIGHTED_COLOR UIColorFromRGB(0x3c3d3d)
#define DISABLED_COLOR UIColorFromRGB(0x3c3d3d)
#define SUBTITLETEXT_COLOR UIColorFromRGB(0xcccccc)
#define BOTTOM_COLOR [UIColor blackColor]//UIColorFromRGB(0x33333b)
#define ADDEDMATERIALCOLOR UIColorFromRGB(0x8cb27b) //字幕等遮罩的颜色//58bb9d
#define MATERIALMASKCOLOR ADDEDMATERIALCOLOR//[ADDEDMATERIALCOLOR colorWithAlphaComponent:0.9]
#define ipadToolBarHeight (iPad?20:0)
#define kSplitLineColor UIColorFromRGB(0x1f1f1f)//分割线颜色
#define kTtitleSplitLineColor UIColorFromRGB(0x272727)//标题分割线颜色
//视频导出帧率
#define kEXPORTFPS 24
//视频导出分辨率
#define kVIDEOHEIGHT ([VEHelp isLowDevice] ? 480 : 720)
#define kVIDEOWIDTH ([VEHelp isLowDevice] ? 852 : 1280)
#define kSQUAREVIDEOWIDTH 720

#define IMAGE_MAX_SIZE_WIDTH 1080
#define IMAGE_MAX_SIZE_HEIGHT 1080
//设备屏幕宽高
#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height
#define kNavigationBarHeight (iPhone_X ? 88 : 44)
#define kToolbarHeight (iPhone_X ? 78 : 44 )// + ipadToolBarHeight
#define kPlayerViewHeight (iPad ? (kHEIGHT - 223) : (kHEIGHT - (iPhone_X ? (44 + 34) : (0  + ipadToolBarHeight)) - ( 0.523 * kWIDTH ) - (iPad?0:20) - 30 ))
//#define kToolbarHeight (iPhone_X ? 78 : 44)
//#define kPlayerViewHeight (kHEIGHT - (iPhone_X ? 44 + 34 : 0) - ( 0.523 * kWIDTH ) - 20)
#define kPlayerViewOriginX (iPhone_X ? 44 : 0)
#define kIs_iPhoneX iPhone_X
#define kIs_iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/*状态栏高度+ NavgationBar高度*/
#define kNavgationBar_Height   (kIs_iPhoneX ? 88:64)
/*状态栏高度*/
#define kStatusBarHeight (CGFloat)(kIs_iPhoneX?(44.0):(20.0))
/*底部安全区域远离高度*/
#define kBottomSafeHeight [VEHelp safeAreaInsets].bottom//(CGFloat)(kIs_iPhoneX?(34.0):(0))
#define kStickerMinScale   0.1
#define kStickerMaxScale   4.0
#define kTransitionMinValue   0.1
//#define USEDYNAMICCOVER
#define kLRFlipTransform CGAffineTransformMakeScale(-1.0, 1.0)  //左右
#define kUDFlipTransform CGAffineTransformMakeScale(1.0,-1.0)   //上下
#define kLRUPFlipTransform CGAffineTransformScale(CGAffineTransformMakeScale(1.0,-1.0), -1.0, 1.0)  //上下左右

#define isUseCustomLayer 1
#define BuildAutoSeek 1

#define  KScrollHeight   60
#define kDefaultFontSize 22.0

#define kHandleHeight 50.0    //把手高度

#define MAX_DETECT_NUM 21 //最大检测次数
#define kCollectionMarkTag -100

#define kBundName @"VEEditSDK"
#define kVELanguage @"VELanguage"

#define ClassBundle [NSBundle bundleForClass:self.class]
#define VEEditResourceBundle [VEHelp getEditBundle]
#define VEEditBundlePath VEEditResourceBundle.bundlePath
#define VERecordResourceBundle [VEHelp getRecordBundle]
#define VEDemoUseBundle [VEHelp getDemoUseBundle]
//#define isEnglish [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] hasPrefix:@"en"] || [[[NSUserDefaults standardUserDefaults] objectForKey:kVELanguage] isEqualToString:@"en"]
#define isEnglish ([[[NSUserDefaults standardUserDefaults] objectForKey:kVELanguage] length] > 0 ? [[[NSUserDefaults standardUserDefaults] objectForKey:kVELanguage] isEqualToString:@"en"] : [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] hasPrefix:@"en"])
#define kIsChinese ([[[NSUserDefaults standardUserDefaults] objectForKey:kVELanguage] length] > 0 ? ([[[NSUserDefaults standardUserDefaults] objectForKey:kVELanguage] isEqualToString:@"zh-Hans"] || [[[NSUserDefaults standardUserDefaults] objectForKey:kVELanguage] isEqualToString:@"zh-Hant"]) : ([[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] hasPrefix:@"zh-Hans"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] hasPrefix:@"zh-Hant"]))
#define LanguageBundle [NSBundle bundleWithPath:[ClassBundle pathForResource:[NSString stringWithFormat:@"VEEditSDK.bundle/%@", isEnglish ? @"en" : @"zh-Hans"] ofType:@"lproj"]]
//#define VELocalizedString(key,des) [LanguageBundle localizedStringForKey:(key) value:des table:@"VEEditSDK_Localizable"]
#define VELocalizedString(key,des) [VEHelp getLocalizedString:key]

#define kLocalTransitionFolder [VEEditBundlePath stringByAppendingPathComponent:@"transitions"]

#define kVEDirectory [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents"]//[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

#define kMusicFolder_old [NSTemporaryDirectory() stringByAppendingString:@"music/"]
#define kMusicIconPath_old [NSTemporaryDirectory() stringByAppendingString:@"music/musicIcon/"]
#define kMusicPath_old [NSTemporaryDirectory() stringByAppendingString:@"music/musics/"]

#define kThemeMVPath_old [NSTemporaryDirectory() stringByAppendingString:@"MV/"]
#define kThemeMVIconPath_old [NSTemporaryDirectory() stringByAppendingString:@"MV/MVIcon/"]
#define kThemeMVEffectPath_old [NSTemporaryDirectory() stringByAppendingString:@"MV/MVEffects/"]

#define kMusicFolder [kVEDirectory stringByAppendingPathComponent:@"music"]
#define kMusicIconPath [kMusicFolder stringByAppendingPathComponent:@"musicIcon"]
#define kMusicPath [kMusicFolder stringByAppendingPathComponent:@"musics"]

#define kThemeMVPath [kVEDirectory stringByAppendingPathComponent:@"MV"]
#define kThemeMVIconPath [kThemeMVPath stringByAppendingPathComponent:@"MVIcon"]
#define kThemeMVEffectPath [kThemeMVPath stringByAppendingPathComponent:@"MVEffects"]

#define kShareFileFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/ShareFileFolder/"]

#define kMVAnimateFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/MVAnimate/"]
#define kMVAnimatePlistPath [kMVAnimateFolder stringByAppendingPathComponent:@"animationlist_videoae.plist"]
#define kMusicAnimatePlistPath [kMVAnimateFolder stringByAppendingPathComponent:@"musicAnimation.plist"]
#define kTextAnimateFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/TextAnimate/"]
#define kTempTextAnimateFolder [NSTemporaryDirectory() stringByAppendingPathComponent:@"TextAnimate/"]

#define kAPITemplateFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/VENetworkAPITemplate/"]
#define kAPITemplatePlistPath [kAPITemplateFolder stringByAppendingPathComponent:@"veNetworkApiTemplates.plist"]
#define kBookTemplateFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/VENetworkBookTemplate/"]
#define kBookTemplatePlistPath [kBookTemplateFolder stringByAppendingPathComponent:@"veNetworkBookTemplates.plist"]

#define kPhotoSingingTemplateFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/VENetworkPhotoSingTemplate/"]
#define kPhotoSingingTemplatePlistPath [kPhotoSingingTemplateFolder stringByAppendingPathComponent:@"veNetworkPhotoSingTemplates.plist"]

#define kPlayscriptTemplateFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/VENetworkPlayscriptTemplate/"]
#define kPlayscriptTemplatePlistPath [kBookTemplateFolder stringByAppendingPathComponent:@"veNetworkPlayscriptTemplates.plist"]

#define kMusicAlbumTemplateFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/VENetworkMusicAlbumTemplate/"]
#define kMusicAlbumTemplatePlistPath [kBookTemplateFolder stringByAppendingPathComponent:@"veNetworkMusicAlbumTemplates.plist"]


#define kFragmentAPITemplatePlistPath [kAPITemplateFolder stringByAppendingPathComponent:@"veNetworkFragmentApiTemplates.plist"]//test

#define kCoverTemplateFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/VENetworkCoverTemplate/"]
#define kCoverTemplatePlistPath [kCoverTemplateFolder stringByAppendingPathComponent:@"veNetworkCoverTemplates.plist"]

#define kSpecialEffectFolder2 [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/SpecialEffect2"]
#define kNewSpecialEffectPlistPath2 [kSpecialEffectFolder2 stringByAppendingPathComponent:@"SpecialEffectList_New2.plist"]
#define kCollectEffectPlistPath2 [kSpecialEffectFolder2 stringByAppendingPathComponent:@"CollectEffect2.plist"]
#define kRecentEffectPlistPath2 [kSpecialEffectFolder2 stringByAppendingPathComponent:@"RecentEffect2.plist"]

#define kSpecialEffectFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/SpecialEffect"]
#define kNewSpecialEffectPlistPath [kSpecialEffectFolder stringByAppendingPathComponent:@"SpecialEffectList_New.plist"]
#define kCollectEffectPlistPath [kSpecialEffectFolder stringByAppendingPathComponent:@"CollectEffect.plist"]
#define kRecentEffectPlistPath [kSpecialEffectFolder stringByAppendingPathComponent:@"RecentEffect.plist"]

#define kBoxEffectFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/BoxEffect"]
#define kNewBoxEffectPlistPath [kBoxEffectFolder stringByAppendingPathComponent:@"BoxEffectList_New.plist"]

#define kSuperposiEffectFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/SuperposiEffect"]
#define kNewSuperposiEffectPlistPath [kSuperposiEffectFolder stringByAppendingPathComponent:@"SuperposiEffectList_New.plist"]

#define kTransitionFolder [kVEDirectory stringByAppendingPathComponent:@"transitionFiles"]
#define kTransitionPlistPath [kTransitionFolder stringByAppendingPathComponent:@"TransitionList.plist"]
#define kTransitionIconFolder [kTransitionFolder stringByAppendingPathComponent:@"TransitionIconFolder"]
#define kEffectIconFolder [kVEDirectory stringByAppendingPathComponent:@"EffectIconFolder"]

#define kLocalTransitionPlist [kLocalTransitionFolder stringByAppendingPathComponent:@"Transition.plist"]
#define kDefaultTransitionTypeName @"基础"

#define kWatermarkFolder [NSTemporaryDirectory() stringByAppendingString:@"watermark/"]

#define kMergeLayersFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/MergeLayersFloatder"]

#define kMattingFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/VideoMatting"]
#define kErasePenFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/ErasePenFloatder"]
#define kTextImageFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/TextImage"]
#define kCoverFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/cover"]
#define kCanvasFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/Canvas"]
#define kLocalCanvasFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/LocalCanvas"]
#define kLocalCanvasPlist [kLocalCanvasFolder stringByAppendingPathComponent:@"LocalCanvas.plist"]
#define kCoverTemplateFodler [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/coverTemplateFolder"]

#define kDoodleFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/doodle"]
#define kTextboardFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/textboard"]
#define kCurrentFrameTextureFolder  [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/currentFrameTexture"]

#define kAEJsonMVEffectPath [NSTemporaryDirectory() stringByAppendingString:@"AEJsonAnimation/"]
#define kAEPreProgressFolder [kAEJsonMVEffectPath stringByAppendingPathComponent:@"AEPreProgress"]

#define kStickerImageGIFFolder [NSTemporaryDirectory() stringByAppendingString:@"StickerImageGIFFolder/"]

#define kVEDraftDirectory [kVEDirectory stringByAppendingPathComponent:@"VEDraft"]
#define kVEDraftPListPath [kVEDraftDirectory stringByAppendingPathComponent:@"VEDraft.plist"]
#define kVEDraftListPath [kVEDraftDirectory stringByAppendingPathComponent:@"veDraft.plist"]
#define kVEDraftUndonePath [kVEDraftDirectory stringByAppendingPathComponent:@"veDraftUndone.plist"]
#define kVECloudBackupDirectory [kVEDirectory stringByAppendingPathComponent:@"VECloudBackup"]//已下载云备份

#define kSubtitleEffectFolder [kVEDirectory stringByAppendingPathComponent:@"SubtitleEffect"]
#define kSubtitleFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"Subtitle"]
#define kSubtitleIconPath [kSubtitleFolder stringByAppendingPathComponent:@"icon"]
#define kSubtitlePlistPath [kSubtitleFolder stringByAppendingPathComponent:@"SubtitleListType.plist"]
#define kSubtitleIconPlistPath [kSubtitleFolder stringByAppendingPathComponent:@"SubtitleIconList.plist"]
#define kSubtitleCategoryPlistPath [kSubtitleFolder stringByAppendingPathComponent:@"SubtitleCategoryListType.plist"]

//放大镜
#define kMagnifyingGlassFolder [kVEDirectory stringByAppendingPathComponent:@"magnifyingGlass"]
#define kMagnifyingGlassEffectFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/Magnifier"]
#define kMagnifyingGlassPlistPath [kMagnifyingGlassFolder stringByAppendingPathComponent:@"magnifyingGlassListType.plist"]

//自定义贴纸
#define kCustomStickerFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/CustomStickerFolder/"]
#define kCollectStickerPlistPath [kCustomStickerFolder stringByAppendingPathComponent:@"CollectSticker.plist"]
#define kVEHistoryStickerPlistPath [kCustomStickerFolder stringByAppendingPathComponent:@"VEHistorySticker.plist"]

#pragma mark- 换背景
#define KChangeBackgroundFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/ChangeBackground"]
#define kChangeBackgroundPath [KChangeBackgroundFolder stringByAppendingPathComponent:@"ChangeBackgroundPath.plist"]

#pragma mark- 天空
#pragma mark- 换背景
#define KChangeSkyFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/ChangeSky"]
#define kChangeSkyPath [KChangeSkyFolder stringByAppendingPathComponent:@"ChangeSkyPath.plist"]

#define KChangeMaskFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/ChangeMask"]
#define kChangeMaskPath [KChangeMaskFolder stringByAppendingPathComponent:@"ChangeMaskPath.plist"]

#pragma mark- 图片流动换天空背景
#define KChangeSkyVideoFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/ChangeSkyVideo"]
#define kChangeSkyVideoPath [KChangeSkyFolder stringByAppendingPathComponent:@"ChangeSkyPath.plist"]

#pragma mark- 字幕动画
#define KSubtitleAnimationFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/SubtitleAnimation"]
#define kSubtitleAnimationPath [KSubtitleAnimationFolder stringByAppendingPathComponent:@"SubtitleAnimationPath.plist"]

#define kTextTemplateFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"textTemplate"]
#define kTextTemplatePlistPath [kTextTemplateFolder stringByAppendingPathComponent:@"TextTemplatePlistList.plist"]
#define kTextTemplateIconFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"TextTemplateIconFolder"]

#define KAudioEffectTypesFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/AudioEffectTypes"]
#define KAudioEffectTypesPath [KAudioEffectTypesFolder stringByAppendingPathComponent:@"TypePlistList.plist"]

#define kSubtitleTTSPlistPath [kSubtitleFolder stringByAppendingPathComponent:@"SubtitleTTSListType.plist"]

#define kFontFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"Font"]
#define kLocalFontFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"LocalFont"]
#define kFontIconPath [kFontFolder stringByAppendingPathComponent:@"icon"]
#define kFontPlistPath [kFontFolder stringByAppendingPathComponent:@"fontList2020.plist"]
#define kFontIconPlistPath [kFontFolder stringByAppendingPathComponent:@"fontIconList2020.plist"]
#define kFontCheckPlistPath [kFontFolder stringByAppendingPathComponent:@"fontCheckList2020.plist"]
#define kCollectFontPlistPath [kFontFolder stringByAppendingPathComponent:@"CollectFont.plist"]
#define kFontType @"font_family_2"
#define kPESDKFontType @"font"
#define kDefaultFontPath [VEEditResourceBundle pathForResource:@"New_EditVideo/text_sample/PingFang-SC-Regular" ofType:@"otf"]

#define kFlowerWordFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"FlowerWord"]
#define kFlowerWordPlistPath [kFlowerWordFolder stringByAppendingPathComponent:@"FlowerWord.plist"]

#define kFontLiteFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"FontLite"]
#define kFontLitePlistPath [kFontFolder stringByAppendingPathComponent:@"fontLiteList.plist"]

#define kWebmFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"webm"]
#define kWebmIconPath [kWebmFolder stringByAppendingPathComponent:@"icon"]
#define kWebmPlistPath [kWebmFolder stringByAppendingPathComponent:@"WebmList.plist"]

#define kStickerFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"Effect"]
#define kStickerIconPath [kStickerFolder stringByAppendingPathComponent:@"icon"]
#define kStickerPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectList.plist"]

#define kStickerIconPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectIconList.plist"]

#define kScaleFolder [kVEDirectory stringByAppendingPathComponent:@"scales"]

#define kLocalMusicFolder [kVEDirectory stringByAppendingPathComponent:@"localFileMusics"]

#define kMusicSearchFolder [kVEDirectory stringByAppendingPathComponent:@"MusicSearch"]
#define kMusicSearchHistoryPath [kMusicSearchFolder stringByAppendingPathComponent:@"MusicSearchList.plist"]

#define kStickerTypesPath [kStickerFolder stringByAppendingPathComponent:@"EffectTypesList.plist"]
#define kNewStickerPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectPlistList.plist"]
#define kNewStickerCategoryPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectCategoryPlistList.plist"]
//笔配置
#define kP_anitSubtitleConfigFolder [kVEDirectory stringByAppendingPathComponent:@"P_SubtitleAnitConfigs"]
#define kP_anitSubtitleConfigCategoryPlist [kFilterFolder stringByAppendingPathComponent:@"p_SubtitleAnitConfigCategory.plist"]
#define kP_anitSubtitleConfigTypeListPath [kFilterFolder stringByAppendingPathComponent:@"p_SubtitleAnitConfigTypeList.plist"]

#define kP_anitStickerConfigFolder [kVEDirectory stringByAppendingPathComponent:@"P_StickerAnitConfigs"]
#define kP_anitStickerConfigCategoryPlist [kFilterFolder stringByAppendingPathComponent:@"p_StickerAnitConfigCategory.plist"]
#define kP_anitStickerConfigTypeListPath [kFilterFolder stringByAppendingPathComponent:@"p_StickerAnitConfigTypeList.plist"]

//滤镜目录
#define kFilterFolder [kVEDirectory stringByAppendingPathComponent:@"filters"]
#define kFilterCategoryPlist [kFilterFolder stringByAppendingPathComponent:@"filterCategory.plist"]
#define kNewFilterPlistPath [kFilterFolder stringByAppendingPathComponent:@"filterTypeList.plist"]
#define kFilterCollectionPlist [kFilterFolder stringByAppendingPathComponent:@"filtersCollection.plist"]
#define kFilterCubeLocalFloder [kFilterFolder stringByAppendingPathComponent:@"LocalFilterFldoer"]
#define kFilterCubeLocalCoverFloder [kFilterFolder stringByAppendingPathComponent:@"LocalFilterCoverFldoer"]

#define kImageOcclusionIconPath [kImageOcclusionFolder stringByAppendingPathComponent:@"ImageOcclusionIcon"]
#define kImageOcclusionPlistPath [kImageOcclusionFolder stringByAppendingPathComponent:@"ImageOcclusionList.plist"]
#define kImageOcclusionFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"ImageOcclusion"]
#define kImageOcclusionTypesPath [kImageOcclusionFolder stringByAppendingPathComponent:@"ImageOcclusionTypesList.plist"]
#define kNewImageOcclusionPlistPath [kImageOcclusionFolder stringByAppendingPathComponent:@"ImageOcclusionPlistList.plist"]
#define kNewImageOcclusionCategoryPlistPath [kStickerFolder stringByAppendingPathComponent:@"ImageOcclusionCategoryPlistList.plist"]

//粒子目录
#define kParticlesFolder [kVEDirectory stringByAppendingPathComponent:@"particles"]
#define kParticlesCategoryPlist [kParticlesFolder stringByAppendingPathComponent:@"particlesCategory.plist"]
#define kNewParticlesPlistPath [kParticlesFolder stringByAppendingPathComponent:@"particlesTypeList.plist"]

//APITemplate
#define kAPITemplateVideoFolder [kVEDirectory stringByAppendingPathComponent:@"templateVideoFolder"]

//拍摄粒子目录
#define kShootParticlesFolder [kVEDirectory stringByAppendingPathComponent:@"shootParticles"]
#define kShootParticlesCategoryPlist [kShootParticlesFolder stringByAppendingPathComponent:@"shootParticlesCategory.plist"]
#define kNewShootParticlesPlistPath [kShootParticlesFolder stringByAppendingPathComponent:@"shootParticlesTypeList.plist"]

//自动踩点目录
#define kPlantedsFolder [kVEDirectory stringByAppendingPathComponent:@"planteds"]
#define kPlantedsPlistPath [kPlantedsFolder stringByAppendingPathComponent:@"plantedsPlistList.plist"]

//防抖
#define kAntiShakeFolder [kVEDirectory stringByAppendingPathComponent:@"kAntiShake"]

//涂鸦笔
#define kDoodlePensFolder [kVEDirectory stringByAppendingPathComponent:@"DoodlePens"]
#define kDoodlePensCategoryPlist [kDoodlePensFolder stringByAppendingPathComponent:@"DoodlePensCategory.plist"]
#define kDoodlePensPlistPath [kDoodlePensFolder stringByAppendingPathComponent:@"DoodlePensTypeList.plist"]
#define kDoodlePensIconFolder [kDoodlePensFolder stringByAppendingPathComponent:@"DoodlePensIconFolder"]


//换发目录
#define kHairFolder [kVEDirectory stringByAppendingPathComponent:@"hairs"]
#define kHairCategoryPlist [kHairFolder stringByAppendingPathComponent:@"hairCategory.plist"]
#define kNewHairPlistPath [kHairFolder stringByAppendingPathComponent:@"hairTypeList.plist"]
//换装目录
#define kDressUpFolder [kVEDirectory stringByAppendingPathComponent:@"dressUps"]
#define kDressUpCategoryPlist [kDressUpFolder stringByAppendingPathComponent:@"dressUpCategory.plist"]
#define kNewDressUpPlistPath [kDressUpFolder stringByAppendingPathComponent:@"dressUpTypeList.plist"]
#pragma mark-图片上色
#define kFlowColorFillFolder [kVEDirectory stringByAppendingPathComponent:@"FlowColorFills"]
#define kColorFillCategoryPlist [kFlowCollageFolder stringByAppendingPathComponent:@"ColorFillCategory.plist"]
#define kNewColorFillPlistPath [kFlowCollageFolder stringByAppendingPathComponent:@"ColorFillTypeList.plist"]
#pragma mark-图片流动音乐
#define kFlowCollageFolder [kVEDirectory stringByAppendingPathComponent:@"FlowCollages"]
#define kCollageCategoryPlist [kFlowCollageFolder stringByAppendingPathComponent:@"CollageCategory.plist"]
#define kNewCollagePlistPath [kFlowCollageFolder stringByAppendingPathComponent:@"CollageTypeList.plist"]

#define kTemplateRecordFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/TemplateRecord"]
#define kTemplateRecordPlist [kTemplateRecordFolder stringByAppendingPathComponent:@"TemplateRecord.plist"]
#define kCollectRecordTemplatePlistPath [kTemplateRecordFolder stringByAppendingPathComponent:@"CollectRecordTemplate.plist"]

#pragma mark-媒体动画
#define KAnimationFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/Animation"]
#define kAnimationPath [KAnimationFolder stringByAppendingPathComponent:@"AnimationPath.plist"]

#pragma mark- 贴纸动画
#define KStickerAnimationFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/StickerAnimation"]
#define kStickerAnimationPath [KStickerAnimationFolder stringByAppendingPathComponent:@"StickerAnimationPath.plist"]

#define kTextToSpeechFolder [kVEDirectory stringByAppendingPathComponent:@"TextToSpeech"]
#define kAutoSegmentImageFolder [kVEDirectory stringByAppendingPathComponent:@"AutoSegmentImage"]
#define kSpeechRecordFolder [kVEDirectory stringByAppendingPathComponent:@"SpeechRecord"]

#pragma mark- 相册网络素材库
#define KCloudVideoFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/CloudVideo"]
#define kCloudVideoPath [KCloudVideoFolder stringByAppendingPathComponent:@"CloudVideoPath.plist"]
#define kNewCloudVideoCategoryPlistPath [KCloudVideoFolder stringByAppendingPathComponent:@"CloudVideoCategoryPlistList.plist"]

#pragma mark- 书单网络素材库
#define KBookCloudMaterialFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/BookCloudMaterial"]
#define kBookCloudMaterialPlistPath [KBookCloudMaterialFolder stringByAppendingPathComponent:@"BookCloudMaterialPath.plist"]
#define kBookCloudMaterialCategoryPlistPath [KBookCloudMaterialFolder stringByAppendingPathComponent:@"BookCloudMaterialCategoryList.plist"]

#define kVERecordSet @"VERecordSet"
#define kVEProportionIndex  @"VEProportionIndex"    //视频比例
#define kVEBgColorIndex  @"VEBgColorIndex"  //背景颜色
#define kVEVideoBgColorIndex  @"VEVideoBgColorIndex"  //背景颜色
#define kVEEnableVague  @"VEEnableVague"    //模糊背景
#define kVEAVCaptureDevicePosition @"VEAVCaptureDevicePosition"
#define VECustomErrorDomain @"com.VESDK.ErrorDomain"

#define kThumbnailFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/thumbnailFolder"]

#define kTTSAudioMp3Folder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/TTSAudioMp3"]

#define kWebmMp3Folder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/webmMp3"]
#define kWebmICON @"webm"

#define kWhisperModelFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/whisperModel"]

#define kTemplateThemeFolder [kVEDirectory stringByAppendingPathComponent:@"TemplateThemes"]
#define kTemplateThemeCategoryPlist [kTemplateThemeFolder stringByAppendingPathComponent:@"TemplateThemeCategory.plist"]
#define kTemplateThemeTypeListPath [kTemplateThemeFolder stringByAppendingPathComponent:@"TemplateThemeTypeList.plist"]
#define kTemplateThemeIconFolder [kVEDirectory stringByAppendingPathComponent:@"TemplateThemeIconFolder"]
#define kVEInterfaceStyle @"kVEInterfaceStyle"//界面风格
#define kNewMask

#define SliderMaximumTrackTintColor UIColorFromRGB(0x434343)
#define SliderMinimumTrackTintColor UIColorFromRGB(0xffffff)

#define kOcclusionImageFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/OcclusionImages"]
#define kFaceImagesFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/FaceImages"]

#define kTextMaretrialFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/VETextMaretrial/"]
#define kTextMaretrialPlistPath [kTextMaretrialFolder stringByAppendingPathComponent:@"veTextMaretrials.plist"]

#define kTTSMaretrialFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/VETTSMaretrial/"]
#define kTTSMaretrialPlistPath [kTTSMaretrialFolder stringByAppendingPathComponent:@"veTTSMaretrials.plist"]

#define kPictureTextToVideoFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/VEPictureTextToVideo"]
#define kPictureTextToVideoDraftPListPath [kPictureTextToVideoFolder stringByAppendingPathComponent:@"VEPictureTextToVideo.plist"]
#define kPictureTextToVideoAudioFolder [kPictureTextToVideoFolder stringByAppendingPathComponent:@"Audio"]
#define kPictureTextToVideoMaterialsFolder [kPictureTextToVideoFolder stringByAppendingPathComponent:@"AIMatchMaterials"]

#define kSkyISHorizontal 1

#define kPERepairCustomMaskPath [kVEDirectory stringByAppendingPathComponent:@"PERepairCustomMask"]

#define kDefaultSubtitleText VELocalizedString(@"输入文字...", nil)

#define kPERepairTempPath [kVEDirectory stringByAppendingPathComponent:@"PERepairTempImages"]


#pragma mark- 贴纸动画
#define KStickerAnimationFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/StickerAnimation"]
#define kStickerAnimationPath [KStickerAnimationFolder stringByAppendingPathComponent:@"StickerAnimationPath.plist"]
#define kStickerAnimationIconFolder [KStickerAnimationFolder stringByAppendingPathComponent:@"AnimationIconFolder"]

#define kIsMagnifyingGlassOffset @"isMagnifyingGlassOffset"
#define kIsagnifyingGlassOffsetCenter @"isMagnifyingGlassOffsetCenter"

#define kIsLoadedStickerResource @"isLoadedStickerResource"
#define kIsLoadedFaceShieldResource @"isLoadedFaceShieldResource"//智能挡脸
#define kIsLoadedFlowerWordResource @"isLoadedFlowerWordResource"
#define kIsLoadedTextTemplateResource @"isLoadedTextTemplateResource"

#define kVEEnableChangeColorAnimateId @"1012384"

#define KScriptFolder [[VEConfigManager sharedManager].directory stringByAppendingPathComponent:@"Documents/Script"]

#define kScriptPath [KScriptFolder stringByAppendingPathComponent:@"scriptDraft.plist"]

#define kScriptPropsRecordPlist [KScriptFolder stringByAppendingPathComponent:@"scriptPropsRecord.plist"]

#define PHOTO_ALBUM_NAME [[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"]
