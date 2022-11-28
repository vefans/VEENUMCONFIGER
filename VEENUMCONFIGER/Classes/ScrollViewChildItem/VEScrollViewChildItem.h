//
//  VEScrollViewChildItem.h
//  VELiteSDK
//
//  Created by iOS VESDK Team. on 16/10/23.
//  Copyright © 2016年 VELiteSDK. All rights reserved.
//

typedef NS_ENUM(NSInteger, VEScrollItemType){
    VEScrollItemType_Normal     = 0,
    VEScrollItemType_Music      = 1,    //配乐
    VEScrollItemType_Filter     = 2,    //滤镜
    VEScrollItemType_Tone       = 3,    //音色
    VEScrollItemType_VoiceFX    = 4,    //变声
};

#import <UIKit/UIKit.h>

@class VEScrollViewChildItem;
@protocol VEScrollViewChildItemDelegate <NSObject>

@optional
- (void)scrollViewChildItemTapCallBlock:(VEScrollViewChildItem *)item;

@end

@interface VEScrollViewChildItem : UIButton
@property (nonatomic,assign) VEScrollItemType type;
@property (nonatomic,weak) UIImageView    *itemIconView;
@property (nonatomic,weak) UILabel        *itemTitleLabel;
//@property (nonatomic,strong) void (^tapBtnCallBlock)(id sender);
@property (nonatomic, weak) id<VEScrollViewChildItemDelegate> delegate;
@property (nonatomic,assign) BOOL            play;
@property (nonatomic,assign) BOOL            downloading;
@property (nonatomic,assign,readonly) BOOL   isStartMove;
@property (nonatomic,assign) float           cornerRadius;
@property (nonatomic,assign) float           fontSize;
@property (nonatomic,strong) UIColor        *normalColor;
@property (nonatomic,strong) UIColor        *selectedColor;
@property (nonatomic,strong) UIColor        *textSelectedColor;
@property (nonatomic,strong) id  object;

- (CGRect )getIconFrame;

- (void)startScrollTitle;

- (void)stopScrollTitle;

//配乐
@property (nonatomic,strong) UIImageView    *itemIconselectedView;      //配乐选中

- (instancetype)initWithFrame:(CGRect)frame itemType:(VEScrollItemType)itemType;

@end
