//
//  VEVideoCropView.h
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import <UIKit/UIKit.h>
#import "VECropView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VEVideoCropDelegte <NSObject>
- (void)cropViewDidChangeCropValue:(CGRect)rect clipRect:(CGRect)clipRect;


@end


@interface VEVideoCropView : UIView

-(instancetype)initWithFrame:(CGRect)frame withVideoCropType:(VEVideoCropType)videoCropType;
@property(nonatomic,assign)CGSize videoSize;//视频分辨率
@property(nonatomic,assign)CGRect videoRect;//视频大小
@property(nonatomic,strong)UIView * videoView;
@property(nonatomic,strong)VECropView * cropView;
@property(nonatomic,assign)VEVideoCropType videoCropType;


@end

NS_ASSUME_NONNULL_END
