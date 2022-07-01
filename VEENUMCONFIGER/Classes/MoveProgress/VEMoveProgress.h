//
//  VEMoveProgress.h
//
//
//  Created by iOS VESDK Team. on 15/10/13.
//  Copyright © 2015 iOS VESDK Team. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface VEMoveProgress : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor* progressTintColor;
@property (nonatomic, strong) UIColor* trackTintColor;
@property (nonatomic, strong) UIImage* progressImag;
@property (nonatomic, strong) UIImage* trackImage;

- (void)setProgress:(double)progress animated:(BOOL)animated;

@end
