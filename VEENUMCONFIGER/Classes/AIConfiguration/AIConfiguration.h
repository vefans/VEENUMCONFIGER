//
//  AIConfiguration.h
//  VEENUMCONFIGER
//
//  Created by macos team  on 2024/3/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/** AI账号配置
 */
@interface AIConfiguration : NSObject

/** 服务器任务的AppKey
 *  AppKey for server tasks
 */
@property (nonatomic, copy) NSString  *serverTaskAppKey;

/** 服务器素材分类地址
 */
@property (nonatomic, copy)NSString   *serverMaterialTypeURL;

/** 服务器素材地址
 */
@property (nonatomic, copy)NSString   *serverMaterialURL;

/** 上传图片或视频的网络资源地址
 */
@property (nonatomic, copy) NSString *uploadPath;

/** 生成视频的网络资源地址
 */
@property (nonatomic, copy) NSString *serverTaskPath;

@end

NS_ASSUME_NONNULL_END
