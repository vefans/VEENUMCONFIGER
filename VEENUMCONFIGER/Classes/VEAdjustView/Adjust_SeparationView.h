//
//  Adjust_SeparationView.h
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/4/24.
//

#import <UIKit/UIKit.h>

@class Adjust_SeparationView;

@protocol Adjust_SeparationViewDelegate <NSObject>

- (void)changingAdjustSeparation;

- (void)resetAdjustSeparation:(Adjust_SeparationView *)view;

- (void)completionAdjustSeparation:(Adjust_SeparationView *)view;

@end

@interface Adjust_SeparationView : UIView

@property (nonatomic, strong) HighLightShadow *highLight_shadow;

@property (nonatomic, weak) id<Adjust_SeparationViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame highLight_shadow:(HighLightShadow *)highLight_shadow;

@end
