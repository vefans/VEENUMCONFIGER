//
//  VENetworkMaterialBtn_Cell.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/8/31.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VEENUMCONFIGER/VEAddItemButton.h>
    
NS_ASSUME_NONNULL_BEGIN

@interface VENetworkMaterialBtn_Cell : UICollectionViewCell

@property (nonatomic , strong)NSURLSessionDataTask *task;
@property(nonatomic, weak)  UIView * btnCollectBtn;

@end

NS_ASSUME_NONNULL_END
