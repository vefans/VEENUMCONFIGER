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


@property(nonatomic,assign) CGFloat cropWidth;
@property(nonatomic,assign) CGFloat cropHeight;
@property(nonatomic,assign) CGFloat croporiginX;
@property(nonatomic,assign) CGFloat croporiginY;


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

#pragma mark - 1.Life Cycle

-(instancetype)initWithFrame:(CGRect)frame withVideoCropType:(VEVideoCropType)videoCropType{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.videoCropType = videoCropType;
        self.cropType = VE_VECROPTYPE_FREE;
        
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN, VE_CROPHEIGHT_MIN);
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
        
        [self ratioFreeAandOriginal];
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
        
    }else if(cropType == VE_VECROPTYPE_4TO5){
        
        [self ratioLessThan1WithValueX:4.0 WithToValueY:5.0];
        [self setTrackButtonState:YES];
        
        
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/5)*4, VE_CROPHEIGHT_MIN);
        
    }else if(cropType == VE_VECROPTYPE_4TO3){
        
        [self ratioGreaterThan1WithValueX:4.0 WithToValueY:3.0];
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake(VE_CROPWIDTH_MIN, (VE_CROPHEIGHT_MIN/4)*3);
        
    }else if(cropType == VE_VECROPTYPE_3TO4){
        
        [self ratioLessThan1WithValueX:3.0 WithToValueY:4.0];
        [self setTrackButtonState:YES];
        
        self.cropSizeMin = CGSizeMake((VE_CROPWIDTH_MIN/4)*3, VE_CROPHEIGHT_MIN);
        
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
    
    if ( _videoFrame.size.width > _videoFrame.size.height) {
        
        if(videoR > 1.0 && self.cropType == VE_VECROPTYPE_FIXEDRATIO){
            
            self.croporiginX = _videoFrame.origin.x;
            self.croporiginY = _videoFrame.origin.y+ (_videoFrame.size.height -_videoFrame.size.width/videoR)/2;
            self.cropWidth = _videoFrame.size.width;
            self.cropHeight = _videoFrame.size.width /videoR;
        }else{
            self.croporiginX = _videoFrame.origin.x+ (_videoFrame.size.width -_videoFrame.size.height *valueX/valueY)/2;
            self.croporiginY = _videoFrame.origin.y;
            self.cropWidth = _videoFrame.size.height *valueX/valueY;
            self.cropHeight = _videoFrame.size.height;
        }
        
    }else{
        
        if (videoR > _videoFrame.size.width / _videoFrame.size.height) {
            
            self.croporiginX = _videoFrame.origin.x;
            self.croporiginY = _videoFrame.origin.y + (_videoFrame.size.height -_videoFrame.size.width* valueY/valueX)/2;
            self.cropWidth = _videoFrame.size.width;
            self.cropHeight = _videoFrame.size.width* valueY/valueX;
            
        }else{
            
            self.croporiginX = _videoFrame.origin.x+ (_videoFrame.size.width -_videoFrame.size.height *valueX/valueY)/2;
            self.croporiginY = _videoFrame.origin.y;
            self.cropWidth = _videoFrame.size.height *valueX/valueY;
            self.cropHeight = _videoFrame.size.height;
            
            

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

#pragma mark - 2.Setting View and Style


- (void)setVideoFrame:(CGRect)videoFrame{
    _videoFrame = videoFrame;
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
    v_r.size.width = r.size.width/self.videoSize.width;
    v_r.size.height = r.size.height/self.videoSize.height;

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

#pragma mark - 5.DataSource and Delegate

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    // 当前控件上的点转换到chatView上
    // 判断下点在不在chatView上
    CGRect topTrackBounds = self.topTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat topTrackwidthDelta = MAX(44.0 - topTrackBounds.size.width, 0);
    CGFloat topTrackheightDelta = MAX(44.0 - topTrackBounds.size.height, 0);
    topTrackBounds = CGRectInset(self.topTrackButton.frame, -0.5 * topTrackwidthDelta, -0.5 * topTrackheightDelta);
    
    
    // 判断下点在不在chatView上
    CGRect bottomTrackBounds = self.bottomTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat bottomTrackWidthDelta = MAX(44.0 - bottomTrackBounds.size.width, 0);
    CGFloat bottomTrackHeightDelta = MAX(44.0 - bottomTrackBounds.size.height, 0);
    bottomTrackBounds = CGRectInset(self.bottomTrackButton.frame, -0.5 * bottomTrackWidthDelta, -0.5 * bottomTrackHeightDelta);
    
    
    
    // 判断下点在不在chatView上
    CGRect leftTrackBounds = self.leftTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat leftTrackWidthDelta = MAX(44.0 - leftTrackBounds.size.width, 0);
    CGFloat leftTrackHeightDelta = MAX(44.0 - leftTrackBounds.size.height, 0);
    leftTrackBounds = CGRectInset(self.leftTrackButton.frame, -0.5 * leftTrackWidthDelta, -0.5 * leftTrackHeightDelta);
    
    
    // 判断下点在不在chatView上
    CGRect rightTrackBounds = self.rightTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat rightTrackWidthDelta = MAX(44.0 - rightTrackBounds.size.width, 0);
    CGFloat rightTrackHeightDelta = MAX(44.0 - rightTrackBounds.size.height, 0);
    rightTrackBounds = CGRectInset(self.rightTrackButton.frame, -0.5 * rightTrackWidthDelta, -0.5 * rightTrackHeightDelta);
    
    
    // 判断下点在不在chatView上
    CGRect topLeftTrackBounds = self.topLeftTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat topLeftTrackWidthDelta = MAX(44.0 - topLeftTrackBounds.size.width, 0);
    CGFloat topLeftTrackHeightDelta = MAX(44.0 - topLeftTrackBounds.size.height, 0);
    topLeftTrackBounds = CGRectInset(self.topLeftTrackButton.frame, -0.5 * topLeftTrackWidthDelta, -0.5 * topLeftTrackHeightDelta);
    
    
    // 判断下点在不在chatView上
    CGRect topRightTrackBounds = self.topRightTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat topRightTrackWidthDelta = MAX(44.0 - topRightTrackBounds.size.width, 0);
    CGFloat topRightTrackHeightDelta = MAX(44.0 - topRightTrackBounds.size.height, 0);
    topRightTrackBounds = CGRectInset(self.topRightTrackButton.frame, -0.5 * topRightTrackWidthDelta, -0.5 * topRightTrackHeightDelta);
    
    // 判断下点在不在chatView上
    CGRect bottomLeftTrackBounds = self.bottomLeftTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat bottomLeftTrackWidthDelta = MAX(44.0 - bottomLeftTrackBounds.size.width, 0);
    CGFloat bottomLeftTrackHeightDelta = MAX(44.0 - bottomLeftTrackBounds.size.height, 0);
    bottomLeftTrackBounds = CGRectInset(self.bottomLeftTrackButton.frame, -0.5 * bottomLeftTrackWidthDelta, -0.5 * bottomLeftTrackHeightDelta);
    
    // 判断下点在不在chatView上
    CGRect bottomRightTrackBounds = self.bottomRightTrackButton.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat bottomRightTrackWidthDelta = MAX(44.0 - bottomRightTrackBounds.size.width, 0);
    CGFloat bottomRightTrackHeightDelta = MAX(44.0 - bottomRightTrackBounds.size.height, 0);
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
        self.cropViewTrackType = VE_TRACK_CROPRECTVIEW;
        return  self.cropRectView.superview;
        
    }else{
        NSLog(@"动不动");
        self.cropViewTrackType = VE_TRACK_CROPRECTVIEW;
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
    }else if (self.cropViewTrackType == VE_TRACK_CROPRECTVIEW){
        NSLog(@"裁切");
        return YES;
        
    }
    return YES;
    
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint pointTemp = [touch locationInView:self];
    [self needsUpdateCropPoints];
//    NSLog(@"pointTemp %f", pointTemp.x);
    if (self.cropViewTrackType == VE_TRACK_TOP) {
        
        float distance = fabs(self.cropPointBottomLeft.y - pointTemp.y);
        if (self.cropPointBottomLeft.y - pointTemp.y > self.cropSizeMin.height && pointTemp.y >= self.trackingRectPointTopLeft.y) {
            self.croporiginY = pointTemp.y;
            self.cropHeight = distance;
        }else{
            if (self.cropPointBottomLeft.y - pointTemp.y > self.cropSizeMin.height) {
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
        if (pointTemp.y - self.cropPointTopLeft.y> self.cropSizeMin.height && pointTemp.y <= self.trackingRectPointBottomLeft.y) {
            self.cropHeight = distance;
        }else{
            if (pointTemp.y - self.cropPointTopLeft.y > self.cropSizeMin.height) {
                self.cropHeight = fabs(self.trackingRectPointBottomLeft.y - self.cropPointTopLeft.y );
            }
        }
        [self setNeedsDisplay];
        NSLog(@"拖动下方");
        return YES;
    }
    else if (self.cropViewTrackType == VE_TRACK_LEFT) {
        
        float distance = fabs(self.cropPointTopRight.x - pointTemp.x);
        if (fabs(self.cropPointTopRight.x - pointTemp.x)> self.cropSizeMin.width && pointTemp.x > self.trackingRectPointTopLeft.x && pointTemp.x <= self.cropPointTopRight.x - self.cropSizeMin.width) {
            self.croporiginX = pointTemp.x;
            self.cropWidth = distance;
        }else{
            if ( self.cropPointTopRight.x- pointTemp.x  > self.cropSizeMin.width) {
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
        if (fabs(pointTemp.x - self.cropPointTopLeft.x)> self.cropSizeMin.width && pointTemp.x < self.trackingRectPointTopRight.x) {
            
            self.cropWidth = distance;
        }else{
            if ( pointTemp.x - self.cropPointTopLeft.x  > self.cropSizeMin.width) {
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

                if (self.cropPointTopRight.x - pointTemp.x > self.cropSizeMin.width && pointTemp.x <= self.cropPointTopRight.x - self.cropSizeMin.width) {
                    self.croporiginX = pointTemp.x;
                    self.cropWidth = distanceWidth;
                }else {
                    self.croporiginX = self.cropPointTopRight.x - self.cropSizeMin.width;
                    self.cropWidth = self.cropSizeMin.width;
                }

                if (self.cropPointBottomLeft.y - pointTemp.y > self.cropSizeMin.height && pointTemp.y <= self.cropPointBottomLeft.y - self.cropSizeMin.height) {
                    self.croporiginY = pointTemp.y;
                    self.cropHeight = distanceHeight;
                }else{
                    self.croporiginY = self.cropPointBottomLeft.y - self.cropSizeMin.height;
                    self.cropHeight = self.cropSizeMin.height;
                }

            }else{

                if (pointTemp.x < self.cropPointBottomRight.x  && pointTemp.x >= self.cropPointBottomRight.x- self.cropSizeMin.width ) {

                    self.croporiginX = self.cropPointBottomRight.x- self.cropSizeMin.width ;
                    self.croporiginY =self.trackingRectPointTopLeft.y;
                    self.cropWidth = self.cropSizeMin.width;
                    self.cropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopLeft.y);

                }

                if (pointTemp.x < self.cropPointBottomRight.x- self.cropSizeMin.width && pointTemp.x > self.trackingRectPointTopLeft.x) {

                    self.croporiginX = pointTemp.x;
                    self.croporiginY = self.trackingRectPointTopLeft.y;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopLeft.y);

                }


                if (pointTemp.y < self.cropPointBottomLeft.y && pointTemp.y > self.cropPointBottomLeft.y -self.cropSizeMin.height) {

                    self.croporiginX = self.trackingRectPointTopLeft.x;
                    self.croporiginY = self.cropPointBottomLeft.y - self.cropSizeMin.height;
                    self.cropWidth = self.cropPointBottomRight.x -self.trackingRectPointTopLeft.x;
                    self.cropHeight = self.cropSizeMin.height;


                }

                if (pointTemp.y < self.cropPointBottomLeft.y -self.cropSizeMin.height && pointTemp.y > self.trackingRectPointTopLeft.y) {

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
            
            if (newCropWidth < self.cropSizeMin.width || newCropHeight < self.cropSizeMin.height) {
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
            
            if (newCroporiginX >= self.cropPointBottomRight.x - self.cropSizeMin.width  && newCroporiginY >= self.cropPointBottomLeft.y - self.cropSizeMin.height) {

                newCroporiginX = self.cropPointBottomRight.x - self.cropSizeMin.width;
                newCropWidth = self.cropSizeMin.width;
                
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
                
                
                if ((pointTemp.x > self.cropPointBottomLeft.x + self.cropSizeMin.width &&  pointTemp.y < self.cropPointBottomLeft.y - self.cropSizeMin.height) ) {

                    self.croporiginY = pointTemp.y;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = distanceHeight;
                    
                }
                
                if (pointTemp.x <= self.cropPointBottomLeft.x +  self.cropSizeMin.width && pointTemp.y < self.cropPointBottomLeft.y - self.cropSizeMin.height){
                    
                    self.croporiginY = pointTemp.y;
                    self.cropWidth = self.cropSizeMin.width;
                    self.cropHeight = distanceHeight;
                    
                    
                }
                
                if(pointTemp.y >= self.cropPointBottomLeft.y - self.cropSizeMin.height && pointTemp.x > self.cropPointBottomLeft.x +  self.cropSizeMin.width){
                    
                    self.croporiginY = self.cropPointBottomLeft.y - self.cropSizeMin.height;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = self.cropSizeMin.height;
                    
                    
                }
                
                if (pointTemp.x <= self.cropPointBottomLeft.x +  self.cropSizeMin.width &&  pointTemp.x >= self.cropPointBottomLeft.y - self.cropSizeMin.height) {
                    
                    self.croporiginY = self.cropPointBottomLeft.y - self.cropSizeMin.height;
                    self.cropWidth = self.cropSizeMin.width;
                    self.cropHeight = self.cropSizeMin.height;
                }
                
            }else{
                
                //超出拖动区域异常处理
                if (pointTemp.x <= self.cropPointBottomLeft.x +  self.cropSizeMin.width && pointTemp.y <= self.trackingRectPointTopRight.y) {
                    
                    self.croporiginY = self.trackingRectPointTopRight.y;
                    self.cropWidth = self.cropSizeMin.width;
                    self.cropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopRight.y) ;
                    
                }
                
                if (pointTemp.x >= self.cropPointBottomLeft.x +  self.cropSizeMin.width &&  pointTemp.y<= self.trackingRectPointTopRight.y && pointTemp.x <= self.trackingRectPointTopRight.x) {
                    
                    self.croporiginY = self.trackingRectPointTopRight.y;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = fabs(self.cropPointBottomLeft.y - self.trackingRectPointTopRight.y) ;
                    
                }
                
                if (pointTemp.y >= self.cropPointBottomLeft.y - self.cropSizeMin.height && pointTemp.x >= self.trackingRectPointTopRight.x) {
                    
                    self.croporiginY = self.cropPointBottomLeft.y - self.cropSizeMin.height;
                    self.cropWidth = self.trackingRectPointTopRight.x - self.cropPointBottomLeft.x;
                    self.cropHeight = self.cropSizeMin.height ;
                    
                }
                
                if (pointTemp.y < self.cropPointBottomLeft.y - self.cropSizeMin.height && pointTemp.x >= self.trackingRectPointTopRight.x && pointTemp.y >= self.trackingRectPointTopRight.y) {
                    
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
            NSLog(@"elf.cropSizeMin.width%f",self.cropSizeMin.width);
            CGFloat newCropHeight = 0.0;
            
            newCroporiginY  = self.croporiginY - (croporiginX / self.ratio);
            newCropHeight = newCropWidth / self.ratio;
            
            if (newCropWidth < self.cropSizeMin.width || newCropHeight < self.cropSizeMin.height) {
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

            if (newCropWidth < self.cropSizeMin.width  ||  newCropHeight <= self.cropSizeMin.height) {
                
                
                NSLog(@"------------>异常3 1");
                newCropWidth = self.cropSizeMin.width;
                newCropHeight = self.cropSizeMin.height;
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
                
                if (pointTemp.x > self.trackingRectPointTopRight.x && pointTemp.x <= self.cropPointTopRight.x - self.cropSizeMin.width && pointTemp.y < self.cropPointTopRight.y + self.cropSizeMin.height){
                    
                    self.croporiginX = pointTemp.x;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = self.cropSizeMin.height;
                    
                    
                }
                
                if (pointTemp.x > self.cropPointTopRight.x - self.cropSizeMin.width && pointTemp.y > self.cropPointTopRight.y + self.cropSizeMin.height &&  pointTemp.y < self.trackingRectPointBottomLeft.y) {
                    
                    self.croporiginX = self.cropPointTopRight.x - self.cropSizeMin.width;
                    self.cropWidth = self.cropSizeMin.width;
                    self.cropHeight = distanceHeight;
                    
                }
                
                if (pointTemp.x >=  self.trackingRectPointTopLeft.x && pointTemp.x <=  self.cropPointTopRight.x - self.cropSizeMin.width  && pointTemp.y >= self.cropPointTopRight.y + self.cropSizeMin.height && pointTemp.y <= self.trackingRectPointBottomLeft.y) {
                    
                    self.croporiginX = pointTemp.x;
                    self.cropWidth = distanceWidth;
                    self.cropHeight = distanceHeight;
                    
                }
                
            }else{
                if (pointTemp.x < self.trackingRectPointBottomLeft.x && pointTemp.y < self.cropPointTopRight.y + self.cropSizeMin.height) {
                    
                    self.croporiginX = self.trackingRectPointBottomLeft.x;
                    self.cropWidth = fabs(self.trackingRectPointBottomLeft.x - self.cropPointTopRight.x);
                    self.cropHeight = self.cropSizeMin.height;
                    
                }
                
                if (pointTemp.x < self.trackingRectPointBottomLeft.x && pointTemp.y >= self.cropPointTopRight.y + self.cropSizeMin.height && pointTemp.y < self.trackingRectPointBottomLeft.y) {
                    
                    self.croporiginX = self.trackingRectPointBottomLeft.x;
                    self.cropWidth = fabs(self.cropPointTopRight.x - self.trackingRectPointBottomLeft.x);
                    self.cropHeight = distanceHeight;
                    
                }
                
                if (pointTemp.x >= self.cropPointTopRight.x - self.cropSizeMin.width  && pointTemp.x < self.cropPointTopRight.x && pointTemp.y >  self.trackingRectPointBottomLeft.y) {
                    
                    self.croporiginX = fabs(self.cropPointTopRight.x - self.cropSizeMin.width);
                    self.cropWidth = self.cropSizeMin.width;
                    self.cropHeight = fabs(self.trackingRectPointBottomLeft.y - self.cropPointTopRight.y);
                }
                
                if ( pointTemp.x <= self.cropPointTopRight.x - self.cropSizeMin.width && pointTemp.x > self.trackingRectPointBottomLeft.x && pointTemp.y >  self.trackingRectPointBottomLeft.y) {
                    
                    
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
            
            if (newCropWidth < self.cropSizeMin.width || newCropHeight < self.cropSizeMin.height) {
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
            if (self.cropPointTopRight.y +newCropHeight <= self.cropPointTopRight.y +self.cropSizeMin.height  && self.cropPointTopRight.x +newCropWidth >= self.cropPointTopRight.x - self.cropSizeMin.width) {

                newCroporiginX = self.cropPointTopRight.x - self.cropSizeMin.width;
                newCropWidth = self.cropSizeMin.width;

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
                
                if (pointTemp.x < (self.cropPointTopLeft.x + self.cropSizeMin.width) && pointTemp.y > self.cropPointTopLeft.y + self.cropSizeMin.height ) {
                    
                    self.cropWidth = self.cropSizeMin.width;
                    self.cropHeight = distanceHeight;
                    
                }
                
                if (pointTemp.x > (self.cropPointTopLeft.x + self.cropSizeMin.width) && pointTemp.y < self.cropPointTopLeft.y + self.cropSizeMin.height ) {
                    
                    self.cropWidth = distanceWidth;
                    self.cropHeight = self.cropSizeMin.height;
                }
                
                if (pointTemp.x >= (self.cropPointTopLeft.x + self.cropSizeMin.width) && pointTemp.y >= self.cropPointTopLeft.y + self.cropSizeMin.height) {
                    self.cropWidth = distanceWidth;
                    self.cropHeight = distanceHeight;
                }
            }else{
              
                if (pointTemp.x >=  self.trackingRectPointBottomRight.x && pointTemp.y <= self.cropPointTopLeft.y + self.cropSizeMin.height) {
                    NSLog(@"------->0");
                    self.cropWidth = fabs(self.trackingRectPointBottomRight.x - self.cropPointTopLeft.x);
                    self.cropHeight = self.cropSizeMin.height;
                }
                
                
                if (pointTemp.x >=  self.trackingRectPointBottomRight.x && pointTemp.y > self.cropPointTopLeft.y + self.cropSizeMin.height && pointTemp.y < self.trackingRectPointBottomRight.y) {
                    NSLog(@"------->1");
                    self.cropWidth = fabs(self.trackingRectPointBottomRight.x - self.cropPointTopLeft.x);
                    self.cropHeight = distanceHeight;
                }
                
                
                if (pointTemp.x >=  self.cropPointTopLeft.x && pointTemp.x <= self.cropPointTopLeft.x + self.cropSizeMin.width && pointTemp.y >= self.trackingRectPointBottomRight.y) {
                    NSLog(@"------->2");
                    self.cropWidth = self.cropSizeMin.width;
                    self.cropHeight = fabs(self.trackingRectPointBottomRight.y - self.cropPointTopLeft.y);
                }
                
                
                if (pointTemp.x >=  self.cropPointTopLeft.x + self.cropSizeMin.width  && pointTemp.x <= self.trackingRectPointBottomRight.x &&
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
                
                if (pointTemp.x <= self.cropPointTopLeft.x + self.cropSizeMin.width && pointTemp.y <= self.cropPointTopLeft.y + self.cropSizeMin.height) {
                    
                    self.cropWidth = self.cropSizeMin.width;
                    self.cropHeight = self.cropSizeMin.height;
                    
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
            
            if (newCropWidth < self.cropSizeMin.width || newCropHeight < self.cropSizeMin.height) {
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
            if (self.cropPointTopLeft.x +newCropWidth <= self.cropPointTopLeft.x + self.cropSizeMin.width  && self.cropPointTopLeft.y +newCropHeight <= self.cropPointTopLeft.y + self.cropSizeMin.height) {
                newCropWidth = self.cropSizeMin.width;

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
    [self needsUpdateCropPoints];
    
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
    }
    [self needsUpdateCropPoints];
    
   
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
        [_topTrackButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _topTrackButton;

}

-(VETrackButton *)bottomTrackButton{
    if (_bottomTrackButton == nil) {
        _bottomTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX + (self.cropWidth - VE_TRACK_HEIGHT)/2, self.croporiginY +self.cropHeight, VE_TRACK_HEIGHT, VE_TRACK_WIDTH) withCropViewTrackType:VE_TRACK_BOTTOM];
        [_bottomTrackButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _bottomTrackButton;
}

-(VETrackButton *)leftTrackButton{
    if (_leftTrackButton == nil) {
        _leftTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX -VE_TRACK_WIDTH, self.croporiginY + (self.cropHeight-VE_TRACK_HEIGHT)/2, VE_TRACK_WIDTH, VE_TRACK_HEIGHT) withCropViewTrackType:VE_TRACK_LEFT];
        [_leftTrackButton setBackgroundColor:[UIColor whiteColor]];
    }
    return _leftTrackButton;
}

-(VETrackButton *)rightTrackButton{
    if (_rightTrackButton == nil) {
        _rightTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX + self.cropWidth, self.croporiginY + (self.cropHeight-VE_TRACK_HEIGHT)/2, VE_TRACK_WIDTH, VE_TRACK_HEIGHT) withCropViewTrackType:VE_TRACK_RIGHT];
        [_rightTrackButton setBackgroundColor:Color(255, 255, 255, 1)];
    }
    return _rightTrackButton;
}

-(VETrackButton *)topLeftTrackButton{
    if (_topLeftTrackButton == nil) {
        if ((self.videoCropType == VEVideoCropType_Crop)
            || (VEVideoCropType_FixedCrop == self.videoCropType )) {
            _topLeftTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX -VE_TRACK_WIDTH, self.croporiginY - VE_TRACK_WIDTH, VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH , VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH) withCropViewTrackType:VE_TRACK_TOPLEFT];
            [_topLeftTrackButton setBackgroundColor:Color(255, 255, 255, 1)];
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
            [_topRightTrackButton setBackgroundColor:Color(255, 255, 255, 1)];
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
        [_bottomLeftTrackButton setBackgroundColor:Color(255, 255, 255, 1)];
    }
    return _bottomLeftTrackButton;
}

-(VETrackButton *)bottomRightTrackButton{
    
    if (_bottomRightTrackButton == nil) {
        if ((self.videoCropType == VEVideoCropType_Crop)
            || (VEVideoCropType_FixedCrop == self.videoCropType )) {
            _bottomRightTrackButton = [[VETrackButton alloc] initWithFrame:CGRectMake(self.croporiginX+self.cropWidth -VE_TRACK_HEIGHT*1/2, self.croporiginY+self.cropHeight -VE_TRACK_HEIGHT*1/2, VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH , VE_TRACK_HEIGHT*1/2 +VE_TRACK_WIDTH) withCropViewTrackType:VE_TRACK_BOTTOMRIGHT];
            [_bottomRightTrackButton setBackgroundColor:Color(255, 255, 255, 1)];
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

@end

