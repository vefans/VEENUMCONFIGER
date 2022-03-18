//
//  VEFileDownloader.h
//  VE
//
//  Created by iOS VESDK Team on 2017/3/27.
//  Copyright © 2017年 VE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**请求方式
 */
typedef NS_ENUM(NSInteger, VEHTTPMethod){
    VEGET,//get 方式请求
    VEPOST//post 方式请求
    
};
@interface VEFileDownloader : NSObject

#pragma mark- 方式一
/**下载网络数据
 @params  sourceUrlstr 数据源地址
 @params  cachePath 文件缓存地址或文件夹
 @params  HTTPMethod 请求方式
 @params  progress 下载进度
 @params  finish 下载完成
 @params  fail 下载失败
 */

+ (void)downloadFileWithURL:(NSString *)sourceUrlstr cachePath:(NSString *)cachePath HTTPMethod:(VEHTTPMethod )HTTPMethod progress:(void(^)(NSNumber *numProgress))progress finish:(void (^)(NSString *fileCachePath))finish fail:(void(^)(NSError *error))fail;

+ (void)downloadFileWithURL:(NSString *)sourceUrlstr cachePath:(NSString *)cachePath HTTPMethod:(VEHTTPMethod )HTTPMethod cancelBtn:(UIButton *)cancelBtn progress:(void(^)(NSNumber *numProgress))progress finish:(void (^)(NSString *fileCachePath))finish fail:(void(^)(NSError *error))fail cancel:(void(^)(void))cancel;


#pragma mark- 方式二
@property (nonatomic ,copy)NSString *cacheFilePath;

- (instancetype)init;

- (void)downloadFileWithURL:(NSString *)sourceUrlstr HTTPMethod:(VEHTTPMethod )HTTPMethod progress:(void(^)(NSNumber *numProgress))progress finish:(void (^)(NSString *fileCachePath))finish fail:(void(^)(NSError *error))fail cancel:(void(^)(void))cancel;

- (void)downloadFileWithURL:(NSString *)sourceUrlstr cachePath:(NSString *)cachePath HTTPMethod:(VEHTTPMethod )HTTPMethod progress:(void(^)(NSNumber *numProgress))progress finish:(void (^)(NSString *fileCachePath))finish fail:(void(^)(NSError *error))fail cancel:(void(^)(void))cancel;

- (float)progress;

- (void)cancel;
@end
