//
//  Custom_ProgressHUD.h
//  KXVideo
//
//  Created by MAC_RD on 2024/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VECustomProgressHUD : UIView
@property(nonatomic,strong)UIButton *cancelBtn;
+ (instancetype)sharedHUD;
+ (void)showCustomHUD:(NSString *)status;
+ (void)showCustomHUD:(NSString *)status cancel:(void(^)(BOOL isCancel))cancel;
+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status  cancel:(void(^)(BOOL))cancel;
+ (void)dismiss;
+ (void)hideCustomHUDWithDelay:(float)delay;
@end

NS_ASSUME_NONNULL_END
