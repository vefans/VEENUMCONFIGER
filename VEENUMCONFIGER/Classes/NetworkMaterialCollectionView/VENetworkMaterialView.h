//
//  VENetworkMaterialView.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/8/31.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VENetworkMaterialBtn_Cell.h"
@interface VENet_CollectionView : UICollectionView
@end
@protocol VENetworkMaterialViewDelegate;

@interface VENetworkMaterialView : UIView

- (instancetype)initWithFrame:(CGRect)frame atCount:(NSInteger) count atIsVertical_Cell:(BOOL) isVertical_Cell atWidth:(float) cellWidth atHeight:(float) cellHeight;

@property (weak, nonatomic) id<VENetworkMaterialViewDelegate> delegate;

-(void)initCollectView;
-(void)initCollectView:(UIEdgeInsets)contentInset;
@property(nonatomic, assign)BOOL                 isDragToChange;

@property(nonatomic, assign) NSInteger           isAddCount;
 
@property(nonatomic, assign) BOOL             isImageShow;

@property(nonatomic, assign) bool               isNotMove;
@property(nonatomic, strong) UICollectionViewFlowLayout * flowLayout;
@property(nonatomic, weak) VENet_CollectionView     *collectionView;
@property(nonatomic, assign) float              collectionOffsetX;
@property(nonatomic, assign) float              collectionOffsetPointX;

@property(nonatomic, assign) NSInteger          CollectionViewCount;

@property(nonatomic, assign) NSInteger         currentCellIndex;

@property(nonatomic, assign) float cellMinimumInteritemSpacing;

@property(nonatomic, assign) float cellMinimumLineSpacing;

/** 设置当前选中项相关参数
 *  offsetX ：CollectView的偏移值
 *  lineItemCount ：竖排时，一行的素材数，0为横排
 *  selectedItemIndex ：当前选中项
 */
- (void)setCurrentOffsetX:(float)offsetX
            lineItemCount:(NSInteger)lineItemCount
        selectedItemIndex:(NSInteger)selectedItemIndex;

-(void)freNetWorkMaterialVIew;

- (CGPoint)getCurrentCellContentOffset;
- (void)setCurrentCellContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
@end

@protocol VENetworkMaterialViewDelegate <NSObject>
@optional
-(void) CellIndex:(NSInteger) index atNetwork:(VENetworkMaterialView *) network;
-(UIView *)btnCollectCell:(NSInteger) index atIndexCount:(NSInteger) indexCount atNetwork:(VENetworkMaterialView *) network cell:(VENetworkMaterialBtn_Cell *)btnCell;
-(NSInteger) indexCountCell:(NSInteger) index atNetwork:(VENetworkMaterialView *) network;
-(NSInteger) indexCountCell:(NSInteger) index headerReferenceSize:(CGSize *)headerReferenceSize footerReferenceSize:(CGSize *)footerReferenceSize atNetwork:(VENetworkMaterialView *) network;

-(UIView *)ImageViewCollectCell:(NSInteger) indexCount atNetwork:(VENetworkMaterialView *) network;

- (void)veNetworkMaterialViewHeaderView:(UICollectionReusableView *)headerView;

- (void)veNetworkMaterialViewFooterView:(UICollectionReusableView *)footerView;

#pragma mark - UIScrollViewDelegate (时间轴的更新操作)
//开始滑动
- (void)netWrokMaterial_ScrollViewWillBeginDragging:(UIScrollView *)scrollView;
/**
 滚动中
 */
- (void)netWrokMaterial_ScrollViewDidScroll:(UIScrollView *)scrollView;

/**滚动停止
 */
- (void)netWrokMaterial_ScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

/**手指停止滑动
 */
- (void)netWrokMaterial_ScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

-(void)netWrokMaterial_MoveGesture:(UIGestureRecognizer *) recognizer;

#pragma mark- 释放
-(void)freedCell:( id ) cell;



@end
