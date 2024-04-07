//
//  ICGRulerView.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 1/25/15.
//  Copyright (c) 2015 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VEHRulerViewDelegate <NSObject>

@end

@interface VEHRulerView : UIView

@property (nonatomic, assign) BOOL isFromUnit;//Default is NO.
@property (nonatomic, assign) CGFloat minValue;//Default is 0.
@property (nonatomic, assign) CGFloat maxValue;//Default is self.frame.size.width.
@property (nonatomic, assign) CGFloat stepValue;//Default is 10.
@property (nonatomic, assign) int unitValue;//Default is 10.
@property (nonatomic, assign) CGFloat stepLineHeight;//Default is 10.
@property (nonatomic, assign) CGFloat lineWidth;//Default is 1.5.
@property (nonatomic, assign) CGFloat unitLineHeight;//Default is 10.
@property (nonatomic, strong) UIColor *stepLineColor;//Default is UIColorFromRGB(0x656565).
@property (nonatomic, strong) UIColor *unitLineColor;//Default is UIColorFromRGB(0xd3d3d3).
@property (nonatomic, assign) BOOL isShowText;//Default is NO.
@property (nonatomic, strong) UIColor *textColor;//Default is [UIColor whiteColor].
@property (nonatomic, assign) CGFloat fontSize;//Default is 11.

@property (nonatomic, weak) id<VEHRulerViewDelegate> delegate;

@end
