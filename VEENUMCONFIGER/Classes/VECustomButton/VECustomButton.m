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
