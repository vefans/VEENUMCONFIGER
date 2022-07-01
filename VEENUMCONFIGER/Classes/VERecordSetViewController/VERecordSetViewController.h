//
//  VERecordSetViewController.h
//  VELiteSDK
//
//  Created by iOS VESDK Team on 2018/12/4.
//  Copyright © 2018年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VERecordSetViewController : UIViewController

@property (nonatomic,copy) void (^changeRecordSetFinish)(int bitrate, NSInteger resolutionIndex);

@end

NS_ASSUME_NONNULL_END
