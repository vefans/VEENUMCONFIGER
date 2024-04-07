//
//  VECropRectView.h
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VECropRectView : UIView

@property(nonatomic,assign)VEVideoCropType videoCropType;

@property(nonatomic,assign)BOOL isTrackButtonHidden;

-(instancetype)initWithFrame:(CGRect)frame withVideoCropType:(VEVideoCropType)videoCropType;

@property(nonatomic, assign) float  scale;

@end

NS_ASSUME_NONNULL_END
