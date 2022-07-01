//
//  CircleView.h
//  VELiteSDK
//
//  Created by iOS VESDK Team. on 2017/3/21.
//  Copyright © 2017年 iOS VESDK Team. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface VECircleView : UIView

@property (nonatomic, strong) UIColor *progressColor; /**< 进度条颜色 默认红色*/
@property (nonatomic, strong) UIColor *progressBackgroundColor; /**< 进度条背景色 默认灰色*/
@property (nonatomic, assign) CGFloat progressWidth; /**< 进度条宽度 默认3*/
@property (nonatomic, assign) float percent; /**< 进度条进度 0-1*/
@property (nonatomic, assign) BOOL clockwise; /**< 0顺时针 1逆时针*/

@end
