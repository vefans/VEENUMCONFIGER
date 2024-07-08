//
//  VECheckBooxView.m
//  VEDeluxeSDK
//
//  Created by mac on 2024/7/3.
//

#import "VECheckBooxView.h"
#import "VEENUMCONFIGER/VEHelp.h"
#define MagnifyingGlassView_CurrentViewTag 2001
#define MagnifyingGlassView_CloseBtnTag 2002
#define MagnifyingGlassView_RotateViewTag 2003

CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t)
{
    return atan2(t.b, t.a);
}

@interface VECheckBooxView ()
{
    // 定义变量以跟踪初始状态
    CGPoint touchPoint;
    CGPoint beganPoint;
    CGFloat deltaAngle;
    bool    isShock;
    
    CGSize magifyingClassSize;
    float startDistanceBetween;
}

@end

@implementation VECheckBooxView

-(void)setFrame:(CGRect) frame angle:( float ) angle center:( CGPoint ) center
{
    self.transform = CGAffineTransformMakeRotation( 0 );
    
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + self.edgeWidth*2.0, frame.size.height + self.edgeWidth*2.0);
    self.closeBtn.frame =  CGRectMake(0, 0, self.edgeWidth*2.0, self.edgeWidth*2.0);
    self.rotateView.frame = CGRectMake(0, 0, self.edgeWidth*2.0, self.edgeWidth*2.0);
    self.currentView.frame = CGRectMake(self.edgeWidth, self.edgeWidth, self.frame.size.width - self.edgeWidth*2.0, self.frame.size.height - self.edgeWidth*2.0);
    self.rotateView.center = CGPointMake(CGRectGetMaxX(self.currentView.frame) - 1.5, CGRectGetMaxY(self.currentView.frame) - 1.5);
    self.center = center;
    
    self.transform = CGAffineTransformMakeRotation( - angle/(180.0/M_PI) );
}

- (instancetype)initWithFrame:( CGRect )frame atEdgeWidth:( float ) edgeWidth
{
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + edgeWidth*2.0, frame.size.height + edgeWidth*2.0);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.maxHeight = kHEIGHT;
        self.minHeight = 10;
        self.edgeWidth = edgeWidth;
        self.currentView = [[UIView alloc] initWithFrame:CGRectMake(self.edgeWidth, self.edgeWidth, frame.size.width - self.edgeWidth*2.0, frame.size.height - self.edgeWidth*2.0)];
        self.currentView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.currentView.layer.borderWidth = 1.5;
        self.currentView.tag = MagnifyingGlassView_CurrentViewTag;
        [self addSubview:self.currentView];
        
        {
            self.closeBtn=  [[UIButton alloc]  initWithFrame:CGRectMake(0, 0, self.edgeWidth*2.0, self.edgeWidth*2.0)];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.edgeWidth/2.0, self.edgeWidth/2.0, self.edgeWidth, self.edgeWidth)];
            imageView.image = [VEHelp imageNamed:@"/PESDKImage/PESDK_关闭@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
            [self.closeBtn addSubview:imageView];
            [self addSubview:self.closeBtn];
            [self.closeBtn addTarget:self action:@selector(veCheckBooxView_CloseBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        
        {
            self.rotateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.edgeWidth*2.0, self.edgeWidth*2.0)];
            self.rotateView.tag = MagnifyingGlassView_RotateViewTag;
            self.rotateView.center = CGPointMake(CGRectGetMaxX(self.currentView.frame) - 1.5, CGRectGetMaxY(self.currentView.frame) - 1.5);
            self.rotateView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin ;
            self.rotateView.backgroundColor = [UIColor clearColor];
            {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.edgeWidth/2.0, self.edgeWidth/2.0, self.edgeWidth, self.edgeWidth)];
                imageView.image = [VEHelp imageNamed:@"/PESDKImage/PESDK_拖动旋转@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]];
                [self.rotateView addSubview:imageView];
            }
            self.rotateView.userInteractionEnabled = YES;
            [self addSubview:self.rotateView];
            
            UIPanGestureRecognizer* rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(veCheckBooxView_rotateGesture:)];
            [self.rotateView addGestureRecognizer:rotateGesture];
        }
    }
    return self;
}

-(void)veCheckBooxView_CloseBtn
{
    if( self.closeCheckBooxView )
    {
        self.closeCheckBooxView(self);
    }
}

-( CGFloat )distanceBetweenPoints:(CGPoint) point1 point2:(CGPoint) point2 {
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrtf(dx * dx + dy * dy); // 使用sqrtf计算平方根
}

- (void) veCheckBooxView_rotateGesture:(UIPanGestureRecognizer *) recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if( self.checkBooxView_rotateGesture )
        {
            self.checkBooxView_rotateGesture( self, recognizer );
        }
        // 保存开始拖动的位置
        beganPoint =  [recognizer locationInView:self.syncContainer];
        magifyingClassSize = self.frame.size;
        startDistanceBetween = [self distanceBetweenPoints:self.center point2:beganPoint];
        deltaAngle = CGAffineTransformGetAngle(self.transform);
    } else if ( recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint  = [recognizer locationInView:self.syncContainer];
        float  endDistanceBetween = [self distanceBetweenPoints:self.center point2:currentPoint];
        CGFloat scale = endDistanceBetween/startDistanceBetween; // 获取缩放比例
        float ang =  -atan2(beganPoint.y-self.center.y, beganPoint.x-self.center.x) + atan2(currentPoint.y-self.center.y, currentPoint.x-self.center.x);
        float angleDiff = deltaAngle + ang;
        float angle = - angleDiff * (180.0/M_PI);
        float height = scale *  magifyingClassSize.height;
        if( height > self.maxHeight )
            height = self.maxHeight;
        if( height < self.minHeight )
            height = self.minHeight;
        CGPoint center = self.center;
        self.transform = CGAffineTransformMakeRotation( 0 );

        CGRect frame = CGRectMake(0, 0, height*( magifyingClassSize.width/magifyingClassSize.height ) , height);
        self.frame = frame;
        
        self.currentView.frame = CGRectMake(self.edgeWidth, self.edgeWidth, frame.size.width - self.edgeWidth*2.0, frame.size.height - self.edgeWidth*2.0);
        self.closeBtn.center = CGPointMake(self.closeBtn.frame.size.width/2.0, self.closeBtn.frame.size.height/2.0);
       self.rotateView.center = CGPointMake(CGRectGetMaxX(self.currentView.frame) - 1.5, CGRectGetMaxY(self.currentView.frame) - 1.5);

        self.center = center;
        self.transform = CGAffineTransformMakeRotation( - angle/(180.0/M_PI) );
    }
    
    if( self.refreshSynContainer )
        self.refreshSynContainer(self);
    
    if( (recognizer.state == UIGestureRecognizerStateEnded) && self.checkBooxView_rotateGesture )
    {
        self.checkBooxView_rotateGesture( self, recognizer );
    }
}

-(void)veCheckBooxView_Move:( UIPanGestureRecognizer * ) recognizer
{
    if ( recognizer.state == UIGestureRecognizerStateChanged ) {
        float deltaAngle = CGAffineTransformGetAngle(self.transform);
        CGPoint center = [recognizer translationInView:self.syncContainer];
        self.transform = CGAffineTransformMakeRotation( 0 );
        self.center = CGPointMake( self.center.x + center.x, self.center.y + center.y);
        self.transform = CGAffineTransformMakeRotation( deltaAngle );
    }
    [recognizer setTranslation:CGPointZero inView:self.syncContainer];
    
    if( recognizer.state == UIGestureRecognizerStateBegan )
        self.hidden = true;
    else if( recognizer.state == UIGestureRecognizerStateEnded )
        self.hidden = NO;
    
    if( self.refreshSynContainer )
        self.refreshSynContainer(self);
}

-(void)veCheckBooxView_Angle:( UIRotationGestureRecognizer * ) recognizer
{
     if ( recognizer.state == UIGestureRecognizerStateChanged ) {
        CGFloat rotatedAngle = recognizer.rotation; // 获取旋转的弧度值
         float deltaAngle = CGAffineTransformGetAngle(self.transform) + rotatedAngle;
         self.transform = CGAffineTransformMakeRotation( deltaAngle );
     }
    recognizer.rotation = 0;
    
    if( recognizer.state == UIGestureRecognizerStateBegan )
    {
        self.closeBtn.hidden = true;
        self.rotateView.hidden = true;
    }
    else if( recognizer.state == UIGestureRecognizerStateEnded )
    {
        self.closeBtn.hidden = NO;
        self.rotateView.hidden = NO;
    }
    
    if( self.refreshSynContainer )
        self.refreshSynContainer(self);
}

-(void)veCheckBooxView_Scale:( UIPinchGestureRecognizer * ) recognizer
{
    if ( recognizer.state == UIGestureRecognizerStateChanged ) {
        CGFloat scale = recognizer.scale; // 获取缩放比例
        CGPoint center = self.center;
        float deltaAngle = CGAffineTransformGetAngle(self.transform);
        self.transform = CGAffineTransformMakeRotation( 0 );
        
        float height = scale *  self.frame.size.height;
        if( height > self.maxHeight )
            height = self.maxHeight;
        if( height < self.minHeight )
            height = self.minHeight;
        CGRect frame = CGRectMake(0, 0, height*( self.frame.size.width/self.frame.size.height ) , height);
        
        self.frame = frame;
        self.currentView.frame = CGRectMake(self.edgeWidth, self.edgeWidth, frame.size.width - self.edgeWidth*2.0, frame.size.height - self.edgeWidth*2.0);
        self.closeBtn.center = CGPointMake(self.closeBtn.frame.size.width/2.0, self.closeBtn.frame.size.height/2.0);
       self.rotateView.center = CGPointMake(CGRectGetMaxX(self.currentView.frame) - 1.5, CGRectGetMaxY(self.currentView.frame) - 1.5);
        
        self.center = center;
        self.transform = CGAffineTransformMakeRotation(deltaAngle);
    }
    recognizer.scale = 1.0;
    
    if( recognizer.state == UIGestureRecognizerStateBegan )
    {
        self.closeBtn.hidden = true;
        self.rotateView.hidden = true;
    }
    else if( recognizer.state == UIGestureRecognizerStateEnded )
    {
        self.closeBtn.hidden = NO;
        self.rotateView.hidden = NO;
    }
    
    if( self.refreshSynContainer )
        self.refreshSynContainer(self);
}

@end
