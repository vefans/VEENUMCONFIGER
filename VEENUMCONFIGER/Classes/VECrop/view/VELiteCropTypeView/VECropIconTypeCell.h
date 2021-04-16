//
//  VECropIconTypeCell.h
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import <UIKit/UIKit.h>
#import "VECropTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VECropIconTypeCell : UICollectionViewCell

@property(nonatomic,assign)BOOL isSelect;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIImageView * iconImageView;

-(void)setCellForoCropTypeModel:(VECropTypeModel*)cropTypeModel;

@end

NS_ASSUME_NONNULL_END
