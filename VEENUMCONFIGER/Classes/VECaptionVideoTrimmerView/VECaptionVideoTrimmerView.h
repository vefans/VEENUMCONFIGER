//
//  ICGVideoTrimmerView.h
//  VEDeluxeDemo
//
//  Created by iOS VESDK Team on 1/18/15.
//  Copyright (c) 2015 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <LibVECore/LibVECore.h>
#import "VETTRangeSlider.h"
#import "VECaptionRangeView.h"

typedef enum {
    kVECannotAddCaptionforPiantou,
    kVECannotAddCaptionforPianwei,
    kVECanAddCaption,
} VERdCanAddCaptionType;


@protocol VECaptionVideoTrimmerDelegate;

@interface VECaptionVideoTrimmerView : UIView

@property (nonatomic, assign) BOOL      isAddedMaterial;

@property (nonatomic, strong) NSTimer   *scroll_time;//自动滚动 定时调用
@property (nonatomic, assign) float     distancePer;    //距离百分比
@property (nonatomic, assign) float     location_width;
@property (nonatomic, assign) BOOL      isScrollAdd;
@property (nonatomic, assign) float     scrollMin;
@property (nonatomic, assign) float     scrollMax;
@property (assign, nonatomic) BOOL      scrollIsRight;                   //是否右微调

@property (nonatomic, assign) float     scrollRange;    //自动滚动 范围
@property (nonatomic, strong) UITouch   *scrollTouch;

@property (nonatomic, assign) BOOL      isMove;         //是否拖拽
/**
    不能长按拖动，默认为NO
 */
@property (nonatomic, assign) BOOL isDragDisable;

//画中画
//@property (nonatomic,assign) bool isCollage;   //是否为画中画

@property (nonatomic,assign) bool isTiming;   //是否计时

@property (nonatomic,assign) bool isJumpTail;   //保存时是否需要跳转到尾部  


@property (nonatomic,assign) double changeScaleValue;

@property (nonatomic,assign) NSInteger thumbTimes;

@property(strong , nonatomic) VECore *videoCore;


@property (strong, nonatomic) UIColor *themeColor;

@property (assign, nonatomic) CGFloat maxLength;

@property (assign, nonatomic) CGFloat minLength;

@property (strong, nonatomic) UIImage *leftThumbImage;

@property (strong, nonatomic) UIImage *rightThumbImage;

@property (strong, nonatomic) UIImageView *contentView;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *frameView;

@property (strong, nonatomic) UIImageView *videoRangeView;

@property (assign, nonatomic) CGSize contentSize;

@property (assign, nonatomic) CGFloat borderWidth;

@property (weak, nonatomic) id<VECaptionVideoTrimmerDelegate> delegate;

@property (assign, nonatomic) BOOL  loadImageFinish;

@property (assign, nonatomic) CMTimeRange  clipTimeRange;

@property (assign, nonatomic) BOOL       isRangeSlider_Drag;        //正在左右微调
@property (assign, nonatomic) BOOL       isRight;                   //是否右微调
@property (assign, nonatomic) CMTimeRange      RangeSliderTimeRange;

@property (strong, nonatomic) VETTRangeSlider *rangeSlider;
@property (strong, nonatomic) UILabel         *rangeTimeLabel;

@property (strong, nonatomic) VECaptionRangeView *currentCaptionView;
@property (strong, nonatomic) Caption *lastCaption;
@property (assign, nonatomic) BOOL isTouchAddMeatir;
@property (strong, nonatomic) VECaptionRangeView *timeEffectCapation;

@property (copy, nonatomic) NSString *fontName;
@property (nonatomic, assign) float progress;
@property (nonatomic) CGFloat startTime;
@property (assign, nonatomic) float  piantouDuration;

@property (assign, nonatomic) float  pianweiDuration;

@property (assign, nonatomic) float rightSpace;//右边间距

- (instancetype)initWithFrame:(CGRect)frame videoCore:(VECore *)videoCore;

- (void)resetSubviews:(UIImage *)thumbImage;

- (void)refreshThumbImage:(NSInteger)index thumbImage:(UIImage *)thumbImage;

- (void)animateWithDurationShowCurrentCaptionView;
- (VERdCanAddCaptionType)checkCanAddCaption;
- (VECaptionRangeView *)copyLastCapation;
- (VECaptionRangeView *)addCapation:(NSString *)themeName type:(NSInteger )type captionDuration:(double)captionDuration;

- (BOOL)changecurrentCaptionViewTimeRange;

- (BOOL)changecurrentCaptionViewTimeRange:(Float64)captionDuration;

- (NSMutableArray *)getTimesFor_videoRangeView;

@property (nonatomic, assign) bool isFX;        //是否为特效进度条
- (NSMutableArray *)getTimesFor_videoRangeView_withTime;

- (bool)setProgress:(float)progress animated:(BOOL)animated;
- (void)setFrameRect:(CGRect)rect;

- (void)useToAllWithTypeToAll:(BOOL)typeToAll animationToAll:(BOOL)animationToAll colorToAll:(BOOL)colorToAll borderToAll:(BOOL)borderToAll fontToAll:(BOOL)fontToAll sizeToAll:(BOOL)sizeToAll positionToAll:(BOOL)positionToAll scale:(float)scale captionView:(VECaptionRangeView *)captionRangeView;

- (void)checkAllCaptionSize;

//多段配乐
- (void)changeMulti_trackCurrentRangeviewFile:(MusicInfo *)music
                             captionView:(VECaptionRangeView *)captionRangeView;

//高斯模糊/马赛克/去水印
- (void)changeDewatermark:(id)dewatermark
                typeIndex:(VEDewatermarkType)type;

//画中画
- (void)changeCollageCurrentRangeviewFile:(Overlay *)collage
                               thumbImage:(UIImage *)thumbImage
                              captionView:(VECaptionRangeView *)captionRangeView;
//涂鸦
- (void)changeDoodleCurrentRangeviewFile:(Overlay *)doodle
                              thumbImage:(UIImage *)thumbImage
                             captionView:(VECaptionRangeView *)captionRangeView;
//字幕

- (void) changeCurrentRangeviewFile:(Caption *)caption
                             tColor:(UIColor *)tColor
                         strokeColor:(UIColor *)strokeColor
                           fontName:(NSString *)fontName
                           fontCode:(NSString *)fontCode
                          typeIndex:(NSInteger)typeIndex
                          frameSize:(CGSize)frameSize
                        captionText:(NSString *)captionText
                           aligment:(CaptionTextAlignment)aligment
                 inAnimateTypeIndex:(NSInteger)inAnimateTypeIndex
                outAnimateTypeIndex:(NSInteger)outAnimateTypeIndex
                        pushInPoint:(CGPoint)pushInPoint
                       pushOutPoint:(CGPoint)pushOutPoint
                        captionView:(VECaptionRangeView *)captionRangeView;

- (void) changeCurrentRangeviewFile:(Caption *)caption
                          typeIndex:(NSInteger)typeIndex
                          frameSize:(CGSize)frameSize
                        captionText:(NSString *)captionText
                           aligment:(CaptionTextAlignment)aligment
                 captionAnimateType:(CaptionAnimationType)captionAnimateType
                 inAnimateTypeIndex:(NSInteger)inAnimateTypeIndex
                outAnimateTypeIndex:(NSInteger)outAnimateTypeIndex
                     pushInPoint:(CGPoint)pushInPoint
                       pushOutPoint:(CGPoint)pushOutPoint
                        captionView:(VECaptionRangeView *)captionRangeView;

- (void)changeSubtitleTye:(Caption *)caption
                typeIndex:(NSInteger)typeIndex
                frameSize:(CGSize)frameSize
              captionView:(VECaptionRangeView *)captionRangeView;

- (void)changeCurrentRangeviewWithAlpha:(float)alpha captionView:(VECaptionRangeView *)captionRangeView;
- (void) changeCurrentRangeviewWithTColor:(UIColor *)tColor alpha:(float)alpha colorId:(NSInteger)colorId captionView:(VECaptionRangeView *)captionRangeView;

- (void) changeCurrentRangeviewWithstrokeColor:(UIColor *)strokeColor borderWidth:(float )borderWidth alpha:(float)alpha borderColorId:(NSInteger)borderColorId captionView:(VECaptionRangeView *)captionRangeView;

- (void) changeCurrentRangeviewWithShadowColor:(UIColor *)color width:(float )width colorId:(NSInteger)colorId captionView:(VECaptionRangeView *)captionRangeView;

- (void) changeCurrentRangeviewWithBgColor:(UIColor *)color colorId:(NSInteger)colorId captionView:(VECaptionRangeView *)captionRangeView;

- (void) changeCurrentRangeviewWithIsBold:(BOOL)isBold isItalic:(BOOL )isItalic isShadow:(BOOL)isShadow shadowColor:(UIColor *)shadowColor shadowOffset:(CGSize)shadowOffset captionView:(VECaptionRangeView *)captionRangeView;

- (void) changeCurrentRangeviewWithFontName:(NSString *)fontName
                                   fontCode:(NSString *)fontCode
                                   fontPath:(NSString *)fontPath
                                     fontId:(NSInteger)fontId
                                captionView:(VECaptionRangeView *)captionRangeView;
- (void) changeCurrentRangeviewWithNetCover:(NSString *)netCover
                                captionView:(VECaptionRangeView *)captionRangeView;
- (void) changeCurrentRangeviewWithSubtitleAlignment:(VESubtitleAlignment)subtitleAlignment captionView:(VECaptionRangeView *)captionRangeView;

- (VECaptionRangeView *)getCaptioncurrentView:(BOOL)flag;

- (void)touchesUpInslide;

//- (void)refreshVideoRangeViewFromIndexPath:(NSInteger)fromIndex moveToIndex:(NSInteger)toIndex;

- (void)moveEditedSubviews:(NSArray *)editedArray restoreVideoRangeView:(NSArray *)originalSubviewsArray;

- (NSMutableArray *)getEditArrays:(BOOL)flag;

- (BOOL)deletedcurrentCaption;

- (NSMutableArray *)getCaptionsViewForcurrentTime:(BOOL)flag;//获取当前时间段可以编辑的特效段数组

//只适用于在同一时间有多个字幕的情况
- (VECaptionRangeView *)getcurrentCaption:(NSInteger)captionId;

- (VECaptionRangeView *)getcurrentCaptionFromId:(NSInteger)captionId;

//字幕
- (void)saveCurrentRangeview:(NSString *)captionText
                   typeIndex:(NSInteger) index
               rotationAngle:(float)rotationAngle
                   transform:(CGAffineTransform)captionTransform
                 centerPoint:(CGPoint)centerPoint
              ppcaptionFrame:(CGRect)ppcaptionFrame
              contentsCenter:(CGRect)contentsCenter
                      tFrame:(CGRect)tFrame
                  customSize:(float)captionLastScal
                 tStretching:(BOOL)tStretching
                    fontSize:(float)fontSize
                  strokeWidth:(float)strokeWidth
                    aligment:(CaptionTextAlignment)aligment
             inAnimationType:(CaptionAnimateType)inAnimationType
            outAnimationType:(CaptionAnimateType)outAnimationType
                 pushInPoint:(CGPoint)pushInPoint
                pushOutPoint:(CGPoint)pushOutPoint
             widthProportion:(CGFloat)widthProportion
                   themeName:(NSString *)themeName
                       pSize:(CGSize)pSize
                        flag:(BOOL)flag
                 captionView:(VECaptionRangeView *)captionRangeView;

//去水印
- (void)saveCurrentRangeview:(BOOL)isScroll;

//画中画
- (void)saveCollageCurrentRangeview:(BOOL)isScroll
                      rotationAngle:(float)rotationAngle
                          transform:(CGAffineTransform)transform
                        centerPoint:(CGPoint)centerPoint
                              frame:(CGRect)frame
                     contentsCenter:(CGRect)contentsCenter
                              scale:(float)scale
                              pSize:(CGSize)pSize
                         thumbImage:(UIImage *)thumbImage
                         collageSize:(CGSize)collageSize
                   captionRangeView:(VECaptionRangeView *)captionRangeView;

- (void)showOrHiddenAddBtn;

- (void)clearCaptionRangeVew;

- (void)clear;

-(void)SetCaptionType:(CGFloat) fcaptionType;

-(CGFloat)CaptionType;

//固定截取 所用
- (void)resetSubviews:(UIImage *)thumbImage  picWidth:(float) picWidth;
@property (nonatomic,assign) float trimDuration_OneSpecifyTime;

-(void)cancelCurrent;

//特效
//添加
- (VECaptionRangeView *)addCapation:(NSString *)themeName type:(NSInteger )type captionDuration:(double)captionDuration genSpecialFilter:(VEFXFilter *) customFilter;
-(VECaptionRangeView *)getCaptionRangeView_CaptionId:(NSInteger) captionId;
//-(BOOL)deleteFilterCaption;
-(void)setTimeEffectCapation:(CMTimeRange ) timeRange name:(NSString *)name atisShow:(BOOL) isShow;

-(void)SetCurrentCaptionView:( VECaptionRangeView * ) rangeV;

-(void)setisSeektime:(BOOL) Seektime;

//画中画拖动范围
-(void)collageDragRange;

@property( nonatomic, assign ) bool isEndOfRat;
@end

@protocol VECaptionVideoTrimmerDelegate <NSObject>
@optional

-(NSInteger)getcaptionIdCount;

- (void)leftMoveRangeViewWithEnd:(BOOL)isEnd;
- (void)rightMoveRangeViewWithEnd:(BOOL)isEnd;
- (void)didEndChangeSelectedMinimumValue_maximumValue;

- (void)startMoveTTrangSlider:(id)view;

- (void)stopMoveTTrangSlider:(id)view;

- (void)capationScrollViewWillBegin:(VECaptionVideoTrimmerView *)trimmerView;

- (void)capationScrollViewWillEnd:(VECaptionVideoTrimmerView *)trimmerView
                        startTime:(Float64)capationStartTime
                          endTime:(Float64)capationEndTime;

- (void)touchescurrentCaptionView:(VECaptionRangeView *)rangeView;

- (void)touchescurrentCaptionView:(VECaptionVideoTrimmerView *)trimmerView
                      showOhidden:(BOOL)flag
                        startTime:(Float64)captionStartTime;

-(void)TimesFor_videoRangeView_withTime:(NSInteger) captionId;

- (void)changeCaptionViewType:(VECaptionRangeView *)captionRangeView;

-(void)dragRangeSlider:(float) x dragStartTime:(float) dragStartTime dragTime:( float ) dragTime isLeft:(float) isleft isHidden:(BOOL) isHidden;

-(void)deleteMaterialEffect_Effect:(NSString *) strPatch;

-(void)Pan_MaterialEffect:(CMTimeRange) timeRange;

-(void)longPressGesture_StateBegan;


-(void)cancelCurrent_CurrerntCaptionView;

@required
- (void)trimmerView:(id)trimmerView
didChangeLeftPosition:(CGFloat)startTime
      rightPosition:(CGFloat)endTime;


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
