//
//  VESwitch.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team. on 2022/6/16.
//

#import <UIKit/UIKit.h>

@interface VESwitch : UIControl

@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, strong) UIColor *onTintColor;
@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic, strong) UIImage *thumbImage;

@property(nonatomic,getter=isOn) BOOL on;

- (void)setOn:(BOOL)on animated:(BOOL)animated;

@end
