//
//  VEMaskPasterView+Rectangle.m
//  libVEDeluxe
//
//  Created by apple on 2020/10/28.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEMaskPasterView+Rectangle.h"

@interface VEMaskPasterView (Rectangle)<UIGestureRecognizerDelegate>

@end

@implementation VEMaskPasterView (Rectangle)

-(void)initRectangle:(float) CenterHeight atWidth:(float) CenterWidth
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RoundnessHeight + CenterWidth + (btnWidth+intervalWidth)*2.0, RoundnessHeight + CenterHeight + (btnWidth+intervalWidth)*2.0)];
    [self addSubview:view];
    self.rectangleView = view;
    self.curretnView = view;
    
    UIPanGestureRecognizer* centreImageViewMoveGesture1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(centreImageViewMoveGesture_Rectangle:)];
    centreImageViewMoveGesture1.delegate = self;
    [self addGestureRecognizer:centreImageViewMoveGesture1];
    
    {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake( (self.curretnView.frame.size.width - (RoundnessHeight + 60))/2.0, (self.curretnView.frame.size.height - (RoundnessHeight + 60))/2.0, RoundnessHeight + 60, RoundnessHeight + 60)];
        view.layer.borderColor =  self.mainColor.CGColor;
        view.layer.borderWidth = 1.5;
        self.rectangleViewCenterView = view;
        self.curretnCenterView = view;
        
        [self.rectangleView addSubview:self.rectangleViewCenterView];
        
        self.centreImageView.frame = CGRectMake( (self.rectangleViewCenterView.frame.size.width - RoundnessHeight)/2.0, (self.rectangleViewCenterView.frame.size.height - RoundnessHeight)/2.0, RoundnessHeight, RoundnessHeight);
    }
    
    {
        filletWidth = 0;
        
        float x = sqrt((filletWidth*filletWidth)/2.0);
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.rectangleViewCenterView.frame.origin.x - x - btnWidth + 3),(self.rectangleViewCenterView.frame.origin.y - x - btnWidth + 3),btnWidth,btnWidth)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin ;
        imageView.backgroundColor = [UIColor clearColor];
        if( [self.bundleStr isEqualToString:@"VEPESDK"] )
        {
            imageView.image = [VEHelp imageNamed:@"/PESDKImage/PESDK_蒙版圆角@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
        }
        else
            imageView.image = [VEHelp imageNamed:@"New_EditVideo/mask/剪辑_剪辑蒙版圆角_"];
        imageView.userInteractionEnabled = YES;
        [self.curretnView addSubview:imageView];
        self.fillet_ImageView = imageView;
        
        UIPanGestureRecognizer* filletGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(filletGestureGesture_Rectangle:)];
        filletGesture.delegate = self;
        [self.fillet_ImageView  addGestureRecognizer:filletGesture];
    }
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.curretnView.frame.size.width - btnWidth,(self.curretnView.frame.size.height - btnWidth)/2.0,btnWidth,btnWidth)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin ;
        imageView.backgroundColor = [UIColor clearColor];
        if( [self.bundleStr isEqualToString:@"VEPESDK"] )
        {
            imageView.image = [VEHelp imageNamed:@"/PESDKImage/PESDK_蒙版左右@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
        }
        else
            imageView.image = [VEHelp imageNamed:@"New_EditVideo/mask/剪辑_剪辑蒙版左右拉伸_"];
        imageView.userInteractionEnabled = YES;
        [self.curretnView addSubview:imageView];
        self.level_ImageView = imageView;

        UIPanGestureRecognizer* levelGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(levelGestureGesture_Rectangle:)];
        levelGesture.delegate = self;
        [self.level_ImageView  addGestureRecognizer:levelGesture];
    }
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.curretnView.frame.size.width - btnWidth)/2.0,0,btnWidth,btnWidth)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin ;
        imageView.backgroundColor = [UIColor clearColor];
        if( [self.bundleStr isEqualToString:@"VEPESDK"] )
        {
            imageView.image = [VEHelp imageNamed:@"/PESDKImage/PESDK_蒙版上下拖动@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
        }
        else
            imageView.image = [VEHelp imageNamed:@"New_EditVideo/mask/剪辑_剪辑蒙版上下拉升_@3x"];
        imageView.userInteractionEnabled = YES;
        [self.curretnView addSubview:imageView];
        self.vertical_ImageView = imageView;

        UIPanGestureRecognizer* verticalGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(verticalGesture_Rectangle:)];
        verticalGesture.delegate = self;
        [self.vertical_ImageView  addGestureRecognizer:verticalGesture];
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
        
        UIPanGestureRecognizer* rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture_Rectangle:)];
        rotateGesture.delegate = self;
        [self.rotate_ImageView  addGestureRecognizer:rotateGesture];
        
    }
    
    CGPoint point = self.currentMultiTrackPasterTextView.center;
    self.curretnView.center = point;
    
    UIPinchGestureRecognizer *GestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer_Rectangle:)];
    [self addGestureRecognizer:GestureRecognizer];
    GestureRecognizer.delegate = self;

    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(Rotation_GestureRecognizer_Rectangle:)];
    //手势View 对象 添加给UIImageView
    [self addGestureRecognizer:rotation];
    rotation.delegate = self;
}

//MARK: 平移
- (void) centreImageViewMoveGesture_Rectangle:(UIGestureRecognizer *) recognizer{

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
-(void)Rotation_GestureRecognizer_Rectangle:(UIRotationGestureRecognizer *)rotation
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
//MARK: 拖拽旋转
- (void) rotateGesture_Rectangle:(UIPanGestureRecognizer *) recognizer{

    touchLocation = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        currentCenter = self.rectangleViewCenterView.center;
        currentCenter = [self.curretnView convertPoint:currentCenter toView:self];
        deltaAngle      =
              - VECGAffineTransformGetAngle(self.curretnView.transform);
        beganLocation = touchLocation;
        
        beginningWidth =  VECGPointGetDistance([recognizer locationInView:self],self.curretnView.center);
        beginningPinch_x = self.rectangleViewCenterView.frame.size.width/2.0;
        beginningPinch_y = self.rectangleViewCenterView.frame.size.height/2.0;
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
        
        self.rectangleViewCenterView .frame = CGRectMake( (self.curretnView.frame.size.width - width)/2.0, (self.curretnView.frame.size.height - height)/2.0, width, height);
        [self setCenterView_Rectangle];
        self.curretnView.transform = CGAffineTransformMakeRotation(-angleDiff);
    }
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(dragAndRotate_MaskPasterView:)] )
    {
        [self.delegate dragAndRotate_MaskPasterView:self];
    }
}
//MARK: 两指缩放
- (void)pinchGestureRecognizer_Rectangle:(UIPinchGestureRecognizer *)recognizer {
    
    if( recognizer.numberOfTouches == 1 )
    {
        return;
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        {
            deltaAngle      = -VECGAffineTransformGetAngle(self.curretnView.transform);
            beginningWidth =  VECGPointGetDistance([recognizer locationOfTouch:0 inView:self],[recognizer locationOfTouch:1 inView:self]);
            beginningPinch_x = self.rectangleViewCenterView.frame.size.width/2.0;
            beginningPinch_y = self.rectangleViewCenterView.frame.size.height/2.0;
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
            
            self.rectangleViewCenterView .frame = CGRectMake( (self.curretnView.frame.size.width - width)/2.0, (self.curretnView.frame.size.height - height)/2.0, width, height);
            
            [self setCenterView_Rectangle];
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

//MARK: 左右拉伸
- (void) levelGestureGesture_Rectangle:(UIPanGestureRecognizer *) recognizer{

    touchLocation = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        currentCenter = self.rectangleViewCenterView.center;
        currentCenter = [self.curretnView convertPoint:currentCenter toView:self];
        deltaAngle      =
              - VECGAffineTransformGetAngle(self.curretnView.transform);
        beganLocation = touchLocation;
    
        beginningWidth =  VECGPointGetDistance([recognizer locationInView:self],self.curretnView.center);
        beginningPinch_x = self.rectangleViewCenterView.frame.size.width/2.0;
    } else if ( (recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded) ) {
        float width =  VECGPointGetDistance([recognizer locationInView:self],self.curretnView.center) - beginningWidth;
        
        width = width+beginningPinch_x;
        
        width = width*2.0;
        
        if( width < RoundnessHeight )
        {
            width = RoundnessHeight;
        }
        
        self.curretnView.transform = CGAffineTransformMakeRotation(-0);
        CGPoint center = self.curretnView.center;
        self.curretnView.frame = CGRectMake(0, 0, width+(btnWidth+intervalWidth)*2.0, self.curretnView.frame.size.height);
        self.curretnView.center = center;
        
        self.rectangleViewCenterView .frame = CGRectMake( (self.curretnView.frame.size.width - width)/2.0, (self.curretnView.frame.size.height - self.rectangleViewCenterView .frame.size.height)/2.0, width, self.rectangleViewCenterView .frame.size.height);
        [self setCenterView_Rectangle];
        self.curretnView.transform = CGAffineTransformMakeRotation(-deltaAngle);
    }
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(leftAndRightStretch_MaskPasterView:)] )
    {
        [self.delegate leftAndRightStretch_MaskPasterView:self];
    }
}
//MARK: 上下拉伸
- (void) verticalGesture_Rectangle:(UIGestureRecognizer *) recognizer{

    touchLocation = [recognizer locationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        currentCenter = self.rectangleViewCenterView.center;
        currentCenter = [self.curretnView convertPoint:currentCenter toView:self];
        deltaAngle      =
              - VECGAffineTransformGetAngle(self.curretnView.transform);
        beganLocation = touchLocation;
        
        beginningWidth =  VECGPointGetDistance([recognizer locationInView:self],self.curretnView.center);
        beginningPinch_y = self.rectangleViewCenterView.frame.size.height/2.0;
        
    } else if ( (recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded) ) {
        
        float height = VECGPointGetDistance([recognizer locationInView:self],self.curretnView.center) - beginningWidth;
        
        height = beginningPinch_y + height;
        
        height = height*2.0;
        
        if( height < RoundnessHeight )
        {
            height = RoundnessHeight;
        }
        
        self.curretnView.transform = CGAffineTransformMakeRotation(-0);
        CGPoint center = self.curretnView.center;
        self.curretnView.frame = CGRectMake(0, 0, self.curretnView.frame.size.width, height + (btnWidth+intervalWidth)*2.0);
        self.curretnView.center = center;
        
        self.rectangleViewCenterView.frame = CGRectMake( (self.curretnView.frame.size.width - self.rectangleViewCenterView.frame.size.width)/2.0, (self.curretnView.frame.size.height - height)/2.0, self.rectangleViewCenterView.frame.size.width, height);
        [self setCenterView_Rectangle];
        
        self.curretnView.transform = CGAffineTransformMakeRotation(-deltaAngle);
    }
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(stretchUpAndDown_MaskPasterView:)] )
    {
        [self.delegate stretchUpAndDown_MaskPasterView:self];
    }
}

//MARK: 圆角
- (void) filletGestureGesture_Rectangle:(UIGestureRecognizer *) recognizer{

    touchLocation = [recognizer locationInView:self.curretnView];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        beganLocation = touchLocation;
        beginningWidth =  touchLocation.y;
    } else if ( (recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded)  ) {
        
        float cornerRadiusHeight = touchLocation.y - beganLocation.y;
        float cornerRadiusWidth = touchLocation.x - beganLocation.x;
        float cornerRadius = cornerRadiusHeight;
        
        if( fabsf(cornerRadiusWidth) > fabsf(cornerRadiusHeight) )
        {
            cornerRadius = cornerRadiusWidth;
        }
        
        cornerRadius = filletWidth - cornerRadius;
        
        if( cornerRadius > (btnWidth/2.0+3) )
        {
            cornerRadius = (btnWidth/2.0+3);
        }
        else if( cornerRadius < 0 )
        {
            cornerRadius = 0;
        }
        
        filletWidth = cornerRadius;
        
        float x = sqrt((cornerRadius*cornerRadius)/2.0)/sqrt((btnWidth/2.0+3)*(btnWidth/2.0+3)/2.0);
        
        self.fillet_ImageView.frame = CGRectMake((self.rectangleViewCenterView.frame.origin.x - filletWidth + 3 - btnWidth),(self.rectangleViewCenterView.frame.origin.y - filletWidth + 3  - btnWidth),btnWidth,btnWidth);
        
        
        
        if( self.delegate && [self.delegate respondsToSelector:@selector(fillet_MaskPasterView_Quadrilateral:atCornerRadius:)] )
        {
            [self.delegate fillet_MaskPasterView_Quadrilateral:self atCornerRadius:x];
        }
        
        beganLocation = touchLocation;
    }
    
    
}


-(void)setCenterView_Rectangle
{
    self.centreImageView.frame = CGRectMake( (self.rectangleViewCenterView.frame.size.width - RoundnessHeight)/2.0, (self.rectangleViewCenterView.frame.size.height - RoundnessHeight)/2.0, RoundnessHeight, RoundnessHeight);
    
    self.fillet_ImageView.frame = CGRectMake((self.rectangleViewCenterView.frame.origin.x - filletWidth + 3  - btnWidth),(self.rectangleViewCenterView.frame.origin.y - filletWidth + 3  - btnWidth),btnWidth,btnWidth);
    
    self.level_ImageView.frame = CGRectMake(self.curretnView.frame.size.width - btnWidth,(self.curretnView.frame.size.height - btnWidth)/2.0,btnWidth,btnWidth);
    self.vertical_ImageView.frame = CGRectMake((self.curretnView.frame.size.width - btnWidth)/2.0,0,btnWidth,btnWidth);
    self.rotate_ImageView.frame = CGRectMake( (self.curretnView.frame.size.width - btnWidth)/2.0, self.curretnView.frame.size.height - btnWidth, btnWidth, btnWidth);
    
    float width = self.rectangleViewCenterView.frame.size.width;
    float height = self.rectangleViewCenterView.frame.size.height;
    
    float  cornerRadius = 0;
    
    if( width >= height )
    {
        cornerRadius = height/3.0*( filletWidth/10.0 );
    }
    else
    {
        cornerRadius = width/3.0*( filletWidth/10.0 );
    }
    
    self.rectangleViewCenterView.layer.cornerRadius = cornerRadius;
}
@end
