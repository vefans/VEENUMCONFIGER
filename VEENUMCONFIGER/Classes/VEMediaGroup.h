//
//  VEMediaGroup.h
//  VEENUMCONFIGER
//
//  Created by mac on 2022/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEMediaGroup : NSObject

@property (nonatomic, assign) int groupId;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) BOOL isAllReplaced;

@property (nonatomic, assign) BOOL isNeedPrompt;

@end

NS_ASSUME_NONNULL_END
