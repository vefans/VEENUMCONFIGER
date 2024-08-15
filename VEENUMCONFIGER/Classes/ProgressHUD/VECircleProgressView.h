//
//  VECircleProgressView.h
//  MusicSDK
//
//  Created by iOS VESDK Team on 15/8/26.
//  Copyright (c) 2015年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VECircleProgressViewDelegate;

//typedef CGFloat (^KKProgressBlock)();

@interface VECircleProgressView : UIView
@property(nonatomic, weak) id <VECircleProgressViewDelegate> delegate;

@property(nonatomic, assign) float progress;//CGFloat progress; //20161104 bug205

@property(nonatomic) CGFloat frameWidth;

@property(nonatomic, strong) UIColor *progressColor;

@property(nonatomic, strong) UIColor *progressBackgroundColor;

@property(nonatomic, strong) UIColor *circleBackgroundColor;

- (void)progressValueChange:(float)progress;

@end

@protocol VECircleProgressViewDelegate <NSObject>
@optional

@end
