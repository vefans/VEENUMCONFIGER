//
//  VECustomProgressHUD.h
//  KXVideo
//
//  Created by MAC_RD on 2024/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VECustomProgressHUD : UIView
+ (instancetype)sharedHUD;
+ (void)showCustomHUD:(NSString *)status;
+ (void)showWithStatus:(NSString *)status;
+ (void)hideCustomHUD;
+ (void)hideCustomHUDWithDelay:(float)delay;
@end

NS_ASSUME_NONNULL_END
