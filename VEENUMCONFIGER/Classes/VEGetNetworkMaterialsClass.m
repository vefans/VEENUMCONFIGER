//
//  VEGetNetworkMaterialsClass.m
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/7/14.
//

#import "VEGetNetworkMaterialsClass.h"
#import "VEHelp.h"
#import "VEReachability.h"
#import "VEWindow.h"

@implementation VEGetNetworkMaterialsClass

+ (void)getAllCategorysWithType:(VENetworkResourceType)type completionHandler:(void (^)(NSError *, NSMutableArray *))completionHandler
{
    NSString *folderPath;
    NSString *plistPath;
    if ([type isEqualToString:VENetworkResourceType_TTS]) {
        folderPath = kTTSMaretrialFolder;
        plistPath = kTTSMaretrialPlistPath;
    }
    NSMutableArray *categorys;
    VEReachability *lexiu = [VEReachability reachabilityForInternetConnection];
    if([lexiu currentReachabilityStatus] == VEReachabilityStatus_NotReachable
       || [VEConfigManager sharedManager].editConfiguration.netMaterialTypeURL.length == 0)
    {
        categorys = [[NSArray arrayWithContentsOfFile:kTTSMaretrialPlistPath] mutableCopy];
        if (!categorys && [type isEqualToString:VENetworkResourceType_TTS]) {
            categorys = [self getSystemToneList];
        }
        [VEWindow showMessage:VELocalizedString(@"无可用的网络", nil) duration:2.0];
        if (completionHandler) {
            completionHandler(nil, categorys);
        }
        return;
    }
    NSString *appKey = [VEConfigManager sharedManager].appKey;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (appKey.length > 0) {
        [params setObject:appKey forKey:@"appkey"];
    }
    [params setObject:type forKey:@"type"];
    NSDictionary *typeDic = [VEHelp getNetworkMaterialWithParams:params
                                                          appkey:appKey
                                                         urlPath:[VEConfigManager sharedManager].editConfiguration.netMaterialTypeURL];
    if (typeDic && [typeDic[@"code"] intValue] == 0) {
        NSMutableArray *typeArray = [NSMutableArray arrayWithArray:typeDic[@"data"]];
        categorys = typeArray;
        if ([type isEqualToString:VENetworkResourceType_TTS]) {
            if(@available(iOS 16.0, *)){
                for (int i = 0; i < typeArray.count; i++)
                {
                    NSString *language_code = [[[typeArray[i][@"extra"][@"locale"] lowercaseString] componentsSeparatedByString:@"_"] firstObject];
                    NSArray <AVSpeechSynthesisVoice *>*speechVoices = [AVSpeechSynthesisVoice speechVoices];
                    NSMutableArray *arr = [NSMutableArray new];
                    NSMutableArray *nameArray = [NSMutableArray array];
                    for (AVSpeechSynthesisVoice *voice in speechVoices) {
                        NSString *lang = [voice language];
                        if([[language_code lowercaseString] isEqualToString:[[[lang componentsSeparatedByString:@"-"] firstObject] lowercaseString]]){
                            NSString *identifier = [voice identifier];
                            NSString *name = [voice name];
                            if (![nameArray containsObject:name]) {
                                [nameArray addObject:name];
                                NSDictionary *itemDic = @{@"id":identifier,@"name":name,@"lang":lang,@"identifier":identifier,@"sort":@(-1),@"voice":voice,@"gender":@(voice.gender)};
                                [arr insertObject:itemDic atIndex:0];
                            }
                        }
                    }
                    [nameArray removeAllObjects];
                    nameArray = nil;
                    [arr sortUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull obj1, NSDictionary * _Nonnull obj2) {
                        if([obj1[@"sort"] integerValue] > [obj2[@"sort"] integerValue]){
                            return NSOrderedAscending;
                        }else{
                            return NSOrderedDescending;
                        }
                    }];
                    [typeArray[i] setObject:arr forKey:@"data"];
                }
            }
        }
        
        NSDictionary *obj = typeArray.firstObject;
        [self getResourcesWithType:type
                        categoryId:obj[@"id"]
                 completionHandler:^(NSString *errorMessage, NSMutableArray *resources) {
            if (resources.count > 0) {
                NSMutableArray *itemArray = obj[@"data"];
                NSRange range = NSMakeRange(0, [resources count]);
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
                [itemArray insertObjects:resources atIndexes:indexSet];
            }
            if (categorys.count > 0) {
                BOOL suc = [categorys writeToFile:plistPath atomically:YES];
                if(suc){
                    NSLog(@"失败");
                }
            }
            if (completionHandler) {
                completionHandler(nil, categorys);
            }
        }];
        
        return;
    }
    categorys = [[NSArray arrayWithContentsOfFile:plistPath] mutableCopy];
    if([typeDic[@"msg"] length] > 0) {
        [VEWindow showMessage:typeDic[@"msg"] duration:2.0];
    }
    if (completionHandler) {
        completionHandler(nil, categorys);
    }
}

+ (void)getResourcesWithType:(VENetworkResourceType)type
                  categoryId:(NSString *)categoryId
           completionHandler:(void (^)(NSString *, NSMutableArray *))completionHandler
{
    NSString *folderPath;
    NSString *plistPath;
    if ([type isEqualToString:VENetworkResourceType_TTS]) {
        folderPath = kTTSMaretrialFolder;
        plistPath = kTTSMaretrialPlistPath;
    }
    NSString *appKey = [VEConfigManager sharedManager].appKey;
    
    NSMutableDictionary *paramArray = [NSMutableDictionary dictionary];
    if (appKey.length > 0) {
        [paramArray setObject:appKey forKey:@"appkey"];
    }
    [paramArray setObject:type forKey:@"type"];
    [paramArray setObject:categoryId forKey:@"category"];
    NSDictionary *resultDic = [VEHelp getNetworkMaterialWithParams:paramArray
                                                            appkey:appKey
                                                           urlPath:[VEConfigManager sharedManager].editConfiguration.netMaterialURL];
    if (resultDic && [resultDic[@"code"] intValue] == 0) {
        NSMutableArray *array = resultDic[@"data"];
        
        NSArray *tempTemplateList = [NSArray arrayWithContentsOfFile:plistPath];
        if (tempTemplateList.count > 0) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                NSString *file = [obj1[@"file"] stringByDeletingPathExtension];
                NSString *updateTime = obj1[@"updatetime"];
                if ([updateTime isKindOfClass:[NSNumber class]]) {
                    updateTime = [obj1[@"updatetime"] stringValue];
                }
                __block NSString *tmpUpdateTime;
                [tempTemplateList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                    if ([[obj2 objectForKey:@"id"] isEqualToString:categoryId]) {
                        [obj2[@"data"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
                            if ([[obj3[@"file"] stringByDeletingPathExtension] isEqualToString:file]) {
                                tmpUpdateTime = obj3[@"updatetime"];
                                if ([tmpUpdateTime isKindOfClass:[NSNumber class]]) {
                                    tmpUpdateTime = [obj3[@"updatetime"] stringValue];
                                }
                                *stop3 = YES;
                                *stop2 = YES;
                            }
                        }];
                    }
                }];
                if(tmpUpdateTime && ![tmpUpdateTime isEqualToString:updateTime])
                {
                    NSString *path = [VEHelp getCachedFileNameWithUrlStr:obj1[@"file"] folderPath:folderPath];
                    NSString *jsonPath = [NSString stringWithFormat:@"%@/%@.json", folderPath, file];
                    if ([fileManager fileExistsAtPath:jsonPath]) {
                        [fileManager removeItemAtPath:jsonPath error:nil];
                    }
                    if ([fileManager fileExistsAtPath:path]) {
                        [fileManager removeItemAtPath:path error:nil];
                    }
                }
            }];
        }
        if (completionHandler) {
            completionHandler(nil, array);
        }
        return;
    }
    if (completionHandler) {
        completionHandler(nil, nil);
    }
}

+ (NSMutableArray *)getSpeechVoiceAllCategorys {
    NSMutableArray *speechVoices;
    VEReachability *lexiu = [VEReachability reachabilityForInternetConnection];
    if([lexiu currentReachabilityStatus] == VEReachabilityStatus_NotReachable
       || [VEConfigManager sharedManager].editConfiguration.netMaterialTypeURL.length == 0)
    {
        speechVoices = [[NSArray arrayWithContentsOfFile:kTTSMaretrialPlistPath] mutableCopy];
        if (!speechVoices) {
            speechVoices = [self getSystemToneList];
        }
        [VEWindow showMessage:VELocalizedString(@"无可用的网络", nil) duration:2.0];
        return speechVoices;
    }
    NSString *appKey = [VEConfigManager sharedManager].appKey;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (appKey.length > 0) {
        [params setObject:appKey forKey:@"appkey"];
    }
    [params setObject:@"edge_tts_language" forKey:@"type"];
    NSDictionary *typeDic = [VEHelp getNetworkMaterialWithParams:params
                                                          appkey:appKey
                                                         urlPath:[VEConfigManager sharedManager].editConfiguration.netMaterialTypeURL];
    if (typeDic && [typeDic[@"code"] intValue] == 0) {
        NSMutableArray *typeArray = [NSMutableArray arrayWithArray:typeDic[@"data"]];
        speechVoices = typeArray;
        if(@available(iOS 16.0, *)){
            for (int i = 0; i < typeArray.count; i++)
            {
                NSString *language_code = [[[typeArray[i][@"extra"][@"locale"] lowercaseString] componentsSeparatedByString:@"_"] firstObject];
                NSArray <AVSpeechSynthesisVoice *>*speechVoices = [AVSpeechSynthesisVoice speechVoices];
                NSMutableArray *arr = [NSMutableArray new];
                NSMutableArray *nameArray = [NSMutableArray array];
                for (AVSpeechSynthesisVoice *voice in speechVoices) {
                    NSString *lang = [voice language];
                    if([[language_code lowercaseString] isEqualToString:[[[lang componentsSeparatedByString:@"-"] firstObject] lowercaseString]]){
                        NSString *identifier = [voice identifier];
                        NSString *name = [voice name];
                        if (![nameArray containsObject:name]) {
                            [nameArray addObject:name];
                            NSDictionary *itemDic = @{@"id":identifier,@"name":name,@"lang":lang,@"identifier":identifier,@"sort":@(-1),@"voice":voice,@"gender":@(voice.gender)};
                            [arr insertObject:itemDic atIndex:0];
                        }
                    }
                }
                [nameArray removeAllObjects];
                nameArray = nil;
                [arr sortUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull obj1, NSDictionary * _Nonnull obj2) {
                    if([obj1[@"sort"] integerValue] > [obj2[@"sort"] integerValue]){
                        return NSOrderedAscending;
                    }else{
                        return NSOrderedDescending;
                    }
                }];
                [typeArray[i] setObject:arr forKey:@"data"];
            }
        }
        NSDictionary *obj = typeArray.firstObject;
        NSArray *array = [self getSpeechVoicesWithCategoryId:obj[@"id"]];
        if (array.count > 0) {
            NSMutableArray *itemArray = obj[@"data"];
            NSRange range = NSMakeRange(0, [array count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [itemArray insertObjects:array atIndexes:indexSet];
        }
        if (speechVoices.count > 0) {
            BOOL suc = [speechVoices writeToFile:kTTSMaretrialPlistPath atomically:YES];
            if(suc){
                NSLog(@"失败");
            }
        }
        return speechVoices;
    }
    speechVoices = [[NSArray arrayWithContentsOfFile:kTTSMaretrialPlistPath] mutableCopy];
    if([typeDic[@"msg"] length] > 0) {
        [VEWindow showMessage:typeDic[@"msg"] duration:2.0];
    }
    return speechVoices;
}

+ (NSArray *)getSpeechVoicesWithCategoryId:(NSString *)categoryId {
    NSString *appKey = [VEConfigManager sharedManager].appKey;
    
    NSMutableDictionary *paramArray = [NSMutableDictionary dictionary];
    if (appKey.length > 0) {
        [paramArray setObject:appKey forKey:@"appkey"];
    }
    [paramArray setObject:@"edge_tts_language" forKey:@"type"];
    [paramArray setObject:categoryId forKey:@"category"];
    NSDictionary *resultDic = [VEHelp getNetworkMaterialWithParams:paramArray
                                                            appkey:appKey
                                                           urlPath:[VEConfigManager sharedManager].editConfiguration.netMaterialURL];
    if (resultDic && [resultDic[@"code"] intValue] == 0) {
        NSArray *array = resultDic[@"data"];
        
        NSArray *tempTemplateList = [NSArray arrayWithContentsOfFile:kTTSMaretrialPlistPath];
        if (tempTemplateList.count > 0) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [array enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                NSString *file = [obj1[@"file"] stringByDeletingPathExtension];
                NSString *updateTime = obj1[@"updatetime"];
                if ([updateTime isKindOfClass:[NSNumber class]]) {
                    updateTime = [obj1[@"updatetime"] stringValue];
                }
                __block NSString *tmpUpdateTime;
                [tempTemplateList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                    if ([[obj2 objectForKey:@"id"] isEqualToString:categoryId]) {
                        [obj2[@"data"] enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj3, NSUInteger idx3, BOOL * _Nonnull stop3) {
                            if ([[obj3[@"file"] stringByDeletingPathExtension] isEqualToString:file]) {
                                tmpUpdateTime = obj3[@"updatetime"];
                                if ([tmpUpdateTime isKindOfClass:[NSNumber class]]) {
                                    tmpUpdateTime = [obj3[@"updatetime"] stringValue];
                                }
                                *stop3 = YES;
                                *stop2 = YES;
                            }
                        }];
                    }
                }];
                if(tmpUpdateTime && ![tmpUpdateTime isEqualToString:updateTime])
                {
                    NSString *path = [VEHelp getCachedFileNameWithUrlStr:obj1[@"file"] folderPath:kTTSMaretrialFolder];
                    NSString *jsonPath = [NSString stringWithFormat:@"%@/%@.json", kTTSMaretrialFolder, file];
                    if ([fileManager fileExistsAtPath:jsonPath]) {
                        [fileManager removeItemAtPath:jsonPath error:nil];
                    }
                    if ([fileManager fileExistsAtPath:path]) {
                        [fileManager removeItemAtPath:path error:nil];
                    }
                }
            }];
        }
        return array;
    }
    return nil;
}

+ (NSMutableArray *)getSystemToneList {
    NSMutableArray *speechVoices = [NSMutableArray array];
    if(@available(iOS 16.0, *)){
        NSMutableDictionary *categroy = [NSMutableDictionary new];
        [categroy setObject:@"init" forKey:@"appkey"];
        [categroy setObject:@"category" forKey:@"classify"];
        [categroy setObject:@"defaultSystem" forKey:@"id"];
        [categroy setObject:@"系统" forKey:@"name"];
        [categroy setObject:@"System" forKey:@"name_en"];
        {
            NSArray <AVSpeechSynthesisVoice *>*speechVoices = [AVSpeechSynthesisVoice speechVoices];
            NSMutableArray *arr = [NSMutableArray new];
            NSMutableArray *nameArray = [NSMutableArray array];
            NSInteger index = speechVoices.count - 1;
            for (AVSpeechSynthesisVoice *voice in speechVoices) {
                NSString *lang = [voice language];
                NSString *name = [voice name];
                if((![nameArray containsObject:name])){
                    [nameArray addObject:name];
                    
                    NSString *identifier = [voice identifier];
                    NSDictionary *itemDic = @{@"id":[NSString stringWithFormat:@"system_%zd",[speechVoices indexOfObject:voice]],@"name":name,@"lang":lang,@"identifier":identifier,@"sort":@(index),@"voice":voice};
                    [arr addObject:itemDic];
                }
            }
            [nameArray removeAllObjects];
            nameArray = nil;
            [arr sortUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull obj1, NSDictionary * _Nonnull obj2) {
                if([obj1[@"sort"] integerValue] > [obj2[@"sort"] integerValue]){
                    return NSOrderedAscending;
                }else{
                    return NSOrderedDescending;
                }
            }];
            
            [categroy setObject:arr forKey:@"data"];
        }
        [speechVoices addObject:categroy];
    }
    return speechVoices;
}

@end
