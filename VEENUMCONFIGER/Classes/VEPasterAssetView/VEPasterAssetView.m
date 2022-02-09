//
//  VEPasterAssetView.m
//  VEENUMCONFIGER
//
//  Created by mac on 2022/1/5.
//

#import "VEPasterAssetView.h"
#import "VEHelp.h"

CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t)
{
    return atan2(t.b, t.a);
}


@interface VEPasterAssetView()<UIGestureRecognizerDelegate>
{
    CGPoint _beganPoint;
    CGPoint _centerPoint;
    
    CGPoint _pasterAssetCenterPoint;
    
    float      _pinScale;
    float      _scale;
    float      _oldScale;
    BOOL    _isScale;
    
    bool    isShock;
    
    float    _angle;
    
    CGPoint _touchLocation;
    
    CGFloat _deltaAngle;
    CGFloat _beginAngle;
}
@end

@implementation VEPasterAssetView

-(void)setAngle:( float ) angle
{
    _angle = angle;
    self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-_angle), _scale, _scale);
}

- (instancetype)initWithFrame:(CGRect ) frame atIntervalWidth:( float  ) intervalWidth
{
    CGRect rect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + intervalWidth * 2.0, frame.size.height + intervalWidth * 2.0);
    self = [super initWithFrame:rect];
    if( self )
    {
        _isDrag = true;
        _isDrag_Upated = true;
        _isCurrent = true;
        _scale = 1.0;
        self.fIntervalWidth = intervalWidth;
        [self setPointWithUpLeft:CGPointMake(intervalWidth, intervalWidth) atUpRight:CGPointMake(rect.size.width - intervalWidth, intervalWidth) atBottomRight:CGPointMake(rect.size.width - intervalWidth, rect.size.height - intervalWidth) atBottomLeft:CGPointMake(intervalWidth, rect.size.height - intervalWidth)];
        
        UITapGestureRecognizer *singleTapShowHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)];
        [self addGestureRecognizer:singleTapShowHide];
    }
    return self;
}

-(void)setPointWithUpLeft:( CGPoint ) upLeftPoint atUpRight:( CGPoint ) upRightPoint atBottomRight:( CGPoint ) bottomRight atBottomLeft:( CGPoint ) bottomLeftPoint
{
//    self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1.0, 1.0);
    if( self.centerView == nil )
    {
        UIView * view= [[UIView alloc] initWithFrame:self.bounds];
        self.centerView = view;
        [self addSubview:view];
    }
    else{
        self.centerView.frame = self.bounds;
//        self.dragUpLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
    }
    
    //MARK: 左上
    {
        if( self.dragUpLeftBtn == nil ){
            self.dragUpLeftBtn = [self getDirectionBtn:CGRectMake(0, 0, self.fIntervalWidth, self.fIntervalWidth) atDirection:0];
            UIPanGestureRecognizer* movGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movGestureUpLeft:)];
            [self.dragUpLeftBtn addGestureRecognizer:movGesture];
            self.dragUpLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
        }
        else{
            CGRect rect = self.dragUpLeftBtn.frame;
            if(  _fIntervalWidth == 0 )
            {
                rect.size.width = 1;
                rect.size.height = 1;
            }
            else{
                rect.size.width = _fIntervalWidth/_scale;
                rect.size.height = _fIntervalWidth/_scale;
            }
            rect.origin = CGPointMake(upLeftPoint.x - rect.size.width, upLeftPoint.y - rect.size.height);
            self.dragUpLeftBtn.frame = rect;
            self.dragUpLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
        }
    }
    //MARK: 右上
    {
        if( self.dragUpRightBtn == nil ){
            self.dragUpRightBtn = [self getDirectionBtn:CGRectMake(self.bounds.size.width - self.fIntervalWidth, 0, self.fIntervalWidth, self.fIntervalWidth) atDirection:1];
            UIPanGestureRecognizer* movGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movGestureUpRight:)];
            [self.dragUpRightBtn addGestureRecognizer:movGesture];
            self.dragUpRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
        }
        else{
            CGRect rect = self.dragUpRightBtn.frame;
            if(  _fIntervalWidth == 0 )
            {
                rect.size.width = 1;
                rect.size.height = 1;
            }
            else{
                rect.size.width = _fIntervalWidth/_scale;
                rect.size.height = _fIntervalWidth/_scale;
            }
            rect.origin = CGPointMake(upRightPoint.x, upRightPoint.y - rect.size.height);
            self.dragUpRightBtn.frame = rect;
            self.dragUpRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
        }
    }
    //MARK: 右下
    {
        if( self.dragBottomRightBtn == nil ){
            self.dragBottomRightBtn = [self getDirectionBtn:CGRectMake(self.bounds.size.width - self.fIntervalWidth, self.bounds.size.height - self.fIntervalWidth, self.fIntervalWidth, self.fIntervalWidth) atDirection:2];
            UIPanGestureRecognizer* movGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movGestureBottomRight:)];
            [self.dragBottomRightBtn addGestureRecognizer:movGesture];
            self.dragBottomRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
        }
        else{
            CGRect rect = self.dragBottomRightBtn.frame;
            if(  _fIntervalWidth == 0 )
            {
                rect.size.width = 1;
                rect.size.height = 1;
            }
            else{
                rect.size.width = _fIntervalWidth/_scale;
                rect.size.height = _fIntervalWidth/_scale;
            }
            rect.origin = CGPointMake(bottomRight.x, bottomRight.y);
            self.dragBottomRightBtn.frame = rect;
            self.dragBottomRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
        }
    }
    //MARK: 左下
    {
        if( self.dragBottomLeftBtn == nil ){
            self.dragBottomLeftBtn = [self getDirectionBtn:CGRectMake(0, self.bounds.size.height - self.fIntervalWidth, self.fIntervalWidth, self.fIntervalWidth) atDirection:3];
            UIPanGestureRecognizer* movGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movGestureBottomLeft:)];
            [self.dragBottomLeftBtn addGestureRecognizer:movGesture];
            self.dragBottomLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
        }
        else{
            CGRect rect = self.dragBottomLeftBtn.frame;
            if(  _fIntervalWidth == 0 )
            {
                rect.size.width = 1;
                rect.size.height = 1;
            }
            else{
                rect.size.width = _fIntervalWidth/_scale;
                rect.size.height = _fIntervalWidth/_scale;
            }
            rect.origin = CGPointMake(bottomLeftPoint.x - rect.size.width, bottomLeftPoint.y);
            self.dragBottomLeftBtn.frame = rect;
            self.dragBottomLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
        }
    }
    
    [self drawPaintBrushWithUpLeft:upLeftPoint atUpRight:upRightPoint atBottomRight:bottomRight atBottomLeft:bottomLeftPoint];
}


-(UIImageView *)getDirectionBtn:(CGRect) rect atDirection:( NSInteger ) directionInteger
{
    UIImageView * sender = [[UIImageView alloc] initWithFrame:rect];
    NSString *imagePath = nil;
    switch (directionInteger) {
        case 0://左上
        {
            imagePath = [VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/New_EditVideo/scrollViewChildImage/剪辑_剪辑变形左上默认_@3x" Type:@"png"];
        }
            break;
        case 1://右上
        {
            imagePath = [VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/New_EditVideo/scrollViewChildImage/剪辑_剪辑变形右上默认_@3x" Type:@"png"];
        }
            break;
        case 2://右下
        {
            imagePath = [VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/New_EditVideo/scrollViewChildImage/剪辑_剪辑变形右下默认_@3x" Type:@"png"];
        }
            break;
        case 3://左下
        {
            imagePath = [VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/New_EditVideo/scrollViewChildImage/剪辑_剪辑变形左下默认_@3x" Type:@"png"];
        }
            break;
        default:
            break;
    }
    sender.image = [VEHelp imageWithContentOfPath:imagePath];
    
    sender.userInteractionEnabled = YES;
    [self addSubview:sender];
    return sender;
}

- (void)contentTapped:(UITapGestureRecognizer*)tapGesture
{
    if( _delegate && [_delegate respondsToSelector:@selector(pasterAssetViewShow:)] )
    {
        [_delegate pasterAssetViewShow:self];
    }
}

-(void)refreshPasterAssetViewWithUpLeftPoint:( CGPoint ) upLeftPoint atUpRight:( CGPoint ) upRightPoint atBottomRight:( CGPoint ) bottomRightPoint atBottomLeft:( CGPoint ) bottomLeftPoint
{
    float fUpLeftX =  upLeftPoint.x;
    float fUpLeftY =  upLeftPoint.y;
    float fBottomRightX = bottomRightPoint.x;
    float fBottomRightY = bottomRightPoint.y;
    
    //左上
    {
        if( fUpLeftX > upLeftPoint.x )
        {
            fUpLeftX = upLeftPoint.x;
        }
        if( fBottomRightX < upLeftPoint.x )
        {
            fBottomRightX = upLeftPoint.x;
        }
        if( fUpLeftY > upLeftPoint.y )
        {
            fUpLeftY = upLeftPoint.y;
        }
        if( fBottomRightY < upLeftPoint.y )
        {
            fBottomRightY = upLeftPoint.y;
        }
    }
    //右上
    {
        if( fUpLeftX > upRightPoint.x )
        {
            fUpLeftX = upRightPoint.x;
        }
        if( fBottomRightX < upRightPoint.x )
        {
            fBottomRightX = upRightPoint.x;
        }
        if( fUpLeftY > upRightPoint.y )
        {
            fUpLeftY = upRightPoint.y;
        }
        if( fBottomRightY < upRightPoint.y )
        {
            fBottomRightY = upRightPoint.y;
        }
    }
    //右下
    {
        if( fUpLeftX > bottomRightPoint.x )
        {
            fUpLeftX = bottomRightPoint.x;
        }
        if( fBottomRightX < bottomRightPoint.x )
        {
            fBottomRightX = bottomRightPoint.x;
        }
        if( fUpLeftY > bottomRightPoint.y )
        {
            fUpLeftY = bottomRightPoint.y;
        }
        if( fBottomRightY < bottomRightPoint.y )
        {
            fBottomRightY = bottomRightPoint.y;
        }
    }
    //左下
    {
        if( fUpLeftX > bottomLeftPoint.x )
        {
            fUpLeftX = bottomLeftPoint.x;
        }
        if( fBottomRightX < bottomLeftPoint.x )
        {
            fBottomRightX = bottomLeftPoint.x;
        }
        if( fUpLeftY > bottomLeftPoint.y )
        {
            fUpLeftY = bottomLeftPoint.y;
        }
        if( fBottomRightY < bottomLeftPoint.y )
        {
            fBottomRightY = bottomLeftPoint.y;
        }
    }
    
    CGRect rect = CGRectMake(fUpLeftX, fUpLeftY, fBottomRightX - fUpLeftX, fBottomRightY - fUpLeftY);
    {
        CGSize size = [self getSIze];
        self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), _scale, _scale);
        CGPoint center = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0);
        self.frame = CGRectMake(0, 0, (size.width + 2.0 * self.fIntervalWidth), (size.height + 2.0 * self.fIntervalWidth));
        self.center = center;
        self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-_angle), _scale, _scale);
    }
    
    upLeftPoint = [self.syncContainer convertPoint:upLeftPoint toView:self];
    upRightPoint = [self.syncContainer convertPoint:upRightPoint toView:self];
    bottomRightPoint = [self.syncContainer convertPoint:bottomRightPoint toView:self];
    bottomLeftPoint = [self.syncContainer convertPoint:bottomLeftPoint toView:self];
    
    [self setPointWithUpLeft:upLeftPoint atUpRight:upRightPoint atBottomRight:bottomRightPoint atBottomLeft:bottomLeftPoint];
}


-(CGSize)getSIze
{
    CGPoint upLeftPoint = CGPointZero;
    CGPoint upRightPoint = CGPointZero;
    CGPoint bottomRightPoint = CGPointZero;
    CGPoint bottomLeftPoint = CGPointZero;
    {
        self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), _scale, _scale);
        upLeftPoint = CGPointMake(self.dragUpLeftBtn.frame.origin.x + self.dragUpLeftBtn.frame.size.width, self.dragUpLeftBtn.frame.origin.y + self.dragUpLeftBtn.frame.size.height);
        upLeftPoint = [self convertPoint:upLeftPoint toView:self.syncContainer];
        upRightPoint = CGPointMake(self.dragUpRightBtn.frame.origin.x, self.dragUpRightBtn.frame.origin.y + self.dragUpRightBtn.frame.size.height);
        upRightPoint = [self convertPoint:upRightPoint toView:self.syncContainer];
        bottomRightPoint = CGPointMake(self.dragBottomRightBtn.frame.origin.x, self.dragBottomRightBtn.frame.origin.y);
        bottomRightPoint = [self convertPoint:bottomRightPoint toView:self.syncContainer];
        bottomLeftPoint = CGPointMake(self.dragBottomLeftBtn.frame.origin.x + self.dragBottomLeftBtn.frame.size.width, self.dragBottomLeftBtn.frame.origin.y);
        bottomLeftPoint = [self convertPoint:bottomLeftPoint toView:self.syncContainer];
        self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-_angle), _scale, _scale);
    }
    
    float fUpLeftX =  upLeftPoint.x;
    float fUpLeftY =  upLeftPoint.y;
    float fBottomRightX = bottomRightPoint.x;
    float fBottomRightY = bottomRightPoint.y;
    
    //左上
    {
        if( fUpLeftX > upLeftPoint.x )
        {
            fUpLeftX = upLeftPoint.x;
        }
        if( fBottomRightX < upLeftPoint.x )
        {
            fBottomRightX = upLeftPoint.x;
        }
        if( fUpLeftY > upLeftPoint.y )
        {
            fUpLeftY = upLeftPoint.y;
        }
        if( fBottomRightY < upLeftPoint.y )
        {
            fBottomRightY = upLeftPoint.y;
        }
    }
    //右上
    {
        if( fUpLeftX > upRightPoint.x )
        {
            fUpLeftX = upRightPoint.x;
        }
        if( fBottomRightX < upRightPoint.x )
        {
            fBottomRightX = upRightPoint.x;
        }
        if( fUpLeftY > upRightPoint.y )
        {
            fUpLeftY = upRightPoint.y;
        }
        if( fBottomRightY < upRightPoint.y )
        {
            fBottomRightY = upRightPoint.y;
        }
    }
    //右下
    {
        if( fUpLeftX > bottomRightPoint.x )
        {
            fUpLeftX = bottomRightPoint.x;
        }
        if( fBottomRightX < bottomRightPoint.x )
        {
            fBottomRightX = bottomRightPoint.x;
        }
        if( fUpLeftY > bottomRightPoint.y )
        {
            fUpLeftY = bottomRightPoint.y;
        }
        if( fBottomRightY < bottomRightPoint.y )
        {
            fBottomRightY = bottomRightPoint.y;
        }
    }
    //左下
    {
        if( fUpLeftX > bottomLeftPoint.x )
        {
            fUpLeftX = bottomLeftPoint.x;
        }
        if( fBottomRightX < bottomLeftPoint.x )
        {
            fBottomRightX = bottomLeftPoint.x;
        }
        if( fUpLeftY > bottomLeftPoint.y )
        {
            fUpLeftY = bottomLeftPoint.y;
        }
        if( fBottomRightY < bottomLeftPoint.y )
        {
            fBottomRightY = bottomLeftPoint.y;
        }
    }
    
    CGRect rect = CGRectMake(fUpLeftX, fUpLeftY, fBottomRightX - fUpLeftX, fBottomRightY - fUpLeftY);
    return rect.size;
}



-(void)RefreshPasterAssetView
{
    CGPoint upLeftPoint = CGPointZero;
    CGPoint upRightPoint = CGPointZero;
    CGPoint bottomRightPoint = CGPointZero;
    CGPoint bottomLeftPoint = CGPointZero;
    
    {
        upLeftPoint = CGPointMake(self.dragUpLeftBtn.frame.origin.x + self.dragUpLeftBtn.frame.size.width, self.dragUpLeftBtn.frame.origin.y + self.dragUpLeftBtn.frame.size.height);
        upLeftPoint = [self convertPoint:upLeftPoint toView:self.syncContainer];
        upRightPoint = CGPointMake(self.dragUpRightBtn.frame.origin.x, self.dragUpRightBtn.frame.origin.y + self.dragUpRightBtn.frame.size.height);
        upRightPoint = [self convertPoint:upRightPoint toView:self.syncContainer];
        bottomRightPoint = CGPointMake(self.dragBottomRightBtn.frame.origin.x, self.dragBottomRightBtn.frame.origin.y);
        bottomRightPoint = [self convertPoint:bottomRightPoint toView:self.syncContainer];
        bottomLeftPoint = CGPointMake(self.dragBottomLeftBtn.frame.origin.x + self.dragBottomLeftBtn.frame.size.width, self.dragBottomLeftBtn.frame.origin.y);
        bottomLeftPoint = [self convertPoint:bottomLeftPoint toView:self.syncContainer];
    }
    
    
    [self refreshPasterAssetViewWithUpLeftPoint:upLeftPoint atUpRight:upRightPoint atBottomRight:bottomRightPoint atBottomLeft:bottomLeftPoint];
}

-(void)drawPaintBrushWithUpLeft:( CGPoint ) upLeftPoint atUpRight:( CGPoint ) upRightPoint atBottomRight:( CGPoint ) bottomRightPoint atBottomLeft:( CGPoint ) bottomLeftPoint
{
    if( !_isCurrent )
    {
        if( self.maskLayer )
        {
            [self.centerView.layer.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj removeFromSuperlayer];
            }];
            [self.maskLayer removeFromSuperlayer];
            self.maskLayer = nil;
        }
        return;
    }
    if( self.maskLayer )
    {
        [self.centerView.layer.sublayers enumerateObjectsUsingBlock:^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperlayer];
        }];
        [self.maskLayer removeFromSuperlayer];
        self.maskLayer = nil;
    }
    CAShapeLayer * maskLayer= [CAShapeLayer layer];
    maskLayer.frame = self.centerView.bounds;
    UIBezierPath *basePath = [UIBezierPath bezierPath];
    
    // 起点
    [basePath moveToPoint:upLeftPoint];
    [basePath addLineToPoint:upRightPoint];
    [basePath addLineToPoint:bottomRightPoint];
    [basePath addLineToPoint:bottomLeftPoint];
    [basePath addLineToPoint:upLeftPoint];
    
    [basePath closePath];
    [basePath stroke];
    
    maskLayer.lineWidth = 2/_scale;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.path = basePath.CGPath;
    maskLayer.fillColor = nil; // 默认为blackColor
    
    [self.centerView.layer addSublayer:maskLayer];
    self.maskLayer = maskLayer;
}

#pragma mark- 拖拽变形
- (void)movGestureUpLeft:(UIGestureRecognizer *) recognizer{
    if( (self.currentBtn != self.dragUpLeftBtn) && (self.currentBtn != nil)  )
    {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.currentBtn = self.dragUpLeftBtn;
    }
    [self movGesture:recognizer];
}
- (void)movGestureUpRight:(UIGestureRecognizer *) recognizer{
    if( (self.currentBtn != self.dragUpRightBtn) && (self.currentBtn != nil)  )
    {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.currentBtn = self.dragUpRightBtn;
    }
    [self movGesture:recognizer];
}
- (void)movGestureBottomRight:(UIGestureRecognizer *) recognizer{
    if( (self.currentBtn != self.dragBottomRightBtn) && (self.currentBtn != nil)  )
    {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.currentBtn = self.dragBottomRightBtn;
    }
    [self movGesture:recognizer];
}
- (void)movGestureBottomLeft:(UIGestureRecognizer *) recognizer{
    if( (self.currentBtn != self.dragBottomLeftBtn) && (self.currentBtn != nil)  )
    {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.currentBtn = self.dragBottomLeftBtn;
    }
    [self movGesture:recognizer];
}
- (void)movGesture:(UIGestureRecognizer *) recognizer{
    CGPoint point = [((UIPanGestureRecognizer*)recognizer) translationInView:self.syncContainer];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _beganPoint = point;
        self.isDrag_Upated = false;
        if( self.currentBtn )
        {
            _centerPoint = self.currentBtn.center;
            _centerPoint = [self convertPoint:_centerPoint toView:self.syncContainer];
            _pasterAssetCenterPoint = self.center;
        }
    }else if((recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded) ) {
        
        if( self.isDrag_Upated == true )
        {
            return;
        }
        
        if(recognizer.state == UIGestureRecognizerStateChanged)
        {
            self.isDrag_Upated = false;
        }
        else{
            self.isDrag_Upated = true;
        }
        
        if( self.currentBtn )
        {
            point = CGPointMake(_beganPoint.x - point.x, _beganPoint.y - point.y);
            point = CGPointMake(_centerPoint.x - point.x, _centerPoint.y - point.y);
        
            self.currentBtn.center = [self.syncContainer convertPoint:point toView:self];;
        }
        [self RefreshPasterAssetView];
        [self recoverPasterAssetView];
        if(recognizer.state == UIGestureRecognizerStateEnded)
        {
            self.currentBtn = nil;
        }
    }
}
#pragma mark- 平移
-(void)pasterAssetViewMove_Gesture:(UIGestureRecognizer *) recognizer{
    CGPoint point = [((UIPanGestureRecognizer*)recognizer) translationInView:self.syncContainer];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _beganPoint = point;
        _centerPoint = self.center;
        _isDrag = true;
        self.isDrag_Upated = false;
    }else if((recognizer.state == UIGestureRecognizerStateChanged) || (recognizer.state == UIGestureRecognizerStateEnded) ) {
        
        if( self.isDrag_Upated == true )
        {
            return;
        }
        
        if(recognizer.state == UIGestureRecognizerStateChanged)
        {
            self.isDrag_Upated = false;
        }
        else{
            _isDrag = false;
            self.isDrag_Upated = true;
        }
        point = CGPointMake(_beganPoint.x - point.x, _beganPoint.y - point.y);
        point = CGPointMake(_centerPoint.x - point.x, _centerPoint.y - point.y);
        self.center = point;
        [self recoverPasterAssetView];
    }
}
#pragma mark- 缩放
-(void)pasterAssetViewPinch_Gesture:(UIPinchGestureRecognizer *) recognizer{
    if( recognizer.numberOfTouches == 1 )
    {
        if(recognizer.state == UIGestureRecognizerStateEnded)
        {
            self.isDrag_Upated = true;
            self.dragUpLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragUpRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragBottomRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragBottomLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            [self RefreshPasterAssetView];
            [self recoverPasterAssetView];
        }
        return;
    }
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        {
            self.isDrag_Upated = false;
            _isScale = true;
            _oldScale = _scale;
            _pinScale = recognizer.scale;
            _isDrag = true;
        }
            break;
        case UIGestureRecognizerStateChanged://缩放改变
        case UIGestureRecognizerStateEnded://缩放结束
        {
            if( self.isDrag_Upated == true )
            {
                return;
            }
            
            if(recognizer.state == UIGestureRecognizerStateChanged)
            {
                self.isDrag_Upated = false;
            }
            else{
                _isDrag = false;
                self.isDrag_Upated = true;
            }
            CGFloat newScale = 0;
            newScale =  _oldScale*recognizer.scale;
            if( newScale < 0.15 )
                newScale = 0.15;
            self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(atan2f(self.transform.b, self.transform.a)), newScale, newScale);
            _scale = newScale;
            self.dragUpLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragUpRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragBottomRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragBottomLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            [self RefreshPasterAssetView];
            [self recoverPasterAssetView];
        }
            break;
//        case UIGestureRecognizerStateEnded://缩放结束
//        {
//            self.isDrag_Upated = true;
//            self.dragUpLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
//            self.dragUpRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
//            self.dragBottomRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
//            self.dragBottomLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
//            [self RefreshPasterAssetView];
//            [self recoverPasterAssetView];
//        }
//            break;
        default:
            break;
    }
}
#pragma mark- 旋转
-(void)pasterAssetViewRotation_Gesture:(UIRotationGestureRecognizer *)rotation
{
    if( rotation.numberOfTouches == 1 )
    {
        if(rotation.state == UIGestureRecognizerStateEnded)
        {
            self.isDrag_Upated = true;
            self.dragUpLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragUpRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragBottomRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragBottomLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            [self RefreshPasterAssetView];
            [self recoverPasterAssetView];
        }
        return;
    }
    
    _touchLocation = [rotation locationInView:self.superview];
    switch (rotation.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        {
            self.isDrag_Upated = false;
            _deltaAngle      = -CGAffineTransformGetAngle(self.transform);
            _beginAngle      = rotation.rotation;
            _isScale = true;
            _isDrag = true;
        }
            break;
        case UIGestureRecognizerStateChanged://缩放改变
        case UIGestureRecognizerStateEnded://缩放结束
        {
            if( self.isDrag_Upated == true )
            {
                return;
            }
            
            if(rotation.state == UIGestureRecognizerStateChanged)
            {
                self.isDrag_Upated = false;
            }
            else{
                _isDrag = false;
                self.isDrag_Upated = true;
            }
            float angleDiff = ( _deltaAngle + (_beginAngle - rotation.rotation) );
            if( ((-angleDiff) < (20.0/180.0/3.14)) && ((-angleDiff) >= -(20.0/180.0/3.14))  )
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
//                self.isDrag_Upated = false;
            self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-angleDiff), _scale, _scale);
            _angle = angleDiff;
//            [self recoverPasterAssetView];
            self.dragUpLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragUpRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragBottomRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            self.dragBottomLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
            [self RefreshPasterAssetView];
            [self recoverPasterAssetView];
        }
            break;
//        case UIGestureRecognizerStateEnded://缩放结束
//        {
//            self.isDrag_Upated = true;
//            self.dragUpLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
//            self.dragUpRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
//            self.dragBottomRightBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
//            self.dragBottomLeftBtn.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-0), 1/_scale, 1/_scale);
//            [self RefreshPasterAssetView];
//            [self recoverPasterAssetView];
//        }
//            break;
        default:
            break;
    }
}

-( void )recoverPasterAssetView
{
//    _angle = 0.0;
//    _scale = 1.0;
//    _isScale = false;
    CGPoint upLeftPoint = CGPointZero;
    CGPoint upRightPoint = CGPointZero;
    CGPoint bottomRightPoint = CGPointZero;
    CGPoint bottomLeftPoint = CGPointZero;
    
    upLeftPoint = CGPointMake(self.dragUpLeftBtn.frame.origin.x + self.dragUpLeftBtn.frame.size.width, self.dragUpLeftBtn.frame.origin.y + self.dragUpLeftBtn.frame.size.height);
    upLeftPoint = [self convertPoint:upLeftPoint toView:self.syncContainer];
    upRightPoint = CGPointMake(self.dragUpRightBtn.frame.origin.x, self.dragUpRightBtn.frame.origin.y + self.dragUpRightBtn.frame.size.height);
    upRightPoint = [self convertPoint:upRightPoint toView:self.syncContainer];
    bottomRightPoint = CGPointMake(self.dragBottomRightBtn.frame.origin.x, self.dragBottomRightBtn.frame.origin.y);
    bottomRightPoint = [self convertPoint:bottomRightPoint toView:self.syncContainer];
    bottomLeftPoint = CGPointMake(self.dragBottomLeftBtn.frame.origin.x + self.dragBottomLeftBtn.frame.size.width, self.dragBottomLeftBtn.frame.origin.y);
    bottomLeftPoint = [self convertPoint:bottomLeftPoint toView:self.syncContainer];
    
//    self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-_angle), _scale, _scale);
    
//    [self refreshPasterAssetViewWithUpLeftPoint:upLeftPoint atUpRight:upRightPoint atBottomRight:bottomRightPoint atBottomLeft:bottomLeftPoint];
    
    if( _delegate && [_delegate respondsToSelector:@selector(pasterAssetViewMove:atUpLeft:atUpRight:atBottomRight:atBottomLeft:)] )
    {
        [_delegate pasterAssetViewMove:self atUpLeft:upLeftPoint atUpRight:upRightPoint atBottomRight:bottomRightPoint atBottomLeft:bottomLeftPoint];
    }
}

-( NSMutableArray * )getPasterAssetViewArray
{
    NSMutableArray *array = [NSMutableArray new];
    CGPoint upLeftPoint = CGPointZero;
    CGPoint upRightPoint = CGPointZero;
    CGPoint bottomRightPoint = CGPointZero;
    CGPoint bottomLeftPoint = CGPointZero;
    
    upLeftPoint = CGPointMake(self.dragUpLeftBtn.frame.origin.x + self.dragUpLeftBtn.frame.size.width, self.dragUpLeftBtn.frame.origin.y + self.dragUpLeftBtn.frame.size.height);
    upLeftPoint = [self convertPoint:upLeftPoint toView:self.syncContainer];
    upRightPoint = CGPointMake(self.dragUpRightBtn.frame.origin.x, self.dragUpRightBtn.frame.origin.y + self.dragUpRightBtn.frame.size.height);
    upRightPoint = [self convertPoint:upRightPoint toView:self.syncContainer];
    bottomRightPoint = CGPointMake(self.dragBottomRightBtn.frame.origin.x, self.dragBottomRightBtn.frame.origin.y);
    bottomRightPoint = [self convertPoint:bottomRightPoint toView:self.syncContainer];
    bottomLeftPoint = CGPointMake(self.dragBottomLeftBtn.frame.origin.x + self.dragBottomLeftBtn.frame.size.width, self.dragBottomLeftBtn.frame.origin.y);
    bottomLeftPoint = [self convertPoint:bottomLeftPoint toView:self.syncContainer];
    
    [array addObject:[NSValue valueWithCGPoint:upLeftPoint]];
    [array addObject:[NSValue valueWithCGPoint:upRightPoint]];
    [array addObject:[NSValue valueWithCGPoint:bottomRightPoint]];
    [array addObject:[NSValue valueWithCGPoint:bottomLeftPoint]];

    return array;
}

@end
