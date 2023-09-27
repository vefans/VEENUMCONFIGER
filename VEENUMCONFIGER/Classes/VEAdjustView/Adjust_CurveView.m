//
//  Adjust_CurveView.m
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/4/24.
//

#import "Adjust_CurveView.h"
#import "VEColorButton.h"
#import "VECustomButton.h"
#import "VEHelp.h"
#import "VEColorButton.h"

@interface Adjust_CurveGraphView ()

@end

@implementation Adjust_CurveGraphView

- (instancetype)initWithFrame:(CGRect)frame points:(NSMutableArray *)points lineColor:(UIColor *)color {
    if (self = [super initWithFrame:frame]) {
        self.points = points;
        _lineColor = color;
        
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:singleTap];
    }
    
    return self;
}

- (void)setPoints:(NSMutableArray<NSMutableArray *> *)points {
    _points = points;
    if (!_rgbPoints) {
        _rgbPoints = [NSMutableArray array];
    }else {
        [_rgbPoints removeAllObjects];
    }
    for (int i = 0; i < _points.count; i = i + 3) {
        CGPoint point = [_points[i] CGPointValue];
        if (i == 0 && [_points[3] CGPointValue].x == 0)
        {
            continue;
        }
        [_rgbPoints addObject:_points[i]];
        if (i == _points.count - 1 - 3
            && point.x == 1)
        {
            break;
        }
    }
}

-(void)drawRect:(CGRect)rect
{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CAShapeLayer * grapLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint prePoint = CGPointZero;
    CGPoint nowPoint;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < _rgbPoints.count; i++) {
        CGPoint point = [_rgbPoints[i] CGPointValue];
        CGFloat x = point.x;
        CGFloat y = point.y;

        x = x * self.frame.size.width;
        y = y * self.frame.size.height;
        
        if( i == 0 )
        {
            prePoint = point;
            [path moveToPoint:CGPointMake(x, self.frame.size.height - y)];
            
            [array addObject:[NSValue valueWithCGPoint:CGPointZero]];
            if (!CGPointEqualToPoint(point, CGPointZero)) {
                CGPoint point1;
                CGPoint point2;
                [self getControlPoint1:&point1 controlPoint2:&point2 prevPoint:CGPointZero currentPoint:point];
                [array addObject:[NSValue valueWithCGPoint:point1]];
                [array addObject:[NSValue valueWithCGPoint:point2]];
                [array addObject:[NSValue valueWithCGPoint:point]];
            }
        }
        else{
            nowPoint = CGPointMake(x, y);
            CGPoint point1;
            CGPoint point2;
            [self getControlPoint1:&point1 controlPoint2:&point2 prevPoint:prePoint currentPoint:point];
            [array addObject:[NSValue valueWithCGPoint:point1]];
            [array addObject:[NSValue valueWithCGPoint:point2]];
            [array addObject:[NSValue valueWithCGPoint:point]];
            
            point1 = CGPointMake(point1.x * self.frame.size.width, self.frame.size.height - point1.y * self.frame.size.height);
            point2 = CGPointMake(point2.x * self.frame.size.width, self.frame.size.height - point2.y * self.frame.size.height);
            [path addCurveToPoint:CGPointMake(x, self.frame.size.height - y) controlPoint1:point1 controlPoint2:point2];
            prePoint = point;
            
            if (i == _rgbPoints.count - 1 && !CGPointEqualToPoint(point, CGPointMake(1.0, 1.0))) {
                CGPoint point1;
                CGPoint point2;
                [self getControlPoint1:&point1 controlPoint2:&point2 prevPoint:point currentPoint:CGPointMake(1.0, 1.0)];
                [array addObject:[NSValue valueWithCGPoint:point1]];
                [array addObject:[NSValue valueWithCGPoint:point2]];
                [array addObject:[NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)]];
            }
        }
    }
    
    [_points removeAllObjects];
    [_points addObjectsFromArray:array];
//    NSLog(@"rgb:%@", _rgbPoints);
//    NSLog(@"_points:%@",_points);
//    NSLog(@"rgbCount:%ld pointsCount:%ld", _rgbPoints.count, _points.count);
    
    grapLayer.path = path.CGPath;
    grapLayer.strokeColor = _lineColor.CGColor;
    grapLayer.fillColor = nil;
    // 默认设置路径宽度为0，使其在起始状态下不显示
    grapLayer.lineWidth = 1.0;
    [self.layer addSublayer:grapLayer];
}

- (void)handleSingleTap:(UIGestureRecognizer *)recognizer
{
//    CGPoint tapLocation = [recognizer locationInView:self];
//    if (![path containsPoint:tapLocation]) {
//        return;
//    }
    CGPoint currentPoint = [recognizer locationInView:self];
    float x = currentPoint.x / self.frame.size.width;
    float y = 1.0 - currentPoint.y / self.frame.size.height;
    CGPoint point = CGPointMake(x, y);
    if (![_rgbPoints containsObject:[NSValue valueWithCGPoint:currentPoint]]) {
        NSInteger index = 0;
        for (int i = 0; i < _rgbPoints.count; i++) {
            CGPoint itemPoint = [_rgbPoints[i] CGPointValue];
            if( x < itemPoint.x )
            {
                index = i;
                break;
            }
        }
        if (index == 1 && !CGPointEqualToPoint(self.superview.subviews[1].frame.origin, CGPointMake(0, self.frame.size.height))) {
            [_rgbPoints replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:CGPointMake(0, point.y)]];
        }
        else if (index == _rgbPoints.count - 1 && !CGPointEqualToPoint([_rgbPoints.lastObject CGPointValue], CGPointMake(1, 1))) {
            [_rgbPoints replaceObjectAtIndex:(_rgbPoints.count - 1) withObject:[NSValue valueWithCGPoint:CGPointMake(1.0, point.y)]];
        }
        [_rgbPoints insertObject:[NSValue valueWithCGPoint:point] atIndex:index];
        
        [self drawRect:self.frame];
        if (_delegate && [_delegate respondsToSelector:@selector(addPoint:index:graphView:)]) {
            [_delegate addPoint:point index:index graphView:self];
        }
    }
}

- (void)getControlPoint1:(CGPoint *)controlPoint1
           controlPoint2:(CGPoint *)controlPoint2
               prevPoint:(CGPoint)prevPoint
            currentPoint:(CGPoint)currentPoint
{
    if (_rgbPoints.count == 2) {
        *controlPoint1 = CGPointMake(0.3, 0.3);
        *controlPoint2 = CGPointMake(0.6, 0.6);
    }else {
        *controlPoint1 = CGPointMake((prevPoint.x+currentPoint.x)/2.0, prevPoint.y);
        *controlPoint2 = CGPointMake((prevPoint.x+currentPoint.x)/2.0, currentPoint.y);
    }
}

@end

@interface Adjust_CurveView ()<Adjust_CurveGraphViewDelegate, VECustomButtonDelegate>
{
    NSArray *_colorArray;
    NSInteger _colorIndex;
    UIScrollView *_colorScrollView;
    NSMutableArray <Adjust_CurveGraphView *>*_graphViews;
    VECustomButton *_selectedBtn;
    float _rectInset;
    UILabel *_pointLbl;
    NSMutableArray *_rgbPoints;
}

@end

@implementation Adjust_CurveView

- (instancetype)initWithFrame:(CGRect)frame points:(NSMutableArray *)points
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : [VEConfigManager sharedManager].viewBackgroundColor;
        _points = points;
        
        UIView *toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        [self addSubview:toolbarView];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:toolbarView.bounds];
        titleLbl.text = VELocalizedString(@"曲线", nil);
        titleLbl.textColor = SUBTITLETEXT_COLOR;
        if([VEConfigManager sharedManager].toolsTitleColor){
            titleLbl.textColor = [VEConfigManager sharedManager].toolsTitleColor;
        }
        titleLbl.font = [UIFont boldSystemFontOfSize:[VEConfigManager sharedManager].iPad_HD ? 17 : 14];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        [toolbarView addSubview:titleLbl];
        
        UIButton *resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 80, 44)];
        [resetBtn setTitle:VELocalizedString(@"重置", nil) forState:UIControlStateNormal];
        resetBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [resetBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [resetBtn setTitleColor:DISABLED_COLOR forState:UIControlStateDisabled];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [resetBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
            [resetBtn setTitleColor:UIColorFromRGB(0x727272) forState:UIControlStateDisabled];
        }
        [resetBtn addTarget:self action:@selector(resetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if([VEConfigManager sharedManager].iPad_HD){
            resetBtn.frame = CGRectMake(5, (CGRectGetHeight(self.frame) - 40), 80, 40);
            [resetBtn setImage:[VEHelp imageNamed:@"ipad_Reset_normal"] forState:UIControlStateNormal];
            [resetBtn setImage:[VEHelp imageNamed:@"ipad_Reset_selected"] forState:UIControlStateDisabled];
            [self addSubview:resetBtn];
        }else{
            [resetBtn setImage:[VEHelp imageNamed:@"剪辑_重置默认_"] forState:UIControlStateNormal];
            [resetBtn setImage:[VEHelp imageNamed:@"剪辑_重置选中_"] forState:UIControlStateDisabled];
            [toolbarView addSubview:resetBtn];
        }
        
        UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        finishBtn.frame = CGRectMake(CGRectGetWidth(toolbarView.frame) - 49, 0, 44, 44);
        [finishBtn setImage:[VEHelp imageNamed:@"RoundDownArrow_"] forState:UIControlStateNormal];
        [finishBtn addTarget:self action:@selector(finishBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [toolbarView addSubview:finishBtn];
        
        UIScrollView *colorScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(toolbarView.frame), frame.size.width, 44)];
        colorScrollView.showsVerticalScrollIndicator = NO;
        colorScrollView.showsHorizontalScrollIndicator = NO;
        _colorScrollView = colorScrollView;
        [self addSubview:colorScrollView];
        
        _colorArray = [VEHelp getToningCurveColorArray];
        _colorIndex = 1;
        
        UIView *curveView = [[UIView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(colorScrollView.frame), self.frame.size.width - 24, self.frame.size.height - CGRectGetMaxY(colorScrollView.frame) - 35)];
        [self addSubview:curveView];
        
        _rectInset = 8.0;
        _pointLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(curveView.frame), curveView.frame.size.width, 15)];
        _pointLbl.textColor = TEXT_COLOR;
        if([VEConfigManager sharedManager].toolsTitleColor){
            _pointLbl.textColor = [VEConfigManager sharedManager].toolsTitleColor;
        }
        _pointLbl.font = [UIFont systemFontOfSize:12];
        _pointLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_pointLbl];
        
        UIView *boxView = [[UIView alloc] initWithFrame:CGRectInset(curveView.bounds, _rectInset, _rectInset)];
        boxView.layer.borderColor = UIColorFromRGB(0x3a3a3a).CGColor;
        boxView.layer.borderWidth = 1.0;
        [curveView addSubview:boxView];
        
        for (int i = 1; i < 4; i++) {
            UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(_rectInset, _rectInset + i * (boxView.frame.size.height - 3) / 4.0, boxView.frame.size.width, 1)];
            verticalLine.backgroundColor = UIColorFromRGB(0x3a3a3a);
            [curveView addSubview:verticalLine];
            
            UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(_rectInset + i * (boxView.frame.size.width - 3) / 4.0, 8, 1, boxView.frame.size.height)];
            horizontalLine.backgroundColor = UIColorFromRGB(0x3a3a3a);
            [curveView addSubview:horizontalLine];
        }
        
        UIView *curveGraphView = [[UIView alloc] initWithFrame:curveView.bounds];
        [curveView addSubview:curveGraphView];
        
        _graphViews = [NSMutableArray array];
        float width = 26.0;
        float space = 25;
        float x = (colorScrollView.frame.size.width - ((width + space) * _colorArray.count - space)) / 2.0;
        float y = (colorScrollView.frame.size.height - width) / 2.0;
        for (int i = 0; i < _colorArray.count; i++) {
            VEColorButton *itemBtn = [[VEColorButton alloc] initWithFrame:CGRectMake(x + (width + space) * i, y, width, width)];
            itemBtn.backgroundColor = _colorArray[i];
            itemBtn.tag = i + 1;
            [itemBtn addTarget:self action:@selector(colorItemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                itemBtn.selected = YES;
            }
            [colorScrollView addSubview:itemBtn];
            
            UIView *itemView = [[UIView alloc] initWithFrame:curveGraphView.bounds];
            if (i > 0) {
                if ([VEHelp isRGBCurveInitialValue:_points[i]]) {
                    itemView.alpha = 0;
                }else {
                    itemView.alpha = 0.2;
                }
            }
            itemView.tag = i + 1;
            [curveGraphView insertSubview:itemView atIndex:0];
            
            Adjust_CurveGraphView *graphView = [[Adjust_CurveGraphView alloc] initWithFrame:CGRectInset(itemView.bounds, _rectInset, _rectInset) points:_points[i] lineColor:(i == 0 ? Main_Color : itemBtn.backgroundColor)];
            graphView.delegate = self;
            [itemView addSubview:graphView];
            [_graphViews addObject:graphView];
            
            [self refreshCustomBtnWithGraphView:graphView selectedIndex:-1];
        }
    }
    
    return self;
}

- (void)refreshCustomBtnWithGraphView:(Adjust_CurveGraphView *)graphView selectedIndex:(NSInteger)selectedIndex {
    NSInteger tag = 1;
    for (int j = 0; j < graphView.rgbPoints.count; j++) {
        CGPoint point = [graphView.rgbPoints[j] CGPointValue];
        if (j == 0
            && ((!CGPointEqualToPoint(point, CGPointZero)) || [graphView.rgbPoints[1] CGPointValue].y == 0))
        {
            continue;
        }
        if (j == graphView.rgbPoints.count - 1
            && (!CGPointEqualToPoint(point, CGPointMake(1, 1))
                || [graphView.rgbPoints[graphView.rgbPoints.count - 2] CGPointValue].x == 1
                || [graphView.rgbPoints[graphView.rgbPoints.count - 2] CGPointValue].y == 1))
        {
            break;
        }
        VECustomButton * btn = [[VECustomButton alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
        btn.center = CGPointMake(graphView.frame.origin.x + point.x * graphView.frame.size.width, graphView.frame.origin.y + graphView.frame.size.height - point.y * graphView.frame.size.height);
        if ([VEHelp colorIsEqual:graphView.lineColor color2:_colorArray.firstObject]) {
            btn.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : [VEConfigManager sharedManager].viewBackgroundColor;
        }else {
            btn.backgroundColor = [UIColor whiteColor];
        }
        btn.layer.cornerRadius = btn.frame.size.height/2.0;
        btn.layer.borderColor = graphView.lineColor.CGColor;
        btn.layer.borderWidth = btn.frame.size.width/2.0;
        btn.layer.masksToBounds = YES;
        btn.object = [NSValue valueWithCGPoint:point];
        btn.delegate = self;
        [btn set_Recognizer];
        btn.tag = tag++;
        [graphView.superview addSubview:btn];
        if (selectedIndex > 0 && j == selectedIndex) {
            btn.selected = YES;
            _selectedBtn = btn;
        }
    }
}

- (void)resetBtnAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:VELocalizedString(@"Do you want to reset all current adjustments?", nil) preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:VELocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:nil]];
    WeakSelf(self);
    [alert addAction:[UIAlertAction actionWithTitle:VELocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf reset];
    }]];
    
    [[VEHelp getCurrentViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)reset {
    for (NSMutableArray *points in _points) {
        [points removeAllObjects];
        [points addObject:[NSValue valueWithCGPoint:CGPointZero]];
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(0.3, 0.3)]];
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(0.6, 0.6)]];
        [points addObject:[NSValue valueWithCGPoint:CGPointMake(1, 1)]];
    }
    for (int i = 0; i < _graphViews.count; i++) {
        Adjust_CurveGraphView *graphView = _graphViews[i];
        graphView.points = _points[i];
        
        UIView *superview = graphView.superview;
        [superview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [superview addSubview:graphView];
        [graphView drawRect:graphView.frame];
                
        [self refreshCustomBtnWithGraphView:graphView selectedIndex:-1];
    };
    if (_delegate && [_delegate respondsToSelector:@selector(resetAdjustCurve:)]) {
        [_delegate resetAdjustCurve:self];
    }
}

- (void)finishBtnAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(completionAdjustCurve:)]) {
        [_delegate completionAdjustCurve:self];
    }
}

- (void)colorItemBtnAction:(UIButton *)sender {
    if (!sender.selected) {
        VEColorButton *prevBtn = [sender.superview viewWithTag:_colorIndex];
        prevBtn.selected = NO;
                
        Adjust_CurveGraphView *prevGraphView = _graphViews[_colorIndex - 1];
        if ([VEHelp isRGBCurveInitialValue:prevGraphView.points]) {
            prevGraphView.superview.alpha = 0;
        }else {
            prevGraphView.superview.alpha = 0.2;
        }
        
        if (_selectedBtn) {
            _selectedBtn.selected = NO;
        }
        
        sender.selected = YES;
        _colorIndex = sender.tag;
        
        Adjust_CurveGraphView *graphView = _graphViews[_colorIndex - 1];
        graphView.superview.alpha = 1.0;
        [graphView.superview.superview bringSubviewToFront:graphView.superview];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = graphView.superview.bounds;
        if(_colorIndex == 1){
            gradient.colors = @[(id)[Main_Color colorWithAlphaComponent:0.3].CGColor, (id)[UIColor clearColor].CGColor];
        }else{
            gradient.colors = @[(id)[sender.backgroundColor colorWithAlphaComponent:0.3].CGColor, (id)[UIColor clearColor].CGColor];
        }
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 1);
        [graphView.superview.layer insertSublayer:gradient atIndex:0];
        
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionFade;
        animation.duration = 1.0;

        // Add the animation to the gradient layer
        [gradient addAnimation:animation forKey:@"removeGradient"];

        // Remove the gradient layer after the animation completes
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [gradient removeFromSuperlayer];
        });
    }
}

#pragma mark - Adjust_CurveGraphViewDelegate
- (void)addPoint:(CGPoint)point index:(NSInteger)index graphView:(Adjust_CurveGraphView *)graphView {
    if (_selectedBtn) {
        _selectedBtn.selected = NO;
    }
    UIView *superview = graphView.superview;
    [superview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [superview addSubview:graphView];
    
    [self refreshCustomBtnWithGraphView:graphView selectedIndex:index];
    
    [self refreshPointLblWithBtn:_selectedBtn graphView:graphView];
    if (_delegate && [_delegate respondsToSelector:@selector(changingAdjustCurve)]) {
        [_delegate changingAdjustCurve];
    }
}

#pragma mark - VECustomButtonDelegate
- (void)custom_moveGesture:(UIGestureRecognizer *)recognizer atBtn:(VECustomButton *)btn {
    Adjust_CurveGraphView *graphView = btn.superview.subviews.firstObject;
    if (!btn.selected) {
        if (_selectedBtn) {
            _selectedBtn.layer.borderWidth = _selectedBtn.frame.size.width / 2.0;
            _selectedBtn.selected = NO;
        }
        btn.layer.borderWidth = 4.0;
        btn.selected = YES;
        _selectedBtn = btn;
    }
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        NSMutableArray *rgb = graphView.rgbPoints;
        CGPoint currentPoint = [recognizer locationInView:graphView];
        CGPoint point = CGPointMake(currentPoint.x / graphView.frame.size.width, 1.0 - currentPoint.y / graphView.frame.size.height);
        point.y = MAX(0, point.y);
        point.y = MIN(1.0, point.y);
        
        if (btn.tag > 1 && btn != btn.superview.subviews.lastObject) {
            UIButton *prevBtn = btn.superview.subviews[btn.tag - 1];
            if(currentPoint.x <= (prevBtn.frame.origin.x + prevBtn.frame.size.width))
            {
                point.x = CGRectGetMaxX(prevBtn.frame) / graphView.frame.size.width;
            }
            else if( btn.tag < (rgb.count - 1) && currentPoint.x >= btn.superview.subviews[btn.tag + 1].frame.origin.x)
            {
                point.x = btn.superview.subviews[btn.tag + 1].frame.origin.x / graphView.frame.size.width;
            }
            point.x = MAX(0, point.x);
            point.x = MIN(1.0, point.x);
            
            VECustomButton *firstBtn = btn.superview.subviews[1];
            if (CGPointEqualToPoint([firstBtn.object CGPointValue], CGPointZero)) {
                [rgb replaceObjectAtIndex:(btn.tag - 1) withObject:[NSValue valueWithCGPoint:point]];
            }else {
                [rgb replaceObjectAtIndex:btn.tag withObject:[NSValue valueWithCGPoint:point]];
            }
        }
        else {
            if(btn.tag == 1 && currentPoint.x >= btn.superview.subviews[btn.tag + 1].frame.origin.x)
            {
                point.x = btn.superview.subviews[btn.tag + 1].frame.origin.x / graphView.frame.size.width;
            }
            else if (btn == btn.superview.subviews.lastObject)
            {
                UIButton *prevBtn = btn.superview.subviews[btn.tag - 1];
                if(currentPoint.x <= (prevBtn.frame.origin.x + prevBtn.frame.size.width)) {
                    point.x = CGRectGetMaxX(prevBtn.frame) / graphView.frame.size.width;
                }
            }
            point.x = MAX(0, point.x);
            point.x = MIN(1.0, point.x);
            if (btn.tag == 1) {
                CGPoint firstPoint = [rgb.firstObject CGPointValue];
                if (CGPointEqualToPoint(point, CGPointZero)) {
                    if (!CGPointEqualToPoint(firstPoint, [btn.object CGPointValue]))
                    {
                        btn.object = [NSValue valueWithCGPoint:point];
                        [rgb replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:CGPointZero]];
                        [rgb removeObjectAtIndex:1];
                    }
                }else {
                    firstPoint.y = point.y;
                    [rgb replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:firstPoint]];
                    
                    if (CGPointEqualToPoint([btn.object CGPointValue], CGPointZero))
                    {
                        [rgb insertObject:[NSValue valueWithCGPoint:point] atIndex:1];
                        btn.object = [NSValue valueWithCGPoint:point];
                    }else {
                        [rgb replaceObjectAtIndex:1 withObject:[NSValue valueWithCGPoint:point]];
                    }
                }
            }
            else if (btn == btn.superview.subviews.lastObject) {
                CGPoint lastPoint = [rgb.lastObject CGPointValue];
                if (CGPointEqualToPoint(point, CGPointMake(1, 1))) {
                    if (!CGPointEqualToPoint(lastPoint, [btn.object CGPointValue]))
                    {
                        btn.object = [NSValue valueWithCGPoint:point];
                        [rgb replaceObjectAtIndex:(rgb.count - 1) withObject:[NSValue valueWithCGPoint:CGPointMake(1, 1)]];
                        [rgb removeObjectAtIndex:(rgb.count - 2)];
                    }
                }else {
                    lastPoint.y = point.y;
                    [rgb replaceObjectAtIndex:(rgb.count - 1) withObject:[NSValue valueWithCGPoint:lastPoint]];
                    
                    if (CGPointEqualToPoint([btn.object CGPointValue], CGPointMake(1, 1)))
                    {
                        [rgb insertObject:[NSValue valueWithCGPoint:point] atIndex:(rgb.count - 1)];
                        btn.object = [NSValue valueWithCGPoint:point];
                    }else {
                        [rgb replaceObjectAtIndex:(rgb.count - 2) withObject:[NSValue valueWithCGPoint:point]];
                    }
                }
            }
        }
        [graphView drawRect:graphView.frame];
        btn.center = CGPointMake(graphView.frame.origin.x + point.x * graphView.frame.size.width, graphView.frame.origin.y + graphView.frame.size.height - point.y * graphView.frame.size.height);
        
        if (_delegate && [_delegate respondsToSelector:@selector(changingAdjustCurve)]) {
            [_delegate changingAdjustCurve];
        }
    }
    [self refreshPointLblWithBtn:btn graphView:graphView];
}

- (void)refreshPointLblWithBtn:(VECustomButton *)btn graphView:(Adjust_CurveGraphView *)graphView {
    CGPoint colorPoint = CGPointMake(btn.frame.origin.x / graphView.frame.size.width, (graphView.frame.size.height - btn.frame.origin.y) / graphView.frame.size.height);
    colorPoint = CGPointMake(colorPoint.x * 255.0, colorPoint.y * 255.0);
    _pointLbl.text = [NSString stringWithFormat:@"(%.f，%.f)", colorPoint.x, colorPoint.y];
}

@end
