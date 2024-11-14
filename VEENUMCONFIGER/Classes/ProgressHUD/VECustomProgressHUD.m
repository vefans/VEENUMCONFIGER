//
//  VECustomProgressHUD.m
//  KXVideo
//
//  Created by MAC_RD on 2024/9/26.
//

#import "VEProgressHUD.h"
#import "VECustomProgressHUD.h"
#import <SDWebImage/SDAnimatedImage.h>
#import <SDWebImage/SDWebImage.h>
#import <VEENUMCONFIGER/VEHelp.h>
@interface VECustomProgressHUD()
@property(nonatomic,strong)UIView *view;
@property(nonatomic,strong)UIView *customView;
@property(nonatomic,strong)UILabel *statusLabel;
@property(nonatomic,strong)UIImageView *iconIV;
@end
@implementation VECustomProgressHUD
+ (instancetype)sharedHUD
{
    static VECustomProgressHUD *singleOjbect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleOjbect = [[self alloc] init];
    });
    return singleOjbect;
}

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}
+ (void)showCustomHUD:(NSString *)status{
    if([VECustomProgressHUD sharedHUD].customView){
        [[VECustomProgressHUD sharedHUD] showWithStatus:status];
    }
    else{
        [[VECustomProgressHUD sharedHUD] showCustomHUD:status];
    }
}
- (void)showCustomHUD:(NSString *)status {
    // 创建自定义视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.view = view;
    // 创建自定义视图
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 158, 138 + 20)];
    customView.layer.cornerRadius = 15;
    customView.layer.masksToBounds = YES;
    customView.backgroundColor = [UIColor whiteColor];

    // 创建动画视图，例如 UIImageView
    UIImageView *iconIV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 98, 98)];
    [iconIV sd_setImageWithURL:[NSURL fileURLWithPath:[[VEHelp getBundleName:@"VEEditSDK"] pathForResource:@"生成动画" ofType:@"gif"]]];
    self.iconIV = iconIV;
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.adjustsFontSizeToFitWidth = YES;
    statusLabel.adjustsFontForContentSizeCategory = YES;
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    statusLabel.font = [UIFont systemFontOfSize:15];
    statusLabel.numberOfLines = 0;
    statusLabel.textColor = UIColorFromRGB(0x000000);
    statusLabel.text = status;
    [customView addSubview:statusLabel];
    [statusLabel sizeToFit];
    _statusLabel = statusLabel;
    CGRect rect = statusLabel.frame;
    rect.size.width = rect.size.width + 40;
    rect.origin.y = 130;
    rect.origin.x = 0;
    _statusLabel.frame = rect;
    
    CGRect i_r = iconIV.frame;
    i_r.size.width = i_r.size.width;
    i_r.origin.x = (MAX(rect.size.width,CGRectGetWidth(customView.frame)) - i_r.size.width)/2.0;
    iconIV.frame = i_r;
    
    CGRect frame = customView.frame;
    frame.size.height = CGRectGetHeight(rect) + 130 + 20;
    frame.size.width = MAX(rect.size.width,rect.size.height);
    frame.origin.y = (kHEIGHT - frame.size.height)/2.0;
    frame.origin.x = (kWIDTH - frame.size.width)/2.0;
    customView.frame = frame;
    self.customView = customView;
    [self.customView addSubview:iconIV];
    [view addSubview:self.customView];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.view];
}
+ (void)showWithStatus:(NSString *)status{
    [[VECustomProgressHUD sharedHUD] showWithStatus:status];
}
- (void)showWithStatus:(NSString *)status{
    __block typeof(self) bself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if(bself->_customView){
            bself->_statusLabel.text = status;
            [bself->_statusLabel sizeToFit];
            CGRect rect = bself->_statusLabel.frame;
            rect.size.width = MAX(158,rect.size.width + 60);
            rect.origin.y = 130;
            rect.origin.x = 0;
            bself->_statusLabel.frame = rect;
            
            
            
            CGRect frame = bself->_customView.frame;
            frame.size.height = CGRectGetHeight(rect) + 130 + 20;
            frame.size.width = MAX(rect.size.width,rect.size.height);
            frame.origin.y = (kHEIGHT - frame.size.height)/2.0;
            frame.origin.x = (kWIDTH - frame.size.width)/2.0;
            bself->_customView.frame = frame;
            
            CGRect i_r = bself->_iconIV.frame;
            i_r.size.width = i_r.size.width;
            i_r.origin.x = (frame.size.width - i_r.size.width)/2.0;
            bself->_iconIV.frame = i_r;
            
        }
        else{
            [bself showCustomHUD:status];
        }
    });
}
// 隐藏 HUD
+ (void)hideCustomHUD{
    [[VECustomProgressHUD sharedHUD] hideCustomHUD];
}
- (void)hideCustomHUD {
    [self.statusLabel removeFromSuperview];
    self.statusLabel = nil;
    [self.customView removeFromSuperview];
    self.customView = nil;
    [self.view removeFromSuperview];
    self.view = nil;
}
+ (void)hideCustomHUDWithDelay:(float)delay{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideCustomHUD];
    });
}
@end
