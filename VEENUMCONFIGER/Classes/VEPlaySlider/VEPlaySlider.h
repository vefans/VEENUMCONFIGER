//
//  VEPlaySlider.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/2/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class VEPlaySlider;
@protocol VEPlaySliderDelegate <NSObject>

-(void)playSlider:(VEPlaySlider*)playSlider withPlayValue:(CGFloat)playValue;
-(void)playSliderTouchesBegan:(VEPlaySlider *)playSlider withEvent:(UIEvent *)event;
-(void)playSliderTouchesMoved:(VEPlaySlider *)playSlider withEvent:(UIEvent *)event;
-(void)playSliderTouchesEnded:(VEPlaySlider *)playSlider withEvent:(UIEvent *)event;

@end

@interface VEPlaySlider : UISlider


@property(nonatomic,weak)id<VEPlaySliderDelegate> delegate;
@property (nonatomic,assign)UIView *thumbView;
@property (nonatomic,assign,readonly)CGRect thumbRect;
@end

NS_ASSUME_NONNULL_END
