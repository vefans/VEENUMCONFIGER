//
//  Custom_ProgressHUD.m
//  KXVideo
//
//  Created by MAC_RD on 2024/9/26.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "VECustomProgressHUD.h"
#ifdef EnableSDWebImage
#import <SDWebImage/SDAnimatedImage.h>
#import <SDWebImage/SDWebImage.h>
#endif
#import <VEENUMCONFIGER/VEHelp.h>
@interface VECustomProgressHUD()
@property(nonatomic,strong)UIView *view;
@property(nonatomic,strong)UIView *customView;
@property(nonatomic,strong)UILabel *statusLabel;
@property(nonatomic,strong)UIImageView *iconIV;
@property(nonatomic,copy)void(^cancelBlock)(BOOL isCancel);
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
+ (void)showCustomHUD:(NSString *)status cancel:(void(^)(BOOL isCancel))cancel{
    NSString *displayStatus = status ? status : @"加载中，请稍后...";  // 默认状态
    if([VECustomProgressHUD sharedHUD].customView){
        [[VECustomProgressHUD sharedHUD] showWithStatus:displayStatus cancel:cancel];
    }
    else{
        [[VECustomProgressHUD sharedHUD] showCustomHUD:displayStatus cancel:cancel];
    }
}
- (void)showCustomHUD:(NSString *)status cancel:(void(^)(BOOL))cancel {
    __block typeof(self) bself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        bself->_cancelBlock = cancel;
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
        NSString *iconPath = [[VEHelp getBundle] pathForResource:@"生成动画.gif" ofType:@""];
        if(iconPath){
    #ifdef EnableSDWebImage
            [iconIV sd_setImageWithURL:[NSURL fileURLWithPath:iconPath]];
    #else
            [VEHelp loadAnimationImageViiewWithView:iconIV atImageUrl:[NSURL fileURLWithPath:iconPath] atPlaceholder:nil];
    #endif
        }
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
        bself->_statusLabel = statusLabel;
        CGRect rect = statusLabel.frame;
        rect.size.width = rect.size.width + 40;
        rect.origin.y = 130;
        rect.origin.x = 0;
        bself->_statusLabel.frame = rect;
        float y = CGRectGetHeight(rect) + 130 + 20;
        if(cancel){
            bself->_cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bself->_cancelBtn.exclusiveTouch = YES;
            bself->_cancelBtn.frame = CGRectMake((CGRectGetWidth(customView.frame) - 120)/2.0, CGRectGetMaxY(bself->_statusLabel.frame) + 15, 120, 40);
            bself->_cancelBtn.backgroundColor = [VEHelp colorWithColors:[VEConfigManager sharedManager].selectedTypeColors bounds:bself->_cancelBtn.frame];
            [bself->_cancelBtn setTitle:VELocalizedString(@"取消", nil) forState:UIControlStateNormal];
            [bself->_cancelBtn setTitleColor:[VEConfigManager sharedManager].textColorOnGradientView forState:UIControlStateNormal];
            bself->_cancelBtn.layer.masksToBounds = YES;
            bself->_cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            bself->_cancelBtn.layer.cornerRadius = 3;
            bself->_cancelBtn.layer.masksToBounds = YES;
            [bself->_cancelBtn addTarget:self action:@selector(cancel_action) forControlEvents:UIControlEventTouchUpInside];
            [customView addSubview:bself->_cancelBtn];
            y = CGRectGetHeight(rect) + 130 + 20 + 50;
        }
        
        
        CGRect frame = customView.frame;
        frame.size.height = y;
        frame.size.width = MAX(rect.size.width,frame.size.height);
        frame.origin.y = (kHEIGHT - frame.size.height)/2.0;
        frame.origin.x = (kWIDTH - frame.size.width)/2.0;
        customView.frame = frame;
        self.customView = customView;
        
        CGRect i_r = iconIV.frame;
        i_r.size.width = i_r.size.width;
        i_r.origin.x = (MAX(frame.size.width,CGRectGetWidth(customView.frame)) - i_r.size.width)/2.0;
        iconIV.frame = i_r;
        
        bself->_statusLabel.center = CGPointMake(self.customView.frame.size.width/2.0, bself->_statusLabel.center.y);
        if(bself->_cancelBtn){
            bself->_cancelBtn.frame = CGRectMake((CGRectGetWidth(customView.frame) - 120)/2.0, CGRectGetMaxY(bself->_statusLabel.frame) + 11, 120, 40);
        }
        [bself.customView addSubview:iconIV];
        [view addSubview:bself.customView];
        if([UIApplication sharedApplication].keyWindow){
            [[UIApplication sharedApplication].keyWindow addSubview:bself.view];
        }
        else{
            [[VEHelp getCurrentViewController].view addSubview:bself.view];
        }
    });
}
- (void)cancel_action{
    if(_cancelBlock){
        _cancelBlock(YES);
    }
    [self dismiss];
}
+ (void)showWithStatus:(NSString *)status{
    [[VECustomProgressHUD sharedHUD] showWithStatus:status];
}
+ (void)showWithStatus:(NSString *)status  cancel:(void(^)(BOOL))cancel{
    [[VECustomProgressHUD sharedHUD] showWithStatus:status cancel:cancel];
}
- (void)showWithStatus:(NSString *)status{
    [self showWithStatus:status cancel:nil];
}
- (void)showWithStatus:(NSString *)status cancel:(void(^)(BOOL))cancel{
    _cancelBlock = cancel;
    if(!_cancelBlock){
        _cancelBtn.hidden = YES;
    }
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
            float y = CGRectGetHeight(rect) + 130 + 20;
            if(bself->_cancelBlock){
                y = CGRectGetHeight(rect) + 130 + 20 + 50;
            }
            
            
            CGRect frame = bself->_customView.frame;
            frame.size.height = y;
            frame.size.width = MAX(rect.size.width,frame.size.height);
            frame.origin.y = (kHEIGHT - frame.size.height)/2.0;
            frame.origin.x = (kWIDTH - frame.size.width)/2.0;
            bself->_customView.frame = frame;
            
            CGRect i_r = bself->_iconIV.frame;
            i_r.size.width = i_r.size.width;
            i_r.origin.x = (frame.size.width - i_r.size.width)/2.0;
            bself->_iconIV.frame = i_r;
            
            bself->_statusLabel.center = CGPointMake(bself.customView.frame.size.width/2.0, bself->_statusLabel.center.y);
            
            if(bself->_cancelBtn){
                bself->_cancelBtn.frame = CGRectMake((CGRectGetWidth(bself.customView.frame) - 120)/2.0, CGRectGetMaxY(bself->_statusLabel.frame) + 11, 120, 40);
            }
        }
        else{
            [bself showCustomHUD:status cancel:bself->_cancelBlock];
        }
    });
}
// 隐藏 HUD
+ (void)dismiss{
    [[VECustomProgressHUD sharedHUD] dismiss];
}
- (void)dismiss {
    _cancelBlock = nil;
    [self.statusLabel removeFromSuperview];
    self.statusLabel = nil;
    [self.customView removeFromSuperview];
    self.customView = nil;
    [self.view removeFromSuperview];
    self.view = nil;
}
+ (void)hideCustomHUDWithDelay:(float)delay{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}
@end
