//
//  VECutVideoRangeSlider.h
//  VEENUMCONFIGER
//
//  Created by MAC_RD on 2024/6/13.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <LibVECore/VECore.h>
NS_ASSUME_NONNULL_BEGIN

@class VECutVideoRangeSlider;
@protocol VECutVideoRangeSliderDelegate <NSObject>
- (void)rangeSliderChange:(VECutVideoRangeSlider *)slider progress:(float)progress status:(UIGestureRecognizerState)status;
- (void)rangeSliderChange:(VECutVideoRangeSlider *)slider progress:(float)progress;
- (void)rangeSliderChange:(VECutVideoRangeSlider *)slider start:(float)start duration:(float)duration progress:(float)progress;

@end
@interface UIHitView: UIView

@end

@interface VECutVideoRangeSlider : UIView

@property (nonatomic, strong) VECore *corePlayer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIHitView *leftThumbView;
@property (nonatomic, strong) UIHitView *rightThumbView;
@property (nonatomic, strong) UIView *leftHandle;
@property (nonatomic, strong) UIView *rightHandle;
@property (nonatomic, strong) UIHitView *rangeView;
@property (nonatomic, assign) CGFloat videoDuration;
@property (nonatomic, assign) CGFloat minRangeDuration;
@property (nonatomic, assign) CGFloat maxRangeDuration;
@property (nonatomic, strong) UIView *thumbHandle;
@property (nonatomic, strong) UIView *thumbMaskHandle;
@property (nonatomic, strong) UILabel *trimTimeLabel;

- (instancetype)initWithFrame:(CGRect)frame player:(VECore *)player minRangeDuration:(float)minRangeDuration maxRangeDuration:(float)maxRangeDuration;
- (instancetype)initWithFrame:(CGRect)frame player:(VECore *)player minRangeDuration:(float)minRangeDuration maxRangeDuration:(float)maxRangeDuration thumbImage:(UIImage *)thumbImage;
@property (nonatomic,weak) id <VECutVideoRangeSliderDelegate> delegate;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat durationTime;
@property (nonatomic, strong) UIImage *thumbImage;
- (void)updateRangeView;
@end

NS_ASSUME_NONNULL_END
