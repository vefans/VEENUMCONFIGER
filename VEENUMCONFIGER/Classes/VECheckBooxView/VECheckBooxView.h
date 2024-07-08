//
//  VECheckBooxView.h
//  VEDeluxeSDK
//
//  Created by mac on 2024/7/3.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface VECheckBooxView : UIView
@property(nonatomic, copy) void(^checkBooxView_rotateGesture)( VECheckBooxView * booxView, UIPanGestureRecognizer * recognizer );
@property(nonatomic, copy) void(^closeCheckBooxView)( VECheckBooxView * booxView );
@property(nonatomic, copy) void(^refreshSynContainer)( VECheckBooxView * booxView );

@property( nonatomic, strong ) UIView *currentView;

@property( nonatomic, strong ) UIButton *closeBtn;

@property( nonatomic, strong ) UIImageView *rotateView;

@property( nonatomic, weak) UIView *syncContainer;

@property(nonatomic, assign) float edgeWidth;

@property(nonatomic, assign) float maxHeight;

@property(nonatomic, assign) float minHeight;

-(void)veCheckBooxView_Move:( UIPanGestureRecognizer * ) recognizer;
-(void)veCheckBooxView_Angle:( UIRotationGestureRecognizer * ) recognizer;
-(void)veCheckBooxView_Scale:( UIPinchGestureRecognizer * ) recognizer;

- (instancetype)initWithFrame:( CGRect )frame atEdgeWidth:( float ) edgeWidth;

-(void)setFrame:(CGRect) frame angle:( float ) angle center:( CGPoint ) center;

@end

NS_ASSUME_NONNULL_END
