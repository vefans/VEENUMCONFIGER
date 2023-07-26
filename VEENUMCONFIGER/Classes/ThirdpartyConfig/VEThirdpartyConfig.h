//
//  VEThirdpartyConfig.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 私有云AI识别账号配置
 */
@interface PrivateCloudAIRecogConfig : NSObject

/** 在私有云注册账号的 appKey
 */
@property (nonatomic, strong) NSString *appKey;

/** 在私有云中获取token的接口
 */
@property (nonatomic, strong) NSString *tokenURL;

/** 在私有云中上传音频文件的接口口
 */
@property (nonatomic, strong) NSString *uploadAudioFileURL;

/** 在私有云中获取AI识别的文本相关信息的接口
 */
@property (nonatomic, strong) NSString *receiveCmdURL;

@end

/** 腾讯云AI识别账号配置
 */
@interface TencentCloudAIRecogConfig : NSObject

/** 在腾讯云注册账号的 AppId
 */
@property (nonatomic, strong) NSString *appId;

/** 在腾讯云注册账号 AppId 对应的 SecretId
 */
@property (nonatomic, strong) NSString *secretId;

/** 在腾讯云注册账号 AppId 对应的 SecretKey
 */
@property (nonatomic, strong) NSString *secretKey;

/** 自行搭建的用于接收识别结果的服务器地址， 长度小于2048字节
 */
@property (nonatomic, strong) NSString *serverCallbackPath;

@end

/** 百度云AI账号配置
*/
@interface BaiDuCloudAIConfig : NSObject
/** 在百度云注册的人体分析 API Key
 */
@property (nonatomic, strong) NSString *bodyAnalysisAppKey;

/** 在百度云注册的人体分析 SecretKey
 */
@property (nonatomic, strong) NSString *bodyAnalysisSecretKey;

/** 在百度云注册的图像效果增强 API Key
 */
@property (nonatomic, strong) NSString *imageEffectAppKey;

/** 在百度云注册的图像效果增强 SecretKey
 */
@property (nonatomic, strong) NSString *imageEffectSecretKey;

@end

/** 阿里云智能语音账号配置
 */
@interface NuiSDKConfig : NSObject

/** 阿里云账号的AccessKey ID
 */
@property (nonatomic, strong) NSString *accessKeyId;

/** 阿里云账号的AccessKey Secret
 */
@property (nonatomic, strong) NSString *accessKeySecret;

/** 在阿里云管控台创建项目的appkey
 */
@property (nonatomic, strong) NSString *appKey;

/** 在阿里云语音已经获取到的授权令牌
 */
@property (nonatomic, strong) NSString *token;

@end

NS_ASSUME_NONNULL_END
