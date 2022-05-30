//
//  VEDocument.h
//  VEENUMCONFIGER
//
//  Created by mac on 2022/5/13.
//

#ifndef VEDocument_h
#define VEDocument_h


#endif /* VEDocument_h */

#import <UIKit/UIKit.h>

@interface VEDocument : UIDocument

- (nullable id)contentsForType:(NSString *)typeName error:(NSError **)outError;

- (BOOL)loadFromContents:(id)contents ofType:(nullable NSString *)typeName error:(NSError **)outError;

@property (nonatomic, strong) NSData *data;

@end
