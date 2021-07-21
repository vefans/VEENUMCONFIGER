//
//  UILabel+DynamicFontSize.h
//  VE
//
//  Created by iOS VESDK Team on 16/4/16.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VEPasterLabel : UILabel

@property (nonatomic, assign) BOOL isUseAttributedText;
@property (assign,nonatomic) float    tScale;
@property (nonatomic, strong) UIColor * _Nullable strokeColor;
@property (assign,nonatomic) float    strokeWidth;
@property (assign,nonatomic) float    strokeAlpha;
@property (nonatomic, strong) UIColor * _Nullable innerStrokeColor;//内描边
@property (assign,nonatomic) float    innerStrokeWidth;
@property (assign,nonatomic) float    innerStrokeAlpha;
@property (strong,nonatomic) UIColor * _Nullable fontColor;
@property (assign,nonatomic) float    textAlpha;
@property (strong,nonatomic) NSString * _Nullable pText;
@property (assign,nonatomic) BOOL     needStretching;
/** 文字竖排，默认为NO*/
@property (nonatomic ,assign) BOOL isVerticalText;
@property (assign,nonatomic) BOOL     onlyoneline;
@property (assign,nonatomic) UICaptionTextAlignment     tAlignment;
@property (nonatomic ,assign) BOOL isBold;
@property (nonatomic ,assign) BOOL isItalic;/**文字字体加粗，默认为NO*/
@property (nonatomic ,assign) BOOL isShadow;
@property (strong,nonatomic) UIColor * _Nullable tShadowColor;
@property (assign,nonatomic) CGSize tShadowOffset;
@property (assign,nonatomic) BOOL     defaultH;
@property (assign,nonatomic) float    linesNumber;
- (void)adjustsWidthToFillItsContents:(CGSize)defaultSize textRect:(CGRect) textRect  syncContainerRect:(CGRect)syncContainerRect;
- (void)adjustsWidthWithSuperOriginalSize:(CGSize)superOriginalSize textRect:(CGRect) textRect syncContainerRect:(CGRect)syncContainerRect;
@property (nonatomic,copy,nonnull) void(^setFont)( float fontSize );

@property (assign,nonatomic) float    labelHeight;
@property (assign,nonatomic) CGFloat globalInset;
/*
 
 - (void)adjustsFontSizeToFillItsContents;
 - (void)adjustsFontSizeToFillRect:(CGRect)newBounds;
 - (void)adjustsFontSizeToFillRect:(CGRect)newBounds defaultSize:(CGSize)defaultSize textRect:(CGRect) textRect;
 - (void)adjustsWidthToFillItsContents;
 */
@end

@interface VETextLayer : CATextLayer

@property (nonatomic,assign) CGSize contentsSize;

@end

