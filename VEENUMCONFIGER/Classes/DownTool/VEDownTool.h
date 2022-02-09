//
//  VEDownTool.h
//  VE
//
//  Created by iOS VESDK Team on 2017/3/22.
//  Copyright © 2017年 iOS VESDK Team. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface VEDownTool : NSObject
@property (nonatomic,copy) void(^Progress) (float);
@property (nonatomic,copy) void(^Finish)(void);

- (instancetype)initWithURLPath:(NSString*)path savePath:(NSString*)savePath;
//- (void) downWithPath:(NSString*) path
//             savePath:(NSString *)savePath
//             progress:(void(^)(float)) progress
//               finish:(void(^)())finish;
- (void) start;
@end
