//
//  VECutVideoRangeSlider.m
//  VEENUMCONFIGER
//
//  Created by MAC_RD on 2024/6/13.
//

#import "VECutVideoRangeSlider.h"
#import "VEHelp.h"
#import "VECutVideoRangeSlider.h"
@implementation UIHitView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;  // 如果点击的是当前视图，则返回nil，使得事件能够传递到下一层视图
    }
    return view;
}

@end

@interface VECutVideoRangeSlider ()<UIScrollViewDelegate,VECoreDelegate>

@property (nonatomic, assign) CGFloat thumbInitialX;
@property (nonatomic, assign) CGFloat leftThumbInitialX;
@property (nonatomic, assign) CGFloat rightThumbInitialX;

@end

@implementation VECutVideoRangeSlider
- (void)statusChanged:(VECore *)sender status:(VECoreStatus)status{
    if(status == kVECoreStatusReadyToPlay){
        [self loadThumbView];
        [self updateRangeView];
    }
}
- (void)dealloc{
    self.corePlayer = nil;
}
-(void)initThumbCore:(VECore *)sender{
    
    
    self.corePlayer = [[VECore alloc] initWithAPPKey:[VEConfigManager sharedManager].appKey
                                      APPSecret:[VEConfigManager sharedManager].appSecret
                                     LicenceKey:[VEConfigManager sharedManager].licenceKey
                                      videoSize:[sender getEditorVideoSize]
                                            fps:kEXPORTFPS
                                     resultFail:^(NSError *error) {
                                         NSLog(@"initSDKError:%@", error.localizedDescription);
                                     }];
//    veCorePlayer.frame = CGRectMake(0, kNavigationBarHeight, kWIDTH, kPlayerViewHeight);
    self.corePlayer .frame = sender.frame;
    self.corePlayer .delegate = self;
    VEExportConfiguration *exportConfig = [VEConfigManager sharedManager].exportConfiguration;
    [self.corePlayer setScenes:[sender getScenes]];
    [self.corePlayer setOverlayArray:[sender overlayArray]];
    self.corePlayer.delegate = self;
    [self.corePlayer build];
    
}
- (instancetype)initWithFrame:(CGRect)frame player:(VECore *)player minRangeDuration:(float)minRangeDuration maxRangeDuration:(float)maxRangeDuration {
    return [self initWithFrame:frame player:player minRangeDuration:minRangeDuration maxRangeDuration:maxRangeDuration thumbImage:nil];
}
- (instancetype)initWithFrame:(CGRect)frame player:(VECore *)player minRangeDuration:(float)minRangeDuration maxRangeDuration:(float)maxRangeDuration thumbImage:(UIImage *)thumbImage{
    self = [super initWithFrame:frame];
    if (self) {
//        self.corePlayer = [[VECore alloc] initWithAPPKey:[VEConfigManager sharedManager].appKey APPSecret:[VEConfigManager sharedManager].appSecret videoSize:[player getEditorVideoSize] fps:24 resultFail:^(NSError *error) {
//            
//        }];
        _thumbImage = thumbImage;
        [self initThumbCore:player];
        self.videoDuration = player.duration;
        self.minRangeDuration = minRangeDuration;
        self.maxRangeDuration = maxRangeDuration;
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 30, 0, 30);
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        // 创建左侧和右侧半透明遮罩
        self.leftThumbView = [[UIHitView alloc] initWithFrame:CGRectMake(0, 0, 30, frame.size.height)];
        self.leftThumbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.leftThumbView];
        
        self.rightThumbView = [[UIHitView alloc] initWithFrame:CGRectMake(frame.size.width - 30, 0, 30, frame.size.height)];
        self.rightThumbView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self addSubview:self.rightThumbView];
        
        // 创建左侧和右侧的拖动手柄
        self.leftHandle = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftThumbView.frame) - 20, 0, 20, frame.size.height)];
        self.leftHandle.backgroundColor = [UIColor whiteColor];
        self.leftHandle.layer.masksToBounds = YES;
        self.leftHandle.layer.cornerRadius = 5;
        self.leftHandle.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMinXMaxYCorner;
        [self addSubview:self.leftHandle];
        {
            UIHitView *imageView = [[UIHitView alloc] initWithFrame:CGRectMake((self.leftHandle.frame.size.width - 4)/2.0, 4, 4, self.leftHandle.frame.size.height - 8)];
            imageView.backgroundColor = [UIColorFromRGB(0x272727) colorWithAlphaComponent:0.9];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 2;
            [self.leftHandle addSubview:imageView];
        }
        
        self.rightHandle = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.rightThumbView.frame), 0, 20, frame.size.height)];
        self.rightHandle.backgroundColor = [UIColor whiteColor];
        self.rightHandle.layer.masksToBounds = YES;
        self.rightHandle.layer.cornerRadius = 5;
        self.rightHandle.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
        [self addSubview:self.rightHandle];
        {
            UIHitView *imageView = [[UIHitView alloc] initWithFrame:CGRectMake((self.rightHandle.frame.size.width - 4)/2.0, 4, 4, self.rightHandle.frame.size.height - 8)];
            imageView.backgroundColor = [UIColorFromRGB(0x272727) colorWithAlphaComponent:0.9];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 2;
            [self.rightHandle addSubview:imageView];
        }
        
        // 创建视频范围视图
        self.rangeView = [[UIHitView alloc] initWithFrame:CGRectMake(self.leftThumbView.frame.origin.x + self.leftThumbView.frame.size.width, 0, self.rightThumbView.frame.origin.x - self.leftThumbView.frame.origin.x - self.leftThumbView.frame.size.width, frame.size.height)];
        self.rangeView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.0]; // 半透明绿色
        self.rangeView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        self.rangeView.layer.borderWidth = 1;
        [self addSubview:self.rangeView];
        
        
        self.trimTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.rangeView.frame) - 16, 46, 15)];
        self.trimTimeLabel.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.8];
        self.trimTimeLabel.textColor = UIColorFromRGB(0xffffff);
        self.trimTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.trimTimeLabel.font = [UIFont systemFontOfSize:10];
        self.trimTimeLabel.layer.cornerRadius = 4;
        self.trimTimeLabel.layer.masksToBounds = YES;
        [self.rangeView addSubview:self.trimTimeLabel];
        
        self.thumbHandle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 26, self.rangeView.frame.size.height)];
        self.thumbHandle.backgroundColor = [UIColor clearColor];
        [self.rangeView addSubview:self.thumbHandle];
        self.thumbHandle.hidden = NO;
        
        
        self.thumbMaskHandle = [[UIView alloc] initWithFrame:CGRectMake(12, -2, 2, self.rangeView.frame.size.height + 4)];
        self.thumbMaskHandle.backgroundColor = [UIColor whiteColor];
        self.thumbMaskHandle.layer.cornerRadius = 1;
        self.thumbMaskHandle.layer.masksToBounds = YES;
        //self.thumbMaskHandle.layer.maskedCorners = kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner | kCALayerMaxXMinYCorner | kCALayerMaxXMaxYCorner;
        [self.thumbHandle addSubview:self.thumbMaskHandle];
        UIImageView *thumbImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.thumbHandle.frame) - 26)/2.0, 26, 26)];
        thumbImage.backgroundColor = [UIColor clearColor];
        thumbImage.image = [VEHelp imageNamed:@"拖动轨道"];
        [self.thumbHandle addSubview:thumbImage];
        
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleProgressThumbPan:)];
        [self.thumbHandle addGestureRecognizer:panGesture];
        
        // 添加手势识别器
        UIPanGestureRecognizer *leftPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftThumbPan:)];
        [self.leftHandle addGestureRecognizer:leftPanGesture];
        
        UIPanGestureRecognizer *rightPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightThumbPan:)];
        [self.rightHandle addGestureRecognizer:rightPanGesture];
        if(_thumbImage){
            [self loadThumbView];
        }
        
    }
    return self;
}

- (void)loadThumbView{
    float rangeDuration = self.maxRangeDuration;
    float rangeArea = self.scrollView.frame.size.width - (self.scrollView.contentInset.left + self.scrollView.contentInset.right);
    float contentWidth = rangeArea / rangeDuration * self.videoDuration;
    int count = ceil(contentWidth / self.scrollView.frame.size.height);
    float w_item = (contentWidth / self.scrollView.frame.size.height) - floorf(contentWidth / self.scrollView.frame.size.height);
    
    NSMutableArray *items = [NSMutableArray new];
    CMTime actualTime = kCMTimeZero;
    UIImage *firstImage = nil;
    if(_thumbImage){
        firstImage = _thumbImage;
    }
    else{
        CGImageRef imageRef = [self.corePlayer copyCGImageAtTime:kCMTimeZero actualTime:&actualTime maximumSize:CGSizeMake(200, 200) error:nil];
        if(imageRef){
            firstImage = [UIImage imageWithCGImage:imageRef];
        }
    }
    
    for (int i = 0; i<count; i++) {
        float itemTime = self.videoDuration / count * i;
        //if(i > 0)
        {
            [items addObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(itemTime, TIMESCALE)]];
        }
        NSInteger tag = i+1;
        UIImageView *itemView = [self.scrollView viewWithTag:tag];
        if(!itemView)
            itemView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.height * i,0,self.scrollView.frame.size.height, self.scrollView.frame.size.height)];
        if(i == count - 1){
            itemView.frame = CGRectMake(self.scrollView.frame.size.height * i,0,self.scrollView.frame.size.height * w_item, self.scrollView.frame.size.height);
        }
        if(i % 2 ==0)
            itemView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        else
            itemView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        itemView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
        itemView.layer.borderWidth = 0;
        itemView.contentMode = UIViewContentModeScaleAspectFill;
        itemView.layer.masksToBounds = YES;
        itemView.tag = tag;
        if(firstImage){
            itemView.image = firstImage;
        }
        [self.scrollView addSubview:itemView];
        
    }
    
    __block NSInteger index = 0;
    [self.corePlayer generateCGImagesAsynchronouslyForTimes:items maximumSize:CGSizeMake(200, 200) completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        index ++;
        UIImage *newImage = [UIImage imageWithCGImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(newImage){
                ((UIImageView *)[self.scrollView viewWithTag:index]).image = newImage;
            }
        });
    }];
    self.scrollView.contentSize = CGSizeMake(contentWidth, self.scrollView.frame.size.height);
}

- (void)handleProgressThumbPan:(UIPanGestureRecognizer *)gesture{
    CGPoint translation = [gesture translationInView:self.rangeView];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.thumbInitialX = self.thumbHandle.frame.origin.x;
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat newX = MAX(self.thumbInitialX + translation.x,-10);
            CGFloat maxAllowedX = CGRectGetWidth(self.rangeView.frame) - self.thumbHandle.frame.size.width + 10;
            if (newX >= -10 && newX <= maxAllowedX) {
                self.thumbHandle.frame = CGRectMake(newX, self.thumbHandle.frame.origin.y, self.thumbHandle.frame.size.width, self.thumbHandle.frame.size.height);
            }
            break;
        }
        default:
            break;
    }
    _progress = self.thumbHandle.center.x/self.rangeView.frame.size.width;
    if([_delegate respondsToSelector:@selector(rangeSliderChange:progress:)]){
        [_delegate rangeSliderChange:self progress:_progress];
    }
    //self.thumbHandle.hidden = YES;
}

- (void)handleLeftThumbPan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.leftThumbInitialX = self.leftHandle.frame.origin.x;
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat newX = MAX(self.leftThumbInitialX + translation.x,10);
            CGFloat maxAllowedX = CGRectGetMinX(self.rightHandle.frame) - self.leftHandle.frame.size.width;
            if (newX >= 0 && newX <= maxAllowedX) {
                self.leftHandle.frame = CGRectMake(newX, self.leftHandle.frame.origin.y, self.leftHandle.frame.size.width, self.leftHandle.frame.size.height);
                [self updateRangeView];
            }
            break;
        }
        default:
            break;
    }
}

- (void)handleRightThumbPan:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.rightThumbInitialX = self.rightHandle.frame.origin.x;
            break;
        case UIGestureRecognizerStateChanged: {
            CGFloat newX = MIN(self.rightThumbInitialX + translation.x,self.scrollView.frame.size.width - self.rightHandle.frame.size.width - 10);
            CGFloat minAllowedX = CGRectGetMaxX(self.leftHandle.frame);
            if (newX >= minAllowedX && newX <= self.scrollView.frame.size.width - self.rightHandle.frame.size.width) {
                self.rightHandle.frame = CGRectMake(newX, self.rightHandle.frame.origin.y, self.rightHandle.frame.size.width, self.rightHandle.frame.size.height);
                [self updateRangeView];
            }
            break;
        }
        default:
            break;
    }
    self.thumbHandle.hidden = YES;
}

- (void)updateRangeView {
    CGFloat rangeX = CGRectGetMaxX(self.leftHandle.frame);
    CGFloat rangeWidth = CGRectGetMinX(self.rightHandle.frame) - rangeX;
    self.rangeView.frame = CGRectMake(rangeX, self.rangeView.frame.origin.y, rangeWidth, self.rangeView.frame.size.height);
    self.leftThumbView.frame = CGRectMake(0, self.leftThumbView.frame.origin.y, CGRectGetMinX(self.rangeView.frame), self.leftThumbView.frame.size.height);
    self.rightThumbView.frame = CGRectMake(CGRectGetMaxX(self.rangeView.frame), self.rightThumbView.frame.origin.y, self.frame.size.width - CGRectGetMaxX(self.rangeView.frame), self.rightThumbView.frame.size.height);
    
    float x = self.scrollView.contentOffset.x + self.leftThumbView.frame.size.width;
    _startTime =  (x/self.scrollView.contentSize.width) * self.videoDuration;
    _durationTime =  ((CGRectGetMinX(self.rightThumbView.frame) - CGRectGetMaxX(self.leftThumbView.frame))/self.scrollView.contentSize.width) * self.videoDuration;
    NSLog(@"start:%f    duration:%f",_startTime,_durationTime);
    if([_delegate respondsToSelector:@selector(rangeSliderChange:start:duration:progress:)]){
        [_delegate rangeSliderChange:self start:_startTime duration:_durationTime progress:_progress];
    }
    self.trimTimeLabel.text = [VEHelp timeFormat:_durationTime];
    CGRect rect = self.thumbHandle.frame;
    rect.origin.x = -10;
    self.thumbHandle.frame = rect;
    
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    float startProgress = self.startTime/ self.videoDuration;
    float x = _progress - startProgress - 10;
    
    //float maxProgress = (self.startTime + self.durationTime)/self.videoDuration;
    float off_x = (self.rangeView.frame.size.width/self.durationTime) * (x * self.videoDuration);
    NSLog(@"off_x:%f",off_x);
    CGRect rect = self.thumbHandle.frame;
    rect.origin.x = MAX(off_x, -10);
    self.thumbHandle.frame = rect;
    self.thumbHandle.hidden = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float x = self.scrollView.contentOffset.x + self.leftThumbView.frame.size.width;
    _startTime =  (x/self.scrollView.contentSize.width) * self.videoDuration;
    _durationTime =  ((CGRectGetMinX(self.rightThumbView.frame) - CGRectGetMaxX(self.leftThumbView.frame))/self.scrollView.contentSize.width) * self.videoDuration;
    NSLog(@"start:%f    duration:%f",_startTime,_durationTime);
    if([_delegate respondsToSelector:@selector(rangeSliderChange:start:duration:progress:)]){
        [_delegate rangeSliderChange:self start:_startTime duration:_durationTime progress:_progress];
    }
    self.trimTimeLabel.text = [VEHelp timeFormat:_durationTime];
}
@end


