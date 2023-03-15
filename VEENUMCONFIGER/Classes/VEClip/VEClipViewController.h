//
//  VEClipViewController.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/7/16.
//

#import <UIKit/UIKit.h>
#import <VEENUMCONFIGER/VEENUMCONFIGER.h>
#import <VEENUMCONFIGER/VENavBarViewController.h>
#import <VEENUMCONFIGER/VEPlaySlider.h>

#import <VEENUMCONFIGER/VECropTypeView.h>
#import <VEENUMCONFIGER/VECropTypeModel.h>
#import <VEENUMCONFIGER/VEVideoCropView.h>
#import "VEExportProgressView.h"
NS_ASSUME_NONNULL_BEGIN

@interface VEClipViewController : VENavBarViewController

@property(nonatomic, assign)FileCropModeType    cutMmodeType;
@property(nonatomic, assign)BOOL                        isCropTypeViewHidden;   //是否显示 裁剪比例选择
@property(nonatomic, assign)CGRect fixedMaxCrop;//固定裁剪最大区域
@property(nonatomic,assign)VECropType cropType;

/**需要裁剪的文件
 */
@property (nonatomic, strong ) VEMediaInfo        *selectFile;

/** 是否需要导出，默认NO
 */
@property (nonatomic, assign) BOOL isNeedExport;


@property(nonatomic,copy)VECancelHandler cancelBlock;

/**滤镜
 */
@property (nonatomic, strong,nullable) NSMutableArray  *globalFilters;
/**视频预览尺寸
 */
@property (nonatomic, assign ) CGSize        editVideoSize;
/**音乐地址
 */
@property(nonatomic,strong)NSURL            *musicURL;
/**音乐时间范围
 */
@property(nonatomic,assign)CMTimeRange      musicTimeRange;
/**音乐音量
 */
@property(nonatomic,assign)float            musicVolume;
@property(nonatomic,strong)UIView           *bgView;
@property(nonatomic,strong)UIImage          *blurBgImage;
@property(nonatomic,assign)CGRect           frameRect;

@property (nonatomic,copy) void (^editVideoForOnceFinishAction)(BOOL useToAll,CGRect crop,CGRect cropRect,BOOL verticalMirror,BOOL horizontalMirror,float rotation, VECropType cropmodeType);

@property (nonatomic,copy) void (^editVideoForOnce_timeFinishAction)(BOOL useToAll,CGRect crop,CGRect cropRect,BOOL verticalMirror,BOOL horizontalMirror,float rotation, CMTimeRange timeRange, VECropType cropmodeType);

/**AE图片素材编辑
 */
@property (nonatomic,copy) void (^editVideoForOnceFinishFiltersAction)(CGRect crop,
                                                                       CGRect cropRect,
                                                                       BOOL verticalMirror,
                                                                       BOOL horizontalMirror,
                                                                       float rotation,
                                                                       VECropType cropmodeType,
                                                                       NSInteger filterIndex
                                );

-(void)seekTime:(CMTime) time;
@property(nonatomic,assign)BOOL            flowPicture;
@property (nonatomic,assign)BOOL isPresentModel;
@end

NS_ASSUME_NONNULL_END
