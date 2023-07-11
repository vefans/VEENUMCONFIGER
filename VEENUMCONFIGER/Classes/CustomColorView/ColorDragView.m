//
//  ColorDragView.m
//  PEImageInfo
//
//  Created by emmet-mac on 2023/4/23.
//

#import "ColorDragView.h"
#import "VEHelp.h"
#import "CustomColorView.h"
@interface ColorDragView(){
}
@end
@implementation ColorDragView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self initFocusView];
    }
    return self;
}
- (void)initFocusView{
    _focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    _focusView.backgroundColor = [UIColor clearColor];
    for (int i = 0; i<4; i++) {
        UIView *itemView = [[UIView alloc] init];
        switch (i) {
            case 0:
            {
                itemView.frame = CGRectMake(CGRectGetWidth(_focusView.frame)/2.0 - 1, 0, 2, 4);
            }
                break;
            case 1:
            {
                itemView.frame = CGRectMake(0, CGRectGetWidth(_focusView.frame)/2.0 - 1, 4, 2);
            }
                break;
            case 2:
            {
                itemView.frame = CGRectMake(CGRectGetWidth(_focusView.frame) - 4, CGRectGetWidth(_focusView.frame)/2.0 - 1, 4, 2);
            }
                break;
            case 3:
            {
                itemView.frame = CGRectMake(CGRectGetWidth(_focusView.frame)/2.0 - 1, CGRectGetWidth(_focusView.frame) - 4, 2, 4);
            }
                break;
            default:
                break;
        }
        itemView.backgroundColor = [UIColor whiteColor];
        [_focusView addSubview:itemView];
    }
    [self addSubview:_focusView];
    _focusView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    
    _strawLayer = [[CALayer alloc] init];
    _strawLayer.frame = CGRectMake(0, 0, 31, 38);
    _strawLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _strawLayer.contents = (id)([VEHelp imageNamed:@"颜色-选取2" atBundle:[VEHelp getBundleName:@"VEEditSDK"]].CGImage);
    UIImage*maskingImage =[VEHelp imageNamed:@"颜色-选取1" atBundle:[VEHelp getBundleName:@"VEEditSDK"]];
    CALayer*maskingLayer =[CALayer layer];
    maskingLayer.frame = _strawLayer.bounds;
    [maskingLayer setContents:(id)[maskingImage CGImage]];
    [_strawLayer setMask:maskingLayer];
    __block typeof(self) bself = self;
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    //[window.layer addSublayer:bself->_strawLayer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(bself->_strawLayer.superlayer){
            CGRect rect = [bself->_focusView convertRect:bself->_focusView.bounds toView:window];
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
            bself->_strawLayer.position = CGPointMake(CGRectGetMidX(rect) + 15 - bself->_strawLayer.frame.size.width/2.0, rect.origin.y - bself->_strawLayer.frame.size.height/2.0);
            [CATransaction commit];
        }
    });
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([_delegate respondsToSelector:@selector(changeDragViewColor: isDragEnd:)]){
        UIImage *image = [self imageFromLayer:self.headerLayer];
        UIColor *color = [VEHelp colorAtPixel:CGPointMake(_focusView.center.x, _focusView.center.y) source:image];
        [_delegate changeDragViewColor:color isDragEnd:YES];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint center = [[touches anyObject] locationInView:self];
    _focusView.center = CGPointMake(MAX(MIN(center.x, self.frame.size.width - 1), 1), MIN(MAX(center.y, 1), self.frame.size.height - 1));
    [self setdefaultColor:event];
}
- (void)setdefaultColor:(UIEvent *)event{
    if(!event){
        _focusView.center = CGPointMake(1, 1);
    }
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[_focusView convertRect:_focusView.bounds toView:window];
    CGPoint position = CGPointMake(CGRectGetMidX(rect) + 15 - _strawLayer.frame.size.width/2.0, rect.origin.y - _strawLayer.frame.size.height/2.0);
    CGRect frame = _strawLayer.frame;
    frame.origin.x = position.x - frame.size.width/2.0;
    frame.origin.y = position.y - frame.size.height/2.0;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _strawLayer.frame = frame;
    [CATransaction commit];
    [self resetColor];
}
- (void)resetColor{
    UIImage *image = [self imageFromLayer:self.headerLayer];
//    UIColor *color = [VEHelp colorAtPixel:CGPointMake(_focusView.center.x, _focusView.center.y) source:image];
    float saturation = (_focusView.center.x/self.frame.size.width - 0.1)/0.9;
    float brightness = (1.0 - _focusView.center.y/self.frame.size.height)/0.9;
    float hue = 1.0 - ((CustomColorView*)_delegate).moreColorSlider.value;
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    
    _strawLayer.backgroundColor = color.CGColor;
    if([_delegate respondsToSelector:@selector(changeDragViewColor: isDragEnd:)]){
        [_delegate changeDragViewColor:color isDragEnd:NO];
    }
}
- (UIImage *)imageFromLayer:(CALayer *)layer
{

    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);

    [layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return outputImage;

}

- (UIColor *)colorFromLayer:(CALayer *)layer

{

    UIGraphicsBeginImageContextWithOptions(layer.frame.size, NO, 0);

    [layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return [UIColor colorWithPatternImage:outputImage];

}


-(void)setFocusViewCenter:( CGPoint ) point
{
    _focusView.center = point;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[_focusView convertRect:_focusView.bounds toView:window];
    CGPoint position = CGPointMake(CGRectGetMidX(rect) + 15 - _strawLayer.frame.size.width/2.0, rect.origin.y - _strawLayer.frame.size.height/2.0);
    CGRect frame = _strawLayer.frame;
    frame.origin.x = position.x - frame.size.width/2.0;
    frame.origin.y = position.y - frame.size.height/2.0;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _strawLayer.frame = frame;
    [CATransaction commit];
    [self resetColor];
}
@end
