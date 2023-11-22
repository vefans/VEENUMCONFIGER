//
//  VEAPITemplateRecordButton.h
//  VEDeluxeSDK
//
//  Created by iOS VESDK Team  on 2021/7/16.
//

#import <UIKit/UIKit.h>

@interface VEAPITemplateRecordButton : UIButton

@property (nonatomic, strong) UIColor *progressColor; /**< 进度条颜色 默认Main_Color*/
@property (nonatomic, strong) UIColor *progressBackgroundColor; /**< 进度条背景色 默认无*/
@property (nonatomic, assign) CGFloat progressWidth; /**< 进度条宽度 默认5*/
@property (nonatomic, assign) float percent; /**< 进度条进度 0-1*/
@property (nonatomic, assign) BOOL clockwise; /**< 0顺时针 1逆时针*/
@property (nonatomic, assign) bool parity;

@end
