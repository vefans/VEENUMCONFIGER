//
//  captionRangeView.h
//  VE
//
//  Created by iOS VESDK Team on 15/9/28.
//  Copyright © 2015年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VEFXFilter.h"
#import "VEVideoCaptionInfo.h"

@interface VECaptionRangeView : UIButton

@property(strong,nonatomic)UIImageView * displayImageView;

@property(assign,nonatomic)NSInteger    captionType;

@property(strong, nonatomic)VEVideoCaptionInfo *file;
@property(assign,nonatomic)NSInteger    index;
@end
