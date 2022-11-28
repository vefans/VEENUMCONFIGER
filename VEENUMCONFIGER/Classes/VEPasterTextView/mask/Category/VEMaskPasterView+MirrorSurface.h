//
//  VEMaskPasterView+MirrorSurface.h
//  libVEDeluxe
//
//  Created by iOS VESDK Team on 2020/10/28.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEMaskPasterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEMaskPasterView (MirrorSurface)

-(void)initMirrorSuface:(float) height atHeight:(float) CenterHeight atWidth:(float) CenterWidth;

@end

NS_ASSUME_NONNULL_END
