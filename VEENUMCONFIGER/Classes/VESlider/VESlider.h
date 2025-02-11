//
//  VESlider.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2016/12/6.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VESlider : UISlider

@property (nonatomic, assign) CGRect thumbRect;
@property (nonatomic, assign) BOOL isAETemplate;
@property (nonatomic, assign) BOOL isAdj;
@property (nonatomic, weak) UILabel *valueLbl;
@property (nonatomic, assign) CGPoint thumbCenter;

@end
