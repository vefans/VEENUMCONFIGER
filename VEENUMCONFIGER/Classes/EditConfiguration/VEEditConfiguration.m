//
//  VEEditConfiguration.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import "VEEditConfiguration.h"

@implementation VEEditConfiguration
- (void)setIsSingletrack:(bool)isSingletrack{
    _isSingletrack = isSingletrack;
    if(_isSingletrack){
        [VEConfigManager sharedManager].iPad_HD = NO;
    }else{
        [VEConfigManager sharedManager].iPad_HD = NO;
    }
}
- (instancetype)init{
    if(self = [super init]){
        _supportFileType                        = SUPPORT_ALL;
        _defaultSelectAlbum                     = VEDEFAULTSELECTALBUM_VIDEO;
        _mediaCountLimit                         = 0;
        _minVideoDuration = 0;
        _enableTextTitle                 = true;
        //片段编辑预设
        _enableSmear = true;
        _enableAperture = true;
        _enableHDR = true;
        _enableHoly = true;
        _enableSharpen = true;
        _enableSmear = true;
        _enableTon = true;
        _enableSpirit = true;
        _enableBlurry = true;
        _enableSingleMediaAdjust = true;
        _enableSingleSpecialEffects = true;
        _enableSingleMediaFilter         = true;
        _enableTrim                      = true;
        _enableTrim                      = true;
        _enableSplit                     = true;
        _enableReplace                  = true;
        _enableTransparency             = true;
        _enableEdit                      = true;
        _enableRotate = true;
        _enableMirror = true;
        _enableFlipUpAndDown = true;
        _enableTransition = true;
        _enableVolume = true;
        _enableSpeedcontrol              = true;
        _enableCopy                      = true;
        _enableSort                      = true;
        _enableImageDurationControl      = true;
        _enableProportion                = true;
        _enableReverseVideo              = true;
        _proportionType = VEPORTIONTYPE_AUTO;
        _enableAlbumCamera = true;
        _enableAnimation = true;
        _enableBeauty = true;
        
        _enableAuidoCurveSpeed = true;
        _enableMediaCurveSpeed = true;
        _enableCaptionKeyframe = true;
        _enableCaptionTrack = false;
        _enableMediaKeyframe = true;
        _enableAudioKeyframe = true;
        
        //编辑导出预设
        _enableMV           = false;
        _enableSubtitle     = true;
        _enableSubtitleToSpeech = false;
        _enableAIRecogSubtitle = true;
        _tencentAIRecogConfig = [[TencentCloudAIRecogConfig alloc] init];
        _baiDuCloudAIConfig = [[BaiDuCloudAIConfig alloc] init];
        _nuiSDKConfig = [[NuiSDKConfig alloc] init];
        _enableSticker      = true;
        _enablePicZoom = true;
        _enableBackgroundEdit = true;
        _enableFilter       = true;
        _enableEffect       = false;
        _enableEffectsVideo = true;
        _enableFreezeEffects= false;
        _enableDubbing      = true;
        _enableMusic        = true;
        _enableSoundEffect  = true;
        _enableMosaic       = true;
        _enableWatermark    = true;
        _enableDewatermark  = true;
        _enableFragmentedit = true;
        _enableLocalMusic   = true;
        _enableCollage      = true;
        _enableCover        = true;
        _enableDoodle       = true;
        _dubbingType    = VEDUBBINGTYPE_FIRST;
        //截取视频预设
        _defaultSelectMinOrMax          = kVEDefaultSelectCutMin;
        _trimDuration_OneSpecifyTime    = 15.0;
        _trimMinDuration_TwoSpecifyTime = 12.0;
        _trimMaxDuration_TwoSpecifyTime = 30.0;
        _trimExportVideoType            = TRIMEXPORTVIDEOTYPE_ORIGINAL;
        _presentAnimated            = true;
        _dissmissAnimated           = true;
        _netMaterialTypeURL = @"http://d.56show.com/filemanage2/public/filemanage/file/typeData";
        _newmvResourceURL = nil;
        _newmusicResourceURL = nil;
        _newartist = VEENUMCONFIGERLocalizedString(@"音乐家 Jason Shaw", nil);
        _newartistHomepageTitle = @"@audionautix.com";
        _newartistHomepageUrl = @"https://audionautix.com";
        _newmusicAuthorizationTitle = VEENUMCONFIGERLocalizedString(@"授权证书", nil);
        _newmusicAuthorizationUrl = @"http://d.56show.com/accredit/accredit.jpg";
        _filterResourceURL = nil;
        _subtitleResourceURL = nil;
        _effectResourceURL = nil;
        _specialEffectResourceURL = nil;
        _fontResourceURL = nil;
        _transitionURL  = nil;
        _enableDraft = false;
        _enableShowBackTipView = true;
        _enableShowRepeatView = true;
    }
    
    return self;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    VEEditConfiguration *copy   = [[[self class] allocWithZone:zone] init];
    copy.enableSmear = _enableSmear;
    copy.enableTon = _enableTon;
    copy.enableAperture = _enableAperture;
    copy.enableHDR = _enableHDR;
    copy.enableHoly = _enableHoly;
    copy.enableSpirit = _enableSpirit;
    copy.enableSharpen = _enableSharpen;
    copy.enableBlurry = _enableBlurry;
    copy.netMaterialTypeURL                     = _netMaterialTypeURL;
    copy.supportFileType                        = _supportFileType;
    copy.defaultSelectAlbum                     = _defaultSelectAlbum;
    copy.mediaCountLimit                        = _mediaCountLimit;
    copy.mediaMinCount                          = _mediaMinCount;
    copy.minVideoDuration                       = _minVideoDuration;
    copy.enableAlbumCamera                      = _enableAlbumCamera;
    copy.clickAlbumCameraBlackBlock             = _clickAlbumCameraBlackBlock;
    copy.isDisableEdit                          = _isDisableEdit;
    //片段编辑预设
    copy.enableTextTitle                 = _enableTextTitle;
    copy.enableSingleMediaAdjust         = _enableSingleMediaAdjust;
    copy.enableSingleSpecialEffects      = _enableSingleSpecialEffects;
    copy.enableSingleMediaFilter         = _enableSingleMediaFilter;
    copy.enableTrim                      = _enableTrim;
    copy.enableSplit                     = _enableSplit;
    copy.enableEdit                      = _enableEdit;
    copy.enableSpeedcontrol              = _enableSpeedcontrol;
    copy.enableCopy                      = _enableCopy;
    copy.enableSort                      = _enableSort;
    
    copy.enableAuidoCurveSpeed = _enableAuidoCurveSpeed;
    copy.enableMediaCurveSpeed = _enableMediaCurveSpeed;
    copy.enableCaptionKeyframe = _enableCaptionKeyframe;
    copy.enableCaptionTrack = _enableCaptionTrack;
    copy.enableMediaKeyframe = _enableMediaKeyframe;
    copy.enableAudioKeyframe = _enableAudioKeyframe;
    
    copy.enableRotate                      = _enableRotate;
    copy.enableMirror                      = _enableMirror;
    copy.enableFlipUpAndDown                      = _enableFlipUpAndDown;
    copy.enableTransition                      = _enableTransition;
    copy.enableVolume                      = _enableVolume;
    copy.enableAnimation = _enableAnimation;
    copy.enableBeauty = _enableBeauty;
    copy.enableImageDurationControl      = _enableImageDurationControl;
    copy.enableProportion                = _enableProportion ;
    copy.enableReverseVideo              = _enableReverseVideo;
    copy.proportionType                  = _proportionType;
    //编辑导出预设
    copy.enableMV               = _enableMV;
    copy.enableSubtitle         = _enableSubtitle;
    copy.enableAIRecogSubtitle  = _enableAIRecogSubtitle;
    copy.enableSubtitleToSpeech = _enableSubtitleToSpeech;
    copy.enableSticker           = _enableSticker;
    copy.enablePicZoom    = _enablePicZoom;
    copy.enableBackgroundEdit    = _enableBackgroundEdit;
    copy.enableFilter           = _enableFilter;
    copy.enableEffectsVideo     = _enableEffectsVideo;
    copy.enableFreezeEffects    = _enableFreezeEffects;
    copy.enableDewatermark      = _enableDewatermark;
    copy.enableWatermark        = _enableWatermark;
    copy.enableMosaic           = _enableMosaic;
    copy.enableDubbing          = _enableDubbing;
    copy.enableMusic            = _enableMusic;
    copy.enableSoundEffect      = _enableSoundEffect;
    copy.enableCollage          = _enableCollage;
    copy.enableCover            = _enableCover;
    copy.enableDoodle           = _enableDoodle;
    copy.enableFragmentedit     = _enableFragmentedit;
    copy.dubbingType                 = _dubbingType;
    copy.mvResourceURL               = _mvResourceURL;
    copy.enableLocalMusic            = _enableLocalMusic;
    copy.soundMusicResourceURL       = _soundMusicResourceURL;
    copy.soundMusicTypeResourceURL   = _soundMusicTypeResourceURL;
    //截取视频预设
    copy.defaultSelectMinOrMax      = _defaultSelectMinOrMax;
    copy.presentAnimated            = _presentAnimated;
    copy.dissmissAnimated           = _dissmissAnimated;
    copy.defaultSelectMinOrMax          = _defaultSelectMinOrMax;
    copy.trimDuration_OneSpecifyTime    = _trimDuration_OneSpecifyTime;
    copy.trimMinDuration_TwoSpecifyTime = _trimMinDuration_TwoSpecifyTime;
    copy.trimMaxDuration_TwoSpecifyTime = _trimMaxDuration_TwoSpecifyTime;
    copy.trimExportVideoType            = _trimExportVideoType;
    copy.newmvResourceURL               = _newmvResourceURL;
    copy.newmusicResourceURL            = _newmusicResourceURL;
    copy.newartist                      = _newartist;
    copy.newartistHomepageTitle         = _newartistHomepageTitle;
    copy.newartistHomepageUrl           = _newartistHomepageUrl;
    copy.newmusicAuthorizationTitle     = _newmusicAuthorizationTitle;
    copy.newmusicAuthorizationUrl       = _newmusicAuthorizationUrl;
    copy.filterResourceURL              = _filterResourceURL;
    copy.subtitleResourceURL            = _subtitleResourceURL;
    copy.effectResourceURL              = _effectResourceURL;
    copy.specialEffectResourceURL       = _specialEffectResourceURL;
    copy.fontResourceURL                = _fontResourceURL;
    copy.transitionURL                  = _transitionURL;
    copy.enableDraft                    = _enableDraft;
    copy.disableShowDraftButton         = _disableShowDraftButton;
    copy.enableAutoSaveDraft            = _enableAutoSaveDraft;
    copy.canvasVideosURL                = _canvasVideosURL;
    copy.enableShowBackTipView          = _enableShowBackTipView;
    copy.enableShowRepeatView           = _enableShowRepeatView;
    copy.templatePath                   = _templatePath;
    copy.stickerResourceMinVersion      = _stickerResourceMinVersion;
    copy.netMaterialURL = _netMaterialURL;

    return copy;
}

- (id)copyWithZone:(NSZone *)zone{
    VEEditConfiguration *copy   = [[[self class] allocWithZone:zone] init];
    copy.netMaterialTypeURL                     = _netMaterialTypeURL;
    copy.enableTon = _enableTon;
    copy.enableAperture = _enableAperture;
    copy.enableHDR = _enableHDR;
    copy.enableHoly = _enableHoly;
    copy.enableSpirit = _enableSpirit;
    copy.enableSharpen = _enableSharpen;
    copy.enableBlurry = _enableBlurry;
    copy.supportFileType                        = _supportFileType;
    copy.defaultSelectAlbum                     = _defaultSelectAlbum;
    copy.mediaCountLimit                         = _mediaCountLimit;
    copy.mediaMinCount                          = _mediaMinCount;
    copy.minVideoDuration                       = _minVideoDuration;
    copy.enableAlbumCamera                      = _enableAlbumCamera;
    copy.clickAlbumCameraBlackBlock             = _clickAlbumCameraBlackBlock;
    copy.isDisableEdit                          = _isDisableEdit;
    //片段编辑预设
    copy.enableTextTitle                 = _enableTextTitle;
    copy.enableSingleMediaAdjust         = _enableSingleMediaAdjust;
    copy.enableSingleSpecialEffects      = _enableSingleSpecialEffects;
    copy.enableSingleMediaFilter         = _enableSingleMediaFilter;
    copy.enableTrim                      = _enableTrim;
    copy.enableSplit                     = _enableSplit;
    copy.enableEdit                      = _enableEdit;
    copy.enableRotate                      = _enableRotate;
    copy.enableMirror                      = _enableMirror;
    copy.enableFlipUpAndDown                      = _enableFlipUpAndDown;
    copy.enableTransition                      = _enableTransition;
    copy.enableVolume                      = _enableVolume;
    copy.enableSpeedcontrol              = _enableSpeedcontrol;
    copy.enableCopy                      = _enableCopy;
    copy.enableSort                      = _enableSort;
    copy.enableImageDurationControl      = _enableImageDurationControl;
    copy.enableProportion                = _enableProportion ;
    copy.proportionType                  = _proportionType;
    copy.enableReverseVideo              = _enableReverseVideo;
    copy.enableAnimation = _enableAnimation;
    copy.enableBeauty = _enableBeauty;
    
    copy.enableAuidoCurveSpeed = _enableAuidoCurveSpeed;
    copy.enableMediaCurveSpeed = _enableMediaCurveSpeed;
    copy.enableCaptionKeyframe = _enableCaptionKeyframe;
    copy.enableCaptionTrack = _enableCaptionTrack;
    copy.enableMediaKeyframe = _enableMediaKeyframe;
    copy.enableAudioKeyframe = _enableAudioKeyframe;
    
    //编辑导出预设
    copy.enableMV   = _enableMV;
    copy.enableSubtitle  = _enableSubtitle;
    copy.enableAIRecogSubtitle  = _enableAIRecogSubtitle;
    copy.enableSubtitleToSpeech = _enableSubtitleToSpeech;
    copy.enableSticker   = _enableSticker;
    copy.enablePicZoom    = _enablePicZoom;
    copy.enableBackgroundEdit    = _enableBackgroundEdit;
    copy.enableEffectsVideo     = _enableEffectsVideo;
    copy.enableFreezeEffects    = _enableFreezeEffects;
    copy.enableDewatermark      = _enableDewatermark;
    copy.enableWatermark        = _enableWatermark;
    copy.enableMosaic           = _enableMosaic;
    copy.enableFilter    = _enableFilter;
    copy.enableDubbing   = _enableDubbing;
    copy.enableMusic     = _enableMusic;
    copy.enableSoundEffect           = _enableSoundEffect;
    copy.enableCollage               = _enableCollage;
    copy.enableCover            = _enableCover;
    copy.enableDoodle           = _enableDoodle;
    copy.enableFragmentedit          = _enableFragmentedit;
    copy.dubbingType                 = _dubbingType;
    copy.mvResourceURL               = _mvResourceURL;
    copy.enableLocalMusic            = _enableLocalMusic;
    copy.soundMusicResourceURL       = _soundMusicResourceURL;
    copy.soundMusicTypeResourceURL   = _soundMusicTypeResourceURL;
    //截取视频预设
    copy.defaultSelectMinOrMax      = _defaultSelectMinOrMax;
    copy.presentAnimated            = _presentAnimated;
    copy.dissmissAnimated           = _dissmissAnimated;
    copy.defaultSelectMinOrMax          = _defaultSelectMinOrMax;
    copy.trimDuration_OneSpecifyTime    = _trimDuration_OneSpecifyTime;
    copy.trimMinDuration_TwoSpecifyTime = _trimMinDuration_TwoSpecifyTime;
    copy.trimMaxDuration_TwoSpecifyTime = _trimMaxDuration_TwoSpecifyTime;
    copy.trimExportVideoType            = _trimExportVideoType;
    copy.newmvResourceURL               = _newmvResourceURL;
    copy.newmusicResourceURL            = _newmusicResourceURL;
    copy.newartist                      = _newartist;
    copy.newartistHomepageTitle         = _newartistHomepageTitle;
    copy.newartistHomepageUrl           = _newartistHomepageUrl;
    copy.newmusicAuthorizationTitle     = _newmusicAuthorizationTitle;
    copy.newmusicAuthorizationUrl       = _newmusicAuthorizationUrl;
    copy.filterResourceURL              = _filterResourceURL;
    copy.subtitleResourceURL            = _subtitleResourceURL;
    copy.effectResourceURL              = _effectResourceURL;
    copy.specialEffectResourceURL       = _specialEffectResourceURL;
    copy.fontResourceURL                = _fontResourceURL;
    copy.transitionURL                  = _transitionURL;
    copy.enableDraft                    = _enableDraft;
    copy.disableShowDraftButton         = _disableShowDraftButton;
    copy.enableAutoSaveDraft            = _enableAutoSaveDraft;
    copy.canvasVideosURL                = _canvasVideosURL;
    copy.enableShowBackTipView          = _enableShowBackTipView;
    copy.enableShowRepeatView           = _enableShowRepeatView;
    copy.templatePath                   = _templatePath;
    copy.stickerResourceMinVersion      = _stickerResourceMinVersion;
    copy.netMaterialURL = _netMaterialURL;

    return copy;
}

- (void)setEnableEffect:(bool)enableEffect {
    _enableSticker = enableEffect;
}

@end
