//
//  VEDraftInfo.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team  on 2021/9/28.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VEDraftEditType){
    VEDraftEditType_Rename  = 0,    //重命名
    VEDraftEditType_Copy    = 1,    //复制
    VEDraftEditType_Export  = 2,    //导出
    VEDraftEditType_Edit    = 3,    //编辑
    VEDraftEditType_Delete  = 4,    //删除
    VEDraftEditType_Update  = 5,    //更新
};

typedef NS_ENUM(NSInteger, VEDraftType) {
    VEDraftType_LocalEdit       = 0,    //本地剪辑
    VEDraftType_LiteEdit        = 1,    //精简剪辑
    VEDraftType_APITemplate     = 2,    //API模板
    VEDraftType_Cloud           = 3,    //云草稿
};

@interface LocalDraftData : NSObject

/** 唯一标识
 */
@property (nonatomic, strong) NSString *uuid;

/** 标题
 */
@property (nonatomic, strong) NSString *name;

/** 封面
 */
@property (nonatomic, strong) NSString *cover;

/** 更新时间
 */
@property (nonatomic, strong) NSString *updateTime;

/** 云草稿唯一标识
 */
@property (nonatomic, strong) NSString *ubid;

/** 是否上传云
 */
@property (nonatomic, assign) BOOL isBackup;

/** 时长
 */
@property (nonatomic, assign) double duration;

@end
