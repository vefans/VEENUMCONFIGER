//
//  VENetworkMaterialView.h
//  libVEDeluxe
//
//  Created by apple on 2020/8/31.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VENetworkMaterialViewDelegate;

@interface VENetworkMaterialView : UIView

- (instancetype)initWithFrame:(CGRect)frame atCount:(NSInteger) count atIsVertical_Cell:(BOOL) isVertical_Cell atWidth:(float) cellWidth atHeight:(float) cellHeight;

@property (weak, nonatomic) id<VENetworkMaterialViewDelegate> delegate;

-(void)initCollectView;

@property(nonatomic, assign) bool               isNotMove;

@property(nonatomic, weak) UICollectionView     *collectionView;
@property(nonatomic, assign) float              collectionOffsetX;
@property(nonatomic, assign) float              collectionOffsetPointX;

@property(nonatomic, assign) NSInteger          CollectionViewCount;

@end

@protocol VENetworkMaterialViewDelegate <NSObject>
@optional
-(void) CellIndex:(NSInteger) index atNetwork:(VENetworkMaterialView *) network;
-(UIView *)btnCollectCell:(NSInteger) index atIndexCount:(NSInteger) indexCount atNetwork:(VENetworkMaterialView *) network;
-(NSInteger) indexCountCell:(NSInteger) index atNetwork:(VENetworkMaterialView *) network;

@end

NS_ASSUME_NONNULL_END
