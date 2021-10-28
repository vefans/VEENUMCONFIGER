//
//  VEMaskPasterView+Quadrilateral.m
//  libVEDeluxe
//
//  Created by apple on 2020/10/28.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEMaskPasterView+Quadrilateral.h"
//#import "VEOvalView.h"

@interface VEMaskPasterView (Quadrilateral)<UIGestureRecognizerDelegate>

@end

@implementation VEMaskPasterView (Quadrilateral)

-(void)initQuadrilateral:(float) CenterHeight atWidth:(float) CenterWidth
{
    UIPanGestureRecognizer* centreImageViewMoveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(centreImageViewMoveGesture_Quadrilateral:)];
    centreImageViewMoveGesture.delegate = self;
    [self addGestureRecognizer:centreImageViewMoveGesture];
    
    self.centreImageView.frame = CGRectMake( (self.frame.size.width - 10.0)/2.0, (self.frame.size.height - 10.0)/2.0, 10.0, 10.0);
    
    CGPoint point = self.currentMultiTrackPasterTextView.center;
    self.centreImageView.center = point;
    
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width*2.0,  self.bounds.size.height*2.0)];
        imageView.center = point;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        self.curretnView = imageView;
        
        [self addSubview:imageView];
    }
    
    btnWidth = 30;
    //左上
    {
        {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( self.curretnView.bounds.size.width/2.0 - 0.25*CenterWidth - btnWidth/2.0, self.curretnView.bounds.size.height/2.0 - 0.25*CenterHeight - btnWidth/2.0, 0.25*CenterWidth + btnWidth, 0.25*CenterHeight + btnWidth)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.userInteractionEnabled = NO;
            [self.curretnView addSubview:imageView];
            self.topLeftRectangleImageView = imageView;
        }
        self.topLeftImageView = [self getAntennaImageView:CGRectMake(0,0,btnWidth,btnWidth) atQuadrilateral:self.topLeftRectangleImageView atSelect:@selector(topLeft_Quadrilateral:)];
        
        CGPoint point = self.topLeftRectangleImageView.frame.origin;
//        point = [self.curretnView convertPoint:point toView:self];
        self.topLeftImageView.center = CGPointMake(point.x + btnWidth/2.0, point.y + btnWidth/2.0);
    }
    
    //圆角
    {
        {
            filletWidth = 0;
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.rectangleViewCenterView.frame.origin.x - btnWidth - 2),(self.rectangleViewCenterView.frame.origin.y - btnWidth - 2),btnWidth,btnWidth)];
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
            
            UIPanGestureRecognizer* filletGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(filletGestureGesture_Quadrilateral:)];
            filletGesture.delegate = self;
            [self.fillet_ImageView  addGestureRecognizer:filletGesture];
                        
            [self setFillet_ImageViewCenter];
        }
    }
    
    //左下
    {
        {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.curretnView.bounds.size.width/2.0 - 0.25*CenterWidth - btnWidth/2.0, self.curretnView.bounds.size.height/2.0 - btnWidth/2.0, 0.25*CenterWidth + btnWidth, 0.25*CenterHeight + btnWidth)];
            imageView.userInteractionEnabled = NO;
            imageView.backgroundColor = [UIColor clearColor];
            [self.curretnView addSubview:imageView];
            self.bottomLeftRectangleImageView = imageView;
        }
        self.bottomLeftImageView = [self getAntennaImageView:CGRectMake(0,0,btnWidth,btnWidth)
                                             atQuadrilateral:self.bottomLeftRectangleImageView atSelect:@selector(bottomLeft_Quadrilateral:)];
        
        CGPoint point = CGPointMake(self.bottomLeftRectangleImageView.frame.origin.x, self.bottomLeftRectangleImageView.frame.size.height+self.bottomLeftRectangleImageView.frame.origin.y);
        self.bottomLeftImageView.center = CGPointMake(point.x + btnWidth/2.0, point.y -  btnWidth/2.0);
    }
    //右上
    {
        {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( self.curretnView.bounds.size.width/2.0 - btnWidth/2.0, self.curretnView.bounds.size.height/2.0 - 0.25*CenterHeight - btnWidth/2.0,  0.25*CenterWidth + btnWidth, 0.25*CenterHeight + btnWidth)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.userInteractionEnabled = NO;
            [self.curretnView addSubview:imageView];
            self.topRightRectangleImageView = imageView;
        }
        self.topRightImageView = [self getAntennaImageView:CGRectMake(0,0,btnWidth,btnWidth)
                                           atQuadrilateral:self.topRightRectangleImageView atSelect:@selector(topRight_Quadrilateral:)];
        CGPoint point = CGPointMake(self.topRightRectangleImageView.frame.size.width+self.topRightRectangleImageView.frame.origin.x ,self.topRightRectangleImageView.frame.origin.y );
        self.topRightImageView.center = CGPointMake(point.x - btnWidth/2.0, point.y + btnWidth/2.0);
    }
    //右下
    {
        {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( self.curretnView.bounds.size.width/2.0 - btnWidth/2.0, self.curretnView.bounds.size.height/2.0 - btnWidth/2.0, 0.25*CenterWidth + btnWidth, 0.25*CenterHeight + btnWidth)];
            imageView.userInteractionEnabled = NO;
            imageView.backgroundColor = [UIColor clearColor];
            [self.curretnView addSubview:imageView];
            self.bottomRightRectangleImageView = imageView;
        }
        self.bottomRightImageView = [self getAntennaImageView:CGRectMake(0,0,btnWidth,btnWidth)
                                              atQuadrilateral:self.bottomRightRectangleImageView
                                                     atSelect:@selector(bottomRight_Quadrilateral:)];
        CGPoint point = CGPointMake(self.bottomRightRectangleImageView.frame.size.width+self.bottomRightRectangleImageView.frame.origin.x ,self.bottomRightRectangleImageView.frame.size.height+self.bottomRightRectangleImageView.frame.origin.y );
        self.bottomRightImageView.center = CGPointMake(point.x - btnWidth/2.0, point.y  - btnWidth/2.0);
    }
    
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( (self.curretnView.bounds.size.width - btnWidth)/2.0, self.curretnView.bounds.size.height - btnWidth, btnWidth, btnWidth)];
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
        
        UIPanGestureRecognizer* rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture_Quadrilateral:)];
        rotateGesture.delegate = self;
        [self.rotate_ImageView  addGestureRecognizer:rotateGesture];
        
        [self setRotate_ImageViewCenter];
    }

    UIPinchGestureRecognizer *GestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer_Quadrilateral:)];
    [self addGestureRecognizer:GestureRecognizer];
    GestureRecognizer.delegate = self;
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(Rotation_GestureRecognizer_Quadrilateral:)];
//    手势View 对象 添加给UIImageView
    [self addGestureRecognizer:rotation];
    rotation.delegate = self;
}

-(UIImageView *)getAntennaImageView:(CGRect) rect atQuadrilateral:(UIImageView *) quadrilateralImageView atSelect:(nullable SEL) select
{
    UIImageView * antennaImageView = nil;
    filletWidth = 0;
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin ;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.userInteractionEnabled = YES;
        [self.curretnView addSubview:imageView];
        antennaImageView = imageView;
    }
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((antennaImageView.frame.size.width/2.0 - 15/2.0),(antennaImageView.frame.size.height/2.0 - 15/2.0),15,15)];
        imageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        imageView.layer.borderColor = [UIColor colorWithWhite:0.89 alpha:0.9].CGColor;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.cornerRadius = 15/2.0;
        [antennaImageView addSubview:imageView];
    }
    
    UIPanGestureRecognizer* filletGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:select];
    filletGesture.delegate = self;
    [antennaImageView  addGestureRecognizer:filletGesture];
    return antennaImageView;
}

//MARK: 平移
- (void) centreImageViewMoveGesture_Quadrilateral:(UIGestureRecognizer *) recognizer{

    if( recognizer.numberOfTouches == 2 )
    {
        return;
    }
    
    touchLocation = [recognizer locationInView:self.superview];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        beginningPoint = touchLocation;
        beginningCenter = self.centreImageView.center;
//        self.topLeftPoint = self.topLeftRectangleImageView.center;
//        self.bottomLeftPoint = self.bottomLeftRectangleImageView.center;
//        self.topRightPoint = self.topRightRectangleImageView.center;
//        self.bottomRightPoint = self.bottomRightRectangleImageView.center;
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        [self setQuadrilateralCenterPoint:true];
        
        if( self.delegate && [self.delegate respondsToSelector:@selector(corner_MaskPasterView:)] )
        {
            [self.delegate corner_MaskPasterView:self];
        }
        if( self.delegate && [self.delegate respondsToSelector:@selector(movement_MaskPasterView:)] )
        {
            [self.delegate movement_MaskPasterView:self];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded){
        [self setQuadrilateralCenterPoint:true];
        
        if( self.delegate && [self.delegate respondsToSelector:@selector(corner_MaskPasterView:)] )
        {
            [self.delegate corner_MaskPasterView:self];
        }
        if( self.delegate && [self.delegate respondsToSelector:@selector(movement_MaskPasterView:)] )
        {
            [self.delegate movement_MaskPasterView:self];
        }
    }
    
    
}

-(void)setQuadrilateralCenterPoint:( BOOL ) isMove
{
    CGPoint point;
    if(  isMove )
    {
        point = CGPointMake(beginningCenter.x + (touchLocation.x - beginningPoint.x), beginningCenter.y + (touchLocation.y - beginningPoint.y));
        
        CGPoint pasterPoint = [self convertPoint:point toView:self.currentMultiTrackPasterTextView];
        
        if( pasterPoint.x < (8) )
        {
            pasterPoint.x = (8);
        }
        if( pasterPoint.x > (self.currentMultiTrackPasterTextView.bounds.size.width-8) )
        {
            pasterPoint.x = self.currentMultiTrackPasterTextView.bounds.size.width-8;
        }
        
        if( pasterPoint.y < (8) )
        {
            pasterPoint.y = (8);
        }
        if( pasterPoint.y > (self.currentMultiTrackPasterTextView.bounds.size.height-(8)) )
        {
            pasterPoint.y = self.currentMultiTrackPasterTextView.bounds.size.height-(8);
        }
        
        point = [self.currentMultiTrackPasterTextView convertPoint:pasterPoint toView:self];
        
        [self.centreImageView setCenter:point];
        [self.curretnView setCenter:point];
    }
    //左上
    {
        point = self.topLeftRectangleImageView.frame.origin;
        self.topLeftImageView.center = CGPointMake(point.x + btnWidth/2.0, point.y + btnWidth/2.0);
    }
    //左下
    {
        point = CGPointMake(self.bottomLeftRectangleImageView.frame.origin.x, self.bottomLeftRectangleImageView.frame.size.height+self.bottomLeftRectangleImageView.frame.origin.y);
        self.bottomLeftImageView.center = CGPointMake(point.x + btnWidth/2.0, point.y -  btnWidth/2.0);
    }
    //右上
    {
        point = CGPointMake(self.topRightRectangleImageView.frame.size.width+self.topRightRectangleImageView.frame.origin.x ,self.topRightRectangleImageView.frame.origin.y );
        self.topRightImageView.center = CGPointMake(point.x - btnWidth/2.0, point.y + btnWidth/2.0);
    }
    //右下
    {
        point = CGPointMake(self.bottomRightRectangleImageView.frame.size.width+self.bottomRightRectangleImageView.frame.origin.x ,self.bottomRightRectangleImageView.frame.size.height+self.bottomRightRectangleImageView.frame.origin.y );
        self.bottomRightImageView.center = CGPointMake(point.x - btnWidth/2.0, point.y  - btnWidth/2.0);
    }
}

////MARK: 两指旋转
-(void)Rotation_GestureRecognizer_Quadrilateral:(UIRotationGestureRecognizer *)rotation
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
            
            self.curretnView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-angleDiff), self.selfScale, self.selfScale);
            
            [self setQuadrilateralCenterPoint:false];
            
            [self setFillet_ImageViewCenter];
            [self setRotate_ImageViewCenter];
            
            if( self.delegate && [self.delegate respondsToSelector:@selector(corner_MaskPasterView:)] )
            {
                [self.delegate corner_MaskPasterView:self];
            }
        }
            break;
        default:
            break;
    }
}
//MARK: 拖拽旋转
- (void) rotateGesture_Quadrilateral:(UIPanGestureRecognizer *) recognizer{

    touchLocation = [recognizer locationInView:self];

    CGPoint center = VECGRectGetCenter(self.curretnView.frame);
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        deltaAngle      =  - VECGAffineTransformGetAngle(self.curretnView.transform);
        beganLocation = touchLocation;
        initialBounds   = CGRectIntegral(self.bounds);
        initialDistance = VECGPointGetDistance(center, touchLocation);
        self.oldSelfScale = self.selfScale;
    } else if ( (recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded) ) {
        float ang =
        -atan2(beganLocation.y-center.y, beganLocation.x-center.x) +
        atan2(touchLocation.y-center.y, touchLocation.x-center.x);
        
        float angleDiff = deltaAngle - ang;
        
        float oldScale = self.selfScale;
        
        self.zoomScale = VECGPointGetDistance(center, touchLocation)/(initialDistance);
        
        self.selfScale = self.oldSelfScale + (self.zoomScale-1.0)*self.oldSelfScale;
        
        float size = (self.selfScale - 1.0)/1.2f;
        float scale = oldScale;
        scale = self.selfScale;
        
        if( ((-angleDiff) < 0.03) && ((-angleDiff) >= -0.03)  )
        {
            angleDiff = 0;
            if( isShock )
            {
                AudioServicesPlaySystemSound(1519);
                isShock = false;
            }
        }
        else{
            isShock = true;
        }
        
//        if( self.minScale > scale )
//        {
//            scale = self.minScale;
//        }
        
        self.curretnView.transform =  CGAffineTransformScale(CGAffineTransformMakeRotation(-angleDiff), scale, scale);
        
        [self setFrameCurrentscale:scale];
        
        [self setFillet_ImageViewCenter];
        [self setRotate_ImageViewCenter];

        
        [self setQuadrilateralCenterPoint:false];
        
        if( self.delegate && [self.delegate respondsToSelector:@selector(corner_MaskPasterView:)] )
        {
            [self.delegate corner_MaskPasterView:self];
        }
    }
}
//MARK: 两指缩放
- (void)pinchGestureRecognizer_Quadrilateral:(UIPinchGestureRecognizer *)recognizer {
    
    if( recognizer.numberOfTouches == 1 )
    {
        return;
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        {
            deltaAngle      =-VECGAffineTransformGetAngle(self.curretnView.transform);
            self.pinScale = recognizer.scale;
            self.oldSelfScale = self.selfScale;
//            beginningWidth =  CGPointGetDistance([recognizer locationOfTouch:0 inView:self.curretnView],[recognizer locationOfTouch:1 inView:self.curretnView]);
//            self.topLeftZoomPoint = CGPointMake(self.topLeftRectangleImageView.frame.origin.x + btnWidth/2.0, self.topLeftRectangleImageView.frame.origin.y + btnWidth/2.0);
//            self.bottomLeftZoomPoint = CGPointMake(self.bottomLeftRectangleImageView.frame.origin.x + btnWidth/2.0, self.bottomLeftRectangleImageView.frame.origin.y + self.bottomLeftRectangleImageView.frame.size.height - btnWidth/2.0);
//            self.topRightZoomPoint = CGPointMake(self.topRightRectangleImageView.frame.origin.x + self.topRightRectangleImageView.frame.size.width - btnWidth/2.0, self.topRightRectangleImageView.frame.origin.y + btnWidth/2.0);
//            self.bottomRightZoomPoint = CGPointMake(self.bottomRightRectangleImageView.frame.origin.x + self.bottomRightRectangleImageView.frame.size.width - btnWidth/2.0, self.bottomRightRectangleImageView.frame.origin.y + self.bottomRightRectangleImageView.frame.size.height - btnWidth/2.0);
//
//            self.quadrilateralWidth = CGPointGetDistance(self.topLeftZoomPoint,CGPointMake(self.curretnView.bounds.size.width/2.0,self.curretnView.bounds.size.height/2.0));
//            self.topLeftWidth = self.quadrilateralWidth;
//            self.bottomLeftWidth = CGPointGetDistance(self.bottomLeftZoomPoint,CGPointMake(self.curretnView.bounds.size.width/2.0,self.curretnView.bounds.size.height/2.0));
//            if( self.quadrilateralWidth < self.bottomLeftWidth )
//            {
//                self.quadrilateralWidth = self.bottomLeftWidth;
//            }
//            self.topRightWidth = CGPointGetDistance(self.topRightZoomPoint,CGPointMake(self.curretnView.bounds.size.width/2.0,self.curretnView.bounds.size.height/2.0));
//            if( self.quadrilateralWidth < self.topRightWidth )
//            {
//                self.quadrilateralWidth = self.topRightWidth;
//            }
//            self.bottomRightWidth  = CGPointGetDistance(self.bottomRightZoomPoint,CGPointMake(self.curretnView.bounds.size.width/2.0,self.curretnView.bounds.size.height/2.0));
//            if( self.quadrilateralWidth < self.bottomRightWidth )
//            {
//                self.quadrilateralWidth = self.bottomRightWidth;
//            }
        }
            break;
        case UIGestureRecognizerStateChanged://缩放改变
        case UIGestureRecognizerStateEnded://缩放结束
        {
            CGFloat newScale = 0;
            newScale =  self.oldSelfScale*recognizer.scale;
            
            self.selfScale = newScale;
            
            self.curretnView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(atan2f(self.curretnView.transform.b, self.curretnView.transform.a)), newScale, newScale);
          //左上
                CGPoint point = self.topLeftRectangleImageView.frame.origin;
                self.topLeftImageView.center = CGPointMake(point.x + btnWidth/2.0, point.y + btnWidth/2.0);
            //左下
            {
                CGPoint point = CGPointMake(self.bottomLeftRectangleImageView.frame.origin.x, self.bottomLeftRectangleImageView.frame.size.height+self.bottomLeftRectangleImageView.frame.origin.y);
                self.bottomLeftImageView.center = CGPointMake(point.x + btnWidth/2.0, point.y -  btnWidth/2.0);
            }
            //右上
            {
                CGPoint point = CGPointMake(self.topRightRectangleImageView.frame.size.width+self.topRightRectangleImageView.frame.origin.x ,self.topRightRectangleImageView.frame.origin.y );
                self.topRightImageView.center = CGPointMake(point.x - btnWidth/2.0, point.y + btnWidth/2.0);
            }
            //右下
            {
                CGPoint point = CGPointMake(self.bottomRightRectangleImageView.frame.size.width+self.bottomRightRectangleImageView.frame.origin.x ,self.bottomRightRectangleImageView.frame.size.height+self.bottomRightRectangleImageView.frame.origin.y );
                self.bottomRightImageView.center = CGPointMake(point.x - btnWidth/2.0, point.y  - btnWidth/2.0);
            }
        
            [self setFrameCurrentscale:newScale];
            
            [self setFillet_ImageViewCenter];
            [self setRotate_ImageViewCenter];
        }
            break;
        default:
            break;
    }
    
    if( self.delegate && [self.delegate respondsToSelector:@selector(corner_MaskPasterView:)] )
    {
        [self.delegate corner_MaskPasterView:self];
    }
}

//MARK: 左上
-(void)topLeft_Quadrilateral:(UIGestureRecognizer *) recognizer{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://拖动开始
        {
            self->beginningPoint = [recognizer locationInView:self.curretnView];
            self->currentCenter = CGPointMake(self.topLeftRectangleImageView.frame.origin.x + btnWidth/2.0, self.topLeftRectangleImageView.frame.origin.y + btnWidth/2.0);
        }
            break;
        case UIGestureRecognizerStateChanged://拖动改变
        case UIGestureRecognizerStateEnded://拖动结束
        {
            CGPoint point = [recognizer locationInView:self.curretnView];
            float point_x = self->currentCenter.x - (self->beginningPoint.x - point.x);
            float point_y = self->currentCenter.y - (self->beginningPoint.y - point.y);
            
            if( point_x > (self.curretnView.bounds.size.width/2.0 ) )
            {
                point_x = self.curretnView.bounds.size.width/2.0;
            }
            if( point_y > (self.curretnView.bounds.size.height/2.0) )
            {
                point_y = self.curretnView.bounds.size.height/2.0;
            }
            
            self.topLeftRectangleImageView.frame = CGRectMake(point_x - btnWidth/2.0, point_y - btnWidth/2.0, self.curretnView.bounds.size.width/2.0 - point_x + btnWidth, self.curretnView.bounds.size.height/2.0 - point_y + btnWidth);

            point = self.topLeftRectangleImageView.frame.origin;
//            point = [self.curretnView convertPoint:point toView:self];
            self.topLeftImageView.center = CGPointMake(point.x + btnWidth/2.0, point.y + btnWidth/2.0);
            
            //圆角
            {
                [self setFillet_ImageViewCenter];
            }
        }
            break;
        default:
            break;
    }
    if( self.delegate && [self.delegate respondsToSelector:@selector(corner_MaskPasterView:)] )
    {
        [self.delegate corner_MaskPasterView:self];
    }
}
//MARK: 左下
-(void)bottomLeft_Quadrilateral:(UIGestureRecognizer *) recognizer{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://拖动开始
        {
            self->beginningPoint = [recognizer locationInView:self.curretnView];
            self->currentCenter = CGPointMake(self.bottomLeftRectangleImageView.frame.origin.x + btnWidth/2.0, self.bottomLeftRectangleImageView.frame.origin.y + self.bottomLeftRectangleImageView.frame.size.height - btnWidth/2.0);
        }
            break;
        case UIGestureRecognizerStateChanged://拖动改变
        case UIGestureRecognizerStateEnded://拖动结束
        {
            CGPoint point = [recognizer locationInView:self.curretnView];
            float point_x = self->currentCenter.x - (self->beginningPoint.x - point.x);
            float point_y = self->currentCenter.y - (self->beginningPoint.y - point.y);
            
            if( point_x > (self.curretnView.bounds.size.width/2.0) )
            {
                point_x = self.curretnView.bounds.size.width/2.0;
            }
            if( point_y < ( self.curretnView.bounds.size.height/2.0) )
            {
                point_y = self.curretnView.bounds.size.height/2.0;
            }
            
            self.bottomLeftRectangleImageView.frame = CGRectMake(point_x - btnWidth/2.0, self.curretnView.bounds.size.height/2.0 - btnWidth/2.0, self.curretnView.bounds.size.width/2.0 - point_x + btnWidth, point_y - self.curretnView.bounds.size.height/2.0 + btnWidth);
            
            point = CGPointMake(self.bottomLeftRectangleImageView.frame.origin.x, self.bottomLeftRectangleImageView.frame.size.height+self.bottomLeftRectangleImageView.frame.origin.y);
//            point = [self.curretnView convertPoint:point toView:self];
            self.bottomLeftImageView.center = CGPointMake(point.x + btnWidth/2.0, point.y -  btnWidth/2.0);
            
            [self setRotate_ImageViewCenter];
        }
            break;
        default:
            break;
    }
    if( self.delegate && [self.delegate respondsToSelector:@selector(corner_MaskPasterView:)] )
    {
        [self.delegate corner_MaskPasterView:self];
    }
}
//MARK: 右上
-(void)topRight_Quadrilateral:(UIGestureRecognizer *) recognizer{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://拖动开始
        {
            self->beginningPoint = [recognizer locationInView:self.curretnView];
            self->currentCenter = CGPointMake(self.topRightRectangleImageView.frame.origin.x + self.topRightRectangleImageView.frame.size.width - btnWidth/2.0, self.topRightRectangleImageView.frame.origin.y + btnWidth/2.0);
        }
            break;
        case UIGestureRecognizerStateChanged://拖动改变
        case UIGestureRecognizerStateEnded://拖动结束
        {
            CGPoint point = [recognizer locationInView:self.curretnView];
            float point_x = self->currentCenter.x - (self->beginningPoint.x - point.x);
            float point_y = self->currentCenter.y - (self->beginningPoint.y - point.y);
            
            if( point_x < (self.curretnView.bounds.size.width/2.0) )
            {
                point_x = self.curretnView.bounds.size.width/2.0;
            }
            if( point_y > (self.curretnView.bounds.size.height/2.0) )
            {
                point_y = self.curretnView.bounds.size.height/2.0;
            }
            
            self.topRightRectangleImageView.frame = CGRectMake(self.curretnView.bounds.size.width/2.0 - btnWidth/2.0, point_y - btnWidth/2.0, point_x - self.curretnView.bounds.size.width/2.0 + btnWidth, self.curretnView.bounds.size.height/2.0 - point_y + btnWidth);
            
            point = CGPointMake(self.topRightRectangleImageView.frame.size.width+self.topRightRectangleImageView.frame.origin.x ,self.topRightRectangleImageView.frame.origin.y );
            self.topRightImageView.center = CGPointMake(point.x - btnWidth/2.0, point.y + btnWidth/2.0);
        }
            break;
        default:
            break;
    }
    if( self.delegate && [self.delegate respondsToSelector:@selector(corner_MaskPasterView:)] )
    {
        [self.delegate corner_MaskPasterView:self];
    }
}
//MARK: 右下
-(void)bottomRight_Quadrilateral:(UIGestureRecognizer *) recognizer{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://拖动开始
        {
            self->beginningPoint = [recognizer locationInView:self.curretnView];
            self->currentCenter = CGPointMake(self.bottomRightRectangleImageView.frame.origin.x + self.bottomRightRectangleImageView.frame.size.width - btnWidth/2.0, self.bottomRightRectangleImageView.frame.origin.y + self.bottomRightRectangleImageView.frame.size.height - btnWidth/2.0);
        }
            break;
        case UIGestureRecognizerStateChanged://拖动改变
        case UIGestureRecognizerStateEnded://拖动结束
        {
            CGPoint point = [recognizer locationInView:self.curretnView];
            float point_x = self->currentCenter.x - (self->beginningPoint.x - point.x);
            float point_y = self->currentCenter.y - (self->beginningPoint.y - point.y);
            
            if( point_x < (self.curretnView.bounds.size.width/2.0) )
            {
                point_x = self.curretnView.bounds.size.width/2.0;
            }
            if( point_y < ( self.curretnView.bounds.size.height/2.0) )
            {
                point_y = self.curretnView.bounds.size.height/2.0;
            }
            
            self.bottomRightRectangleImageView.frame = CGRectMake(self.curretnView.bounds.size.width/2.0 - btnWidth/2.0, self.curretnView.bounds.size.height/2.0 - btnWidth/2.0, point_x - self.curretnView.bounds.size.width/2.0 + btnWidth, point_y - self.curretnView.bounds.size.height/2.0 + btnWidth);
            
            point = CGPointMake(self.bottomRightRectangleImageView.frame.size.width+self.bottomRightRectangleImageView.frame.origin.x ,self.bottomRightRectangleImageView.frame.size.height+self.bottomRightRectangleImageView.frame.origin.y );
            self.bottomRightImageView.center = CGPointMake(point.x - btnWidth/2.0, point.y  - btnWidth/2.0);
            
            [self setRotate_ImageViewCenter];
        }
            break;
        default:
            break;
    }
    if( self.delegate && [self.delegate respondsToSelector:@selector(corner_MaskPasterView:)] )
    {
        [self.delegate corner_MaskPasterView:self];
    }
}

-(void)setCenterView_Quadrilateral
{
    self.centreImageView.frame = CGRectMake( (self.quadrilateralViewCenterView.frame.size.width - RoundnessHeight)/2.0, (self.quadrilateralViewCenterView.frame.size.height - RoundnessHeight)/2.0, RoundnessHeight, RoundnessHeight);
    
    float x = sqrt((filletWidth*filletWidth)/2.0);
    self.fillet_ImageView.frame = CGRectMake((self.quadrilateralViewCenterView.frame.origin.x - x - btnWidth),(self.quadrilateralViewCenterView.frame.origin.y - x - btnWidth),btnWidth,btnWidth);
    
    self.topLeftImageView.frame = CGRectMake((self.quadrilateralViewCenterView.frame.origin.x - btnWidth/2.0 ),(self.quadrilateralViewCenterView.frame.origin.y - btnWidth/2.0),btnWidth,btnWidth);
    self.bottomLeftImageView.frame = CGRectMake((self.quadrilateralViewCenterView.frame.origin.x - btnWidth/2.0 ),(self.quadrilateralViewCenterView.frame.origin.y + self.quadrilateralViewCenterView.frame.size.height - btnWidth/2.0),btnWidth,btnWidth);
    self.topRightImageView.frame = CGRectMake((self.quadrilateralViewCenterView.frame.origin.x + self.quadrilateralViewCenterView.frame.size.width - btnWidth/2.0 ),(self.quadrilateralViewCenterView.frame.origin.y - btnWidth/2.0),btnWidth,btnWidth);
    self.bottomRightImageView.frame = CGRectMake((self.quadrilateralViewCenterView.frame.origin.x + self.quadrilateralViewCenterView.frame.size.width - btnWidth/2.0 ),(self.quadrilateralViewCenterView.frame.origin.y + self.quadrilateralViewCenterView.frame.size.height - btnWidth/2.0),btnWidth,btnWidth);
    
    float width = self.quadrilateralViewCenterView.frame.size.width;
    float height = self.quadrilateralViewCenterView.frame.size.height;
    
    float  cornerRadius = 0;
    
    if( width >= height )
    {
        cornerRadius = height/3.0*( filletWidth/10.0 );
    }
    else
    {
        cornerRadius = width/3.0*( filletWidth/10.0 );
    }
    
    self.quadrilateralViewCenterView.layer.cornerRadius = cornerRadius;
}

//MARK: 圆角
- (void) filletGestureGesture_Quadrilateral:(UIGestureRecognizer *) recognizer{

    touchLocation = [recognizer locationInView:self];
    
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
        
        if( cornerRadius > 30 )
        {
            cornerRadius = 30;
        }
        else if( cornerRadius < 0 )
        {
            cornerRadius = 0;
        }
        
        filletWidth = cornerRadius;
        
        float x = sqrt((cornerRadius*cornerRadius)/2.0)/sqrt(30*30/2.0);
        
        {
            [self setFillet_ImageViewCenter];
        }
        
        if( self.delegate && [self.delegate respondsToSelector:@selector(fillet_MaskPasterView_Quadrilateral:atCornerRadius:)] )
        {
            [self.delegate fillet_MaskPasterView_Quadrilateral:self atCornerRadius:x];
        }
        
        beganLocation = touchLocation;
    }
}

-(void)setFillet_ImageViewCenter
{
   CGPoint  point = CGPointMake(self.topLeftImageView.frame.origin.x - (filletWidth+2)/self.selfScale , self.topLeftImageView.frame.origin.y - (filletWidth+2)/self.selfScale );
    NSLog(@"fillet_ImageViewCenter: %0.2f,  %0.2f ",point.x , point.y);
    self.fillet_ImageView.center = point;
}

-(void)setRotate_ImageViewCenter
{
    float  bottomLeftY = self.bottomLeftRectangleImageView.frame.origin.y + self.bottomLeftRectangleImageView.frame.size.height;
    float  bottomRightY  = self.bottomRightRectangleImageView.frame.origin.y + self.bottomRightRectangleImageView.frame.size.height;
    float y = bottomLeftY;
    if( bottomRightY > bottomLeftY )
    {
        y = bottomRightY;
    }
   CGPoint  point = CGPointMake(self.curretnView.bounds.size.width/2.0, y + (btnWidth/2.0)/self.selfScale);
    self.rotate_ImageView.center = point;
}

-(void)setFrameCurrentscale:(float)value
{
    self.rotate_ImageView.transform = CGAffineTransformMakeScale(1, 1);
    self.rotate_ImageView.transform = CGAffineTransformMakeScale(1/value, 1/value);
    self.fillet_ImageView.transform = CGAffineTransformMakeScale(1, 1);
    self.fillet_ImageView.transform = CGAffineTransformMakeScale(1/value, 1/value);
    
    self.topLeftImageView.transform = CGAffineTransformMakeScale(1, 1);
    self.topLeftImageView.transform = CGAffineTransformMakeScale(1/value, 1/value);
    self.bottomLeftImageView.transform = CGAffineTransformMakeScale(1, 1);
    self.bottomLeftImageView.transform = CGAffineTransformMakeScale(1/value, 1/value);
    self.topRightImageView.transform = CGAffineTransformMakeScale(1, 1);
    self.topRightImageView.transform = CGAffineTransformMakeScale(1/value, 1/value);
    self.bottomRightImageView.transform = CGAffineTransformMakeScale(1, 1);
    self.bottomRightImageView.transform = CGAffineTransformMakeScale(1/value, 1/value);
}
@end
