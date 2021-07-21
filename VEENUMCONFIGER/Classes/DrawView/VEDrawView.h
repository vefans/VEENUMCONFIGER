//
//  VEDrawView.h
//  12
//
//  Created by iOS VESDK Team on 2017/5/22.
//  Copyright © 2017年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
@class VEDrawTouchPointView;
@class VEDrawView;
@protocol VEDrawViewDelegate <NSObject>
- (void)showAlertView:(UIAlertController *)alertController;
- (void)hidden_View;
- (void)drawCallback:(VEDrawView *) drawView;
@end

@interface VEDrawView : UIImageView

@property (nonatomic, weak) VEDrawTouchPointView *drawView;

@property (nonatomic,weak) id <VEDrawViewDelegate> delegate;

+ (VEDrawView *)initWithImage:(UIImage *)image frame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor;
/** 清屏 */
- (void)clearScreen;
/** 撤消操作 */
- (void)revokeScreen;
/** 擦除 */
- (void)eraseSreen;
/** 设置画笔颜色 */
- (void)setStrokeColor:(UIColor *)lineColor;

-(UIColor *)StrokeColor;

/** 设置画笔大小 */
- (void)setStrokeWidth:(CGFloat)lineWidth;
- (float)LineWidth;

- (void)alterDrawBoardDescLabel:(UILabel *)content;

- (UIImage *)getImage;

- (BOOL)isHasContent;//是否还有画的线

//图片编辑添加功能 点涂鸦界面进行回调
@property (nonatomic,assign)BOOL isCallback;
@end



@interface VEDrawTouchPointView : UIView
@property (nonatomic, strong) NSMutableArray *stroks;
@property (nonatomic, strong) NSMutableArray <UILabel *> *textDescs;
@property (nonatomic, assign,readonly) CGPoint touchupCurrentPoint;
@property (nonatomic,assign)BOOL canDrawLine;

/** 清屏 */
- (void)clearScreen;
/** 撤消操作 */
- (void)revokeScreen;
/** 擦除 */
- (void)eraseSreen;
/** 设置画笔颜色 */
- (void)setStrokeColor:(UIColor *)lineColor;
/** 设置画笔大小 */
- (void)setStrokeWidth:(CGFloat)lineWidth;

- (UIImage *)snapsHotView;

@end

typedef struct CGPath *CGMutablePathRef;
typedef enum CGBlendMode CGBlendMode;

@interface VEDWStroke : NSObject

@property (nonatomic) CGMutablePathRef path;
@property (nonatomic, assign) CGBlendMode blendMode;
@property (nonatomic, assign) CGFloat strokeWidth;
@property (nonatomic, strong) UIColor *lineColor;
- (void)strokeWithContext:(CGContextRef)context;


@end
