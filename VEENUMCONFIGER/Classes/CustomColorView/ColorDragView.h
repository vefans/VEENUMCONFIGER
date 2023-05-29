//
//  ColorDragView.h
//  PEImageInfo
//
//  Created by emmet-mac on 2023/4/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ColorDragViewDelegate <NSObject>
- (void)changeDragViewColor:(UIColor *)color isDragEnd:(BOOL)isDragEnd;

@end
@interface ColorDragView : UIButton
@property (nonatomic,strong)UIView *focusView;
@property (nonatomic,strong)CALayer *strawLayer;
@property (nonatomic,strong)CAGradientLayer *headerLayer;
@property (nonatomic,strong)CAGradientLayer *endlayer;
@property(nonatomic,weak)id<ColorDragViewDelegate>   delegate;
- (void)setdefaultColor:(UIEvent *)event;
- (void)resetColor;
@end

NS_ASSUME_NONNULL_END
