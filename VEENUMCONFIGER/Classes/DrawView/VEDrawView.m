//
//  VEDrawView.m
//  12
//
//  Created by iOS VESDK Team on 2017/5/22.
//  Copyright © 2017年 iOS VESDK Team. All rights reserved.
//

#import "VEDrawView.h"
#import <VEENUMCONFIGER/VEENUMCONFIGER.h>

@interface VEDrawView()
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *lineColor;
@end

@implementation VEDrawView

+ (VEDrawView *)initWithImage:(UIImage *)image frame:(CGRect)frame lineWidth:(CGFloat)lineWidth lineColor:(UIColor *)lineColor {
    VEDrawView *backGourp = [[VEDrawView alloc] initWithFrame:frame];
    backGourp.frame = frame;
    backGourp.image = image;
    backGourp.lineColor = lineColor;
    backGourp.lineWidth = lineWidth;
    return backGourp;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self addControl];
        _isCallback = false;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addControl];
    }
    return self;
}

//添加控件
- (void)addControl {
    VEDrawTouchPointView *draw = [[VEDrawTouchPointView alloc] initWithFrame:self.bounds];
    _drawView = draw;
    _drawView.canDrawLine = YES;
    
    //_drawView.layer.borderColor = [UIColor grayColor].CGColor;
    //_drawView.layer.borderWidth = 1;
    [self addSubview:_drawView];
    self.userInteractionEnabled = YES;
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setStrokeColor:lineColor];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setStrokeWidth:lineWidth];
}
- (float)LineWidth
{
    return _lineWidth;
}

/** 清屏 */
- (void)clearScreen {
    [_drawView clearScreen];
//    [self alterDrawBoardDescLabel:nil];
}

/** 撤消操作 */
- (void)revokeScreen {
    [_drawView revokeScreen];
}

/** 擦除 */
- (void)eraseSreen {
    [_drawView eraseSreen];
}
/**箭头*/
- (void)setDoodleType:(VEDoodleType)doodleType {
    _doodleType = doodleType;
    _drawView.doodleType = doodleType;
}

/** 设置画笔颜色 */
- (void)setStrokeColor:(UIColor *)lineColor {
    _strokeColor = lineColor;
    [_drawView setStrokeColor:lineColor];
}
-(UIColor *)StrokeColor
{
    return _strokeColor;
}

/** 设置画笔大小 */
- (void)setStrokeWidth:(CGFloat)lineWidth {
    [_drawView setStrokeWidth:lineWidth];
}


- (void)alterDrawBoardDescLabel:(UILabel *)content {
    if(_delegate && [_delegate respondsToSelector:@selector(showAlertView:)]) {
        __block UILabel *label = content;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:VELocalizedString(@"输入文字内容", nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:VELocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        WeakSelf(self);
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:VELocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            StrongSelf(self);
            if(!label){
                label = [[UILabel alloc] init];
                label.userInteractionEnabled = YES;
                label.frame = CGRectMake(self.drawView.center.x - 60, self.drawView.center.x - 25, 120, 50);
                label.font = [UIFont systemFontOfSize:(20 + self.lineWidth)];
                label.numberOfLines = 0;
                label.adjustsFontForContentSizeCategory = YES;
                label.textColor = self.strokeColor;
                label.backgroundColor = [UIColor clearColor];
                UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:strongSelf action:@selector(tapgesture:)];
                [label addGestureRecognizer:tapgesture];
                UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:strongSelf action:@selector(panGesture:)];
                [label addGestureRecognizer:panGesture];
                [strongSelf addSubview:label];
                [self.drawView.textDescs addObject:label];
            }
            
            
            label.text = alertController.textFields.firstObject.text;
            label.textColor = self.strokeColor;
            
            CGSize size = [label.text boundingRectWithSize:CGSizeMake(strongSelf.bounds.size.width, strongSelf.bounds.size.height)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName : label.font}
                                                          context:nil].size;
            label.bounds = CGRectMake(0, 0, size.width, size.height);
            label.center = CGPointMake((strongSelf.frame.size.width)/2.0, self.drawView.touchupCurrentPoint.y);
            
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = VELocalizedString(@"请输入!", nil);
            textField.text = label.text;
        }];
        
        [_delegate showAlertView:alertController];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gesture{
    if(_drawView.canDrawLine){
        return;
    }
    CGPoint pt = [gesture translationInView:self];
    gesture.view.center = CGPointMake(gesture.view.center.x + pt.x , gesture.view.center.y + pt.y);
    //每次移动完，将移动量置为0，否则下次移动会加上这次移动量
    [gesture setTranslation:CGPointMake(0, 0) inView:self];
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"pan.view == %f", gesture.view.center.x);
    }
    
}
- (void)tapgesture:(UITapGestureRecognizer *)gesture{
    if(_drawView.canDrawLine){
        return;
    }
//    UILabel *label = (UILabel *)gesture.view;
//    [self alterDrawBoardDescLabel:label];
    
}

/** 获取图片 */
- (UIImage *)getImage {
    //return  [_drawView snapsHotView];
    
    
    //1.开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    //2.把画板上的内容渲染到上下文当中
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    self.layer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0].CGColor;
    [self.layer renderInContext:ctx];
    //3.从上下文当中取出一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();


    //4.关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (BOOL)isHasContent {
    __block BOOL isHasContent = NO;
    for (VEDWStroke *strok in _drawView.stroks) {
        if (!CGColorEqualToColor(strok.lineColor.CGColor, [UIColor clearColor].CGColor)) {
            isHasContent = YES;
            break;
        }
    }
    return isHasContent;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end


@interface VEDrawTouchPointView () {
    CGMutablePathRef currentPath;
    
    VEDWStroke * currentStroke;
}


@property (nonatomic, assign) BOOL isEarse;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation VEDrawTouchPointView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!_canDrawLine){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        _touchupCurrentPoint = point;
        return;
    }else{
        _touchupCurrentPoint = CGPointZero;
    }
    currentPath = CGPathCreateMutable();
    VEDWStroke *stroke = [[VEDWStroke alloc] init];
    stroke.filletWidth = 5.0;
    stroke.path = currentPath;
    stroke.blendMode = _isEarse ? kCGBlendModeDestinationIn : kCGBlendModeNormal;
    stroke.strokeWidth = _lineWidth;
    stroke.lineColor = _isEarse ? [UIColor clearColor] : _lineColor;
    stroke.doodleType = _doodleType;
    currentStroke = stroke;
    [_stroks addObject:stroke];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(_doodleType != VEDoodleType_pencil)
    {
        currentStroke.beganPoint = point;
        currentStroke.endPoint = point;
    }
    else
        CGPathMoveToPoint(currentPath, NULL, point.x, point.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!_canDrawLine){
        if([self.superview respondsToSelector:@selector(alterDrawBoardDescLabel:)]){
            [self.superview performSelector:@selector(alterDrawBoardDescLabel:) withObject:nil];
        }
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(_doodleType != VEDoodleType_pencil){
        currentStroke.endPoint = point;
    }
    else
        CGPathAddLineToPoint(currentPath, NULL, point.x, point.y);
    [self setNeedsDisplay];
}



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _textDescs = [[NSMutableArray alloc] init];
        _stroks = [[NSMutableArray alloc] initWithCapacity:1];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (VEDWStroke *stroke in _stroks) {
        [stroke strokeWithContext:context];
    }
    
}


- (void)dealloc {
    NSLog(@"%s", __func__);
    CGPathRelease(currentPath);
}

/** 清屏 */
- (void)clearScreen {
    _isEarse = NO;
    [_stroks removeAllObjects];
    [self setNeedsDisplay];
}

/** 撤消操作 */
- (void)revokeScreen {
    _isEarse = NO;
    if(_canDrawLine){
        [_stroks removeLastObject];
    }else{
        [[_textDescs lastObject] removeFromSuperview];
        [_textDescs removeLastObject];
    }
    [self setNeedsDisplay];
}
- (void)setDoodleType:(VEDoodleType)doodleType {
    _doodleType = doodleType;
    _isEarse = NO;
}

/** 擦除 */
- (void)eraseSreen {
    self.isEarse = YES;
    _doodleType = VEDoodleType_pencil;
}
/** 设置画笔颜色 */
- (void)setStrokeColor:(UIColor *)lineColor {
    self.lineColor = lineColor;
    if (CGColorEqualToColor(lineColor.CGColor, [UIColor clearColor].CGColor)) {
        _isEarse = YES;
    }else {
        _isEarse = NO;
    }
    [self setNeedsDisplay];
}
/** 设置画笔大小 */
- (void)setStrokeWidth:(CGFloat)lineWidth {
//    if (CGColorEqualToColor(self.lineColor.CGColor, [UIColor clearColor].CGColor)) {
//        _isEarse = YES;
//    }else {
//        _isEarse = NO;
//    }
    self.lineWidth = lineWidth;
}


- (UIImage *)snapsHotView
{
    // 影响质量
    //    UIGraphicsBeginImageContextWithOptions(view.bounds.size,YES,[UIScreen mainScreen].scale);
    //    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return image;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation VEDWStroke

-(void)setFilletWidth:(CGFloat)filletWidth
{
    _filletWidth = filletWidth;
}

- (void)strokeWithContext:(CGContextRef)context {
    
    if(_doodleType == VEDoodleType_rectangle)
    {
        float x = _beganPoint.x;
        float y = _beganPoint.y;
        float width = _beganPoint.x - _endPoint.x;
        if( width > 0 )
        {
            x = _endPoint.x;
        }
        else{
            width = fabsf(width);
        }
        float height = _beganPoint.y - _endPoint.y;
        if( height > 0 )
        {
            y = _endPoint.y;
        }
        else{
            height = fabsf(height);
        }
        if( width <= 0 )
        {
            width = 0.1;
        }
        if( height == 0 )
        {
            height = 0.1;
        }
        
        CGFloat strokeFiletWidth = _filletWidth;
        if(  (strokeFiletWidth*2.0) > width )
        {
            strokeFiletWidth = width/2.0;
        }
        else if( (strokeFiletWidth*2.0) > height )
        {
            strokeFiletWidth = height/2.0;
        }
//        NSLog(@"filetWidth:%.2f,width:%.2f",strokeFiletWidth,width);
        //颜色的填充
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        //线宽
        CGContextSetLineWidth(context, _strokeWidth);
        CGContextSetStrokeColorWithColor(context, [_lineColor CGColor]);
        CGContextSetBlendMode(context, _blendMode);
        //绘制图像及圆角
        CGContextMoveToPoint(context, x+width, y+strokeFiletWidth * 2);  // 开始坐标右边开始
        CGContextAddArcToPoint(context, x+width, y+height, x+width - 10, y+height, strokeFiletWidth);  // 右下角
        CGContextAddArcToPoint(context, x, y+height, x, y+height - 10, strokeFiletWidth); // 左下角
        CGContextAddArcToPoint(context, x, y, x+strokeFiletWidth * 2, y, strokeFiletWidth); // 左上角
        CGContextAddArcToPoint(context, x+width, y, x+width, y+strokeFiletWidth * 2, strokeFiletWidth); // 右上角
        CGContextAddArcToPoint(context, x+width, y+strokeFiletWidth * 2,  x+width, y+strokeFiletWidth * 2,strokeFiletWidth); // 右上角
        //渲染
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    else if(_doodleType == VEDoodleType_arrow)
    {
        float width = _endPoint.x - _beganPoint.x;
        float height =_endPoint.y - _beganPoint.y;
        float angle = atanf(fabsf(height)/fabsf(width));
        angle = angle * (180.0 / M_PI);
        
        if(  ( height > 0 ) && ( width > 0 ) )
        {
            angle = 360 - angle;
        }
        else if( ( height > 0 ) && ( width < 0 ) )
        {
            angle = 180 + angle;
        }
        else if( ( height < 0 ) && ( width < 0 ) )
        {
            angle = 180 - angle;
        }
        
        NSLog(@"ArrowAngle:%.2f",angle);
        angle = (360 - angle)/(180.0 / M_PI);
        
        
        width =  sqrtf((_beganPoint.x - _endPoint.x)*(_beganPoint.x - _endPoint.x) + (_beganPoint.y - _endPoint.y)*(_beganPoint.y - _endPoint.y));
        height = (width*0.4)*((_strokeWidth/22.0)*0.5+0.5);
        
        NSLog(@"ArrowHeight:%.2f  ArrowWidth:%.2f",height,width);
        
        //颜色的填充
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        //线宽
        CGContextSetLineWidth(context, 0.1);
        CGContextSetStrokeColorWithColor(context, [_lineColor CGColor]);
        CGContextSetFillColorWithColor(context, [_lineColor CGColor]);//填充颜色
        CGContextSetBlendMode(context, _blendMode);
        CGContextMoveToPoint(context, _beganPoint.x, _beganPoint.y);  // 开始坐标右边开始
        
        int count = 8;
        CGPoint sPoints[8];//坐标点
        
        sPoints[0] = CGPointMake(0, 0);//坐标1
        sPoints[1] = CGPointMake(0, height/2.0*0.15);
        sPoints[2] = CGPointMake(width*0.84,height/2.0*0.30);
        sPoints[3] = CGPointMake(width*0.8,  height/2.0*0.7);
        sPoints[4] = CGPointMake(width, 0);
        sPoints[5] = CGPointMake(width*0.8, -height/2.0*0.7);
        sPoints[6] = CGPointMake(width*0.84, -height/2.0*0.30);
        sPoints[7] = CGPointMake(0,-height/2.0*0.15);
        
        for (int i = 0;  i < 8; i++) {
           float x = sPoints[i].x*cosf(angle) - sPoints[i].y*sinf(angle);
           float y = sPoints[i].x*sinf(angle) + sPoints[i].y*cosf(angle);
            NSLog(@"index:%d x:%.2f  y:%.2f",i,x,y);
            sPoints[i] = CGPointMake(_beganPoint.x + x, _beganPoint.y + y);
        }
        CGContextAddLines(context, sPoints, count);//添加线
        
        CGContextClosePath(context);//封起来
        //渲染
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    else{
        CGContextSetStrokeColorWithColor(context, [_lineColor CGColor]);
        CGContextSetLineWidth(context, _strokeWidth);
        CGContextSetBlendMode(context, _blendMode);
        CGContextBeginPath(context);
        CGContextAddPath(context, _path);
        CGContextStrokePath(context);
    }
}

@end

