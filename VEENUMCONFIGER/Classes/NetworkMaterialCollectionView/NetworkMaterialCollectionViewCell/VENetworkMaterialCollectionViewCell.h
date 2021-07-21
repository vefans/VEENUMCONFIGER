//
//  VENetworkMaterialCollectionViewCell.h
//  VEENUMCONFIGER
//
//  Created by apple on 2020/8/31.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VENetworkMaterialCollectionViewCellDelegate;

@interface VENetworkMaterialCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<VENetworkMaterialCollectionViewCellDelegate> delegate;

@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, assign) NSInteger       index;
@property(nonatomic, assign) NSInteger       indexCount;

@property(nonatomic, weak)UIView       *imageView;

@property(nonatomic, assign) bool               isNotMove;

-(void)initCollectView:(BOOL) isVertical_Cell atWidth:(float) cellWidth atHeight:(float) cellHeight;

@end

@protocol VENetworkMaterialCollectionViewCellDelegate <NSObject>
@optional
-(UIView *)btnCollectCell:(NSInteger) index atIndexCount:(NSInteger) indexCount;

-(void)CellIndex:(NSInteger) index;

@end
NS_ASSUME_NONNULL_END
