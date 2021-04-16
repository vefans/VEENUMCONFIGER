//
//  VEAssetModel.m
//  TZImagePickerController
//
//  Created by iOS VESDK Team. on 15/12/24.
//  Copyright © 2015 iOS VESDK Team. All rights reserved.
//

#import "VEAssetModel.h"
#import "VEImageManager.h"

@implementation VEAssetModel

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(VEAssetModelMediaType)type{
    VEAssetModel *model = [[VEAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(PHAsset *)asset type:(VEAssetModelMediaType)type timeLength:(NSString *)timeLength {
    VEAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

@end



@implementation VETZAlbumModel

- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets {
    _result = result;
    if (needFetchAssets) {
        [[VEImageManager manager] getAssetsFromFetchResult:result completion:^(NSArray<VEAssetModel *> *models) {
            self->_models = models;
            if (self->_selectedModels) {
                [self checkSelectedModels];
            }
        }];
    }
}

- (void)setSelectedModels:(NSArray *)selectedModels {
    _selectedModels = selectedModels;
    if (_models) {
        [self checkSelectedModels];
    }
}

- (void)checkSelectedModels {
    self.selectedCount = 0;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    for (VEAssetModel *model in _selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    for (VEAssetModel *model in _models) {
        if ([selectedAssets containsObject:model.asset]) {
            self.selectedCount ++;
        }
    }
}

- (NSString *)name {
    if (_name) {
        return _name;
    }
    return @"";
}

@end
