//
//  VEExportProgressView.h
//  VE
//
//  Created by iOS VESDK Team on 2016/12/1.
//  Copyright © 2016年 VE. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancelExportBlock) (void);

@interface UIRectProgressView:UIView
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) UIImageView *coverImageView;
@property(nonatomic,assign) double progress;
@property (nonatomic, assign) BOOL isHiddenCancelBtn;//是否隐藏取消,默认为NO
@property (nonatomic, copy) CancelExportBlock cancelExportBlock;
- (instancetype)initWithFrame:(CGRect)frame coverImage:(UIImage *)coverImage;
- (void)dismiss;
@end




@interface VEExportProgressView : UIView
@property (nonatomic, strong) UILabel *progressTitleLabel;
@property (nonatomic, strong) UIColor* trackprogressTintColor;
@property (nonatomic, strong) UIColor* trackbackTintColor;
@property (nonatomic, strong) UIImage* trackbackImage;
@property (nonatomic, strong) UIImage* trackprogressImag;
@property (nonatomic, assign)BOOL canTouchUpCancel;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic, copy) CancelExportBlock cancelExportBlock;
@property (nonatomic, assign) BOOL isHiddenCancelBtn;//是否隐藏取消,默认为NO
- (void)setProgressTitle:(NSString *)progressTitle;
- (void)setProgress:(double)progress animated:(BOOL)animated;
- (void)setProgress2:(double)progress animated:(BOOL)animated;
- (void)dismiss;
@end
