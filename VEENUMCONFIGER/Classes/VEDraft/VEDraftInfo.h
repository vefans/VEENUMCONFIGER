//
//  VEDraftInfo.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team  on 2021/9/28.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DraftEditType){
    DraftEditType_Rename  = 0,    //重命名
    DraftEditType_Copy    = 1,    //复制
    DraftEditType_Export  = 2,    //导出
    DraftEditType_Edit    = 3,    //编辑
    DraftEditType_Delete  = 4,    //删除
    DraftEditType_Update  = 5,    //更新
};

typedef NS_ENUM(NSInteger, DraftType) {
    DraftType_LocalEdit       = 0,    //本地剪辑
    DraftType_LiteEdit        = 1,    //精简剪辑
    DraftType_APITemplate     = 2,    //API模板
    DraftType_Cloud           = 3,    //云草稿
    DraftType_MusicTemp       = 4,    //音乐相册
};

@interface LocalDraftData : NSObject

@property (nonatomic, assign) NSInteger mid;

/** 唯一标识
 */
@property (nonatomic, strong) NSString *uuid;

/** 标题
 */
@property (nonatomic, strong) NSString *name;
/**草稿类型
 */
@property (nonatomic, assign) DraftType type;

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
