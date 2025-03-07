//
//  VEEditConfiguration.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import "VEEditConfiguration.h"

@implementation VEEditConfiguration
- (void)setDefaultFunction:(int)defaultFunction{
    _defaultFunction = defaultFunction;
}
- (void)setSupportFileType:(SUPPORTFILETYPE)supportFileType{
    _supportFileType = supportFileType;
}
- (void)setIsSingletrack:(bool)isSingletrack{
    _isSingletrack = isSingletrack;
    if(_isSingletrack){
        [VEConfigManager sharedManager].iPad_HD = NO;
    }else{
        [VEConfigManager sharedManager].iPad_HD = iPad;
    }
}
- (instancetype)init{
    if(self = [super init]){
        
        //相册界面
        _albumLayoutStyle = ALBUMLAYOUTSTYLE_ONE;
        _resultFileType = ALBUMFILETYPE_MediaInfo;
        _enableMagnifyingClass = true;
        _enableCloudDraft = true;
        _isShowSplitScreen = YES;
        _enableTemplateTheme = true;
        _supportFileType                        = SUPPORT_ALL;
        _defaultSelectAlbum                     = VEDEFAULTSELECTALBUM_VIDEO;
        _mediaCountLimit                         = 0;
        _minVideoDuration = 0;
        _enableOcclusion = true;
        _enableTextTitle = false;
        //片段编辑预设
        _enableParticle = true;
        _enableSmear = true;
        _enableAperture = true;
        _enableHDR = true;
        _enableHoly = true;
        _enableSharpen = true;
        _enableTon = true;
        _enableMask = true;
        _enableAntiShake = true;
        _enableVR = true;
        _disableShowDraftButton = false;
        _enableAutoSaveDraft = false;
        _enableSpirit = true;
        _enableBlurry = true;
        _enableSingleMediaAdjust = true;
        _enableSingleSpecialEffects = true;
        _enableSingleMediaFilter         = true;
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
        _enableSnapshort = true;
        _enableAuidoCurveSpeed = true;
        _enableMediaCurveSpeed = true;
        _enableCaptionKeyframe = true;
        _enableCaptionTrack = true;
        _enableMediaKeyframe = true;
        _enableAudioKeyframe = true;
        _enableDoodlePenKeyframe = true;
        _enableCutout = true;
        _enableCut_PIP = true;
        _enableNoise = true;
        _enableMorph = true;
        _enableDeformed = true;
        _enableEqualizer = true;
        _enableTemplateDraft = true;
        _enableEffectAccessObject = true;
        _enableMusicAlbumDraft = false;
        //编辑导出预设
        _enableMV           = false;
        _enableSubtitle     = true;
        _enableSubtitleTemplate = true;
        _enableSubtitleToSpeech = false;
        _enableAIRecogSubtitle = true;
        _privateCloudAIRecogConfig = [[PrivateCloudAIRecogConfig alloc] init];
        _tencentAIRecogConfig = [[TencentCloudAIRecogConfig alloc] init];
        _baiDuCloudAIConfig = [[BaiDuCloudAIConfig alloc] init];
        _nuiSDKConfig = [[NuiSDKConfig alloc] init];
        _enableSticker      = true;
        _enablePicZoom = true;
        _enableBackgroundEdit = true;
        _enableFilter       = true;
        _enableEffect       = false;
        _enableEffectsVideo = true;
        _enableFreezeEffects= true;
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
        _enableDraft = false;
        _enableShowBackTipView = true;
        _enableShowRepeatView = true;
        _enableSubtitleStyleInTool = true;
        _enableSubtitleTemplate = true;//文字模板
        _dubbingType    = VEDUBBINGTYPE_FIRST;
        //截取视频预设
        _defaultSelectMinOrMax          = kVEDefaultSelectCutMin;
        _trimDuration_OneSpecifyTime    = 15.0;
        _trimMinDuration_TwoSpecifyTime = 12.0;
        _trimMaxDuration_TwoSpecifyTime = 30.0;
        _trimExportVideoType            = TRIMEXPORTVIDEOTYPE_ORIGINAL;
        _presentAnimated            = true;
        _dissmissAnimated           = true;
        _newmvResourceURL = nil;
        _newmusicResourceURL = nil;
        _newartist = VEENUMCONFIGERLocalizedString(@"音乐家 Jason Shaw", nil);
        _newartistHomepageTitle = @"@audionautix.com";
        _newartistHomepageUrl = @"https://audionautix.com";
        _newmusicAuthorizationTitle = VEENUMCONFIGERLocalizedString(@"授权证书", nil);
        _filterResourceURL = nil;
        _subtitleResourceURL = nil;
        _effectResourceURL = nil;
        _specialEffectResourceURL = nil;
        _fontResourceURL = nil;
        _transitionURL  = nil;
        
        
        _enableSoundVolume = true;
        _enableSoundFade = true;
        _enableSoundEqualizer = true;
        _enableSoundPlanting = true;
        _enableSoundSplit = true;
        _enableSoundVoice = true;
        _enableSoundSpeed = true;
        _enableSoundDelete = true;
        _enableSoundCopy = true;
        _enableSoundorginal = true;
        _enableSingleAudioSepar = true;
        _enableHierarchy = true;
        _enableMixedMode = true;
        _enablePIPBind = true;
        _enableResetRect = true;
        _enableLockAngleSize = true;
        _enableHiddenMedia = true;
        _isOnlyFragmentEdit = false;
        _enableBasicProperties = true;
        _enableSmartCrop = true;
        _enableExtractFrames = true;
        _enableMotionflow = true;
        _isDisableSelectGif = false;
        _defaultErasePenType = DefaultErasePenType_Manual;
        _isTrimShowClipView = false;
    }
    
    return self;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    VEEditConfiguration *copy   = [[[self class] allocWithZone:zone] init];
    //相册界面
    copy.albumLayoutStyle = _albumLayoutStyle;
    copy.enableCloudDraft = _enableCloudDraft;
    copy.isHiddenNetworkMaterial = _isHiddenNetworkMaterial;
    copy.isShowBookNetworkMaterial = _isShowBookNetworkMaterial;
    copy.resultFileType = _resultFileType;
    copy.thumbDisable = _thumbDisable;
    copy.isShowSplitScreen = _isShowSplitScreen;
    
    copy.enableOcclusion = _enableOcclusion;
    copy.enableParticle = _enableParticle;
    copy.enableSmear = _enableSmear;
    copy.enableTon = _enableTon;
    copy.enableAperture = _enableAperture;
    copy.enableHDR = _enableHDR;
    copy.enableHoly = _enableHoly;
    copy.enableSnapshort = _enableSnapshort;
    copy.enableSpirit = _enableSpirit;
    copy.enableSharpen = _enableSharpen;
    copy.enableBlurry = _enableBlurry;
    copy.netMaterialTypeURL                     = _netMaterialTypeURL;
    copy.supportFileType                        = _supportFileType;
    copy.isLivePhotoDisable                       = _isLivePhotoDisable;
    copy.defaultSelectAlbum                     = _defaultSelectAlbum;
    copy.mediaCountLimit                        = _mediaCountLimit;
    copy.mediaMinCount                          = _mediaMinCount;
    copy.minVideoDuration                       = _minVideoDuration;
    copy.maxVideoDuration                       = _maxVideoDuration;
    copy.enableAlbumCamera                      = _enableAlbumCamera;
    copy.clickAlbumCameraBackBlock             = _clickAlbumCameraBackBlock;
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
    copy.enableDoodlePenKeyframe = _enableDoodlePenKeyframe;
    
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
    copy.enableBasicProperties           = _enableBasicProperties;
    //编辑导出预设
    copy.enableMV               = _enableMV;
    copy.enableSubtitle         = _enableSubtitle;
    copy.enableAttributedString = _enableAttributedString;
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
    copy.cardMusicResourceURL           = _cardMusicResourceURL;
    copy.newartist                      = _newartist;
    copy.newartistHomepageTitle         = _newartistHomepageTitle;
    copy.newartistHomepageUrl           = _newartistHomepageUrl;
    copy.newmusicAuthorizationTitle     = _newmusicAuthorizationTitle;
    copy.newmusicAuthorizationUrl       = _newmusicAuthorizationUrl;
    copy.filterResourceURL              = _filterResourceURL;
    copy.subtitleResourceURL            = _subtitleResourceURL;
    copy.flowerWordResourceURL          = _flowerWordResourceURL;
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
    copy.templateCategoryPath           = _templateCategoryPath;
    copy.templatePath                   = _templatePath;
    copy.stickerResourceMinVersion      = _stickerResourceMinVersion;
    copy.netMaterialURL = _netMaterialURL;
    copy.onlineAlbumPath = _onlineAlbumPath;
    copy.doodlePenResourcePath = _doodlePenResourcePath;
    copy.maskResourcePath = _maskResourcePath;
    copy.searchMediaFromTextPath = _searchMediaFromTextPath;
    copy.enableSubtitleStyleInTool = _enableSubtitleStyleInTool;
    copy.getTextContentFromLinkPath = _getTextContentFromLinkPath;
    copy.functionEnablePath = _functionEnablePath;
    
    
    copy.enableSoundVolume = _enableSoundVolume;
    copy.enableSoundFade = _enableSoundFade;
    copy.enableSoundEqualizer = _enableSoundEqualizer;
    copy.enableSoundPlanting = _enableSoundPlanting;
    copy.enableSoundSplit = _enableSoundSplit;
    copy.enableSoundVoice = _enableSoundVoice;
    copy.enableSoundSpeed = _enableSoundSpeed;
    copy.enableSoundDelete = _enableSoundDelete;
    copy.enableSoundCopy = _enableSoundCopy;
    copy.enableSoundorginal = _enableSoundorginal;
    copy.enableSingleAudioSepar = _enableSingleAudioSepar;
    copy.enableHierarchy = _enableHierarchy;
    copy.enableMixedMode = _enableMixedMode;
    copy.enablePIPBind = _enablePIPBind;
    copy.enableEffectAccessObject = _enableEffectAccessObject;
    copy.enableResetRect = _enableResetRect;
    copy.enableLockAngleSize = _enableLockAngleSize;
    copy.enableHiddenMedia = _enableHiddenMedia;
    copy.isOnlyFragmentEdit = _isOnlyFragmentEdit;
    copy.enableMorph = _enableMorph;
    copy.enableCutout = _enableCutout;
    copy.enableMask = _enableMask;
    copy.enableAntiShake = _enableAntiShake;
    copy.enableVR = _enableVR;
    copy.enableCut_PIP = _enableCut_PIP;
    copy.enableReplace = _enableReplace;
    copy.enableTransparency = _enableTransparency;
    copy.enableEqualizer = _enableEqualizer;
    copy.enableNoise = _enableNoise;
    copy.sourcesKey = _sourcesKey;
    copy.enableSmartCrop = _enableSmartCrop;
    copy.getMusicFromLinkPath = _getMusicFromLinkPath;
    copy.musicResourcesConfigPath = _musicResourcesConfigPath;
    copy.enableExtractFrames = _enableExtractFrames;
    copy.enableMotionflow = _enableMotionflow;
    
    copy.isDisableSelectGif = _isDisableSelectGif;
    copy.defaultErasePenType = _defaultErasePenType;
    copy.aiChatPath = _aiChatPath;
    copy.isTrimShowClipView = _isTrimShowClipView;
    return copy;
}

- (id)copyWithZone:(NSZone *)zone{
    return [self mutableCopyWithZone:zone];
}

- (void)setEnableEffect:(bool)enableEffect {
    _enableSticker = enableEffect;
}

@end
