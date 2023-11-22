//
//  VEAPITemplateBeauty_VirtualView.h
//  VEDeluxe
//
//  Created by iOS VESDK Team on 2020/3/27.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VEAPITemplateBeauty_VirtualView;

@protocol VEAPITemplateBeauty_VirtualViewDelegate <NSObject>

@optional
//设置美颜
-(void)refreshBeautyValue:(float)value beautyType:(KVLBeautyType)beautyType;
-(void)refreshFiveSensesValue:(float)value beautyType:(KBeautyType)beautyType;
- (void)resetBeauty;
- (void)resetFiveSenses;
- (void)refreshFiveSenses:(FaceAttribute *)faceAttribute;
- (void)resetBeautyWithArray:( NSMutableArray * ) array atView:( VEAPITemplateBeauty_VirtualView * ) beautyEditView;
//关闭
-(void)beautyConfirm_Btn:(VEAPITemplateBeauty_VirtualView *) beautyEditView;

- (void)beginChangeBeautyBigEye;

- (void)beginChangeBeautyThinFace;

@end

@interface VEAPITemplateBeauty_VirtualView : UIView

@property(nonatomic, weak)id<VEAPITemplateBeauty_VirtualViewDelegate>   delegate;

@end

NS_ASSUME_NONNULL_END
