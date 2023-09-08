//
//  VEMaskPasterView+MirrorSurface.m
//  libVEDeluxe
//
//  Created by iOS VESDK Team on 2020/10/28.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEMaskPasterView+MirrorSurface.h"

@interface VEMaskPasterView (MirrorSurface)<UIGestureRecognizerDelegate>

@end

@implementation VEMaskPasterView (MirrorSurface)

-(void)initMirrorSuface:(float) height atHeight:(float) CenterHeight atWidth:(float) CenterWidth
{
    {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*3, height + CenterHeight + (btnWidth+intervalWidth)*2.0)];
        self.mirrorSurfaceView = view;
        self.curretnView = view;
        [self addSubview:view];
    }
    
    UIPanGestureRecognizer* centreImageViewMoveGesture1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(centreImageViewMoveGesture_MirrorSurface:)];
    centreImageViewMoveGesture1.delegate = self;
    [self addGestureRecognizer:centreImageViewMoveGesture1];
    
//    UIPanGestureRecognizer* centreImageViewMoveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(centreImageViewMoveGesture_MirrorSurface:)];
    
    {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake( 0, (self.curretnView.frame.size.height - (height + 30))/2.0, self.frame.size.width*3.0, height + 30)];
        view.layer.borderColor =  self.mainColor.CGColor;
        view.layer.borderWidth = 1.5;
        self.mirrorSurfaceCenterView = view;
        
        [self.mirrorSurfaceView addSubview:self.mirrorSurfaceCenterView];
        self.curretnCenterView = view;
//        [self.centreImageView addGestureRecognizer:centreImageViewMoveGesture];
        
//        [centreImageViewMoveGesture1 requireGestureRecognizerToFail:centreImageViewMoveGesture];
        
        self.centreImageView.frame = CGRectMake( (self.mirrorSurfaceCenterView.frame.size.width - height)/2.0, (self.mirrorSurfaceCenterView.frame.size.height - height)/2.0, height, height);
    }
    
    CGPoint point = self.currentMultiTrackPasterTextView.center;
    point.y = point.y + ( (self.curretnView.frame.size.height/2.0 - self.mirrorSurfaceCenterView.center.y) );
    self.curretnView.center = point;
    
    UIPinchGestureRecognizer *GestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer_MirrorSurface:)];
    [self addGestureRecognizer:GestureRecognizer];
    GestureRecognizer.delegate = self;
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(Rotation_GestureRecognizer_MirrorSurface:)];
    //手势View 对象 添加给UIImageView
    [self addGestureRecognizer:rotation];
    rotation.delegate = self;
//    [centreImageViewMoveGesture1 requireGestureRecognizerToFail:rotation];
    
    UIImageView * rotateView = [[UIImageView alloc] initWithFrame:CGRectMake((self.curretnView.frame.size.width - btnWidth)/2.0, self.curretnView.frame.size.height - btnWidth, btnWidth, btnWidth)];
    self.rotate_ImageView = rotateView;
    rotateView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin ;
    rotateView.backgroundColor = [UIColor clearColor];
    if( [self.bundleStr isEqualToString:@"VEPESDK"] )
    {
        rotateView.image = [VEHelp imageNamed:@"/PESDKImage/PESDK_蒙版旋转@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
    }
    else
        rotateView.image = [VEHelp imageNamed:@"New_EditVideo/mask/剪辑_剪辑蒙版旋转_"];
    rotateView.userInteractionEnabled = YES;
    [self.curretnView addSubview:rotateView];
    
    UIPanGestureRecognizer* rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture_MirrorSurface:)];
    rotateGesture.delegate = self;
    [rotateView addGestureRecognizer:rotateGesture];
    
//    [rotation requireGestureRecognizerToFail:rotateGesture];
    
    
}

//MARK: 平移
- (void) centreImageViewMoveGesture_MirrorSurface:(UIGestureRecognizer *) recognizer{

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
-(void)Rotation_GestureRecognizer_MirrorSurface:(UIRotationGestureRecognizer *)rotation
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
- (void) rotateGesture_MirrorSurface:(UIGestureRecognizer *) recognizer{

    touchLocation = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        currentCenter = self.mirrorSurfaceCenterView.center;
        currentCenter = [self.curretnView convertPoint:currentCenter toView:self];
        deltaAngle      =
              - VECGAffineTransformGetAngle(self.curretnView.transform);
        beganLocation = touchLocation;
        
        beginningWidth =  VECGPointGetDistance([recognizer locationInView:self],self.curretnView.center);
        beginningPinch_x = self.mirrorSurfaceCenterView.frame.size.height/2.0;
        
    } else if ( (recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded) ) {
        
        float width =  VECGPointGetDistance([recognizer locationInView:self],self.curretnView.center) - beginningWidth;
        
        width = beginningPinch_x + width;
        
        width = width*2.0;
        
        if( width < RoundnessHeight )
        {
            width = RoundnessHeight;
        }
        
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
        
        self.curretnView.transform = CGAffineTransformMakeRotation(-0);
        CGPoint center = self.curretnView.center;
        self.curretnView.frame = CGRectMake(0, 0, self.frame.size.width*3, width + (btnWidth+intervalWidth)*2.0);
        self.curretnView.center = center;
        
        self.mirrorSurfaceCenterView .frame = CGRectMake( 0, (self.curretnView.frame.size.height - width)/2.0, self.frame.size.width*3.0, width);
//        self.centreImageView.frame = CGRectMake( (self.mirrorSurfaceCenterView.frame.size.width - RoundnessHeight)/2.0, (self.mirrorSurfaceCenterView.frame.size.height - RoundnessHeight)/2.0, RoundnessHeight, RoundnessHeight);
        self.centreImageView.frame = CGRectMake( (self.mirrorSurfaceCenterView.frame.size.width - 10.0)/2.0, (self.mirrorSurfaceCenterView.frame.size.height - 10.0)/2.0, 10.0, 10.0);
        self.rotate_ImageView.frame = CGRectMake( (self.curretnView.frame.size.width - btnWidth)/2.0, self.curretnView.frame.size.height - btnWidth, btnWidth, btnWidth);
        self.curretnView.transform = CGAffineTransformMakeRotation(-angleDiff);
    }
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(dragAndRotate_MaskPasterView:)] )
    {
        [self.delegate dragAndRotate_MaskPasterView:self];
    }
}
//MARK: 两指缩放
- (void)pinchGestureRecognizer_MirrorSurface:(UIPinchGestureRecognizer *)recognizer {
    
    if( recognizer.numberOfTouches == 1 )
    {
        return;
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        {
            deltaAngle      = -VECGAffineTransformGetAngle(self.curretnView.transform);
            beginningWidth =  VECGPointGetDistance([recognizer locationOfTouch:0 inView:self],[recognizer locationOfTouch:1 inView:self]);
            beginningPinch_x = self.mirrorSurfaceCenterView.frame.size.height;
        }
            break;
        case UIGestureRecognizerStateChanged://缩放改变
        {
            float width =  VECGPointGetDistance([recognizer locationOfTouch:0 inView:self],[recognizer locationOfTouch:1 inView:self]) - beginningWidth;
            
            width = beginningPinch_x + width;
            
            if( width < RoundnessHeight )
            {
                width = RoundnessHeight;
            }
            
            self.curretnView.transform = CGAffineTransformMakeRotation(-0);
            CGPoint center = self.curretnView.center;
            self.curretnView.frame = CGRectMake(0, 0, self.frame.size.width*3, width + (btnWidth+intervalWidth)*2.0);
            self.curretnView.center = center;
            
            self.mirrorSurfaceCenterView .frame = CGRectMake( 0, (self.curretnView.frame.size.height - width)/2.0, self.frame.size.width*3.0, width);
//            self.centreImageView.frame = CGRectMake( (self.mirrorSurfaceCenterView.frame.size.width - RoundnessHeight)/2.0, (self.mirrorSurfaceCenterView.frame.size.height - RoundnessHeight)/2.0, RoundnessHeight, RoundnessHeight);
            self.centreImageView.frame = CGRectMake( (self.mirrorSurfaceCenterView.frame.size.width - 10.0)/2.0, (self.mirrorSurfaceCenterView.frame.size.height - 10.0)/2.0, 10.0, 10.0);
            self.rotate_ImageView.frame = CGRectMake( (self.curretnView.frame.size.width - btnWidth)/2.0, self.curretnView.frame.size.height - btnWidth, btnWidth, btnWidth);
            self.curretnView.transform = CGAffineTransformMakeRotation(-deltaAngle);
        }
            break;
        case UIGestureRecognizerStateEnded://缩放结束
            break;
            
        default:
            break;
    }
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(two_FingerZoom_MaskPasterView:)] )
    {
        [self.delegate two_FingerZoom_MaskPasterView:self];
    }
}


@end
