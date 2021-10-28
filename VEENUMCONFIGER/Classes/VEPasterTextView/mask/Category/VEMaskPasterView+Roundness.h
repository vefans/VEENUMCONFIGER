//
//  VEMaskPasterView+Roundness.h
//  libVEDeluxe
//
//  Created by apple on 2020/10/29.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEMaskPasterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEMaskPasterView (Roundness)

-(void)initRoundness:(float) CenterHeight atWidth:(float) CenterWidth;

-(void)setCenterView_Roundness;

@end

NS_ASSUME_NONNULL_END
