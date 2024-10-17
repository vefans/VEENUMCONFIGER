//
//  VECameraConfiguration.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VEENUMCONFIGER/VEFaceUBeautyParams.h>
#import <VEENUMCONFIGER/VEMusicInfo.h>

typedef NS_ENUM(NSUInteger, RecordStatus) {
    RecordHeader = 1 << 0, // 正方形录制  only
    Recording = 1 << 1, // 非正方形录制 only
    RecordEnd = 1 << 2, // 混合 可切换
};

typedef NS_ENUM(NSUInteger, RecordVideoSizeType) {
    RecordVideoTypeSquare = 1 << 0, // 正方形录制  only
    RecordVideoTypeNotSquare = 1 << 1, // 非正方形录制 only
    RecordVideoTypeMixed = 1 << 2, // 混合 可切换
};

//此参数在非方形录制下生效
typedef NS_ENUM(NSUInteger, RecordVideoOrientation) {
    RecordVideoOrientationAuto = 1 << 0, // 横竖屏自动切换切换
    RecordVideoOrientationPortrait = 1 << 1, // 保持竖屏
    RecordVideoOrientationLeft = 1 << 2, // 保持横屏
};

typedef NS_ENUM(NSUInteger, Record_Type) {
    RecordType_Video = 0,//录制
    RecordType_Photo = 1,//拍照
    RecordType_MVVideo = 2,//短视频MV
};

typedef NS_ENUM(NSUInteger, CameraCollocationPositionType) {
    CameraCollocationPositionTop    = 1 << 0,//顶部
    CameraCollocationPositionBottom = 1 << 1,//底部
};

typedef NS_ENUM(NSUInteger, CameraType) {
    CameraType_CutSameStyle     = 0,//全部
    CameraType_RecordPhoto      = 1,//录制 拍照
    CameraType_Video            = 2,//录制
    CameraType_Photo            = 3,//拍照
    CameraType_CreativeVideo    = 4,//模板拍摄
    CameraType_IDPhoto          = 5,//证件照拍摄
    CameraType_SlowMo           = 6,//慢动作
};

typedef NS_ENUM(NSUInteger, CameraModelType) {
    CameraModel_Onlyone    = 1 << 0,//录制完成立即返回
    CameraModel_Manytimes = 1 << 1,//录制完成保存到相册并不立即返回，可多次录制或拍照
};

NS_ASSUME_NONNULL_BEGIN

@interface VECameraConfiguration : NSObject<NSMutableCopying,NSCopying>

@property (nonatomic,copy,nullable)NSString    *cameraFilterType;

@property(nonatomic, assign) BOOL                   enableSoundtrack;
@property (nonatomic, copy) void(^ startupMusicViewCallBlock)(id _Nonnull music);
@property (nonatomic, copy) void(^ startupMusicViewCancelBlock)(void);

@property(nonatomic, assign)CameraType           cameraType;

/** 设置输出图像格式，默认为YES
 *  YES:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
 *  NO:kCVPixelFormatType_32BGRA
 */
@property(nonatomic, assign) bool captureAsYUV;

/** 拍摄模式 default CameraModel_Onlyone
 */
@property (nonatomic,assign) CameraModelType              cameraModelType;
/** 是否在拍摄完成就保存到相册再返回 default false 该参数只有在 CameraModel_Onlyone 模式下才生效
 */
@property (nonatomic,assign) bool                           cameraWriteToAlbum;
/** 前/后置摄像头 default AVCaptureDevicePositionFront
 */
@property (nonatomic,assign) AVCaptureDevicePosition        cameraCaptureDevicePosition;
/** 相机的方向 default RecordVideoOrientationAuto
 */
@property (nonatomic,assign) RecordVideoOrientation         cameraRecordOrientation;
/** 相机录制大小（正方形录制，非正方形录制）
 */
@property (nonatomic,assign) RecordVideoSizeType            cameraRecordSizeType;
/** 录制视频帧率 default 30
 */
@property (nonatomic,assign) int32_t                        cameraFrameRate;
/** 录制视频码率 default 4000000
 */
@property (nonatomic,assign) int32_t                        cameraBitRate;
/** 录制还是拍照 default RecordType_Video
 */
@property (nonatomic,assign) Record_Type                    cameraRecord_Type;
/** 视频输出路径
 */
@property (nonatomic,copy,nullable) NSString              *cameraOutputPath;
/**录制的视频的大小 (如：{720,1280}) default CGSizeZero
 */
@property (nonatomic,assign) CGSize                         cameraOutputSize;
/** 正方形录制时配置按钮的位置（美颜，延时，摄像头切换 三个按钮的位置）
 */
@property (nonatomic,assign) CameraCollocationPositionType  cameraCollocationPosition;
/** 正方形录制最大时长(default 10 )
 */
@property (nonatomic,assign) float                          cameraSquare_MaxVideoDuration;
/**非正方形录制最大时长 (default 0 ，不限制)
 */
@property (nonatomic,assign) float                          cameraNotSquare_MaxVideoDuration;
/**录制最小时长 (default 0 ，不限制 正方形录制和长方形录制都生效)
 */
@property (nonatomic,assign) float                          cameraMinVideoDuration;
/**反复录制时长 (default 2)开发中
 */
@property (nonatomic,assign) float                          repeatRecordDuration;

/** 是否开启滤镜功能(只有在开启Faceu的时候该参数才生效)
 */
@property (nonatomic , assign) bool                         enableFilter;

/**人脸道具贴纸
 */
@property (assign, nonatomic) bool                          enableFaceU;
/**是否启用网络下载faceUnity
 */
@property (assign, nonatomic)bool                           enableNetFaceUnity;
/**人脸道具贴纸下载路径
 */
@property (copy, nonatomic,nonnull)NSString                 *faceUURL;
/** 拍摄类型:可拍摄短视频MV(default true)
 */
@property (nonatomic,assign) bool                           cameraMV;
/** 拍摄类型:可拍摄视频(default true)
 */
@property (nonatomic,assign) bool                           cameraVideo;
/** 拍摄类型:可拍摄照片(default true)
 */
@property (nonatomic,assign) bool                           cameraPhoto;
/** 短视频MV录制最小时长(default 3s )
 */
@property (nonatomic,assign) float                          cameraMV_MinVideoDuration;
/** 短视频MV录制最大时长(default 15s )
 */
@property (nonatomic,assign) float                          cameraMV_MaxVideoDuration;
/** 从相机进入相册
 */
@property (nonatomic,copy,nonnull) void(^cameraEnterPhotoAlbumCallbackBlock)(void);


/** 是否隐藏相机进入相册按钮
 */
@property (nonatomic,assign) bool                           hiddenPhotoLib;

@property (nonatomic, strong) VEFaceUBeautyParams           * _Nullable faceUBeautyParams;
/*是否开启使用音乐录制. 如果需要切换音乐请设置好音乐下载路径,不设置则跳转到本地音乐界面 （editConfiguration.newmusicResourceURL）
 */
@property (nonatomic, assign) BOOL                  enableUseMusic;
/*传入需要录制时播放的音乐
 */
@property (nonatomic, strong) VEMusicInfo          * _Nullable musicInfo;

/** 录制完成后，是否合并成一个视频(default true)
 */
@property (nonatomic, assign) bool              enableMergeVideos;

/*是否启用相机水印
 */
@property (nonatomic, assign) BOOL              enabelCameraWaterMark;
/*片头水印时长
 */
@property (nonatomic, assign) float             cameraWaterMarkHeaderDuration;
/*片尾水印时长
 */
@property (nonatomic, assign) float             cameraWaterMarkEndDuration;
/*相机水印更新画面回调
 */
@property (nonatomic, copy, nullable) void (^cameraWaterProcessingCompletionBlock)(NSInteger type/*1:正方形录制，0：非正方形录制*/,RecordStatus status, UIView * _Nonnull waterMarkview ,float time);

/**启用相册设置 (default true)
 */
@property (nonatomic,assign) bool enableSet;
/**启用相册快慢速 (default true)
 */
@property (nonatomic,assign) bool enableFstOrSlow;
/**启用相册倒计时 (default true)
 */
@property (nonatomic,assign) bool enableCountdown;
/**启用相册闪光灯 (default true)
 */
@property (nonatomic,assign) bool enableFlash;
/**启用相册翻转 (default true)
 */
@property (nonatomic,assign) bool enableFlip;
/**启用相册美化 (default true)
 */
@property (nonatomic,assign) bool enableBeautify;
/**启用相册粒子 (default true)
 */
@property (nonatomic,assign) bool enableParticle;
/**启用相册比例 (default true)
 */
@property (nonatomic,assign) bool enableProportion;
/**启用相册滤镜 (default true)
 */
@property (nonatomic,assign) bool enableFile;
/**启用相册焦距 (default true)
 */
@property (nonatomic,assign) bool enableFocalLength;

/** 是否显示相册按钮(default true)
 */
@property (nonatomic, assign) bool isShowAlbumButton;

/** 是否显示模板按钮(default true)
 */
@property (nonatomic, assign) bool isShowTemplateButton;

/** 可设置最大拍摄时长(default true)
 */
@property (nonatomic, assign) bool enableSetMaxDuration;

@end

NS_ASSUME_NONNULL_END
