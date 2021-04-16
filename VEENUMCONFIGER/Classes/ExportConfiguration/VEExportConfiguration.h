//
//  VEExportConfiguration.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import <Foundation/Foundation.h>

/**水印位置
 */
typedef NS_ENUM(NSInteger,VEWATERPOSITION){
    WATERPOSITION_LEFTTOP,
    WATERPOSITION_RIGHTTOP,
    WATERPOSITION_LEFTBOTTOM,
    WATERPOSITION_RIGHTBOTTOM
};

NS_ASSUME_NONNULL_BEGIN

@interface VEExportConfiguration : NSObject<NSMutableCopying,NSCopying>

#pragma mark- 设置视频水印和码率

/** 设置视频输出最大时长 (单位是秒) 不限制则传0，默认不限制
 */
@property (nonatomic,assign)long int   outputVideoMaxDuration;
/** 设置视频输入最大时长 (单位是秒) 不限制则传0，默认不限制
 */
@property (nonatomic,assign)long int   inputVideoMaxDuration;
/** 是否禁用片尾，(default true)
 */
@property (nonatomic,assign)bool    endPicDisabled;
/** 片尾显示的用户名
 */
@property (nonatomic,copy)NSString * _Nullable endPicUserName;
/** 片尾显示时长（不包括淡入时长）
 */
@property (nonatomic,assign)float    endPicDuration;
/** 片尾淡入时长
 */
@property (nonatomic,assign)float    endPicFadeDuration;
/** 片尾显示的图片路径
 */
@property (nonatomic,copy)NSString * _Nullable endPicImagepath;
/** 是否禁用水印(default true)
 */
@property (nonatomic,assign)bool     waterDisabled;
/** 文字水印
 */
@property (nonatomic,copy,nullable)NSString *waterText;
/** 图片水印
 */
@property (nonatomic,strong,nullable)UIImage *waterImage;
/** 显示位置
 */
@property (nonatomic,assign)VEWATERPOSITION  waterPosition;

/** 设置视频输出码率 (单位是兆,默认是6M),建议设置大于1M，导出和压缩都生效
 */
@property (nonatomic,assign)float   videoBitRate;
/**压缩视频分辨率（调用压缩视频接口生效）
 */
@property (nonatomic,assign)CGSize  condenseVideoResolutionRatio;
/** 导出视频声道 (默认为2 双声道)
 */
@property (nonatomic,assign)int    audioChannelNumbers;

@end

NS_ASSUME_NONNULL_END
