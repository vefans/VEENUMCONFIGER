//
//  VEPasterAssetView.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2022/1/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VEPasterAssetView;
@protocol VEPasterAssetViewDelegate <NSObject>

- (void)dragPasterAssetViewBegin:(VEPasterAssetView *)pasterAssetView;

//位置移动
-(void)pasterAssetViewMove:( VEPasterAssetView * ) pasterAssetView atUpLeft:( CGPoint ) upLeftPoint atUpRight:( CGPoint ) upRightPoint atBottomRight:( CGPoint ) bottomRightPoint atBottomLeft:( CGPoint ) bottomLeftPoint;
//获取是否可以拖动
-(BOOL)isDragPasterAssetViewEnable:( VEPasterAssetView * ) pasterAssetView;
//是否显示字幕文字编辑界面
- (void)pasterAssetViewShow:( VEPasterAssetView * _Nullable )pasterAssetView;

@end


@interface VEPasterAssetView : UIView


@property (nonatomic, assign)BOOL       isFixedSize;
@property (nonatomic, assign)BOOL       isFixedAngle;

@property (nonatomic, assign)BOOL       isInvisible;
@property (nonatomic, assign)float         invisibleAlpha;

@property (nonatomic, assign)BOOL isDrag_Upated;
@property (nonatomic, assign)bool isDrag;

-(void)RefreshPasterAssetView;
-(void)setAngle:( float ) angle;

-(void)refreshPasterAssetViewWithUpLeftPoint:( CGPoint ) upLeftPoint atUpRight:( CGPoint ) upRightPoint atBottomRight:( CGPoint ) bottomRightPoint atBottomLeft:( CGPoint ) bottomLeftPoint;

@property (weak, nonatomic,nullable) id<VEPasterAssetViewDelegate>   delegate;

- (instancetype)initWithFrame:(CGRect ) frame atIntervalWidth:( float  ) intervalWidth;

@property( nonatomic, strong)id _Nullable media;

@property (nonatomic, assign)float   fIntervalWidth;
@property (nonatomic, assign)BOOL  isCurrent;

@property (nonatomic, weak)UIImageView *currentBtn;

//MARK: 主体
@property (nonatomic, weak)UIView       *centerView;
@property (nonatomic, weak)CAShapeLayer * maskLayer;

//MARK: 左上
@property (nonatomic, weak)UIImageView *dragUpLeftBtn;

//MARK: 右上
@property (nonatomic, weak)UIImageView *dragUpRightBtn;

//MARK: 右下
@property (nonatomic, weak)UIImageView *dragBottomRightBtn;

//MARK: 左下
@property (nonatomic, weak)UIImageView *dragBottomLeftBtn;

@property (nonatomic,weak) UIView            * _Nullable syncContainer;
#pragma mark- 平移
-(void)pasterAssetViewMove_Gesture:(UIGestureRecognizer *) recognizer;
#pragma mark- 缩放
-(void)pasterAssetViewPinch_Gesture:(UIPinchGestureRecognizer *) recognizer;
#pragma mark- 旋转
-(void)pasterAssetViewRotation_Gesture:(UIRotationGestureRecognizer *)rotation;
#pragma mark- 选中
- (void)contentTapped:(UITapGestureRecognizer*)tapGesture;

-( NSMutableArray * )getPasterAssetViewArray;

-( void )recoverPasterAssetView;


@property (nonatomic, assign) UIGestureRecognizerState gestureState;
@end

NS_ASSUME_NONNULL_END
