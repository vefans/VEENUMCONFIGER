//
//  VEUndoRedoObject.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team  on 2021/9/27.
//

#import <Foundation/Foundation.h>
#import <VEENUMCONFIGER/VEMediaInfo.h>

typedef NS_ENUM(NSInteger, VEUndoRedoEditType){
    VEUndoRedoEditType_Default = 0,
    VEUndoRedoEditType_Media_Split, //媒体分割
    VEUndoRedoEditType_Media_Transition,//转场
    VEUndoRedoEditType_Media_Speed,//变速
    VEUndoRedoEditType_Media_CurveSpeed,//曲线变速
    VEUndoRedoEditType_Media_Volume,//音量
    VEUndoRedoEditType_Media_Mute,//静音
    VEUndoRedoEditType_Media_VoiceFx,//变声
    VEUndoRedoEditType_Media_AddMedia, //添加媒体
    VEUndoRedoEditType_Media_Delete,//删除
    VEUndoRedoEditType_Media_Replace,//替换文件
    VEUndoRedoEditType_Media_AutoSegment,//智能抠像
    VEUndoRedoEditType_Media_Animation,//动画
    VEUndoRedoEditType_Media_Freeze,//定格
    VEUndoRedoEditType_Media_Rotate,//旋转
    VEUndoRedoEditType_Media_Mirror,//上下翻转/左右翻转
    VEUndoRedoEditType_Media_Crop,//裁切
    VEUndoRedoEditType_Media_ChangeOverlayOrMain,//切画中画/主轨
    VEUndoRedoEditType_Media_Keyframe,//关键帧
    VEUndoRedoEditType_Media_Filter,//滤镜
    VEUndoRedoEditType_Media_Toning,//调色
    VEUndoRedoEditType_Media_Mask,//蒙版
    VEUndoRedoEditType_Media_Cutout,//抠像
    VEUndoRedoEditType_Media_Transparency,//透明度
    VEUndoRedoEditType_Media_Denoise,//降噪
    VEUndoRedoEditType_Media_Beauty,//美颜
    VEUndoRedoEditType_Media_Reverse,//倒放
    VEUndoRedoEditType_Media_Copy,//复制
    VEUndoRedoEditType_Media_Trim,//截取
    VEUndoRedoEditType_Media_Sort,//排序
    VEUndoRedoEditType_Media_Background,//背景
    VEUndoRedoEditType_Media_AboutMirror,//左右翻转
    VEUndoRedoEditType_Media_UpDownMirror,//上下翻转
    VEUndoRedoEditType_Media_adjustPoint,     // 位置调整
    
    VEUndoRedoEditType_MusicAdd,//音乐添加
    VEUndoRedoEditType_SoundEffectsAdd,//音效添加
    VEUndoRedoEditType_ExtractMusicAdd,//提取音乐
    VEUndoRedoEditType_DubbingAdd,//配音添加
    VEUndoRedoEditType_Audio_Volume,//音频音量
    VEUndoRedoEditType_Audio_Split,//音频分割
    VEUndoRedoEditType_Audio_VoiceFx,//音频变声
    VEUndoRedoEditType_Audio_Delete,//音频删除
    VEUndoRedoEditType_Audio_Speed,//音频变速
    VEUndoRedoEditType_Audio_CurveSpeed,//音频曲线变速
    VEUndoRedoEditType_Audio_Copy,//音频复制
    
    VEUndoRedoEditType_Subtitle_Add,//字幕添加
    VEUndoRedoEditType_Subtitle_Split,//字幕分割
    VEUndoRedoEditType_Subtitle_Copy,//字幕复制
    VEUndoRedoEditType_Subtitle_Edit,//字幕编辑
    VEUndoRedoEditType_Subtitle_Delete,//字幕删除
    VEUndoRedoEditType_Subtitle_Keyframe,//字幕关键帧
    VEUndoRedoEditType_Subtitle_Move,//字幕移动
    
    VEUndoRedoEditType_TextTemplate_Add,//文字模板添加
    VEUndoRedoEditType_TextTemplate_Split,//文字模板分割
    VEUndoRedoEditType_TextTemplate_Copy,//文字模板复制
    VEUndoRedoEditType_TextTemplate_Edit,//文字模板编辑
    VEUndoRedoEditType_TextTemplate_Delete,//文字模板删除
    VEUndoRedoEditType_TextTemplate_Keyframe,//文字模板关键帧
    
    VEUndoRedoEditType_Stick_Add,//贴纸添加
    VEUndoRedoEditType_Stick_Split,//贴纸分割
    VEUndoRedoEditType_Stick_Copy,//贴纸复制
    VEUndoRedoEditType_Stick_Animation,//贴纸动画
    VEUndoRedoEditType_Stick_Mirror,//贴纸镜像
    VEUndoRedoEditType_Stick_Delete,//贴纸删除
    VEUndoRedoEditType_Stick_Keyframe,//贴纸关键帧
    VEUndoRedoEditType_Stick_Move,//贴纸移动
    
    VEUndoRedoEditType_Overlay_Add,//画中画添加
    VEUndoRedoEditType_Overlay_Split,//分割
    VEUndoRedoEditType_Overlay_Speed,//变速
    VEUndoRedoEditType_Overlay_CurveSpeed,//曲线变速
    VEUndoRedoEditType_Overlay_Volume,//音量
    VEUndoRedoEditType_Overlay_VoiceFx,//变声
    VEUndoRedoEditType_Overlay_Mixed,//混合模式
    VEUndoRedoEditType_Overlay_Delete,//删除
    VEUndoRedoEditType_Overlay_AutoSegment,//智能抠像
    VEUndoRedoEditType_Overlay_Replace,//替换
    VEUndoRedoEditType_Overlay_Animation,//动画
    VEUndoRedoEditType_Overlay_Level,//层级
    VEUndoRedoEditType_Overlay_ChangeOverlayOrMain,//切画中画/主轨
    VEUndoRedoEditType_Overlay_Rotate,//旋转
    VEUndoRedoEditType_Overlay_Mirror,//左右翻转
    VEUndoRedoEditType_Overlay_FlipUpAndDown,//上下翻转
    VEUndoRedoEditType_Overlay_Crop,//裁切
    VEUndoRedoEditType_Overlay_Keyframe,//关键帧
    VEUndoRedoEditType_Overlay_Mask,//蒙版
    VEUndoRedoEditType_Overlay_Cutout,//抠图
    VEUndoRedoEditType_Overlay_Filter,//滤镜
    VEUndoRedoEditType_Overlay_Adjust,//调色
    VEUndoRedoEditType_Overlay_Transparency,//透明度
    VEUndoRedoEditType_Overlay_Denoise,//降噪
    VEUndoRedoEditType_Overlay_Beauty,//美颜
    VEUndoRedoEditType_Overlay_Copy,//复制
    VEUndoRedoEditType_Overlay_Freeze,//定格
    VEUndoRedoEditType_Overlay_Trim,//截取
    VEUndoRedoEditType_Overlay_Background,//背景
    VEUndoRedoEditType_Overlay_adjustPoint,//调整
    
    VEUndoRedoEditType_Doodle_Add,//涂鸦添加
    VEUndoRedoEditType_Doodle_Copy,//复制
    VEUndoRedoEditType_Doodle_Delete,//删除
    VEUndoRedoEditType_Doodle_Trim,//截取
    
    VEUndoRedoEditType_Watermark_Add,//水印
    VEUndoRedoEditType_Watermark_Replace,//替换
    VEUndoRedoEditType_Watermark_Edit,//编辑
    VEUndoRedoEditType_Watermark_Delete,//删除
    
    VEUndoRedoEditType_Dewatermark_Add,//去水印添加
    VEUndoRedoEditType_Dewatermark_Copy,//复制
    VEUndoRedoEditType_Dewatermark_Edit,//编辑
    VEUndoRedoEditType_Dewatermark_Delete,//删除
    
    VEUndoRedoEditType_Effect_Add,//特效添加
    VEUndoRedoEditType_Effect_Edit,//编辑
    VEUndoRedoEditType_Effect_Delete,//删除
    VEUndoRedoEditType_Effect_Role,//作用对象
    VEUndoRedoEditType_Effect_Copy,//复制
    VEUndoRedoEditType_Effect_Trim,//截取
    VEUndoRedoEditType_Effect_Replace,//替换
    
    VEUndoRedoEditType_Filter_Add,//滤镜添加
    VEUndoRedoEditType_Filter_Edit,//编辑
    VEUndoRedoEditType_Filter_Delete,//删除
    VEUndoRedoEditType_Filter_Trim,//截取
    
    VEUndoRedoEditType_Adjust_Add,//调色添加
    VEUndoRedoEditType_Adjust_Edit,//编辑
    VEUndoRedoEditType_Adjust_Delete,//删除
    VEUndoRedoEditType_Adjust_Trim,//截取
    
    VEUndoRedoEditType_Proportion,//比例调整
    VEUndoRedoEditType_Canvas,//画布
    VEUndoRedoEditType_Cover,//封面
    
    VEUndoRedoEditType_Ton_Add,//调色添加
    
    VEUndoRedoEditType_BOX_Add,//边框添加
    VEUndoRedoEditType_BOX_Move,//边框背景移动
    
    VEUndoRedoEditType_Superposi_Add,//叠加添加
    VEUndoRedoEditType_Superposi_Copy,//叠加复制
    VEUndoRedoEditType_Superposi_Move,//叠加移动
    VEUndoRedoEditType_Superposi_Delete,//叠加删除
    
    VEUndoRedoEditType_ErasePen_Add, // 添加消除笔
    VEUndoRedoEditType_Cutout_Add,   //添加抠图
    VEUndoRedoEditType_MergeLayers,     //图层合并
    
    VEUndoRedoEditType_BackgroundReplace, // 背景替换
    
    VEUndoRedoEditType_Mask,//蒙版
    
    VEUndoRedoEditType_Hair,//头发
    
    VEUndoRedoEditType_DoodlePen_Add,//涂鸦笔添加
    VEUndoRedoEditType_DoodlePen_Adds,//涂鸦笔添加
    VEUndoRedoEditType_DoodlePen_Copy,//复制
    VEUndoRedoEditType_DoodlePen_Delete,//删除
    VEUndoRedoEditType_DoodlePen_Trim,//截取
};


@interface VEUndoRedoObject : NSObject
@property (nonatomic, assign) VEAdvanceEditType editType;
@property (nonatomic, assign) VEUndoRedoEditType type;
@property (nonatomic, weak)   UIView   *currentPasterTextView;
@property (nonatomic, strong) NSMutableArray    *orArray;
@property (nonatomic, strong) NSMutableArray    *dstArray;
//字幕
@property (nonatomic, assign)NSInteger  orSubtitleIndex;
@property (nonatomic, strong) NSString *dstSubtitleIdentifier;
//贴纸
@property (nonatomic, assign)NSInteger  orStickerIndex;
//滤镜 特效 边框
@property (nonatomic, assign) float orLookUpFilterIntensity;
@property (nonatomic, assign) float dstLookUpFilterIntensity;
//图层 画笔(涂鸦) 字幕
@property (nonatomic, strong) NSObject *orOverlay;
@property (nonatomic, strong) NSObject *dstOverlay;
@property (nonatomic, strong) NSObject *dstBackgroundOverlay;

@property (nonatomic, strong) CaptionEx *orSubtitle;
@property (nonatomic, strong) CaptionEx *dstSubtitle;

@property (nonatomic, strong) CustomFilter *orFilter;
@property (nonatomic, strong) CustomFilter *dstFilter;

@property (nonatomic, strong)CaptionEx    *orSticker;
@property (nonatomic, strong)CaptionEx    *dstSticker;
//调色
@property (nonatomic, strong) ToningInfo   *orToningInfo;
@property (nonatomic, strong) ToningInfo   *dstToningInfo;

@property (nonatomic, strong) NSURL  * orUrl;
@property (nonatomic, strong) NSURL  * dstUrl;

@property (nonatomic, assign) CGRect   dstCropAssetRect;
@property (nonatomic, assign) CGRect   orCropAssetRect;

@property (nonatomic, assign) CGRect   dstRectInImageAssetRect;
@property (nonatomic, assign) CGRect   orRectInImageAssetRect;
@property (nonatomic, assign) float         dstAssetAngle;
@property (nonatomic, assign) float         orAssetAngle;

//涂鸦笔
@property (nonatomic, strong) NSObject *orDoodlePen;
@property (nonatomic, strong) NSObject *dstDoodlePen;

@property (nonatomic, strong) NSMutableArray *orDoodlePens;
@property (nonatomic, strong) NSMutableArray *dstDoodlePens;

@property (nonatomic, strong) NSString  *tempJsonPath;
@property (nonatomic, strong) NSString  *oldTempJsonPath;

@property (nonatomic,strong) NSMutableDictionary *tempDic;
@property (nonatomic,strong) NSMutableDictionary *oldTempDic;

@property (nonatomic, assign) NSIndexPath * tempSelectIndexpath;
@property (nonatomic, assign) NSIndexPath * oldTempSelectIndexpath;

@end
