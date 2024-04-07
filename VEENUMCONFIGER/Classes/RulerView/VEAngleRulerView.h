//
//  VEAngleRulerView.h
//  VEENUMCONFIGER
//
//  Created by mac on 2024/1/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VEAngleRulerViewDelegate <NSObject>
@optional

- (void)rulerView_Value:(float) value RulerView:(UIView *) rulerView;

@end

@interface VEAngleRulerView : UIView

@property (nonatomic,weak) id<VEAngleRulerViewDelegate> delegate;

@property (nonatomic, assign) CGFloat value; // 当前标尺所指示的值
@property (nonatomic, strong) UIImageView *valueSelectedImage;

- (void)updateValueCoordinate;
@end

NS_ASSUME_NONNULL_END
