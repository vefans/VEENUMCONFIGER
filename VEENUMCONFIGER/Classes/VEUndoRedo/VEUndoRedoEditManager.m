//
//  VEUndoRedoEditManager.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team  on 2021/10/11.
//

#import "VEUndoRedoEditManager.h"

@interface VEUndoRedoEditManager ()

@property (strong, nonatomic) NSMutableArray <VEUndoRedoObject *> *undoList;
@property (strong, nonatomic) NSMutableArray <VEUndoRedoObject *> *redoList;

@end

@implementation VEUndoRedoEditManager

-(NSMutableArray<VEUndoRedoObject *> *)getUndoList
{
    return _undoList;
}

-(NSMutableArray<VEUndoRedoObject *> *)getRedoList
{
    return _redoList;
}

+ (instancetype)sharedManager
{
    static VEUndoRedoEditManager *singleOjbect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleOjbect = [[self alloc] init];
    });
    return singleOjbect;
}

- (id)init{
    
    if (self = [super init]) {
        
        self.undoList = [NSMutableArray array];
        self.redoList = [NSMutableArray array];
    }
    return self;
}

- (void)saveUndoRedoObject:(VEUndoRedoObject *)model completionHandler:(void(^)(BOOL enableUndo, BOOL enableRedo))completionHandler{
    if (model) {
        _currentObject = model;
        [self.undoList addObject:model];
        [self.redoList removeAllObjects];
    }    
    
    _enableUndo = self.undoList.count == 0 ? NO:YES;
    _enableRedo = self.redoList.count == 0 ? NO:YES;
    if (completionHandler) {
        NSLog(@"撤销类型:%lu",(unsigned long)_currentObject.type);
        completionHandler(_enableUndo, _enableRedo);
    }
}

- (void)undoWithCompletionHandler:(void(^)(BOOL enableUndo, BOOL enableRedo, VEUndoRedoObject *currentObject))completionHandler{
    
    if (self.undoList.count > 0) {
        _currentObject = self.undoList.lastObject;
        [self.redoList addObject:_currentObject];
        [self.undoList removeObject:_currentObject];
    }
    
    _enableUndo = self.undoList.count == 0 ? NO:YES;
    _enableRedo = self.redoList.count == 0 ? NO:YES;
    if (completionHandler) {
        NSLog(@"撤销类型:%lu",(unsigned long)_currentObject.type);
        completionHandler(_enableUndo, _enableRedo, _currentObject);
    }
}

- (void)redoWithCompletionHandler:(void(^)(BOOL enableUndo, BOOL enableRedo, VEUndoRedoObject *currentObject))completionHandler{
    
    if (self.redoList.count > 0) {
        _currentObject = self.redoList.lastObject;
        [self.undoList addObject:_currentObject];
        [self.redoList removeObject:_currentObject];
    }
    
    _enableUndo = self.undoList.count == 0 ? NO:YES;
    _enableRedo = self.redoList.count == 0 ? NO:YES;
    if (completionHandler) {
        NSLog(@"恢复类型:%lu",(unsigned long)_currentObject.type);
        completionHandler(_enableUndo, _enableRedo, _currentObject);
    }
}

- (void)clearUndoRedoData{
    [self.undoList removeAllObjects];
    [self.redoList removeAllObjects];
    _enableUndo = NO;
    _enableRedo = NO;
}

#pragma mark -根据editType和id得到VEUndoRedoCaptionModel
//- (VEUndoRedoCaptionModel *)getCaptionModelWithId:(NSInteger)modelId undoRedoType:(VEUndoRedoType)undoRedoType{
//
//    __block VEUndoRedoCaptionModel *targetModel = nil;
//    NSMutableArray *tempArray = [NSMutableArray array];
//    [tempArray addObjectsFromArray:self.undoList];
//    [tempArray addObjectsFromArray:self.redoList];
//
//    [tempArray enumerateObjectsUsingBlock:^(VEUndoRedoObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        if (obj.undoRedoType == undoRedoType && [obj isKindOfClass:VEUndoRedoCaptionModel.class]) {
//
//            VEUndoRedoCaptionModel *captionModel = (VEUndoRedoCaptionModel *)obj;
//            if (captionModel.dstRangeFile.captionId == modelId) {
//
//                targetModel = (VEUndoRedoCaptionModel *)obj;
//                *stop = YES;
//            }
//
//        }
//    }];
//    return targetModel;
//}

@end
