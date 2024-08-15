//
//  VEAddItemButton.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2019/10/10.
//  Copyright © 2019 iOS VESDK Team. All rights reserved.
//

#import "VEAddItemButton.h"
#import "VEHelp.h"
#define kFxIconTag 1000

@interface VEAddItemButton()<CAAnimationDelegate>
{
    BOOL _isReStart;
    
}
@property (nonatomic, strong) UIImageView *selectedIV;

@end

@implementation VEAddItemButton

+(VEAddItemButton *)initFXframe:(CGRect) rect atpercentage:(float) propor
{
    VEAddItemButton * fxItemBtn = [[VEAddItemButton alloc] initWithFrame:rect];
    fxItemBtn.propor = propor;
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, fxItemBtn.frame.size.width, fxItemBtn.frame.size.width, fxItemBtn.frame.size.height - fxItemBtn.frame.size.width)];
    fxItemBtn.label = label;
    fxItemBtn.label.textAlignment = NSTextAlignmentCenter;
    fxItemBtn.label.textColor = TEXT_COLOR;
    if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
        fxItemBtn.label.textColor = UIColorFromRGB(0x131313);
    }
    fxItemBtn.label.font = [UIFont systemFontOfSize:10];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:fxItemBtn.label.frame];
    fxItemBtn.moveTitleLabel = label1;
    fxItemBtn.moveTitleLabel.backgroundColor = [UIColor clearColor];
    fxItemBtn.moveTitleLabel.font = [UIFont systemFontOfSize:10];
    fxItemBtn.moveTitleLabel.textAlignment = NSTextAlignmentCenter;
    fxItemBtn.moveTitleLabel.hidden = YES;
    
    LongCacheImageView * imageView = [[LongCacheImageView alloc] initWithFrame:CGRectMake(0, 0, fxItemBtn.frame.size.width, fxItemBtn.frame.size.width)];
    imageView.backgroundColor = UIColorFromRGB(0x272727);
    if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
        imageView.backgroundColor = UIColorFromRGB(0xf9f9f9);
    }
    fxItemBtn.thumbnailIV = imageView;
    [fxItemBtn addSubview:fxItemBtn.thumbnailIV];
    [fxItemBtn addSubview:fxItemBtn.label];
    [fxItemBtn addSubview:fxItemBtn.moveTitleLabel];
    
    fxItemBtn.thumbnailIV.layer.cornerRadius = 3;
    fxItemBtn.thumbnailIV.layer.masksToBounds = YES;
    fxItemBtn.thumbnailIV.layer.borderWidth = 1.0;
    fxItemBtn.thumbnailIV.layer.borderColor = [UIColor clearColor].CGColor;
    fxItemBtn.thumbnailIV.tag = kFxIconTag;
    
    SDAnimatedImageView * animatedImageView = [[SDAnimatedImageView alloc] initWithFrame:fxItemBtn.thumbnailIV.bounds];
    animatedImageView.contentMode = UIViewContentModeScaleAspectFill;
    animatedImageView.backgroundColor = [UIColor clearColor];
    fxItemBtn.animatedImageView = animatedImageView;
    [fxItemBtn.thumbnailIV addSubview:fxItemBtn.animatedImageView];
    fxItemBtn.animatedImageView.tag = kFxIconTag+ 10000;
    
    fxItemBtn.userInteractionEnabled = YES;
    fxItemBtn.layer.masksToBounds = YES;
    
    return fxItemBtn;
}

- (UIView *)editView {
    if (!_editView) {
        UIView * editView = [[UIView alloc] initWithFrame:_thumbnailIV.bounds];
        editView.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.3];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            editView.backgroundColor = [UIColorFromRGB(0x000000) colorWithAlphaComponent:0.8];
        }
        editView.tag = kFxIconTag + 10;
        _editView = editView;
        [_thumbnailIV addSubview:editView];
        
        UIImageView * editIconView = [[UIImageView alloc] initWithFrame:CGRectMake((editView.frame.size.width - 22)/2.0, (editView.frame.size.height - 20 - 22)/2.0, 22, 22)];
        editIconView.userInteractionEnabled = YES;
        editIconView.image = [VEHelp imageNamed:@"手写动画画笔"];
        editIconView.tag = 1;
        [_editView addSubview:editIconView];
        
        UILabel * editLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(editIconView.frame), editView.frame.size.width, 20)];
        editLabel.backgroundColor = [UIColor clearColor];
        editLabel.userInteractionEnabled = YES;
        editLabel.font = [UIFont systemFontOfSize:9];
        editLabel.textColor = [UIColor whiteColor];
        editLabel.text = VELocalizedString(@"Paint", nil);
        editLabel.textAlignment = NSTextAlignmentCenter;
        [_editView addSubview:editLabel];
        editView.hidden = YES;
    }
    
    return _editView;
}

- (UIImageView *)selectedIV {
    if (!_selectedIV) {
        _selectedIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
        _selectedIV.image = [VEHelp imageNamed:@"Common/SelectedBox_@3x"];
        [self addSubview:_selectedIV];
    }
    
    return _selectedIV;
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
    [UIView setAnimationsEnabled:YES];
    [self moveAction];
}
- (void)pauseScrollTitle{
    _isReStart = YES;
    _isStartMove = NO;
    [self pauseLayer:_label.layer];
}
- (void)stopScrollTitle{
    _isReStart = NO;
    _moveTitleLabel.hidden = YES;
    _isStartMove = NO;
    [_label.layer removeAllAnimations];
    [_moveTitleLabel.layer removeAllAnimations];
    _label.frame = CGRectMake(0, _label.frame.origin.y, self.frame.size.width, _label.frame.size.height);
}

- (void)moveAction
{
   _moveTitleLabel.hidden = NO;
    _moveTitleLabel.text = _label.text;
    _moveTitleLabel.textColor = _label.textColor;
    _moveTitleLabel.font      = _label.font;
    
    CGRect rect = [_label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, _label.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:_label.font.fontName size:_label.font.pointSize]} context:nil];
    CGRect fr = _label.frame;
    if(fr.size.width > rect.size.width + 20){
        [self stopScrollTitle];
        
        return;
    }
    
    CGRect beginItemRect = _label.frame;
    
    beginItemRect.size.width = rect.size.width+20;
    _label.frame = beginItemRect;
    
    _moveTitleLabel.frame = CGRectMake(beginItemRect.size.width+10, _label.frame.origin.y, beginItemRect.size.width, _label.frame.size.height);
    
    CGRect beginMoveRect = _moveTitleLabel.frame;
    CGRect itemEndRect = _label.frame;
    itemEndRect.origin.x = -(rect.size.width+30);
    
    CGRect moveTitleEndRect = _moveTitleLabel.frame;
    moveTitleEndRect.origin.x = 0;
    
    WeakSelf(self);
    [UIView setAnimationsEnabled:YES];
    [UIView animateWithDuration:beginMoveRect.size.width/20.0 animations:^{
        StrongSelf(self);
        if( strongSelf )
        {
            weakSelf.label.frame = itemEndRect;
            strongSelf->_moveTitleLabel.frame = moveTitleEndRect;
        }
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            StrongSelf(self);
            if( strongSelf )
            {
                strongSelf.label.frame = beginItemRect;
                strongSelf->_moveTitleLabel.frame = beginMoveRect;
                if(strongSelf.isStartMove){
                    [strongSelf moveAction];
                }else{
                    strongSelf.label.frame = CGRectMake(0, strongSelf->_label.frame.origin.y, strongSelf.frame.size.width, strongSelf->_label.frame.size.height);
                    
                    strongSelf->_moveTitleLabel.frame = CGRectMake(strongSelf.frame.size.width, strongSelf->_label.frame.origin.y, strongSelf.frame.size.width, strongSelf->_label.frame.size.height);
                    
                }
            }
        });
    }];

}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (_thumbnailIV.superview) {
        if (_thumbnailIV.frame.origin.x == 0) {
            _thumbnailIV.frame = CGRectInset(_thumbnailIV.frame, 4, 4);
        }    
        if (selected) {
            self.selectedIV.hidden = NO;
            _label.textColor = [UIColor whiteColor];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                _label.textColor = UIColorFromRGB(0x131313);
            }
        }else {
            _selectedIV.hidden = YES;
            _label.textColor = TEXT_COLOR;
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                _label.textColor = UIColorFromRGB(0x131313);
            }
        }
    }
}

- (void)dealloc{
    [self stopScrollTitle];
    [_label removeFromSuperview];
    _label = nil;
    [_moveTitleLabel removeFromSuperview];
    _moveTitleLabel = nil;
    
    _thumbnailIV.image = nil;
    _thumbnailIV.longGifData = nil;
    [_thumbnailIV removeFromSuperview];
    _thumbnailIV = nil;
    NSLog(@"%s",__func__);
}

-(void)textColor:(UIColor *) color
{
    _label.textColor = color;
    _moveTitleLabel.textColor = color;
}

@end
