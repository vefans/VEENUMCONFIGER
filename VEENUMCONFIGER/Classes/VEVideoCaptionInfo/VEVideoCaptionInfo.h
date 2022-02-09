//
//  VEVideoCaptionInfo.h
//  Pods
//
//  Created by mac on 2021/6/28.
//

#import <Foundation/Foundation.h>
#import <VEENUMCONFIGER/VEFXFilter.h>

NS_ASSUME_NONNULL_BEGIN

//对齐方式
/**
 UIRectCornerTopLeft     = 1 << 0,
 UIRectCornerTopRight    = 1 << 1,
 UIRectCornerBottomLeft  = 1 << 2,
 UIRectCornerBottomRight = 1 << 3,
 */
typedef NS_ENUM(NSInteger, VESubtitleAlignment) {
    VESubtitleAlignmentUnknown = 0,
    VESubtitleAlignmentTopLeft,         //左上
    VESubtitleAlignmentTopCenter,       //上居中
    VESubtitleAlignmentTopRight,        //右上
    VESubtitleAlignmentLeftCenter,      //左居中
    VESubtitleAlignmentCenter,          //水平垂直居中
    VESubtitleAlignmentRightCenter,     //右居中
    VESubtitleAlignmentBottomLeft,      //左下
    VESubtitleAlignmentBottomCenter,    //下居中
    VESubtitleAlignmentBottomRight,     //右下
};
//轻移方向
typedef NS_ENUM(NSInteger, VEMoveSlightlyDirection) {
    VEMoveSlightlyLeft = 0,
    VEMoveSlightlyTop,
    VEMoveSlightlyBottom,
    VEMoveSlightlyRight,
};

@interface VEVideoCaptionInfo : NSObject
//关键帧
@property (nonatomic, strong) NSMutableArray               *keyFrameTimeArray;

@property (nonatomic, strong) NSMutableArray                *keyFrameRectRotateArray;

@property(assign,nonatomic)CMTimeRange  timeRange;
@property(assign,nonatomic)BOOL         isAICaption; //是否为AI识别
@property(assign,nonatomic)NSInteger    dubbingIndex;//转配音对应的配音下标
@property(assign,nonatomic)BOOL       isSubtitle;
@property(strong,nonatomic)Caption    *caption;//字幕、贴纸

@property(assign,nonatomic)NSInteger    speechKindIndex;//转配音 发音人编号

@property(strong,nonatomic)NSString *mediaIdentifier;
/**特效
 */
@property(assign,nonatomic)int                      filterId;
@property(nonatomic,assign)CMTimeRange              fxEffectTimeRange;
@property(nonatomic,strong)CustomFilter        *fxEffect;

/**文件类型
 */
@property(nonatomic,assign)MediaType        fileType;

@property(nonatomic,assign)CMTimeRange  stickerAnimationOutTimeRange;
////贴纸 动画
@property(nonatomic,assign)CMTimeRange  stickerAnimationTimeRange;
/** 动画循环周期
*/
@property(nonatomic,assign)float        stickerCycleDuration;

@property(strong,nonatomic)MediaAssetBlur  *blur;//高斯模糊
@property(strong,nonatomic)Mosaic     *mosaic;//马赛克
@property(strong,nonatomic)Dewatermark *dewatermark;//去水印

@property(assign,nonatomic)float        rotate;     //旋转
@property(assign,nonatomic)CGRect       cropRect;
@property(assign,nonatomic)NSInteger fileCropModeType;

@property(assign, nonatomic) NSInteger     filterIndex;
@property(nonatomic,strong)CustomMultipleFilter * filters; //滤镜

@property(nonatomic,strong)ToningInfo * tonInfo;//调色
@property(nonatomic,strong)NSString   *tonName;

@property(strong,nonatomic)Overlay  *doodle;//涂鸦

@property(assign,nonatomic)BOOL        isNoDraggable;   //是否拖动
@property(strong,nonatomic) NSString * fxName;
@property(strong,nonatomic)VEFXFilter * customFilter; //特效
@property(assign,nonatomic)NSInteger   fxFileId;

@property(assign,nonatomic)BOOL   isFxFile; //该特效 是否用于主视频
@property(assign,nonatomic)NSInteger   fxCollageIndex;  //画中画ID (特效作用的画中画ID)

@property(assign,nonatomic)NSInteger    customFilterId;
@property (nonatomic, assign) int fxId;
@property(strong,nonatomic)NSString *currentFrameTexturePath;
@property (nonatomic, assign) bool  isErase;


@property(strong,nonatomic)MusicInfo      *music; //配乐

@property(assign,nonatomic)NSInteger    captiontypeIndex;
@property(assign,nonatomic)NSInteger    fancyWrodsIndex;//花字
@property(copy,nonatomic)NSString       *captionColorImagePath;
@property(copy,nonatomic)NSString     *captionText;
@property(copy,nonatomic)NSAttributedString *attributedString;
@property(assign,nonatomic)CGSize       collageSize;
@property(assign,nonatomic)CGAffineTransform captionTransform;
@property(assign,nonatomic)CGPoint      centerPoint;
@property(assign,nonatomic)float        scale;
@property(assign,nonatomic)NSInteger    captionId;
@property(strong,nonatomic)UIColor      *tColor;
@property(strong,nonatomic)UIColor      *strokeColor;
@property(strong,nonatomic)UIColor      *shadowColor;
@property(strong,nonatomic)UIColor      *bgColor;
@property(copy,nonatomic)NSString       *fontName;
@property(copy,nonatomic)NSString       *fontPath;
@property(assign,nonatomic)float         tFontSize;
@property(copy,nonatomic)NSString       *title;
@property(assign,nonatomic)BOOL          deleted;
@property(assign,nonatomic)CGSize        frameSize;
@property(assign,nonatomic)CGRect        home;
@property(strong,nonatomic)UIImage      *thumbnailImage;
@property(assign,nonatomic)CGSize        pSize;
@property(assign,nonatomic)CGSize        cSize;
@property(copy,nonatomic)NSString       *netCover;
@property(assign,nonatomic)float        rectW;//配置文件中，初始字幕大小，相对于实际视频size的字幕大小(0.0〜1.0)
@property (nonatomic,assign) NSInteger     selectTypeId;
@property (nonatomic,assign) NSInteger     selectColorItemIndex;
@property (nonatomic,assign) NSInteger     selectBorderColorItemIndex;
@property (nonatomic,assign) NSInteger     selectShadowColorIndex;
@property (nonatomic,assign) NSInteger     selectBgColorIndex;
@property (nonatomic,assign) NSInteger     inAnimationIndex;
@property (nonatomic,assign) NSInteger     outAnimationIndex;
@property (nonatomic,assign) NSInteger     selectFontItemIndex;
@property (nonatomic, strong) NSString     *tfontCode;
@property (nonatomic,assign) VESubtitleAlignment alignment;

@property(strong,nonatomic)NSString   *collagethumbnailImagePath;

@property(copy,nonatomic)NSString       *maskName;
@property (nonatomic,assign) BOOL   isIntelligentKey; //是否智能抠图
@property (nonatomic,assign) float  videoVolume;
@property(strong,nonatomic)Overlay  *collage;//画中画
@property(nonatomic, assign)NSInteger   collageID;
@property(nonatomic,assign)NSInteger    curveSpeedIndex;
@property(assign,nonatomic)NSInteger   collageMaskType;
@property(assign,nonatomic)NSInteger    collageMaskColorIndex;
@property(nonatomic,assign)float          fileScale;

//画中画 滤镜
@property(nonatomic,assign)NSInteger     collageFilterIndex;

//画中画 动画 入场 组合
/** 动画类型
*/
@property(nonatomic,assign)NSInteger    animationType;
/** 动画序号
*/
@property(nonatomic,assign)NSInteger    animationIndex;
/** 动画时间段
*/
@property(nonatomic,assign)CMTimeRange  animationTimeRange;

//画中画 动画 出场
/** 动画类型
*/
@property(nonatomic,assign)NSInteger    animationOutType;
/** 动画序号
*/
@property(nonatomic,assign)NSInteger    animationOutIndex;
/** 动画时间段
*/
@property(nonatomic,assign)CMTimeRange  animationOutTimeRange;


/******************************以下参数已废弃******************************/
/** 动画名称
*/
@property(nonatomic,strong)NSString *animationName;
/** 动画时长
*/
@property(nonatomic,assign)float animationDuration;
/**素材在整个视频中的显示位置的中心坐标 （启用动画时 才会使用）
 */
@property(nonatomic,assign)float          rectInScale;

@end

NS_ASSUME_NONNULL_END
