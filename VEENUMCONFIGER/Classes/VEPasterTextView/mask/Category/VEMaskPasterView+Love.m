//
//  VEMaskPasterView+Love.m
//  libVEDeluxe
//
//  Created by iOS VESDK Team on 2020/10/29.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEMaskPasterView+Love.h"
#import "VEOvalView.h"

@interface VEMaskPasterView (Love)<UIGestureRecognizerDelegate>

@end

@implementation VEMaskPasterView (Love)

-(void)initLove:(float) CenterHeight atWidth:(float) CenterWidth
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RoundnessHeight + CenterWidth + (btnWidth+intervalWidth)*2.0, RoundnessHeight + CenterHeight + (btnWidth+intervalWidth)*2.0)];    [self addSubview:view];
    self.loveView = view;
    self.curretnView = view;
    
    UIPanGestureRecognizer* centreImageViewMoveGesture1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(centreImageViewMoveGesture_Love:)];
    centreImageViewMoveGesture1.delegate = self;
    [self addGestureRecognizer:centreImageViewMoveGesture1];
    
    {
        UIView * view = [[VEOvalView alloc] initWithFrame:CGRectMake( (self.curretnView.frame.size.width - (RoundnessHeight + 60))/2.0, (self.curretnView.frame.size.height - (RoundnessHeight + 60))/2.0, RoundnessHeight + 60, RoundnessHeight + 60) atType:VEMaskType_LOVE atColor:self.mainColor];
        view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
//        view.layer.borderColor =  self.mainColor.CGColor;
//        view.layer.borderWidth = 1.5;
        self.loveCenterView = view;
        self.curretnCenterView = view;
        
        [self.loveView addSubview:self.loveCenterView];
        
//        self.centreImageView.frame = CGRectMake( (self.loveCenterView.frame.size.width - RoundnessHeight)/2.0, (self.loveCenterView.frame.size.height - RoundnessHeight)/2.0, RoundnessHeight, RoundnessHeight);
        self.centreImageView.frame = CGRectMake( (self.loveCenterView.frame.size.width - 10.0)/2.0, (self.loveCenterView.frame.size.height - 10.0)/2.0, 10.0, 10.0);
    }
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( (self.curretnView.frame.size.width - btnWidth)/2.0, self.curretnView.frame.size.height - btnWidth, btnWidth, btnWidth)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin ;
        imageView.backgroundColor = [UIColor clearColor];
        if( [self.bundleStr isEqualToString:@"VEPESDK"] )
        {
            imageView.image = [VEHelp imageNamed:@"/PESDKImage/PESDK_蒙版旋转@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
        }
        else
            imageView.image = [VEHelp imageNamed:@"New_EditVideo/mask/剪辑_剪辑蒙版旋转_"];
        imageView.userInteractionEnabled = YES;
        [self.curretnView addSubview:imageView];
        self.rotate_ImageView = imageView;
        
        UIPanGestureRecognizer* rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture_Love:)];
        rotateGesture.delegate = self;
        [self.rotate_ImageView  addGestureRecognizer:rotateGesture];
    }
    
    CGPoint point = self.currentMultiTrackPasterTextView.center;
    self.curretnView.center = point;
    
    UIPinchGestureRecognizer *GestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer_Love:)];
    [self addGestureRecognizer:GestureRecognizer];
    GestureRecognizer.delegate = self;

    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(Rotation_GestureRecognizer_Love:)];
    //手势View 对象 添加给UIImageView
    [self addGestureRecognizer:rotation];
    rotation.delegate = self;
}

//MARK: 平移
- (void) centreImageViewMoveGesture_Love:(UIGestureRecognizer *) recognizer{

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
//MARK: 拖拽旋转
- (void) rotateGesture_Love:(UIPanGestureRecognizer *) recognizer{

    touchLocation = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        currentCenter = self.loveCenterView.center;
        currentCenter = [self.curretnView convertPoint:currentCenter toView:self];
        deltaAngle      =
              - VECGAffineTransformGetAngle(self.curretnView.transform);
        beganLocation = touchLocation;
        
        beginningWidth =  VECGPointGetDistance([recognizer locationInView:self],self.curretnView.center);
        beginningPinch_x = self.loveCenterView.frame.size.width/2.0;
        beginningPinch_y = self.loveCenterView.frame.size.height/2.0;
    } else if ( (recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded) ) {
        float width =  VECGPointGetDistance([recognizer locationInView:self],self.curretnView.center) - beginningWidth;
        float height = 0;
        if( beginningPinch_x >= beginningPinch_y )
        {
            width = beginningPinch_x + width;
            width = width*2.0;
            height = (beginningPinch_y/beginningPinch_x)*width;
        }
        else
        {
            height = beginningPinch_y + width;
            height = height*2.0;
            width = (beginningPinch_x/beginningPinch_y)*height;
        }
        
        if( width < RoundnessHeight )
        {
            width = RoundnessHeight;
            height = (beginningPinch_y/beginningPinch_x)*width;
        }
        
        if( height <  RoundnessHeight )
        {
            height = RoundnessHeight;
            width = (beginningPinch_x/beginningPinch_y)*height;
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
        self.curretnView.frame = CGRectMake(0, 0, width+(btnWidth+intervalWidth)*2.0, height + (btnWidth+intervalWidth)*2.0);
        self.curretnView.center = center;
        
        self.loveCenterView .frame = CGRectMake( (self.curretnView.frame.size.width - width)/2.0, (self.curretnView.frame.size.height - height)/2.0, width, height);
        [self setCenterView_Love];
        self.curretnView.transform = CGAffineTransformMakeRotation(-angleDiff);
    }
    if( self.delegate && [self.delegate respondsToSelector:@selector(dragAndRotate_MaskPasterView:)] )
    {
        [self.delegate dragAndRotate_MaskPasterView:self];
    }
}
//MARK: 两指旋转
-(void)Rotation_GestureRecognizer_Love:(UIRotationGestureRecognizer *)rotation
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
            self.curretnView.transform = CGAffineTransformMakeRotation(-angleDiff);
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
//MARK: 两指缩放
- (void)pinchGestureRecognizer_Love:(UIPinchGestureRecognizer *)recognizer {
    
    if( recognizer  .numberOfTouches == 1 )
    {
        return;
    }
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        {
            deltaAngle      = -VECGAffineTransformGetAngle(self.curretnView.transform);
            beginningWidth =  VECGPointGetDistance([recognizer locationOfTouch:0 inView:self],[recognizer locationOfTouch:1 inView:self]);
            beginningPinch_x = self.loveCenterView.frame.size.width/2.0;
            beginningPinch_y = self.loveCenterView.frame.size.height/2.0;
        }
            break;
        case UIGestureRecognizerStateChanged://缩放改变
        {
            float width =  VECGPointGetDistance([recognizer locationOfTouch:0 inView:self],[recognizer locationOfTouch:1 inView:self]) - beginningWidth;
            float height = 0;
            if( beginningPinch_x >= beginningPinch_y )
            {
                width = beginningPinch_x + width;
                width = width*2.0;
                height = (beginningPinch_y/beginningPinch_x)*width;
            }
            else
            {
                height = beginningPinch_y + width;
                height = height*2.0;
                width = (beginningPinch_x/beginningPinch_y)*height;
            }
            
            if( width < RoundnessHeight )
            {
                width = RoundnessHeight;
                height = (beginningPinch_y/beginningPinch_x)*width;
            }
            
            if( height <  RoundnessHeight )
            {
                height = RoundnessHeight;
                width = (beginningPinch_x/beginningPinch_y)*height;
            }
            
            self.curretnView.transform = CGAffineTransformMakeRotation(-0);
            CGPoint center = self.curretnView.center;
            self.curretnView.frame = CGRectMake(0, 0, width+(btnWidth+intervalWidth)*2.0, height + (btnWidth+intervalWidth)*2.0);
            self.curretnView.center = center;
            
            self.loveCenterView .frame = CGRectMake( (self.curretnView.frame.size.width - width)/2.0, (self.curretnView.frame.size.height - height)/2.0, width, height);
            
            [self setCenterView_Love];
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

-(void)setCenterView_Love
{
//    self.centreImageView.frame = CGRectMake( (self.loveCenterView.frame.size.width - RoundnessHeight)/2.0, (self.loveCenterView.frame.size.height - RoundnessHeight)/2.0, RoundnessHeight, RoundnessHeight);
    self.centreImageView.frame = CGRectMake( (self.loveCenterView.frame.size.width - 10.0)/2.0, (self.loveCenterView.frame.size.height - 10.0)/2.0, 10.0, 10.0);
    self.rotate_ImageView.frame = CGRectMake( (self.curretnView.frame.size.width - btnWidth)/2.0, self.curretnView.frame.size.height - btnWidth, btnWidth, btnWidth);
    
    [((VEOvalView*)self.loveCenterView) setNeedsDisplay];
}

@end
