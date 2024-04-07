//
//  VECropView.m
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import "VECropView.h"
#import <VEENUMCONFIGER/VEHelp.h>
#define VE_TRACK_WIDTH 3
#define VE_TRACK_HEIGHT 28

#define VE_TRACK_HEIGHT_DEWATERMARK 22
#define VE_CROPWIDTH_MIN 90
#define VE_CROPHEIGHT_MIN 90





@interface VECropView()
@property (nonatomic, assign) BOOL  isInitialPoint;
@property (nonatomic, assign) CGPoint initialCenter;
@property (nonatomic, assign) CGFloat initialDistance;

@property(nonatomic,assign)BOOL isTrackButtonHidden;

@property(nonatomic,assign) CGPoint cropPointTopLeft; //裁剪区上左边顶点
@property(nonatomic,assign) CGPoint cropPointTopRight;//裁剪区上右边顶点
@property(nonatomic,assign) CGPoint cropPointBottomLeft;//裁剪区下左边顶点
@property(nonatomic,assign) CGPoint cropPointBottomRight;//裁剪区下右边顶点


@property(nonatomic,assign) CGPoint trackingRectPointTopLeft;//有效拖动区上左边顶点
@property(nonatomic,assign) CGPoint trackingRectPointTopRight;//有效拖动区上右边顶点
@property(nonatomic,assign) CGPoint trackingRectPointBottomLeft;//有效拖动区下左边顶点
@property(nonatomic,assign) CGPoint trackingRectPointBottomRight;//有效拖动区下左边顶点


@property(nonatomic,assign) CGFloat ratio;
@property(nonatomic,assign) CGPoint changePointTemp;//

@end

@implementation VECropView
- (void)setCropWidth:(CGFloat)cropWidth{
    _cropWidth = cropWidth;
}
#pragma mark - 1.Life Cycle

-(instancetype)initWithFrame:(CGRect)frame withVideoCropType:(VEVideoCropType)videoCropType{
    self = [super initWithFrame:frame];
    if (self) {
        self.videoCropType = videoCropType;
        self.cropType = VE_VECROPTYPE_FREE;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:([VEConfigManager sharedManager].iPad_HD ? 0.0 : 0.5)];
        
        self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN, VE_CROPHEIGHT_MIN);
        if( [VEConfigManager sharedManager].isPictureEditing )
        {
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:([VEConfigManager sharedManager].iPad_HD ? 0.0 : 0.9)];
        }
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        if ((self.videoCropType == VEVideoCropType_Crop)
            || (VEVideoCropType_FixedCrop == self.videoCropType )) {
            
            self.cropWidth= self.cropSizeMin.width;
            self.cropHeight = self.cropSizeMin.height;
            self.croporiginX = (width -  self.cropWidth)/2;
            self.croporiginY = (height - self.cropHeight)/2;
            
        }else if(self.videoCropType == VEVideoCropType_Dewatermark){
            
            self.cropWidth= 102;
            self.cropHeight = 57;
            self.croporiginX = (width -  self.cropWidth)/2;
            self.croporiginY = (height - self.cropHeight)/2;
        }
        
        
        [self addSubview:self.cropRectView];
        [self addSubview:self.topTrackButton];
        [self addSubview:self.bottomTrackButton];
        [self addSubview:self.leftTrackButton];
        [self addSubview:self.rightTrackButton];
        
        [self addSubview:self.topLeftTrackButton];
        [self addSubview:self.topRightTrackButton];
        [self addSubview:self.bottomLeftTrackButton];
        [self addSubview:self.bottomRightTrackButton];
        if(self.videoCropType == VEVideoCropType_Dewatermark){
            self.cropSizeMin = CGSizeMake(22, 22);
            self.backgroundColor = [UIColor clearColor];
            self.topTrackButton.hidden = YES;
            self.bottomTrackButton.hidden = YES;
            self.leftTrackButton.hidden = YES;
            self.rightTrackButton.hidden = YES;
            self.bottomLeftTrackButton.hidden = YES;
            
            // 单击的 Recognizer
            UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
            //点击的次数
            singleRecognizer.numberOfTapsRequired = 1;// 单击
            //给self.view添加一个手势监测；
            [self addGestureRecognizer:singleRecognizer];
        }

    }
    return self;
}

- (void)setDelegate:(id<VECropViewDelegate>)delegate
{
    _delegate = delegate;
}

- (void)setVideoView:(UIView *)videoView
{
    _videoView = videoView;
    if( _videoView )
    {
        [_videoView setUserInteractionEnabled:true];
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [_videoView addGestureRecognizer:pinchGesture];
    }
}

- (void)setVideoCropView:(UIView *)videoCropView
{
    _videoCropView = videoCropView;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
    if (gesture.numberOfTouches == 2) {
        _isModificationCrop = true;
        self.cropViewTrackType = VE_TRACK_SCALING;
        if( self.delegate && [self.delegate respondsToSelector:@selector(PinchGetureRecognizer_endDragCropView:)] )
        {
            [self.delegate PinchGetureRecognizer_endDragCropView:gesture];
        }
        _isDrawCroprectview = true;
        [self setNeedsDisplay];
    }
    
    if( gesture.state == UIGestureRecognizerStateEnded )
    {
        _isDrawCroprectview = false;
        _isModificationCrop = false;
        self.cropViewTrackType = VE_TRACK_CROPRECTVIEW;
        [self convertView:self.cropRectView atDestinationView:self atInView:_videoView];
//        self.videoFrame = _videoFrame;
        _trackingRect = CGRectMake(_videoFrame.origin.x, _videoFrame.origin.y, _videoFrame.size.width,_videoFrame.size.height);
        
        self.trackingRectPointTopLeft = CGPointMake(_trackingRect.origin.x, _trackingRect.origin.y);
        
        self.trackingRectPointTopRight = CGPointMake(_trackingRect.origin.x + _trackingRect.size.width, _trackingRect.origin.y);
        
        self.trackingRectPointBottomLeft = CGPointMake(_trackingRect.origin.x , _trackingRect.origin.y+ _trackingRect.size.height);
        
        self.trackingRectPointBottomRight = CGPointMake(_trackingRect.origin.x +  _trackingRect.size.width, _trackingRect.origin.y+ _trackingRect.size.height);
        
        if( self.delegate && [self.delegate respondsToSelector:@selector(PinchGetureRecognizer_End:)] )
        {
            [self needsUpdateCropRect];
            [self.delegate PinchGetureRecognizer_End:self];
            [self.cropRectView setNeedsDisplay];
            [self setNeedsDisplay];
        }
    }
}

-(void)setWithCropWidth:(CGFloat)cropWidth WithCropHeight:(CGFloat)CropHeight{
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.cropWidth= cropWidth;
    self.cropHeight = CropHeight;
    self.croporiginX = (width -  self.cropWidth)/2;
    self.croporiginY = (height - self.cropHeight)/2;
    [self setNeedsDisplay];
}

-(void)setCropRectViewFrame:(VECropType)cropType{
    
    self.cropType = cropType;
    if (cropType == VE_VECROPTYPE_FREE) {
        if( (self.videoCropType == VEVideoCropType_Crop)
           || (VEVideoCropType_FixedCrop == self.videoCropType)) {
            
            [self ratioFreeAandOriginal];
            [self setTrackButtonState:NO];
            self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN, VE_CROPHEIGHT_MIN);
            
        }else if(self.videoCropType == VEVideoCropType_Dewatermark){
            self.cropSizeMin = CGSizeMake(22, 22);
        }
        
        
    }else if (cropType == VE_VECROPTYPE_FIXEDRATIO) {
        if(self.ratio > 0.0){
            if(self.ratio > 1.0){
                [self ratioLessThan1WithValueX:16 WithToValueY:16/self.ratio];
                self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN, VE_CROPHEIGHT_MIN/self.ratio);
            }else{
                [self ratioLessThan1WithValueX:self.ratio * 9 WithToValueY:9];
                self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN * self.ratio, VE_CROPHEIGHT_MIN);
            }
        }else{
            [self ratioFreeAandOriginal];
            self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN, VE_CROPHEIGHT_MIN);
        }
        [self setTrackButtonState:YES];
        
        
    }else if (cropType == VE_VECROPTYPE_ORIGINAL){
        if (self.cropRatio > 0) {
            [self ratioLessThan1WithValueX:self.cropRatio WithToValueY:1.0];
        }else {
            [self ratioFreeAandOriginal];
        }
        [self setTrackButtonState:YES];
        
        if (self.cropWidth / self.cropHeight> 1.0) {
            self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN, VE_CROPHEIGHT_MIN/(self.cropWidth / self.cropHeight));
        }else{
            self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN * (self.cropWidth / self.cropHeight), VE_CROPHEIGHT_MIN);
        }

        
    }else if (cropType == VE_VECROPTYPE_9TO16){
        
        [self ratioLessThan1WithValueX:9.0 WithToValueY:16.0];
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/16)*9, VE_CROPHEIGHT_MIN);
        
    }else if (cropType == VE_VECROPTYPE_16TO9){
        
        [self ratioGreaterThan1WithValueX:16.0 WithToValueY:9.0];
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN, (VE_CROPHEIGHT_MIN/16)*9);
        
    }else if (cropType == VE_VECROPTYPE_1TO1){
        
        [self RatioEquals1];
        
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN, VE_CROPHEIGHT_MIN);
        
    }else if(cropType == VE_VECROPTYPE_6TO7){
        
        [self ratioLessThan1WithValueX:6.0 WithToValueY:7.0];
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/7)*6, VE_CROPHEIGHT_MIN);
        
    }else if(cropType == VE_VECROPTYPE_5TO8){
        
        [self ratioLessThan1WithValueX:1.0 WithToValueY:2.167];
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/2.167)*1, VE_CROPHEIGHT_MIN);
        
    }else if(cropType == VE_VECROPTYPE_4TO5){
        
        [self ratioLessThan1WithValueX:4.0 WithToValueY:5.0];
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/5)*4, VE_CROPHEIGHT_MIN);
        
    }else if(cropType == VE_VECROPTYPE_4TO3){
        
        [self ratioGreaterThan1WithValueX:4.0 WithToValueY:3.0];
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN, (VE_CROPHEIGHT_MIN/4)*3);
        
    }else if(cropType == VE_VECROPTYPE_3TO5){
        
        [self ratioLessThan1WithValueX:3.0 WithToValueY:5.0];
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/5)*3, VE_CROPHEIGHT_MIN);
        
    }else if(cropType == VE_VECROPTYPE_3TO4){
        
        [self ratioLessThan1WithValueX:3.0 WithToValueY:4.0];
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/4)*3, VE_CROPHEIGHT_MIN);
        
    }else if(cropType == VE_VECROPTYPE_3TO2){
        [self ratioLessThan1WithValueX:3.0 WithToValueY:2.0];
        [self setTrackButtonState:YES];
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/3.0)*2.0, VE_CROPHEIGHT_MIN);
    }
    else if(cropType == VE_VECROPTYPE_235TO1){
        [self ratioLessThan1WithValueX:2.35 WithToValueY:1.0];
        [self setTrackButtonState:YES];
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/1)*2.35, VE_CROPHEIGHT_MIN);
    }
    else if(cropType == VE_VECROPTYPE_2TO3){
        [self ratioLessThan1WithValueX:2.0 WithToValueY:3.0];
        [self setTrackButtonState:YES];
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/2.0)*3.0, VE_CROPHEIGHT_MIN);
    }
    else if(cropType == VE_VECROPTYPE_2TO1){
        [self ratioLessThan1WithValueX:2.0 WithToValueY:1.0];
        [self setTrackButtonState:YES];
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/2.0)*1.0, VE_CROPHEIGHT_MIN);
    }
    else if(cropType == VE_VECROPTYPE_185TO1){
        [self ratioLessThan1WithValueX:1.85 WithToValueY:1.0];
        [self setTrackButtonState:YES];
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/1.85)*1.0, VE_CROPHEIGHT_MIN);
    }
    if(self.cropType != VE_VECROPTYPE_FIXEDRATIO){
        self.ratio = self.cropWidth / self.cropHeight;
    }
//    else{
//        self.ratio = self.cropWidth / self.cropHeight;
//    }
    self.cropSizeMax = CGSizeMake(self.cropWidth, self.cropHeight);

    [self needsUpdateCropPoints];
    [self setNeedsDisplay];
    
}

-(void)setTrackButtonState:(BOOL)state{
    if (state || _videoCropType == VEVideoCropType_Dewatermark) {
        
        self.topTrackButton.hidden = YES;
        self.bottomTrackButton.hidden = YES;
        self.leftTrackButton.hidden = YES;
        self.rightTrackButton.hidden = YES;
        
    }else{
        
        self.topTrackButton.hidden = NO;
        self.bottomTrackButton.hidden = NO;
        self.leftTrackButton.hidden = NO;
        self.rightTrackButton.hidden = NO;
        
    }
}


-(void)ratioGreaterThan1WithValueX:(float)valueX WithToValueY:(float)valueY{
    
    float videoR = valueX / valueY;
    if (_videoFrame.size.width > _videoFrame.size.height) {
        
        if (videoR > _videoFrame.size.width / _videoFrame.size.height) {
            self.croporiginX = _videoFrame.origin.x;
            self.croporiginY = _videoFrame.origin.y + (_videoFrame.size.height - _videoFrame.size.width * valueY/valueX)/2;
            self.cropWidth = _videoFrame.size.width;
            self.cropHeight = _videoFrame.size.width * valueY/valueX;
            
        }else{
            
            self.croporiginX = _videoFrame.origin.x+ (_videoFrame.size.width -_videoFrame.size.height *valueX/valueY)/2;
            self.croporiginY = _videoFrame.origin.y;
            self.cropWidth = _videoFrame.size.height *valueX/valueY;
            self.cropHeight = _videoFrame.size.height;
            
        }
        
        
        
    }else{
        
        self.croporiginX = _videoFrame.origin.x;
        self.croporiginY = _videoFrame.origin.y + (_videoFrame.size.height - _videoFrame.size.width * valueY/valueX)/2;
        self.cropWidth = _videoFrame.size.width;
        self.cropHeight = _videoFrame.size.width * valueY/valueX;
        
    }
    
}

-(void)ratioLessThan1WithValueX:(float)valueX WithToValueY:(float)valueY{
    
    float videoR = valueX / valueY;
    
    CGRect rect =  _videoFrame;
    
    if( VEVideoCropType_FixedCrop == _videoCropType )
    {
        rect.origin.x = rect.origin.x + 20;
        rect.origin.y = rect.origin.y + 45;
        
        rect.size.width = rect.size.width - 40;
        rect.size.width = rect.size.width - 90;
    }
    
    if ( _videoFrame.size.width > _videoFrame.size.height) {
        
        if(videoR > 1.0 && _cropType == VE_VECROPTYPE_FIXEDRATIO){
            
            _croporiginX = _videoFrame.origin.x;
            _croporiginY = _videoFrame.origin.y+ (_videoFrame.size.height -_videoFrame.size.width/videoR)/2;
            _cropWidth = _videoFrame.size.width;
            _cropHeight = _videoFrame.size.width /videoR;
            if (_cropHeight > _videoFrame.size.height) {
                _croporiginX = _videoFrame.origin.x+ (_videoFrame.size.width -_videoFrame.size.height *valueX/valueY)/2;
                _croporiginY = _videoFrame.origin.y;
                _cropWidth = _videoFrame.size.height *valueX/valueY;
                _cropHeight = _videoFrame.size.height;
            }
        }else{
            _croporiginX = _videoFrame.origin.x+ (_videoFrame.size.width -_videoFrame.size.height *valueX/valueY)/2;
            _croporiginY = _videoFrame.origin.y;
            _cropWidth = _videoFrame.size.height *valueX/valueY;
            _cropHeight = _videoFrame.size.height;
            if (_cropWidth > _videoFrame.size.width) {
                _croporiginX = _videoFrame.origin.x;
                _croporiginY = _videoFrame.origin.y+ (_videoFrame.size.height -_videoFrame.size.width/videoR)/2;
                _cropWidth = _videoFrame.size.width;
                _cropHeight = _videoFrame.size.width /videoR;
            }
        }
    }else{
        
        if (videoR > _videoFrame.size.width / _videoFrame.size.height) {
            
            _croporiginX = _videoFrame.origin.x;
            _croporiginY = _videoFrame.origin.y + (_videoFrame.size.height -_videoFrame.size.width* valueY/valueX)/2;
            _cropWidth = _videoFrame.size.width;
            _cropHeight = _videoFrame.size.width* valueY/valueX;
            if (_cropHeight > _videoFrame.size.height) {
                _croporiginX = _videoFrame.origin.x+ (_videoFrame.size.width -_videoFrame.size.height *valueX/valueY)/2;
                _croporiginY = _videoFrame.origin.y;
                _cropWidth = _videoFrame.size.height *valueX/valueY;
                _cropHeight = _videoFrame.size.height;
            }
        }else{
            
            _croporiginX = _videoFrame.origin.x+ (_videoFrame.size.width -_videoFrame.size.height *valueX/valueY)/2;
            _croporiginY = _videoFrame.origin.y;
            _cropWidth = _videoFrame.size.height *valueX/valueY;
            _cropHeight = _videoFrame.size.height;
            if (_cropWidth > _videoFrame.size.width) {
                _croporiginX = _videoFrame.origin.x;
                _croporiginY = _videoFrame.origin.y + (_videoFrame.size.height -_videoFrame.size.width* valueY/valueX)/2;
                _cropWidth = _videoFrame.size.width;
                _cropHeight = _videoFrame.size.width* valueY/valueX;
            }
        }
    }
}
-(void)RatioEquals1{
    
    if (_videoFrame.size.width > _videoFrame.size.height) {
        self.croporiginX = _videoFrame.origin.x + (_videoFrame.size.width - _videoFrame.size.height)/2;
        self.croporiginY = _videoFrame.origin.y ;
        self.cropWidth= _videoFrame.size.height;
        self.cropHeight = _videoFrame.size.height;
    }else if (_videoFrame.size.width < _videoFrame.size.height){
        self.croporiginX = _videoFrame.origin.x;
        self.croporiginY = _videoFrame.origin.y +(_videoFrame.size.height - _videoFrame.size.width)/2 ;
        self.cropWidth= _videoFrame.size.width;
        self.cropHeight = _videoFrame.size.width;
    }else{
        self.croporiginX = _videoFrame.origin.x;
        self.croporiginY = _videoFrame.origin.y ;
        self.cropWidth= _videoFrame.size.width;
        self.cropHeight = _videoFrame.size.height;
    }
    
}



-(void)ratioFreeAandOriginal{
    
    self.croporiginX = _videoFrame.origin.x;
    self.croporiginY = _videoFrame.origin.y;
    self.cropWidth= _videoFrame.size.width;
    self.cropHeight = _videoFrame.size.height;
    [self setNeedsDisplay];
    
}

-(void)needsUpdateCropRect
{
    self.croporiginX = self.cropRectView.frame.origin.x;
    self.croporiginY = self.cropRectView.frame.origin.y;
    self.cropWidth = self.cropRectView.frame.size.width;
    self.cropHeight = self.cropRectView.frame.size.height;
    
    [self needsUpdateCropPoints];
}

-(void)needsUpdateCropPoints{
    
    self.cropPointTopLeft = CGPointMake(self.croporiginX, self.croporiginY);
    self.cropPointTopRight = CGPointMake(self.croporiginX + self.cropWidth , self.croporiginY);
    self.cropPointBottomLeft = CGPointMake(self.croporiginX, self.croporiginY + self.cropHeight);
    self.cropPointBottomRight = CGPointMake(self.croporiginX + self.cropWidth , self.croporiginY + self.cropHeight);
    [self.cropRectView setFrame:CGRectMake(self.croporiginX, self.croporiginY, self.cropWidth , self.cropHeight)];
    [self.cropRectView setNeedsDisplay];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cropViewCrop:withCropRect:)]) {
        [self.delegate cropViewCrop:[self getCropRect] withCropRect:self.cropRect];
    }
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if ( _isDrawCroprectview )
    {
        _isDrawCroprectview = false;
        //透明区域
        [[UIColor clearColor] setFill];
        // 获取源控件上的 CGRect
        CGRect rectInSourceView = self.cropRectView.frame;
        // 将源控件上的 CGRect 转换到窗口坐标系中
        CGRect rectInWindow = [_videoView convertRect:rectInSourceView toView:nil];
        // 将窗口坐标系中的 CGRect 转换回目标控件上
        CGRect rectInDestinationView = [self convertRect:rectInWindow fromView:nil];
        UIRectFill(CGRectMake(rectInDestinationView.origin.x, rectInDestinationView.origin.y, rectInDestinationView.size.width, rectInDestinationView.size.height));
    }else{
        if ((self.videoCropType == VEVideoCropType_Crop)
            || (VEVideoCropType_FixedCrop == self.videoCropType )) {
            
            [self.cropRectView setFrame:CGRectMake(self.croporiginX, self.croporiginY, self.cropWidth, self.cropHeight)];
            //透明区域
            [[UIColor clearColor] setFill];
            UIRectFill(CGRectMake(self.croporiginX, self.croporiginY, self.cropWidth, self.cropHeight));
            
            [self.topTrackButton setFrame:CGRectMake(self.croporiginX + (self.cropWidth - VE_TRACK_HEIGHT)/2, self.croporiginY-VE_TRACK_WIDTH,VE_TRACK_HEIGHT , VE_TRACK_WIDTH)];
            
            [self.bottomTrackButton setFrame:CGRectMake(self.croporiginX + (self.cropWidth - VE_TRACK_HEIGHT)/2, self.croporiginY +self.cropHeight, VE_TRACK_HEIGHT, VE_TRACK_WIDTH)];
            
            [self.leftTrackButton setFrame:CGRectMake(self.croporiginX -VE_TRACK_WIDTH, self.croporiginY + (self.cropHeight-VE_TRACK_HEIGHT)/2, VE_TRACK_WIDTH, VE_TRACK_HEIGHT)];
            
            [self.rightTrackButton setFrame:CGRectMake(self.croporiginX + self.cropWidth, self.croporiginY + (self.cropHeight-VE_TRACK_HEIGHT)/2, VE_TRACK_WIDTH, VE_TRACK_HEIGHT)];
            
            [self.topLeftTrackButton setFrame:CGRectMake(self.croporiginX -VE_TRACK_WIDTH, self.croporiginY - VE_TRACK_WIDTH, VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH , VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH)];
            
            [self.topRightTrackButton setFrame:CGRectMake((self.croporiginX+ self.cropWidth) -VE_TRACK_HEIGHT*1/2, self.croporiginY - VE_TRACK_WIDTH, VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH , VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH)];
            
            
            [self.bottomLeftTrackButton setFrame:CGRectMake(self.croporiginX -VE_TRACK_WIDTH, self.croporiginY+self.cropHeight - VE_TRACK_HEIGHT*1/2, VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH , VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH)];
            
            [self.bottomRightTrackButton setFrame:CGRectMake(self.croporiginX+self.cropWidth -VE_TRACK_HEIGHT*1/2, self.croporiginY+self.cropHeight -VE_TRACK_HEIGHT*1/2, VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH , VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH)];
            
            
        }else{
            
            [self.cropRectView setFrame:CGRectMake(self.croporiginX, self.croporiginY, self.cropWidth, self.cropHeight)];
            //透明区域
            [[UIColor clearColor] setFill];
            UIRectFill(CGRectMake(self.croporiginX, self.croporiginY, self.cropWidth, self.cropHeight));
            
            
            [self.topLeftTrackButton setFrame:CGRectMake(self.croporiginX -VE_TRACK_HEIGHT_DEWATERMARK/2, self.croporiginY - VE_TRACK_HEIGHT_DEWATERMARK/2, VE_TRACK_HEIGHT_DEWATERMARK , VE_TRACK_HEIGHT_DEWATERMARK)];
            
            [self.topRightTrackButton setFrame:CGRectMake((self.croporiginX+ self.cropWidth) -VE_TRACK_HEIGHT_DEWATERMARK*1/2, self.croporiginY - VE_TRACK_HEIGHT_DEWATERMARK/2, VE_TRACK_HEIGHT_DEWATERMARK , VE_TRACK_HEIGHT_DEWATERMARK)];
            
            [self.bottomRightTrackButton setFrame:CGRectMake(self.croporiginX+self.cropWidth -VE_TRACK_HEIGHT_DEWATERMARK*1/2, self.croporiginY+self.cropHeight -VE_TRACK_HEIGHT_DEWATERMARK*1/2, VE_TRACK_HEIGHT_DEWATERMARK , VE_TRACK_HEIGHT_DEWATERMARK)];
            
        }
    }
}

#pragma mark - 2.Setting View and Style


- (void)setVideoFrame:(CGRect)videoFrame{
    _videoFrame = videoFrame;
    if( _isModificationCrop )
        return;
    _trackingRect = CGRectMake(_videoFrame.origin.x, _videoFrame.origin.y, _videoFrame.size.width,_videoFrame.size.height);
    
    self.trackingRectPointTopLeft = CGPointMake(_trackingRect.origin.x, _trackingRect.origin.y);
    
    self.trackingRectPointTopRight = CGPointMake(_trackingRect.origin.x + _trackingRect.size.width, _trackingRect.origin.y);
    
    self.trackingRectPointBottomLeft = CGPointMake(_trackingRect.origin.x , _trackingRect.origin.y+ _trackingRect.size.height);
    
    self.trackingRectPointBottomRight = CGPointMake(_trackingRect.origin.x +  _trackingRect.size.width, _trackingRect.origin.y+ _trackingRect.size.height);
    
    
    [self setCropRectViewFrame:self.cropType];
    
    
}

- (void)setCropType:(VECropType)cropType{
    _cropType = cropType;
    if(_cropType == VE_VECROPTYPE_FIXEDRATIO){
        [self setTrackButtonState:YES];
    }else{
        [self setTrackButtonState:NO];
    }
}
#pragma mark - 3 Data


#pragma mark - 4.Custom Methods

- (CGRect)getCropRect
{
    float imgsize = self.videoSize.width;
    float viewsize = self.videoFrame.size.width;

    float scale = imgsize/viewsize;

    CGRect r = CGRectMake((_croporiginX-self.trackingRectPointTopLeft.x) *scale, (_croporiginY-self.trackingRectPointTopLeft.y)*scale, _cropWidth*scale, _cropHeight*scale);

    CGRect v_r = CGRectZero;

    v_r.origin.x = r.origin.x/self.videoSize.width;
    v_r.origin.y = r.origin.y/self.videoSize.height;
    v_r.size.width = ((int)(r.size.width))/self.videoSize.width;
    v_r.size.height = ((int)(r.size.height))/self.videoSize.height;

    return v_r;
    
//    float imgsize = self.videoSize.width;
//    float viewsize = self.videoFrame.size.width;
//
//    float scale = imgsize/viewsize;
//
//
//
//    CGRect r = CGRectMake((_croporiginX-self.trackingRectPointTopLeft.x) *scale, (_croporiginY-self.trackingRectPointTopLeft.y)*scale, _cropWidth*scale, _cropHeight*scale);

//    CGRect v_r = CGRectZero;
//
//    v_r.origin.x = (_croporiginX-self.trackingRectPointTopLeft.x) / self.videoFrame.size.width;
//    v_r.origin.y = (_croporiginY-self.trackingRectPointTopLeft.y) / self.videoFrame.size.height;
//    v_r.size.width = self.cropWidth/self.videoFrame.size.width;
//    v_r.size.height = self.cropHeight/self.videoFrame.size.height;
//
//
//    return v_r;

}

-(void)SingleTap:(UITapGestureRecognizer*)recognizer{//处理单击操作
    CGPoint point = [recognizer locationInView:self];
    NSLog(@"withToucheClipPoint:%f,y:%f",point.x,point.y);
    if (point.x >=  self.videoFrame.origin.x && point.x <=  self.videoFrame.origin.x + self.videoFrame.size.width && point.y >=  self.videoFrame.origin.y && point.y <= self.videoFrame.origin.y + self.videoFrame.size.height) {
        CGFloat  pointW = point.x - self.videoFrame.origin.x;
        CGFloat  pointH = point.y - self.videoFrame.origin.y;
        CGPoint clipPoint = CGPointMake(pointW /self.videoFrame.size.width , pointH/self.videoFrame.size.height);
        if(_delegate){
            if([_delegate respondsToSelector:@selector(cropViewTouchesEndSuperView:withInVideo:withToucheClipPoint:)]){
                [_delegate  cropViewTouchesEndSuperView:recognizer  withInVideo:YES withToucheClipPoint:clipPoint];
            }
        }
    }else{
        
        CGPoint clipPoint = CGPointMake(point.x /self.frame.size.width , point.y/self.frame.size.height);
        
        if(_delegate){
            if([_delegate respondsToSelector:@selector(cropViewTouchesEndSuperView:withInVideo:withToucheClipPoint:)]){
                [_delegate  cropViewTouchesEndSuperView:recognizer  withInVideo:NO withToucheClipPoint:clipPoint];
            }
        }
        
    }
}

-(void)topLeftTrackButtonClicked{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cropViewTouchTopLeftTrackButton)]) {
        [self.delegate cropViewTouchTopLeftTrackButton];
    }
}

-(void)topRightTrackButtonClicked{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cropViewTouchtopRightTrackButton)]) {
        [self.delegate cropViewTouchtopRightTrackButton];
    }
}

-(void)convertView:( UIView * ) view atDestinationView:( UIView * ) destinationView atInView:( UIView * ) inView
{
    // 获取源控件上的 CGRect
    CGRect rectInSourceView = view.frame;
    // 将源控件上的 CGRect 转换到窗口坐标系中
    CGRect rectInWindow = [inView convertRect:rectInSourceView toView:nil];
    // 将窗口坐标系中的 CGRect 转换回目标控件上
    CGRect rectInDestinationView = [destinationView convertRect:rectInWindow fromView:nil];
    view.frame = rectInDestinationView;
    [destinationView addSubview:view];
}

#pragma mark - 5.DataSource and Delegate
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    float hitTestWidth = 44.0;
    // 当前控件上的点转换到chatView上
    // 判断下点在不在chatView上
    CGRect topTrackBounds = self.topTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat topTrackwidthDelta = MAX(hitTestWidth - topTrackBounds.size.width, 0);
    CGFloat topTrackheightDelta = MAX(hitTestWidth - topTrackBounds.size.height, 0);
    topTrackBounds = CGRectInset(self.topTrackButton.frame, -0.5 * topTrackwidthDelta, -0.5 * topTrackheightDelta);
    
    
    // 判断下点在不在chatView上
    CGRect bottomTrackBounds = self.bottomTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat bottomTrackWidthDelta = MAX(hitTestWidth - bottomTrackBounds.size.width, 0);
    CGFloat bottomTrackHeightDelta = MAX(hitTestWidth - bottomTrackBounds.size.height, 0);
    bottomTrackBounds = CGRectInset(self.bottomTrackButton.frame, -0.5 * bottomTrackWidthDelta, -0.5 * bottomTrackHeightDelta);
    
    
    
    // 判断下点在不在chatView上
    CGRect leftTrackBounds = self.leftTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat leftTrackWidthDelta = MAX(hitTestWidth - leftTrackBounds.size.width, 0);
    CGFloat leftTrackHeightDelta = MAX(hitTestWidth - leftTrackBounds.size.height, 0);
    leftTrackBounds = CGRectInset(self.leftTrackButton.frame, -0.5 * leftTrackWidthDelta, -0.5 * leftTrackHeightDelta);
    
    
    // 判断下点在不在chatView上
    CGRect rightTrackBounds = self.rightTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat rightTrackWidthDelta = MAX(hitTestWidth - rightTrackBounds.size.width, 0);
    CGFloat rightTrackHeightDelta = MAX(hitTestWidth - rightTrackBounds.size.height, 0);
    rightTrackBounds = CGRectInset(self.rightTrackButton.frame, -0.5 * rightTrackWidthDelta, -0.5 * rightTrackHeightDelta);
    
    
    // 判断下点在不在chatView上
    CGRect topLeftTrackBounds = self.topLeftTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat topLeftTrackWidthDelta = MAX(hitTestWidth - topLeftTrackBounds.size.width, 0);
    CGFloat topLeftTrackHeightDelta = MAX(hitTestWidth - topLeftTrackBounds.size.height, 0);
    topLeftTrackBounds = CGRectInset(self.topLeftTrackButton.frame, -0.5 * topLeftTrackWidthDelta, -0.5 * topLeftTrackHeightDelta);
    
    
    // 判断下点在不在chatView上
    CGRect topRightTrackBounds = self.topRightTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat topRightTrackWidthDelta = MAX(hitTestWidth - topRightTrackBounds.size.width, 0);
    CGFloat topRightTrackHeightDelta = MAX(hitTestWidth - topRightTrackBounds.size.height, 0);
    topRightTrackBounds = CGRectInset(self.topRightTrackButton.frame, -0.5 * topRightTrackWidthDelta, -0.5 * topRightTrackHeightDelta);
    
    // 判断下点在不在chatView上
    CGRect bottomLeftTrackBounds = self.bottomLeftTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat bottomLeftTrackWidthDelta = MAX(hitTestWidth - bottomLeftTrackBounds.size.width, 0);
    CGFloat bottomLeftTrackHeightDelta = MAX(hitTestWidth - bottomLeftTrackBounds.size.height, 0);
    bottomLeftTrackBounds = CGRectInset(self.bottomLeftTrackButton.frame, -0.5 * bottomLeftTrackWidthDelta, -0.5 * bottomLeftTrackHeightDelta);
    
    // 判断下点在不在chatView上
    CGRect bottomRightTrackBounds = self.bottomRightTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat bottomRightTrackWidthDelta = MAX(hitTestWidth - bottomRightTrackBounds.size.width, 0);
    CGFloat bottomRightTrackHeightDelta = MAX(hitTestWidth - bottomRightTrackBounds.size.height, 0);
    bottomRightTrackBounds = CGRectInset(self.bottomRightTrackButton.frame, -0.5 * bottomRightTrackWidthDelta, -0.5 * bottomRightTrackHeightDelta);
    
    
    // 判断下点在不在chatView上
    CGRect cropRectViewBounds = self.cropRectView.frame;
    if (CGRectContainsPoint(topTrackBounds,point) && self.topTrackButton.hidden == NO) {
        self.cropViewTrackType = VE_TRACK_TOP;
        return  self.topTrackButton.superview;
    }else if(CGRectContainsPoint(bottomTrackBounds,point) && self.topTrackButton.hidden == NO){
        self.cropViewTrackType = VE_TRACK_BOTTOM;
        return  self.bottomTrackButton.superview;
    }else if(CGRectContainsPoint(leftTrackBounds,point) && self.topTrackButton.hidden == NO){
        self.cropViewTrackType = VE_TRACK_LEFT;
        return  self.leftTrackButton.superview;
    }else if(CGRectContainsPoint(rightTrackBounds,point) && self.topTrackButton.hidden == NO){
        self.cropViewTrackType = VE_TRACK_RIGHT;
        return  self.rightTrackButton.superview;
    }else if(CGRectContainsPoint(topLeftTrackBounds,point)){
        
        if ((self.videoCropType == VEVideoCropType_Crop)
            || (VEVideoCropType_FixedCrop == self.videoCropType )) {
            self.cropViewTrackType = VE_TRACK_TOPLEFT;
            return  self.topLeftTrackButton.superview;
            
        }else if(self.videoCropType == VEVideoCropType_Dewatermark){
            
            self.cropViewTrackType = VE_TRACK_TOPLEFT;
            return  self.topLeftTrackButton;
        }
        return [super hitTest:point withEvent:event];
        
    }else if(CGRectContainsPoint(topRightTrackBounds,point)){
        
        if ((self.videoCropType == VEVideoCropType_Crop)
            || (VEVideoCropType_FixedCrop == self.videoCropType )) {
            self.cropViewTrackType = VE_TRACK_TOPRIGHT;
            return  self.topRightTrackButton.superview;
            
        }else if(self.videoCropType == VEVideoCropType_Dewatermark){
            self.cropViewTrackType = VE_TRACK_TOPRIGHT;
            return  self.topRightTrackButton;
        }
        return [super hitTest:point withEvent:event];
        
    }else if(CGRectContainsPoint(bottomLeftTrackBounds,point)){
        self.cropViewTrackType = VE_TRACK_BOTTOMLEFT;
        return  self.bottomLeftTrackButton.superview;
    }else if(CGRectContainsPoint(bottomRightTrackBounds,point)){
        self.cropViewTrackType = VE_TRACK_BOTTOMRIGHT;
        return  self.bottomRightTrackButton.superview;
    }else if (CGRectContainsPoint(cropRectViewBounds,point)){
        if( _videoCropView )
        {
            if( (VE_TRACK_CROPRECTVIEW != self.cropViewTrackType) && (self.cropViewTrackType != VE_TRACK_SCALING) )
                self.cropViewTrackType = VE_TRACK_CROPRECTVIEW;
        }
        else
            self.cropViewTrackType = VE_TRACK_CROPRECTVIEW;
        return  self.cropRectView.superview;
    }else{
        NSLog(@"动不动");
        if( _videoView )
        {
            if( (VE_TRACK_CROPRECTVIEW != self.cropViewTrackType) && (self.cropViewTrackType != VE_TRACK_SCALING) )
                self.cropViewTrackType = VE_TRACK_CROPRECTVIEW;
        }
        else{
            self.cropViewTrackType = VE_TRACK_CROPRECTVIEW;
        }
        return [super hitTest:point withEvent:event];
    }
}
-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint pointTemp = [touch locationInView:self];
    self.changePointTemp = pointTemp;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cropViewbeginTrackingWithTouch:withEvent:)]) {
        [self.delegate cropViewbeginTrackingWithTouch:touch withEvent:event];
    }
    
    if (self.cropViewTrackType == VE_TRACK_TOP) {
        NSLog(@"开始拖动上方");
        return YES;
    }else if (self.cropViewTrackType == VE_TRACK_BOTTOM){
        NSLog(@"开始拖动下方");
        return YES;
    }if (self.cropViewTrackType == VE_TRACK_LEFT) {
        NSLog(@"开始拖左边");
        return YES;
    }else if (self.cropViewTrackType == VE_TRACK_RIGHT){
        NSLog(@"开始拖右边");
        return YES;
    }if (self.cropViewTrackType == VE_TRACK_TOPLEFT) {
        NSLog(@"开始拖动左上方");
        return YES;
    }else if (self.cropViewTrackType == VE_TRACK_TOPRIGHT){
        NSLog(@"开始拖动右上方");
        return YES;
    }if (self.cropViewTrackType == VE_TRACK_BOTTOMLEFT) {
        NSLog(@"开始拖动左下方");
        return YES;
    }else if (self.cropViewTrackType == VE_TRACK_BOTTOMRIGHT){
        NSLog(@"开始拖动右下方");
        return YES;
    }else if(self.cropViewTrackType == VE_TRACK_CROPRECTVIEW){
        NSLog(@"裁切");
        if( _videoCropView )
        {
            self.isInitialPoint = false;
            self.lastLocation = pointTemp;
            [self convertView:self.cropRectView atDestinationView:_videoView atInView:self];
        }
        return YES;
    }
    return YES;
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint pointTemp = [touch locationInView:self];
    
    if( _videoCropView )
    {
        CGPoint viewPoint = [self convertPoint:pointTemp toView:_videoView];
        if( viewPoint.y > self.fMaxHeight )
        {
            viewPoint = CGPointMake(viewPoint.x, self.fMaxHeight);
            pointTemp = [_videoView convertPoint:viewPoint toView:self];
        }
        
        if( self.cropViewTrackType != VE_TRACK_SCALING )
        {
            if(  (self.cropViewTrackType == VE_TRACK_CROPRECTVIEW) && _videoCropView)
            {
                
            }
            else
                [self needsUpdateCropPoints];
        }
    }
    else{
        [self needsUpdateCropPoints];
    }
//    NSLog(@"pointTemp %f", pointTemp.x);
    
    float cropSizeMinWith = self.cropSizeMin.width;
    float cropSizeMinHeight = self.cropSizeMin.height;
    
    if (self.cropViewTrackType == VE_TRACK_TOP) {
        
        float distance = fabs(self.cropPointBottomLeft.y - pointTemp.y);
        if (self.cropPointBottomLeft.y - pointTemp.y > cropSizeMinHeight && pointTemp.y >= self.trackingRectPointTopLeft.y) {
            self.croporiginY = pointTemp.y;
            self.cropHeight = distance;
        }else{
            if (self.cropPointBottomLeft.y - pointTemp.y > cropSizeMinHeight) {
                self.croporiginY = self.trackingRectPointTopLeft.y;
                self.cropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopLeft.y);
            }
        }
        
        [self setNeedsDisplay];
        
        NSLog(@"拖动上方");
        return YES;
    }
    else if (self.cropViewTrackType == VE_TRACK_BOTTOM){
        
        float distance = fabs(pointTemp.y - self.cropPointTopLeft.y );
        if (pointTemp.y - self.cropPointTopLeft.y> cropSizeMinHeight && pointTemp.y <= self.trackingRectPointBottomLeft.y) {
            self.cropHeight = distance;
        }else{
            if (pointTemp.y - self.cropPointTopLeft.y > cropSizeMinHeight) {
                self.cropHeight = fabs(self.trackingRectPointBottomLeft.y - self.cropPointTopLeft.y );
            }
        }
        [self setNeedsDisplay];
        NSLog(@"拖动下方");
        return YES;
    }
    else if (self.cropViewTrackType == VE_TRACK_LEFT) {
        
        float distance = fabs(self.cropPointTopRight.x - pointTemp.x);
        if (fabs(self.cropPointTopRight.x - pointTemp.x)> cropSizeMinWith && pointTemp.x > self.trackingRectPointTopLeft.x && pointTemp.x <= self.cropPointTopRight.x - cropSizeMinWith) {
            self.croporiginX = pointTemp.x;
            self.cropWidth = distance;
        }else{
            if ( self.cropPointTopRight.x- pointTemp.x  > cropSizeMinWith) {
                self.croporiginX = self.trackingRectPointTopLeft.x;
                self.cropWidth = self.cropPointTopRight.x - self.trackingRectPointTopLeft.x;
                
            }
        }
        [self setNeedsDisplay];
        
        NSLog(@"拖左边");
        return YES;
    }
    else if (self.cropViewTrackType == VE_TRACK_RIGHT){
        
        float distance = fabs(pointTemp.x - self.cropPointTopLeft.x);
        if (fabs(pointTemp.x - self.cropPointTopLeft.x)> cropSizeMinWith && pointTemp.x < self.trackingRectPointTopRight.x) {
            
            self.cropWidth = distance;
        }else{
            if ( pointTemp.x - self.cropPointTopLeft.x  > cropSizeMinWith) {
                self.cropWidth = self.trackingRectPointTopRight.x - self.cropPointTopLeft.x;
            }
        }
        [self setNeedsDisplay];
        NSLog(@"拖右边");
        return YES;
    }
    else if (self.cropViewTrackType == VE_TRACK_TOPLEFT) {
        if(self.videoCropType == VEVideoCropType_Dewatermark){
            return YES;
        }
        
        if (self.cropType == VE_VECROPTYPE_FREE) {
            //自由拖放
            float distanceWidth = fabs(self.cropPointTopRight.x - pointTemp.x);
            float distanceHeight = fabs(self.cropPointBottomLeft.y - pointTemp.y);

            if (pointTemp.x >= self.trackingRectPointTopLeft.x && pointTemp.y >= self.trackingRectPointTopLeft.y){

                if (self.cropPointTopRight.x - pointTemp.x > cropSizeMinWith && pointTemp.x <= self.cropPointTopRight.x - cropSizeMinWith) {
                    self.croporiginX = pointTemp.x;
                    self.cropWidth = distanceWidth;
                }else {
                    self.croporiginX = self.cropPointTopRight.x - cropSizeMinWith;
                    self.cropWidth = cropSizeMinWith;
                }

                if (self.cropPointBottomLeft.y - pointTemp.y > cropSizeMinHeight && pointTemp.y <= self.cropPointBottomLeft.y - cropSizeMinHeight) {
                    self.croporiginY = pointTemp.y;
                    self.cropHeight = distanceHeight;
                }else{
                    self.croporiginY = self.cropPointBottomLeft.y - cropSizeMinHeight;
                    self.cropHeight = cropSizeMinHeight;
                }

            }else{

                if (pointTemp.x < self.cropPointBottomRight.x  && pointTemp.x >= self.cropPointBottomRight.x- cropSizeMinWith ) {

                    self.croporiginX = self.cropPointBottomRight.x- cropSizeMinWith ;
                    self.croporiginY =self.trackingRectPointTopLeft.y;
                    self.cropWidth = cropSizeMinWith;
                    self.cropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopLeft.y);

                }

                if (pointTemp.x < self.cropPointBottomRight.x- cropSizeMinWith && pointTemp.x > self.trackingRectPointTopLeft.x) {

                    self.croporiginX = pointTemp.x;
                    self.croporiginY = self.trackingRectPointTopLeft.y;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopLeft.y);

                }


                if (pointTemp.y < self.cropPointBottomLeft.y && pointTemp.y > self.cropPointBottomLeft.y -cropSizeMinHeight) {

                    self.croporiginX = self.trackingRectPointTopLeft.x;
                    self.croporiginY = self.cropPointBottomLeft.y - cropSizeMinHeight;
                    self.cropWidth = self.cropPointBottomRight.x -self.trackingRectPointTopLeft.x;
                    self.cropHeight = cropSizeMinHeight;


                }

                if (pointTemp.y < self.cropPointBottomLeft.y -cropSizeMinHeight && pointTemp.y > self.trackingRectPointTopLeft.y) {

                    self.croporiginX = self.trackingRectPointTopLeft.x;
                    self.croporiginY = pointTemp.y;
                    self.cropWidth = self.cropPointBottomRight.x - self.trackingRectPointTopLeft.x;
                    self.cropHeight = distanceHeight;

                }

                if (pointTemp.y <= self.trackingRectPointTopLeft.y && pointTemp.x <= self.trackingRectPointTopLeft.x) {

                    self.croporiginX = self.trackingRectPointTopLeft.x ;
                    self.cropWidth = fabs(self.cropPointTopRight.x - self.trackingRectPointTopLeft.x);
                    self.croporiginY = self.trackingRectPointTopLeft.y;
                    self.cropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopLeft.y);

                }
            }
    
        }else{
            
            //等比例缩放
            CGFloat croporiginX = pointTemp.x - self.changePointTemp.x;
            CGFloat croporiginY = pointTemp.y - self.changePointTemp.y;
            self.changePointTemp = CGPointMake(self.changePointTemp.x +croporiginX, self.changePointTemp.y +croporiginY);
            CGFloat newCroporiginX = self.croporiginX + croporiginX;
            CGFloat newCroporiginY = 0.0;
            CGFloat newCropWidth = self.cropWidth - croporiginX;
            NSLog(@"newCropWidth%f",newCropWidth);
            CGFloat newCropHeight = 0.0;
            if (self.ratio > 1.0) {
                newCroporiginY  = self.croporiginY + (croporiginX / self.ratio);
                newCropHeight = newCropWidth / self.ratio;
            }else{
                newCroporiginY  = self.croporiginY + (croporiginX / self.ratio);
                newCropHeight = newCropWidth / self.ratio;
            }
            
            if (newCropWidth < cropSizeMinWith || newCropHeight < cropSizeMinHeight) {
                return YES;
            }
            
            if (newCroporiginX <= self.trackingRectPointTopLeft.x && newCroporiginY > self.trackingRectPointTopLeft.y) {

                
                newCroporiginX = self.trackingRectPointTopLeft.x;
                newCropWidth = fabs(self.trackingRectPointTopLeft.x - self.cropPointBottomRight.x);
                if (self.ratio > 1.0) {
                    newCropHeight = newCropWidth / self.ratio;
                    NSLog(@"------------>异常1 1");
                }else{
                    newCropHeight = newCropWidth / self.ratio;
                    NSLog(@"------------>异常1 2");
                }
                newCroporiginY = self.cropPointBottomRight.y - newCropHeight;
                
                
            }

            if (newCroporiginY <= self.trackingRectPointTopLeft.y && newCroporiginX > self.trackingRectPointTopLeft.x) {
                

                newCroporiginY = self.trackingRectPointTopLeft.y;
                newCropHeight = fabs(self.trackingRectPointTopLeft.y - self.cropPointBottomRight.y);
                if (self.ratio > 1.0) {
                    newCropWidth = newCropHeight * self.ratio;
                    NSLog(@"------------>异常2 1");
                }else{
                    newCropWidth = newCropHeight * self.ratio;
                    NSLog(@"------------>异常2 2");
                }
                newCroporiginX = self.cropPointBottomRight.x - newCropWidth;


            }
            
            if (newCroporiginX <= self.trackingRectPointTopLeft.x && newCroporiginY <= self.trackingRectPointTopLeft.y) {
                
                
                NSLog(@"------------>异常3 2");
                newCroporiginX = self.trackingRectPointTopLeft.x ;
                newCropWidth = fabs(self.cropPointTopRight.x - self.trackingRectPointTopLeft.x);
                newCroporiginY = self.trackingRectPointTopLeft.y;
                newCropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopLeft.y);
                
            }
            
            if (newCroporiginX >= self.cropPointBottomRight.x - cropSizeMinWith  && newCroporiginY >= self.cropPointBottomLeft.y - cropSizeMinHeight) {

                newCroporiginX = self.cropPointBottomRight.x - cropSizeMinWith;
                newCropWidth = cropSizeMinWith;
                
                if (self.ratio > 1.0) {
                    newCropHeight = newCropWidth / self.ratio;
            
                }else{
                    newCropHeight = newCropWidth / self.ratio;
             
                }
                newCroporiginY = self.cropPointBottomRight.y - newCropHeight;
            }
            self.croporiginX = newCroporiginX;
            self.croporiginY = newCroporiginY;
            self.cropWidth = newCropWidth;
            self.cropHeight = newCropHeight;
            
        }
        
        [self setNeedsDisplay];
        NSLog(@"拖动左上方");
        return YES;
    }else if (self.cropViewTrackType == VE_TRACK_TOPRIGHT){
        
        if(self.videoCropType == VEVideoCropType_Dewatermark){
            return YES;
        }
        
        if (self.cropType == VE_VECROPTYPE_FREE) {
            float distanceWidth = fabs(pointTemp.x - self.cropPointBottomLeft.x);
            float distanceHeight = fabs(self.cropPointBottomLeft.y - pointTemp.y);
            if (pointTemp.x < self.trackingRectPointTopRight.x && pointTemp.y > self.trackingRectPointTopRight.y){
                
                
                if ((pointTemp.x > self.cropPointBottomLeft.x + cropSizeMinWith &&  pointTemp.y < self.cropPointBottomLeft.y - cropSizeMinHeight) ) {

                    self.croporiginY = pointTemp.y;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = distanceHeight;
                    
                }
                
                if (pointTemp.x <= self.cropPointBottomLeft.x +  cropSizeMinWith && pointTemp.y < self.cropPointBottomLeft.y - cropSizeMinHeight){
                    
                    self.croporiginY = pointTemp.y;
                    self.cropWidth = cropSizeMinWith;
                    self.cropHeight = distanceHeight;
                    
                    
                }
                
                if(pointTemp.y >= self.cropPointBottomLeft.y - cropSizeMinHeight && pointTemp.x > self.cropPointBottomLeft.x +  cropSizeMinWith){
                    
                    self.croporiginY = self.cropPointBottomLeft.y - cropSizeMinHeight;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = cropSizeMinHeight;
                    
                    
                }
                
                if (pointTemp.x <= self.cropPointBottomLeft.x +  cropSizeMinWith &&  pointTemp.x >= self.cropPointBottomLeft.y - cropSizeMinHeight) {
                    
                    self.croporiginY = self.cropPointBottomLeft.y - cropSizeMinHeight;
                    self.cropWidth = cropSizeMinWith;
                    self.cropHeight = cropSizeMinHeight;
                }
                
            }else{
                
                //超出拖动区域异常处理
                if (pointTemp.x <= self.cropPointBottomLeft.x +  cropSizeMinWith && pointTemp.y <= self.trackingRectPointTopRight.y) {
                    
                    self.croporiginY = self.trackingRectPointTopRight.y;
                    self.cropWidth = cropSizeMinWith;
                    self.cropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopRight.y) ;
                    
                }
                
                if (pointTemp.x >= self.cropPointBottomLeft.x +  cropSizeMinWith &&  pointTemp.y<= self.trackingRectPointTopRight.y && pointTemp.x <= self.trackingRectPointTopRight.x) {
                    
                    self.croporiginY = self.trackingRectPointTopRight.y;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopRight.y) ;
                    
                }
                
                if (pointTemp.y >= self.cropPointBottomLeft.y - cropSizeMinHeight && pointTemp.x >= self.trackingRectPointTopRight.x) {
                    
                    self.croporiginY = self.cropPointBottomLeft.y - cropSizeMinHeight;
                    self.cropWidth = self.trackingRectPointTopRight.x - self.cropPointBottomLeft.x;
                    self.cropHeight = cropSizeMinHeight ;
                    
                }
                
                if (pointTemp.y < self.cropPointBottomLeft.y - cropSizeMinHeight && pointTemp.x >= self.trackingRectPointTopRight.x && pointTemp.y >= self.trackingRectPointTopRight.y) {
                    
                    self.croporiginY = pointTemp.y;
                    self.cropWidth = fabs(self.trackingRectPointTopRight.x - self.cropPointBottomLeft.x);
                    self.cropHeight = distanceHeight ;
                    
                }
                
                if (pointTemp.x >= self.trackingRectPointTopRight.x && pointTemp.y <= self.trackingRectPointTopRight.y) {
                    
                    self.croporiginY = self.trackingRectPointTopRight.y;
                    self.cropWidth = fabs(self.trackingRectPointTopRight.x - self.cropPointBottomLeft.x);
                    self.cropHeight = fabs(self.trackingRectPointTopRight.y - self.cropPointBottomLeft.y);
                }
               
            }
            
        }
        else{
            //等比例缩放
            CGFloat croporiginX = pointTemp.x - self.changePointTemp.x;
            CGFloat croporiginY = pointTemp.y - self.changePointTemp.y;
            self.changePointTemp = CGPointMake(self.changePointTemp.x +croporiginX, self.changePointTemp.y +croporiginY);
            CGFloat newCroporiginY = 0.0;
            CGFloat newCropWidth = self.cropWidth + croporiginX;
            NSLog(@"newCropWidth%f",newCropWidth);
            NSLog(@"elf.cropSizeMin.width%f",cropSizeMinWith);
            CGFloat newCropHeight = 0.0;
            
            newCroporiginY  = self.croporiginY - (croporiginX / self.ratio);
            newCropHeight = newCropWidth / self.ratio;
            
            if (newCropWidth < cropSizeMinWith || newCropHeight < cropSizeMinHeight) {
                return YES;
            }
            
            if (self.cropPointBottomLeft.y - newCropHeight <= self.trackingRectPointTopRight.y ) {
                
                
                newCropHeight = fabs(self.trackingRectPointTopRight.y - self.cropPointBottomLeft.y);
                newCroporiginY = self.cropPointBottomLeft.y - newCropHeight;
                newCropWidth = newCropHeight * self.ratio;
            }

            if (self.cropPointBottomLeft.x + newCropWidth >= self.trackingRectPointTopRight.x) {
                
                newCropWidth = fabs(self.trackingRectPointTopRight.x - self.cropPointBottomLeft.x);
                newCropHeight = newCropWidth / self.ratio;
                newCroporiginY = self.cropPointBottomLeft.y - newCropHeight;
            }

            if (newCropWidth < cropSizeMinWith  ||  newCropHeight <= cropSizeMinHeight) {
                
                
                NSLog(@"------------>异常3 1");
                newCropWidth = cropSizeMinWith;
                newCropHeight = cropSizeMinHeight;
                newCroporiginY = self.cropPointBottomLeft.y - newCropHeight;
                
                NSLog(@"------------>异常 %f",self.cropPointBottomLeft.y);
            }
            self.croporiginY = newCroporiginY;
            self.cropWidth = newCropWidth;
            self.cropHeight = newCropHeight;
            
        }
        [self setNeedsDisplay];
        
        NSLog(@"拖动右上方");
        return YES;
    }if (self.cropViewTrackType == VE_TRACK_BOTTOMLEFT) {
        if(self.videoCropType == VEVideoCropType_Dewatermark){
            return YES;
        }
        
        if (self.cropType == VE_VECROPTYPE_FREE ) {
            float distanceWidth = fabs(pointTemp.x - self.cropPointTopRight.x);
            float distanceHeight = fabs(pointTemp.y - self.cropPointTopRight.y);
            
            
            if (pointTemp.x > self.trackingRectPointBottomLeft.x && pointTemp.y < self.trackingRectPointBottomLeft.y && pointTemp.x <self.cropPointTopRight.x && pointTemp.y > self.cropPointTopRight.y) {
                
                if (pointTemp.x > self.trackingRectPointTopRight.x && pointTemp.x <= self.cropPointTopRight.x - cropSizeMinWith && pointTemp.y < self.cropPointTopRight.y + cropSizeMinHeight){
                    
                    self.croporiginX = pointTemp.x;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = cropSizeMinHeight;
                    
                    
                }
                
                if (pointTemp.x > self.cropPointTopRight.x - cropSizeMinWith && pointTemp.y > self.cropPointTopRight.y + cropSizeMinHeight &&  pointTemp.y < self.trackingRectPointBottomLeft.y) {
                    
                    self.croporiginX = self.cropPointTopRight.x - cropSizeMinWith;
                    self.cropWidth = cropSizeMinWith;
                    self.cropHeight = distanceHeight;
                    
                }
                
                if (pointTemp.x >=  self.trackingRectPointTopLeft.x && pointTemp.x <=  self.cropPointTopRight.x - cropSizeMinWith  && pointTemp.y >= self.cropPointTopRight.y + cropSizeMinHeight && pointTemp.y <= self.trackingRectPointBottomLeft.y) {
                    
                    self.croporiginX = pointTemp.x;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = distanceHeight;
                    
                }
                
            }else{
                if (pointTemp.x < self.trackingRectPointBottomLeft.x && pointTemp.y < self.cropPointTopRight.y + cropSizeMinHeight) {
                    
                    self.croporiginX = self.trackingRectPointBottomLeft.x;
                    self.cropWidth = fabs(self.trackingRectPointBottomLeft.x - self.cropPointTopRight.x);
                    self.cropHeight = cropSizeMinHeight;
                    
                }
                
                if (pointTemp.x < self.trackingRectPointBottomLeft.x && pointTemp.y >= self.cropPointTopRight.y + cropSizeMinHeight && pointTemp.y < self.trackingRectPointBottomLeft.y) {
                    
                    self.croporiginX = self.trackingRectPointBottomLeft.x;
                    self.cropWidth = fabs(self.cropPointTopRight.x - self.trackingRectPointBottomLeft.x);
                    self.cropHeight = distanceHeight;
                    
                }
                
                if (pointTemp.x >= self.cropPointTopRight.x - cropSizeMinWith  && pointTemp.x < self.cropPointTopRight.x && pointTemp.y >  self.trackingRectPointBottomLeft.y) {
                    
                    self.croporiginX = fabs(self.cropPointTopRight.x - cropSizeMinWith);
                    self.cropWidth = cropSizeMinWith;
                    self.cropHeight = fabs(self.trackingRectPointBottomLeft.y - self.cropPointTopRight.y);
                }
                
                if ( pointTemp.x <= self.cropPointTopRight.x - cropSizeMinWith && pointTemp.x > self.trackingRectPointBottomLeft.x && pointTemp.y >  self.trackingRectPointBottomLeft.y) {
                    
                    
                    self.croporiginX = pointTemp.x;
                    self.cropWidth = fabs(pointTemp.x - self.cropPointTopRight.x);
                    self.cropHeight = fabs(self.trackingRectPointBottomLeft.y - self.cropPointTopRight.y);
                }
                
                if ( pointTemp.x <= self.trackingRectPointBottomLeft.x && pointTemp.y >= self.trackingRectPointBottomLeft.y){
                    
                    self.croporiginX = self.trackingRectPointBottomLeft.x;
                    self.cropWidth = fabs(self.trackingRectPointBottomLeft.x - self.cropPointTopRight.x);
                    self.cropHeight = fabs(self.trackingRectPointBottomLeft.y - self.cropPointTopRight.y);
                }
            }
        }
        else{
            
            //等比例缩放
            CGFloat croporiginX = pointTemp.x - self.changePointTemp.x;
            CGFloat croporiginY = pointTemp.y - self.changePointTemp.y;
            self.changePointTemp = CGPointMake(self.changePointTemp.x +croporiginX, self.changePointTemp.y +croporiginY);
            CGFloat newCroporiginX = self.croporiginX + croporiginX;
            CGFloat newCropWidth = self.cropWidth - croporiginX;
            NSLog(@"newCropWidth%f",newCropWidth);
            CGFloat newCropHeight = 0.0;
            if (self.ratio > 1.0) {
                newCropHeight = newCropWidth / self.ratio;
            }else{
                newCropHeight = newCropWidth / self.ratio;
            }
            
            if (newCropWidth < cropSizeMinWith || newCropHeight < cropSizeMinHeight) {
                return YES;
            }
            
            if (newCroporiginX <= self.trackingRectPointTopLeft.x) {

                newCropWidth = fabs(self.cropPointTopRight.x - self.trackingRectPointTopLeft.x);
                newCroporiginX = self.trackingRectPointTopLeft.x;
                if (self.ratio > 1.0) {
                    newCropHeight = newCropWidth / self.ratio;
                    NSLog(@"------------>异常1 1");
                }else{
                    newCropHeight = newCropWidth / self.ratio;
                    NSLog(@"------------>异常1 2");
                }
            }

            if (self.cropPointTopRight.y +newCropHeight  >= self.trackingRectPointBottomLeft.y) {


                newCropHeight = fabs(self.trackingRectPointBottomLeft.y - self.cropPointTopRight.y);
                if (self.ratio > 1.0) {
                    newCropWidth = newCropHeight * self.ratio;
                    NSLog(@"------------>异常2 1");
                }else{
                    newCropWidth = newCropHeight * self.ratio;
                    NSLog(@"------------>异常2 2");
                }
                newCroporiginX = self.cropPointTopRight.x - newCropWidth;
                
            }
            if (self.cropPointTopRight.y +newCropHeight <= self.cropPointTopRight.y +cropSizeMinHeight  && self.cropPointTopRight.x +newCropWidth >= self.cropPointTopRight.x - cropSizeMinWith) {

                newCroporiginX = self.cropPointTopRight.x - cropSizeMinWith;
                newCropWidth = cropSizeMinWith;

                if (self.ratio > 1.0) {
                    newCropHeight = newCropWidth / self.ratio;

                }else{
                    newCropHeight = newCropWidth / self.ratio;

                }
            
            }
            self.croporiginX = newCroporiginX;
            self.cropWidth = newCropWidth;
            self.cropHeight = newCropHeight;
        }
        [self setNeedsDisplay];
        NSLog(@"拖动左下方");
        return YES;
    }else if (self.cropViewTrackType == VE_TRACK_BOTTOMRIGHT){
       
        
        if (self.cropType == VE_VECROPTYPE_FREE) {
            
            float distanceWidth = fabs(pointTemp.x - self.cropPointTopLeft.x);
            float distanceHeight = fabs(pointTemp.y - self.cropPointTopLeft.y);
            
          
            if (pointTemp.x < self.trackingRectPointBottomRight.x && pointTemp.y < self.trackingRectPointBottomRight.y && pointTemp.x > self.cropPointTopLeft.x && pointTemp.y > self.cropPointTopLeft.y) {
                
                if (pointTemp.x < (self.cropPointTopLeft.x + cropSizeMinWith) && pointTemp.y > self.cropPointTopLeft.y + cropSizeMinHeight ) {
                    
                    self.cropWidth = cropSizeMinWith;
                    self.cropHeight = distanceHeight;
                    
                }
                
                if (pointTemp.x > (self.cropPointTopLeft.x + cropSizeMinWith) && pointTemp.y < self.cropPointTopLeft.y + cropSizeMinHeight ) {
                    
                    self.cropWidth = distanceWidth;
                    self.cropHeight = cropSizeMinHeight;
                }
                
                if (pointTemp.x >= (self.cropPointTopLeft.x + cropSizeMinWith) && pointTemp.y >= self.cropPointTopLeft.y + cropSizeMinHeight) {
                    self.cropWidth = distanceWidth;
                    self.cropHeight = distanceHeight;
                }
            }else{
              
                if (pointTemp.x >=  self.trackingRectPointBottomRight.x && pointTemp.y <= self.cropPointTopLeft.y + cropSizeMinHeight) {
                    NSLog(@"------->0");
                    self.cropWidth = fabs(self.trackingRectPointBottomRight.x - self.cropPointTopLeft.x);
                    self.cropHeight = cropSizeMinHeight;
                }
                
                
                if (pointTemp.x >=  self.trackingRectPointBottomRight.x && pointTemp.y > self.cropPointTopLeft.y + cropSizeMinHeight && pointTemp.y < self.trackingRectPointBottomRight.y) {
                    NSLog(@"------->1");
                    self.cropWidth = fabs(self.trackingRectPointBottomRight.x - self.cropPointTopLeft.x);
                    self.cropHeight = distanceHeight;
                }
                
                
                if (pointTemp.x >=  self.cropPointTopLeft.x && pointTemp.x <= self.cropPointTopLeft.x + cropSizeMinWith && pointTemp.y >= self.trackingRectPointBottomRight.y) {
                    NSLog(@"------->2");
                    self.cropWidth = cropSizeMinWith;
                    self.cropHeight = fabs(self.trackingRectPointBottomRight.y - self.cropPointTopLeft.y);
                }
                
                
                if (pointTemp.x >=  self.cropPointTopLeft.x + cropSizeMinWith  && pointTemp.x <= self.trackingRectPointBottomRight.x &&
                    pointTemp.y > self.trackingRectPointBottomRight.y) {
                    NSLog(@"------->3");
                    self.cropWidth = fabs(pointTemp.x - self.cropPointTopLeft.x);
                    self.cropHeight = fabs(self.trackingRectPointBottomRight.y - self.cropPointTopLeft.y);
                }
                
                if (pointTemp.x >= self.trackingRectPointBottomRight.x && pointTemp.y >= self.trackingRectPointBottomRight.y) {
                    NSLog(@"------->4");
                    self.cropWidth = fabs(self.trackingRectPointBottomRight.x - self.cropPointTopLeft.x);
                    self.cropHeight = fabs(self.trackingRectPointBottomRight.y - self.cropPointTopLeft.y);
                }
                
                if (pointTemp.x <= self.cropPointTopLeft.x + cropSizeMinWith && pointTemp.y <= self.cropPointTopLeft.y + cropSizeMinHeight) {
                    
                    self.cropWidth = cropSizeMinWith;
                    self.cropHeight = cropSizeMinHeight;
                    
                }
            }
            
        }
        else{
            
            //等比例缩放
            CGFloat croporiginX = pointTemp.x - self.changePointTemp.x;
            CGFloat croporiginY = pointTemp.y - self.changePointTemp.y;
            self.changePointTemp = CGPointMake(self.changePointTemp.x +croporiginX, self.changePointTemp.y +croporiginY);
            
            CGFloat newCropWidth = self.cropWidth + croporiginX;
            NSLog(@"newCropWidth%f",newCropWidth);
            CGFloat newCropHeight = 0.0;
            if (self.ratio > 1.0) {
                newCropHeight = newCropWidth / self.ratio;
            }else{
                newCropHeight = newCropWidth / self.ratio;
            }
            
            if (newCropWidth < cropSizeMinWith || newCropHeight < cropSizeMinHeight) {
                return YES;
            }
            
            if (self.cropPointTopLeft.x +newCropWidth >= self.trackingRectPointTopRight.x   ) {
                newCropWidth = fabs(self.trackingRectPointTopRight.x - self.cropPointTopLeft.x);
                if (self.ratio > 1.0) {
                    newCropHeight = newCropWidth / self.ratio;
                    NSLog(@"------------>异常1 1");
                }else{
                    newCropHeight = newCropWidth / self.ratio;
                    NSLog(@"------------>异常1 2");
                }


            }

            if (self.cropPointTopLeft.y +newCropHeight >= self.trackingRectPointBottomRight.y) {


                newCropHeight = fabs(self.trackingRectPointBottomRight.y- self.cropPointTopLeft.y);
                if (self.ratio > 1.0) {
                    newCropWidth = newCropHeight * self.ratio;
                    NSLog(@"------------>异常2 1");
                }else{
                    newCropWidth = newCropHeight * self.ratio;
                    NSLog(@"------------>异常2 2");
                }


            }
            if (self.cropPointTopLeft.x +newCropWidth <= self.cropPointTopLeft.x + cropSizeMinWith  && self.cropPointTopLeft.y +newCropHeight <= self.cropPointTopLeft.y + cropSizeMinHeight) {
                newCropWidth = cropSizeMinWith;

                if (self.ratio > 1.0) {
                    newCropHeight = newCropWidth / self.ratio;

                }else{
                    newCropHeight = newCropWidth / self.ratio;

                }
            }
            self.cropWidth = newCropWidth;
            self.cropHeight = newCropHeight;
        }
        [self setNeedsDisplay];
        NSLog(@"拖动右下方");
        return YES;
    }else if (self.cropViewTrackType == VE_TRACK_CROPRECTVIEW){
        CGFloat croporiginX = pointTemp.x - self.changePointTemp.x;
        CGFloat croporiginY = pointTemp.y - self.changePointTemp.y;
        if( _videoCropView )
        {
//            NSSet *touches = [event allTouches];
//            if (touches.count == 2) {
//                self.cropViewTrackType = VE_TRACK_SCALING;
//                _isDrawCroprectview = true;
//                return YES;
//            }
//            else
            {
                CGFloat deltaX = pointTemp.x - self.lastLocation.x;
                CGFloat deltaY = pointTemp.y - self.lastLocation.y;
                
                CGPoint center =  CGPointMake(_videoCropView.center.x + deltaX, _videoCropView.center.y + deltaY);
                
                CGRect rectInSourceView = self.cropRectView.frame;
                float  startX = (center.x - _videoCropView.frame.size.width/2.0)+ self.videoFrame.origin.x;
                float restrictionsStartX = rectInSourceView.origin.x;
                float endX = center.x + _videoCropView.frame.size.width/2.0 - ( _videoCropView.frame.size.width - (self.videoFrame.origin.x + self.videoFrame.size.width) );
                float restrictionsEndX = rectInSourceView.origin.x + rectInSourceView.size.width;
                
                float  startY = center.y - _videoCropView.frame.size.height/2.0 + self.videoFrame.origin.y;
                float restrictionsStartY = rectInSourceView.origin.y;
                float endY = center.y + _videoCropView.frame.size.height/2.0 - ( _videoCropView.frame.size.height - (self.videoFrame.origin.y + self.videoFrame.size.height) );
                float restrictionsEndY = rectInSourceView.origin.y + rectInSourceView.size.height ;
                
                if( restrictionsStartX < startX )
                {
                    center.x = restrictionsStartX + _videoCropView.frame.size.width/2.0 - self.videoFrame.origin.x;
                }
                else if( restrictionsEndX > endX )
                {
                    center.x = restrictionsEndX - _videoCropView.frame.size.width/2.0 + (_videoCropView.frame.size.width - (self.videoFrame.origin.x + self.videoFrame.size.width));
                }
                
                if( restrictionsStartY < startY )
                {
                    center.y = restrictionsStartY + _videoCropView.frame.size.height/2.0 - self.videoFrame.origin.y;
                }
                else if( restrictionsEndY > endY  )
                {
                    center.y = restrictionsEndY - _videoCropView.frame.size.height/2.0 + (_videoCropView.frame.size.height - (self.videoFrame.origin.y + self.videoFrame.size.height));
                }
                _videoCropView.center = center;
                _isDrawCroprectview = true;
                [self setNeedsDisplay];
            }
        }
        else
        {
            if( !_videoCropView )
                    self.changePointTemp = CGPointMake(self.changePointTemp.x +croporiginX, self.changePointTemp.y +croporiginY);
            CGFloat newCroporiginX = self.croporiginX + croporiginX;
            CGFloat newCroporiginY = self.croporiginY + croporiginY;
            if (newCroporiginX <= self.trackingRectPointTopLeft.x) {
                newCroporiginX = self.trackingRectPointTopLeft.x;
            }
            if (newCroporiginX >= self.trackingRectPointTopRight.x - self.cropWidth) {
                newCroporiginX = self.trackingRectPointTopRight.x - self.cropWidth;
            }
            if (newCroporiginY <= self.trackingRectPointTopLeft.y) {
                newCroporiginY = self.trackingRectPointTopLeft.y;
            }
            if (newCroporiginY >= self.trackingRectPointBottomLeft.y - self.cropHeight) {
                newCroporiginY = self.trackingRectPointBottomLeft.y - self.cropHeight;
            }
            self.croporiginX = newCroporiginX;
            self.croporiginY = newCroporiginY;
            [self setNeedsDisplay];
        }
    }
    if( _videoCropView )
    {
        if( self.cropViewTrackType != VE_TRACK_SCALING )
        {
            if ( (self.cropViewTrackType == VE_TRACK_CROPRECTVIEW) && _videoCropView)
            {
                
            }
            else
                [self needsUpdateCropPoints];
        }
    }
    else{
        [self needsUpdateCropPoints];
    }
    return YES;
}
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if (self.cropViewTrackType == VE_TRACK_TOP) {
        NSLog(@"结束拖动上方");
    }else if (self.cropViewTrackType == VE_TRACK_BOTTOM){
        NSLog(@"结束拖动下方");
    }if (self.cropViewTrackType == VE_TRACK_LEFT) {
        NSLog(@"结束拖左边");
    }else if (self.cropViewTrackType == VE_TRACK_RIGHT){
        NSLog(@"结束拖右边");
    }if (self.cropViewTrackType == VE_TRACK_TOPLEFT) {
        NSLog(@"结束拖动左上方");
    }else if (self.cropViewTrackType == VE_TRACK_TOPRIGHT){
        NSLog(@"结束拖动右上方");
    }if (self.cropViewTrackType == VE_TRACK_BOTTOMLEFT) {
        NSLog(@"结束拖动左下方");
    }else if (self.cropViewTrackType == VE_TRACK_BOTTOMRIGHT){
        NSLog(@"结束拖动右下方");
    }else if (self.cropViewTrackType == VE_TRACK_CROPRECTVIEW){
//        NSLog(@"结束剪切区域拖动");
        if( _videoCropView )
        {
            [self convertView:self.cropRectView atDestinationView:self atInView:_videoView];
//            {
//                // 获取源控件上的 CGRect
//                CGRect rectInSourceView = self.cropRectView.frame;
//                // 将源控件上的 CGRect 转换到窗口坐标系中
//                CGRect rectInWindow = [_videoView convertRect:rectInSourceView toView:nil];
//                // 将窗口坐标系中的 CGRect 转换回目标控件上
//                CGRect rectInDestinationView = [self convertRect:rectInWindow fromView:nil];
//                self.cropRectView.frame = rectInDestinationView;
//            }
//            [self addSubview:self.cropRectView];
            
            self.croporiginX = self.cropRectView.frame.origin.x;
            self.croporiginY = self.cropRectView.frame.origin.y;
            self.cropWidth = self.cropRectView.frame.size.width;
            self.cropHeight = self.cropRectView.frame.size.height;
            
            _isDrawCroprectview = false;
            [self setNeedsDisplay];
        }
    }
    else if(self.cropViewTrackType == VE_TRACK_SCALING)
    {
        if( _videoCropView )
        {
            return;
//            [self convertView:self.cropRectView atDestinationView:self atInView:_videoView];
//            self.croporiginX = self.cropRectView.frame.origin.x;
//            self.croporiginY = self.cropRectView.frame.origin.y;
//            self.cropWidth = self.cropRectView.frame.size.width;
//            self.cropHeight = self.cropRectView.frame.size.height;
//            
//            _isDrawCroprectview = false;
//            [self setNeedsDisplay];
        }
    }
  
    if( self.cropViewTrackType != VE_TRACK_SCALING )
    {
        [self needsUpdateCropPoints];
        if( self.delegate && [self.delegate respondsToSelector:@selector(endDragCropView)] )
        {
            [self.delegate endDragCropView];
        }
    }
}
- (void)cancelTrackingWithEvent:(nullable UIEvent *)event
{
    if (self.cropViewTrackType == VE_TRACK_CROPRECTVIEW){
        if( _videoCropView )
        {
            {
                // 获取源控件上的 CGRect
                CGRect rectInSourceView = self.cropRectView.frame;
                // 将源控件上的 CGRect 转换到窗口坐标系中
                CGRect rectInWindow = [_videoView convertRect:rectInSourceView toView:nil];
                // 将窗口坐标系中的 CGRect 转换回目标控件上
                CGRect rectInDestinationView = [self convertRect:rectInWindow fromView:nil];
                self.cropRectView.frame = rectInDestinationView;
            }
            [self addSubview:self.cropRectView];
            
            self.croporiginX = self.cropRectView.frame.origin.x;
            self.croporiginY = self.cropRectView.frame.origin.y;
            self.cropWidth = self.cropRectView.frame.size.width;
            self.cropHeight = self.cropRectView.frame.size.height;
            
            _isDrawCroprectview = false;
            [self setNeedsDisplay];
            
            [self needsUpdateCropPoints];
            if( self.delegate && [self.delegate respondsToSelector:@selector(endDragCropView)] )
            {
                [self.delegate endDragCropView];
            }
        }
    }
}

#pragma mark - 6.Set & Get

-(void)setCropRect:(CGRect)crop{
    
    if(_cropType == VE_VECROPTYPE_FIXEDRATIO){
        self.ratio = crop.size.width / crop.size.height;
    }
    
    self.croporiginX = self.videoFrame.origin.x +  crop.origin.x;
    self.croporiginY =  self.videoFrame.origin.y + crop.origin.y;
    
    
    self.cropWidth =  crop.size.width;
    self.cropHeight  =  crop.size.height;
    
    [self needsUpdateCropPoints];
    [self setNeedsDisplay];
}

-(CGRect)crop{
    
    return  [self getCropRect];
    
}

-(CGRect)cropRect{
    return CGRectMake(self.croporiginX -self.trackingRectPointTopLeft.x, self.croporiginY-self.trackingRectPointTopLeft.y, self.cropWidth, self.cropHeight);
}

-(VETrackButton *)topTrackButton{
    if (_topTrackButton == nil) {
        _topTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX + (self.cropWidth - VE_TRACK_HEIGHT)/2, self.croporiginY-VE_TRACK_WIDTH,VE_TRACK_HEIGHT , VE_TRACK_WIDTH) withCropViewTrackType:VE_TRACK_TOP];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [_topTrackButton setBackgroundColor:UIColorFromRGB(0x131313)];
        }else{
            [_topTrackButton setBackgroundColor:[UIColor whiteColor]];
        }
    }
    return _topTrackButton;

}

-(VETrackButton *)bottomTrackButton{
    if (_bottomTrackButton == nil) {
        _bottomTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX + (self.cropWidth - VE_TRACK_HEIGHT)/2, self.croporiginY +self.cropHeight, VE_TRACK_HEIGHT, VE_TRACK_WIDTH) withCropViewTrackType:VE_TRACK_BOTTOM];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [_bottomTrackButton setBackgroundColor:UIColorFromRGB(0x131313)];
        }
        else{
            [_bottomTrackButton setBackgroundColor:[UIColor whiteColor]];
        }
    }
    return _bottomTrackButton;
}

-(VETrackButton *)leftTrackButton{
    if (_leftTrackButton == nil) {
        _leftTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX -VE_TRACK_WIDTH, self.croporiginY + (self.cropHeight-VE_TRACK_HEIGHT)/2, VE_TRACK_WIDTH, VE_TRACK_HEIGHT) withCropViewTrackType:VE_TRACK_LEFT];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [_leftTrackButton setBackgroundColor:UIColorFromRGB(0x131313)];
        }
        else{
            [_leftTrackButton setBackgroundColor:[UIColor whiteColor]];
        }
    }
    return _leftTrackButton;
}

-(VETrackButton *)rightTrackButton{
    if (_rightTrackButton == nil) {
        _rightTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX + self.cropWidth, self.croporiginY + (self.cropHeight-VE_TRACK_HEIGHT)/2, VE_TRACK_WIDTH, VE_TRACK_HEIGHT) withCropViewTrackType:VE_TRACK_RIGHT];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [_rightTrackButton setBackgroundColor:UIColorFromRGB(0x131313)];
        }
        else{
            [_rightTrackButton setBackgroundColor:Color(255, 255, 255, 1)];
        }
    }
    return _rightTrackButton;
}

-(VETrackButton *)topLeftTrackButton{
    if (_topLeftTrackButton == nil) {
        if ((self.videoCropType == VEVideoCropType_Crop)
            || (VEVideoCropType_FixedCrop == self.videoCropType )) {
            _topLeftTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX -VE_TRACK_WIDTH, self.croporiginY - VE_TRACK_WIDTH, VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH , VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH) withCropViewTrackType:VE_TRACK_TOPLEFT];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                [_topLeftTrackButton setBackgroundColor:UIColorFromRGB(0x131313)];
            }
            else{
                [_topLeftTrackButton setBackgroundColor:Color(255, 255, 255, 1)];
            }
        }else if (self.videoCropType == VEVideoCropType_Dewatermark){
            _topLeftTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX -VE_TRACK_HEIGHT_DEWATERMARK/2, self.croporiginY - VE_TRACK_HEIGHT_DEWATERMARK/2, VE_TRACK_HEIGHT_DEWATERMARK , VE_TRACK_HEIGHT_DEWATERMARK) withCropViewTrackType:VE_TRACK_Dewatermark];
            _topLeftTrackButton.layer.cornerRadius = VE_TRACK_HEIGHT_DEWATERMARK/2;
            _topLeftTrackButton.layer.masksToBounds = YES;
            [_topLeftTrackButton setBackgroundImage:[VEHelp imageWithContentOfFile:@"jianji/jianji_dewatermark_close_icon"] forState:UIControlStateNormal];
            
            [_topLeftTrackButton addTarget:self action:@selector(topLeftTrackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
           
        }
        
    }
    return _topLeftTrackButton;
}

-(VETrackButton *)topRightTrackButton{
    if (_topRightTrackButton == nil) {
        
        if ((self.videoCropType == VEVideoCropType_Crop)
            || (VEVideoCropType_FixedCrop == self.videoCropType )) {
            _topRightTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake((self.croporiginX+ self.cropWidth) -VE_TRACK_HEIGHT*1/2, self.croporiginY - VE_TRACK_WIDTH, VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH , VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH) withCropViewTrackType:VE_TRACK_TOPRIGHT];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                [_topRightTrackButton setBackgroundColor:UIColorFromRGB(0x131313)];
            }
            else{
                [_topRightTrackButton setBackgroundColor:Color(255, 255, 255, 1)];
            }
        }else if (self.videoCropType == VEVideoCropType_Dewatermark){
            _topRightTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake((self.croporiginX+ self.cropWidth) -VE_TRACK_HEIGHT_DEWATERMARK*1/2, self.croporiginY - VE_TRACK_HEIGHT_DEWATERMARK/2, VE_TRACK_HEIGHT_DEWATERMARK , VE_TRACK_HEIGHT_DEWATERMARK) withCropViewTrackType:VE_TRACK_Dewatermark];
            _topRightTrackButton.layer.cornerRadius = VE_TRACK_HEIGHT_DEWATERMARK/2;
            _topRightTrackButton.layer.masksToBounds = YES;
            [_topRightTrackButton setBackgroundImage:[VEHelp imageWithContentOfFile:@"jianji/jianji_dewatermark_edit_icon"] forState:UIControlStateNormal];
            [_topRightTrackButton addTarget:self action:@selector(topRightTrackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
       
    }
    return _topRightTrackButton;
}
-(VETrackButton *)bottomLeftTrackButton{
    if (_bottomLeftTrackButton == nil) {
        _bottomLeftTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX -VE_TRACK_WIDTH, self.croporiginY+self.cropHeight - VE_TRACK_HEIGHT*1/2, VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH , VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH) withCropViewTrackType:VE_TRACK_BOTTOMLEFT];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [_bottomLeftTrackButton setBackgroundColor:UIColorFromRGB(0x131313)];
        }
        else{
            [_bottomLeftTrackButton setBackgroundColor:Color(255, 255, 255, 1)];
        }
    }
    return _bottomLeftTrackButton;
}

-(VETrackButton *)bottomRightTrackButton{
    
    if (_bottomRightTrackButton == nil) {
        if ((self.videoCropType == VEVideoCropType_Crop)
            || (VEVideoCropType_FixedCrop == self.videoCropType )) {
            _bottomRightTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX+self.cropWidth -VE_TRACK_HEIGHT*1/2, self.croporiginY+self.cropHeight -VE_TRACK_HEIGHT*1/2, VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH , VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH) withCropViewTrackType:VE_TRACK_BOTTOMRIGHT];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                [_bottomRightTrackButton setBackgroundColor:UIColorFromRGB(0x131313)];
            }else{
                [_bottomRightTrackButton setBackgroundColor:Color(255, 255, 255, 1)];
            }
        }else if (self.videoCropType == VEVideoCropType_Dewatermark){
            _bottomRightTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX+self.cropWidth -VE_TRACK_HEIGHT_DEWATERMARK*1/2, self.croporiginY+self.cropHeight -VE_TRACK_HEIGHT_DEWATERMARK*1/2, VE_TRACK_HEIGHT_DEWATERMARK , VE_TRACK_HEIGHT_DEWATERMARK) withCropViewTrackType:VE_TRACK_Dewatermark];
            _bottomRightTrackButton.layer.cornerRadius = VE_TRACK_HEIGHT_DEWATERMARK/2;
            _bottomRightTrackButton.layer.masksToBounds = YES;
            [_bottomRightTrackButton setBackgroundImage:[VEHelp imageWithContentOfFile:@"jianji/jianji_dewatermark_zoom_icon"] forState:UIControlStateNormal];
        }
    }
    return _bottomRightTrackButton;
}

-(VECropRectView *)cropRectView{
    if (_cropRectView == nil) {
        _cropRectView =[[VECropRectView alloc] initWithFrame:CGRectMake(self.croporiginX, self.croporiginY, self.cropWidth, self.cropHeight) withVideoCropType:self.videoCropType];
        [_cropRectView setBackgroundColor:Color(0,0,0,0)];
    }
    return _cropRectView;
}

-(void)buttonAlpha:( float ) alpha
{
   if( self.topTrackButton.hidden != YES)
   {
       self.topTrackButton.alpha = alpha;
   }
    if( self.bottomTrackButton.hidden != YES)
    {
        self.bottomTrackButton.alpha = alpha;
    }
    if( self.leftTrackButton.hidden != YES)
    {
        self.leftTrackButton.alpha = alpha;
    }
    if( self.rightTrackButton.hidden != YES)
    {
        self.rightTrackButton.alpha = alpha;
    }
    if( self.topLeftTrackButton.hidden != YES)
    {
        self.topLeftTrackButton.alpha = alpha;
    }
    if( self.topRightTrackButton.hidden != YES)
    {
        self.topRightTrackButton.alpha = alpha;
    }
    if( self.bottomLeftTrackButton.hidden != YES)
    {
        self.bottomLeftTrackButton.alpha = alpha;
    }
    if( self.bottomRightTrackButton.hidden != YES)
    {
        self.bottomRightTrackButton.alpha = alpha;
    }
}

-(void)trackButtonAdjustmentPosition
{
   if( self.topTrackButton.hidden != YES)
   {
//       [self button:self.topTrackButton atScale:scale];
       CGRect rect =  self.topTrackButton.frame;
       rect.origin = CGPointMake(self.cropRectView.frame.origin.x + (self.cropRectView.frame.size.width - VE_TRACK_HEIGHT)/2, self.cropRectView.frame.origin.y-VE_TRACK_WIDTH);
       self.topTrackButton.frame = rect;
       
   }
    if( self.bottomTrackButton.hidden != YES)
    {
        //   [self button:self.bottomTrackButton atScale:scale];
        
        CGRect rect =  self.bottomTrackButton.frame;
        rect.origin = CGPointMake(self.cropRectView.frame.origin.x + (self.cropRectView.frame.size.width - VE_TRACK_HEIGHT)/2, self.cropRectView.frame.origin.y +self.cropRectView.frame.size.height);
        self.bottomTrackButton.frame = rect;
    }
    if( self.leftTrackButton.hidden != YES)
    {
        // [self button:self.leftTrackButton atScale:scale];
        
        CGRect rect =  self.leftTrackButton.frame;
        rect.origin = CGPointMake(self.cropRectView.frame.origin.x -VE_TRACK_WIDTH, self.cropRectView.frame.origin.y + (self.cropRectView.frame.size.height-VE_TRACK_HEIGHT)/2);
        self.leftTrackButton.frame = rect;
    }
    if( self.rightTrackButton.hidden != YES)
    {
        // [self button:self.rightTrackButton atScale:scale];
        
        CGRect rect =  self.rightTrackButton.frame;
        rect.origin = CGPointMake(self.cropRectView.frame.origin.x + self.cropRectView.frame.size.width, self.cropRectView.frame.origin.y + (self.cropRectView.frame.size.height-VE_TRACK_HEIGHT)/2);
        self.rightTrackButton.frame = rect;
    }
    
    if( self.topLeftTrackButton.hidden != YES)
    {
        //    [self button:self.topLeftTrackButton atScale:scale];
        
        CGRect rect =  self.topLeftTrackButton.frame;
        rect.origin = CGPointMake(self.cropRectView.frame.origin.x -VE_TRACK_WIDTH, self.cropRectView.frame.origin.y - VE_TRACK_WIDTH);
        self.topLeftTrackButton.frame = rect;
    }
    if( self.topRightTrackButton.hidden != YES)
    {
        //  [self button:self.topRightTrackButton atScale:scale];
        
        CGRect rect =  self.topRightTrackButton.frame;
        rect.origin = CGPointMake((self.cropRectView.frame.origin.x+ self.cropRectView.frame.size.width) -VE_TRACK_HEIGHT*1/2, self.cropRectView.frame.origin.y - VE_TRACK_WIDTH);
        self.topRightTrackButton.frame = rect;
    }
    if( self.bottomLeftTrackButton.hidden != YES)
    {
        //   [self button:self.bottomLeftTrackButton atScale:scale];
        
        CGRect rect =  self.bottomLeftTrackButton.frame;
        rect.origin = CGPointMake(self.cropRectView.frame.origin.x -VE_TRACK_WIDTH, self.cropRectView.frame.origin.y+self.cropRectView.frame.size.height - VE_TRACK_HEIGHT*1/2);
        self.bottomLeftTrackButton.frame = rect;
    }
    if( self.bottomRightTrackButton.hidden != YES)
    {
        //  [self button:self.bottomRightTrackButton atScale:scale];
        
        CGRect rect =  self.bottomRightTrackButton.frame;
        rect.origin = CGPointMake(self.cropRectView.frame.origin.x+self.cropRectView.frame.size.width -VE_TRACK_HEIGHT*1/2, self.cropRectView.frame.origin.y+self.cropRectView.frame.size.height -VE_TRACK_HEIGHT*1/2);
        self.bottomRightTrackButton.frame = rect;
    }
    [self.cropRectView setNeedsDisplay];
}

//-(void)button:( VETrackButton * ) button atScale:( float ) scale
//{
//    button.transform =  CGAffineTransformMakeScale(1.0, 1.0);
//    button.transform = CGAffineTransformMakeScale(1.0/scale, 1.0/scale);
//}

-(void)trackButton_hidden:(  BOOL ) isHidden
{
    _isTrackButtonHidden = isHidden;
    self.topTrackButton.hidden = YES;
    self.bottomTrackButton.hidden = YES;
    self.leftTrackButton.hidden = YES;
    self.rightTrackButton.hidden = YES;
    
    self.topLeftTrackButton.hidden = YES;
    self.topRightTrackButton.hidden = YES;
    self.bottomLeftTrackButton.hidden = YES;
    self.bottomRightTrackButton.hidden = YES;
    
    _cropRectView.isTrackButtonHidden = _isTrackButtonHidden;
    
    if( _isTrackButtonHidden )
    {
        _cropRectView.layer.borderWidth = 2.0;
    }
    
    [_cropRectView setNeedsLayout];
    [_cropRectView setNeedsDisplay];
}
@end

