//
//  VECameraConfiguration.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import "VECameraConfiguration.h"

@implementation VECameraConfiguration

- (instancetype)init{
    if(self = [super init]){
        _cameraFilterType = @"filter";
        _captureAsYUV                       = true;
        _cameraCaptureDevicePosition        = AVCaptureDevicePositionFront;
        _cameraRecordSizeType               = RecordVideoTypeMixed;
        _cameraMV                           = true;
        _cameraVideo                        = true;
        _cameraPhoto                        = true;
        _cameraRecord_Type                  = RecordType_Video;
        _cameraRecordOrientation            = RecordVideoOrientationAuto;
        _cameraSquare_MaxVideoDuration      = 10.0;
        _cameraNotSquare_MaxVideoDuration   = 0.0;
        _cameraMV_MinVideoDuration          = 3;
        _cameraMV_MaxVideoDuration          = 15;
        _repeatRecordDuration               = 2.0;
        _cameraOutputSize                   = CGSizeZero;
        _cameraFrameRate                    = 30.0;
        _cameraBitRate                      = 4.0 * 1000 * 1000;
        _cameraCollocationPosition          = CameraCollocationPositionBottom;
        _cameraOutputPath                   = @"";
        _cameraModelType                    = CameraModel_Onlyone;
        _cameraWriteToAlbum                 = false;
        _enableFaceU                        = false;
        _faceUURL = @"http://dianbook.17rd.com/api/shortvideo/getfaceprop2";
        _enableNetFaceUnity                 = false;
        _enableFilter                       = true;
        _enableUseMusic                     = false;
        _musicInfo                          = nil;
        _faceUBeautyParams                  = [[VEFaceUBeautyParams alloc] init];
        _enabelCameraWaterMark              = NO;
        _cameraWaterMarkHeaderDuration      = 0;
        _cameraWaterMarkEndDuration         = 0;
        _enableMergeVideos                  = true;
        
        _enableSet = true;
        _enableFstOrSlow = true;
        _enableCountdown = true;
        _enableFlash = true;
        _enableFlip = true;
        _enableBeautify = true;
        _enableParticle = true;
        _enableProportion = true;
        _enableFile = true;
        _enableFocalLength = true;
        _isShowAlbumButton = true;
        _isShowTemplateButton = true;
        _enableSetMaxDuration = true;
    }
    
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    VECameraConfiguration *copy   = [[[self class] allocWithZone:zone] init];
    copy.captureAsYUV                       = _captureAsYUV;
    copy.cameraCaptureDevicePosition        = _cameraCaptureDevicePosition;
    copy.cameraRecordSizeType               = _cameraRecordSizeType;
    copy.cameraRecord_Type                  = _cameraRecord_Type;
    copy.cameraRecordOrientation            = _cameraRecordOrientation;
    copy.cameraSquare_MaxVideoDuration      = _cameraSquare_MaxVideoDuration;
    copy.cameraNotSquare_MaxVideoDuration   = _cameraNotSquare_MaxVideoDuration;
    copy.cameraMinVideoDuration             = _cameraMinVideoDuration;
    copy.cameraOutputSize                   = _cameraOutputSize;
    copy.cameraFrameRate                    = _cameraFrameRate;
    copy.cameraBitRate                      = _cameraBitRate;
    copy.cameraCollocationPosition          = _cameraCollocationPosition;
    copy.cameraOutputPath                   = _cameraOutputPath;
    copy.cameraModelType                    = _cameraModelType;
    copy.cameraWriteToAlbum                 = _cameraWriteToAlbum;
    copy.enableFaceU                        = _enableFaceU;
    copy.faceUURL                           = _faceUURL;
    copy.enableNetFaceUnity                 = _enableNetFaceUnity;
    copy.hiddenPhotoLib                     = _hiddenPhotoLib;
    copy.enableFilter                       = _enableFilter;
    copy.enableUseMusic                     = _enableUseMusic;
    copy.musicInfo                          = _musicInfo;
    copy.faceUBeautyParams                  = [_faceUBeautyParams copy];
    copy.cameraEnterPhotoAlbumCallbackBlock= _cameraEnterPhotoAlbumCallbackBlock;
    copy.cameraMV                           = _cameraMV;
    copy.cameraVideo                        = _cameraVideo;
    copy.cameraPhoto                        = _cameraPhoto;
    copy.cameraMV_MinVideoDuration          = _cameraMV_MinVideoDuration;
    copy.cameraMV_MaxVideoDuration          = _cameraMV_MaxVideoDuration;
    copy.enableMergeVideos                  = _enableMergeVideos;
    
    copy.enableSet = _enableSet;
    copy.enableFstOrSlow = _enableFstOrSlow;
    copy.enableCountdown = _enableCountdown;
    copy.enableFlash = _enableFlash;
    copy.enableFlip = _enableFlip;
    copy.enableBeautify = _enableBeautify;
    copy.enableParticle = _enableParticle;
    copy.enableProportion = _enableProportion;
    copy.enableFile = _enableFile;
    copy.enableFocalLength = _enableFocalLength;
//    /*传入相机水印图片
//     */
//    @property (nonatomic, strong) UIImage          * cameraWaterMarkHeader;
//    /*传入相机水印图片
//     */
//    @property (nonatomic, strong) UIImage          * cameraWaterMarkBody;
//    /*传入相机水印图片
//     */
//    @property (nonatomic, strong) UIImage          * cameraWaterMarkEnd;
//    copy.cameraWaterMarkEnd                  = _cameraWaterMarkEnd;
//    copy.cameraWaterMarkHeader                  = _cameraWaterMarkHeader;
//    copy.cameraWaterMarkBody                    = _cameraWaterMarkBody;
    copy.enabelCameraWaterMark                  = _enabelCameraWaterMark;
    copy.cameraWaterMarkHeaderDuration          = _cameraWaterMarkHeaderDuration;
    copy.cameraWaterMarkEndDuration          = _cameraWaterMarkEndDuration;
    copy.cameraWaterProcessingCompletionBlock   = _cameraWaterProcessingCompletionBlock;
    copy.isShowAlbumButton = _isShowAlbumButton;
    copy.isShowTemplateButton = _isShowTemplateButton;
    copy.enableSetMaxDuration = _enableSetMaxDuration;
    
    return copy;
}

- (id)copyWithZone:(NSZone *)zone{
    VECameraConfiguration *copy   = [[[self class] allocWithZone:zone] init];
    copy.captureAsYUV                       = _captureAsYUV;
    copy.cameraCaptureDevicePosition        = _cameraCaptureDevicePosition;
    copy.cameraRecordSizeType               = _cameraRecordSizeType;
    copy.cameraRecord_Type                  = _cameraRecord_Type;
    copy.cameraRecordOrientation            = _cameraRecordOrientation;
    copy.cameraSquare_MaxVideoDuration      = _cameraSquare_MaxVideoDuration;
    copy.cameraNotSquare_MaxVideoDuration   = _cameraNotSquare_MaxVideoDuration;
    copy.cameraMinVideoDuration             = _cameraMinVideoDuration;
    copy.cameraOutputSize                   = _cameraOutputSize;
    copy.cameraFrameRate                    = _cameraFrameRate;
    copy.cameraBitRate                      = _cameraBitRate;
    copy.cameraCollocationPosition          = _cameraCollocationPosition;
    copy.cameraOutputPath                   = _cameraOutputPath;
    copy.cameraModelType                    = _cameraModelType;
    copy.cameraWriteToAlbum                 = _cameraWriteToAlbum;
    copy.enableFaceU                        = _enableFaceU;
    copy.faceUURL                           = _faceUURL;
    copy.enableNetFaceUnity                 = _enableNetFaceUnity;
    copy.cameraEnterPhotoAlbumCallbackBlock= _cameraEnterPhotoAlbumCallbackBlock;
    copy.hiddenPhotoLib                     = _hiddenPhotoLib;
    copy.enableFilter                       = _enableFilter;
    copy.enableUseMusic                    = _enableUseMusic;
    copy.musicInfo                          = _musicInfo;
    copy.faceUBeautyParams                  = [_faceUBeautyParams copy];
    copy.cameraMV                           = _cameraMV;
    copy.cameraVideo                        = _cameraVideo;
    copy.cameraPhoto                        = _cameraPhoto;
    copy.cameraMV_MinVideoDuration          = _cameraMV_MinVideoDuration;
    copy.cameraMV_MaxVideoDuration          = _cameraMV_MaxVideoDuration;
    copy.enableMergeVideos                  = _enableMergeVideos;
    
    copy.enableSet = _enableSet;
    copy.enableFstOrSlow = _enableFstOrSlow;
    copy.enableCountdown = _enableCountdown;
    copy.enableFlash = _enableFlash;
    copy.enableFlip = _enableFlip;
    copy.enableBeautify = _enableBeautify;
    copy.enableParticle = _enableParticle;
    copy.enableProportion = _enableProportion;
    copy.enableFile = _enableFile;
    copy.enableFocalLength = _enableFocalLength;
//    copy.cameraWaterMarkEnd                  = _cameraWaterMarkEnd;
//    copy.cameraWaterMarkHeader                  = _cameraWaterMarkHeader;
//    copy.cameraWaterMarkBody                    = _cameraWaterMarkBody;
    copy.enabelCameraWaterMark                  = _enabelCameraWaterMark;
    copy.cameraWaterMarkHeaderDuration          = _cameraWaterMarkHeaderDuration;
    copy.cameraWaterMarkEndDuration          = _cameraWaterMarkEndDuration;
    copy.cameraWaterProcessingCompletionBlock   = _cameraWaterProcessingCompletionBlock;
    copy.isShowAlbumButton = _isShowAlbumButton;
    copy.isShowTemplateButton = _isShowTemplateButton;
    copy.enableSetMaxDuration = _enableSetMaxDuration;
    
    return copy;
}

@end
