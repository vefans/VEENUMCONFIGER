//
//  VEColorView.h
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/7/21.
//

#import <UIKit/UIKit.h>

@protocol VEColorViewDelegate <NSObject>

//显示吸色
- (void)showEyedropperView:(UIView *)eyedropperView;
- (UIImage *)getCurrentImage;
- (void)changeColor:(UIColor *)color;

@end

@interface VEColorView : UIView

//isEnableEyedropper:是否支持吸色
- (instancetype)initWithFrame:(CGRect)frame
           isEnableEyedropper:(BOOL)isEnableEyedropper
           currentCustomColor:(UIColor *)currentCustomColor
                 isLayoutiPad:(BOOL)isLayoutiPad;

@property (nonatomic, readonly) UIColor *currentCustomColor;
@property (nonatomic, readonly) UIColor *selectedColor;
@property (nonatomic, weak) id<VEColorViewDelegate> delegate;

- (void)setCurrentColor:(UIColor *)color;

@end
