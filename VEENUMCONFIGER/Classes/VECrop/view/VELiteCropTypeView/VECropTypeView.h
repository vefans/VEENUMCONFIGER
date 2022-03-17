//
//  VECropTypeView.h
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import <UIKit/UIKit.h>
#import "VECropTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@class VECropTypeView;

@protocol VECropTypeDelegate <NSObject>

-(void)cropTypeView:(VECropTypeView *)cropTypeView selectItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface VECropTypeView : UIView

@property(nonatomic, strong)UICollectionView    *collectionView;

@property(nonatomic, weak)id<VECropTypeDelegate> delegate;

-(void)reloadDataForDataArray:(NSMutableArray*)dataArray;

-(void)didSelectItemAtIndexPathRow:(NSInteger)row;

@end

NS_ASSUME_NONNULL_END
