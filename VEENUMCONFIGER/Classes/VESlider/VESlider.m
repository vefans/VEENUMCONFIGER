//
//  VESlider.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2016/12/6.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import "VESlider.h"
#import "VEHelp.h"

@implementation VESlider

- (instancetype)initWithFrame:(CGRect)frame{
    frame.size.width = floor(frame.size.width);
    if (self = [super initWithFrame:frame]) {
        if([VEConfigManager sharedManager].iPad_HD){
            [self setMinimumTrackImage:[VEHelp imageWithColor:UIColorFromRGB(0xffffff) size:CGSizeMake(self.frame.size.width, 1) cornerRadius:1] forState:UIControlStateNormal];
            [self setMaximumTrackImage:[VEHelp imageWithColor:UIColorFromRGB(0x2F302F) size:CGSizeMake(self.frame.size.width, 1) cornerRadius:1] forState:UIControlStateNormal];
        }else{
            UIImage *trackImage = [VEHelp imageWithColor:SliderMinimumTrackTintColor size:CGSizeMake(10, 2.0) cornerRadius:1];
            [self setMinimumTrackImage:trackImage forState:UIControlStateNormal];
            trackImage = [VEHelp imageWithColor:SliderMaximumTrackTintColor size:CGSizeMake(10, 2.0) cornerRadius:1];
            [self setMaximumTrackImage:trackImage forState:UIControlStateNormal];
        }
        [self setThumbImage:[VEHelp imageWithContentOfFile:@"/jianji/Adjust/剪辑-调色_球1"] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)trackRectForBounds:(CGRect)bounds
{
    bounds =  [super trackRectForBounds:bounds ];
    return bounds;
}

-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    _thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
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
