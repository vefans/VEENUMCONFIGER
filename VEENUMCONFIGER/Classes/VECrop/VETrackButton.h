//
//  VETrackButton.h
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VECropViewTrackType){
    VE_TRACK_TOP = 0,      //上边
    VE_TRACK_BOTTOM = 1,      //下边
    VE_TRACK_LEFT = 2,      //左边
    VE_TRACK_RIGHT = 3,      //又边
    VE_TRACK_TOPLEFT = 4,      //左上角
    VE_TRACK_TOPRIGHT = 5,      //右上角
    VE_TRACK_BOTTOMLEFT = 6,      //左下角
    VE_TRACK_BOTTOMRIGHT = 7,      //右下角
    VE_TRACK_CROPRECTVIEW = 8,      //剪切区域
    VE_TRACK_Dewatermark = 9,      //去水印按钮
    VE_TRACK_OTHER = 10,      //右下角
    

};

@interface VETrackButton : UIButton

@property(nonatomic,strong)CAShapeLayer *shapLayer;
@property(nonatomic,strong)UIBezierPath *bezierPath;
@property(nonatomic,assign)VECropViewTrackType  cropViewTrackType;


-(instancetype)initWithFrame:(CGRect)frame withCropViewTrackType:(VECropViewTrackType)cropViewTrackType;


@end

NS_ASSUME_NONNULL_END
