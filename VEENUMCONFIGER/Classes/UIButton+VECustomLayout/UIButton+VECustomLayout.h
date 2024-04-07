//
//  UIButton+VECustomLayout.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2019/6/5.
//  Copyright © 2019 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VEButtonEdgeInsetsStyle) {
    VEButtonEdgeInsetsStyleTop,     // image在上，label在下
    VEButtonEdgeInsetsStyleLeft,    // image在左，label在右
    VEButtonEdgeInsetsStyleBottom,  // image在下，label在上
    VEButtonEdgeInsetsStyleRight    // image在右，label在左
};

@interface UIButton (VECustomLayout)

@property (nonatomic, assign) NSTimeInterval custom_acceptEventInterval; // 可以用这个给重复点击加间隔

- (void)layoutButtonWithEdgeInsetsStyle:(VEButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end

@interface VEDebounceButton : UIButton

@property (nonatomic, assign) NSTimeInterval debounceInterval;

@end
