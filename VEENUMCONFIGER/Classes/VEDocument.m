//
//  VEDocument.m
//  VEENUMCONFIGER
//
//  Created by mac on 2022/5/13.
//

#import <Foundation/Foundation.h>

#import "VEDocument.h"

@implementation VEDocument

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError {
    self.data = contents;
    return YES;
}

@end
