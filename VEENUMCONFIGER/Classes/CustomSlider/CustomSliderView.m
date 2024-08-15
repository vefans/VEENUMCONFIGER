#import "CustomSliderView.h"
#import "VEHelp.h"

#define cycleViewWidth   8
#define currentCycleViewWidth   15
#define LineHeight       3
#define NormalViewBgColor  [UIColor colorWithHexString:@"#f4f4f4"];
#define VIEW_WIDTH [UIScreen mainScreen].bounds.size.width
#define ScaleW(width)  width*VIEW_WIDTH/375
#define systemFont(x) [UIFont systemFontOfSize:x]
@interface CustomSliderView ()
{
}
@property (nonatomic ,strong) UIView *bellowView;
@property (nonatomic ,strong) UIView *progressView;
@property (nonatomic ,strong) UIImageView *currentCycleView;
@property (nonatomic ,strong) NSMutableArray <UIView *>*cycleViewArrM;
@property (nonatomic ,strong) NSMutableArray <UILabel *>*indexLabelArrM;
@property (nonatomic ,strong) NSMutableArray *indexLbArrM;
@end
@implementation CustomSliderView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addChildrenViews];
    }
    return self;
}
- (void) addChildrenViews{
    self.selectedBgColor = [UIColor blueColor];
    self.currentCycleColor =  [UIColor whiteColor];
    [self addSubview:self.bellowView];
    [self addSubview:self.progressView];
    [self addSubview:self.currentCycleView];
    self.bellowView.layer.masksToBounds = YES;
    self.currentCycleView.backgroundColor = UIColorFromRGB(0x272727);
    self.currentCycleView.userInteractionEnabled = YES;
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    if(self.cycleViewArrM.count > currentIndex){
        _currentCycleView.center = self.cycleViewArrM[currentIndex].center;
        _progressView.frame = CGRectMake(20, ((CGRectGetHeight(self.frame) - 15) - 2)/2.0, _currentCycleView.center.x - 20, 2);
    }
    for (int i = 0;i<self.cycleViewArrM.count;i++) {
        UIView *view = self.cycleViewArrM[i];
        view.backgroundColor = i <= _currentIndex ? _selectedBgColor : _normalBgColor;
    }

}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)setBaifenbiArr:(NSArray *)baifenbiArr{
    _baifenbiArr = baifenbiArr;
    for (UIView *vvv in self.cycleViewArrM) {
        [vvv removeFromSuperview];
    }
    for (UIView *vvv in self.indexLbArrM) {
        [vvv removeFromSuperview];
    }
    [self.cycleViewArrM removeAllObjects];
    [self.indexLbArrM removeAllObjects];
    [self addCycleViews];
}
- (void) addCycleViews{
    [self layoutIfNeeded];
    [self.indexLabelArrM makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.indexLabelArrM makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.cycleViewArrM removeAllObjects];
    [self.indexLabelArrM removeAllObjects];
    float spanwidth = (self.frame.size.width - 8 * self.baifenbiArr.count  - 40)/ (self.baifenbiArr.count - 1);
    UIView *bakkcycleView = [[UIView alloc] init];
    bakkcycleView.backgroundColor = self.normalBgColor;
    for (int i = 0; i < self.baifenbiArr.count; i++) {
        UIView *cycleView = [[UIView alloc] init];
        [self.cycleViewArrM addObject:cycleView];
        cycleView.layer.masksToBounds = YES;
        cycleView.frame = CGRectMake((spanwidth + cycleViewWidth) * i + 20, ((CGRectGetHeight(self.frame) - 15) - cycleViewWidth)/2.0, cycleViewWidth, cycleViewWidth);
        if(_hideBaifenbi){
            CGRect rect = cycleView.frame;
            CGPoint center = cycleView.center;
            rect.size.width = 2 * i + cycleViewWidth;
            rect.size.height = 2 * i + cycleViewWidth;
            rect.origin.x = center.x - rect.size.width/2.0;
            rect.origin.y = center.y - rect.size.height/2.0;
            cycleView.frame = rect;
        }
        cycleView.layer.cornerRadius = CGRectGetWidth(cycleView.frame) * 0.5;
        cycleView.backgroundColor = self.normalBgColor;
        [self insertSubview:cycleView belowSubview:self.currentCycleView];
        UILabel *indexLb = [[UILabel alloc] init];
        [self.indexLabelArrM addObject:indexLb];
        indexLb.font = systemFont(11);
        indexLb.textColor = UIColorFromRGB(0x727272);
        indexLb.text = self.baifenbiArr[i];
        indexLb.hidden = _hideBaifenbi;
        indexLb.textAlignment = NSTextAlignmentCenter;
        indexLb.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 15, 40, 15);
        indexLb.center = CGPointMake(cycleView.center.x, indexLb.center.y);
        [self insertSubview:indexLb aboveSubview:self.currentCycleView];
    }
    
    _bellowView.frame = CGRectMake(20, ((CGRectGetHeight(self.frame) - 15) - 2)/2.0, CGRectGetWidth(self.frame) -40, 2);
    _progressView.frame = CGRectMake(20, ((CGRectGetHeight(self.frame) - 15) - 2)/2.0, 0, 2);
    [self setCurrentIndex:0];
}
- (void)setSelectedBgColor:(UIColor *)selectedBgColor{
    _selectedBgColor = selectedBgColor;
    self.progressView.backgroundColor = selectedBgColor;
}
- (void)setNormalBgColor:(UIColor *)normalBgColor{
    _normalBgColor = normalBgColor;
    self.bellowView.backgroundColor = normalBgColor;
}

- (void)setNormalCycleColor:(UIColor *)normalCycleColor{
    _normalCycleColor = normalCycleColor;
    for (UIView *view in self.cycleViewArrM) {
        view.backgroundColor = _normalCycleColor;
    }
}
- (void)setCurrentCycleColor:(UIColor *)currentCycleColor{
    _currentCycleColor = currentCycleColor;
    self.currentCycleView.backgroundColor = currentCycleColor;
}
- (void)setCurrentCycleBoardColor:(UIColor *)currentCycleBoardColor{
    _currentCycleBoardColor = currentCycleBoardColor;
    self.currentCycleView.layer.borderColor = currentCycleBoardColor.CGColor;
}
- (UIView *)bellowView{
    if (!_bellowView) {
        _bellowView = [[UIView alloc] init];
        _bellowView.backgroundColor = UIColor.blueColor;
        _bellowView.layer.cornerRadius = 2 * 0.5;
        _bellowView.clipsToBounds = YES;
    }
    return _bellowView;
}
- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = UIColor.blueColor;
        _progressView.layer.cornerRadius = 2 * 0.5;
        _progressView.clipsToBounds = YES;
    }
    return _progressView;
}

- (UIImageView *)currentCycleView{
    if (!_currentCycleView) {
        _currentCycleView = [[UIImageView alloc] init];
        _currentCycleView.contentMode = UIViewContentModeScaleAspectFit;
        _currentCycleView.layer.borderWidth = 2;
        _currentCycleView.layer.borderColor = UIColor.whiteColor.CGColor;
        _currentCycleView.layer.cornerRadius = currentCycleViewWidth * 0.5;
        _currentCycleView.clipsToBounds = YES;
        _currentCycleView.frame = CGRectMake(0, (((CGRectGetHeight(self.frame) - 15) - currentCycleViewWidth)/2.0),currentCycleViewWidth, currentCycleViewWidth);
    }
    return _currentCycleView;
}

-(NSMutableArray *)cycleViewArrM{
    if (!_cycleViewArrM) {
        _cycleViewArrM = [NSMutableArray array];
    }
    return _cycleViewArrM;
}
- (NSMutableArray<UILabel *> *)indexLabelArrM{
    if (!_indexLabelArrM) {
        _indexLabelArrM = [NSMutableArray array];
    }
    return _indexLabelArrM;
}
- (NSMutableArray *)indexLbArrM{
    if (!_indexLbArrM) {
        _indexLbArrM = [NSMutableArray array];
    }
    return _indexLbArrM;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"point    %lf     %lf", point.x, point.y);
    for (UIView *cycleView in self.cycleViewArrM) {
        CGFloat r = cycleViewWidth * 4 * 0.5;
        CGPoint p = cycleView.center;
        if (fabs(p.x - point.x) <= r && fabs(p.y - point.y) <= r) {
            NSInteger index = [self.cycleViewArrM indexOfObject:cycleView];
            self.currentIndex = index;
            _currentCycleView.center = cycleView.center;
            _progressView.frame = CGRectMake(20, ((CGRectGetHeight(self.frame) - 15) - 2)/2.0, _currentCycleView.center.x - 20, 2);
        }
    }
    for (UIView *cycleView in self.cycleViewArrM) {
        if(point.x < CGRectGetMinX(cycleView.frame)){
            cycleView.backgroundColor = _normalBgColor;
        }else{
            cycleView.backgroundColor = _selectedBgColor;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    _currentCycleView.center = CGPointMake(MIN(MAX(point.x, self.cycleViewArrM.firstObject.center.x), self.cycleViewArrM.lastObject.center.x), _currentCycleView.center.y);
    _progressView.frame = CGRectMake(20, ((CGRectGetHeight(self.frame) - 15) - 2)/2.0, _currentCycleView.center.x - 20, 2);
    for (UIView *cycleView in self.cycleViewArrM) {
        if(point.x < CGRectGetMinX(cycleView.frame)){
            cycleView.backgroundColor = _normalBgColor;
        }else{
            cycleView.backgroundColor = _selectedBgColor;
        }
    }
    if(_changeSliderCallback){
        _changeSliderCallback(_currentCycleView.center.x/self.cycleViewArrM.lastObject.center.x);
    }
//    if(_selectedIndexCallback){
//        _selectedIndexCallback(_currentIndex,self.baifenbiArr[_currentIndex]);
//    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    if(point.x <= self.cycleViewArrM.firstObject.center.x){
        point.x  = self.cycleViewArrM.firstObject.center.x;
    }
    
    if(point.x >= self.cycleViewArrM.lastObject.center.x){
        point.x  = self.cycleViewArrM.lastObject.center.x;
    }
    float spanwidth = (self.frame.size.width - 8 * self.baifenbiArr.count  - 40)/ (self.baifenbiArr.count - 1);
    for (UIView *cycleView in self.cycleViewArrM) {
        if((point.x > CGRectGetMinX(cycleView.frame) - spanwidth/2.0) && (point.x < CGRectGetMaxX(cycleView.frame) + spanwidth/2.0)){
            NSInteger index = [self.cycleViewArrM indexOfObject:cycleView];
            _currentIndex = index;
            _currentCycleView.center = cycleView.center;
            _progressView.frame = CGRectMake(20, ((CGRectGetHeight(self.frame) - 15) - 2)/2.0, _currentCycleView.center.x - 20, 2);
        }
    }
    for (UIView *cycleView in self.cycleViewArrM) {
        if(point.x < CGRectGetMinX(cycleView.frame)){
            cycleView.backgroundColor = _normalBgColor;
        }else{
            cycleView.backgroundColor = _selectedBgColor;
        }
    }
    if(_selectedIndexCallback){
        _selectedIndexCallback(_currentIndex,self.baifenbiArr[_currentIndex]);
    }
}

@end


@interface CustomDoubleSlider ()
{
    UIView *_minTrack;
    UIView *_maxTrack;
    UIView *_mainTrack;
    
    CGPoint _beganCenter;
    CGFloat _total;
}

@end

@implementation CustomDoubleSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        _delayTime = -1;
        self.minValue = 0.0;
        self.maxValue = 0.0;
        self.unit = @"s";
        _minThumbColor = [UIColor whiteColor];
        _maxThumbColor = [UIColor whiteColor];
        _minTintColor = UIColorFromRGB(0x48cce2);
        _maxTintColor = UIColorFromRGB(0xf73e5f);
        if([VEConfigManager sharedManager].iPad_HD){
            _mainTintColor = UIColorFromRGB(0x2F302F);
        }else{
            _mainTintColor = SliderMaximumTrackTintColor;
            if([VEConfigManager sharedManager].backgroundStyle ==UIBgStyleDarkContent){
                _mainTintColor = UIColorFromRGB(0xcccfd6);
            }
        }
        
        UIImage *handlerImage = [VEHelp imageNamed:@"/New_EditVideo/Slider/LeftHandler_@3x"];
        _mainTrack = [[UIView alloc]initWithFrame:CGRectMake(55 + 15, (self.frame.size.height - 2) / 2.0, self.frame.size.width - (55 + 15) * 2, 2)];
        _mainTrack.backgroundColor = _mainTintColor;
        [self addSubview:_mainTrack];
        
        _minTrack = [[UIView alloc]initWithFrame:CGRectMake(_mainTrack.frame.origin.x, _mainTrack.frame.origin.y, 0, _mainTrack.frame.size.height)];
        _minTrack.backgroundColor = _minTintColor;
        [self addSubview:_minTrack];
        
        _maxTrack = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width - _mainTrack.frame.origin.x, _mainTrack.frame.origin.y, 0, _mainTrack.frame.size.height)];
        _maxTrack.backgroundColor = _maxTintColor;
        [self addSubview:_maxTrack];
        
        UIImageView *minThumbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_mainTrack.frame.origin.x - handlerImage.size.width / 2.0, (frame.size.height - handlerImage.size.height) / 2.0 + 3, handlerImage.size.width, handlerImage.size.height)];
        minThumbImageView.backgroundColor = [UIColor clearColor];
        minThumbImageView.layer.masksToBounds = YES;
        minThumbImageView.image = handlerImage;
        minThumbImageView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *minThumbImageViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMinThumbImageViewGesture:)];
        [minThumbImageView addGestureRecognizer:minThumbImageViewPanGestureRecognizer];
        [self addSubview:minThumbImageView];
        _minThumbImageView = minThumbImageView;
        
        UIImageView *maxThumbImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_mainTrack.frame) - handlerImage.size.width / 2.0, minThumbImageView.frame.origin.y, minThumbImageView.frame.size.width, minThumbImageView.frame.size.height)];
        maxThumbImageView.backgroundColor = [UIColor clearColor];
        maxThumbImageView.layer.masksToBounds = YES;
        maxThumbImageView.image = [VEHelp imageNamed:@"/New_EditVideo/Slider/RightHandler_@3x"];
        maxThumbImageView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *maxThumbImageViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panMaxThumbImageViewGesture:)];
        [maxThumbImageView addGestureRecognizer:maxThumbImageViewPanGestureRecognizer];
        [self addSubview:maxThumbImageView];
        _maxThumbImageView = maxThumbImageView;
        
        self.isShowLabel = YES;
    }
    return self;
}

- (void)setIsShowLabel:(BOOL)isShowLabel {
    _isShowLabel = isShowLabel;
    if (isShowLabel) {
        _minLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 55, self.frame.size.height)];
        _minLabel.textColor = [UIColor whiteColor];
        _minLabel.textAlignment = NSTextAlignmentRight;
        _minLabel.font = [UIFont systemFontOfSize:12.0];
        _minLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_minLabel];
        
        _maxLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - _minLabel.frame.size.width, _minLabel.frame.origin.y, _minLabel.frame.size.width, _minLabel.frame.size.height)];
        _maxLabel.textColor = [UIColor whiteColor];
        _maxLabel.textAlignment = NSTextAlignmentLeft;
        _maxLabel.font = [UIFont systemFontOfSize:12.0];
        _maxLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_maxLabel];
    }else {
        CGRect frame = _mainTrack.frame;
        frame.origin.x = _minThumbImageView.frame.size.width / 2.0;
        frame.size.width = self.frame.size.width - _minThumbImageView.frame.size.width;
        _mainTrack.frame = frame;
        
        frame = _minTrack.frame;
        frame.origin.x = _mainTrack.frame.origin.x;
        _minTrack.frame = frame;
    }
}

- (void)setMinThumbImage:(UIImage *)minThumbImage {
    if (!minThumbImage) {
        self.minThumbColor = _minThumbColor;
        return;
    }
    _minThumbImage = minThumbImage;
    CGRect frame = _minThumbImageView.frame;
    CGPoint center = _minThumbImageView.center;
    frame.size.width = _minThumbImage.size.width;
    frame.size.height = _minThumbImage.size.height;
    _minThumbImageView.frame = frame;
    _minThumbImageView.center = center;
    _minThumbImageView.backgroundColor = [UIColor clearColor];
    _minThumbImageView.layer.cornerRadius = 0;
    _minThumbImageView.layer.borderWidth = 0;
}

- (void)setMaxThumbImage:(UIImage *)maxThumbImage {
    if (!maxThumbImage) {
        self.maxThumbColor = _maxThumbColor;
        return;
    }
    _maxThumbImage = maxThumbImage;
    CGRect frame = _maxThumbImageView.frame;
    CGPoint center = _maxThumbImageView.center;
    frame.size.width = _maxThumbImage.size.width;
    frame.size.height = _maxThumbImage.size.height;
    _maxThumbImageView.frame = frame;
    _maxThumbImageView.center = center;
    _maxThumbImageView.backgroundColor = [UIColor clearColor];
    _maxThumbImageView.layer.cornerRadius = 0;
    _maxThumbImageView.layer.borderWidth = 0;
}

- (void)setMinThumbColor:(UIColor *)minThumbColor {
    _minThumbColor = minThumbColor;
    
    _minThumbImageView.backgroundColor = minThumbColor;
    _minThumbImageView.layer.cornerRadius = _minThumbImageView.frame.size.width/2.0f;
    _minThumbImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _minThumbImageView.layer.borderWidth = 0.5;
    _minThumbImageView.userInteractionEnabled = YES;
    _minThumbImageView.image = nil;
}

- (void)setMaxThumbColor:(UIColor *)maxThumbColor {
    _maxThumbColor = maxThumbColor;
    
    _maxThumbImageView.backgroundColor = maxThumbColor;
    _maxThumbImageView.layer.cornerRadius = _maxThumbImageView.frame.size.width/2.0f;
    _maxThumbImageView.layer.masksToBounds = YES;
    _maxThumbImageView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    _maxThumbImageView.layer.borderWidth = 0.5;
    _maxThumbImageView.image = nil;
}

- (void)panMinThumbImageViewGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _beganCenter = gesture.view.center;
        _minLabel.hidden = NO;
        [self bringSubviewToFront:_minThumbImageView];
    }
    gesture.view.center = CGPointMake(_beganCenter.x + point.x, _minThumbImageView.center.y);
    
    if (CGRectGetMaxX(gesture.view.frame) > CGRectGetMaxX(_maxThumbImageView.frame)) {
        CGRect frame = gesture.view.frame;
        frame.origin.x = _maxThumbImageView.frame.origin.x;
        gesture.view.frame = frame;
    }else {
        if (gesture.view.center.x < _mainTrack.frame.origin.x) {
            gesture.view.center = CGPointMake(_mainTrack.frame.origin.x, gesture.view.center.y);
        }
        if (gesture.view.center.x > CGRectGetMaxX(_mainTrack.frame)) {
            gesture.view.center = CGPointMake(CGRectGetMaxX(_mainTrack.frame), gesture.view.center.y);
        }
    }
    _minTrack.frame = CGRectMake(_minTrack.frame.origin.x, _minTrack.frame.origin.y,  gesture.view.center.x - _minTrack.frame.origin.x, _minTrack.frame.size.height);
    [self valueMinChange:gesture.view.center.x];
    
    if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged && _delayTime >= 0) {
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:_delayTime];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customDoubleSliderChangeValue:state:isMinValue:)]) {
        [_delegate customDoubleSliderChangeValue:_currentMinValue state:gesture.state isMinValue:YES];
    }
}

- (void)panMaxThumbImageViewGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _beganCenter = gesture.view.center;
        _maxLabel.hidden = NO;
        [self bringSubviewToFront:_maxThumbImageView];
    }
    gesture.view.center = CGPointMake(_beganCenter.x + point.x, _minThumbImageView.center.y);
    
    if (gesture.view.frame.origin.x < _minThumbImageView.frame.origin.x) {
        CGRect frame = gesture.view.frame;
        frame.origin.x = _minThumbImageView.frame.origin.x;
        gesture.view.frame = frame;
    }else {
        if (gesture.view.center.x < _mainTrack.frame.origin.x) {
            gesture.view.center = CGPointMake(_mainTrack.frame.origin.x, gesture.view.center.y);
        }
        if (gesture.view.center.x > CGRectGetMaxX(_mainTrack.frame)) {
            gesture.view.center = CGPointMake(CGRectGetMaxX(_mainTrack.frame), gesture.view.center.y);
        }
    }
    _maxTrack.frame = CGRectMake(gesture.view.center.x, _maxTrack.frame.origin.y, self.frame.size.width - _mainTrack.frame.origin.x - gesture.view.center.x, _maxTrack.frame.size.height);
    [self valueMaxChange:gesture.view.center.x];
    
    if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged && _delayTime >= 0) {
        [self performSelector:@selector(hiddenLabel) withObject:nil afterDelay:_delayTime];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(customDoubleSliderChangeValue:state:isMinValue:)]) {
        [_delegate customDoubleSliderChangeValue:_currentMaxValue state:gesture.state isMinValue:NO];
    }
}

- (void)hiddenLabel {
    _minLabel.hidden = YES;
    _maxLabel.hidden = YES;
}

- (void)valueMinChange:(CGFloat)num
{
    _currentMinValue = _minValue + _total * (num - _mainTrack.frame.origin.x);
    _minLabel.text = [NSString stringWithFormat:@"%.1f%@", _currentMinValue, _unit];
}

- (void)valueMaxChange:(CGFloat)num
{
    _currentMaxValue = _minValue + _total * (num - _mainTrack.frame.origin.x);
    _maxLabel.text = [NSString stringWithFormat:@"%.1f%@", (_maxValue - _currentMaxValue), _unit];
}

-(void)setMinValue:(CGFloat)minValue
{
    _minValue = minValue;
    _total = (_maxValue - _minValue)/_mainTrack.frame.size.width;
    if (_total < 0) {
        _total = -_total;
    }
    
    _minLabel.text = [NSString stringWithFormat:@"%.1f%@", minValue, _unit];
    _currentMinValue = minValue;
}

-(void)setMaxValue:(CGFloat)maxValue
{
    _maxValue = maxValue;
    _total = (_maxValue - _minValue)/_mainTrack.frame.size.width;
    if (_total < 0) {
        _total = -_total;
    }
    _currentMaxValue = maxValue;
    _maxLabel.text = [NSString stringWithFormat:@"%.1f%@", (_maxValue - _currentMaxValue), _unit];
}

- (void)setCurrentMinValue:(CGFloat)currentMinValue {
    _currentMinValue = currentMinValue;
    if (_currentMinValue <= _minValue) {
        _minLabel.hidden = YES;
        _minThumbImageView.hidden = YES;
        _minTrack.hidden = YES;
        
        CGRect frame = _minThumbImageView.frame;
        frame.origin.x = _mainTrack.frame.origin.x - frame.size.width / 2.0;
        _minThumbImageView.frame = frame;
        return;
    }
    if (currentMinValue > _maxValue - _currentMaxValue) {
        _currentMinValue = _maxValue - _currentMaxValue;
    }
    [self bringSubviewToFront:_minThumbImageView];
    _minLabel.text = [NSString stringWithFormat:@"%.1f%@", _currentMinValue, _unit];
    CGRect frame = _minThumbImageView.frame;
    frame.origin.x = (_currentMinValue - _minValue) / _total + _mainTrack.frame.origin.x - frame.size.width / 2.0;
    _minThumbImageView.frame = frame;
    
    frame = _minTrack.frame;
    frame.size.width = _minThumbImageView.center.x - _minTrack.frame.origin.x;
    _minTrack.frame = frame;
    
    _minLabel.hidden = NO;
    _minThumbImageView.hidden = NO;
    _minTrack.hidden = NO;
}

- (void)setCurrentMaxValue:(CGFloat)currentMaxValue {
    _currentMaxValue = currentMaxValue;
    if (_currentMaxValue <= _minValue) {
        _maxLabel.hidden = YES;
        _maxThumbImageView.hidden = YES;
        _maxTrack.hidden = YES;
        
        CGRect frame = _maxThumbImageView.frame;
        frame.origin.x = CGRectGetMaxX(_mainTrack.frame) - frame.size.width / 2.0;
        _maxThumbImageView.frame = frame;
        return;
    }
    if (_currentMaxValue < _currentMinValue) {
        _currentMaxValue = _currentMinValue;
    }
    [self bringSubviewToFront:_maxThumbImageView];
    _maxLabel.text = [NSString stringWithFormat:@"%.1f%@", (_maxValue - _currentMaxValue), _unit];
    CGRect frame = _maxThumbImageView.frame;
    frame.origin.x = (_currentMaxValue - _minValue) / _total + _mainTrack.frame.origin.x - frame.size.width / 2.0;
    _maxThumbImageView.frame = frame;
    
    frame = _maxTrack.frame;
    frame.origin.x = _maxThumbImageView.center.x;
    frame.size.width = self.frame.size.width - frame.origin.x - _mainTrack.frame.origin.x;
    _maxTrack.frame = frame;
    
    _maxLabel.hidden = NO;
    _maxThumbImageView.hidden = NO;
    _maxTrack.hidden = NO;
}

-(void)setMinTintColor:(UIColor *)minTintColor
{
    _minTintColor = minTintColor;
    _minTrack.backgroundColor = minTintColor;
}

-(void)setMaxTintColor:(UIColor *)maxTintColor
{
    _maxTintColor = maxTintColor;
    _maxTrack.backgroundColor = maxTintColor;
}

-(void)setMainTintColor:(UIColor *)mainTintColor
{
    _mainTintColor = mainTintColor;
    _mainTrack.backgroundColor = mainTintColor;
}

@end
