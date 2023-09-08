//
//  VEMaskPasterView.m
//  libVEDeluxe
//
//  Created by iOS VESDK Team on 2020/10/27.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VEMaskPasterView.h"
#import "VEMaskPasterView+Linnear.h"
#import "VEMaskPasterView+MirrorSurface.h"
#import "VEMaskPasterView+Rectangle.h"
#import "VEMaskPasterView+Roundness.h"
#import "VEMaskPasterView+Pentacle.h"
#import "VEMaskPasterView+Love.h"

#import "VEMaskPasterView+Quadrilateral.h"

@interface  VEMaskPasterView()


@end

@implementation VEMaskPasterView

-(void)setfilletWidth:(float) fillet
{
    filletWidth = fillet;
    switch (_maskType) {
        case VEMaskType_RECTANGLE:
        case VEMaskType_InterRECTANGLE:
        {
            filletWidth = filletWidth*(btnWidth/2.0+3);
            self.fillet_ImageView.frame = CGRectMake((self.rectangleViewCenterView.frame.origin.x - filletWidth + 3 - btnWidth),(self.rectangleViewCenterView.frame.origin.y - filletWidth + 3  - btnWidth),btnWidth,btnWidth);
        }
            break;
        case VEMaskType_QUADRILATERAL:
        case VEMaskType_InterQUADRILATERAL:
        {
            [self setQuadrilateralCenterPoint:false];
            [self setFillet_ImageViewCenter];
            [self setRotate_ImageViewCenter];
            [self setFrameCurrentscale:self.selfScale];
        }
            break;
        default:
            break;
    }
}

- (instancetype)initWithFrame:(CGRect)frame atType:(VEMaskType) type atPasterTextView:(VEPasterTextView *) pasterTextView atSyncContainer:(VESyncContainerView *) syncContainer  atHeight:(float) CenterHeight atWidth:(float) CenterWidth  atColor:( UIColor * ) color  atStr:( NSString * ) str
{
    if (self = [super initWithFrame:frame]) {
        _selfScale = 1.0;
        _oldSelfScale = 1.0;
        float height = 10.0;
        RoundnessHeight = height;
        _bundleStr = str;
        _mainColor = color;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        
        _currentMultiTrackPasterTextView = pasterTextView;
        _syncContainer = syncContainer;
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( (_curretnView.frame.size.width - height)/2.0, (_curretnView.frame.size.height - height)/2.0, height, height)];
        _centreImageView = imageView;
        _centreImageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        _centreImageView.layer.cornerRadius = _centreImageView.frame.size.width/2.0;
        _centreImageView.layer.borderWidth = 2.0;
        _centreImageView.layer.borderColor = self.mainColor.CGColor;
        _centreImageView.userInteractionEnabled = YES;
        _centreImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        
        btnWidth = 25;
        intervalWidth = 5;
        self.maskType = type;
        
        switch (type) {
            case VEMaskType_LINNEAR://MARK: 线性
            case VEMaskType_InterLINNEAR://MARK: 线性
            {
                [self initLinnear:height atHeight:CenterHeight atWidth:CenterWidth];
                [_curretnView addSubview:_centreImageView];
            }
                break;
            case VEMaskType_MIRRORSURFACE://MARK: 镜面
            case VEMaskType_InterMIRRORSURFACE://MARK: 镜面
            {
                [self initMirrorSuface:height atHeight:CenterHeight atWidth:CenterWidth];
                [_mirrorSurfaceCenterView addSubview:_centreImageView];
            }
                break;
            case VEMaskType_ROUNDNESS://MARK: 圆形
            case VEMaskType_InterROUNDNESS://MARK: 圆形
            {
                [self initRoundness:CenterHeight atWidth:CenterWidth];
                [_roundnessCenterView addSubview:_centreImageView];
            }
                break;
            case VEMaskType_RECTANGLE://MARK: 矩形
            case VEMaskType_InterRECTANGLE://MARK: 矩形
            {
                [self initRectangle:CenterHeight atWidth:CenterWidth];
                [_rectangleViewCenterView addSubview:_centreImageView];
            }
                break;
            case VEMaskType_QUADRILATERAL://MARK: 四边形
            case VEMaskType_InterQUADRILATERAL://MARK: 四边形
            {
                RoundnessHeight = 0;
                [self initQuadrilateral:CenterHeight atWidth:CenterWidth];
                [self addSubview:_centreImageView];
            }
                break;
            case VEMaskType_PENTACLE://MARK: 五角星
            case VEMaskType_InterPENTACLE://MARK: 五角星
            {
                [self initPentacle:CenterHeight atWidth:CenterWidth];
                [_pentacleCenterView addSubview:_centreImageView];
            }
                break;
            case VEMaskType_LOVE://MARK: 爱心
            case VEMaskType_InterLOVE://MARK: 爱心
            {
                [self initLove:CenterHeight atWidth:CenterWidth];
                [_loveCenterView addSubview:_centreImageView];
            }
                break;
            default:
                break;
        }
        RoundnessHeight = 0.5;
    }
    return self;
}

-(void)setCenterPoint
{
    CGPoint point = CGPointMake(beginningCenter.x + (touchLocation.x - beginningPoint.x), beginningCenter.y + (touchLocation.y - beginningPoint.y));
    
    CGPoint pasterPoint = [self convertPoint:point toView:_currentMultiTrackPasterTextView];
    
    if( pasterPoint.x < (8) )
    {
        pasterPoint.x = (8);
    }
    if( pasterPoint.x > (_currentMultiTrackPasterTextView.bounds.size.width-8) )
    {
        pasterPoint.x = _currentMultiTrackPasterTextView.bounds.size.width-8;
    }
    
    if( pasterPoint.y < (8) )
    {
        pasterPoint.y = (8);
    }
    if( pasterPoint.y > (_currentMultiTrackPasterTextView.bounds.size.height-(8)) )
    {
        pasterPoint.y = _currentMultiTrackPasterTextView.bounds.size.height-(8);
    }
    
    point = [_currentMultiTrackPasterTextView convertPoint:pasterPoint toView:self];
    
    [_curretnView setCenter:point];
}

-( CGAffineTransform )GetCGAffineTransformRotateAroundPoint:(float) centerX atCenterY:(float) centerY atX:(float) x atY:(float) y atAngle:(float) angle
{
    x = x - centerX; //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    y = y - centerY; //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
 
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
    trans = CGAffineTransformRotate(trans,angle);
    trans = CGAffineTransformTranslate(trans,-x, -y);
    return trans;
}

-(void)setFramescale:(float) value
{
    _curretnView.transform =  CGAffineTransformMakeScale(1, 1);
    _curretnView.transform =  CGAffineTransformMakeScale(1/value, 1/value);
    if( _curretnView )
    {
        CGPoint center = _curretnView.center;
        _curretnView.frame = CGRectMake(0, 0, _curretnView.frame.size.width, _curretnView.frame.size.height);
        _curretnView.center = center;
    }
    
    self.rotate_ImageView.transform =  CGAffineTransformMakeScale(1, 1);
    self.rotate_ImageView.transform =  CGAffineTransformMakeScale(1/value, 1/value);
    if( self.rotate_ImageView )
    {
        CGPoint center = self.rotate_ImageView.center;
        self.rotate_ImageView.frame = CGRectMake(0, 0, self.rotate_ImageView.frame.size.width, self.rotate_ImageView.frame.size.height);
        self.rotate_ImageView.center = center;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if( [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] ||
        [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
       )
        return  false;
    else
        return true;
}

@end
