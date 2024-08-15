//
//  VEAddItemButton.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2019/10/10.
//  Copyright © 2019 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LongCacheImageView.h"
#import <SDWebImage/SDAnimatedImageView.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface VEAddItemButton : UIButton

@property(nonatomic,weak)UIImageView * redDotImageView;

+(VEAddItemButton *)initFXframe:(CGRect) rect atpercentage:(float) propor;
//特效
@property(nonatomic,weak)LongCacheImageView *thumbnailIV;
@property(nonatomic,weak)SDAnimatedImageView *animatedImageView;
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)UIView *editView;
@property(nonatomic,weak)UILabel *label;
@property(nonatomic,weak)UILabel *moveTitleLabel;
@property(nonatomic,assign)float propor;
@property(nonatomic,assign)BOOL isDownloading;
@property(nonatomic,assign)NSInteger section;
@property(nonatomic,assign)NSInteger row;

-(void)textColor:(UIColor *) color;

//文字滚动显示
@property (nonatomic,assign) BOOL   isStartMove;
- (void)startScrollTitle;

- (void)stopScrollTitle;
- (void)setSelected:(BOOL)selected;

@end
