//
//  VEMaskPasterView+Linnear.m
//  libVEDeluxe
//
//  Created by iOS VESDK Team on 2020/10/28.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEMaskPasterView+Linnear.h"

@interface VEMaskPasterView (Linnear)<UIGestureRecognizerDelegate>

@end


@implementation VEMaskPasterView (Linnear)

-(void)initLinnear:(float) height atHeight:(float) CenterHeight atWidth:(float) CenterWidth
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*3, height + (intervalWidth+btnWidth)*2.0)];
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, (height - 1.5)/2.0 + (intervalWidth+btnWidth), (view.frame.size.width - height)/2.0, 1.5)];
//        label.backgroundColor =  self.mainColor;
        [view addSubview:label];
    }
    {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake((view.frame.size.width - height)/2.0+height, (height - 1.5)/2.0 + (intervalWidth+btnWidth), (view.frame.size.width - height)/2.0, 1.5)];
//        label.backgroundColor =  self.mainColor;
        [view addSubview:label];
    }
    self.linnearView = view;
    [self addSubview:view];
    self.curretnView = view;
    
    UIPanGestureRecognizer* centreImageViewMoveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(centreImageViewMoveGesture_Linnear:)];
    centreImageViewMoveGesture.delegate = self;
    [self.centreImageView addGestureRecognizer:centreImageViewMoveGesture];
    
    UIPanGestureRecognizer* linnearViewMoveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(centreImageViewMoveGesture_Linnear:)];
    linnearViewMoveGesture.delegate = self;
    [self addGestureRecognizer:linnearViewMoveGesture];
    
    [linnearViewMoveGesture requireGestureRecognizerToFail:centreImageViewMoveGesture];//优先识别rotateGesture手势
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(Rotation_GestureRecognizer_Linnear:)];
    //手势View 对象 添加给UIImageView
    [self addGestureRecognizer:rotation];
    [centreImageViewMoveGesture requireGestureRecognizerToFail:rotation];
    
    self.centreImageView.frame = CGRectMake( (self.curretnView.frame.size.width - height)/2.0,  (intervalWidth+btnWidth), height, height);
    
    CGPoint point = self.currentMultiTrackPasterTextView.center;
    self.curretnView.center = point;
    
    UIImageView * rotateView = [[UIImageView alloc] initWithFrame:CGRectMake((self.curretnView.frame.size.width - btnWidth)/2.0, height + (intervalWidth+btnWidth) + intervalWidth, btnWidth, btnWidth)];
    rotateView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin ;
    rotateView.backgroundColor = [UIColor clearColor];
    if( [self.bundleStr isEqualToString:@"VEPESDK"] )
    {
        rotateView.image = [VEHelp imageNamed:@"/PESDKImage/PESDK_蒙版旋转@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
    }
    else
        rotateView.image = [VEHelp imageNamed:@"New_EditVideo/mask/剪辑_剪辑蒙版旋转_"];
    rotateView.userInteractionEnabled = YES;
    [self.linnearView addSubview:rotateView];
    
    UIPanGestureRecognizer* rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture_Linnear:)];
    rotateGesture.delegate = self;
    [rotateView addGestureRecognizer:rotateGesture];
    [rotation requireGestureRecognizerToFail:rotateGesture];
}

#pragma mark- 线性
//MARK: 平移
- (void) centreImageViewMoveGesture_Linnear:(UIGestureRecognizer *) recognizer{

    if( recognizer.numberOfTouches == 2 )
    {
        return;
    }
    
    touchLocation = [recognizer locationInView:self.superview];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        beginningPoint = touchLocation;
        beginningCenter = self.curretnView.center;
        [self setCenterPoint];
        beginBounds = self.curretnView.bounds;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        [self setCenterPoint];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded){
        [self setCenterPoint];
    }
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(movement_MaskPasterView:)] )
    {
        [self.delegate movement_MaskPasterView:self];
    }
}

//MARK: 两指旋转
-(void)Rotation_GestureRecognizer_Linnear:(UIRotationGestureRecognizer *)rotation
{
    if( rotation.numberOfTouches == 1 )
    {
        return;
    }
    touchLocation = [rotation locationInView:self.superview];
    
    switch (rotation.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        {
            deltaAngle      = -VECGAffineTransformGetAngle(self.curretnView.transform);
            beginAngle      = rotation.rotation;
        }
            break;
        case UIGestureRecognizerStateChanged://缩放改变
        case UIGestureRecognizerStateEnded://缩放结束
        {
            float angleDiff = ( deltaAngle + (beginAngle - rotation.rotation) );
            if( ((-angleDiff) < 0.1) && ((-angleDiff) >= -0.1)  )
            {
                angleDiff = 0;
                if( isShock )
                {
                    AudioServicesPlaySystemSound(1519);
                    isShock = false;
                }
            }
            else
            {
                isShock = true;
            }
            self.curretnView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-angleDiff), 1.0, 1.0);
        }
            break;
        default:
            break;
    }
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(two_fingerRotation_MaskPasterView:)] )
    {
        [self.delegate two_fingerRotation_MaskPasterView:self];
    }
}
//MARK: 拖拽旋转
- (void) rotateGesture_Linnear:(UIGestureRecognizer *) recognizer{

    touchLocation = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        currentCenter = self.centreImageView.center;
        currentCenter = [self.curretnView convertPoint:currentCenter toView:self];
        deltaAngle      =
              - VECGAffineTransformGetAngle(self.curretnView.transform);
        beganLocation = touchLocation;
    } else if ( (recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded) ) {
        float ang =
        -atan2(beganLocation.y-currentCenter.y, beganLocation.x-currentCenter.x) + atan2(touchLocation.y-currentCenter.y, touchLocation.x-currentCenter.x);
        
        float angleDiff = deltaAngle - ang;
        if( ((-angleDiff) < 0.1) && ((-angleDiff) >= -0.1)  )
        {
            angleDiff = 0;
            if( isShock )
            {
                AudioServicesPlaySystemSound(1519);
                isShock = false;
            }
        }
        else
        {
            isShock = true;
        }
        
        self.curretnView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-angleDiff), 1.0, 1.0);
        
        self.curretnView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-angleDiff), 1.0, 1.0);
    }
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(dragAndRotate_MaskPasterView:)] )
    {
        [self.delegate dragAndRotate_MaskPasterView:self];
    }
}

@end
