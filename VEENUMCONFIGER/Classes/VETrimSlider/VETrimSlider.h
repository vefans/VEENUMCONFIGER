//
//  VETrimSlider.h
//  VE
//
//  Created by apple on 2019/9/17.
//  Copyright © 2019 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VECaptionVideoTrimmerView.h"

@protocol VETrimSliderDelegate <NSObject>
-(void)trimmerViewProgress:(CGFloat)startTime;

@end

@interface VETrimSlider : UIControl
- (instancetype)initWithFrame:(CGRect)frame videoCore:(VECore *)videoCore trimDuration_OneSpecifyTime:(float) trimDuration_OneSpecifyTime;

- (void)loadTrimmerViewThumbImage:(UIImage *)image thumbnailCount:(NSInteger)thumbnailCount;

@property (weak, nonatomic) id<VETrimSliderDelegate> delegate;

@property(weak, nonatomic)UIImageView   *currentHandle;

@property (strong, nonatomic) UIImageView* lowerHandle;
@property (strong, nonatomic) UIImageView* upperHandle;
@property (strong, nonatomic) VECaptionVideoTrimmerView*  TrimmerView;
@property(nonatomic,strong)VECore *thumbnailCoreSDK;
@property (nonatomic,assign) float trimDuration_OneSpecifyTime;

@property(nonatomic,assign) float progressValue;
@property(nonatomic,assign) float currentProgressValue;

-(float)progress:(float) value;
-(void)interceptProgress:(float) value;

@end

