//
//  VEFaceUBeautyParams.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEFaceUBeautyParams : NSObject<NSCopying>

/**瘦脸 0.0~1.0     default 0.68
 */
@property (nonatomic , assign) float cheekThinning;

/**大眼 0.0~1.0     default 0.5
 */
@property (nonatomic , assign) float eyeEnlarging;

/**美白 0.0~1.0     default 0.48
 */
@property (nonatomic , assign) float colorLevel;

/**红润 0.0~1.0     default 0.5
 */
@property (nonatomic , assign) float redLevel;

/**磨皮 1 2 3 4 5 6   default 3
 */
@property (nonatomic , assign) float blurLevel;

/** 瘦脸等级 0.0 ~ 1.0 默认1.0
 */
@property (nonatomic , assign) float faceShapeLevel;

/** 美型类型 (0、1、2、3) 默认：0，女神：0，网红：1，自然：2
 */
@property (nonatomic , assign) float faceShape;

@end

NS_ASSUME_NONNULL_END
