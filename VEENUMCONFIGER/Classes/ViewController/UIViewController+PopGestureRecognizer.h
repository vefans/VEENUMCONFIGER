//
//  UIViewController+PopGestureRecognizer.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/12/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (PopGestureRecognizer)
+ (void)popGestureClose:(UIViewController *)VC;
+ (void)popGestureOpen:(UIViewController *)VC;
@end

NS_ASSUME_NONNULL_END
