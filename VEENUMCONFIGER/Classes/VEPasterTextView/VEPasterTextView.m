//
//  VETextView.m
//  VE
//
//  Created by iOS VESDK Team on 16/4/14.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import "VEPasterTextView.h"
#import "UIImage+Tint.h"
#import <VEENUMCONFIGER/VEENUMCONFIGER.h>


/* 角度转弧度 */
#define SK_DEGREES_TO_RADIANS(angle) \
((angle) / 180.0 * M_PI)
CG_INLINE CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

//CG_INLINE CGRect CGRectScale(CGRect rect, CGFloat wScale, CGFloat hScale)
//{
//    return CGRectMake(rect.origin.x * wScale, rect.origin.y * hScale, rect.size.width * wScale, rect.size.height * hScale);
//}

CG_INLINE CGFloat CGPointGetDistance(CGPoint point1, CGPoint point2)
{
    //Saving Variables.
    CGFloat fx = (point2.x - point1.x);
    CGFloat fy = (point2.y - point1.y);
    
    return sqrt((fx*fx + fy*fy));
}

CG_INLINE CGFloat CGAffineTransformGetAngle(CGAffineTransform t)
{
    return atan2(t.b, t.a);
}


CG_INLINE CGSize CGAffineTransformGetScale(CGAffineTransform t)
{
    return CGSizeMake(sqrt(t.a * t.a + t.c * t.c), sqrt(t.b * t.b + t.d * t.d)) ;
}
@interface VEPasterTextView()<UIGestureRecognizerDelegate>
{
    CGFloat globalInset;
    float       rotateViewWidth;
    UIImageView* rotateView;
    
    CGRect initialBounds;
    CGFloat initialDistance;
    
    CGPoint beginningPoint;
    CGPoint beginningCenter;
    
    CGPoint prevPoint;
    CGPoint touchLocation;
    
//    CGRect beginBounds;
    
    CGFloat deltaAngle;
    CGFloat RotateAngle;
    
    CGFloat beginAngle;
    
    CGPoint beganLocation;
    
    BOOL _isShowingEditingHandles;
    
    CGRect originRect;
    
    
    float  _tScale;
    
    float   _selfScale;
    float   _oldSelfScale;
    
    float   pinScale;
    
    float  _zoomScale;
    float  _zoomLastScale;
    CGRect _syncContainerRect;
    UIImageView * selectImageView;
    
    UIImageView *topImageView;
    
    float selectImageViewBorderWidth;
    float selectImageViewShadowRadius;
    bool    iscanvas;
    BOOL    iswatermark;
    
    
    bool    isShock;
    float   shockX;
    BOOL    isShockY;
    float   shockY;
    //放大
    UIPinchGestureRecognizer *_GestureRecognizer;
    //移动
    UIPanGestureRecognizer* _moveGesture;
}
@end
@implementation VEPasterTextView


-(void)remove_Recognizer
{
    [self removeGestureRecognizer:_GestureRecognizer];
    [self removeGestureRecognizer:_moveGesture];
}

-(UIImageView *)getselectImageView
{
    return  selectImageView;
}

-(void)initCloseRotate
{
    rotateViewWidth = globalInset*3.0 + globalInset/4.0;
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(-rotateViewWidth/2.0 + globalInset, -rotateViewWidth/2.0 + globalInset, rotateViewWidth, rotateViewWidth)];
    _closeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin ;
    _closeBtn.backgroundColor = [UIColor clearColor];
    [_closeBtn setImage:[VEHelp imageNamed:@"next_jianji/剪辑-删除_"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(touchClose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
    
    rotateView =  [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - rotateViewWidth/2.0 - globalInset, self.bounds.size.height - rotateViewWidth/2.0 - globalInset, rotateViewWidth, rotateViewWidth)];
    rotateView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin ;
    rotateView.backgroundColor = [UIColor clearColor];
    rotateView.image = [VEHelp imageNamed:@"next_jianji/剪辑-字幕旋转_"];
    rotateView.image = [rotateView.image imageWithTintColor];
    rotateView.userInteractionEnabled = YES;
    
    rotateView.userInteractionEnabled = YES;
    [self addSubview:rotateView];
    UIPanGestureRecognizer* rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture:)];
    [rotateView addGestureRecognizer:rotateGesture];
}

-(void)initSelectImageView
{
    selectImageViewBorderWidth = 2.0;
    selectImageViewShadowRadius = 2.0;
    selectImageView = [[UIImageView alloc] init];
    selectImageView.frame = CGRectInset(self.bounds, globalInset, globalInset);
    selectImageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    selectImageView.layer.borderWidth = selectImageViewBorderWidth;
    selectImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    selectImageView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.1].CGColor;
    selectImageView.layer.shadowOffset = CGSizeZero;
    selectImageView.layer.shadowOpacity = 0.2;
    selectImageView.layer.shadowRadius = selectImageViewShadowRadius;
    selectImageView.layer.masksToBounds = true;
    selectImageView.clipsToBounds = NO;
    selectImageView.layer.allowsEdgeAntialiasing = YES;
    [self addSubview:selectImageView];
    
    
}

-(UIImageView *)getRotateView
{
    return rotateView;
}

-(float)gettScale
{
    return _tScale;
}

-(float) selfscale
{
    return _selfScale;
}

-(void)setCanvasPasterText:(BOOL) isCanvas
{
    _closeBtn.hidden = YES;
    _textEditBtn.hidden = YES;
    iscanvas = TRUE;
    
}

//加水印
-(void)setWatermarkPasterText:(BOOL) isWatermark
{
    iswatermark = isWatermark;
//    _closeBtn.hidden = YES;
    _textEditBtn.hidden = YES;
}


- (instancetype)initWithFrame:(CGRect)frame
               superViewFrame:(CGRect)superRect
                 contentImage:(UIImageView *)contentImageView
            syncContainerRect:(CGRect)syncContainerRect
{
    if (frame.size.width < 16 || isnan(frame.size.width) || isinf(frame.size.width)) {
        frame.size.width = 16;
    }
    if (frame.size.height < 16 || isnan(frame.size.height) || isinf(frame.size.height)) {
        frame.size.height = 16;
    }
    if(frame.origin.x<0 || isnan(frame.origin.x) || isinf(frame.origin.x)){
        frame.origin.x = 0;
    }
    if(frame.origin.y<0 || isnan(frame.origin.y) || isinf(frame.origin.y)){
        frame.origin.y = 0;
    }
    if (self = [super initWithFrame:frame]) {
        _captionTextIndex = 0;
        _isDrag_Upated = false;
        _isSizePrompt = true;
        iswatermark = NO;
        
        _isViewHidden_GestureRecognizer = false;
        _isEditImage = false;
        _dragaAlpha = -1;
//        _isDrag_Upated = true;
        _isDrag = false;
        _minScale = 0;
        isShock = true;
        isShockY = true;
//        self.layer.shouldRasterize = YES;
//        self.layer.rasterizationScale = YES;
//        self.layer.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
//        self.layer.shadowOpacity = 0.0;
//        self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
//        self.layer.shadowRadius = 0.0;
//        self.layer.allowsEdgeAntialiasing = YES;
        
//        contentImageView.layer.contentsGravity = kCAGravityResizeAspectFill;
        contentImageView.layer.minificationFilter = kCAFilterNearest;
        contentImageView.layer.magnificationFilter = kCAFilterNearest;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        _syncContainerRect = syncContainerRect;
        originRect = frame;
        globalInset = 8;
        rotateViewWidth = globalInset*3.0 + globalInset/4.0;
        _selfScale = 1.0;
        _alignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        
         self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        _contentImage = contentImageView;
        _contentImage.frame = CGRectInset(self.bounds, globalInset, globalInset);
        _contentImage.layer.allowsEdgeAntialiasing = YES;
        _contentImage.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        [self addSubview:_contentImage];
        
        [selectImageView removeFromSuperview];
        selectImageView = nil;
        [self initSelectImageView];
        
        [self initCloseRotate];
        
//        CGPoint center = CGRectGetCenter(self.frame);
//        CGPoint rotateViewCenter = CGRectGetCenter(rotateView.frame);
//        RotateAngle = atan2(rotateViewCenter.y-center.y, rotateViewCenter.x-center.x);
        
//        _moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
//        [self addGestureRecognizer:_moveGesture];
        
//        UIPanGestureRecognizer* rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture:)];
//        [rotateView addGestureRecognizer:rotateGesture];
        
//        [_moveGesture requireGestureRecognizerToFail:rotateGesture];//优先识别rotateGesture手势
        
//        UITapGestureRecognizer *singleTapShowHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)];
//        singleTapShowHide.delegate = self;
//        singleTapShowHide.numberOfTapsRequired = 1;
//        [self addGestureRecognizer:singleTapShowHide];
        
        //        if( _isEditImage )
        //        {
        UITapGestureRecognizer *singleTapShowHide1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleClick:)];
        singleTapShowHide1.delegate = self;
        singleTapShowHide1.numberOfTapsRequired = 2;
        [self addGestureRecognizer:singleTapShowHide1];
        
//        [singleTapShowHide requireGestureRecognizerToFail:singleTapShowHide1];
//        [_moveGesture requireGestureRecognizerToFail:singleTapShowHide1];//优先识别singleTapShowHide1手势
//        }
        
        //放大
//        _GestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
//        [self addGestureRecognizer:_GestureRecognizer];
    }
    return self;
}

-(void)getrotateViewHidden
{
    [rotateView removeFromSuperview];
    rotateView = nil;
}

-(void)setRotationGestureRecognizer
{
//    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(Rotation_GestureRecognizer:)];
//    rotation.delegate = self;
//    //手势View 对象 添加给UIImageView
//    [self addGestureRecognizer:rotation];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if( [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ||
        [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
       )
        return  false;
    else
        return true;
}


- (instancetype)initWithFrame:(CGRect)frame
             pasterViewEnbled:(BOOL)pasterViewEnbled
               superViewFrame:(CGRect)superRect
                 contentImage:(UIImageView *)contentImageView
                    textLabel:(VEPasterLabel *)textLabel
                     textRect:(CGRect )textRect
                      ectsize:(CGSize )tsize
                          ect:(CGRect )t
               needStretching:(BOOL)needStretching
                  onlyoneLine:(BOOL)onlyoneLine
                    textColor:(UIColor *)textColor
                  strokeColor:(UIColor *)strokeColor
                   strokeWidth:(float)strokeWidth syncContainerRect:(CGRect)syncContainerRect
                    isRestore:(BOOL)isREstroe
{
    
    _captionTextIndex = 0;
    _isSizePrompt = false;
    _isDrag_Upated = false;
    globalInset = 8;
    rotateViewWidth = globalInset*3.0 + globalInset/4.0;
    _syncContainerRect = syncContainerRect;
    _needStretching = needStretching;
    _tsize = tsize;
    _tOutRect = t;
    if( !isREstroe )
    {
        if (frame.size.width < globalInset*2.0) {
            frame.size.width = globalInset*2.0;
        }
        if (frame.size.height < globalInset*2.0) {
            frame.size.height = globalInset*2.0;
        }
        if(frame.origin.x<0){
            frame.origin.x = 0;
        }
        if(frame.origin.y<0){
            frame.origin.y = 0;
        }
    }
    NSLog(@"frame1:%@", NSStringFromCGRect(frame));
    if (self = [super initWithFrame:frame]) {
        iswatermark = NO;
        _isViewHidden_GestureRecognizer = false;
        _isEditImage = false;
        _dragaAlpha = -1;
//        _isDrag_Upated = true;
        _isDrag_Upated = false;
        _isDrag = false;
        _minScale = 0;
        _tScale = 1.0;
        isShock = true;
        isShockY = true;
        contentImageView.layer.minificationFilter = kCAFilterNearest;
        contentImageView.layer.magnificationFilter = kCAFilterNearest;
        
        originRect = frame;
        _selfScale = 1.0;
        _oldSelfScale = 1.0;
        _alignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        
         self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        [selectImageView removeFromSuperview];
        selectImageView = nil;
        [self initSelectImageView];
        
        [self initCloseRotate];
        
//        [self addSubview:_closeBtn];
        [self addSubview:_alignBtn];
//        [self addSubview:rotateView];
        
        [_contentImage removeFromSuperview];
        _contentImage = contentImageView;
        _contentImage.frame = CGRectInset(self.bounds, globalInset, globalInset);
        _contentImage.layer.allowsEdgeAntialiasing = YES;
        CALayer *layer = _contentImage.layer;
        layer.magnificationFilter = @"nearest";
        [self insertSubview:_contentImage atIndex:0];
        if(isnan(textRect.origin.x) || isnan(textRect.size.width)){
            return nil;
        }
        _labelBgView = [[UIView alloc] initWithFrame:textRect];
        _labelBgView.backgroundColor = [UIColor clearColor];
        _labelBgView.clipsToBounds = NO;
        _labelBgView.layer.allowsEdgeAntialiasing = YES;
        [self insertSubview:_labelBgView atIndex:1];
        
        _shadowLbl = [[VEPasterLabel alloc] initWithFrame:_labelBgView.bounds];
        _shadowLbl.text = textLabel.text;
        _shadowLbl.globalInset = globalInset;
        _shadowLbl.backgroundColor = [UIColor clearColor];
        _shadowLbl.tScale = _tScale;
        _shadowLbl.fontColor = textColor;
        _shadowLbl.strokeWidth = strokeWidth;
        _shadowLbl.needStretching = needStretching;
        _shadowLbl.onlyoneline = onlyoneLine;
        _shadowLbl.clipsToBounds = NO;
        _shadowLbl.layer.allowsEdgeAntialiasing = YES;
        _shadowLbl.lineBreakMode = NSLineBreakByCharWrapping;
        _shadowLbl.minimumScaleFactor = 5.0;
        _shadowLbl.numberOfLines = 0;
        _shadowLbl.hidden = YES;
        [_labelBgView addSubview:_shadowLbl];
        
        _contentLabel = textLabel;
        _contentLabel.frame = _labelBgView.bounds;
        _contentLabel.globalInset = globalInset;
//        [_contentLabel setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.tScale = _tScale;
        _contentLabel.fontColor = textColor;
        _contentLabel.strokeColor = strokeColor;
        _contentLabel.strokeWidth = strokeWidth;
        _contentLabel.needStretching = needStretching;
        _contentLabel.onlyoneline = onlyoneLine;
        
//        _contentLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
//        _contentLabel.layer.borderWidth = 1.0;
//        _contentLabel.layer.borderColor = [UIColor clearColor].CGColor;
//        _contentLabel.layer.shadowColor = [UIColor clearColor].CGColor;
//        _contentLabel.layer.shadowOffset = CGSizeZero;
//        _contentLabel.layer.shadowOpacity = 0.5;
//        _contentLabel.layer.shadowRadius = 2.0;
        //2019.10.31 为了解决文字毛边严重
        _contentLabel.clipsToBounds = NO;
        _contentLabel.layer.allowsEdgeAntialiasing = YES;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _contentLabel.minimumScaleFactor = 5.0;
        [_labelBgView addSubview:_contentLabel];
        
        if(!_needStretching){
            
            _contentImage.image = [contentImageView.animationImages firstObject];
            _contentImage.animationImages = contentImageView.animationImages;
            _contentImage.animationDuration = 1.6;
            [_contentImage startAnimating];
            //[_contentImage setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight];
            [_contentImage setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

            _contentImage.contentMode = UIViewContentModeScaleAspectFill;
            //_contentLabel.adjustsFontSizeToFitWidth = YES;
        }else{
//            _contentImage.layer.contents        = (id)((UIImage *)[contentImageView.animationImages firstObject]).CGImage;
            _contentImage.image = [contentImageView.animationImages firstObject];
            _contentImage.layer.contentsCenter  = contentImageView.layer.contentsCenter;
            _contentImage.layer.contentsGravity = kCAGravityResize;
            [_contentImage setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        }
        _contentLabel.numberOfLines = 0;
        
//        _moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
//        [self addGestureRecognizer:_moveGesture];
        
//        UIPanGestureRecognizer* rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture:)];
//        [rotateView addGestureRecognizer:rotateGesture];
        
//        [_moveGesture requireGestureRecognizerToFail:rotateGesture];//优先识别rotateGesture手势
        
//        UITapGestureRecognizer *singleTapShowHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)];
//        singleTapShowHide.delegate = self;
//        singleTapShowHide.numberOfTapsRequired = 1;
//        [self addGestureRecognizer:singleTapShowHide];
        
        //        if( _isEditImage )
        //        {
        UITapGestureRecognizer *singleTapShowHide1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleClick:)];
        singleTapShowHide1.delegate = self;
        singleTapShowHide1.numberOfTapsRequired = 2;
        [self addGestureRecognizer:singleTapShowHide1];
        
//        [singleTapShowHide requireGestureRecognizerToFail:singleTapShowHide1];
//        [_moveGesture requireGestureRecognizerToFail:singleTapShowHide1];//优先识别singleTapShowHide1手势
        //        }
        
        //放大
//        _GestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizer:)];
//        [self addGestureRecognizer:_GestureRecognizer];
        
        if(needStretching){
            CGPoint centPoint = self.center;
            if(self.frame.origin.x <= 0){
                centPoint.x = self.frame.size.width / 2.0 + 2;
                self.center = centPoint;
            }
            
            if(self.frame.origin.x + self.frame.size.width > superRect.size.width){
                centPoint.x = superRect.size.width  - self.frame.size.width/2.0 - 2;
                self.center = centPoint;
            }
        }
        
    }
    //initialBounds   = self.bounds;
    return self;
}

-(void)addCopyBtn
{
    _alignBtn = [[UIButton alloc] initWithFrame:CGRectMake(-rotateViewWidth/2.0 + globalInset, self.bounds.size.height - rotateViewWidth/2.0 - globalInset, rotateViewWidth, rotateViewWidth)];
    _alignBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin ;
    _alignBtn.backgroundColor = [UIColor clearColor];
    [_alignBtn setImage:[VEHelp imageNamed:@"next_jianji/剪辑-字幕居中_"] forState:UIControlStateNormal];
//    [_alignBtn addTarget:self action:@selector(alignBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _alignBtn.hidden = NO;
    [self addSubview:_alignBtn];
    _alignBtn.transform =  CGAffineTransformMakeScale(1, 1);
    _alignBtn.transform =  CGAffineTransformMakeScale(1/_selfScale, 1/_selfScale);
}

- (UIButton *)mirrorBtn {
    if ( (!_mirrorBtn) && (!_isMirror) ) {
        _mirrorBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - rotateViewWidth/2.0 - globalInset, -rotateViewWidth/2.0 + globalInset, rotateViewWidth, rotateViewWidth)];
        [_mirrorBtn setImage:[VEHelp imageNamed:@"next_jianji/剪辑-画中画镜像左右_"] forState:UIControlStateNormal];
        [_mirrorBtn setImage:[VEHelp imageNamed:@"next_jianji/剪辑-画中画镜像上下_"] forState:UIControlStateSelected];
        [_mirrorBtn addTarget:self action:@selector(mirrorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mirrorBtn];
    }
    return _mirrorBtn;
}

- (void)mirrorBtnAction:(UIButton *)sender {
    if (CGAffineTransformEqualToTransform(_contentImage.transform, CGAffineTransformIdentity)) {
        _contentImage.transform = kLRFlipTransform;//左右
        sender.selected = NO;
    }else if (CGAffineTransformEqualToTransform(_contentImage.transform, kLRFlipTransform)) {
        _contentImage.transform = kUDFlipTransform;//上下
        sender.selected = YES;
    }else if (CGAffineTransformEqualToTransform(_contentImage.transform, kUDFlipTransform)) {
        _contentImage.transform = kLRUPFlipTransform;//上下左右
        sender.selected = YES;
    }else if (CGAffineTransformEqualToTransform(_contentImage.transform, kLRUPFlipTransform)) {
        _contentImage.transform = CGAffineTransformIdentity;//复原
        sender.selected = NO;
    }
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
}

- (void)setContentImageTransform:(CGAffineTransform)transform {
    _contentImage.transform = transform;
    if (CGAffineTransformEqualToTransform(transform, kUDFlipTransform) || CGAffineTransformEqualToTransform(transform, kLRUPFlipTransform)) {
        _mirrorBtn.selected = YES;
    }
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
}

- (void)refreshBounds:(CGRect)bounds {
    if (bounds.size.width < 16) {
        bounds.size.width = 16;
    }
    if (bounds.size.height < 16) {
        bounds.size.height = 16;
    }
    self.bounds = bounds;
    _contentImage.frame = CGRectInset(self.bounds, globalInset, globalInset);
    selectImageView.frame = CGRectInset(self.bounds, globalInset, globalInset);
    if( !iswatermark )
    {
        if( _closeBtn )
        {
            _closeBtn.frame = CGRectMake(-globalInset/2.0, -globalInset/2.0, globalInset*3, globalInset*3);
        }
        if( _textEditBtn )
        {
            _textEditBtn.frame = CGRectMake(self.bounds.size.width - globalInset*3 + globalInset/2.0, -globalInset/2.0, globalInset*3, globalInset*3);
        }
        rotateView.frame = CGRectMake(self.bounds.size.width - globalInset*3 + globalInset/2.0, self.bounds.size.height - globalInset*3 + globalInset/2.0, globalInset*3, globalInset*3);
        _mirrorBtn.frame = CGRectMake(-globalInset/2.0, -globalInset/2.0, globalInset*3, globalInset*3);
    }
    
    _selfScale = self.transform.a;
    
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
    
     [self setFramescale:_selfScale];
    
    if( iswatermark )
    {
        float size = (_selfScale - 1.0)/1.2f;
        if([_delegate respondsToSelector:@selector(pasterViewSizeScale: atValue:)]){
            [_delegate pasterViewSizeScale:self atValue:size];
        }
    }
}

- (void)setIsHiddenAlignBtn:(BOOL)isHiddenAlignBtn {
    _alignBtn.hidden = isHiddenAlignBtn;
//    if( _alignBtn.isHidden )
//        [selectImageView removeFromSuperview];
}

- (void)contentTapped:(UITapGestureRecognizer*)tapGesture
{
//    if( self.syncContainer.isCalculateSelected )
//    {
//        [self.syncContainer contentTapped:tapGesture];
//        return;
//    }
    
    if( self.syncContainer == nil )
    {
        return;
    }
    
    if( _isCanCurrent )
    {
        _isCanCurrent = false;
        return;
    }
    if( _isSubtitleView )
        return;
    
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
    if( _isCutout )
    {
        //取得所点击的点的坐标
        [self setPointCutout:[tapGesture locationInView:selectImageView] isRefresh:false];
    }
    else
    {
        
    if (_isShowingEditingHandles) {
        [self hideEditingHandles];
        if( CGRectContainsPoint(self.bounds, [tapGesture locationInView:self]) )
        {
            _isCanCurrent = true;
        }
//        [self.superview bringSubviewToFront:self];
        if( [_delegate respondsToSelector:@selector(pasterViewShowText:)] )
        {
            [_delegate pasterViewShowText:self];
        }
    } else {
        [self showEditingHandles];
        if( CGRectContainsPoint(self.bounds, [tapGesture locationInView:self]) && ( self.syncContainer.currentPasterTextView == nil ) )
        {
            _isCanCurrent = true;
        }
        if( [_delegate respondsToSelector:@selector(pasterViewShowText:)] )
        {
            [_delegate pasterViewShowText:self];
        }
    }
    

    }
}

//获取图片某一点的颜色
 - (UIColor *)colorAtPixel:(CGPoint)point  isRefresh:(BOOL) isRefresh{
     if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, _contentImage.image.size.width, _contentImage.image.size.height), point)) {
         return nil;
     }
     
     NSInteger pointX = trunc(point.x);
     NSInteger pointY = trunc(point.y);
     CGImageRef cgImage = _contentImage.image.CGImage;
     NSUInteger width = _contentImage.image.size.width;
     NSUInteger height = _contentImage.image.size.height;
     CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
     int bytesPerPixel = 4;
     int bytesPerRow = bytesPerPixel * 1;
     NSUInteger bitsPerComponent = 8;
     unsigned char pixelData[4] = { 0, 0, 0, 0 };
     CGContextRef context = CGBitmapContextCreate(pixelData,
                                                  1,
                                                  1,
                                                  bitsPerComponent,
                                                  bytesPerRow,
                                                  colorSpace,
                                                  kCGImageAlphaPremultipliedLast |     kCGBitmapByteOrder32Big);
     CGColorSpaceRelease(colorSpace);
     CGContextSetBlendMode(context, kCGBlendModeCopy);
     
     CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
     CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
     CGContextRelease(context);
     
     CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
     CGFloat green = (CGFloat)pixelData[1] / 255.0f;
     CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
     CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
     
     if( [_delegate respondsToSelector:@selector(paster_CutoutColor: atColorRed: atColorGreen: atColorBlue: atAlpha: isRefresh:)] )
     {
         [_delegate paster_CutoutColor:self atColorRed:red atColorGreen:green atColorBlue:blue atAlpha:alpha isRefresh:isRefresh];
     }
     
     return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
 }

//抠图颜色获取界面
-(void)setPointCutout:(CGPoint ) point isRefresh:(BOOL) isRefresh
{
//    point = CGPointMake(point.x - _contentImage.frame.origin.x, point.y - _contentImage.frame.origin.y );
    if( point.x < (_cutoutHeight/2.0/_selfScale)  )
    {
        point = CGPointMake(_cutoutHeight/2.0/_selfScale, point.y);
    }
    if(point.y < (_cutoutHeight/2.0/_selfScale))
    {
        point = CGPointMake(point.x, _cutoutHeight/2.0/_selfScale);
    }
    if(point.y > (_contentImage.frame.size.height - _cutoutHeight/2.0/_selfScale))
    {
        point = CGPointMake(point.x, (_contentImage.frame.size.height - _cutoutHeight/2.0/_selfScale));
    }
    if(point.x > ((_contentImage.frame.size.width - _cutoutHeight/2.0/_selfScale) ))
    {
        point = CGPointMake(((_contentImage.frame.size.width - _cutoutHeight/2.0/_selfScale) ), point.y);
    }
    
    float imageHeight = _cutoutHeight;
    
    CGRect rect = CGRectMake( (point.x - _cutoutHeight/2.0/_selfScale)/_contentImage.frame.size.width, (point.y - _cutoutHeight/2.0/_selfScale)/_contentImage.frame.size.height, imageHeight/_selfScale/_contentImage.frame.size.width, imageHeight/_selfScale /_contentImage.frame.size.height);
    
    UIColor * color = [self colorAtPixel:CGPointMake(
     (point.x/_contentImage.frame.size.width)  * _contentImage.image.size.width,
     (point.y/_contentImage.frame.size.height) * _contentImage.image.size.height )
     isRefresh:isRefresh];
    
    UIImage * image = [VEHelp image:_contentImage.image rotation:0 cropRect:rect];
    
    _cutout_ZoomAreaView.image = nil;
    _cutout_RealAreaView.image = nil;
    
    _cutout_ZoomAreaView.image = image;
    _cutout_RealAreaView.image = image;
    
    _cutout_MagnifierView.backgroundColor = color;
    
    _cutout_MagnifierView.frame = CGRectMake( point.x + _contentImage.frame.origin.x - _cutout_MagnifierView.frame.size.width/2.0, point.y + _contentImage.frame.origin.y - _cutout_MagnifierView.frame.size.height/2.0,  _cutout_MagnifierView.frame.size.width, _cutout_MagnifierView.frame.size.height);
}

-(void)setCutoutMagnifier:(bool) isCutout
{
    if( isCutout )
    {
        selectImageView.hidden = YES;
        _closeBtn.hidden = YES;
        _textEditBtn.hidden = YES;
        rotateView.hidden = YES;
        _mirrorBtn.hidden = YES;
        
        if( !_cutout_MagnifierView )
        {
            _cutout_Height = 80;
            _cutoutHeight = 20;
            
            UIColor *backgroundColor = [UIColor  colorWithWhite:0.8 alpha:1.0];
            
            float imageHeight = _cutoutHeight/_selfScale;
            
            UIImage * image = [VEHelp image:_contentImage.image rotation:0 cropRect:CGRectMake((_contentImage.frame.size.width - imageHeight)/2.0/_contentImage.frame.size.width, (_contentImage.frame.size.height - imageHeight)/2.0/_contentImage.frame.size.height, imageHeight/_contentImage.frame.size.width, imageHeight/_contentImage.frame.size.height)];
            
//            UIColor * color = [self colorAtPixel:CGPointMake(_contentImage.frame.size.width/2.0/_contentImage.frame.size.width * _contentImage.image.size.width, _contentImage.frame.size.height/2.0/_contentImage.frame.size.height * _contentImage.image.size.height) isRefresh:true];
            
            _cutout_MagnifierView = [[UIView alloc] initWithFrame:CGRectMake((_contentImage.frame.size.width - _cutout_Height)/2.0, (_contentImage.frame.size.height - _cutout_Height)/2.0, _cutout_Height, _cutout_Height)];
            _cutout_MagnifierView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
            _cutout_MagnifierView.layer.borderColor = backgroundColor.CGColor;
            _cutout_MagnifierView.layer.cornerRadius =  _cutout_MagnifierView.frame.size.width/2.0;
            _cutout_MagnifierView.layer.borderWidth = 1.5;
            _cutout_MagnifierView.layer.cornerRadius =  _cutout_MagnifierView.frame.size.width/2.0;
            _cutout_MagnifierView.layer.shadowColor = [UIColor blackColor].CGColor;
            _cutout_MagnifierView.layer.shadowOffset = CGSizeZero;
            _cutout_MagnifierView.layer.shadowOpacity = 0.5;
            _cutout_MagnifierView.layer.shadowRadius = 2.0;
            _cutout_MagnifierView.clipsToBounds = YES;
            _cutout_MagnifierView.layer.allowsEdgeAntialiasing = YES;
            
            [self addSubview:_cutout_MagnifierView];
            
            _cutout_ZoomAreaView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, _cutout_Height - 10, _cutout_Height - 10)];
            _cutout_ZoomAreaView.layer.borderColor = backgroundColor.CGColor;
            _cutout_ZoomAreaView.layer.cornerRadius =  _cutout_ZoomAreaView.frame.size.width/2.0;
            _cutout_ZoomAreaView.layer.borderWidth = 1.5;
            _cutout_ZoomAreaView.layer.shadowColor = [UIColor blackColor].CGColor;
            _cutout_ZoomAreaView.layer.shadowOffset = CGSizeZero;
            _cutout_ZoomAreaView.layer.shadowOpacity = 0.5;
            _cutout_ZoomAreaView.layer.shadowRadius = 2.0;
            _cutout_ZoomAreaView.clipsToBounds = YES;
            _cutout_ZoomAreaView.layer.allowsEdgeAntialiasing = YES;
            
            _cutout_ZoomAreaView.image = image;
            [_cutout_MagnifierView addSubview:_cutout_ZoomAreaView];
            
            _cutout_RealAreaView = [[UIImageView alloc] initWithFrame:CGRectMake((_cutout_Height - _cutoutHeight)/2.0, (_cutout_Height - _cutoutHeight)/2.0, _cutoutHeight, _cutoutHeight)];
            _cutout_RealAreaView.layer.borderColor = backgroundColor.CGColor;
            _cutout_RealAreaView.layer.cornerRadius =  _cutout_RealAreaView.frame.size.width/2.0;
            _cutout_RealAreaView.layer.borderWidth = 1.5;
            _cutout_RealAreaView.layer.shadowColor = [UIColor blackColor].CGColor;
            _cutout_RealAreaView.layer.shadowOffset = CGSizeZero;
            _cutout_RealAreaView.layer.shadowOpacity = 0.5;
            _cutout_RealAreaView.layer.shadowRadius = 2.0;
            _cutout_RealAreaView.clipsToBounds = YES;
            _cutout_RealAreaView.layer.allowsEdgeAntialiasing = YES;
            _cutout_RealAreaView.image = image;
            [_cutout_MagnifierView addSubview:_cutout_RealAreaView];
            
            _cutout_label1 = [[UILabel alloc] initWithFrame:CGRectMake( (_cutout_Height - 5)/2.0,  (_cutout_Height - 1)/2.0, 5, 1)];
            _cutout_label1.backgroundColor = backgroundColor;
            _cutout_label1.layer.shadowColor = [UIColor blackColor].CGColor;
            _cutout_label1.layer.shadowOffset = CGSizeZero;
            _cutout_label1.layer.shadowOpacity = 0.5;
            _cutout_label1.layer.shadowRadius = 2.0;
            _cutout_label1.clipsToBounds = NO;
            _cutout_label1.layer.allowsEdgeAntialiasing = YES;
            [_cutout_MagnifierView addSubview:_cutout_label1];
            
            
            _cutout_label2 = [[UILabel alloc] initWithFrame:CGRectMake( (_cutout_Height - 1)/2.0,  (_cutout_Height - 5)/2.0, 1, 5)];
            _cutout_label2.backgroundColor = backgroundColor;
            _cutout_label2.layer.shadowColor = [UIColor blackColor].CGColor;
            _cutout_label2.layer.shadowOffset = CGSizeZero;
            _cutout_label2.layer.shadowOpacity = 0.5;
            _cutout_label2.layer.shadowRadius = 2.0;
            _cutout_label2.clipsToBounds = NO;
            _cutout_label2.layer.allowsEdgeAntialiasing = YES;
            [_cutout_MagnifierView addSubview:_cutout_label2];
            
            
            _cutout_MagnifierView.layer.borderWidth = 1.0*1/_selfScale;
            _cutout_MagnifierView.layer.shadowRadius = 2.0*1/_selfScale;
            _cutout_MagnifierView.transform = CGAffineTransformMakeScale(1, 1);
            _cutout_MagnifierView.transform = CGAffineTransformMakeScale(1/_selfScale, 1/_selfScale);

            _cutout_ZoomAreaView.layer.borderWidth = 1.0*1/_selfScale;
            _cutout_ZoomAreaView.layer.shadowRadius = 2.0*1/_selfScale;

            _cutout_RealAreaView.layer.borderWidth = 1.0*1/_selfScale;
            _cutout_RealAreaView.layer.shadowRadius = 2.0*1/_selfScale;
        }
        
        _cutout_MagnifierView.hidden = NO;
    }
    else
    {
        selectImageView.hidden = NO;
        _closeBtn.hidden = NO;
        _textEditBtn.hidden = NO;
        rotateView.hidden = NO;
        _mirrorBtn.hidden = NO;
        _cutout_MagnifierView.hidden = YES;
    }
    _isCutout = isCutout;
}

-(void)refresh
{
    if (self.superview) {
        [_closeBtn setTransform:CGAffineTransformMakeScale(1,1)];
        [rotateView setTransform:CGAffineTransformMakeScale(1,1)];
        [_mirrorBtn setTransform:CGAffineTransformMakeScale(1,1)];
        [_alignBtn setTransform:CGAffineTransformMakeScale(1,1)];
        [_textEditBtn setTransform:CGAffineTransformMakeScale(1,1)];
        CGSize scale = CGAffineTransformGetScale(self.superview.transform);
        CGAffineTransform t = CGAffineTransformMakeScale(scale.width, scale.height);
        [_closeBtn setTransform:CGAffineTransformInvert(t)];
        [rotateView setTransform:CGAffineTransformInvert(t)];
        [_alignBtn setTransform:CGAffineTransformInvert(t)];
        [_textEditBtn setTransform:CGAffineTransformInvert(t)];
        [_mirrorBtn setTransform:CGAffineTransformInvert(t)];
    }
}

-(void)setSyncContainer:( VESyncContainerView * ) syncContainer
{
    _syncContainer = syncContainer;
    
//    _syncContainer.currentPasterTextView = self;
    [_syncContainer setMark];
}

-(void)Rotation_GestureRecognizer:(UIRotationGestureRecognizer *)rotation
{
    if( self.isMainPicture )
        return;
    
    if( rotation.numberOfTouches == 1 )
    {
        return;
    }
    
    if( _isFixedCrop )
        return;
    
    
    touchLocation = [rotation locationInView:self.superview];
    
    switch (rotation.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        {
            deltaAngle      = -CGAffineTransformGetAngle(self.transform);
            beginAngle      = rotation.rotation;
        }
            break;
        case UIGestureRecognizerStateChanged://缩放改变
        {
            float angleDiff = ( deltaAngle + (beginAngle - rotation.rotation) );
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
        
            self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-angleDiff), _selfScale, _selfScale);
            
            if( _isDrag )
            {
                _isDrag_Upated = false;
//                _contentImage.alpha = 1.0;
            }
            
            
            
        }
            break;
        case UIGestureRecognizerStateEnded://缩放结束
        {
            float angleDiff = ( deltaAngle + (beginAngle - rotation.rotation) );
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
            
            self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-angleDiff), _selfScale, _selfScale);
            if( _isDrag )
            {
                _isDrag_Upated = true;
            }
        }
            break;
        default:
            break;
    }
    
    if(_delegate){
        if([_delegate respondsToSelector:@selector(pasterViewDidChangeFrame:)]){
            [_delegate pasterViewDidChangeFrame:self];
        }
        if([_delegate respondsToSelector:@selector(pasterViewMoved:)]){
            [_delegate pasterViewMoved:self];
        }
    }
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
}

- (void)pinchGestureRecognizer:(UIPinchGestureRecognizer *)recognizer {

    if( self.isMainPicture )
        return;
    
    if( _isViewHidden_GestureRecognizer && _syncContainer.currentPasterTextView != self )
        return;
    
    if( _isCutout )
    {
        return;
    }
    CGPoint center = CGRectGetCenter(self.frame);
    
    _isScale = true;
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan://缩放开始
        {
             deltaAngle      =-CGAffineTransformGetAngle(self.transform);
                    beganLocation = touchLocation;
                    initialBounds   = CGRectIntegral(self.bounds);
                    initialDistance = CGPointGetDistance(center, touchLocation);
            
            
            pinScale = recognizer.scale;
            _oldSelfScale = _selfScale;
            
            
            
            if( _isDrag )
            {
                _isDrag_Upated = false;
//                _contentImage.alpha = 1.0;
            }
        }
            break;
        case UIGestureRecognizerStateChanged://缩放改变
        {
//            float ang =
//            -atan2(beganLocation.y-center.y, beganLocation.x-center.x) +
//            atan2(touchLocation.y-center.y, touchLocation.x-center.x);
            
//            float angleDiff = deltaAngle - ang;
            
            CGFloat newScale = 0;
            if( iswatermark )
            {
//                newScale = (recognizer.scale - 1.0) + _oldSelfScale;
                newScale =  _oldSelfScale*recognizer.scale;
                
                if( newScale > _waterMaxScale )
                    newScale = _waterMaxScale;
                else if( newScale < 1.0 )
                    newScale = 1.0;
                else
                    newScale =  _oldSelfScale*recognizer.scale;
//                    newScale = (recognizer.scale - 1.0) + _oldSelfScale;
                
            }
            else
//               newScale = (recognizer.scale - 1.0) + _oldSelfScale;
                newScale =  _oldSelfScale*recognizer.scale;
            if( _minScale > newScale )
            {
                newScale = _minScale;
            }
            

//            if( newScale < 0.20 )
//                newScale = 0.2;
            float scaleHeight = 40;
            if( _contentImage.frame.size.width > _contentImage.frame.size.height )
            {
                if( scaleHeight > ( _contentImage.frame.size.height*newScale) )
                {
                    newScale = scaleHeight/_contentImage.frame.size.height;
                }
            }
            else{
                if( scaleHeight > ( _contentImage.frame.size.width*newScale) )
                {
                    newScale = scaleHeight/_contentImage.frame.size.width;
                }
            }
            
            if( _isFixedCrop )
            {
                newScale = [self getCropREct_Scale:newScale];
            }
            
            self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(atan2f(self.transform.b, self.transform.a)), newScale, newScale);
            [self setFramescale:newScale];
            
            if( _isFixedCrop)
                self.center = [self getCropRect_Center:self.center ];
            
            if( _isSizePrompt )
            {
                CGSize size = CGSizeMake(_contentImage.frame.size.width*newScale / _syncContainer.bounds.size.width, _contentImage.frame.size.height*newScale / _syncContainer.bounds.size.height);
                CGPoint center = self.center;
                if( (center.x > (self.syncContainer.frame.size.width/2.0  - 1) ) && (center.x  < (self.syncContainer.frame.size.width/2.0  + 1) )
                   &&  (size.width >= 0.98) && (size.width <= 1.01) )
                {
                    newScale = 1.0*_syncContainer.bounds.size.width/_contentImage.frame.size.width;
                    self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(atan2f(self.transform.b, self.transform.a)), newScale, newScale);
                    [self setFramescale:newScale];
                    if( isShock )
                    {
                        AudioServicesPlaySystemSound(1519);
                        isShock = false;
                    }
                }
                else
                {
                    isShock = true;
                    if( (center.y > (self.syncContainer.frame.size.width/2.0 - 1) ) && (center.y  < (self.syncContainer.frame.size.width/2.0 + 1) )
                       &&  (size.height >= 0.98) && (size.height <= 1.02))
                    {
                        newScale = 1.0*_syncContainer.bounds.size.height/_contentImage.frame.size.height;
                        self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(atan2f(self.transform.b, self.transform.a)), newScale, newScale);
                        [self setFramescale:newScale];
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
                }
            }
            
            if([_delegate respondsToSelector:@selector(pasterViewSizeScale: atValue:)]){
                [_delegate pasterViewSizeScale:self atValue:(_selfScale - 1.0)/1.2f];
            }
            _selfScale = newScale;
            if( _isDrag )
            {
                _isDrag_Upated = false;
//                _contentImage.alpha = 1.0;
            }
        }
            break;
        case UIGestureRecognizerStateEnded://缩放结束
            //               self.lastScale = 1;
            if( _isDrag )
            {
                _isDrag_Upated = true;
//                _contentImage.alpha = 0.0;
            }
            break;
            
        default:
            break;
    }
    
    if(_delegate){
        if([_delegate respondsToSelector:@selector(pasterViewDidChangeFrame:)]){
            [_delegate pasterViewDidChangeFrame:self];
        }
        if([_delegate respondsToSelector:@selector(pasterViewMoved:)]){
            [_delegate pasterViewMoved:self];
        }
    }
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
}

- (void) moveGesture:(UIGestureRecognizer *) recognizer{
    if( self.isMainPicture )
        return;
    
    if( recognizer.numberOfTouches == 2 )
    {
        return;
    }
    
    if( _isViewHidden_GestureRecognizer && _syncContainer.currentPasterTextView != self )
        return;
    
    _isScale = false;
    
    if( _isCutout )
    {
        //取得所点击的点的坐标
        [self setPointCutout:[recognizer locationInView:selectImageView] isRefresh:YES];
    }
    else
    {
//        touchLocation = [recognizer locationInView:self.superview];
        
        if(_delegate){
                if( self.syncContainer )
                    [self.syncContainer pasterMidline:self isHidden:false];
        }
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
//            beginningPoint = touchLocation;
//            beginningCenter = self.center;
            shockX = self.center.x;
            shockY = self.center.y;
//            CGPoint point = [((UIPanGestureRecognizer*)recognizer) translationInView:_syncContainer];
            
//            self.center = CGPointMake(self.center.x + point.x, self.center.y + point.y);
            
            [((UIPanGestureRecognizer*)recognizer) setTranslation:CGPointMake(0, 0) inView:_syncContainer];
            
//            beginBounds = self.bounds;
            if( _isDrag )
            {
                _isDrag_Upated = false;
#if 0
//                _contentImage.alpha = 1.0;
#else   //20200306 test
//                _contentImage.alpha = 0.0;
                if( _textEditBtnArray )
                {
                    [_textEditBtnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.hidden = YES;
                    }];
                }
                selectImageView.hidden = YES;
                _closeBtn.hidden = YES;
                _textEditBtn.hidden = YES;
                rotateView.hidden = YES;
                _mirrorBtn.hidden = YES;
                _alignBtn.hidden = YES;
#endif
            }
        }else if (recognizer.state == UIGestureRecognizerStateChanged){
            
            if( shockX == 0 )
            {
                shockX = self.center.x;
                shockY = self.center.y;
            }
            
            float interval = 2;
            float x = self.syncContainer.frame.size.width/2.0;
            float y = self.syncContainer.frame.size.height/2.0;
            
            CGPoint point = [((UIPanGestureRecognizer*)recognizer) translationInView:_syncContainer];
            shockX = shockX + point.x;
            shockY = shockY + point.y;
            CGPoint center = CGPointMake(shockX,shockY);
            
            if( _isFixedCrop )
            {
                center = [self getCropRect_Center:center];
            }
            
            if( ( shockX >= ( x - interval ) ) && ( shockX <= ( x + interval ) )   )
            {
                center.x = x;
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
            
            if( ( shockY >= ( y - interval ) ) && ( shockY <= ( y + interval ) )   )
            {
                center.y = y;
                if( isShockY )
                {
                    AudioServicesPlaySystemSound(1519);
                    isShockY = false;
                }
            }
            else
            {
                isShockY = true;
            }
            
//            if( center.x < 10 )
//            {
//                center.x = 0;
//                if( self.center.x != center.x )
//                    AudioServicesPlaySystemSound(1519);
//            }
//            else if( center.x > ( self.syncContainer.frame.size.width - 10 ) )
//            {
//                center.x = self.syncContainer.frame.size.width;
//                if( self.center.x != center.x )
//                    AudioServicesPlaySystemSound(1519);
//            }
//
//            if( center.y < 10 )
//            {
//                center.y = 0;
//                if( self.center.y != center.y )
//                    AudioServicesPlaySystemSound(1519);
//            }
//            else if( center.y > ( self.syncContainer.frame.size.height - 10 ) )
//            {
//                center.y = self.syncContainer.frame.size.height;
//                if( self.center.y != center.y )
//                    AudioServicesPlaySystemSound(1519);
//            }
            
            [self setCenter:center];
            
            [((UIPanGestureRecognizer*)recognizer) setTranslation:CGPointMake(0, 0) inView:_syncContainer];
            
            if( _isDrag )
            {
                _isDrag_Upated = false;
            }
        }else if (recognizer.state == UIGestureRecognizerStateEnded){
            
            if( shockX == 0 )
            {
                shockX = self.center.x;
                shockY = self.center.y;
            }
            
            float interval = 2;
            float x = self.syncContainer.frame.size.width/2.0;
            float y = self.syncContainer.frame.size.height/2.0;
            
            CGPoint point = [((UIPanGestureRecognizer*)recognizer) translationInView:_syncContainer];
            shockX = shockX + point.x;
            shockY = shockY + point.y;
            CGPoint center = CGPointMake(shockX,shockY);
            
            if( _isFixedCrop )
            {
                center = [self getCropRect_Center:center];
            }
            
            if( ( shockX >= ( x - interval ) ) && ( shockX <= ( x + interval ) )   )
            {
                center.x = x;
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
            
            if( ( shockY >= ( y - interval ) ) && ( shockY <= ( y + interval ) )   )
            {
                center.y = y;
                if( isShockY )
                {
                    AudioServicesPlaySystemSound(1519);
                    isShockY = false;
                }
            }
            else
            {
                isShockY = true;
            }
            
            
//            if( center.x < 10 )
//            {
//                center.x = 10;
//                if( self.center.x != center.x )
//                    AudioServicesPlaySystemSound(1519);
//            }
//            else if( center.x > (self.syncContainer.frame.size.width - 10 ) )
//            {
//                center.x = self.syncContainer.frame.size.width;
//                if( self.center.x != center.x )
//                    AudioServicesPlaySystemSound(1519);
//            }
//
//            if( center.y < 10 )
//            {
//                center.y = 0;
//                if( self.center.y != center.y )
//                    AudioServicesPlaySystemSound(1519);
//            }
//            else if( center.y > ( self.syncContainer.frame.size.height - 10 ) )
//            {
//                center.y = self.syncContainer.frame.size.height;
//                if( self.center.y != center.y )
//                    AudioServicesPlaySystemSound(1519);
//            }
            
            [self setCenter:center];
            
            [((UIPanGestureRecognizer*)recognizer) setTranslation:CGPointMake(0, 0) inView:_syncContainer];
            
            //            if(_delegate){
            if( self.syncContainer )
                [self.syncContainer pasterMidline:self isHidden:false];
            //            }
            if( _isDrag )
            {
                _isDrag_Upated = true;
                if( _textEditBtnArray )
                {
                    [_textEditBtnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.hidden = NO;
                    }];
                }
//                _contentImage.alpha = 0.0;
#if 1   //20200306 test
                selectImageView.hidden = NO;
                _closeBtn.hidden = NO;
                _textEditBtn.hidden = NO;
                rotateView.hidden = NO;
                _mirrorBtn.hidden = NO;
                _alignBtn.hidden = NO;
#endif
            }
        }
//        prevPoint = touchLocation;
        
        if([_delegate respondsToSelector:@selector(pasterViewMoved:)]){
            [_delegate pasterViewMoved:self];
        }
        [_contentLabel setNeedsLayout];
        [_shadowLbl setNeedsLayout];
    }
}

- (void)touchClose{
    if(_delegate){
        if([_delegate respondsToSelector:@selector(pasterViewDidClose:)]){
            [_delegate pasterViewDidClose:self];
        }
    }
    [self removeFromSuperview];
}

- (NSInteger)getTextAlign{
    if (_alignment == NSTextAlignmentLeft) {
        return 0;
    }
    else if (_alignment == NSTextAlignmentCenter) {
        return 1;
    }else {
        return 2;
    }
}

- (void)alignBtnAction:(UIButton *)sender {
    if (_alignment == NSTextAlignmentRight) {
       self.alignment = NSTextAlignmentLeft;
    }
    else if (_alignment == NSTextAlignmentCenter) {
        self.alignment = NSTextAlignmentRight;
    }else {
        self.alignment = NSTextAlignmentCenter;
    }
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
}

- (void)setIsBold:(BOOL)isBold{
    _isBold = isBold;
    _contentLabel.isBold = _isBold;
    _shadowLbl.isBold = _isBold;
}

- (void)setAlignment:(NSTextAlignment)alignment {
    _alignment = alignment;
    if (alignment == NSTextAlignmentLeft) {
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.tAlignment = UICaptionTextAlignmentLeft;
        _shadowLbl.textAlignment = NSTextAlignmentLeft;
        _shadowLbl.tAlignment = UICaptionTextAlignmentLeft;
        [_alignBtn setImage:[VEHelp imageNamed:@"next_jianji/剪辑-字幕居左_"] forState:UIControlStateNormal];
    }
    else if (alignment == NSTextAlignmentRight) {
        _contentLabel.textAlignment = NSTextAlignmentRight;
        _contentLabel.tAlignment = UICaptionTextAlignmentRight;
        _shadowLbl.textAlignment = NSTextAlignmentRight;
        _shadowLbl.tAlignment = UICaptionTextAlignmentRight;
        [_alignBtn setImage:[VEHelp imageNamed:@"next_jianji/剪辑-字幕居右_"] forState:UIControlStateNormal];
    }else {
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.tAlignment = UICaptionTextAlignmentCenter;
        _shadowLbl.textAlignment = NSTextAlignmentCenter;
        _shadowLbl.tAlignment = UICaptionTextAlignmentCenter;
        [_alignBtn setImage:[VEHelp imageNamed:@"next_jianji/剪辑-字幕居中_"] forState:UIControlStateNormal];
    }
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
}

- (void) setFramescale:(float)value{
    if (isnan(value)) {
        return;
    }
//    NSLog(@"frame2:%@", NSStringFromCGRect(self.frame));
    _selfScale = value;
    
    selectImageView.layer.borderWidth = selectImageViewBorderWidth*1/value;
    selectImageView.layer.shadowRadius = selectImageViewShadowRadius*1/value;
    
    _cutout_MagnifierView.layer.borderWidth = 1.0*1/value;
    _cutout_MagnifierView.layer.shadowRadius = 2.0*1/value;
    _cutout_MagnifierView.transform = CGAffineTransformMakeScale(1, 1);
    _cutout_MagnifierView.transform = CGAffineTransformMakeScale(1/value, 1/value);

    _cutout_ZoomAreaView.layer.borderWidth = 1.0*1/value;
    _cutout_ZoomAreaView.layer.shadowRadius = 2.0*1/value;

    _cutout_RealAreaView.layer.borderWidth = 1.0*1/value;
    _cutout_RealAreaView.layer.shadowRadius = 2.0*1/value;
    
    if( _contentLabel )
    {
        _labelBgView.transform = CGAffineTransformIdentity;
        float width = _labelBgView.frame.size.width/_tScale;
        float height = _labelBgView.frame.size.height/_tScale;
        CGPoint center = CGRectGetCenter(_labelBgView.frame);
        _labelBgView.frame = CGRectMake( center.x -  (width * value)/2.0  , center.y - (height * value)/2.0, width * value , height * value );
        if(_isItalic){
            if (_isVerticalText) {
                _labelBgView.transform = CGAffineTransformMake(1/value, 0, tanf(0 * (CGFloat)M_PI / 180), 1/value, 0, 0);
                CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);//设置倾斜角度。
                UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:_fontName matrix:matrix];
                _contentLabel.font = [UIFont fontWithDescriptor:desc size:_fontSize*value];
            }else {
                _labelBgView.transform = CGAffineTransformMake(1/value, 0, tanf(-15 * (CGFloat)M_PI / 180), 1/value, 0, 0);
                _contentLabel.font = [UIFont fontWithName:_fontName size:_fontSize*value];
            }
        }else{
            _labelBgView.transform = CGAffineTransformMake(1/value, 0, tanf(0 * (CGFloat)M_PI / 180), 1/value, 0, 0);
            _contentLabel.font = [UIFont fontWithName:_fontName size:_fontSize*value];
        }
        _tScale = value;
        _contentLabel.frame = _labelBgView.bounds;
//        _contentLabel.tScale = _tScale;
        _shadowLbl.font = _contentLabel.font;
        _shadowLbl.frame = CGRectMake(_shadowOffset.width*_tScale, _shadowOffset.height*_tScale, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
        [_contentLabel setNeedsLayout];
        [_shadowLbl setNeedsLayout];
    }
    
    rotateView.transform = CGAffineTransformMakeScale(1, 1);
    rotateView.transform =  CGAffineTransformMakeScale(1/value, 1/value);

    _alignBtn.transform =  CGAffineTransformMakeScale(1, 1);
    _alignBtn.transform =  CGAffineTransformMakeScale(1/value, 1/value);

    _mirrorBtn.transform = CGAffineTransformMakeScale(1, 1);
    _mirrorBtn.transform = CGAffineTransformMakeScale(1/value, 1/value);
    
    _closeBtn.transform =  CGAffineTransformMakeScale(1, 1);
    _closeBtn.transform =  CGAffineTransformMakeScale(1/value, 1/value);

    _textEditBtn.transform =  CGAffineTransformMakeScale(1, 1);
    _textEditBtn.transform = CGAffineTransformMakeScale(1/value, 1/value);
    
    if( _closeBtn )
    {
        CGPoint center = _closeBtn.center;
        _closeBtn.frame = CGRectMake(0, 0, rotateView.frame.size.width, rotateView.frame.size.height);
        _closeBtn.center = center;
    }
    
    if( _textEditBtn )
    {
        CGPoint center = _textEditBtn.center;
        _textEditBtn.frame = CGRectMake(0, 0, rotateView.frame.size.width, rotateView.frame.size.height);
        _textEditBtn.center = center;
    }
    
    [self refreshTextEidtFrameEx];
//    [self refreshTextEidtFrameEx];
}

- (float) getFramescale{
    return _selfScale;
}


-(float)Angle
{
    CGPoint center = CGRectGetCenter(self.frame);
    CGPoint rotateViewCenter = beganLocation;
    CGPoint closeBtnCenter = touchLocation;
    
    CGFloat x1 = rotateViewCenter.x - center.x;
    CGFloat y1 = rotateViewCenter.y - center.y;
    CGFloat x2 = closeBtnCenter.x - center.x;
    CGFloat y2 = closeBtnCenter.y - center.y;
    
    CGFloat x = x1 * x2 + y1 * y2;
    CGFloat y = x1 * y2 - x2 * y1;
    return atan2( y, x );
}

- (void) rotateGesture:(UIGestureRecognizer *) recognizer{
    
    if( self.isMainPicture )
        return;
    
    if( _isViewHidden_GestureRecognizer && _syncContainer.currentPasterTextView != self )
        return;
    
    touchLocation = [recognizer locationInView:self.superview];
//    touchLocation = [VEHelp solveUIWidgetFuzzyPoint:touchLocation];
    CGPoint center = CGRectGetCenter(self.frame);
//    center = [VEHelp solveUIWidgetFuzzyPoint:center];
    
    if( self.syncContainer )
       [self.syncContainer pasterMidline:self isHidden:false];
//    if( _delegate && iscanvas || iswatermark )
//    {
//        if([_delegate respondsToSelector:@selector(pasterMidline: isHidden:)]){
//                   [_delegate pasterMidline:self isHidden:false];
//               }
//    }
    
    
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        deltaAngle      =
//        floor(
//              atan2(touchLocation.y - center.y, touchLocation.x-center.x)
              - CGAffineTransformGetAngle(self.transform)
//        )
        ;
        beganLocation = touchLocation;
        initialBounds   = CGRectIntegral(self.bounds);
        initialDistance =
//        floor(
                                CGPointGetDistance(center, touchLocation)
//        )
        ;
        _oldSelfScale = _selfScale;
        if( _isDrag )
        {
            _isDrag_Upated = false;
//            _contentImage.alpha = 1.0;
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged){
        float ang =
        -atan2(beganLocation.y-center.y, beganLocation.x-center.x) +
//        [self Angle];
        atan2(touchLocation.y-center.y, touchLocation.x-center.x);
        
        float angleDiff = deltaAngle - ang;
        
//        float oldScale = _selfScale;
        
        _zoomScale = CGPointGetDistance(center, touchLocation)/(initialDistance);
        if( iswatermark )
        {
            float watermarkScale = _oldSelfScale + (_zoomScale-1.0)*_oldSelfScale;
            
            if( watermarkScale > _waterMaxScale )
                _selfScale = _waterMaxScale;
            else if( watermarkScale < 1.0 )
                _selfScale = 1.0;
            else
                _selfScale = _oldSelfScale + (_zoomScale-1.0)*_oldSelfScale;
        }
        else
            _selfScale = _oldSelfScale + (_zoomScale-1.0)*_oldSelfScale;
//        if(_zoomScale>1){
//            if(_zoomScale>_zoomLastScale){
//                _selfScale +=0.04;
//            }
//            else if(_zoomLastScale>_zoomScale){
//                _selfScale -=0.04;
//            }
//        }else if(_zoomScale<1){
//            if(_zoomScale>_zoomLastScale)
//                _selfScale +=0.02;
//            else if(_zoomLastScale>_zoomScale){
//                _selfScale -=0.02;
//            }
//        }
        _zoomLastScale = _zoomScale;
        if( _contentLabel )
        {
            float size = (_selfScale - 1.0)/1.2f;
            float scale;// = oldScale;
//
//            float fontSize = _fontSize * (size*1.2f + 1.0);
//
//            float RestrictedFontSize = 6.0;
//            if( !_needStretching )
//                RestrictedFontSize = 4.0;
//
//            if( ( fontSize > RestrictedFontSize )
//               && (size < 4.0)
//               )
//                scale = _selfScale;
//            else
//            {
//                if( size >= 4.0 )
//                    size = 4.0;
//                else
//                    if(  fontSize < RestrictedFontSize )
//                        size = (RestrictedFontSize/_fontSize - 1.0)/1.2f;
//
//                _selfScale = size*1.2f + 1.0;
                scale = _selfScale;
                
                
//            }
            if( ((-angleDiff) < (20.0/180.0/3.14)) && ((-angleDiff) >= (-20.0/180.0/3.14))  )
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
            float fheight = (scale*CGRectGetHeight(self.frame));
            scale = fheight/CGRectGetHeight(self.frame);
            
            self.transform =  CGAffineTransformScale(CGAffineTransformMakeRotation(-angleDiff), scale, scale);
            [self setFramescale:scale];
            if([_delegate respondsToSelector:@selector(pasterViewSizeScale: atValue:)]){
                [_delegate pasterViewSizeScale:self atValue:size];
            }
        }
        else{
            float size = (_selfScale - 1.0)/1.2f;
            float scale = _selfScale;
            
            if( ((-angleDiff) < (20.0/180.0/3.14)) && ((-angleDiff) >= (-20.0/180.0/3.14))  )
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
            
            if( _minScale > scale )
            {
                scale = _minScale;
            }
            
            self.transform =  CGAffineTransformScale(CGAffineTransformMakeRotation(-angleDiff), scale, scale);
            [self setFramescale:scale];
            
            if( _isSizePrompt )
            {
                CGSize size = CGSizeMake(_contentImage.frame.size.width*scale / _syncContainer.bounds.size.width, _contentImage.frame.size.height*scale / _syncContainer.bounds.size.height);
                CGPoint center = self.center;
                if( (center.x > (self.syncContainer.frame.size.width/2.0  - 1) ) && (center.x  < (self.syncContainer.frame.size.width/2.0  + 1) )
                   &&  (size.width >= 0.98) && (size.width <= 1.01) )
                {
                    scale = 1.0*_syncContainer.bounds.size.width/_contentImage.frame.size.width;
                    self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(atan2f(self.transform.b, self.transform.a)), scale, scale);
                    [self setFramescale:scale];
                    if( isShock )
                    {
                        AudioServicesPlaySystemSound(1519);
                        isShock = false;
                    }
                }
                else
                {
                    isShock = true;
                    if( (center.y > (self.syncContainer.frame.size.width/2.0 - 1) ) && (center.y  < (self.syncContainer.frame.size.width/2.0 + 1) )
                       &&  (size.height >= 0.98) && (size.height <= 1.02))
                    {
                        scale = 1.0*_syncContainer.bounds.size.height/_contentImage.frame.size.height;
                        self.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(atan2f(self.transform.b, self.transform.a)), scale, scale);
                        [self setFramescale:scale];
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
                }
            }
            
            if([_delegate respondsToSelector:@selector(pasterViewSizeScale: atValue:)]){
                [_delegate pasterViewSizeScale:self atValue:size];
            }
        }
        if( _isDrag )
        {
            _isDrag_Upated = false;
        }
        
    }else if(recognizer.state == UIGestureRecognizerStateEnded){
        
           if( self.syncContainer )
            [self.syncContainer pasterMidline:self isHidden:false];
        if( _isDrag )
        {
            _isDrag_Upated = true;
//            _contentImage.alpha = 0.0;
        }
    }
    if(_delegate){
        if([_delegate respondsToSelector:@selector(pasterViewDidChangeFrame:)]){
            [_delegate pasterViewDidChangeFrame:self];
        }
        if([_delegate respondsToSelector:@selector(pasterViewMoved:)]){
            [_delegate pasterViewMoved:self];
        }
    }
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
}
-(void)setMinScale:(float) scale
{
    _minScale = scale;
}


- (void)setTextString:(NSString *)text adjustPosition:(BOOL)adjust{
    _contentLabel.isUseAttributedText = NO;
    _shadowLbl.isUseAttributedText = NO;
    _contentLabel.pText = text;
    _shadowLbl.pText = text;
    NSMutableString * attributedText = [NSMutableString string];
    if (_isVerticalText) {
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
        ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            if (substringRange.location + substringRange.length == text.length) {
                [attributedText insertString:substring atIndex:attributedText.length];
            }else {
                [attributedText insertString:[substring stringByAppendingString:@"\n"] atIndex:attributedText.length];
            }
        }];
        text = attributedText;
    }else if (text.length > 0) {
        [attributedText setString:text];
    }else{
        [attributedText setString:@""];
    }
    if (text.length == 0) {
        text = @"";
    }
    if (attributedText.length > 0) {
        [_contentLabel setText:attributedText];
        [_shadowLbl setText:attributedText];
    }else{
        [_contentLabel setText:nil];
        [_shadowLbl setText:nil];
    }
    
    _contentLabel.needStretching = _needStretching;
    _contentLabel.isVerticalText = _isVerticalText;
    _contentLabel.layer.contentsGravity = kCAGravityResizeAspectFill;
    _contentLabel.layer.minificationFilter = kCAFilterNearest;
    _contentLabel.layer.magnificationFilter = kCAFilterNearest;
    _shadowLbl.needStretching = _needStretching;
    _shadowLbl.isVerticalText = _isVerticalText;
    _shadowLbl.layer.contentsGravity = kCAGravityResizeAspectFill;
    _shadowLbl.layer.minificationFilter = kCAFilterNearest;
    _shadowLbl.layer.magnificationFilter = kCAFilterNearest;
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.layer.minificationFilter = kCAFilterNearest;
    self.layer.magnificationFilter = kCAFilterNearest;
    float RestrictedFontSize  = 1.0;
    if (_needStretching) {
        CGSize maxSize;
        if ( [_pname isEqualToString:@"text_sample"] ) {
            maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
            float fontSize = 22;
            UIFont *font = [UIFont fontWithName:_fontName size:fontSize];
            if(!font){
                _fontName = [[UIFont systemFontOfSize:kDefaultFontSize] fontName];//@"Baskerville-BoldItalic";
                _fontCode = @"morenziti";
                font = [UIFont fontWithName:_fontName size:fontSize];
            }
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                                     attributes:@{NSFontAttributeName:font}];
                CGSize rectSize = [attributedText boundingRectWithSize:maxSize
                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                               context:nil].size;
                CGRect frame = self.bounds;
                frame.size.width = rectSize.width + _tOutRect.origin.x + _tOutRect.size.width + globalInset*2.0;
                frame.size.height = rectSize.height + _tOutRect.origin.y + _tOutRect.size.height + globalInset*2.0;
                self.bounds = frame;
                _labelBgView.frame = CGRectMake(_tOutRect.origin.x + globalInset, _tOutRect.origin.y + globalInset, rectSize.width, rectSize.height);
                _contentLabel.frame = _labelBgView.bounds;
                _shadowLbl.frame = CGRectMake(_shadowOffset.width*_tScale, _shadowOffset.height*_tScale, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
                [self setFontSize:fontSize label:_contentLabel];
                [self setFontSize:fontSize label:_shadowLbl];
            }
            else
        {
            if (_isVerticalText) {
                maxSize = CGSizeMake(CGFLOAT_MAX, _syncContainerRect.size.height - _tOutRect.origin.y - _tOutRect.size.height);
            }
            else {
                maxSize = CGSizeMake(_syncContainerRect.size.width - _tOutRect.origin.x - _tOutRect.size.width, CGFLOAT_MAX);
            }
            if( [_pname isEqualToString:@"text_vertical"] )
            {
                maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
                float fontSize = 22;
                UIFont *font = [UIFont fontWithName:_fontName size:fontSize];
                if(!font){
                    _fontName = [[UIFont systemFontOfSize:kDefaultFontSize] fontName];//@"Baskerville-BoldItalic";
                    _fontCode = @"morenziti";
                    font = [UIFont fontWithName:_fontName size:fontSize];
                }
                NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                                         attributes:@{NSFontAttributeName:font}];
                    CGSize rectSize = [attributedText boundingRectWithSize:maxSize
                                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                   context:nil].size;
                    CGRect frame = self.bounds;
                    frame.size.width = rectSize.width + _tOutRect.origin.x + _tOutRect.size.width + globalInset*2.0;
                    frame.size.height = rectSize.height + _tOutRect.origin.y + _tOutRect.size.height + globalInset*2.0;
                    self.bounds = frame;
                    _labelBgView.frame = CGRectMake(_tOutRect.origin.x + globalInset, _tOutRect.origin.y + globalInset, rectSize.width, rectSize.height);
                    _contentLabel.frame = _labelBgView.bounds;
                    _shadowLbl.frame = CGRectMake(_shadowOffset.width*_tScale, _shadowOffset.height*_tScale, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
                    [self setFontSize:fontSize label:_contentLabel];
                    [self setFontSize:fontSize label:_shadowLbl];
            }
            else{
                float fWidth = _labelBgView.frame.size.width;
                float fHeight = _labelBgView.frame.size.height;
                for (int i = (_isVerticalText ? fWidth : fHeight); i >= 1 ; i--) {
                    UIFont *font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                    if(!font){
                        _fontName = [[UIFont systemFontOfSize:kDefaultFontSize] fontName];//@"Baskerville-BoldItalic";
                        _fontCode = @"morenziti";
                        font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                    }
                    
                    NSMutableAttributedString *attrStrText = [[NSMutableAttributedString alloc] initWithAttributedString:_shadowLbl.attributedText];
                    [attrStrText replaceCharactersInRange:NSMakeRange(0, _shadowLbl.attributedText.length) withString:text];
                    NSRange range = NSMakeRange(0, attrStrText.length);
                    
                    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attrStrText];
                    [attrStr removeAttribute:NSFontAttributeName range:range];
                    [attrStr addAttribute:NSFontAttributeName value:font range:range];
                    
                    CGSize rectSize = [attrStr boundingRectWithSize:maxSize
                                                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                    context:nil].size;
                    if((!_isVerticalText && rectSize.height <= fHeight) || (_isVerticalText && rectSize.width <= fWidth) || i == RestrictedFontSize){
                        CGRect frame = self.bounds;
                        if (_isVerticalText) {
                            frame.size.height = rectSize.height + _tOutRect.origin.y + _tOutRect.size.height + globalInset*2.0;
                            self.bounds = frame;
                            _labelBgView.frame = CGRectMake(_tOutRect.origin.x + globalInset, _tOutRect.origin.y + globalInset, rectSize.width, rectSize.height);
                        }else {
                            frame.size.width = rectSize.width + _tOutRect.origin.x + _tOutRect.size.width + globalInset*2.0;
                            self.bounds = frame;
                            _labelBgView.frame = CGRectMake(_tOutRect.origin.x + globalInset, _tOutRect.origin.y + globalInset, rectSize.width, rectSize.height);
                        }
                        _contentLabel.frame = _labelBgView.bounds;
                        _shadowLbl.frame = CGRectMake(_shadowOffset.width*_tScale, _shadowOffset.height*_tScale, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
                         [self setFontSize:i label:_contentLabel];
                         [self setFontSize:i label:_shadowLbl];
                        break;
                    }
                }
            }
            }
    }
    else
    {
        if (_isVerticalText) {
            float width = _labelBgView.frame.size.width;
            float height = _labelBgView.frame.size.height;
            for (int i = _labelBgView.frame.size.width; i >= 1 ; i--) {
                UIFont *font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                if(!font){
                    _fontName = [[UIFont systemFontOfSize:10] fontName];
                    _fontCode = @"morenziti";
                    font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                }
                CGSize size_w = [attributedText boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:font}
                                                             context:nil].size;
                CGSize size_h = [attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:font}
                                                             context:nil].size;
                
                if ((size_w.height <= height && size_h.width <= width) || ( i == RestrictedFontSize )  ) {
                    [self setFontSize:i label:_contentLabel];
                    [self setFontSize:i label:_shadowLbl];
                    break;
                }
            }
        }else {
            float textHeight = _labelBgView.frame.size.height - 5;
            for (int i = textHeight; i >= 1 ; i--) {
                UIFont *font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                if(!font){
                    _fontName = [[UIFont systemFontOfSize:10] fontName];
                    _fontCode = @"morenziti";
                    font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                }
                
                NSMutableAttributedString *attrStrText = [[NSMutableAttributedString alloc] initWithAttributedString:_shadowLbl.attributedText];
                [attrStrText replaceCharactersInRange:NSMakeRange(0, _shadowLbl.attributedText.length) withString:text];
                NSRange range = NSMakeRange(0, attrStrText.length);
                
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:attrStrText];
                [attrStr removeAttribute:NSFontAttributeName range:range];
                [attrStr addAttribute:NSFontAttributeName value:font range:range];
                
                float textWidth = _labelBgView.frame.size.width-5;
                if( textWidth <= 5 )
                {
                    textWidth = 5;
                }
                
                CGSize rectSize = [attrStr boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                               context:nil].size;
                
                if(( (rectSize.height <= _labelBgView.frame.size.height)) || ( i == RestrictedFontSize ) ){
                    [self setFontSize:i label:_contentLabel];
                    [self setFontSize:i label:_shadowLbl];
                    break;
                }
            }
        }
        _contentLabel.adjustsFontSizeToFitWidth = NO;
    }
    if(adjust)
        [self adjustPosition];
    
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
    selectImageView.frame = CGRectInset(self.bounds, globalInset, globalInset);
    if( _alignBtn )
    {
        if( _closeBtn )
        {
            _closeBtn.frame = CGRectMake(-globalInset/2.0, -globalInset/2.0, globalInset*3, globalInset*3);
//            [self textEdit];
        }
    }

    if( _textEditBtn )
    {
        _textEditBtn.frame = CGRectMake(self.bounds.size.width - globalInset*3 + globalInset/2.0, -globalInset/2.0, globalInset*3, globalInset*3);

    }
    [self setFramescale:_selfScale];
//    NSLog(@"self:%@ 文本框:%@ _tOutRect:%@ 图片：%@", NSStringFromCGSize(self.frame.size), NSStringFromCGRect(_labelBgView.frame), NSStringFromCGRect(_tOutRect), NSStringFromCGRect(_contentImage.frame));
}

- (void)setAttributedString:(NSMutableAttributedString *)attributedString isBgCaption:(BOOL)isBgCaption adjustPosition:(BOOL)adjust{
    _contentLabel.pText = attributedString.string;
    _shadowLbl.pText = attributedString.string;
    NSMutableString * attributedText = [NSMutableString string];
    if (_isVerticalText) {
        NSString *text = attributedString.string;
        text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [text enumerateSubstringsInRange:NSMakeRange(0, text.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
        ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            if (substringRange.location + substringRange.length == text.length) {
                [attributedText insertString:substring atIndex:attributedText.length];
            }else {
                [attributedText insertString:[substring stringByAppendingString:@"\n"] atIndex:attributedText.length];
            }
        }];
        [attributedString replaceCharactersInRange:NSMakeRange(0, attributedString.length) withString:attributedText];
    }else if (attributedString.string.length > 0) {
        [attributedText setString:attributedString.string];
    }else{
        [attributedText setString:@""];
    }
    NSString *text;
    if (attributedString) {
        if (isBgCaption) {
            _shadowLbl.attributedText = attributedString;
            _shadowLbl.isUseAttributedText = YES;
        }else {
            _contentLabel.attributedText = attributedString;
            _contentLabel.isUseAttributedText = YES;
        }
        text = attributedString.string;
    }else{
        _contentLabel.text = @"";
        _shadowLbl.text = @"";
        text = @"";
        if (isBgCaption) {
            _shadowLbl.isUseAttributedText = NO;
        }else {
            _contentLabel.isUseAttributedText = NO;
        }
    }
    
    _contentLabel.needStretching = _needStretching;
    _contentLabel.isVerticalText = _isVerticalText;
    _contentLabel.layer.contentsGravity = kCAGravityResizeAspectFill;
    _contentLabel.layer.minificationFilter = kCAFilterNearest;
    _contentLabel.layer.magnificationFilter = kCAFilterNearest;
    _shadowLbl.needStretching = _needStretching;
    _shadowLbl.isVerticalText = _isVerticalText;
    _shadowLbl.layer.contentsGravity = kCAGravityResizeAspectFill;
    _shadowLbl.layer.minificationFilter = kCAFilterNearest;
    _shadowLbl.layer.magnificationFilter = kCAFilterNearest;
    self.layer.contentsGravity = kCAGravityResizeAspectFill;
    self.layer.minificationFilter = kCAFilterNearest;
    self.layer.magnificationFilter = kCAFilterNearest;
    float RestrictedFontSize  = 2.0;
    if (_needStretching) {
        CGSize maxSize;
        if ( [_pname isEqualToString:@"text_sample"] ) {
            maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
            float fontSize = 22;
            UIFont *font = [UIFont fontWithName:_fontName size:fontSize];
            if(!font){
                _fontName = [[UIFont systemFontOfSize:kDefaultFontSize] fontName];//@"Baskerville-BoldItalic";
                _fontCode = @"morenziti";
                font = [UIFont fontWithName:_fontName size:fontSize];
            }
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                                     attributes:@{NSFontAttributeName:font}];
            CGSize rectSize = [attributedText boundingRectWithSize:maxSize
                                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                           context:nil].size;
            CGRect frame = self.bounds;
            frame.size.width = rectSize.width + _tOutRect.origin.x + _tOutRect.size.width + globalInset*2.0;
            frame.size.height = rectSize.height + _tOutRect.origin.y + _tOutRect.size.height + globalInset*2.0;
            self.bounds = frame;
            _labelBgView.frame = CGRectMake(_tOutRect.origin.x + globalInset, _tOutRect.origin.y + globalInset, rectSize.width, rectSize.height);
            if (isBgCaption) {
                _shadowLbl.frame = CGRectMake(_shadowOffset.width*_tScale, _shadowOffset.height*_tScale, _labelBgView.bounds.size.width, _labelBgView.bounds.size.height);
                [self setFontSize:fontSize label:_shadowLbl];
            }else {
                _contentLabel.frame = _labelBgView.bounds;
                [self setFontSize:fontSize label:_contentLabel];
            }
        }else {
            if (_isVerticalText) {
                maxSize = CGSizeMake(CGFLOAT_MAX, _syncContainerRect.size.height - _tOutRect.origin.y - _tOutRect.size.height);
            }
            else {
                maxSize = CGSizeMake(_syncContainerRect.size.width - _tOutRect.origin.x - _tOutRect.size.width, CGFLOAT_MAX);
            }
            float fWidth = _labelBgView.frame.size.width;
            float fHeight = _labelBgView.frame.size.height;
            for (int i = (_isVerticalText ? fWidth : fHeight); i >= 1 ; i--) {
                UIFont *font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                if(!font){
                    _fontName = [[UIFont systemFontOfSize:kDefaultFontSize] fontName];//@"Baskerville-BoldItalic";
                    _fontCode = @"morenziti";
                    font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                }
                NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text
                                                                                     attributes:@{NSFontAttributeName:font}];
                CGSize rectSize = [attributedText boundingRectWithSize:maxSize
                                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                context:nil].size;
                if((!_isVerticalText && rectSize.height <= fHeight) || (_isVerticalText && rectSize.width <= fWidth) || i == RestrictedFontSize){
                    CGRect frame = self.bounds;
                    if (_isVerticalText) {
                        frame.size.height = rectSize.height + _tOutRect.origin.y + _tOutRect.size.height + globalInset*2.0;
                        self.bounds = frame;
                        _labelBgView.frame = CGRectMake(_tOutRect.origin.x + globalInset, _tOutRect.origin.y + globalInset, rectSize.width, rectSize.height);
                    }else {
                        frame.size.width = rectSize.width + _tOutRect.origin.x + _tOutRect.size.width + globalInset*2.0;
                        self.bounds = frame;
                        _labelBgView.frame = CGRectMake(_tOutRect.origin.x + globalInset, _tOutRect.origin.y + globalInset, rectSize.width, rectSize.height);
                    }
                    if (isBgCaption) {
                        _shadowLbl.frame = CGRectMake(_shadowOffset.width*_tScale, _shadowOffset.height*_tScale, _labelBgView.bounds.size.width, _labelBgView.bounds.size.height);
                        [self setFontSize:i label:_shadowLbl];
                    }else {
                        _contentLabel.frame = _labelBgView.bounds;
                         [self setFontSize:i label:_contentLabel];
                    }
                    break;
                }
            }
        }
    }
    else
    {
        if (_isVerticalText) {
            float width = _labelBgView.frame.size.width;
            float height = _labelBgView.frame.size.height;
            for (int i = _labelBgView.frame.size.width; i >= 1 ; i--) {
                UIFont *font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                if(!font){
                    _fontName = [[UIFont systemFontOfSize:10] fontName];
                    _fontCode = @"morenziti";
                    font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                }
                CGSize size_w = [attributedText boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:font}
                                                             context:nil].size;
                CGSize size_h = [attributedText boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                          attributes:@{NSFontAttributeName:font}
                                                             context:nil].size;
                
                if ((size_w.height <= height && size_h.width <= width) || ( i == RestrictedFontSize )  ) {
                    if (isBgCaption) {
                        [self setFontSize:i label:_shadowLbl];
                    }else {
                        [self setFontSize:i label:_contentLabel];
                    }
                    break;
                }
            }
        }else {
            for (int i = (_labelBgView.frame.size.height - 5 ); i >= 1 ; i--) {
                UIFont *font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                if(!font){
                    _fontName = [[UIFont systemFontOfSize:10] fontName];
                    _fontCode = @"morenziti";
                    font = [UIFont fontWithName:_fontName size:(CGFloat)i];
                }
                NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:(text ? text : @"")
                                                                                     attributes:@{NSFontAttributeName:font}];
                CGSize rectSize = [attributedText boundingRectWithSize:CGSizeMake(_labelBgView.frame.size.width-globalInset*2.0, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                               context:nil].size;
                if( (rectSize.height <= _labelBgView.frame.size.height) || ( i == RestrictedFontSize ) ){
                    if (isBgCaption) {
                        [self setFontSize:i label:_shadowLbl];
                    }else {
                        [self setFontSize:i label:_contentLabel];
                    }
                    break;
                }
            }
        }
        _contentLabel.adjustsFontSizeToFitWidth = NO;
    }
    if(adjust)
        [self adjustPosition];
    if (isBgCaption) {
        [_shadowLbl setNeedsLayout];
    }else {
        [_contentLabel setNeedsLayout];
    }
    selectImageView.frame = CGRectInset(self.bounds, globalInset, globalInset);
    if( _alignBtn )
    {
        if( _closeBtn )
        {
            _closeBtn.frame = CGRectMake(-globalInset/2.0, -globalInset/2.0, globalInset*3, globalInset*3);
//            [self textEdit];
        }
    }

    if( _textEditBtn )
    {
        _textEditBtn.frame = CGRectMake(self.bounds.size.width - globalInset*3 + globalInset/2.0, -globalInset/2.0, globalInset*3, globalInset*3);

    }
    [self setFramescale:_selfScale];
//    NSLog(@"self:%@ 文本框:%@ _tOutRect:%@ 图片：%@", NSStringFromCGSize(self.frame.size), NSStringFromCGRect(_labelBgView.frame), NSStringFromCGRect(_tOutRect), NSStringFromCGRect(_contentImage.frame));
}

- (void)adjustPosition{

    if(self.superview.frame.size.width==0 || self.superview.frame.size.height==0){
        return;
    }
    CGFloat radius = atan2f(self.transform.b, self.transform.a);
    //double duijiaoxian = hypot(((double) _pasterView.frame.size.width), ((double) _pasterView.frame.size.height));//已知直角三角形两个直角边长度，求斜边长度
    float captionLastScale = [self getFramescale];
    double s = fabs(sin(radius));
    double c = fabs(cos(radius));
    
    float x = (c * self.contentImage.frame.size.width + self.contentImage.frame.size.height * s)/2.0 * captionLastScale+globalInset*3;
    float y = (s * self.contentImage.frame.size.width  + self.contentImage.frame.size.height * c)/2.0 * captionLastScale+globalInset*3;
    {
        CGPoint center = self.center;
        center.x = (MAX(self.center.x, x));
        [self setCenter: center];
    }
    
    {
        
        CGPoint center = self.center;
        center.x = (MIN(self.center.x, self.superview.frame.size.width - x));
        [self setCenter: center];
    }
    
    {
        CGPoint center = self.center;
        center.y = (MAX(self.center.y, y));
        [self setCenter: center];
    }
    
    {
        CGPoint center = self.center;
        center.y = MIN(self.center.y, self.superview.frame.size.height - y);
        [self setCenter: center];
    }
}

- (void)hideEditingHandles{
    
    _closeBtn.hidden = YES;
    _textEditBtn.hidden = YES;
    _alignBtn.hidden = YES;
    if( !iscanvas  && !iswatermark)
    {
        rotateView.hidden = YES;
        selectImageView.hidden = YES;
    }
    _mirrorBtn.hidden = YES;
    
    _isShowingEditingHandles = NO;
    
    if( _textEditBtnArray )
    {
        [_textEditBtnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = YES;
        }];
        _alignBtn.hidden = YES;
    }
    _TextEditBtn.hidden = YES;
    
//    _syncContainer.currentPasterTextView = nil;
    if( _isCoverText )
    {
        if(_delegate){
            if([_delegate respondsToSelector:@selector(pasterView_PitchUp:atHidden:)]){
                [_delegate pasterView_PitchUp:self atHidden:YES];
            }
        }
    }
}
static VEPasterTextView *lastTouchedView;

- (void) showEditingHandles{
    [lastTouchedView hideEditingHandles];
    _isShowingEditingHandles = YES;
    lastTouchedView = self;
    
    if( !iscanvas  && !iswatermark)
    {
        _closeBtn.hidden = NO;
        _textEditBtn.hidden = NO;
        _alignBtn.hidden = NO;
        _mirrorBtn.hidden = NO;
    }
    
    selectImageView.hidden = NO;
    rotateView.hidden = NO;
    
//    _syncContainer.currentPasterTextView = self;
    
    if( _textEditBtnArray )
    {
        [_textEditBtnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
        }];
        _alignBtn.hidden = NO;
    }
    
    _TextEditBtn.hidden = NO;
    
//    [self setFramescale:_selfScale];
    
    if( _isCoverText )
    {
        if(_delegate){
            if([_delegate respondsToSelector:@selector(pasterView_PitchUp:atHidden:)]){
                [_delegate pasterView_PitchUp:self atHidden:NO];
            }
        }
    }
}

- (void)setIsItalic:(BOOL)isItalic{
    _isItalic = isItalic;
    _contentLabel.isItalic = _isItalic;
    _shadowLbl.isItalic = _isItalic;
    if(_isItalic){
        if (_isVerticalText) {
            _labelBgView.transform = CGAffineTransformMake(1/_tScale, 0, tanf(0 * (CGFloat)M_PI / 180), 1/_tScale, 0, 0);
            CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);//设置倾斜角度。
            UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:_fontName matrix:matrix];
            _contentLabel.font = [UIFont fontWithDescriptor:desc size:_fontSize*_tScale];
        }else {
            _labelBgView.transform = CGAffineTransformMake(1/_tScale, 0, tanf(-15 * (CGFloat)M_PI / 180), 1/_tScale, 0, 0);
            _contentLabel.font = [UIFont fontWithName:_fontName size:_fontSize*_tScale];
        }
    }else{
        _labelBgView.transform = CGAffineTransformMake(1/_tScale, 0, tanf(0 * (CGFloat)M_PI / 180), 1/_tScale, 0, 0);
        _contentLabel.font = [UIFont fontWithName:_fontName size:_fontSize*_tScale];
    }
}

- (void)setIsShadow:(BOOL)isShadow{
    _isShadow = isShadow;
    _contentLabel.isShadow = _isShadow;
    _shadowLbl.hidden = !isShadow;
}

- (void)setShadowColor:(UIColor *)shadowColor{
    _shadowColor = shadowColor;
    if(_isShadow){
        _contentLabel.tShadowColor = _shadowColor;    //设置文本的阴影色彩和透明度。
    }else{
        _contentLabel.tShadowColor = [UIColor clearColor];    //设置文本的阴影色彩和透明度。
    }
    _shadowLbl.textColor = shadowColor;
    _shadowLbl.strokeColor = shadowColor;
    _shadowLbl.fontColor = shadowColor;
    [_shadowLbl setNeedsLayout];
}

- (void)setIsVerticalText:(BOOL)isVerticalText {
    _isVerticalText = isVerticalText;
    _contentLabel.isVerticalText = isVerticalText;
    _shadowLbl.isVerticalText = isVerticalText;
}

- (void)setFontName:(NSString *)fontName
{
    _fontName = fontName;
    if(_isItalic){
        if (_isVerticalText) {
            CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);//设置倾斜角度。
            UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:_fontName matrix:matrix];
            _contentLabel.font = [UIFont fontWithDescriptor:desc size:_fontSize*_tScale];
        }else {
            _contentLabel.font = [UIFont fontWithName:_fontName size:_fontSize*_tScale];
        }
    }else{
        _contentLabel.font = [UIFont fontWithName:_fontName size:_fontSize*_tScale];
    }
    _shadowLbl.font = _contentLabel.font;
//    if(_needStretching && _contentLabel.pText.length > 0){
//        [_contentLabel adjustsWidthWithSuperOriginalSize:originRect.size textRect:_tOutRect syncContainerRect:_syncContainerRect];
//        _shadowLbl.frame = CGRectMake(_shadowOffset.width*_tScale, _shadowOffset.height*_tScale, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
//    }
    [_contentLabel setNeedsLayout];
    [_shadowLbl setNeedsLayout];
    selectImageView.frame = CGRectInset(self.bounds, globalInset, globalInset);
    if( _alignBtn )
    {
        if( _closeBtn )
        {
            _closeBtn.frame = CGRectMake(-globalInset/2.0, -globalInset/2.0, globalInset*3, globalInset*3);
//            [self textEdit];
        }
        if( _textEditBtn )
        {
            _textEditBtn.frame = CGRectMake(self.bounds.size.width - globalInset*3 + globalInset/2.0, -globalInset/2.0, globalInset*3, globalInset*3);
        }
    }
    if (_needStretching) {
        _contentImage.layer.contentsScale = _tsize.height / _contentImage.frame.size.height;
    }
    [self setFramescale:_selfScale];
}

- (void) setonlyoneline:(BOOL)onlyoneline{
    _contentLabel.onlyoneline = onlyoneline;
    _shadowLbl.onlyoneline = onlyoneline;
}

- (void)setFontSize:(CGFloat)fontSize label:(VEPasterLabel *)label
{
    NSLog(@"fontSize:%f",_fontSize);
    _fontSize = fontSize;
    UIFont * font;
    if (_isItalic && _isVerticalText) {
        CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);//设置倾斜角度。
        UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:_fontName matrix:matrix];
        font = [UIFont fontWithDescriptor:desc size:_fontSize*_tScale];
    }else {
        font = [UIFont fontWithName:_fontName size:_fontSize*_tScale];
        label.font = font;
    }
    if (label.isUseAttributedText) {
        NSRange range = NSMakeRange(0, label.attributedText.length);
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
        [attrStr removeAttribute:NSFontAttributeName range:range];
        [attrStr addAttribute:NSFontAttributeName value:font range:range];
        label.attributedText = attrStr;
    }else {
        label.font = font;
    }
    if (_needStretching) {
        _contentImage.layer.contentsScale = _tsize.height / _contentImage.frame.size.height;
    }
}

- (void)dealloc{
    NSLog(@"%s",__func__);
    
    [_textEditBtnLayerArrary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *array = (NSMutableArray*)obj;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            CAShapeLayer *layer = (CAShapeLayer*)obj1;
            [layer removeFromSuperlayer];
        }];
    }];
    
    if( _contentImage )
    {
        _contentImage.image = nil;
        [_contentImage removeFromSuperview];
        _contentImage = nil;
    }
    
    if( rotateView )
    {
        rotateView.image = nil;
        [rotateView removeFromSuperview];
        rotateView = nil;
    }
    
    if( rotateView )
    {
        rotateView.image = nil;
        [rotateView removeFromSuperview];
        rotateView = nil;
    }
    
    if( selectImageView )
    {
        selectImageView.image = nil;
        [selectImageView removeFromSuperview];
        selectImageView = nil;
    }
    
    if( _closeBtn )
    {
        [_closeBtn removeFromSuperview];
        _closeBtn = nil;
    }
    
    if( _alignBtn )
    {
        [_alignBtn removeFromSuperview];
        _alignBtn = nil;
    }
    
    if( _closeBtn )
    {
        [_closeBtn removeFromSuperview];
        _closeBtn = nil;
    }
    
    if( _mirrorBtn )
    {
        [_mirrorBtn removeFromSuperview];
        _mirrorBtn = nil;
    }
    
    if( _contentLabel )
    {
        [_contentLabel removeFromSuperview];
        _contentLabel = nil;
    }
    
    if( _shadowLbl )
    {
        [_shadowLbl removeFromSuperview];
        _shadowLbl = nil;
    }
    
    if( _closeBtn )
    {
        [_closeBtn removeFromSuperview];
        _closeBtn = nil;
    }
    
    if( _cutout_MagnifierView )
    {
        [_cutout_label1 removeFromSuperview];
        _cutout_label1 = nil;
        
        [_cutout_label2 removeFromSuperview];
        _cutout_label2 = nil;
        
        [_cutout_ZoomAreaView removeFromSuperview];
        _cutout_ZoomAreaView = nil;
        
        [_cutout_RealAreaView removeFromSuperview];
        _cutout_RealAreaView = nil;
        
        [_cutout_MagnifierView removeFromSuperview];
        _cutout_MagnifierView = nil;
    }
}

-(void)setTextEdit
{
    [_textEditBtn removeFromSuperview];
    _textEditBtn = nil;
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - globalInset*3 + globalInset/2.0, -globalInset/2.0, globalInset*3, globalInset*3)];
    _textEditBtn = btn;
    _textEditBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin ;
    _textEditBtn.backgroundColor = [UIColor clearColor];
//        [_closeBtn setImage:[VEHelp imageNamed:@"jianji/fenge/剪辑_删除素材_"] forState:UIControlStateNormal];
//    CGSize scale = CGAffineTransformGetScale(self.superview.transform);

    _textEditBtn.transform = CGAffineTransformMakeScale(1, 1);
    _textEditBtn.transform = CGAffineTransformMakeScale(1/_selfScale, 1/_selfScale);
    [_textEditBtn setImage:[VEHelp imageNamed:@"next_jianji/剪辑_文字编辑_"] forState:UIControlStateNormal];
    [_textEditBtn addTarget:self action:@selector(text_Edit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_textEditBtn];
}

-(void)text_Edit
{
    if( _isViewHidden_GestureRecognizer && _syncContainer.currentPasterTextView != self )
        return;
    
    if( _delegate && [_delegate respondsToSelector:@selector(DoubleClick_pasterViewShowText:)] )
    {
        [_delegate DoubleClick_pasterViewShowText:self];
    }
}

#pragma mark- 双击 文字编辑
-(void)DoubleClick:(UITapGestureRecognizer*)tapGesture
{
    if( self.isMainPicture )
        return;
    
    if( _isSubtitleView )
        return;
    
    if( _isViewHidden_GestureRecognizer && _syncContainer.currentPasterTextView != self )
        return;
    
    if( _isEditImage )
    {
        if( _delegate && [_delegate respondsToSelector:@selector(DoubleClick_pasterViewShowText:)] )
        {
            [_delegate DoubleClick_pasterViewShowText:self];
        }
    }
}

-(instancetype)initWithFrame:(CGRect)frame
              superViewFrame:(CGRect)superRect
                contentImage:(UIImageView *)contentImageView
           syncContainerRect:(CGRect)syncContainerRect
                   isRestore:(BOOL)isREstroe
{
    _captionTextIndex = 0;
    globalInset = 8;
    rotateViewWidth = globalInset*3.0 + globalInset/4.0;
    _syncContainerRect = syncContainerRect;
    if( !isREstroe )
    {
        if (frame.size.width < globalInset*2.0) {
            frame.size.width = globalInset*2.0;
        }
        if (frame.size.height < globalInset*2.0) {
            frame.size.height = globalInset*2.0;
        }
        if(frame.origin.x<0){
            frame.origin.x = 0;
        }
        if(frame.origin.y<0){
            frame.origin.y = 0;
        }
    }
    NSLog(@"frame1:%@", NSStringFromCGRect(frame));
    if (self = [super initWithFrame:frame]) {
        _isDrag_Upated = false;
        _isViewHidden_GestureRecognizer = false;
        _isEditImage = false;
        _dragaAlpha = -1;
        iswatermark = NO;
//        _isDrag_Upated = true;
        _isDrag = true;
        _minScale = 0;
        _tScale = 1.0;
        isShock = true;
        isShockY = true;
        
        originRect = frame;
        _selfScale = 1.0;
        _oldSelfScale = 1.0;
        _alignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        contentImageView.layer.minificationFilter = kCAFilterNearest;
        contentImageView.layer.magnificationFilter = kCAFilterNearest;
        
         self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        [selectImageView removeFromSuperview];
        selectImageView = nil;
        [self initSelectImageView];
        
        [self initCloseRotate];
        
//        [self addSubview:_closeBtn];
        [self addSubview:_alignBtn];
//        [self addSubview:rotateView];
        
        [_contentImage removeFromSuperview];
        _contentImage = contentImageView;
        _contentImage.frame = CGRectInset(self.bounds, globalInset, globalInset);
        _contentImage.layer.allowsEdgeAntialiasing = YES;
        _contentImage.alpha = 0.0;
        CALayer *layer = _contentImage.layer;
        layer.magnificationFilter = @"nearest";
        [self insertSubview:_contentImage atIndex:0];
        
        if(!_needStretching){
//            _contentImage.image = [_contentImage.animationImages firstObject];
//            _contentImage.animationImages = _contentImage.animationImages;
//            _contentImage.animationDuration = 1.6;
//            [_contentImage startAnimating];
            [_contentImage setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
            _contentImage.contentMode = UIViewContentModeScaleAspectFill;
        }else{
//            _contentImage.image = [_contentImage.animationImages firstObject];
            _contentImage.layer.contentsCenter  = _contentImage.layer.contentsCenter;
            _contentImage.layer.contentsGravity = kCAGravityResize;
            [_contentImage setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        }
        
        UIPanGestureRecognizer* rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture:)];
        [rotateView addGestureRecognizer:rotateGesture];
        
//        UITapGestureRecognizer *singleTapShowHide = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentTapped:)];
//        [self addGestureRecognizer:singleTapShowHide];
        
        UITapGestureRecognizer *singleTapShowHide1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleClick:)];
        singleTapShowHide1.delegate = self;
        singleTapShowHide1.numberOfTapsRequired = 2;
        [self addGestureRecognizer:singleTapShowHide1];
        
        if(_needStretching){
            CGPoint centPoint = self.center;
            if(self.frame.origin.x <= 0){
                centPoint.x = self.frame.size.width / 2.0 + 2;
                self.center = centPoint;
            }
            if(self.frame.origin.x + self.frame.size.width > superRect.size.width){
                centPoint.x = superRect.size.width  - self.frame.size.width/2.0 - 2;
                self.center = centPoint;
            }
        }
    }
    return  self;
}

-(void)addTextEditBoxEx:(CGRect) rect
{
    if(  _textEditBtnArray == nil  )
    {
        _textEditBtnArray = [NSMutableArray new];
        _textEditBtnLayerArrary = [NSMutableArray new];
    }
    
    UIButton * btn = [[UIButton alloc] initWithFrame:rect];
    [btn addTarget:self action:@selector(textEdit_BtnEx:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = _textEditBtnArray.count + 2300;
    [self addSubview:btn];
    [_textEditBtnArray addObject:btn];
    
    
    [self addSubview:_closeBtn];
    [self addSubview:_alignBtn];
    [self addSubview:_mirrorBtn];
    [self addSubview:rotateView];
}

-(void)textEdit_BtnEx:(UIButton *) btn
{
//    if( _isSubtitleView )
//    {
//        return;
//    }
    
    if( self.syncContainer.currentPasterTextView != self )
    {
        [self showEditingHandles];
        if( [_delegate respondsToSelector:@selector(pasterViewShowText:)] )
        {
            [_delegate pasterViewShowText:self];
        }
    }
    _captionTextIndex = btn.tag - 2300;
    
    if( _delegate && [_delegate respondsToSelector:@selector(DoubleClick_pasterViewShowText:)] )
    {
        [_delegate DoubleClick_pasterViewShowText:self];
    }
}

-(void)refreshTextEidtFrameEx
{
    [_textEditBtnLayerArrary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *array = (NSMutableArray*)obj;
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            CAShapeLayer *layer = (CAShapeLayer*)obj1;
            [layer removeFromSuperlayer];
        }];
    }];
    
    if(_textEditBtnLayerArrary && _textEditBtnLayerArrary.count )
    {
        [_textEditBtnLayerArrary removeAllObjects];
    }
    
    [_textEditBtnArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if( _isPESDK )
        {
            [obj setEnabled:YES];
            [obj setUserInteractionEnabled:YES];
        }
        NSMutableArray * array = [NSMutableArray new];
        {
            CAShapeLayer *layer   = [[CAShapeLayer alloc] init];
            //            layer.t
            layer.frame            = CGRectMake(0, 0 , obj.frame.size.width, obj.frame.size.height);
            layer.backgroundColor   = [UIColor clearColor].CGColor;
            UIBezierPath *path    = [UIBezierPath bezierPathWithRoundedRect:layer.frame cornerRadius:4.0f/_selfScale];
            layer.path             = path.CGPath;
            layer.lineWidth         = 0.9/_selfScale;
            layer.lineDashPattern    = @[@(8/_selfScale), @(8/_selfScale)];
            layer.fillColor          = [UIColor clearColor].CGColor;
            layer.strokeColor       = [UIColor colorWithWhite:0.6 alpha:0.5].CGColor;
            [obj.layer addSublayer:layer];
            [array addObject:layer];
        }
        {
            CAShapeLayer *layer   = [[CAShapeLayer alloc] init];
            layer.frame            = CGRectMake(0, 0 , obj.frame.size.width, obj.frame.size.height);
            layer.backgroundColor   = [UIColor clearColor].CGColor;
            UIBezierPath *path    = [UIBezierPath bezierPathWithRoundedRect:layer.frame cornerRadius:4.0f/_selfScale];
            layer.path             = path.CGPath;
            layer.lineWidth         = 0.5/_selfScale;
            layer.lineDashPattern    = @[@(8/_selfScale), @(8/_selfScale)];
            layer.fillColor          = [UIColor clearColor].CGColor;
            if( (_captionTextIndex == idx) && ( _isTextTemplateEdit ) )
                layer.strokeColor       = Main_Color.CGColor;
            else
                layer.strokeColor       = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
            [obj.layer addSublayer:layer];
            [array addObject:layer];
        }
        [_textEditBtnLayerArrary addObject:array];
    }];
}

-(void)addTextEditBox:(CGRect) rect
{
    if(  _TextEditBtn  )
    {
        [_TextEditBtn removeFromSuperview];
    }
    
    {
        UIButton * btn = [[UIButton alloc] initWithFrame:rect];
       
       
        [self addSubview:btn];
        _TextEditBtn = btn;
        
        [self refreshTextEidtFrame];
    }
}

-(void)refreshTextEidtFrame
{
    CAShapeLayer *layer   = [[CAShapeLayer alloc] init];
    layer.frame            = CGRectMake(0, 0 , _TextEditBtn.frame.size.width, _TextEditBtn.frame.size.height);
    layer.backgroundColor   = [UIColor clearColor].CGColor;

    UIBezierPath *path    = [UIBezierPath bezierPathWithRoundedRect:layer.frame cornerRadius:4.0f];
    layer.path             = path.CGPath;
    layer.lineWidth         = 1.0f;
    layer.lineDashPattern    = @[@4, @4];
    layer.fillColor          = [UIColor clearColor].CGColor;
    layer.strokeColor       = [UIColor colorWithWhite:0.8 alpha:0.6].CGColor;
    [_TextEditBtn.layer addSublayer:layer];
}

-(float)getCropREct_Scale:(float) scale
{
    float width = _contentImage.frame.size.width*scale;
    float height = _contentImage.frame.size.height*scale;
    
    float wScale = scale;
    float  hScale = scale;
    if( _cropRect.size.width < _cropRect.size.height )
    {
        if( width < _cropRect.size.width )
        {
            wScale = _cropRect.size.width/_contentImage.frame.size.width;
        }
        if( height <  _cropRect.size.height  )
        {
            hScale = _cropRect.size.height/_contentImage.frame.size.height;
        }
    }
    else{
        if( width > _cropRect.size.width )
        {
            wScale = _cropRect.size.height/_contentImage.frame.size.height;
        }
        if( height >  _cropRect.size.height  )
        {
            hScale = _cropRect.size.width/_contentImage.frame.size.width;
        }
    }

    if( hScale > wScale )
    {
        scale = hScale;
    }
    else{
        scale = wScale;
    }
    
    return scale;
}

-(CGPoint)getCropRect_Center:(CGPoint) center
{
    if( (center.x - _contentImage.frame.size.width*_selfScale/2.0) > (_cropRect.origin.x) )
    {
        center.x = _cropRect.origin.x+_contentImage.frame.size.width*_selfScale/2.0;
    }
    else if((center.x + _contentImage.frame.size.width*_selfScale/2.0) < (_cropRect.size.width+_cropRect.origin.x) )
    {
        center.x = (_cropRect.size.width+_cropRect.origin.x)-_contentImage.frame.size.width*_selfScale/2.0;
    }
    
    if((center.y - _contentImage.frame.size.height*_selfScale/2.0) > (_cropRect.origin.y) )
    {
        center.y = _cropRect.origin.y+_contentImage.frame.size.height*_selfScale/2.0;
    }
    else if((center.y + _contentImage.frame.size.height*_selfScale/2.0) < (_cropRect.size.height+_cropRect.origin.y) )
    {
        center.y = (_cropRect.size.height+_cropRect.origin.y)-_contentImage.frame.size.height*_selfScale/2.0;
    }
    
    shockX = center.x;
    shockY = center.y;
    return center;
}
- (void)setHidden:(BOOL)hidden{
    if(hidden){
        NSLog(@"sss");
    }
    [super setHidden:hidden];
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
}
@end
