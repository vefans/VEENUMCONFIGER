//
//  VEGetNetworkMaterialsClass.h
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/7/14.
//

#import <Foundation/Foundation.h>

@interface VEGetNetworkMaterialsClass : NSObject

//获取TTS的所有分类数据
+ (NSMutableArray *)getSpeechVoiceAllCategorys;
//获取TTS的单个分类数据
+ (NSMutableArray *)getSpeechVoicesWithCategoryId:(NSString *)categoryId;

@end
