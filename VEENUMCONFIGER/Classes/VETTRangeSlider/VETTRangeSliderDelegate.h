//
//  YLRangeSliderViewDelegate.h
//  FantasyRealFootball
//
//  Created by Tom Thorpe on 16/04/2014.
//  Copyright (c) 2014 Yahoo inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VETTRangeSlider;

@protocol VETTRangeSliderDelegate <NSObject>

- (void)startMove:(UITouch *) touch;

- (void)stopMove;

- (CGSize)getLeftPointAndRightPoint;
- (void)getIsSlide:( float ) x  atoriginX:(float) originX atIsLeft:(BOOL) isLeft atTouch:(UITouch *) touch;


-(void)rangeSlider:(VETTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum isRight:(bool) isRight;

-(void)rangeSlider:(VETTRangeSlider *)sender didEndChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum;

-(void)dragRangeSlider:(VETTRangeSlider *)sender didEndChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum isRight:(BOOL) isRight isUpdate:(BOOL *) isUpdateSlider;

- (void)moveCurrentCaptionView:(CGPoint)moveOffset;

@end
