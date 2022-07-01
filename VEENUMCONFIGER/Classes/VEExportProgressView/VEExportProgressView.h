//
//  VEExportProgressView.h
//  VE
//
//  Created by iOS VESDK Team on 2016/12/1.
//  Copyright © 2016年 VE. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancelExportBlock) (void);

@interface VEExportProgressView : UIView
@property (nonatomic, strong) UILabel *progressTitleLabel;
@property (nonatomic, strong) UIColor* trackprogressTintColor;
@property (nonatomic, strong) UIColor* trackbackTintColor;
@property (nonatomic, strong) UIImage* trackbackImage;
@property (nonatomic, strong) UIImage* trackprogressImag;
@property (nonatomic, assign)BOOL canTouchUpCancel;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic, copy) CancelExportBlock cancelExportBlock;
- (void)setProgressTitle:(NSString *)progressTitle;
- (void)setProgress:(double)progress animated:(BOOL)animated;
- (void)setProgress2:(double)progress animated:(BOOL)animated;
- (void)dismiss;
@end
