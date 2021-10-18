//
//  VEColorView.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2019/12/26.
//  Copyright © 2019 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VEColorControlViewDelegate <NSObject>
@optional

- (void)colorChanged:(UIColor *)color index:(NSInteger)index colorControlView:(UIView *)colorControlView;

@end

@interface VEColorControlView : UIView

@property (nonatomic, strong)NSArray *colorArray;

@property (nonatomic,weak) id<VEColorControlViewDelegate> delegate;

- (void)refreshFrame:(CGRect)frame;

-(NSInteger)setCurrentColorButtonColor:(UIColor *) color;

-(void)getColor:(UIColor *) color atColorIndex:(void (^)(int index))colorIndex;

@end
