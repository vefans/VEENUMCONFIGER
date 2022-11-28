//
//  MediaInfo.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/11/3.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VEENUMCONFIGER/VECustomTextPhotoFile.h>
#import <LibVECore/LibVECore.h>

typedef NS_ENUM(NSInteger ,MediaType) {
    kFILEVIDEO,
    kFILEIMAGE,
    kFILETEXT
};

typedef NS_ENUM(NSInteger,TimeFilterType)
{
    kTimeFilterTyp_None             = 0, //无
    kTimeFilterTyp_Slow             = 1, //慢动作
    kTimeFilterTyp_Repeat           = 2, //反复
    kTimeFilterTyp_Reverse          = 3, //倒序
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
    VEMaskType_TEXT             =8, //文字
    VEMaskType_SHAPE            =9, //形状
    
    VEMaskType_InterMIRRORSURFACE = 1017474, //镜面
    VEMaskType_InterQUADRILATERAL = 1017479, //四边形
    VEMaskType_InterLOVE = 1017478, //爱心
    VEMaskType_InterPENTACLE = 1017477, //五角星
    VEMaskType_InterRECTANGLE = 1017476, //矩形
    VEMaskType_InterROUNDNESS = 1017475, //圆形
    VEMaskType_InterLINNEAR = 1017473, //线性
};

typedef NS_ENUM(NSInteger,CanvasType){
    KCanvasType_None                = 0, //无
    KCanvasType_Color               = 1, //场景背景颜色
    KCanvasType_Style               = 2, //场景图片样式
    KCanvasType_Blurry              = 3, //场景模糊
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

@interface VEMediaInfo : NSObject<NSCopying, NSMutableCopying>

@property (nonatomic, assign)BOOL       isFixedSize;
@property (nonatomic, assign)BOOL       isFixedAngle;

@property (nonatomic, strong) NSString *sceneIdentifier;

@property (nonatomic, assign) int groupId;

/** 标识符
 */
@property (nonatomic,copy  ) NSString *localIdentifier;

/**视频（或图片）地址
 */
@property (nonatomic,copy  ) NSURL *contentURL;
@property (nonatomic,copy  ) NSURL *draftContentURL;

/**文件类型
 */
@property (nonatomic, assign) MediaType fileType;

/** 图片是否是Gif
 */
@property (nonatomic, assign) BOOL isGif;

/**GifData
 */
@property (nonatomic, copy  ) NSData *gifData;

/**图片显示时长
 */
@property (nonatomic, assign) CMTime imageDurationTime;

/**文字板显示时长
 */
@property (nonatomic, assign) CMTimeRange imageTimeRange;

/**文字板在视频中的显示时间段
 */
@property (nonatomic, assign) CMTimeRange imageInVideoTimeRange;

/**视频总时长
 */
@property (nonatomic, assign) CMTime videoDurationTime;

/**视频时间范围
 */
@property (nonatomic, assign) CMTimeRange videoTimeRange;

/**视频截取时间范围
 */
@property (nonatomic, assign) CMTimeRange videoTrimTimeRange;

/**是否倒序
 */
@property (nonatomic, assign) BOOL isReverse;

/**视频倒序的音频类型
*/
@property (nonatomic, assign) ReverseAudioType reverseAudioType;

/**视频倒序地址
 */
@property (nonatomic,copy  ) NSURL *reverseVideoURL;

/**倒序视频总时长
 */
@property (nonatomic, assign) CMTime reverseDurationTime;

/**倒序视频时间范围
 */
@property (nonatomic, assign) CMTimeRange reverseVideoTimeRange;

/**倒序视频截取时间范围
 */
@property (nonatomic, assign) CMTimeRange reverseVideoTrimTimeRange;

/**播放速度
 */
@property (nonatomic, assign) double speed;

/**  是否音调校正，设置曲线变速后无效，Default is NO。
 *   Tone correction, invalid after setting curve speed change.
 */
@property (nonatomic,assign) BOOL speedHoldPitch;

/**当前选中的播放速度下标
 */
@property(nonatomic,assign)NSInteger speedIndex;

/**曲线变速
 */
@property (nonatomic, strong) NSMutableArray<CurvedSpeedPoint *> *curvedSpeedPointArray;

/**当前选中的曲线变速
 */
@property (nonatomic, assign) NSInteger curveSpeedIndex;

/**视频音量
 */
@property (nonatomic, assign) double videoVolume;
@property(nonatomic, assign)float           yuanValue;          //音量

/**  去噪级别(0~4)  默认为0.0(不去噪)
 */
@property (nonatomic, assign) int denoiseLevel;

/** 视频音量淡入时长，默认为0秒
 */
@property (nonatomic, assign) float audioFadeInDuration;

/** 视频音量淡出时长，默认为0秒
 */
@property (nonatomic, assign) float audioFadeOutDuration;

/** 音调
*/
@property (nonatomic, assign) float pitch;

/** 变声
*/
@property (nonatomic, assign) NSInteger voiceFXIndex;

/**视频(或图片)裁剪范围
 */
@property (nonatomic, assign) CGRect crop;

/**视频(或图片)旋转角度
 */
@property (nonatomic, assign) double rotate;

/**是否上下镜像
 */
@property (nonatomic, assign) BOOL isVerticalMirror;

/**是否左右镜像
 */
@property (nonatomic, assign) BOOL isHorizontalMirror;

/**素材在整个视频中的显示位置
 */
@property (nonatomic, assign) CGRect rectInScene;

/**素材在整个视频中的显示位置的中心坐标 （启用动画时 才会使用）
 */
@property (nonatomic, assign) float rectInScale;

/**素材在预览中显示的百分比
 */
@property (nonatomic, assign) CGRect rectInFile;

/** 场景透明度(0.0〜1.0),默认为1.0
*/
@property (nonatomic, assign) float backgroundAlpha;

@property(assign, nonatomic)BOOL    isMediaHide;

/** 调色
 */
@property (nonatomic, strong) ToningInfo *adjustments;


/**滤镜资源分类ID
 */
@property (nonatomic, strong) NSString *filterNetworkCategoryId;

/**滤镜资源ID
 */
@property (nonatomic, strong) NSString *filterNetworkResourceId;

/**滤镜资源地址
 */
@property (nonatomic, strong) NSString *filterPath;

/**滤镜
 */
@property (nonatomic, assign) NSInteger filterIndex;

/**滤镜强度，kFilterType_LookUp时有效,默认为1.0
 */
@property (nonatomic, assign) float filterIntensity;

/** 滤镜类型,默认kFilterType_LookUp
 */
@property (nonatomic , assign) FilterType filterType;

/**滤镜条纹启用，kFilterType_Mosaic时有效,默认为YES
 */
@property (nonatomic, assign)BOOL isStrip;

/** 自定义滤镜特效
 */
@property (nonatomic, assign) NSInteger customFilterIndex;
@property (nonatomic, assign) int customFilterId;

/** 自定义时间特效
 */
@property (nonatomic, assign) TimeFilterType fileTimeFilterType;

/** 自定义时间特效 时间段
 */
@property (nonatomic, assign) CMTimeRange fileTimeFilterTimeRange;

/** 蒙版名字
*/
@property (nonatomic, strong) NSString *maskName;

@property (nonatomic, strong) MaskObject *mask;

//@property (nonatomic, strong) NSArray * pointsArray;

@property (nonatomic, assign) VEMaskType maskType;

/**Set mask edge color
*/
@property (nonatomic, assign) NSInteger maskThickColorIndex;

/**封面在视频中的时间
 */
@property (nonatomic, assign) CMTime coverTime;

/** 视频实际时长，去掉片头和片尾的黑帧
@abstract  Tthe actual duration of the video, remove the black frame from the beginning and end of the video.
*/
@property (nonatomic, assign) CMTimeRange videoActualTimeRange;

/** 是否智能抠图
 */
@property (nonatomic, assign) kAutoSegmentType autoSegmentType;

/** fileType为kFILEIMAGE，且不是GIF的智能抠图地址
 */
@property (nonatomic, strong) NSURL *autoSegmentImageUrl;

/** 混合模式
*/
@property (nonatomic, assign) FilterBlendType blendType;

/** 抠图要透过的颜色，须与视频或者图片中一致，VEFilterBlendType 需要设置为 VEFilterBlendTypeChromaColor 否则无效
*/
@property (nonatomic, strong) UIColor *chromaColor;

/**抠图透明度低阀值，0.0~1.0,默认为0.1
 */
@property (nonatomic, assign) float cutoutAlphaLower;

/**抠图透明度高阀值，0.0~2.0,默认为0.5
 */
@property (nonatomic, assign) float cutoutAlphaUpper;

/**抠图边缘修整
 *  cutoutEdgeSize > 0时，cutoutAlphaUpper无效
 *  cutoutEdgeSize == 0时，cutoutAlphaUpper生效
 */
@property (nonatomic, assign) float cutoutEdgeSize;

/**特效
 */
@property (nonatomic, assign) int filterId;
@property (nonatomic, assign) CMTimeRange fxEffectTimeRange;
@property(nonatomic,strong)CustomMultipleFilter *fxEffect;
@property (nonatomic, assign) int fxFileId;

/**视频 GIF 文件 缩略图保存路径 (  用于需要视频缩略图展示时加载  )
*/
@property (nonatomic, copy) NSString *filtImagePatch;

/**美颜磨皮，0.0~1.0,默认为0.0
 */
@property (nonatomic, assign) float beautyBlurIntensity;

/**美颜亮肤，0.0~1.0,默认为0.0
 */
@property (nonatomic, assign) float beautyBrightIntensity;

/**美颜红润，0.0~1.0,默认为0.0
 */
@property (nonatomic, assign) float beautyToneIntensity;

/**大眼，0.0~1.0,默认为0.0
 */
@property (nonatomic, assign) float beautyBigEyeIntensity;

/**瘦脸，0.0~1.0,默认为0.0
 */
@property (nonatomic, assign) float beautyThinFaceIntensity;

/** 五官美颜
 */
@property (nonatomic, strong)  NSMutableArray<FaceAttribute*>* multipleFaceAttribute;

/** 场景变声
 */
@property (nonatomic, assign) NSInteger fileSoundEffect;

/** 场景媒体缩放倍数
 */
@property (nonatomic, assign) float fileScale;

/** 场景背景类型
 */
@property (nonatomic, assign) CanvasType backgroundType;

/** 场景背景 画布样式
 */
@property (nonatomic, assign) NSInteger backgroundStyle;

/**  场景背景媒体
*/
@property (nonatomic, strong) VEMediaInfo *backgroundFile;

/**  场景背景模糊
*/
@property (nonatomic, assign) float backgroundBlurIntensity;
/** 设置径向模糊效果
 *  设置媒体动画后，该属性无效，以动画中的blur为准
 */
@property (nonatomic, strong) Blur *blur;

/**  场景背景色
*/
@property (nonatomic, strong) UIColor *backgroundColor;

/**封面预览 图片
 */
@property (nonatomic, copy  ) NSURL *coverURL;

@property (nonatomic, assign  ) CGRect coverCrop;
/** 转场
 */
@property (nonatomic, strong) Transition *transition;

/**转场资源分类ID
 */
@property (nonatomic, strong) NSString *transitionNetworkCategoryId;

/**转场资源ID
 */
@property (nonatomic, strong) NSString *transitionNetworkResourceId;

/**转场分类名称
 */
@property (nonatomic, copy  ) NSString *transitionTypeName;

/**转场分类序号
 */
@property (nonatomic, assign) NSInteger transitionTypeIndex;

/**转场序号
 */
@property (nonatomic, assign) NSInteger transitionIndex;

/**转场名称
 */
@property (nonatomic, copy  ) NSString *transitionName;

/**转场时间
 */
@property (nonatomic, assign) double transitionDuration;

/**转场文件
 */
@property (nonatomic, copy  ) NSURL *transitionMask;

/**缩率图
 */
@property (nonatomic, strong) UIImage *thumbImage;

/**记录裁剪框显示区域
 */
@property (nonatomic, assign) CGRect cropRect;

/**记录裁切方式
 */
@property (nonatomic, assign) VECropType fileCropModeType;

/**文字板
 */
@property (nonatomic, strong) VECustomTextPhotoFile *customTextPhotoFile;

/**素材 是否进行自定义操作
 */
@property (nonatomic, assign) BOOL isMove;

/** 实现自定义时间特效生成的Scene数量
 */
@property (nonatomic, assign) int timeEffectSceneCount;

/**设置媒体自定义动画。
 */
@property (nonatomic, strong) CustomFilter* customAnimate;
/**3d动画
 */
@property (nonatomic, strong) Animation3D*  animation3D;

/**设置媒体自定义出场动画
 */
@property (nonatomic, strong) CustomFilter* customOutAnimate;

/**设置媒体其他动画（例如：手绘画笔）
 */
@property (nonatomic, strong) CustomFilter* customOtherAnimate;

/** 动画类型 入场，组合
*/
@property (nonatomic, assign) CustomAnimationType animationType;
/** 动画序号
*/
@property (nonatomic, assign) NSInteger animationIndex;

/** 动画时间段
*/
@property (nonatomic, assign) CMTimeRange animationTimeRange;

/** 动画类型 出场
*/
@property (nonatomic, assign) NSInteger animationOutType;

/** 动画序号 出场
*/
@property (nonatomic, assign) NSInteger animationOutIndex;
@property (nonatomic, assign) NSInteger animationPenIndex;
@property(nonatomic,assign)NSInteger    animationWritingModel;
/** 动画时间段 出场
*/
@property (nonatomic, assign) CMTimeRange animationOutTimeRange;

/** 动画名称
*/
@property(nonatomic,strong)NSString *animationName;
/** 动画时长
*/
@property(nonatomic,assign)float animationDuration;

/** 人像分割
*/
@property (nonatomic, assign) BOOL isSelfieSegmentation;

/**是否是系统拍摄的慢动作视频
 */
@property (nonatomic, assign) BOOL isSlomoVideo;

/**关键帧
 */
@property (nonatomic, strong) NSArray<MediaAssetAnimatePosition*>*  animate;

/** 是否通过导入文件生成的animate，Default is NO.
 *  Whether to generate animation by importing files
 */
@property (nonatomic, assign) BOOL importMorph;

/**在video中四个顶点的坐标，可设置非矩形。
 * (0, 0)为左上角 (1, 1)为右下角
 * rectInVideo与pointsInVideoArray只有一个有效，以最后设置的为准
 * 设置媒体动画后，该属性及rectInVideo属性均无效，以动画中的rect或pointsArray值为准
 */
@property (nonatomic, strong) NSMutableArray *pointsInVideoArray;
@property(nonatomic, assign)BOOL    isPasterAssetViewDrag;

@property (nonatomic, strong) NSMutableArray *keyFrameTimeArray;

@property (nonatomic, strong) NSMutableArray *keyFrameRectRotateArray;

- (instancetype)initWithMediaAsset:(MediaAsset *)asset;

- (MediaAsset *)getMedia;

- (void)remove;

/**智能抠像
 */
@property (nonatomic, strong)UIImage *autoSegmentImage;

/** 均衡器数值数组
 */
@property (nonatomic, strong) NSMutableArray <EqObject*>* eq;
@property (nonatomic, assign) NSInteger     eqType;

/** 音频分离 true为分离
 */
@property(nonatomic, assign)BOOL    audioSeparate;

@property (nonatomic, strong) NSURL *antiShakeUrl;
@property (nonatomic, assign) AntiShakeType   antiShakeType;

/** 全景图
 */
@property (nonatomic, strong) Panorama* panorama;

/** 是否为主题中的音乐的标识符
 */
@property (nonatomic,assign) BOOL isTemplateTheme;
@end
