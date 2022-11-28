//
//  VEMaskPasterView+Quadrilateral.h
//  libVEDeluxe
//
//  Created by iOS VESDK Team on 2020/10/28.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEMaskPasterView.h"

NS_ASSUME_NONNULL_BEGIN

@interface VEMaskPasterView (Quadrilateral)

-(void)initQuadrilateral:(float) CenterHeight atWidth:(float) CenterWidth;

-(void)setCenterView_Quadrilateral;

-(void)setFillet_ImageViewCenter;
-(void)setQuadrilateralCenterPoint:( BOOL ) isMove;
-(void)setRotate_ImageViewCenter;
-(void)setFrameCurrentscale:(float)value;
@end

NS_ASSUME_NONNULL_END
