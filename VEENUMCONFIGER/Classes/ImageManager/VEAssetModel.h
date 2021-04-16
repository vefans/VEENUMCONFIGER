//
//  VEAssetModel.h
//  TZImagePickerController
//
//  Created by iOS VESDK Team. on 15/12/24.
//  Copyright © 2015 iOS VESDK Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VEAssetModelMediaTypePhoto = 0,
    VEAssetModelMediaTypeLivePhoto,
    VEAssetModelMediaTypePhotoGif,
    VEAssetModelMediaTypeVideo,
    VEAssetModelMediaTypeAudio
} VEAssetModelMediaType;

@class PHAsset;
@interface VEAssetModel : NSObject

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) BOOL isSelected;      ///< The select status of a photo, default is No
@property (nonatomic, assign) VEAssetModelMediaType type;
@property (assign, nonatomic) BOOL needOscillatoryAnimation;
@property (nonatomic, copy) NSString *timeLength;
@property (strong, nonatomic) UIImage *cachedImage;

/// Init a photo dataModel With a PHAsset
/// 用一个PHAsset实例，初始化一个照片模型
+ (instancetype)modelWithAsset:(PHAsset *)asset type:(VEAssetModelMediaType)type;
+ (instancetype)modelWithAsset:(PHAsset *)asset type:(VEAssetModelMediaType)type timeLength:(NSString *)timeLength;

@end


@class PHFetchResult;
@interface VETZAlbumModel : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) PHFetchResult *result;

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSArray *selectedModels;
@property (nonatomic, assign) NSUInteger selectedCount;

@property (nonatomic, assign) BOOL isCameraRoll;

- (void)setResult:(PHFetchResult *)result needFetchAssets:(BOOL)needFetchAssets;

@end
