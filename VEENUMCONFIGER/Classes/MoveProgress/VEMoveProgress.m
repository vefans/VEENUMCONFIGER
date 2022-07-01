//
//  VEMoveProgress.m
//  VELiteSDK
//
//  Created by iOS VESDK Team. on 15/10/13.
//  Copyright © 2015 iOS VESDK Team. All rights reserved.
//

#import "VEMoveProgress.h"

@interface VEMoveProgress()

@property (nonatomic,weak)UIImageView *trackTintView;
@property (nonatomic,weak)UIImageView *progressView;

@end

@implementation VEMoveProgress

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        UIImageView *trackTintView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        _trackTintView = trackTintView;
        if(_trackTintColor){
            _trackTintView.backgroundColor = _trackTintColor;
        }
        if(_trackImage){
            _trackTintView.image = _trackImage;
            _trackTintView.contentMode = UIViewContentModeScaleToFill;
        } 
        _trackTintView.layer.masksToBounds = YES;
        
        UIImageView *progressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _progressView = progressView;
        _progressView.backgroundColor = [UIColor clearColor];
        [self addSubview:_progressView];
        [self addSubview:_trackTintView];
        
        _progressView.layer.cornerRadius = frame.size.height/2.0;
        _trackTintView.layer.cornerRadius = frame.size.height/2.0;
        _progressView.layer.masksToBounds = YES;
        _trackTintView.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2.0;
        self.layer.masksToBounds = YES;
        if(!self.backgroundColor){
            self.backgroundColor = [UIColor clearColor];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _progressView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _trackTintView.frame = CGRectMake(0, 0, _progress * self.frame.size.width , frame.size.height);
    _progressView.layer.cornerRadius = frame.size.height/2.0;
    _trackTintView.layer.cornerRadius = frame.size.height/2.0;
    _progressView.layer.masksToBounds = YES;
    _trackTintView.layer.masksToBounds = YES;
    self.layer.cornerRadius = frame.size.height/2.0;
    self.layer.masksToBounds = YES;
}

- (void)setProgress:(double)progress animated:(BOOL)animated{
    
    if(isnan(progress) || progress <=0){
        progress = 0.f;
    }
    self.progress = progress;
    
    float flag = animated ? 0.15:0.;
    [UIView animateWithDuration:flag animations:^{
        self.trackTintView.frame = CGRectMake(0, 0, progress * self.frame.size.width , self.trackTintView.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setProgressImag:(UIImage *)progressImag{
    self.progressView.image = progressImag;
}

- (void)setProgressTintColor:(UIColor *)progressTintColor{

}

- (void)setTrackImage:(UIImage *)trackImage{
    if(self.trackImage){
        self.trackTintView.image = trackImage;
        self.trackTintView.contentMode = UIViewContentModeScaleToFill;
        self.trackTintView.alpha = 1.0;
    }
}

- (void)setTrackTintColor:(UIColor *)trackTintColor{
    if(trackTintColor){
        self.trackTintView.backgroundColor = trackTintColor;
        self.trackTintView.alpha = 1.0;

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//20170330
- (void)dealloc{
//    NSLog(@"%s",__func__);
}
@end
