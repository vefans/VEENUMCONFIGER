//
//  VECustomButton.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 16/8/16.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import "VECustomButton.h"

@interface VECustomButton ()


@end

@implementation VECustomButton

-(void)set_Recognizer
{
    UIPanGestureRecognizer* moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
    [self addGestureRecognizer:moveGesture];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleTap];
}

-(void)handleSingleTap:(UIGestureRecognizer *)recognizer

{
    if( _delegate && [_delegate respondsToSelector:@selector(custom_moveGesture:atBtn:)] )
    {
        [_delegate custom_moveGesture:recognizer atBtn:self];
    }
}

-(void)moveGesture:(UIGestureRecognizer *) recognizer
{
    if( _delegate && [_delegate respondsToSelector:@selector(custom_moveGesture:atBtn:)] )
    {
        [_delegate custom_moveGesture:recognizer atBtn:self];
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        self.layer.borderWidth = 4.0;
    }else{
        self.layer.borderWidth = self.frame.size.width/2.0;
    }
}

@end


@implementation VETabButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _normalFontSize = 14;
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self setTitleColor:UIColorFromRGB(0xa4a4a4) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [self setTitleColor:UIColorFromRGB(0x727272) forState:UIControlStateNormal];
            [self setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateSelected];
        }
    }
    
    return self;
}
- (instancetype)init {
    if (self = [super init]) {
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self setTitleColor:UIColorFromRGB(0xa4a4a4) forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [self setTitleColor:UIColorFromRGB(0x727272) forState:UIControlStateNormal];
            [self setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateSelected];
        }
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        if (_selectedFontSize > 0) {
            self.titleLabel.font = [UIFont boldSystemFontOfSize:_selectedFontSize];
        }else {
            self.titleLabel.font = [UIFont boldSystemFontOfSize:self.titleLabel.font.pointSize];
        }
    }else {
        if (_selectedFontSize > 0 && _normalFontSize) {
            self.titleLabel.font = [UIFont systemFontOfSize:_normalFontSize];
        }else {
            self.titleLabel.font = [UIFont systemFontOfSize:self.titleLabel.font.pointSize];
        }
    }
}

@end
