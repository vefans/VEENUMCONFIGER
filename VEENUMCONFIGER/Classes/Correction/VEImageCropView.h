//
//  VEImageCropView.h
//  VEENUMCONFIGER
//
//  Created by mac on 2024/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEImageCropView : UIView

- (instancetype)initWithImage:(UIImage *)image croppingRatio:(CGFloat)croppingRatio frame:(CGRect)frame;
@property (nonatomic, strong) UIView *rectangleView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) BOOL isFixedRatio;

@end

NS_ASSUME_NONNULL_END
