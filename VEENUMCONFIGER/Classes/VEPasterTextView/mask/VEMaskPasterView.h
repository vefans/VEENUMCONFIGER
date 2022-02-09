//
//  VEMaskPasterView.h
//  libVEDeluxe
//
//  Created by apple on 2020/10/27.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEPasterTextView.h"
#import "VESyncContainerView.h"
#import "VEHelp.h"

NS_ASSUME_NONNULL_BEGIN

/* 角度转弧度 */
#define SK_DEGREES_TO_RADIANS(angle) \
((angle) / 180.0 * M_PI)

CG_INLINE CGPoint VECGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

//CG_INLINE CGRect CGRectScale(CGRect rect, CGFloat wScale, CGFloat hScale)
//{
//    return CGRectMake(rect.origin.x * wScale, rect.origin.y * hScale, rect.size.width * wScale, rect.size.height * hScale);
//}

CG_INLINE CGFloat VECGPointGetDistance(CGPoint point1, CGPoint point2)
{
    //Saving Variables.
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    
    return sqrt((fx*fx + fy*fy));
}

CG_INLINE CGFloat VECGAffineTransformGetAngle(CGAffineTransform t)
{
    return atan2(t.b, t.a);
}


CG_INLINE CGSize VECGAffineTransformGetScale(CGAffineTransform t)
{
    return CGSizeMake(sqrt(t.a * t.a + t.c * t.c), sqrt(t.b * t.b + t.d * t.d)) ;
}

@class VEMaskPasterView;

@protocol VEMaskPasterViewDelegate <NSObject>


@optional
//MARK: 平移
- (void) movement_MaskPasterView:(VEMaskPasterView *) maskPastertView;
//MARK: 两指旋转
-(void) two_fingerRotation_MaskPasterView:(VEMaskPasterView *) maskPasterView;
//MARK: 拖拽旋转
-(void) dragAndRotate_MaskPasterView:(VEMaskPasterView *) maskPasterView;
//MARK: 两指缩放
-(void) two_FingerZoom_MaskPasterView:(VEMaskPasterView *) maskPasterView;
//MARK: 左右拉伸
-(void) leftAndRightStretch_MaskPasterView:(VEMaskPasterView *) maskPasterView;
//MARK: 上下拉伸
-(void) stretchUpAndDown_MaskPasterView:(VEMaskPasterView *) maskPasterView;
//MARK: 圆角
-(void) fillet_MaskPasterView_Quadrilateral:(VEMaskPasterView *) maskPasterView  atCornerRadius:(float) cornerRadius;

//MARK: 四边形 四角位置变动
-(void) corner_MaskPasterView:(VEMaskPasterView *) maskPasterView;
@end

@interface VEMaskPasterView : UIView
{
    //平移 线性
    CGPoint touchLocation;
    CGPoint currentCenter;
    CGPoint beginningPoint;
    CGPoint beginningCenter;
    CGRect beginBounds;
    CGFloat deltaAngle;
    CGFloat beginAngle;
    CGPoint beganLocation;
    
    //镜面
    CGFloat beginningWidth;
    CGFloat beginningPinch_x;
    CGFloat beginningPinch_y;
    CGFloat RoundnessHeight;
    
    CGFloat btnWidth;
    CGFloat intervalWidth;
    
    CGFloat filletWidth;
    
    CGRect initialBounds;
    CGFloat initialDistance;
    
    
    bool    isShock;
    
}

@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic,copy)NSString   *bundleStr;

@property (nonatomic, assign) CGPoint topLeftZoomPoint;
@property (nonatomic, assign) CGPoint bottomLeftZoomPoint;
@property (nonatomic, assign) CGPoint topRightZoomPoint;
@property (nonatomic, assign) CGPoint bottomRightZoomPoint;


@property (nonatomic, assign) float topLeftWidth;
@property (nonatomic, assign) float bottomLeftWidth;
@property (nonatomic, assign) float topRightWidth;
@property (nonatomic, assign) float bottomRightWidth;

@property (nonatomic, assign) float   quadrilateralWidth;

- (instancetype)initWithFrame:(CGRect)frame atType:(VEMaskType) type atPasterTextView:(VEPasterTextView *) pasterTextView atSyncContainer:(VESyncContainerView *) syncContainer atHeight:(float) CenterHeight atWidth:(float) CenterWidth atColor:( UIColor * ) color atStr:( NSString * ) str;

@property(nonatomic,weak)id<VEMaskPasterViewDelegate>   delegate;

@property (nonatomic, assign) VEMaskType maskType;

#pragma mark- 矩形 四角触点 topLeft   bottomRight
@property (nonatomic, weak) UIImageView * topLeftImageView;
@property (nonatomic, weak) UIImageView * topLeftRectangleImageView;
@property (nonatomic, assign) CGPoint  topLeftPoint;

@property (nonatomic, weak) UIImageView * bottomLeftImageView;
@property (nonatomic, weak) UIImageView * bottomLeftRectangleImageView;
@property (nonatomic, assign) CGPoint  bottomLeftPoint;

@property (nonatomic, weak) UIImageView * topRightImageView;
@property (nonatomic, weak) UIImageView * topRightRectangleImageView;
@property (nonatomic, assign) CGPoint  topRightPoint;

@property (nonatomic, weak) UIImageView * bottomRightImageView;
@property (nonatomic, weak) UIImageView * bottomRightRectangleImageView;
@property (nonatomic, assign) CGPoint  bottomRightPoint;

#pragma mark-

@property (nonatomic, weak) UIView      *curretnView;       //当前编辑控件
@property (nonatomic, weak) UIView      *curretnCenterView;       //当前编辑控件中心区域
//拖拽
@property (nonatomic, weak) UIImageView *rotate_ImageView;
//上下
@property (nonatomic, weak) UIImageView *vertical_ImageView;
//左右
@property (nonatomic, weak) UIImageView *level_ImageView;
//圆角
@property (nonatomic, weak) UIImageView *fillet_ImageView;

//中心
@property (nonatomic, weak) UIImageView *centreImageView;
//对应的pasterTextView
@property (nonatomic, weak) VEPasterTextView *currentMultiTrackPasterTextView;
@property (nonatomic, weak) VESyncContainerView * syncContainer;

@property (nonatomic, weak) UIView      *linnearView;               //线性

@property (nonatomic, weak) UIView      *mirrorSurfaceView;         //镜面
@property (nonatomic, weak) UIView      *mirrorSurfaceCenterView;   //镜面中心区域

@property (nonatomic, weak) UIView      *rectangleView;             //矩形
@property (nonatomic, weak) UIView      *rectangleViewCenterView;   //矩形中心区域

@property (nonatomic, weak) UIView      *quadrilateralView;         //四边形
@property (nonatomic, weak) UIView      *quadrilateralViewCenterView;   //四边形中心区域
//@property (nonatomic, weak) UIView      *quadrilateralCurrentView;

@property (nonatomic, weak) UIView      *roundnessView;             //圆形
@property (nonatomic, weak) UIView      *roundnessCenterView;       //圆形中心区域

@property (nonatomic, weak) UIView      *pentacleView;              //五角星
@property (nonatomic, weak) UIView      *pentacleCenterView;              //五角星中心区域

@property (nonatomic, weak) UIView      *loveView;              //爱心
@property (nonatomic, weak) UIView      *loveCenterView;              //爱心中心区域



//设置 中心坐标
-(void)setCenterPoint;
//设置 旋转角度 旋转坐标
-( CGAffineTransform )GetCGAffineTransformRotateAroundPoint:(float) centerX atCenterY:(float) centerY atX:(float) x atY:(float) y atAngle:(float) angle;
//设置缩放大小
-(void)setFramescale:(float) value;

-(void)setfilletWidth:(float) fillet;

@property (nonatomic, assign) float   pinScale;
@property (nonatomic, assign)float    selfScale;
@property (nonatomic, assign)float    oldSelfScale;
@property (nonatomic, assign)float    zoomScale;
@end

NS_ASSUME_NONNULL_END
