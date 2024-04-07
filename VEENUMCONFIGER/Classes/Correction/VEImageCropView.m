//
//  VEImageCropView.m
//  VEENUMCONFIGER
//
//  Created by mac on 2024/1/25.
//

#import "VEImageCropView.h"

@interface VEImageCropView()
{
    float  _pointsHeight;
}
@property (nonatomic, strong) UIView *topLeft;
@property (nonatomic, strong) UIView *topRight;
@property (nonatomic, strong) UIView *bottomLeft;
@property (nonatomic, strong) UIView *bottomRight;
@property (nonatomic, strong) UIView *leftMiddle;
@property (nonatomic, strong) UIView *rightMiddle;
@property (nonatomic, strong) UIView *topMiddle;
@property (nonatomic, strong) UIView *bottomMiddle;
@property (nonatomic, strong) UIView *centerBtn;

@end

@implementation VEImageCropView {
    CGFloat _touchThreshold;
    CGPoint _initialCenter;
    CGFloat _initialScale;
    
    CAShapeLayer *cropBorderLayer;
    CGFloat  _fixedRatio;
    
    NSMutableArray<UIImageView *> *_dragViews;
    UIImageView *_activeDragView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _pointsHeight = 40.0;
        _cropRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _fixedRatio = frame.size.width/frame.size.height;
        // 创建ImageView并添加到视图上
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.tag = 101;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
        // 添加拖动手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGesture];
        
        // 添加捏合手势识别器
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:pinchGesture];
        
        // 设置是否固定比例，默认为NO（无限制拖动）
        self.isFixedRatio = NO;
        
        // 裁剪区域的属性
       self.cropRect  = self.imageView.bounds;

        // 允许交互，以便在ImageView的边缘上也能触发拖动手势
        self.imageView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        
        [self addRectangleView];
        
        [self addPoints];
        [self addGestureRecognizers];
        
        [self updateRectangle];
    }
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    CGPoint imageViewPosition = self.imageView.center;
    imageViewPosition.x += translation.x;
    imageViewPosition.y += translation.y;
    self.imageView.center = imageViewPosition;
    [gesture setTranslation:CGPointZero inView:self];
    
    [self updateRectangle];
}
// 缩放手势回调方法
- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = gesture.scale;
        
        // 计算新的缩放比例
        CGFloat newScale = self.imageView.transform.a * scale;
        
        // 设置缩放限制，根据需要调整下面的最小和最大缩放比例
        CGFloat minScale = 1.0;
        CGFloat maxScale = 4.0;
        newScale = MIN(MAX(newScale, minScale), maxScale);
        
        // 应用新的缩放变换
        CGAffineTransform transform = CGAffineTransformMakeScale(newScale, newScale);
        self.imageView.transform = transform;
        
        // 重置手势的缩放比例
        gesture.scale = 1.0;
        
        [self updateRectangle];
    }
}

- (void)addPoints {
    CGFloat lineWidth = 2.5;
    CGFloat size = _pointsHeight;
    UIColor *color = [UIColor blackColor];
    CGFloat width = self.imageView.frame.size.width;
    CGFloat height = self.imageView.frame.size.height;
    
    _topLeft = [self createPointWithFrame:CGRectMake(-size / 2, -size / 2, size, size)
                                      fillColor:color];
    {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(size / 2-lineWidth, size / 2-lineWidth, size / 2 + lineWidth, lineWidth)];
        imageView1.backgroundColor = [UIColor whiteColor];
        [_topLeft addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(size / 2-lineWidth, size / 2-lineWidth, lineWidth, size / 2 +lineWidth)];
        imageView2.backgroundColor = [UIColor whiteColor];
        [_topLeft addSubview:imageView2];
    }
    _topLeft.center = CGPointMake(0, 0);
    
    _topRight = [self createPointWithFrame:CGRectMake(-size / 2, -size / 2, size, size)
                                       fillColor:color];
    {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, size / 2-lineWidth, size / 2 + lineWidth, lineWidth)];
        imageView1.backgroundColor = [UIColor whiteColor];
        [_topRight addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(size/2, size / 2-lineWidth, lineWidth, size / 2 +lineWidth)];
        imageView2.backgroundColor = [UIColor whiteColor];
        [_topRight addSubview:imageView2];
    }
    _topRight.center = CGPointMake(width, 0);
    
    _bottomLeft = [self createPointWithFrame:CGRectMake(-size / lineWidth, -size / lineWidth, size, size)
                                         fillColor:color];
    {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(size / 2-lineWidth, size/2, size / 2 + lineWidth, lineWidth)];
        imageView1.backgroundColor = [UIColor whiteColor];
        [_bottomLeft addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(size / 2-lineWidth, 0, lineWidth, size / 2 +lineWidth)];
        imageView2.backgroundColor = [UIColor whiteColor];
        [_bottomLeft addSubview:imageView2];
    }
    _bottomLeft.center = CGPointMake(0, height);
    
    _bottomRight = [self createPointWithFrame:CGRectMake(-size / 2, -size / 2, size, size)
                                          fillColor:color];
    {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, size / 2, size / 2, lineWidth)];
        imageView1.backgroundColor = [UIColor whiteColor];
        [_bottomRight addSubview:imageView1];
        
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(size / 2, 0, lineWidth, size / 2 +lineWidth)];
        imageView2.backgroundColor = [UIColor whiteColor];
        [_bottomRight addSubview:imageView2];
    }
    _bottomRight.center = CGPointMake(width, height );
    
    _leftMiddle = [self createPointWithFrame:CGRectMake(-size / 2, -size / 2, size, size)
                                         fillColor:color];
    {
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(size / 2-lineWidth, size / 2-lineWidth, lineWidth, size / 2 +lineWidth)];
        imageView2.center = CGPointMake(imageView2.center.x, size/2.0);
        imageView2.backgroundColor = [UIColor whiteColor];
        [_leftMiddle addSubview:imageView2];
    }
    _leftMiddle.center = CGPointMake(0, height / 2);
    
    _rightMiddle = [self createPointWithFrame:CGRectMake(-size / 2, -size / 2, size, size)
                                          fillColor:color];
    {
        UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(size / 2, 0, lineWidth, size / 2 +lineWidth)];
        imageView2.center = CGPointMake(imageView2.center.x, size/2.0);
        imageView2.backgroundColor = [UIColor whiteColor];
        [_rightMiddle addSubview:imageView2];
    }
    _rightMiddle.center = CGPointMake(width, height / 2);
    
    _topMiddle = [self createPointWithFrame:CGRectMake(-size / 2, -size / 2, size, size)
                                        fillColor:color];
    {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(size / 2-lineWidth, size / 2-lineWidth, size / 2 + lineWidth, lineWidth)];
        imageView1.center = CGPointMake( size/2.0, imageView1.center.y);
        imageView1.backgroundColor = [UIColor whiteColor];
        [_topMiddle addSubview:imageView1];
    }
    _topMiddle.center = CGPointMake(width / 2, 0);
    
    _bottomMiddle = [self createPointWithFrame:CGRectMake(-size / 2, -size / 2, size, size)
                                           fillColor:color];
    {
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(size / 2-lineWidth, size/2, size / 2 + lineWidth, lineWidth)];
        imageView1.center = CGPointMake( size/2.0, imageView1.center.y);
        imageView1.backgroundColor = [UIColor whiteColor];
        [_bottomMiddle addSubview:imageView1];
    }
    _bottomMiddle.center = CGPointMake(width / 2, height);
    
    [self addSubview:_topLeft];
    _topLeft.tag = 1;
    [self addSubview:_topRight];
    _topRight.tag = 2;
    [self addSubview:_bottomLeft];
    _bottomLeft.tag = 3;
    [self addSubview:_bottomRight];
    _bottomRight.tag = 4;
    [self addSubview:_leftMiddle];
    _leftMiddle.tag = 5;
    [self addSubview:_rightMiddle];
    _rightMiddle.tag = 6;
    [self addSubview:_topMiddle];
    _topMiddle.tag = 7;
    [self addSubview:_bottomMiddle];
    _bottomMiddle.tag = 8;
}

- (UIView *)createPointWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor {
    UIView *point = [[UIView alloc] initWithFrame:frame];
//    point.layer.cornerRadius = frame.size.width / 2;
//    point.layer.borderColor = [UIColor whiteColor].CGColor;
//    point.layer.borderWidth = 1.0;
//    point.backgroundColor = fillColor;
//    point.userInteractionEnabled = YES;
    return point;
}

- (void)addGestureRecognizers {
    for ( int i = 1; i < 9; i++  ) {
        UIView *view = [self viewWithTag:i];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [view addGestureRecognizer:pan];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *view = gestureRecognizer.view;
    CGPoint translation = [gestureRecognizer translationInView:view.superview];
    CGPoint center = view.center;
    center.x += translation.x;
    center.y += translation.y;
    
    CGRect imageViewFrame = self.imageView.frame;
    CGFloat minX = CGRectGetMinX(imageViewFrame);
    CGFloat minY = CGRectGetMinY(imageViewFrame);
    CGFloat maxX = CGRectGetMaxX(imageViewFrame);
    CGFloat maxY = CGRectGetMaxY(imageViewFrame);
    
    float Interval = 0.0;
    
    if (view.center.x < minX) {
        center.x = minX;
    }
    if (view.center.y < minY) {
        center.y = minY;
    }
    if (view.center.x > maxX) {
        center.x = maxX;
    }
    if (view.center.y > maxY) {
        center.y = maxY;
    }
    
    float  cropWidth =  _pointsHeight + _pointsHeight;
    // Update other points
    if (view == self.topLeft) {
        if( (self.bottomRight.center.x - cropWidth) < center.x )
        {
            center.x = self.bottomRight.center.x - cropWidth;
        }
        if(( self.bottomRight.center.y - cropWidth) < center.y )
        {
            center.y = self.bottomRight.center.y - cropWidth;
        }
        
        if( center.x < Interval )
        {
            center.x = Interval;
        }
        if( center.y < Interval )
        {
            center.y = Interval;
        }
        
        view.center = center;
        self.topRight.center = CGPointMake(self.topRight.center.x, self.topLeft.center.y);
        self.bottomLeft.center = CGPointMake(self.topLeft.center.x, self.bottomLeft.center.y);
    } else if (view == self.topRight) {
        if( (self.bottomLeft.center.x + cropWidth) > center.x )
        {
            center.x = self.bottomLeft.center.x + cropWidth;
        }
        if( (self.bottomLeft.center.y - cropWidth) < center.y )
        {
            center.y = self.bottomLeft.center.y - cropWidth;
        }
        
        if( center.x > ( self.frame.size.height - Interval ) )
        {
            center.x = self.frame.size.height - Interval;
        }
        if( center.y < Interval )
        {
            center.y = Interval;
        }
        
        view.center = center;
        self.topLeft.center = CGPointMake(self.topLeft.center.x, self.topRight.center.y);
        self.bottomRight.center = CGPointMake(self.topRight.center.x, self.bottomRight.center.y);
    } else if (view == self.bottomLeft) {
        if( (self.topRight.center.x - cropWidth) < center.x )
        {
            center.x = self.topRight.center.x - cropWidth;
        }
        if( (self.topRight.center.y + cropWidth) > center.y )
        {
            center.y = self.topRight.center.y + cropWidth;
        }
        
        if( center.x < Interval )
        {
            center.x = Interval;
        }
        if( center.y > (self.frame.size.height - Interval) )
        {
            center.y = self.frame.size.height - Interval;
        }
        
        view.center = center;
        self.topLeft.center = CGPointMake(self.bottomLeft.center.x, self.topLeft.center.y);
        self.bottomRight.center = CGPointMake(self.bottomRight.center.x, self.bottomLeft.center.y);
    } else if (view == self.bottomRight) {
        if( (self.topLeft.center.x + cropWidth) > center.x )
        {
            center.x = self.topLeft.center.x + cropWidth;
        }
        if( (self.topLeft.center.y + cropWidth) > center.y )
        {
            center.y = self.topLeft.center.y + cropWidth;
        }
        
        if( center.x > (self.frame.size.width - Interval) )
        {
            center.x = self.frame.size.width - Interval;
        }
        if( center.y > ( self.frame.size.height - Interval ) )
        {
            center.y = self.frame.size.height - Interval;
        }
        
        view.center = center;
        self.topRight.center = CGPointMake(self.bottomRight.center.x, self.topRight.center.y);
        self.bottomLeft.center = CGPointMake(self.bottomLeft.center.x, self.bottomRight.center.y);
    } else if (view == self.leftMiddle) {
        if( center.x  > ( self.rightMiddle.center.x - cropWidth ) )
        {
            center.x = self.rightMiddle.center.x - cropWidth;
        }
        if( center.x < Interval )
        {
            center.x = Interval;
        }
        view.center = CGPointMake(center.x, view.center.y);
        self.topLeft.center = CGPointMake(self.leftMiddle.center.x, self.topLeft.center.y);
        self.bottomLeft.center = CGPointMake(self.leftMiddle.center.x, self.bottomLeft.center.y);
    } else if (view == self.rightMiddle) {
        if( center.x  < ( self.leftMiddle.center.x + cropWidth ) )
        {
            center.x = self.leftMiddle.center.x + cropWidth;
        }
        if( center.x > (self.frame.size.width - Interval) )
        {
            center.x = self.frame.size.width - Interval;
        }
        view.center = CGPointMake(center.x, view.center.y);
        self.topRight.center = CGPointMake(self.rightMiddle.center.x, self.topRight.center.y);
        self.bottomRight.center = CGPointMake(self.rightMiddle.center.x, self.bottomRight.center.y);
    } else if (view == self.topMiddle) {
        if( center.y  > ( self.bottomMiddle.center.y - cropWidth ) )
        {
            center.y = self.bottomMiddle.center.y - cropWidth;
        }
        if( center.y < Interval )
        {
            center.y = Interval;
        }
        view.center = CGPointMake(view.center.x, center.y);
        self.topLeft.center = CGPointMake(self.topLeft.center.x, self.topMiddle.center.y);
        self.topRight.center = CGPointMake(self.topRight.center.x, self.topMiddle.center.y);
    } else if (view == self.bottomMiddle) {
        if( center.y  < ( self.topMiddle.center.y + cropWidth ) )
        {
            center.y = self.topMiddle.center.y + cropWidth;
        }
        if( center.y > (self.frame.size.height - Interval) )
        {
            center.y = self.frame.size.height - Interval;
        }
        view.center = CGPointMake(view.center.x, center.y);
        self.bottomLeft.center = CGPointMake(self.bottomLeft.center.x, self.bottomMiddle.center.y);
        self.bottomRight.center = CGPointMake(self.bottomRight.center.x, self.bottomMiddle.center.y);
    }
    self.topMiddle.center = CGPointMake((self.topLeft.center.x + self.topRight.center.x) / 2, self.topLeft.center.y);
    self.leftMiddle.center = CGPointMake(self.topLeft.center.x, (self.topLeft.center.y + self.bottomLeft.center.y) / 2);
    self.rightMiddle.center = CGPointMake(self.topRight.center.x, (self.topRight.center.y + self.bottomRight.center.y) / 2);
    self.bottomMiddle.center = CGPointMake((self.bottomLeft.center.x + self.bottomRight.center.x) / 2, self.bottomRight.center.y);

    [gestureRecognizer setTranslation:CGPointZero inView:view.superview];
    
    [self updateRectangle];
}

-(void)addRectangleView
{
    self.rectangleView = [[UIView alloc] init];
    self.rectangleView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.rectangleView.layer.borderWidth = 1.0;
    [self addSubview:self.rectangleView];
}

- (void)updateRectangle {
    UIView *topLeft = [self viewWithTag:1];
    UIView *topRight = [self viewWithTag:2];
    UIView *bottomLeft = [self viewWithTag:3];

    CGFloat x = topLeft.center.x;
    CGFloat y = topLeft.center.y;
    CGFloat width = topRight.center.x - topLeft.center.x;
    CGFloat height = bottomLeft.center.y- topLeft.center.y;
    CGRect rect = CGRectMake(x, y, width, height);
    self.rectangleView.frame = rect;
    
//    center.center = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
    {
        float startX = self.rectangleView.frame.origin.x;
        float startY = self.rectangleView.frame.origin.y;
        
        float endX = self.rectangleView.frame.origin.x + self.rectangleView.frame.size.width;
        float endY = self.rectangleView.frame.origin.y + self.rectangleView.frame.size.height;
        
        if( startX < self.imageView.frame.origin.x )
        {
            
        }
        if( endX > (self.imageView.frame.size.width + self.imageView.frame.origin.x ) )
        {
            
        }
    }
}

@end
