//
//  VEGetNetworkMaterialsClass.h
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/7/14.
//

#import <Foundation/Foundation.h>
#import <VEENUMCONFIGER/VEHelp.h>

@interface VEGetNetworkMaterialsClass : NSObject

//获取TTS的所有分类数据
+ (void)getAllCategorysWithType:(VENetworkResourceType)type
             isContainSystemTts:(BOOL)isContainSystemTts
              completionHandler:(void (^)(NSError *error, NSMutableArray *categorys))completionHandler;

+ (void)getResourcesWithType:(VENetworkResourceType)type
                  categoryId:(NSString *)categoryId
           completionHandler:(void (^)(NSString *errorMessage, NSMutableArray *resources))completionHandler;


+ (NSMutableArray *)getSpeechVoiceAllCategorys;
//获取TTS的单个分类数据
+ (NSMutableArray *)getSpeechVoicesWithCategoryId:(NSString *)categoryId;

@end
