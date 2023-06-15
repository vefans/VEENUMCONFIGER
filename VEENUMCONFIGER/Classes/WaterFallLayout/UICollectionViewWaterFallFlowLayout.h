//
//  UICollectionViewWaterFallFlowLayout.h
//
//  Created by iOS VESDK Team on 2018/4/28.
//  Copyright © 2018年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICollectionViewWaterFallFlowLayout;
@protocol UICollectionViewWaterFallFlowLayoutDataSource;


#pragma mark -

@interface UICollectionViewWaterFallFlowLayout : UICollectionViewLayout

@property (nonatomic, weak) IBOutlet id<UICollectionViewWaterFallFlowLayoutDataSource> dataSource;

@property (nonatomic, assign) CGFloat minimumLineSpacing; // default 0.0
@property (nonatomic, assign) CGFloat minimumInteritemSpacing; // default 0.0
@property (nonatomic, assign) IBInspectable BOOL sectionHeadersPinToVisibleBounds; // default NO
//@property (nonatomic, assign) IBInspectable BOOL sectionFootersPinToVisibleBounds;

@end


#pragma mark -

@protocol UICollectionViewWaterFallFlowLayoutDataSource<NSObject>

@required
/// Return per section's column number(must be greater than 0).
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)layout numberOfColumnInSection:(NSInteger)section;
/// Return per item's height
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)layout itemWidth:(CGFloat)width
 heightForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
/// Column spacing between columns
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)layout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
/// The spacing between rows and rows
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)layout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
///
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)layout insetForSectionAtIndex:(NSInteger)section;
/// Return per section header view height.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)layout referenceHeightForHeaderInSection:(NSInteger)section;
/// Return per section footer view height.
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterFallFlowLayout*)layout referenceHeightForFooterInSection:(NSInteger)section;

@end
