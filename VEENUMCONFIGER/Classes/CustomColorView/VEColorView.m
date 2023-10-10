//
//  VEColorView.m
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/7/21.
//

#import "VEColorView.h"
#import "VEHelp.h"
#import "CustomColorView.h"

#define kVEColorViewBtnTag 10000

@interface VEColorView ()<CustomColorViewDelegate>
{
    BOOL            _isEnableEyedropper;
    UIButton        *_eyedropperBtn;
    UIButton        *_customColorBtn;
    UIView          *_splitLineView;
    UIScrollView    *_colorBtnScrollView;
    NSMutableArray  *_colors;
    float           _space;
    UIImageView     *_eyedropperImageView;
    UIImage         *_currentImage;
    NSInteger       _selectedColorIndex;
    BOOL            _isIPad;
    UIColor         *_prevCustomColor;
}

@property (nonatomic, strong) ColorButton *currentCustomColorBtn;

@property (nonatomic, strong) UIView *eyedropperBgView;

@property (nonatomic, strong) CustomColorView *customColorView;

@end

@implementation VEColorView

- (instancetype)initWithFrame:(CGRect)frame isEnableEyedropper:(BOOL)isEnableEyedropper currentCustomColor:(nonnull UIColor *)currentCustomColor isLayoutiPad:(BOOL)isLayoutiPad {
    if (self = [super initWithFrame:frame]) {
        _isEnableEyedropper = isEnableEyedropper;
        _currentCustomColor = currentCustomColor;
        if (isLayoutiPad) {
            _isIPad = [VEConfigManager sharedManager].iPad_HD;
        }
        
        float width = frame.size.height;
        float x = 15;
        _space = 10;
        if (isEnableEyedropper) {
            _eyedropperBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, width)];
            _eyedropperBtn.layer.cornerRadius = width / 2.0;
            _eyedropperBtn.layer.masksToBounds = YES;
            [_eyedropperBtn setImage:[VEHelp imageNamed:@"颜色-吸管" atBundle:[VEHelp getBundleName:@"VEEditSDK"]] forState:UIControlStateNormal];
            [_eyedropperBtn setImage:[VEHelp imageNamed:@"颜色-吸管选中" atBundle:[VEHelp getBundleName:@"VEEditSDK"]] forState:UIControlStateSelected];
            [_eyedropperBtn setImageEdgeInsets:UIEdgeInsetsMake(-8, -8, -8, -8)];
            [_eyedropperBtn addTarget:self action:@selector(eyedropperBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_eyedropperBtn];
            
            x += width + _space;
        }
        
        UIButton *customColorBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, width, width)];
        customColorBtn.layer.cornerRadius = width / 2.0;
        customColorBtn.layer.masksToBounds = YES;
        [customColorBtn setImage:[VEHelp imageNamed:@"颜色-色板" atBundle:[VEHelp getBundleName:@"VEEditSDK"]] forState:UIControlStateNormal];
        [customColorBtn setImageEdgeInsets:UIEdgeInsetsMake(-8, -8, -8, -8)];
        [customColorBtn addTarget:self action:@selector(customColorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _customColorBtn = customColorBtn;
        [self addSubview:customColorBtn];
        
        x += width + _space;
        
        if (currentCustomColor) {
            _selectedColorIndex = -1;
            self.currentCustomColorBtn.hidden = NO;
            x += width + _space;
        }
        
        _splitLineView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 20, frame.size.height)];
        [self addSubview:_splitLineView];
        {
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 10, _splitLineView.frame.size.height)];
            line.image = [VEHelp imageNamed:@"颜色-过度1" atBundle:[VEHelp getBundleName:@"VEEditSDK"]];
            [_splitLineView addSubview:line];
        }
        {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 1, 1, _splitLineView.frame.size.height - 2)];
            line.backgroundColor = UIColorFromRGB(0x272727);
            [_splitLineView addSubview:line];
        }
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 0, frame.size.width - x, frame.size.height)];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        _colorBtnScrollView = scrollView;
        [self addSubview:scrollView];
        
        [self refreshColorBtnScrollView];
    }
    
    return self;
}

- (void)refreshColorBtnScrollView {
    _colors = [VEHelp getColorList];
    float width = self.frame.size.height;
    for (int i = 0; i < _colors.count; i++) {
        ColorButton *btn = [[ColorButton alloc] initWithFrame:CGRectMake(_space + (width + _space) * i, 0, width, width)];
        btn.backgroundColor = _colors[i];
        btn.tag = i + kVEColorViewBtnTag;
        [btn addTarget:self action:@selector(colorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (!_currentCustomColor && i == _selectedColorIndex) {
            btn.selected = YES;
        }
        [_colorBtnScrollView addSubview:btn];
    }
    _colorBtnScrollView.contentSize = CGSizeMake(_space + (width + _space) * _colors.count, 0);
}

- (ColorButton *)currentCustomColorBtn {
    if (!_currentCustomColorBtn) {
        float x = 15 + self.frame.size.height + 10;
        if (_isEnableEyedropper) {
            x += self.frame.size.height + 10;
        }
        _currentCustomColorBtn = [[ColorButton alloc] initWithFrame:CGRectMake(x, 0, self.frame.size.height, self.frame.size.height)];
        _currentCustomColorBtn.backgroundColor = _currentCustomColor;
        _currentCustomColorBtn.selected = YES;
        [_currentCustomColorBtn addTarget:self action:@selector(currentCustomColorBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_currentCustomColorBtn];
    }
    
    return _currentCustomColorBtn;
}

- (UIView *)eyedropperBgView {
    if (!_eyedropperBgView) {
        _eyedropperBgView = [[UIView alloc] init];
        [_eyedropperBgView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(eyedropperPanGestureRecognizer:)]];
        _eyedropperImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31, 38)];
        _eyedropperImageView.backgroundColor = [UIColor whiteColor];
        _eyedropperImageView.image = [VEHelp imageNamed:@"颜色-选取2" atBundle:[VEHelp getBundleName:@"VEEditSDK"]];
        UIImage*maskingImage =[VEHelp imageNamed:@"颜色-选取1" atBundle:[VEHelp getBundleName:@"VEEditSDK"]];
        CALayer*maskingLayer =[CALayer layer];
        maskingLayer.frame = _eyedropperImageView.bounds;
        [maskingLayer setContents:(id)[maskingImage CGImage]];
        [_eyedropperImageView.layer setMask:maskingLayer];
        [_eyedropperBgView addSubview:_eyedropperImageView];
        
        _currentCustomColor = UIColorFromRGB(0xffffff);
        [self refreshSelectedColorBtn];
    }
    
    return _eyedropperBgView;
}

- (CustomColorView *)customColorView {
    if (!_customColorView) {
        if(_isIPad){
            _customColorView = [[CustomColorView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, 340 + kBottomSafeHeight)];
        }else{
            _customColorView = [[CustomColorView alloc] initWithFrame:CGRectMake(0, kHEIGHT, kWIDTH, 340 + kBottomSafeHeight)];
        }
        _customColorView.delegate = self;
    }
    if(_isIPad){
        [self addSubview:_customColorView];
    }else{
        [[[[UIApplication sharedApplication] delegate] window] addSubview:_customColorView];
    }
    if(_customColorView.otherColors.count > _customColorView.selectColorIndex){
        if(![_customColorView.otherColors[_customColorView.selectColorIndex] isEqualToString:[_customColorView UIColorToHexString:_currentCustomColor]]){
            _customColorView.selectColorIndex = -1;
            [_customColorView refreshOtherColorScrollView];
        }
    }
    if( _currentCustomColor )
    {
        [_customColorView setSelectColor:_currentCustomColor];
    }
    WeakSelf(self);
    CGRect rect = _customColorView.frame;
    if([VEConfigManager sharedManager].iPad_HD){
        rect.origin.x = 0;
    }else{
        rect.origin.y = kHEIGHT - rect.size.height;
    }
    [UIView animateWithDuration:0.25 animations:^{
        StrongSelf(self);
        strongSelf->_customColorView.frame = rect;
    } completion:^(BOOL finished) {
        StrongSelf(self);
        [[[UIApplication sharedApplication].delegate window].layer addSublayer:strongSelf->_customColorView.customShowColorView.strawLayer];
        CGRect rect = [strongSelf->_customColorView.customShowColorView.focusView convertRect:strongSelf->_customColorView.customShowColorView.focusView.bounds toView:[[UIApplication sharedApplication].delegate window]];
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        strongSelf->_customColorView.customShowColorView.strawLayer.position = CGPointMake(CGRectGetMidX(rect) + 15 - strongSelf->_customColorView.customShowColorView.strawLayer.frame.size.width/2.0, rect.origin.y - strongSelf->_customColorView.customShowColorView.strawLayer.frame.size.height/2.0);
        [CATransaction commit];
    }];
    
    return _customColorView;
}

- (void)eyedropperBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.eyedropperBgView.hidden = !sender.selected;
    if (!_eyedropperBgView.hidden && _delegate && [_delegate respondsToSelector:@selector(showEyedropperView:)]) {
        [_delegate showEyedropperView:_eyedropperBgView];
    }
}

- (void)customColorBtnAction:(UIButton *)sender {
    _eyedropperBgView.hidden = YES;
    _eyedropperBtn.selected = NO;
    _prevCustomColor = _currentCustomColor;
    self.customColorView.hidden = NO;
}

- (void)currentCustomColorBtnAction:(ColorButton *)sender {
    _eyedropperBgView.hidden = YES;
    _eyedropperBtn.selected = NO;
    if (_selectedColorIndex >= 0) {
        ColorButton *prevBtn = [_colorBtnScrollView viewWithTag:_selectedColorIndex + kVEColorViewBtnTag];
        prevBtn.selected = NO;
    }
    _currentCustomColor = sender.backgroundColor;
    _selectedColorIndex = -1;
    sender.selected = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(changeColor:)]) {
        [_delegate changeColor:_currentCustomColor];
    }
}

- (void)colorBtnAction:(ColorButton *)sender {
    _eyedropperBgView.hidden = YES;
    _eyedropperBtn.selected = NO;
    if (_selectedColorIndex >= 0) {
        ColorButton *prevBtn = [_colorBtnScrollView viewWithTag:_selectedColorIndex + kVEColorViewBtnTag];
        prevBtn.selected = NO;
    }
    _currentCustomColor = nil;
    _currentCustomColorBtn.selected = NO;
    _selectedColor = sender.backgroundColor;
    _selectedColorIndex = sender.tag - kVEColorViewBtnTag;
    sender.selected = YES;
    
    if ([sender.superview isKindOfClass:[UIScrollView class]]) {
        UIButton *itemBtn = sender;
        UIScrollView *scrollView = (UIScrollView *)itemBtn.superview;
        float margin = scrollView.frame.origin.x / 2.0;
        CGFloat offSetX = itemBtn.center.x - scrollView.bounds.size.width * 0.5 + margin;
        CGFloat offsetX1 = (scrollView.contentSize.width - itemBtn.center.x) - scrollView.bounds.size.width * 0.5;
        CGPoint offset = CGPointZero;
        if (offSetX > 0 && offsetX1 > 0) {
            offset = CGPointMake(offSetX, 0);
        }
        else if(offSetX < 0){
            offset = CGPointZero;
        }
        else if (offsetX1 < 0){
            offset = CGPointMake(scrollView.contentSize.width - scrollView.bounds.size.width, 0);
        }
        [scrollView setContentOffset:offset animated:YES];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(changeColor:)]) {
        [_delegate changeColor:_selectedColor];
    }
}

- (void)eyedropperPanGestureRecognizer:(UIPanGestureRecognizer *)gesture{
    if (_delegate && [_delegate respondsToSelector:@selector(getCurrentImage)]) {
        //获取偏移量
        CGPoint location = [gesture locationInView:_eyedropperBgView];
        if(!gesture){
            location = CGPointMake(_eyedropperBgView.frame.size.width/2.0, _eyedropperBgView.frame.size.height * 1/3.0);
            _currentImage = [_delegate getCurrentImage];
        }
        _eyedropperImageView.center = CGPointMake(MAX(MIN(CGRectGetWidth(_eyedropperBgView.frame), location.x), 0), MAX(MIN(CGRectGetHeight(_eyedropperBgView.frame), location.y), 0) - _eyedropperImageView.frame.size.height);
        CGPoint center = CGPointMake(_eyedropperImageView.center.x/_eyedropperBgView.frame.size.width, CGRectGetMaxY(_eyedropperImageView.frame)/_eyedropperBgView.frame.size.height);
        
        if(gesture.state == UIGestureRecognizerStateBegan || !_currentImage){
            _currentImage = [_delegate getCurrentImage];
        }
        _currentCustomColor = [VEHelp colorAtPixel:CGPointMake(center.x * _currentImage.size.width, center.y * _currentImage.size.height) source:_currentImage];
        if(_currentCustomColor != [UIColor clearColor] && _currentCustomColor != nil){
            _eyedropperImageView.backgroundColor = _currentCustomColor;
            [self refreshSelectedColorBtn];
        }
        
        if(gesture.state == UIGestureRecognizerStateEnded){
            _eyedropperBgView.hidden = YES;
            _eyedropperBtn.selected = NO;
            if (_delegate && [_delegate respondsToSelector:@selector(changeColor:)]) {
                [_delegate changeColor:_currentCustomColor];
            }
        }
    }
}

- (void)refreshSelectedColorBtn {
    float x;
    if (_currentCustomColor) {
        if (_selectedColorIndex >= 0) {
            ColorButton *prevBtn = [_colorBtnScrollView viewWithTag:_selectedColorIndex + kVEColorViewBtnTag];
            prevBtn.selected = NO;
        }
        _selectedColorIndex = -1;
        self.currentCustomColorBtn.backgroundColor = _currentCustomColor;
        _currentCustomColorBtn.selected = YES;
        x = CGRectGetMaxX(_currentCustomColorBtn.frame) + 10;
    }
    else {
        _currentCustomColorBtn.selected = NO;
        if (_currentCustomColorBtn) {
            x = CGRectGetMaxX(_currentCustomColorBtn.frame) + 10;
        }else {
            x = CGRectGetMaxX(_customColorBtn.frame) + 10;
        }
    }
    CGRect frame = _splitLineView.frame;
    frame.origin.x = x;
    _splitLineView.frame = frame;
    
    frame = _colorBtnScrollView.frame;
    frame.origin.x = x;
    frame.size.width = self.frame.size.width - x;
    _colorBtnScrollView.frame = frame;
}

#pragma mark - CustomColorViewDelegate
- (void)colorViewChangeColor:(UIColor *)color{
    _currentCustomColor = color;
    if (_delegate && [_delegate respondsToSelector:@selector(changeColor:)]) {
        [_delegate changeColor:_currentCustomColor];
    }
}

- (void)colorViewCancelChangeColor:(CustomColorView *)view {
    _currentCustomColor = _prevCustomColor;
    NSLog(@"_currentCustomColor:%@", _currentCustomColor);
    if (_currentCustomColor) {
        if (_delegate && [_delegate respondsToSelector:@selector(changeColor:)]) {
            [_delegate changeColor:_currentCustomColor];
        }
    }
    else if (_delegate && [_delegate respondsToSelector:@selector(changeColor:)]) {
        [_delegate changeColor:_selectedColor];
    }
}

- (void)colorViewClose_View:(CustomColorView *)view{
    if([_currentCustomColor isEqual:[UIColor clearColor]] || !_currentCustomColor){
        _currentCustomColor = UIColorFromRGB(0xffffff);
    }
    [self refreshSelectedColorBtn];
    if (_delegate && [_delegate respondsToSelector:@selector(changeColor:)]) {
        [_delegate changeColor:_currentCustomColor];
    }
}

- (void)setCurrentColor:(UIColor *)color {
    if (!color || CGColorEqualToColor(color.CGColor, [UIColor clearColor].CGColor)) {
        if (_selectedColorIndex >= 0) {
            ColorButton *prevBtn = [_colorBtnScrollView viewWithTag:_selectedColorIndex + kVEColorViewBtnTag];
            prevBtn.selected = NO;
        }
        _currentCustomColorBtn.selected = NO;
        _currentCustomColor = nil;
        return;
    }
    __block NSUInteger index = -1;
    if( color )
    {
        CGFloat red1,green1,blue1,alpha1;
        __block CGFloat red2 = 0.0, green2 = 0.0, blue2 = 0.0,alpha2 = 0.0;
        //取出color1的背景颜色的RGBA值
        [color getRed:&red1 green:&green1 blue:&blue1 alpha:&alpha1];
        
        [_colors enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIColor *objColor = (UIColor *)obj;
            [objColor getRed:&red2 green:&green2 blue:&blue2 alpha:&alpha2];
            if ((red1 == red2)&&(green1 == green2)&&(blue1 == blue2)&&(alpha1 == alpha2)) {
                index = idx;
                *stop = YES;
            }
        }];
    }
    if (index == -1) {
        _currentCustomColor = color;
        [self refreshSelectedColorBtn];
    }else {
        ColorButton *btn = [_colorBtnScrollView viewWithTag:index + kVEColorViewBtnTag];
        [self colorBtnAction:btn];
    }
}

- (void)dealloc {
    [_eyedropperBgView removeFromSuperview];
    _eyedropperBgView = nil;
    [_customColorView removeFromSuperview];
    _customColorView = nil;
}

@end
