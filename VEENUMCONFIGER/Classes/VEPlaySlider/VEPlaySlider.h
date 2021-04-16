//
//  VEPlaySlider.h
//  VELiteSDK
//
//  Created by 刘超 on 2021/2/17.
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

@end

NS_ASSUME_NONNULL_END
