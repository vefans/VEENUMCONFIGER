//
//  VEAddItemButton.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2019/10/10.
//  Copyright © 2019 iOS VESDK Team. All rights reserved.
//

#import "VEAddItemButton.h"
#define kFxIconTag 1000

@interface VEAddItemButton()<CAAnimationDelegate>
{
    BOOL _isReStart;
    
}

@end

@implementation VEAddItemButton

+(VEAddItemButton *)initFXframe:(CGRect) rect atpercentage:(float) propor
{
    VEAddItemButton * fxItemBtn = [[VEAddItemButton alloc] initWithFrame:rect];
//    @property(nonatomic,strong)UIImageView *thumbnailIV;
    fxItemBtn.propor = propor;
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, fxItemBtn.frame.size.height*propor, fxItemBtn.frame.size.width, fxItemBtn.frame.size.height*(1.0-propor))];
    fxItemBtn.label = label;
    fxItemBtn.label.textAlignment = NSTextAlignmentCenter;
    fxItemBtn.label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    fxItemBtn.label.font = [UIFont systemFontOfSize:10];
    [fxItemBtn addSubview:fxItemBtn.label];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:fxItemBtn.label.frame];
    fxItemBtn.moveTitleLabel = label1;
    fxItemBtn.moveTitleLabel.backgroundColor = [UIColor clearColor];
    fxItemBtn.moveTitleLabel.font = [UIFont systemFontOfSize:20];
    fxItemBtn.moveTitleLabel.textAlignment = NSTextAlignmentCenter;
    fxItemBtn.moveTitleLabel.hidden = YES;
    [fxItemBtn addSubview:fxItemBtn.moveTitleLabel];
    
    LongCacheImageView * imageView = [[LongCacheImageView alloc] initWithFrame:CGRectMake((fxItemBtn.frame.size.width  - fxItemBtn.frame.size.height*propor)/2.0, 0, fxItemBtn.frame.size.height*propor, fxItemBtn.frame.size.height*propor)];
    fxItemBtn.thumbnailIV = imageView;
    [fxItemBtn addSubview:fxItemBtn.thumbnailIV];
    fxItemBtn.thumbnailIV.layer.cornerRadius = 3;
    fxItemBtn.thumbnailIV.layer.masksToBounds = YES;
    fxItemBtn.thumbnailIV.layer.borderWidth = 2.0;
    fxItemBtn.thumbnailIV.layer.borderColor = [UIColor clearColor].CGColor;
    fxItemBtn.thumbnailIV.tag = kFxIconTag;
    
    fxItemBtn.userInteractionEnabled = YES;
    fxItemBtn.layer.masksToBounds = YES;
    
    return fxItemBtn;
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
    [UIView setAnimationsEnabled:NO];
    [_label.layer removeAllAnimations];
    [_moveTitleLabel.layer removeAllAnimations];
    _label.frame = CGRectMake(0, self.frame.size.height*_propor, self.frame.size.width, self.frame.size.height*(1.0-_propor));
}

- (void)moveAction
{
   _moveTitleLabel.hidden = NO;
    _moveTitleLabel.text = _label.text;
    _moveTitleLabel.textColor = _label.textColor;
    _moveTitleLabel.font      = _label.font;
    
    CGRect rect = [_label.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height*(1.0-_propor)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:_label.font.fontName size:_label.font.pointSize]} context:nil];
    CGRect fr = _label.frame;
    if(fr.size.width > rect.size.width + 20){
        [self stopScrollTitle];
        
        return;
    }
    
    CGRect beginItemRect = _label.frame;
    
    beginItemRect.size.width = rect.size.width+20;
    _label.frame = beginItemRect;
    
    _moveTitleLabel.frame = CGRectMake(beginItemRect.size.width+10, self.frame.size.height*_propor, beginItemRect.size.width, self.frame.size.height*(1.0-_propor));
    
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
                    strongSelf.label.frame = CGRectMake(0, self.frame.size.height*strongSelf.propor, strongSelf.frame.size.width, self.frame.size.height*(1.0-strongSelf.propor));
                    
                    strongSelf->_moveTitleLabel.frame = CGRectMake(strongSelf.frame.size.width, self.frame.size.height*strongSelf.propor, strongSelf.frame.size.width, self.frame.size.height*(1.0-strongSelf.propor));
                    
                }
            }
        });
    }];

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
