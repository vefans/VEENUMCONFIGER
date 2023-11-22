//
//  ScrollViewChildItem.m
//  VEFile
//
//  Created by iOS VESDK Team on 16/10/23.
//  Copyright © 2016年 VEFile. All rights reserved.
//

#import "VEFileScrollViewChildItem.h"
#import "VEHelp.h"
@interface VEFileScrollViewChildItem()<UIGestureRecognizerDelegate,CAAnimationDelegate>{
    UITapGestureRecognizer *_gesture;
    BOOL _isReStart;
    __weak UILabel *_moveTitleLabel;
    UILongPressGestureRecognizer * _longPressGesture;
    UIImageView *_collectionImageView;
}
@end

@implementation VEFileScrollViewChildItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _isCollection = NO;
        _isSelectCollection = NO;
        _collectionImageView = nil;
        [self initUI];
     }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame itemType:(VEFileScrollItemType)itemType {
    if (self = [super initWithFrame:frame]) {
        _isCollection = NO;
        _isSelectCollection = NO;
        _collectionImageView = nil;
        [self initUI];
        _type = itemType;
        if (itemType == VEFileScrollItemType_Filter) {
            _itemIconView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 2);
            _itemIconView.layer.cornerRadius = 0;
            _itemTitleLabel.frame = CGRectMake(0, self.frame.size.height - self.frame.size.height * 0.25, self.frame.size.width, self.frame.size.height * 0.25);
            self.layer.cornerRadius = 3.0;
        }else if (itemType == VEFileScrollItemType_Tone || itemType == VEFileScrollItemType_VoiceFX) {
            _itemIconView.frame = self.bounds;
            _itemTitleLabel.frame = self.bounds;
        }
    }
    
    return self;
}

- (void)setIsSelectCollection:(BOOL)isSelectCollection
{
    _isSelectCollection = isSelectCollection;
    if( isSelectCollection )
    {
        if( _collectionImageView == nil )
        {
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 16, 0, 16, 16)];
            iv.backgroundColor = [UIColor colorWithWhite:0 alpha:1.0];
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:iv.bounds  byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(7, 7)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = iv.bounds;
            maskLayer.path = maskPath.CGPath;
            iv.layer.mask = maskLayer;
            iv.image = [VEHelp imageNamed:@"New_EditVideo/CollectionMark_@3x"];
            iv.tag = kCollectionMarkTag;
            [self addSubview:iv];
            _collectionImageView = iv;
        }
        _collectionImageView.hidden = NO;
    }
    else{
        if( _collectionImageView )
            _collectionImageView.hidden = true;
    }
}

- (void)setIsCollection:(BOOL)isCollection
{
    _isCollection = isCollection;
    
    if( isCollection )
    {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCollection:)];
        _longPressGesture.minimumPressDuration = 0.5f;
        _longPressGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:_longPressGesture];
    }
    else{
        [self removeGestureRecognizer:_longPressGesture];
    }
}

#pragma mark- 长按收藏
-( void )longPressCollection:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if( _isCollection )
        {
            if( _delegate && [_delegate respondsToSelector:@selector(scrollViewChildItem_Collection:)] )
            {
                [_delegate scrollViewChildItem_Collection:self];
            }
        }
      }
}

- (void)initUI {
    _cornerRadius = 15.0;
    UIImageView *itemIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    itemIconView.layer.cornerRadius = _cornerRadius;
    itemIconView.layer.masksToBounds = YES;
    itemIconView.userInteractionEnabled = YES;
    itemIconView.contentMode = UIViewContentModeScaleAspectFill;
    itemIconView.clipsToBounds = YES;
    _itemIconView = itemIconView;
    
    UILabel *itemTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.width, self.frame.size.width, 20)];
    itemTitleLabel.backgroundColor = [UIColor clearColor];
    itemTitleLabel.font = [UIFont systemFontOfSize:_fontSize>0?_fontSize:14];
    itemTitleLabel.textAlignment = NSTextAlignmentCenter;
    _isStartMove = NO;
    _itemTitleLabel = itemTitleLabel;
    
    UILabel *moveTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width, self.frame.size.width, self.frame.size.width, 20)];
    moveTitleLabel.backgroundColor = [UIColor clearColor];
    moveTitleLabel.font = [UIFont systemFontOfSize:_fontSize>0?_fontSize:14];
    moveTitleLabel.textAlignment = NSTextAlignmentCenter;
    _moveTitleLabel = moveTitleLabel;
    
    self.userInteractionEnabled = YES;
    self.layer.masksToBounds = YES;
    _gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgesture:)];
    _downloading = NO;
        
    [self addSubview:_itemIconView];
    [self addSubview:_itemTitleLabel];
    [self addSubview:_moveTitleLabel];
    [self addGestureRecognizer:_gesture];
}

- (void)moveAction
{
    _moveTitleLabel.hidden = NO;
    _moveTitleLabel.text = _itemTitleLabel.text;
    _moveTitleLabel.textColor = _itemTitleLabel.textColor;
    _moveTitleLabel.font      = _itemTitleLabel.font;
    
    CGRect rect = [_itemTitleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:_itemTitleLabel.font.fontName size:_itemTitleLabel.font.pointSize]} context:nil];
    CGRect fr = _itemTitleLabel.frame;
    if(fr.size.width > rect.size.width + 20){
        [self stopScrollTitle];
        
        return;
    }
    
    
    CGRect beginItemRect = _itemTitleLabel.frame;
    
    beginItemRect.size.width = rect.size.width+20;
    _itemTitleLabel.frame = beginItemRect;
    
    _moveTitleLabel.frame = CGRectMake(beginItemRect.size.width+10, _itemTitleLabel.frame.origin.y, beginItemRect.size.width, _itemTitleLabel.frame.size.height);

    CGRect beginMoveRect = _moveTitleLabel.frame;
    CGRect itemEndRect = _itemTitleLabel.frame;
    itemEndRect.origin.x = -(rect.size.width+30);
    
    CGRect moveTitleEndRect = _moveTitleLabel.frame;
    moveTitleEndRect.origin.x = 0;
    
    WeakSelf(self);
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:beginMoveRect.size.width/20.0 animations:^{
        StrongSelf(self);
        if( strongSelf )
        {
            weakSelf.itemTitleLabel.frame = itemEndRect;
            strongSelf->_moveTitleLabel.frame = moveTitleEndRect;
        }
    } completion:^(BOOL finished) {
        StrongSelf(self);
        if( strongSelf )
        {
            strongSelf.itemTitleLabel.frame = beginItemRect;
            strongSelf->_moveTitleLabel.frame = beginMoveRect;
            if(strongSelf.isStartMove){
                [strongSelf moveAction];
            }else{
                strongSelf.itemTitleLabel.frame = CGRectMake(0, strongSelf.itemTitleLabel.frame.origin.y, strongSelf.frame.size.width, strongSelf.itemTitleLabel.frame.size.height);
                
                strongSelf->_moveTitleLabel.frame = CGRectMake(strongSelf.frame.size.width, strongSelf->_itemTitleLabel.frame.origin.y, strongSelf.frame.size.width, strongSelf->_itemTitleLabel.frame.size.height);
                
            }
        }
    }];
    
    
//TODO:20170612 emmet 用下面这种方式执行动画时间长了就会卡死
//    fr.size.width = rect.size.width + 20;
//    fr.origin.x = self.frame.size.width;
//    _itemTitleLabel.frame = fr;
//    //self.frame.size.width +
//    CGPoint fromPoint = CGPointMake(_itemTitleLabel.frame.size.width/2, _itemTitleLabel.frame.origin.y + _itemTitleLabel.frame.size.height/2.0);
//    
//    UIBezierPath *movePath = [UIBezierPath bezierPath];
//    [movePath moveToPoint:fromPoint];
//    [movePath addLineToPoint:CGPointMake(-_itemTitleLabel.frame.size.width, _itemTitleLabel.frame.origin.y + _itemTitleLabel.frame.size.height/2.0)];
//    
//    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    moveAnim.path = movePath.CGPath;
//    moveAnim.removedOnCompletion = NO;
//    
//    moveAnim.duration = _itemTitleLabel.frame.size.width * 8 * 0.01;
//    [moveAnim setDelegate:self];
//    
//    [_itemTitleLabel.layer addAnimation:moveAnim forKey:nil];
//    
//    fr = _moveTitleLabel.frame;
//    fr.size.width = (rect.size.width + 20) *2;
//    fr.origin.x = self.frame.size.width*2;
//    _moveTitleLabel.frame = fr;
//    
//    fromPoint = CGPointMake(self.frame.size.width + _moveTitleLabel.frame.size.width/2, _moveTitleLabel.frame.origin.y + _moveTitleLabel.frame.size.height/2.0);
//    
//    movePath = [UIBezierPath bezierPath];
//    [movePath moveToPoint:fromPoint];
//    [movePath addLineToPoint:CGPointMake(0, _moveTitleLabel.frame.origin.y + _moveTitleLabel.frame.size.height/2.0)];
//    
//    CAKeyframeAnimation *moveAnim1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    moveAnim1.path = movePath.CGPath;
//    moveAnim1.removedOnCompletion = NO;
//    
//    moveAnim1.duration = _itemTitleLabel.frame.size.width * 8 * 0.01;
//    [moveAnim1 setDelegate:self];
//    
//    [_moveTitleLabel.layer addAnimation:moveAnim1 forKey:nil];
    
}

-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = layer.timeOffset;
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [self moveAction];
    }
}

- (void)startScrollTitle{
    [self stopScrollTitle];
    _isStartMove = YES;
    _isReStart = YES;
    [self moveAction];
}
- (void)pauseScrollTitle{
    _isReStart = YES;
    _isStartMove = NO;
    [self pauseLayer:_itemTitleLabel.layer];
}
- (void)stopScrollTitle{
    _isReStart = NO;
    _moveTitleLabel.hidden = YES;
    _isStartMove = NO;
    [UIView setAnimationsEnabled:YES];
    [_itemTitleLabel.layer removeAllAnimations];
    [_moveTitleLabel.layer removeAllAnimations];
    _itemTitleLabel.frame = CGRectMake(0, self.frame.size.width, self.frame.size.width, 20);
}

- (void)restartMoveTitle{
    //[self resumeLayer:_itemTitleLabel.layer];
}

- (CGRect )getIconFrame{
    return _itemIconView.frame;
}

- (void)tapgesture:(UITapGestureRecognizer *)gesture{
    if(self.delegate){
        [self.delegate scrollViewChildItemTapCallBlock:self];
    }
}
- (void)setCornerRadius:(float)cornerRadius{
    _cornerRadius = cornerRadius;
    _itemIconView.layer.cornerRadius = _cornerRadius;
    [self setNeedsDisplay];
}

- (void)setFontSize:(float)fontSize{
    _fontSize = fontSize;
//    if(iPhone4s){
//        _fontSize = 10;
//    }
    _itemTitleLabel.font = [UIFont systemFontOfSize:_fontSize>0?_fontSize:14];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected{
    if(selected){
        _itemIconView.layer.borderColor = _selectedColor?_selectedColor.CGColor:UIColorFromRGB(0x31d065).CGColor;
        _itemIconView.layer.borderWidth = 2.0;
        _itemTitleLabel.textColor = _textSelectedColor ? _textSelectedColor : [UIColor whiteColor];
        if(_type == VEFileScrollItemType_VoiceFX || _type == VEFileScrollItemType_Tone)
        {
            _itemTitleLabel.textColor = [UIColor whiteColor];
            _itemIconView.backgroundColor = SCREEN_BACKGROUND_COLOR;
            
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                _itemTitleLabel.textColor = UIColorFromRGB(0x131313);
                _itemIconView.backgroundColor = UIColorFromRGB(0xefefef);
            }
        }
        else if(_type == VEFileScrollItemType_Music)
        {
            _itemTitleLabel.textColor = [UIColor whiteColor];
            _itemIconselectedView.layer.borderColor = _selectedColor?_selectedColor.CGColor:UIColorFromRGB(0x31d065).CGColor;
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                _itemTitleLabel.textColor = UIColorFromRGB(0x131313);
                _itemIconView.backgroundColor = UIColorFromRGB(0xefefef);
            }
            _itemIconselectedView.layer.borderWidth = 1.0;
            _itemIconselectedView.hidden = NO;
            _itemIconView.hidden = YES;
        }
        else if (_type == VEFileScrollItemType_Filter && ![VEConfigManager sharedManager].iPad_HD) {
            _itemIconView.layer.borderWidth = 0.0;
            self.layer.borderWidth = 2.0;
            self.layer.borderColor = _selectedColor?_selectedColor.CGColor:UIColorFromRGB(0x31d065).CGColor;
        }
    }else{
        _itemIconView.layer.borderColor = [UIColor clearColor].CGColor;
        _itemIconView.layer.borderWidth = 0.0;
        _itemTitleLabel.textColor = _normalColor? _normalColor:[UIColor whiteColor];
        
        if(_type == VEFileScrollItemType_VoiceFX || _type == VEFileScrollItemType_Tone)
        {
            _itemTitleLabel.textColor = [UIColor whiteColor];
            _itemIconView.backgroundColor = UIColorFromRGB(0x333333);
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                _itemTitleLabel.textColor = UIColorFromRGB(0x131313);
                _itemIconView.backgroundColor = UIColorFromRGB(0xefefef);
            }
        }
        else if(_type == VEFileScrollItemType_Music)
        {
            _itemTitleLabel.textColor = UIColorFromRGB(0x666666);
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                _itemTitleLabel.textColor = UIColorFromRGB(0x131313);
                _itemIconView.backgroundColor = UIColorFromRGB(0xefefef);
            }
            _itemIconselectedView.hidden = YES;
            _itemIconView.hidden = NO;
        }
        else if (_type == VEFileScrollItemType_Filter) {
            self.layer.borderWidth = 0.0;
        }
    }
}
- (void)dealloc{
    [_collectionImageView removeFromSuperview];
    _collectionImageView = nil;
//    NSLog(@"%s",__func__);
    [self stopScrollTitle];
    [_itemTitleLabel removeFromSuperview];
    _itemTitleLabel = nil;
    [_moveTitleLabel removeFromSuperview];
    _moveTitleLabel = nil;
    [_itemIconView removeFromSuperview];
    _itemIconView = nil;
    [self removeGestureRecognizer:_gesture];
    _gesture = nil;
}
@end
