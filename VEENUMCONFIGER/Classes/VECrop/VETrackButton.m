//
//  VETrackButton.m
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import "VETrackButton.h"
#define VE_TRACK_WIDTH 3

@interface VETrackButton()



@end

@implementation VETrackButton

#pragma mark - 1.Life Cycle

-(instancetype)initWithFrame:(CGRect)frame withCropViewTrackType:(VECropViewTrackType)cropViewTrackType{
    self = [super initWithFrame:frame];
    if (self) {
        self.cropViewTrackType = cropViewTrackType;
        if (cropViewTrackType == VE_TRACK_TOP || cropViewTrackType == VE_TRACK_BOTTOM ||cropViewTrackType == VE_TRACK_LEFT ||cropViewTrackType == VE_TRACK_RIGHT || cropViewTrackType == VE_TRACK_Dewatermark) {
            self.bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:0];
        }else if(cropViewTrackType == VE_TRACK_TOPLEFT){
            self.bezierPath = [UIBezierPath bezierPath];
            [self.bezierPath moveToPoint:CGPointMake(0, 0)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width, 0)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width ,VE_TRACK_WIDTH)];
            [self.bezierPath addLineToPoint:CGPointMake(VE_TRACK_WIDTH, VE_TRACK_WIDTH)];
            [self.bezierPath addLineToPoint:CGPointMake(VE_TRACK_WIDTH, self.frame.size.height)];
            [self.bezierPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
            [self.bezierPath moveToPoint:CGPointMake(0, 0)];
            [self.bezierPath closePath]; // 添加一个结尾点和起点相同
            
        }else if(cropViewTrackType == VE_TRACK_TOPRIGHT){
            
            self.bezierPath = [UIBezierPath bezierPath];
            [self.bezierPath moveToPoint:CGPointMake(0, 0)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width, 0)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width ,self.frame.size.height)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width -VE_TRACK_WIDTH, self.frame.size.height)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width -VE_TRACK_WIDTH, VE_TRACK_WIDTH)];
            [self.bezierPath addLineToPoint:CGPointMake(0, VE_TRACK_WIDTH)];
            [self.bezierPath moveToPoint:CGPointMake(0, 0)];
            [self.bezierPath closePath]; // 添加一个结尾点和起点相同
            
        }else if (cropViewTrackType == VE_TRACK_BOTTOMLEFT){
            
            self.bezierPath = [UIBezierPath bezierPath];
            [self.bezierPath moveToPoint:CGPointMake(0, 0)];
            [self.bezierPath addLineToPoint:CGPointMake(0, self.frame.size.height)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width , self.frame.size.height)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width , self.frame.size.height -VE_TRACK_WIDTH)];
            [self.bezierPath addLineToPoint:CGPointMake(VE_TRACK_WIDTH, self.frame.size.height -VE_TRACK_WIDTH)];
            [self.bezierPath addLineToPoint:CGPointMake(VE_TRACK_WIDTH,0)];
            [self.bezierPath moveToPoint:CGPointMake(0, 0)];
            [self.bezierPath closePath]; // 添加一个结尾点和起点相同
            
            
            
        }else if (cropViewTrackType == VE_TRACK_BOTTOMRIGHT){
            
            self.bezierPath = [UIBezierPath bezierPath];
            [self.bezierPath moveToPoint:CGPointMake(0, self.frame.size.height -VE_TRACK_WIDTH)];
            [self.bezierPath addLineToPoint:CGPointMake( 0, self.frame.size.height)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width , 0)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width -VE_TRACK_WIDTH , 0)];
            [self.bezierPath addLineToPoint:CGPointMake(self.frame.size.width -VE_TRACK_WIDTH, self.frame.size.height -VE_TRACK_WIDTH)];
            [self.bezierPath addLineToPoint:CGPointMake(0,self.frame.size.height -VE_TRACK_WIDTH)];
            [self.bezierPath closePath]; // 添加一个结尾点和起点相同
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    self.shapLayer.path = self.bezierPath.CGPath;
    self.layer.mask =  self.shapLayer;
}

#pragma mark - 2.Setting View and Style

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL res = [super pointInside:point withEvent:event];
    if (res)
    {
        if ([self.bezierPath containsPoint:point])
        {
            CGRect bounds = self.bounds;
            //若原热区小于44x44，则放大热区，否则保持原大小不变
            CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
            CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
            bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
            return CGRectContainsPoint(bounds, point);
        }
        return NO;
    }
    return NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event

{

    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);

if (CGRectContainsPoint(bounds, point)) {

return self;

}else{

return nil;

}

return self;

}



#pragma mark - 3.Request Data

#pragma mark - 4.Custom Methods


#pragma mark - 5.DataSource and Delegate


#pragma mark - 6.Set & Get
-(CAShapeLayer *)shapLayer{
    if (_shapLayer == nil) {
        _shapLayer= [CAShapeLayer layer];
        _shapLayer.strokeColor = Color(255, 255, 255, 1).CGColor;
        _shapLayer.fillRule = kCAFillRuleEvenOdd;
        _shapLayer.fillColor = Color(255, 255, 255, 1).CGColor;;
        
    }
    return _shapLayer;
}


#pragma mark - 7.Notification


#pragma mark - 8.Event Response



@end
