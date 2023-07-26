//
//  VEeSwitch.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team. on 2022/6/16.
//

#import "VESwitch.h"
#import "VEHelp.h"

@interface VESwitch()
{
    UIButton *_thumbBtn;
}

@end

@implementation VESwitch

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _onTintColor = Main_Color;
        _tintColor = UIColorFromRGB(0xcbcbcb);
        
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, (frame.size.height - 3)/2.0, frame.size.width, 3)];
        _backgroundView.backgroundColor = _tintColor;
        _backgroundView.layer.cornerRadius = 1;
        _backgroundView.layer.masksToBounds = YES;
        [self addSubview:_backgroundView];
        
        UIImage *image = [VEHelp imageNamed:@"/jianji/Adjust/剪辑-调色_球1"];
        _thumbBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (frame.size.height - image.size.height)/2.0, image.size.width, image.size.height)];
        [_thumbBtn setImage:image forState:UIControlStateNormal];
        [_thumbBtn setImage:image forState:UIControlStateHighlighted];
        [_thumbBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _thumbBtn.userInteractionEnabled = YES;
        [self addSubview:_thumbBtn];
        
        self.userInteractionEnabled = YES;
        [self addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    if (!_on) {
        _backgroundView.backgroundColor = tintColor;
    }
}

- (void)setThumbImage:(UIImage *)thumbImage {
    [_thumbBtn setImage:thumbImage forState:UIControlStateNormal];
    [_thumbBtn setImage:thumbImage forState:UIControlStateHighlighted];
    _thumbBtn.frame = CGRectMake(0, (self.frame.size.height - thumbImage.size.height)/2.0, thumbImage.size.width, thumbImage.size.height);
}

- (void)btnAction:(UIControl *)control {
    if (_thumbBtn.frame.origin.x == 0) {
        self.on = YES;
    }else {
        self.on = NO;
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setOn:(BOOL)on {
    _on = on;
    __block CGRect frame = _thumbBtn.frame;
    WeakSelf(self);
    [UIView animateWithDuration:0.25 animations:^{
        StrongSelf(self);
        if (strongSelf) {
            if (on) {
                frame.origin.x = self.frame.size.width - strongSelf->_thumbBtn.frame.size.width;
                strongSelf.backgroundView.backgroundColor = strongSelf.onTintColor;
            }else {
                frame.origin.x = 0;
                strongSelf.backgroundView.backgroundColor = strongSelf.tintColor;
            }
            strongSelf->_thumbBtn.frame = frame;
        }
    }];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
    if (animated) {
        self.on = on;
    }else {
        _on = on;
        CGRect frame = _thumbBtn.frame;
        if (on) {
            frame.origin.x = self.frame.size.width - _thumbBtn.frame.size.width;
            _backgroundView.backgroundColor = _onTintColor;
        }else {
            frame.origin.x = 0;
            _backgroundView.backgroundColor = _tintColor;
        }
        _thumbBtn.frame = frame;
    }
}

@end
