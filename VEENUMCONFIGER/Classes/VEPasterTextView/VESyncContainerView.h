//
//  VESyncContainerView.h
//  VE
//
//  Created by apple on 2020/1/13.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VESyncContainerView : UIView

@property(nonatomic,weak)UIImageView       *syncContainer_X_Left;
@property(nonatomic,weak)UIImageView       *syncContainer_X_Right;

@property(nonatomic,weak)UIImageView       *syncContainer_Y_Left;
@property(nonatomic,weak)UIImageView       *syncContainer_Y_Right;

@property(nonatomic, assign)BOOL               isNoPasterMidline;

@property(nonatomic,weak)UIView *currentPasterTextView;

-(void)pasterMidline:(UIView *) PasterTextView isHidden:(bool) ishidden;
-(void)setMark;

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer;

@end
