
#import <UIKit/UIKit.h>
#import <VEENUMCONFIGER/VEMusicInfo.h>
#import "VEConfigManager.h"
#import <LibVECore/Scene.h>
#import "VEAuthorizationView.h"
#import "UIButton+VECustomLayout.h"

#define kAppKeyType      @"AppKeyType"       //appkey类型
//画笔
typedef NS_ENUM(NSInteger, VEDoodleType){
    VEDoodleType_rectangle,   //矩形
    VEDoodleType_arrow,       //箭头
    VEDoodleType_pencil,      //画笔
};

typedef NS_ENUM(NSInteger,VLSegmentType){
    KVLSegment_None = 0, //无
    KVLSegment_Green, //绿幕
    KVLSegment_AI, //智能
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

typedef NS_ENUM(NSInteger, VECropType){
    VE_VECROPTYPE_ORIGINAL  = 0,  //原比例
    VE_VECROPTYPE_FREE      = 1,      //自由
    VE_VECROPTYPE_9TO16     = 2,      //9:16
    VE_VECROPTYPE_16TO9     = 3,      //16:9
    VE_VECROPTYPE_1TO1      = 4,      //1:1
    
    VE_VECROPTYPE_6TO7      = 5,      //6:7
    VE_VECROPTYPE_5TO8      = 6,      //5.8"
    VE_VECROPTYPE_4TO5      = 7,      //4:5
    VE_VECROPTYPE_4TO3      = 8,      //4:3
    VE_VECROPTYPE_3TO5      = 9,      //3:5
    VE_VECROPTYPE_3TO4      = 10,      //3:4
    VE_VECROPTYPE_3TO2      = 11,      //3:2
    VE_VECROPTYPE_235TO1    = 12,      //2.35:1
    VE_VECROPTYPE_2TO3      = 13,      //2:3
    VE_VECROPTYPE_2TO1      = 14,      //2:1
    VE_VECROPTYPE_185TO1    = 15,      //1.85:1
    VE_VECROPTYPE_FIXEDRATIO = 16,    /**< 固定比例裁切*/
    VE_VECROPTYPE_1TO2      = 17,      //2:1
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
//
//typedef NS_ENUM(NSInteger, VECropType){
//    VE_VECROPTYPE_FREE = 0,      //自由
//    VE_VECROPTYPE_ORIGINAL = 1,  //原比例
//    VE_VECROPTYPE_9TO16 = 2,      //9:16
//    VE_VECROPTYPE_16TO9 = 3,      //16:9
//    VE_VECROPTYPE_1TO1 = 4,      //1:1
//    VE_VECROPTYPE_6TO7 = 5,      //6:7
//    VE_VECROPTYPE_4TO5 = 6,      //4:5
//    VE_VECROPTYPE_4TO3 = 7,      //4:3
//    VE_VECROPTYPE_3TO4 = 8,      //3:4
//    VE_VECROPTYPE_FIXEDRATIO = 9,    /**< 固定比例裁切*/
//    VE_VECROPTYPE_1TO2 = 10,      //1:2
//    VE_VECROPTYPE_2TO1 = 11,      //2:1
//    VE_VECROPTYPE_2TO3 = 12,      //2:3
//    VE_VECROPTYPE_3TO2 = 13,      //3:2
//};

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
    VEAdvanceEditType_Snapshort        =  66,   //视频截图
    VEAdvanceEditType_BlurBackground  =  67,   //背景虚化
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
    KDEFORMED       = 46,   //变形
    KEQUALIZER      = 47, //均衡器
    KBLURRY           = 48, //模糊
    KOPACITY        = 50,//隐藏
    KAUDIOSEPAR        = 51,//音频分离
    KAUDIOPLANTED        = 52,//
    KANTI_SHAKE     = 53,
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
    KPIP_MUTEVOLUME             = 44,//静音
    
    kPIP_DEFORMED                   =45,    //变形
    KPIP_EQUALIZER                  = 46,   //均衡器
    KPIP_BLURRY                  = 47,   //模糊
    KPIP_AUDIOSEPAR           = 48, //aduio Sepateted
    kPIP_REVERSEVIDEO       = 49,//倒放
    KPIP_ANTI_SHAKE          = 50, // 防抖
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


typedef NS_ENUM(NSInteger, VEMaskType)
{
    VEMaskType_NONE             =0,
    VEMaskType_LINNEAR          =1, //线性
    VEMaskType_MIRRORSURFACE    =2, //镜面
    VEMaskType_ROUNDNESS        =3, //圆形
    VEMaskType_RECTANGLE        =4, //矩形
    VEMaskType_PENTACLE         =5, //五角星
    VEMaskType_LOVE             =6, //爱心
    VEMaskType_QUADRILATERAL    =7, //四边形
    
    VEMaskType_InterMIRRORSURFACE = 1017474, //镜面
    VEMaskType_InterQUADRILATERAL = 1017479, //四边形
    VEMaskType_InterLOVE = 1017478, //爱心
    VEMaskType_InterPENTACLE = 1017477, //五角星
    VEMaskType_InterRECTANGLE = 1017476, //矩形
    VEMaskType_InterROUNDNESS = 1017475, //圆形
    VEMaskType_InterLINNEAR = 1017473, //线性
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
#define Main_Color [VEConfigManager sharedManager].mainColor
#define kFreezeFrameFxId [VEConfigManager sharedManager].freezeFXCategoryId
#define VE_NAV_TITLE_COLOR [VEConfigManager sharedManager].navigationBarTitleColor
#define NAVIBGCOLOR [VEConfigManager sharedManager].navigationBackgroundColor
#define NAVIBARTITLEFONT [VEConfigManager sharedManager].navigationBarTitleFont
#define SliderMaximumTrackTintColor UIColorFromRGB(0x3c3d3d)
#pragma mark-PESDK颜色配比
#define PESDKMain_Color UIColorFromRGB(0x9600ff)
#define PESDKTEXT_COLOR UIColorFromRGB(0x3a3a3a)
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
//#define isEnglish [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] hasPrefix:@"en"] || [[[NSUserDefaults standardUserDefaults] objectForKey:kVELanguage] isEqualToString:@"en"]
#define isEnglish ([[[NSUserDefaults standardUserDefaults] objectForKey:kVELanguage] length] > 0 ? [[[NSUserDefaults standardUserDefaults] objectForKey:kVELanguage] isEqualToString:@"en"] : [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0] hasPrefix:@"en"])
#define LanguageBundle [NSBundle bundleWithPath:[ClassBundle pathForResource:[NSString stringWithFormat:@"VEEditSDK.bundle/%@", isEnglish ? @"en" : @"zh-Hans"] ofType:@"lproj"]]
//#define VELocalizedString(key,des) [LanguageBundle localizedStringForKey:(key) value:des table:@"VEEditSDK_Localizable"]
#define VELocalizedString(key,des) [VEHelp getLocalizedString:key]

#define kLocalTransitionFolder [VEEditBundlePath stringByAppendingPathComponent:@"transitions"]

#define kVEDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]

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

#define kMVAnimateFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MVAnimate/"]
#define kMVAnimatePlistPath [kMVAnimateFolder stringByAppendingPathComponent:@"animationlist_videoae.plist"]
#define kMusicAnimatePlistPath [kMVAnimateFolder stringByAppendingPathComponent:@"musicAnimation.plist"]
#define kTextAnimateFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TextAnimate/"]
#define kTempTextAnimateFolder [NSTemporaryDirectory() stringByAppendingPathComponent:@"TextAnimate/"]

#define kAPITemplateFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/VENetworkAPITemplate/"]
#define kAPITemplatePlistPath [kAPITemplateFolder stringByAppendingPathComponent:@"veNetworkApiTemplates.plist"]
#define kFragmentAPITemplatePlistPath [kAPITemplateFolder stringByAppendingPathComponent:@"veNetworkFragmentApiTemplates.plist"]//test

#define kCoverTemplateFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/VENetworkCoverTemplate/"]
#define kCoverTemplatePlistPath [kCoverTemplateFolder stringByAppendingPathComponent:@"veNetworkCoverTemplates.plist"]

#define kSpecialEffectFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SpecialEffect"]
#define kNewSpecialEffectPlistPath [kSpecialEffectFolder stringByAppendingPathComponent:@"SpecialEffectList_New.plist"]

#define kBoxEffectFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/BoxEffect"]
#define kNewBoxEffectPlistPath [kBoxEffectFolder stringByAppendingPathComponent:@"BoxEffectList_New.plist"]

#define kSuperposiEffectFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SuperposiEffect"]
#define kNewSuperposiEffectPlistPath [kSuperposiEffectFolder stringByAppendingPathComponent:@"SuperposiEffectList_New.plist"]

#define kFlowerEffectFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FlowerEffect"]
#define kNewFlowerEffectPlistPath [kFlowerEffectFolder stringByAppendingPathComponent:@"FlowerEffectList_New.plist"]

#define kTransitionFolder [kVEDirectory stringByAppendingPathComponent:@"transitionFiles"]
#define kTransitionPlistPath [kTransitionFolder stringByAppendingPathComponent:@"TransitionList.plist"]
#define kTransitionIconFolder [kTransitionFolder stringByAppendingPathComponent:@"TransitionIconFolder"]
#define kEffectIconFolder [kVEDirectory stringByAppendingPathComponent:@"EffectIconFolder"]

#define kLocalTransitionPlist [kLocalTransitionFolder stringByAppendingPathComponent:@"Transition.plist"]
#define kDefaultTransitionTypeName @"基础"

#define kWatermarkFolder [NSTemporaryDirectory() stringByAppendingString:@"watermark/"]

#define kMergeLayersFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/MergeLayersFloatder"]

#define kCutoutFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CutoutFloatder"]
#define kErasePenFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ErasePenFloatder"]
#define kCoverFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cover"]
#define kCanvasFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Canvas"]

#define kDoodleFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/doodle"]
#define kTextboardFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/textboard"]
#define kCurrentFrameTextureFolder  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/currentFrameTexture"]

#define kAEJsonMVEffectPath [NSTemporaryDirectory() stringByAppendingString:@"AEJsonAnimation/"]
#define kAEPreProgressFolder [kAEJsonMVEffectPath stringByAppendingPathComponent:@"AEPreProgress"]

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

#pragma mark- 换背景
#define KChangeBackgroundFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ChangeBackground"]
#define kChangeBackgroundPath [KChangeBackgroundFolder stringByAppendingPathComponent:@"ChangeBackgroundPath.plist"]

#pragma mark- 天空
#pragma mark- 换背景
#define KChangeSkyFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ChangeSky"]
#define kChangeSkyPath [KChangeSkyFolder stringByAppendingPathComponent:@"ChangeSkyPath.plist"]

#define KChangeMaskFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ChangeMask"]
#define kChangeMaskPath [KChangeMaskFolder stringByAppendingPathComponent:@"ChangeMaskPath.plist"]

#pragma mark- 图片流动换天空背景
#define KChangeSkyVideoFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ChangeSkyVideo"]
#define kChangeSkyVideoPath [KChangeSkyFolder stringByAppendingPathComponent:@"ChangeSkyPath.plist"]

#pragma mark- 字幕动画
#define KSubtitleAnimationFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SubtitleAnimation"]
#define kSubtitleAnimationPath [KSubtitleAnimationFolder stringByAppendingPathComponent:@"SubtitleAnimationPath.plist"]

#define kTextTemplateFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"textTemplate"]
#define kTextTemplatePlistPath [kTextTemplateFolder stringByAppendingPathComponent:@"TextTemplatePlistList.plist"]
#define kTextTemplateIconFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"TextTemplateIconFolder"]

#define kFontFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"Font"]
#define kFontIconPath [kFontFolder stringByAppendingPathComponent:@"icon"]
#define kFontPlistPath [kFontFolder stringByAppendingPathComponent:@"fontList2020.plist"]
#define kFontIconPlistPath [kFontFolder stringByAppendingPathComponent:@"fontIconList2020.plist"]
#define kFontCheckPlistPath [kFontFolder stringByAppendingPathComponent:@"fontCheckList2020.plist"]
#define kFontType @"font_family_2"
#define kPESDKFontType @"font"
#define kDefaultFontPath [VEEditResourceBundle pathForResource:@"New_EditVideo/text_sample/PingFang-SC-Regular" ofType:@"otf"]

#define kStickerFolder [kSubtitleEffectFolder stringByAppendingPathComponent:@"Effect"]
#define kStickerIconPath [kStickerFolder stringByAppendingPathComponent:@"icon"]
#define kStickerPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectList.plist"]

#define kStickerIconPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectIconList.plist"]

#define kScaleFolder [kVEDirectory stringByAppendingPathComponent:@"scales"];

#define kLocalMusicFolder [kVEDirectory stringByAppendingPathComponent:@"localFileMusics"];

#define kMusicSearchFolder [kVEDirectory stringByAppendingPathComponent:@"MusicSearch"]
#define kMusicSearchHistoryPath [kMusicSearchFolder stringByAppendingPathComponent:@"MusicSearchList.plist"]

#define kStickerTypesPath [kStickerFolder stringByAppendingPathComponent:@"EffectTypesList.plist"]
#define kNewStickerPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectPlistList.plist"]
#define kNewStickerCategoryPlistPath [kStickerFolder stringByAppendingPathComponent:@"EffectCategoryPlistList.plist"]
//滤镜目录
#define kFilterFolder [kVEDirectory stringByAppendingPathComponent:@"filters"]
#define kFilterCategoryPlist [kFilterFolder stringByAppendingPathComponent:@"filterCategory.plist"]
#define kNewFilterPlistPath [kFilterFolder stringByAppendingPathComponent:@"filterTypeList.plist"]

//粒子目录
#define kParticlesFolder [kVEDirectory stringByAppendingPathComponent:@"particles"]
#define kParticlesCategoryPlist [kParticlesFolder stringByAppendingPathComponent:@"particlesCategory.plist"]
#define kNewParticlesPlistPath [kParticlesFolder stringByAppendingPathComponent:@"particlesTypeList.plist"]

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
#pragma mark-图片流动音乐
#define kFlowCollageFolder [kVEDirectory stringByAppendingPathComponent:@"FlowCollages"]
#define kCollageCategoryPlist [kFlowCollageFolder stringByAppendingPathComponent:@"CollageCategory.plist"]
#define kNewCollagePlistPath [kFlowCollageFolder stringByAppendingPathComponent:@"CollageTypeList.plist"]

#pragma mark-图片流动音乐
#define kFlowMusicFolder [kVEDirectory stringByAppendingPathComponent:@"FlowMusics"]
#define kMusicCategoryPlist [kFlowMusicFolder stringByAppendingPathComponent:@"MusicCategory.plist"]
#define kNewMusicPlistPath [kFlowMusicFolder stringByAppendingPathComponent:@"MusicTypeList.plist"]


#define kTemplateRecordFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/TemplateRecord"]
#define kTemplateRecordPlist [kTemplateRecordFolder stringByAppendingPathComponent:@"TemplateRecord.plist"]

#pragma mark-媒体动画
#define KAnimationFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Animation"]
#define kAnimationPath [KAnimationFolder stringByAppendingPathComponent:@"AnimationPath.plist"]

#pragma mark- 贴纸动画
#define KStickerAnimationFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/StickerAnimation"]
#define kStickerAnimationPath [KStickerAnimationFolder stringByAppendingPathComponent:@"StickerAnimationPath.plist"]

#define kTextToSpeechFolder [kVEDirectory stringByAppendingPathComponent:@"TextToSpeech"]

#define kAutoSegmentImageFolder [kVEDirectory stringByAppendingPathComponent:@"AutoSegmentImage"]


#define kVERecordSet @"VERecordSet"
#define kVEProportionIndex  @"VEProportionIndex"    //视频比例
#define kVEBgColorIndex  @"VEBgColorIndex"  //背景颜色
#define kVEVideoBgColorIndex  @"VEVideoBgColorIndex"  //背景颜色
#define kVEEnableVague  @"VEEnableVague"    //模糊背景
#define kVEAVCaptureDevicePosition @"VEAVCaptureDevicePosition"
#define VECustomErrorDomain @"com.VESDK.ErrorDomain"

#define kThumbnailFolder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnailFolder"]


