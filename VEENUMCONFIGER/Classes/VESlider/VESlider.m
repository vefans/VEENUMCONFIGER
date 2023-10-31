//
//  VESlider.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2016/12/6.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import "VESlider.h"
#import "VEHelp.h"

@interface VESlider ()

@property (nonatomic, weak) UIImageView* highlightView;

@end

@implementation VESlider

- (instancetype)initWithFrame:(CGRect)frame{
    frame.size.width = floor(frame.size.width);
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 10)];
        _highlightView = imageView;
        _isAETemplate = false;
        _highlightView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        
        if([VEConfigManager sharedManager].iPad_HD){
            [self setMinimumTrackImage:[VEHelp imageWithColor:UIColorFromRGB(0xffffff) size:CGSizeMake(self.frame.size.width, 1) cornerRadius:1] forState:UIControlStateNormal];
            [self setMaximumTrackImage:[VEHelp imageWithColor:UIColorFromRGB(0x2F302F) size:CGSizeMake(self.frame.size.width, 1) cornerRadius:1] forState:UIControlStateNormal];
        }else{
            CGSize size = CGSizeMake(10, 1);
            UIImage *trackImage = [VEHelp imageWithColor:SliderMinimumTrackTintColor size:size cornerRadius:0.5];
            if([VEConfigManager sharedManager].backgroundStyle ==UIBgStyleDarkContent){
                trackImage = [VEHelp imageWithColor:UIColorFromRGB(0x131313) size:size cornerRadius:0.5];
            }
            [self setMinimumTrackImage:trackImage forState:UIControlStateNormal];
            trackImage = [VEHelp imageWithColor:SliderMaximumTrackTintColor size:size cornerRadius:0.5];
            if([VEConfigManager sharedManager].backgroundStyle ==UIBgStyleDarkContent){
                trackImage = [VEHelp imageWithColor:UIColorFromRGB(0xcccfd6) size:size cornerRadius:0.5];
            }
            [self setMaximumTrackImage:trackImage forState:UIControlStateNormal];
        }
        [self setThumbImage:[VEHelp imageWithContentOfFile:@"/jianji/Adjust/剪辑-调色_球1"] forState:UIControlStateNormal];
    }
    return self;
}


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];

    _highlightView.frame = CGRectMake(0, 0, frame.size.width, 5);
    _highlightView.center = CGPointMake(frame.size.width/2, frame.size.height/2);

//    [_highlightView setFrame:CGRectMake(0, 0, frame.size.width, 5)];
    
}
- (void)setHighlightImage:(UIImage *)highlightImage
{
    _highlightView.image = highlightImage;
    [self insertSubview:_highlightView atIndex:2];
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
//    if(_isAdj)
//        return CGRectMake(bounds.origin.x - 5, bounds.origin.y, bounds.size.width, 40);
    
    if( _isAETemplate )
    {
        bounds.origin.x=bounds.origin.x+5;
        
        bounds.size.width=bounds.size.width-10;
    }
    bounds = [super trackRectForBounds:bounds ];
    return bounds;
}

-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    if(_isAETemplate)
    {
        rect.origin.x=rect.origin.x-4.0;
        
        rect.size.width=rect.size.width+8;
        _thumbRect = CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value],4.0,4.0);
    }
    else{
        _thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    }
    return _thumbRect;
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self setNeedsLayout];
}

- (void)dealloc{
//    NSLog(@"%s",__func__);
}

@end
