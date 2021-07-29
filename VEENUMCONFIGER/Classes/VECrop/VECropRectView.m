//
//  VECropRectView.m
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//
#import "VECropRectView.h"
@implementation VECropRectView


#pragma mark - 1.Life Cycle

-(instancetype)initWithFrame:(CGRect)frame withVideoCropType:(VEVideoCropType)videoCropType{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.videoCropType = videoCropType;
        self.backgroundColor = Color(0,0,0,0.5);
        self.layer.borderColor =  Color(255,255,255,1).CGColor;
        self.layer.borderWidth = 1;
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    if ( (self.videoCropType !=VEVideoCropType_Dewatermark) && (!_isTrackButtonHidden) ) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, Color(255,255,255,1).CGColor);//线框颜色
        
        // 绘制锤直虚线
        for (int i = 0; i < 2; i++) {
            float verticalLineWidth = self.frame.size.width/3;
            UIBezierPath *verticalLinePath = [UIBezierPath bezierPath];
            CGFloat dash[] = {3.0, 3.0};
            [verticalLinePath setLineDash:dash count:2 phase:0.0];
            [verticalLinePath moveToPoint: CGPointMake(verticalLineWidth*(i+1), 0)];
            [verticalLinePath addLineToPoint: CGPointMake(verticalLineWidth*(i+1),self.frame.size.height)];
            [verticalLinePath stroke];
            [verticalLinePath fill];
        }
        // 绘水平虚线
        for (int i = 0; i< 2; i++) {
            float horizontalLineHeight = self.frame.size.height/3;
            UIBezierPath *horizontalLinePath = [UIBezierPath bezierPath];
            CGFloat dash[] = {3.0, 3.0};
            [horizontalLinePath setLineDash:dash count:2 phase:0.0];
            [horizontalLinePath moveToPoint: CGPointMake(0, horizontalLineHeight*(i+1))];
            [horizontalLinePath addLineToPoint: CGPointMake(self.frame.size.width, horizontalLineHeight*(i+1))];
            [horizontalLinePath stroke];
            [horizontalLinePath fill];

        }
    }
   
    
    
}

#pragma mark - 2.Setting View and Style

- (void)setupViews{
    
}


#pragma mark - 3 Data

#pragma mark - 4.Custom Methods

#pragma mark - 5.DataSource and Delegate

#pragma mark - 6.Set & Get

@end

