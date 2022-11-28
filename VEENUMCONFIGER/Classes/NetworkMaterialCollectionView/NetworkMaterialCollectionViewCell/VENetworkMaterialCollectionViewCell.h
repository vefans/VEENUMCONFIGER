//
//  VENetworkMaterialCollectionViewCell.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/8/31.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VENetworkMaterialBtn_Cell.h"

NS_ASSUME_NONNULL_BEGIN
@interface VECell_CollectionView : UICollectionView
@end
@protocol VENetworkMaterialCollectionViewCellDelegate;

@interface VENetworkMaterialCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<VENetworkMaterialCollectionViewCellDelegate> delegate;

@property(nonatomic, assign)BOOL                 isDragToChange;

@property(nonatomic, weak) VECell_CollectionView *collectionView;
@property(nonatomic, assign) NSInteger       index;
@property(nonatomic, assign) NSInteger       indexCount;

@property(nonatomic, weak)UIView       *imageView;

@property(nonatomic, assign) bool               isNotMove;

-(void)initCollectView:(BOOL) isVertical_Cell atWidth:(float) cellWidth atHeight:(float) cellHeight minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing;

@end

@protocol VENetworkMaterialCollectionViewCellDelegate <NSObject>
@optional
-(UIView *)btnCollectCell:(NSInteger) index atIndexCount:(NSInteger) indexCount collectionView:(UICollectionView *)collectionView cell:(VENetworkMaterialBtn_Cell *)btnCell;

-(void)CellIndex:(NSInteger) index;

#pragma mark - UIScrollViewDelegate (时间轴的更新操作)
//开始滑动
- (void)cell_ScrollViewWillBeginDragging:(UIScrollView *)scrollView;
/**
 滚动中
 */
- (void)cell_ScrollViewDidScroll:(UIScrollView *)scrollView;

/**滚动停止
 */
- (void)cell_ScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

/**手指停止滑动
 */
- (void)cell_ScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

-(void)cell_MoveGesture:(UIGestureRecognizer *) recognizer;

#pragma mark- 释放
-(void)freedCell:(  id ) cell;

@end
NS_ASSUME_NONNULL_END
