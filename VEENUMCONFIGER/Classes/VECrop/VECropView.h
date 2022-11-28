//
//  VECropView.h
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import <UIKit/UIKit.h>
#import "VETrackButton.h"
#import "VECropRectView.h"


NS_ASSUME_NONNULL_BEGIN

@protocol VECropViewDelegate <NSObject>

- (void)cropViewCrop:(CGRect)crop withCropRect:(CGRect)cropRect;

@optional

- (void)cropViewbeginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)cropViewTouchTopLeftTrackButton;
- (void)cropViewTouchtopRightTrackButton;
- (void)cropViewTouchesEndSuperView:(UITapGestureRecognizer *)gesture withInVideo:(BOOL)isInVideo withToucheClipPoint:(CGPoint)clipPoint;



@end


@interface VECropView : UIControl

@property(nonatomic,assign)VEVideoCropType videoCropType;

@property(nonatomic,assign)CGSize videoSize;//视频分辨率
@property(nonatomic,assign)CGRect videoFrame;//视频在父试图里面的位置
@property(nonatomic,assign)CGSize cropSizeMin;//裁剪框内部最小大小。
@property(nonatomic,assign)CGSize cropSizeMax;//裁剪框的内部最大尺寸
@property(nonatomic,assign)CGRect trackingRect;//剪裁看可拖动区域。


@property(nonatomic,assign)VECropType cropType;//裁剪类型
@property(nonatomic,strong)VECropRectView * cropRectView;

@property(nonatomic,strong)VETrackButton * topTrackButton;
@property(nonatomic,strong)VETrackButton * bottomTrackButton;
@property(nonatomic,strong)VETrackButton * leftTrackButton;
@property(nonatomic,strong)VETrackButton * rightTrackButton;

@property(nonatomic,strong)VETrackButton * topLeftTrackButton;
@property(nonatomic,strong)VETrackButton * topRightTrackButton;
@property(nonatomic,strong)VETrackButton * bottomLeftTrackButton;
@property(nonatomic,strong)VETrackButton * bottomRightTrackButton;
@property(nonatomic,assign)VECropViewTrackType cropViewTrackType;
@property(nonatomic,weak)id<VECropViewDelegate> delegate;

@property(nonatomic,assign)float cropRatio;

@property(nonatomic,assign)CGRect crop;
@property(nonatomic,assign)CGRect cropRect;

- (CGRect)getCropRect;
-(instancetype)initWithFrame:(CGRect)frame withVideoCropType:(VEVideoCropType)videoCropType;
-(void)setCropRectViewFrame:(VECropType)cropType;
-(void)setWithCropWidth:(CGFloat)cropWidth WithCropHeight:(CGFloat)CropHeight;
-(void)setCropRect:(CGRect)crop;

-(void)trackButton_hidden:(  BOOL ) isHidden;

@end

NS_ASSUME_NONNULL_END
