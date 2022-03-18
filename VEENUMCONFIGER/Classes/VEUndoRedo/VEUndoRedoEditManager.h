//
//  VEUndoRedoEditManager.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team  on 2021/10/11.
//

#import <Foundation/Foundation.h>
#import "VEUndoRedoObject.h"

@interface VEUndoRedoEditManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, readonly) VEUndoRedoObject *currentObject;

/** 是否可撤销
 */
@property (nonatomic, readonly) BOOL enableUndo;

/** 是否可恢复
 */
@property (nonatomic, readonly) BOOL enableRedo;

/** 保存撤销恢复数据
 */
- (void)saveUndoRedoObject:(VEUndoRedoObject *)model completionHandler:(void(^)(BOOL enableUndo, BOOL enableRedo))completionHandler;

/** 撤销
 */
- (void)undoWithCompletionHandler:(void(^)(BOOL enableUndo, BOOL enableRedo, VEUndoRedoObject *currentObject))completionHandler;

/** 恢复
 */
- (void)redoWithCompletionHandler:(void(^)(BOOL enableUndo, BOOL enableRedo, VEUndoRedoObject *currentObject))completionHandler;

/** 清除撤销恢复数据
 */
- (void)clearUndoRedoData;

//根据editType和id得到VEUndoRedoCaptionModel
//- (VEUndoRedoCaptionModel *)getCaptionModelWithId:(NSInteger)modelId undoRedoType:(VEUndoRedoType)undoRedoType;

-(NSMutableArray<VEUndoRedoObject *> *)getUndoList;
-(NSMutableArray<VEUndoRedoObject *> *)getRedoList;

@end
