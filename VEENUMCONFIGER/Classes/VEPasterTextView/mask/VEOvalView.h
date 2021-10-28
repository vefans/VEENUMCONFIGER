//
//  VEOvalView.h
//  libVEDeluxe
//
//  Created by apple on 2020/10/29.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class VEOvalView;

@protocol VEOvalViewDelegate <NSObject>

-(NSMutableArray *)getQuadrilateralPointArray;

@end
@interface VEOvalView : UIView

@property (nonatomic, assign) int type;

- (instancetype)initWithFrame:(CGRect)frame atType:(int) type atColor:( UIColor * ) color;

@property(nonatomic,weak)id<VEOvalViewDelegate>   delegate;

@property (nonatomic, strong) UIColor *mainColor;

@end

NS_ASSUME_NONNULL_END
