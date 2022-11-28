//
//  VECropTypeModel.h
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface VECropTypeModel : NSObject

@property(nonatomic,strong)id title;
@property(nonatomic,strong)NSMutableAttributedString * selecctTitle;
@property(nonatomic,strong)UIImage * iconNormal;
@property(nonatomic,strong)UIImage * iconSelecct;
@property(nonatomic,assign)BOOL      isHaveIcon;
@property(nonatomic,assign)BOOL      isSelect;
@property(nonatomic,assign)VECropType cropType;
@property(nonatomic,assign)float        height;

@end

NS_ASSUME_NONNULL_END
