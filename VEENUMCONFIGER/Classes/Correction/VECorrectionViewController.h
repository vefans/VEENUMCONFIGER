//
//  VECorrectionViewController.h
//  VEENUMCONFIGER
//
//  Created by mac on 2024/1/25.
//

#import <UIKit/UIKit.h>
#import <VEENUMCONFIGER/VEENUMCONFIGER.h>
#import <VEENUMCONFIGER/VENavBarViewController.h>
#import <LibVECore/LibVECore.h>

NS_ASSUME_NONNULL_BEGIN

@interface VECorrectionViewController : VENavBarViewController
/**需要裁剪的文件
 */
@property (nonatomic, strong ) VEMediaInfo        *selectFile;

/**视频预览尺寸
 */
@property (nonatomic, assign ) CGSize        editVideoSize;

/**AE图片素材编辑
 */
@property (nonatomic,copy) void (^editVideoForOnceFinishFiltersAction)(CGRect crop,
                                                                       CGFloat verticalDegrees, CGFloat horizontalDegrees);

/** 是否需要导出，默认NO
 */
@property (nonatomic, assign) BOOL isNeedExport;

-(void)seekTime:(CMTime) time;
@end

NS_ASSUME_NONNULL_END
