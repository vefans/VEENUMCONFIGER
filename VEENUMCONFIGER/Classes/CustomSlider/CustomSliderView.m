#import "CustomSliderView.h"
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
        cycleView.layer.cornerRadius = cycleViewWidth * 0.5;
        cycleView.layer.masksToBounds = YES;
        cycleView.frame = CGRectMake((spanwidth + cycleViewWidth) * i + 20, ((CGRectGetHeight(self.frame) - 15) - cycleViewWidth)/2.0, cycleViewWidth, cycleViewWidth);
        cycleView.backgroundColor = self.normalBgColor;
        [self insertSubview:cycleView belowSubview:self.currentCycleView];
        UILabel *indexLb = [[UILabel alloc] init];
        [self.indexLabelArrM addObject:indexLb];
        indexLb.font = systemFont(10);
        indexLb.textColor = UIColorFromRGB(0x727272);
        indexLb.text = [NSString stringWithFormat:@"%@", self.baifenbiArr[i]];
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
    if(_selectedIndexCallback){
        _selectedIndexCallback(_currentIndex,self.baifenbiArr[_currentIndex]);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
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
