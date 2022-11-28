//
//  RDFXFilter.h
//  VE
//
//  Created by iOS VESDK Team on 2019/11/26.
//  Copyright © 2019 iOS VESDK Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LibVECore/Scene.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEFXFilter : NSObject

@property(copy,nonatomic)NSString       *ratingFrameTexturePath; //特效定格

@property(strong,nonatomic)CustomMultipleFilter *customFilter;       //特效参数（除时间特效）

@property(assign,nonatomic)TimeFilterType timeFilterType;       //时间特效
@property(assign,nonatomic)CMTimeRange     filterTimeRange;     //时长
    
@property(assign,nonatomic)NSUInteger      FXTypeIndex;        //特效类型
@property(copy,nonatomic)NSString         *nameStr;           //特效名字

@end

NS_ASSUME_NONNULL_END
