//
//  VETTRangeSlider.m
//
//  Created by iOS VESDK Team

#import "VETTRangeSlider.h"
#import "VEHelp.h"
//原始 -30
const int VE_HANDLE_TOUCH_AREA_EXPANSION = -30; //expand the touch area of the handle by this much (negative values increase size) so that you don't have to touch right on the handle to activate it.
const float VE_HANDLE_DIAMETER = 20;
const float VE_TEXT_HEIGHT = 14;

@interface VETTRangeSlider (){
    bool  isUpdateSlider;
    
    CGPoint _startCenter;
    CGPoint _startCenter_leftHandle;
    CGPoint _startCenter_rightHandle;
    
    BOOL    isFristTracking;
    float   fTrackingX;
    
    bool isCollageSilder;
    float startTouchPositionX;
    
    NSTimer *startMoveTime;
    UITouch *startMoveTouch;
    BOOL      _isLeft;
    BOOL      _isRight;
    BOOL      _isMiddle;
}

@property (nonatomic, strong) CALayer *sliderLine;

@property (nonatomic, strong) CATextLayer *minLabel;
@property (nonatomic, strong) CATextLayer *maxLabel;

@property (nonatomic, strong) NSNumberFormatter *decimalNumberFormatter; // Used to format values if formatType is YLRangeSliderFormatTypeDecimal
@end

static const CGFloat kLabelsFontSize = 12.0f;

@implementation VETTRangeSlider

//do all the setup in a common place, as there can be two initialisers called depending on if storyboards or code are used. The designated initialiser isn't always called :|
- (void)initialiseControl {
    //defaults:
    _minValue = 0;
    _selectedMinimum = 10;
    _maxValue = 100;
    _selectedMaximum  = 90;

    _minDistance = -1;
    _maxDistance = -1;

    _enableStep = NO;
    _step = 0.1f;
    _isDragDisable = NO;
    isFristTracking = true;
    //draw the slider line
    self.sliderLine = [CALayer layer];
    self.sliderLine.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.sliderLine];
    
    _holdDragRecognizer = [[VEDragGestureRecognizer alloc] init];
    _holdDragRecognizer.minimumPressDuration = 1.0;
    [_holdDragRecognizer addTarget:self action:@selector(dragRecognized:)];
    
    _moveCaptionViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moveCaptionViewBtn.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.0 alpha:0.8];//test
    [_moveCaptionViewBtn addGestureRecognizer:_holdDragRecognizer];
    _moveCaptionViewBtn.hidden = YES;
    [self addSubview:_moveCaptionViewBtn];
    
    //draw the minimum slider handle
    _leftHandle = [CALayer layer];
    _leftHandle.cornerRadius = 2.0f;
    [self.layer addSublayer:_leftHandle];

    //draw the maximum slider handle
    _rightHandle = [CALayer layer];
    _rightHandle.cornerRadius = 2.0f;
    [self.layer addSublayer:_rightHandle];
    float handWidth = ([VEConfigManager sharedManager].editConfiguration.isSingletrack == true ? 14 : VE_HANDLE_DIAMETER);
    if(CGRectGetHeight(self.frame)> 40){
        handWidth = VE_HANDLE_DIAMETER;
    }
    _leftHandle.frame = CGRectMake(20 - handWidth, 0, handWidth, self.frame.size.height);
    _rightHandle.frame = CGRectMake(0, 0, handWidth, self.frame.size.height);
    
    _leftLabel = [[UIImageView alloc] initWithFrame:CGRectMake(20 - handWidth, 0, handWidth, self.frame.size.height)];
    _leftLabel.image =  [VEHelp imageNamed:@"New_EditVideo/剪辑-截取_把手默认_"];
    _leftLabel.highlightedImage =  [VEHelp imageNamed:@"New_EditVideo/剪辑-截取_把手选中_"];
    _leftLabel.hidden = YES;
    [self addSubview:_leftLabel];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClick:)];
    [self addGestureRecognizer:tapGesture];
    
    _rightLabel = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, handWidth, self.frame.size.height)];
    _rightLabel.image =  [VEHelp imageNamed:[VEConfigManager sharedManager].iPad_HD ? @"/ipad/剪辑-剪辑-把手_左默认_" : @"New_EditVideo/剪辑-剪辑-把手_左默认_"];
    _rightLabel.highlightedImage =  [VEHelp imageNamed:[VEConfigManager sharedManager].iPad_HD ? @"/ipad/剪辑-剪辑-把手_右默认_" : @"New_EditVideo/剪辑-剪辑-把手_右默认_"];
    _rightLabel.hidden = YES;
    [self addSubview:_rightLabel];
    
    _leftLayer = [CALayer layer];
    _leftLayer.backgroundColor = [UIColor clearColor].CGColor;
    _leftLayer.frame = CGRectMake(0, 0, handWidth, self.frame.size.height);
    _leftLayer.contents = (id)[VEHelp imageNamed:[VEConfigManager sharedManager].iPad_HD ? @"/ipad/剪辑-剪辑-把手_左默认_" : @"New_EditVideo/剪辑-剪辑-把手_左默认_"].CGImage;
    _leftLayer.hidden = YES;

    _leftHightedLayer = [CALayer layer];
    _leftHightedLayer.backgroundColor = [UIColor clearColor].CGColor;
    _leftHightedLayer.frame = CGRectMake(0, 0, handWidth, self.frame.size.height);
    _leftHightedLayer.contents = (id)[VEHelp imageNamed:[VEConfigManager sharedManager].iPad_HD ? @"/ipad/剪辑-剪辑-把手_左默认_" : @"New_EditVideo/剪辑-剪辑-把手_左默认_"].CGImage;
    _leftHightedLayer.hidden = YES;
    [_leftHandle addSublayer:_leftLayer];

    _rightLayer = [CALayer layer];
    _rightLayer.backgroundColor = [UIColor clearColor].CGColor;
    _rightLayer.frame = _rightHandle.bounds;
    _rightLayer.frame = CGRectMake(0, 0, handWidth, self.frame.size.height);
    _rightLayer.contents = (id)[VEHelp imageNamed:[VEConfigManager sharedManager].iPad_HD ? @"/ipad/剪辑-剪辑-把手_右默认_" : @"New_EditVideo/剪辑-剪辑-把手_右默认_"].CGImage;
    _rightLayer.hidden = YES;

    _rightHightedLayer = [CALayer layer];
    _rightHightedLayer.backgroundColor = [UIColor clearColor].CGColor;
    _rightHightedLayer.frame = CGRectMake(0, 0, handWidth, self.frame.size.height);
    _rightHightedLayer.contents = (id)[VEHelp imageNamed:[VEConfigManager sharedManager].iPad_HD ? @"/ipad/剪辑-剪辑-把手_右默认_" : @"New_EditVideo/剪辑-剪辑-把手_右默认_"].CGImage;
    _rightHightedLayer.hidden = YES;
    [_rightHandle addSublayer:_rightLayer];
    
    //draw the text labels
    _minLabel = [[CATextLayer alloc] init];
    _minLabel.alignmentMode = kCAAlignmentCenter;
    _minLabel.fontSize = kLabelsFontSize;
    _minLabel.frame = CGRectMake(0, 0, 75, VE_TEXT_HEIGHT);
    _minLabel.contentsScale = [UIScreen mainScreen].scale;
    _minLabel.contentsScale = [UIScreen mainScreen].scale;
    if (_minLabelColour == nil){
        _minLabel.foregroundColor = self.tintColor.CGColor;
    } else {
        _minLabel.foregroundColor = _minLabelColour.CGColor;
    }
//    [self.layer addSublayer:_minLabel];

    _maxLabel = [[CATextLayer alloc] init];
    _maxLabel.alignmentMode = kCAAlignmentCenter;
    _maxLabel.fontSize = kLabelsFontSize;
    _maxLabel.frame = CGRectMake(0, 0, 75, VE_TEXT_HEIGHT);
    _maxLabel.contentsScale = [UIScreen mainScreen].scale;
    if (_maxLabelColour == nil){
        _maxLabel.foregroundColor = self.tintColor.CGColor;
    } else {
        _maxLabel.foregroundColor = _maxLabelColour.CGColor;
    }
//    [self.layer addSublayer:_maxLabel];

    [self refresh];
}

- (void)handleClick:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self];
    //遍历当前视图上的子视图的presentationLayer 与点击的点是否有交集
    for (CALayer *subLayer in self.layer.sublayers) {
        if ([subLayer.presentationLayer hitTest:touchPoint] && (subLayer == _leftHandle || subLayer == _rightHandle)) {
            if (_delegate && [_delegate respondsToSelector:@selector(tapHandler:)]) {
                [_delegate tapHandler:(subLayer == _leftHandle)];
            }
            break;
        }
    }
}

- (void)dragRecognized:(VEDragGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            // When the gesture starts, remember the current position, and animate the it.
            _startCenter = _moveCaptionViewBtn.center;
            _startCenter_leftHandle = _leftHandle.position;
            _startCenter_rightHandle = _rightHandle.position;
            
            if(_delegate){
                if([_delegate respondsToSelector:@selector(startMove:)]){
                    [_delegate startMove:nil];
                }
            }
            
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            // During the gesture, we just add the gesture's translation to the saved original position.
            // The translation will account for the changes in contentOffset caused by auto-scrolling.
            CGPoint translation = [recognizer translationInView:self];
            CGPoint center = CGPointMake(_startCenter.x + translation.x, _startCenter.y);
            
            CGSize locationSize = [_delegate getLeftPointAndRightPoint];
            if ((center.x >= _moveCaptionViewBtn.frame.size.width/2.0 + 40)
                && (center.x <= (locationSize.height + _leftLabel.frame.size.width - _moveCaptionViewBtn.frame.size.width/2.0 - 5/2.0))) {
                _moveCaptionViewBtn.center = center;
                
                float percentage_left = ((_startCenter_leftHandle.x + translation.x - CGRectGetMinX(self.sliderLine.frame)) - _leftLabel.frame.size.width/2) / (CGRectGetMaxX(self.sliderLine.frame) - CGRectGetMinX(self.sliderLine.frame));
                float percentage_right = ((_startCenter_rightHandle.x + translation.x - CGRectGetMinX(self.sliderLine.frame)) - _leftLabel.frame.size.width/2) / (CGRectGetMaxX(self.sliderLine.frame) - CGRectGetMinX(self.sliderLine.frame));
                
                _selectedMinimum = percentage_left * (self.maxValue - self.minValue) + self.minValue;
                _selectedMaximum = percentage_right * (self.maxValue - self.minValue) + self.minValue;
                if (_selectedMinimum < 0) {
                    _selectedMaximum -= _selectedMinimum;
                    _selectedMinimum = 0;
                }
                [CATransaction begin];
                [CATransaction setDisableActions:YES] ;
                [self updateHandlePositions];
                [self updateLabelPositions];
                [CATransaction commit];
                [self updateLabelValues];
                
                if(_delegate){
                    if ([_delegate respondsToSelector:@selector(rangeSlider:didChangeSelectedMinimumValue:andMaximumValue:isRight:)]){
                        [_delegate rangeSlider:self didChangeSelectedMinimumValue:self.selectedMinimum andMaximumValue:self.selectedMaximum isRight:(_leftHandleSelected)?false:true];
                    }
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if(_delegate){
                if([_delegate respondsToSelector:@selector(rangeSlider:didEndChangeSelectedMinimumValue:andMaximumValue:)]){
                    [_delegate rangeSlider:self didEndChangeSelectedMinimumValue:self.selectedMinimum andMaximumValue:self.selectedMaximum];
                }
                if([_delegate respondsToSelector:@selector(stopMove)]){
                    [_delegate stopMove];
                }
            }
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
 
    //positioning for the slider line
    float barSidePadding = _leftLabel.frame.size.width;
    CGRect currentFrame = self.frame;
    float yMiddle = currentFrame.size.height/2.0;
    CGPoint lineLeftSide = CGPointMake(barSidePadding, yMiddle);
    CGPoint lineRightSide = CGPointMake(currentFrame.size.width-barSidePadding, yMiddle);
    self.sliderLine.frame = CGRectMake(lineLeftSide.x, 0, lineRightSide.x-lineLeftSide.x, self.frame.size.height);

    [self updateHandlePositions];
    [self updateLabelPositions];
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if(self)
    {
        [self initialiseControl];
    }
    return self;
}

-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    if (self)
    {
        [self initialiseControl];
    }

    return self;
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(UIViewNoIntrinsicMetric, 65);
}


- (float)getPercentageAlongLineForValue:(float) value {
    if (self.minValue == self.maxValue){
        return 0; //stops divide by zero errors where maxMinDif would be zero. If the min and max are the same the percentage has no point.
    }

    //get the difference between the maximum and minimum values (e.g if max was 100, and min was 50, difference is 50)
    float maxMinDif = self.maxValue - self.minValue;

    //now subtract value from the minValue (e.g if value is 75, then 75-50 = 25)
    float valueSubtracted = value - self.minValue;

    //now divide valueSubtracted by maxMinDif to get the percentage (e.g 25/50 = 0.5)
    return valueSubtracted / maxMinDif;
}

- (float)getXPositionAlongLineForValue:(float) value {
    //first get the percentage along the line for the value
    float percentage = [self getPercentageAlongLineForValue:value];

    //get the difference between the maximum and minimum coordinate position x values (e.g if max was x = 310, and min was x=10, difference is 300)
    float maxMinDif = CGRectGetMaxX(self.sliderLine.frame) - CGRectGetMinX(self.sliderLine.frame);

    //now multiply the percentage by the minMaxDif to see how far along the line the point should be, and add it onto the minimum x position.
    float offset = percentage * maxMinDif;

    return CGRectGetMinX(self.sliderLine.frame) + offset;
}

- (void)updateLabelValues {
    if ([self.numberFormatterOverride isEqual:[NSNull null]]){
        _minLabel.string = @"";
        _maxLabel.string = @"";
        return;
    }

    NSNumberFormatter *formatter = (self.numberFormatterOverride != nil) ? self.numberFormatterOverride : self.decimalNumberFormatter;

    _minLabel.string = [formatter stringFromNumber:@(self.selectedMinimum)];
    _maxLabel.string = [formatter stringFromNumber:@(self.selectedMaximum)];
}

#pragma mark - Set Positions
- (void)updateHandlePositions {
    @try {
        CGPoint leftHandleCenter = CGPointMake([self getXPositionAlongLineForValue:self.selectedMinimum] - CGRectGetWidth(self.leftHandle.frame)/2.0, CGRectGetMidY(self.sliderLine.frame));
        if (leftHandleCenter.x<0) {
            leftHandleCenter.x = 0;
        }
        if(isnan(leftHandleCenter.x)){
            leftHandleCenter.x = 0;
        }
        _leftHandle.position = leftHandleCenter;
        self.leftLabel.frame = CGRectMake(leftHandleCenter.x - CGRectGetWidth(self.leftHandle.frame)/2.0, 0, self.leftLabel.frame.size.width, self.leftLabel.frame.size.height);
        CGPoint rightHandleCenter = CGPointMake([self getXPositionAlongLineForValue:self.selectedMaximum] + CGRectGetWidth(self.leftHandle.frame)/2.0 , CGRectGetMidY(self.sliderLine.frame));
        if(isnan(rightHandleCenter.x) || rightHandleCenter.x < 0){
            rightHandleCenter.x = 0;
        }
        _rightHandle.position= rightHandleCenter;
        self.rightLabel.frame = CGRectMake(rightHandleCenter.x - CGRectGetWidth(self.leftHandle.frame)/2.0, 0, self.rightLabel.frame.size.width, self.rightLabel.frame.size.height);
    }
    @catch (NSException *exception) {
        
    }
    
}

- (void)updateLabelPositions {
    //the centre points for the labels are X = the same x position as the relevant handle. Y = the y position of the handle minus half the height of the text label, minus some padding.
    int padding = 8;
    float minSpacingBetweenLabels = 8.0f;

    CGPoint leftHandleCentre = [self getCentreOfRect:_leftHandle.frame];
    CGPoint newMinLabelCenter = CGPointMake(leftHandleCentre.x, _leftHandle.frame.origin.y - (_minLabel.frame.size.height/2) - padding);

    CGPoint rightHandleCentre = [self getCentreOfRect:_rightHandle.frame];
    CGPoint newMaxLabelCenter = CGPointMake(rightHandleCentre.x, _rightHandle.frame.origin.y - (_maxLabel.frame.size.height/2) - padding);

    CGSize minLabelTextSize = [_minLabel.string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kLabelsFontSize]}];
    CGSize maxLabelTextSize = [_maxLabel.string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:kLabelsFontSize]}];

    float newLeftMostXInMaxLabel = newMaxLabelCenter.x - maxLabelTextSize.width/2;
    float newRightMostXInMinLabel = newMinLabelCenter.x + minLabelTextSize.width/2;
    float newSpacingBetweenTextLabels = newLeftMostXInMaxLabel - newRightMostXInMinLabel;

    if (self.disableRange || newSpacingBetweenTextLabels > minSpacingBetweenLabels) {
        _minLabel.position = newMinLabelCenter;
        _maxLabel.position = newMaxLabelCenter;
    }
    else {
        newMinLabelCenter = CGPointMake(_minLabel.position.x, _leftHandle.frame.origin.y - (_minLabel.frame.size.height/2) - padding);
        newMaxLabelCenter = CGPointMake(_maxLabel.position.x, _rightHandle.frame.origin.y - (_maxLabel.frame.size.height/2) - padding);
        _minLabel.position = newMinLabelCenter;
        _maxLabel.position = newMaxLabelCenter;

        //Update x if they are still in the original position
        if (_minLabel.position.x == _maxLabel.position.x && _leftHandle != nil) {
            _minLabel.position = CGPointMake(leftHandleCentre.x, _minLabel.position.y);
            _maxLabel.position = CGPointMake(leftHandleCentre.x + _minLabel.frame.size.width/2 + minSpacingBetweenLabels + _maxLabel.frame.size.width/2, _maxLabel.position.y);
        }
    }
}

-(void)startMove_Time
{
    if( !_isStartMove )
    {
        _isStartMove = true;
        
        
        if( _leftHandleSelected )
        {
            _leftLabel.highlighted = YES;
            
            [_rightHightedLayer removeFromSuperlayer];
            [_rightHandle addSublayer:_rightLayer];
            [_leftLayer removeFromSuperlayer];
            [_leftHandle addSublayer:_leftHightedLayer];
            [self animateHandle:_leftHandle withSelection:NO];
        }
        else{
            _rightLabel.highlighted = YES;
            
            [_leftHightedLayer removeFromSuperlayer];
            [_leftHandle addSublayer:_leftLayer];
            [_rightLayer removeFromSuperlayer];
            [_rightHandle addSublayer:_rightHightedLayer];
            [self animateHandle:_rightHandle withSelection:NO];
        }
        
        if(_delegate && [_delegate respondsToSelector:@selector(startMove:)]){
            [_delegate startMove:startMoveTouch];
        }
    }
}

#pragma mark - Touch Tracking

- (void)refresh {
    if (self.enableStep && self.step>=0.0f){
        _selectedMinimum = roundf(self.selectedMinimum/self.step)*self.step;
        _selectedMaximum = roundf(self.selectedMaximum/self.step)*self.step;
    }

    float diff = self.selectedMaximum - self.selectedMinimum;

    if (self.minDistance != -1 && diff < self.minDistance) {
        if(_leftHandleSelected){
            _selectedMinimum = self.selectedMaximum - self.minDistance;
        }else{
            _selectedMaximum = self.selectedMinimum + self.minDistance;
        }
    }else if(self.maxDistance != -1 && diff > self.maxDistance){

        if(_leftHandleSelected){
            _selectedMinimum = self.selectedMaximum - self.maxDistance;
        }else if(_rightHandleSelected){
            _selectedMaximum = self.selectedMinimum + self.maxDistance;
        }
    }

    //ensure the minimum and maximum selected values are within range. Access the values directly so we don't cause this refresh method to be called again (otherwise changing the properties causes a refresh)
    if (self.selectedMinimum < self.minValue){
        _selectedMinimum = self.minValue;
    }
    if (self.selectedMaximum > self.maxValue){
        _selectedMaximum = self.maxValue;
    }
    
    isCollageSilder = true;
    if( self.maxCollageValue > 0 )
    {
        if (self.selectedMinimum < self.minCollageValue){
            isCollageSilder = false;
            _selectedMinimum = self.minCollageValue;
        }
        if (self.selectedMaximum > self.maxCollageValue){
            _selectedMaximum = self.maxCollageValue;
            isCollageSilder = false;
        }
    }
    
    
    //update the frames in a transaction so that the tracking doesn't continue until the frame has moved.
    [CATransaction begin];
    [CATransaction setDisableActions:YES] ;
    [self updateHandlePositions];
    [self updateLabelPositions];
    [CATransaction commit];
    [self updateLabelValues];

    if( self.isSetSelected )
        return;
    
    //update the delegate
    if (_delegate && (_leftHandleSelected || _rightHandleSelected)){
        [_delegate rangeSlider:self didChangeSelectedMinimumValue:self.selectedMinimum andMaximumValue:self.selectedMaximum isRight:(_leftHandleSelected)?false:true];
    }
}

#if 1
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGRect lRect = self.leftHandle.frame;
    lRect.origin.x -= 5;
    lRect.size.width += 10;
    
    CGRect rRect = self.rightHandle.frame;
    rRect.origin.x -= 5;
    rRect.size.width += 10;
    
    if(CGRectContainsPoint(lRect, location)){
        _isLeft = YES;
        _isRight = NO;
        if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
            [_delegate touchesBegan:self isLeft:YES isRight:NO];
        }
    }else if(CGRectContainsPoint(rRect, location)){
        _isRight = YES;
        _isLeft = NO;
        if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
            [_delegate touchesBegan:self isLeft:NO isRight:YES];
        }
    }else{
        _isLeft = NO;
        _isRight = NO;
        _isMiddle = YES;
        if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
            [_delegate touchesBegan:self isLeft:NO isRight:NO];
        }
    }
    startTouchPositionX = location.x;
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if(!_isStartDrag){
        CGPoint location = [touch locationInView:self];
        if(fabs(startTouchPositionX - location.x) > 1.0){
            [self beginTrackingWithTouch:touch withEvent:event];
        }
    }else{
        [self continueTrackingWithTouch:touch withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    location.y = self.frame.size.height/2.0;
    CGRect lRect = self.leftHandle.frame;
    lRect.origin.x -= 5;
    lRect.size.width += 10;
    
    CGRect rRect = self.rightHandle.frame;
    rRect.origin.x -= 5;
    rRect.size.width += 10;
    if(_isStartDrag){
        [self endTrackingWithTouch:touch withEvent:event];
        if(CGRectContainsPoint(lRect, location)){
            if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
                [_delegate touchesBegan:self isLeft:YES isRight:NO];
            }
        }else if(CGRectContainsPoint(rRect, location)){
            if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
                [_delegate touchesBegan:self isLeft:NO isRight:YES];
            }
        }
    }else{
        if(CGRectContainsPoint(lRect, location)){
            if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
                [_delegate touchesBegan:self isLeft:YES isRight:NO];
            }
        }else if(CGRectContainsPoint(rRect, location)){
            if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
                [_delegate touchesBegan:self isLeft:NO isRight:YES];
            }
        }else{
            if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
                [_delegate touchesBegan:self isLeft:NO isRight:NO];
            }
        }
    }
    _isLeft = NO;
    _isRight = NO;
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    location.y = self.frame.size.height/2.0;
    CGRect lRect = self.leftHandle.frame;
    lRect.origin.x -= 5;
    lRect.size.width += 10;
    
    CGRect rRect = self.rightHandle.frame;
    rRect.origin.x -= 5;
    rRect.size.width += 10;
    if(_isStartDrag){
        [self cancelTrackingWithEvent:event];
        if(CGRectContainsPoint(lRect, location)){
            if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
                [_delegate touchesBegan:self isLeft:YES isRight:NO];
            }
        }else if(CGRectContainsPoint(rRect, location)){
            if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
                [_delegate touchesBegan:self isLeft:NO isRight:YES];
            }
        }
    }else{
        if(CGRectContainsPoint(lRect, location)){
            if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
                [_delegate touchesBegan:self isLeft:YES isRight:NO];
            }
        }else if(CGRectContainsPoint(rRect, location)){
            if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
                [_delegate touchesBegan:self isLeft:NO isRight:YES];
            }
        }else{
            if([_delegate respondsToSelector:@selector(touchesBegan:isLeft:isRight:)]){
                [_delegate touchesBegan:self isLeft:NO isRight:NO];
            }
        }
    }
    _isLeft = NO;
    _isRight = NO;
    
}
//#else

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if (_isDragDisable) {
        return NO;
    }
    CGPoint gesturePressLocation = [touch locationInView:self];
    startTouchPositionX = gesturePressLocation.x;
    _isStartMove = false;
    _isStartDrag = YES;
//    startMoveTime = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(startMove_Time) userInfo:nil repeats:YES];

    //if (CGRectContainsPoint(CGRectInset(_leftHandle.frame, VE_HANDLE_TOUCH_AREA_EXPANSION, VE_HANDLE_TOUCH_AREA_EXPANSION), gesturePressLocation) || CGRectContainsPoint(CGRectInset(_rightHandle.frame, VE_HANDLE_TOUCH_AREA_EXPANSION, VE_HANDLE_TOUCH_AREA_EXPANSION), gesturePressLocation))
    if(_isLeft || _isRight || _isMiddle)
    {
        //the touch was inside one of the handles so we're definitely going to start movign one of them. But the handles might be quite close to each other, so now we need to find out which handle the touch was closest too, and activate that one.
        float distanceFromLeftHandle = [self distanceBetweenPoint:gesturePressLocation andPoint:[self getCentreOfRect:_leftHandle.frame]];
        float distanceFromRightHandle =[self distanceBetweenPoint:gesturePressLocation andPoint:[self getCentreOfRect:_rightHandle.frame]];

        if(!_isMiddle){
            if (distanceFromLeftHandle < distanceFromRightHandle && !self.disableRange){
                _leftHandleSelected = YES;
    //            _leftLabel.highlighted = YES;
    //
    //            [_rightHightedLayer removeFromSuperlayer];
    //            [_rightHandle addSublayer:_rightLayer];
    //            [_leftLayer removeFromSuperlayer];
    //            [_leftHandle addSublayer:_leftHightedLayer];
    //            [self animateHandle:_leftHandle withSelection:NO];
            } else {
                if (self.selectedMaximum == self.maxValue && [self getCentreOfRect:_leftHandle.frame].x == [self getCentreOfRect:_rightHandle.frame].x) {
                    _leftHandleSelected = YES;
    //                _leftLabel.highlighted = YES;
    //
    //                [_rightHightedLayer removeFromSuperlayer];
    //                [_rightHandle addSublayer:_rightLayer];
    //                [_leftLayer removeFromSuperlayer];
    //                [_leftHandle addSublayer:_leftHightedLayer];
    //                [self animateHandle:_leftHandle withSelection:NO];
                }
                else {
                    _rightHandleSelected = YES;
    //                _rightLabel.highlighted = YES;
    //
    //                [_leftHightedLayer removeFromSuperlayer];
    //                [_leftHandle addSublayer:_leftLayer];
    //                [_rightLayer removeFromSuperlayer];
    //                [_rightHandle addSublayer:_rightHightedLayer];
    //                [self animateHandle:_rightHandle withSelection:NO];
                }
            }
        }
        startMoveTouch = touch;
        
        [self startMove_Time];
        
        return YES;
    } else {
        return NO;
    }
}

//#pragma mark - 拖拽调整
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if(!_isStartDrag){
        return NO;
    }
    CGPoint location = [touch locationInView:self];
    if ( (((location.x - 0.1) > startTouchPositionX) || ( (location.x + 0.1) < startTouchPositionX ) )  && (_isStartMove) ) {//拖动了才继续往下走
        
        //find out the percentage along the line we are in x coordinate terms (subtracting half the frames width to account for moving the middle of the handle, not the left hand side)
        //    float percentage = ((location.x-CGRectGetMinX(self.sliderLine.frame)) - VE_HANDLE_DIAMETER/2) / (CGRectGetMaxX(self.sliderLine.frame) - CGRectGetMinX(self.sliderLine.frame));
        
        float mainPercentage = fTrackingX/(CGRectGetMaxX(self.sliderLine.frame) - CGRectGetMinX(self.sliderLine.frame));
        
            CGSize locationSize = [_delegate getLeftPointAndRightPoint];
            if(_leftHandleSelected){
                
                if(location.x < locationSize.width){
                    location.x = locationSize.width;
                }else if(location.x > (locationSize.height)){
                    location.x = locationSize.height;
                }
            }
            else
            {
                if(location.x < locationSize.width + 35){
                    location.x = locationSize.width + 35;
                }else if(location.x > (locationSize.height + 35)){
                    location.x = locationSize.height + 35;
                }
            }
            
            if( isFristTracking )
            {
                isFristTracking = false;
                if(_leftHandleSelected)
                {
                    fTrackingX = _leftHandle.bounds.size.width/2.0 -  [self convertPoint:location toView:self.leftLabel].x;
                    
                }
                else
                {
                    fTrackingX =  _rightHandle.bounds.size.width/2.0 -  [self convertPoint:location toView:self.rightLabel].x;
                    
                }
            }
            if(_leftHandleSelected){
                if(location.x > _rightHandle.frame.origin.x - 11){
                    location.x = _rightHandle.frame.origin.x - 11;
                }
            }
            if(_rightHandleSelected){
                if(location.x < _leftHandle.frame.origin.x + _leftHandle.frame.size.width + 12 ){
                    location.x = _leftHandle.frame.origin.x + _leftHandle.frame.size.width + 12;
                }
            }
            float percentage = (location.x - 25 + 3 + fTrackingX)/ (CGRectGetMaxX(self.sliderLine.frame) - CGRectGetMinX(self.sliderLine.frame));//20180612 修改bug:在视频最后几秒添加字幕后，再次编辑时，拖动右把手时不能拖动到视频的最后
            //
            if(_leftHandleSelected){
                percentage = (location.x - 8  + fTrackingX)/ (CGRectGetMaxX(self.sliderLine.frame) - CGRectGetMinX(self.sliderLine.frame));//20180612 修改bug:在视频最后几秒添加字幕后，再次编辑时，拖动右把手时不能拖动到视频的最后
            }
            if( percentage > 1.0 )
            {
                percentage = 1.0;
            }
            
            //multiply that percentage by self.maxValue to get the new selected minimum value
            float selectedValue = percentage * (self.maxValue - self.minValue) + self.minValue;
            
            mainPercentage = mainPercentage * (self.maxValue - self.minValue) + self.minValue;
            
            if( _rightHandleSelected )
            {
                if( mainPercentage > 0 )
                    mainPercentage = 0;
            }
            else
            {
                if( mainPercentage < 0 )
                    mainPercentage = 0;
            }
            
            
            bool isLeft = true;
            bool isIsSlide = false;
            
            if (_leftHandleSelected)
            {
                if ( (selectedValue - mainPercentage ) < (self.selectedMaximum - mainPercentage) ){
                    self.selectedMinimum = selectedValue;
                    isIsSlide = true;
                }
                else {
                    self.selectedMinimum = self.selectedMaximum - mainPercentage;
                    
                }
                
            }
            else if (_rightHandleSelected)
            {
                
                isLeft = false;
                if (selectedValue > (self.selectedMinimum  + fabsf(mainPercentage)) || (self.disableRange && selectedValue >= self.minValue)){ //don't let the dots cross over, (unless range is disabled, in which case just dont let the dot fall off the end of the screen)
                    self.selectedMaximum = selectedValue;
                    isIsSlide = true;
                    
                }
                else {
                    self.selectedMaximum = self.selectedMinimum + fabsf(mainPercentage);
                    
                }
            }
            
            isUpdateSlider = true;
            //no need to refresh the view because it is done as a sideeffect of setting the property
            if(_delegate && [_delegate respondsToSelector:@selector(dragRangeSlider:didEndChangeSelectedMinimumValue:andMaximumValue:isRight:isUpdate:)]){
                [_delegate dragRangeSlider:self didEndChangeSelectedMinimumValue:self.selectedMinimum andMaximumValue:self.selectedMaximum isRight:_rightHandleSelected isUpdate:&isUpdateSlider];
            }
            if( !startMoveTime && _delegate && [_delegate respondsToSelector:@selector(getIsSlide:atoriginX:atIsLeft:atTouch:)])
            {
                if( isCollageSilder && isUpdateSlider && isIsSlide )
                {
                    if( isLeft )
                    {
                        [_delegate getIsSlide:location.x atoriginX: self.frame.origin.x atIsLeft:true atTouch:touch];
                    }
                    else{
                        [_delegate getIsSlide:location.x atoriginX: self.frame.origin.x atIsLeft:false atTouch:touch];
                    }
                }
                else
                {
                    if( isIsSlide )
                    {
                        if( isLeft )
                        {
                            if( isCollageSilder )
                                [_delegate getIsSlide:(self.selectedMinimum - self.minValue)/(self.maxValue - self.minValue) * (CGRectGetMaxX(self.sliderLine.frame) - CGRectGetMinX(self.sliderLine.frame)) + 25 - fTrackingX atoriginX: self.frame.origin.x atIsLeft:true atTouch:touch];
                        }
                        else{
                            if( isCollageSilder )
                                [_delegate getIsSlide:location.x atoriginX: self.frame.origin.x atIsLeft:false atTouch:touch];
                        }
                    }
                }
            }
            else{
                [startMoveTime invalidate];
                startMoveTime = nil;
            }
    }
    else
    {
        if( !_isStartMove )
        {
            if(_leftHandleSelected)
            {
                CGPoint leftLocation = [touch locationInView:self.leftLabel];
                if( (leftLocation.x <0) || (leftLocation.x > self.leftLabel.frame.size.width ) )
                {
                    _isStartMove = false;
                    [startMoveTime invalidate];
                    startMoveTime = nil;
                }
            }
            else
            {
                CGPoint rightLocation = [touch locationInView:self.rightLabel];
                if( (rightLocation.x <0) || (rightLocation.x > self.rightLabel.frame.size.width ) )
                {
                    _isStartMove = false;
                    [startMoveTime invalidate];
                    startMoveTime = nil;
                }
            }
        }
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if(!_isStartDrag){
        return;
    }
    _isStartDrag = NO;
    isFristTracking = true;
    _isStartMove = false;
    [startMoveTime invalidate];
    startMoveTime = nil;
    
    fTrackingX = 0;
    if (_leftHandleSelected){
        if(_delegate && [_delegate respondsToSelector:@selector(rangeSlider:didEndChangeSelectedMinimumValue:andMaximumValue:)]){
            [_delegate rangeSlider:self didEndChangeSelectedMinimumValue:self.selectedMinimum andMaximumValue:self.selectedMaximum];
        }
        _leftLabel.highlighted = NO;
        _leftHandleSelected = NO;
        [self animateHandle:_leftHandle withSelection:NO];
    } else {
        if(_delegate && [_delegate respondsToSelector:@selector(rangeSlider:didEndChangeSelectedMinimumValue:andMaximumValue:)]){
            [_delegate rangeSlider:self didEndChangeSelectedMinimumValue:self.selectedMinimum andMaximumValue:self.selectedMaximum];
        }
        _rightLabel.highlighted = NO;
        _rightHandleSelected = NO;
        [self animateHandle:_rightHandle withSelection:NO];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(stopMove)]){
        [_delegate stopMove];
    }
    _leftHandleSelected = NO;
    _rightHandleSelected = NO;
}

- (void)cancelTrackingWithEvent:(nullable UIEvent *)event{
//    _isStartMove = false;
//    [startMoveTime invalidate];
//    startMoveTime = nil;
    [self endTrackingWithTouch:nil withEvent:event];
    if (_isStartMove) {//20220708 有时不调用endTrackingWithTouch
        _isStartMove = false;
        [startMoveTime invalidate];
        startMoveTime = nil;
        isFristTracking = true;
        fTrackingX = 0;
        if (_leftHandleSelected){
            if(_delegate && [_delegate respondsToSelector:@selector(rangeSlider:didEndChangeSelectedMinimumValue:andMaximumValue:)]){
                [_delegate rangeSlider:self didEndChangeSelectedMinimumValue:self.selectedMinimum andMaximumValue:self.selectedMaximum];
            }
            _leftLabel.highlighted = NO;
            _leftHandleSelected = NO;
            [self animateHandle:_leftHandle withSelection:NO];
        } else {
            if(_delegate && [_delegate respondsToSelector:@selector(rangeSlider:didEndChangeSelectedMinimumValue:andMaximumValue:)]){
                [_delegate rangeSlider:self didEndChangeSelectedMinimumValue:self.selectedMinimum andMaximumValue:self.selectedMaximum];
            }
            _rightLabel.highlighted = NO;
            _rightHandleSelected = NO;
            [self animateHandle:_rightHandle withSelection:NO];
        }
        if(_delegate && [_delegate respondsToSelector:@selector(stopMove)]){
            [_delegate stopMove];
        }
        _leftHandleSelected = NO;
        _rightHandleSelected = NO;
    }else {
        _isStartMove = false;
        [startMoveTime invalidate];
        startMoveTime = nil;
    }
    
    
    
}

#endif

#pragma mark - Animation
- (void)animateHandle:(CALayer*)handle withSelection:(BOOL)selected {
    if (selected){
        handle.transform = CATransform3DMakeScale(1.7, 1.7, 1);
        [self updateLabelPositions];
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.3];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
//        handle.transform = CATransform3DMakeScale(1.7, 1.7, 1);
//
//        //the label above the handle will need to move too if the handle changes size
//        [self updateLabelPositions];
//
//        [CATransaction setCompletionBlock:^{
//
//        }];
//        [CATransaction commit];

    } else {
        handle.transform = CATransform3DIdentity;
        [self updateLabelPositions];
//        [CATransaction begin];
//        [CATransaction setAnimationDuration:0.3];
//        [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
//        handle.transform = CATransform3DIdentity;
//
//        //the label above the handle will need to move too if the handle changes size
//        [self updateLabelPositions];
//
//        [CATransaction commit];
    }
}

#pragma mark - Calculating nearest handle to point
- (float)distanceBetweenPoint:(CGPoint)point1 andPoint:(CGPoint)point2
{
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

- (CGPoint)getCentreOfRect:(CGRect)rect
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}


#pragma mark - Properties
-(void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];

    struct CGColor *color = self.tintColor.CGColor;

    [CATransaction begin];
    [CATransaction setAnimationDuration:0.5];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut] ];
    self.sliderLine.backgroundColor = color;
    _leftHandle.backgroundColor = color;
    _rightHandle.backgroundColor = color;

    if (_minLabelColour == nil){
        _minLabel.foregroundColor = color;
    }
    if (_maxLabelColour == nil){
        _maxLabel.foregroundColor = color;
    }
    [CATransaction commit];
}

- (void)setDisableRange:(BOOL)disableRange {
    _disableRange = disableRange;
    if (_disableRange){
        _leftHandle.hidden = YES;
        _minLabel.hidden = YES;
    } else {
        _leftHandle.hidden = NO;
    }
}

- (NSNumberFormatter *)decimalNumberFormatter {
    if (!_decimalNumberFormatter){
        _decimalNumberFormatter = [[NSNumberFormatter alloc] init];
        _decimalNumberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _decimalNumberFormatter.maximumFractionDigits = 0;
    }
    return _decimalNumberFormatter;
}

- (void)setMinValue:(float)minValue {
    _minValue = minValue;
    [self refresh];
}

- (void)setMaxValue:(float)maxValue {
    _maxValue = maxValue;
    [self refresh];
}

- (void)setSelectedMinimum:(float)selectedMinimum {
    if (selectedMinimum < self.minValue){
        selectedMinimum = self.minValue;
    }

    _selectedMinimum = selectedMinimum;
    [self refresh];
}

- (void)setSelectedMaximum:(float)selectedMaximum {
    if (selectedMaximum > self.maxValue){
        selectedMaximum = self.maxValue;
    }
    _selectedMaximum = selectedMaximum;
    [self refresh];
}

-(void)setMinLabelColour:(UIColor *)minLabelColour{
    _minLabelColour = minLabelColour;
    _minLabel.foregroundColor = _minLabelColour.CGColor;
}

-(void)setMaxLabelColour:(UIColor *)maxLabelColour{
    _maxLabelColour = maxLabelColour;
    _maxLabel.foregroundColor = _maxLabelColour.CGColor;
}

-(void)setNumberFormatterOverride:(NSNumberFormatter *)numberFormatterOverride{
    _numberFormatterOverride = numberFormatterOverride;
    [self updateLabelValues];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}
@end

@interface VETTRangeSlider(Hidden)


@end

@implementation VETTRangeSlider(Hidden)

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if(hidden){
        
    }
}

@end
