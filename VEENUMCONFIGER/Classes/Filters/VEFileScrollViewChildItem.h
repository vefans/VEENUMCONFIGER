//
//  ScrollViewChildItem.h
//  VEFile
//
//  Created by iOS VESDK Team on 16/10/23.
//  Copyright © 2016年 VEFile. All rights reserved.
//

typedef NS_ENUM(NSInteger, VEFileScrollItemType){
    VEFileScrollItemType_Normal     = 0,
    VEFileScrollItemType_Music      = 1,    //配乐
    VEFileScrollItemType_Filter     = 2,    //滤镜
    VEFileScrollItemType_Tone       = 3,    //音色
    VEFileScrollItemType_VoiceFX    = 4,    //变声
};

#import <UIKit/UIKit.h>
@class VEFileScrollViewChildItem;
@protocol VEFileScrollViewChildItemDelegate < NSObject >

@optional
- (void)scrollViewChildItemTapCallBlock:(VEFileScrollViewChildItem *)item;

- (void)scrollViewChildItem_Collection:( VEFileScrollViewChildItem * ) item;

@end
@interface VEFileScrollViewChildItem : UIButton
@property (nonatomic, assign) BOOL isLocalCubeFilter;
@property (nonatomic ,assign) NSInteger filterType;
@property (nonatomic ,assign) NSInteger filterTypeCount;

@property (nonatomic,assign) VEFileScrollItemType type;
@property (nonatomic,weak) UIImageView    *itemIconView;
@property (nonatomic,weak) UILabel        *itemTitleLabel;
//@property (nonatomic,strong) void (^tapBtnCallBlock)(id sender);
@property (nonatomic, weak) id<VEFileScrollViewChildItemDelegate> delegate;
@property (nonatomic,assign) BOOL            play;
@property (nonatomic,assign) BOOL            downloading;
@property (nonatomic,assign,readonly) BOOL   isStartMove;
@property (nonatomic,assign) float           cornerRadius;
@property (nonatomic,assign) float           fontSize;
@property (nonatomic,strong) UIColor        *normalColor;
@property (nonatomic,strong) UIColor        *selectedColor;
@property (nonatomic,strong) UIColor        *textSelectedColor;
@property (nonatomic,strong) id  object;

@property (nonatomic, assign) BOOL      isCollection;
@property (nonatomic, assign) BOOL      isSelectCollection;

- (CGRect )getIconFrame;

- (void)startScrollTitle;

- (void)stopScrollTitle;

//配乐
@property (nonatomic,strong) UIImageView    *itemIconselectedView;      //配乐选中

- (instancetype)initWithFrame:(CGRect)frame itemType:(VEFileScrollItemType)itemType;

@end
