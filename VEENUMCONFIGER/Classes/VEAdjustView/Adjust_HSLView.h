//
//  Adjust_HSLView.h
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/4/24.
//

#import <UIKit/UIKit.h>

@class Adjust_HSLView;

@protocol Adjust_HSLViewDelegate <NSObject>

- (void)changingAdjustHSL;

- (void)resetAdjustHSL:(Adjust_HSLView *)view;

- (void)completionAdjustHSL:(Adjust_HSLView *)view;

@end

@interface Adjust_HSLView : UIView

@property (nonatomic, strong) HSL *hsl;

@property (nonatomic, weak) id<Adjust_HSLViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame hsl:(HSL *)hsl;

@end
