//
//  VEExportConfiguration.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import "VEExportConfiguration.h"

@implementation VEEndingMedia

- (instancetype)init {
    if (self = [super init]) {
        _isChangeTimeline = YES;
    }
    
    return self;
}

@end

@implementation VEExportConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _audioChannelNumbers = 2;
        _outputVideoMaxDuration = 0;
        _inputVideoMaxDuration = 0;
        //设置视频片尾和码率
        _endingMediaDisabled = true;
        _endPicUserName = @" ";
        _videoBitRate   = 6.0;
        _endPicDuration = 2.0;
        _endPicFadeDuration = 1.0;
        //设置水印是否可用
        _watermarkDisabled = true;
        _watermarkPosition = VEWatermarkPosition_leftBottom;
        
    }
    return self;
}

-(void)setAudioChannelNumbers:(int)audioChannelNumbers
{
    if( audioChannelNumbers > 6 )
    {
        _audioChannelNumbers = 6;
    }
    else if( audioChannelNumbers < 1 )
    {
        _audioChannelNumbers = 1;
    }
    else{
        _audioChannelNumbers = audioChannelNumbers;
    }
}

- (id)copyWithZone:(NSZone *)zone{
    VEExportConfiguration *copy   = [[[self class] allocWithZone:zone] init];
    copy.outputVideoMaxDuration   = _outputVideoMaxDuration;
    copy.inputVideoMaxDuration    = _inputVideoMaxDuration;
    //设置视频片尾和码率
    copy.endingMediaDisabled= _endingMediaDisabled;
    copy.endingMedia        = _endingMedia;
    copy.endPicUserName     = _endPicUserName;
    copy.endPicDuration     = _endPicDuration;
    copy.endPicFadeDuration = _endPicFadeDuration;
    copy.endPicImagepath    = _endPicImagepath;
    copy.videoBitRate       = _videoBitRate;
    //设置水印是否可用
    copy.watermarkDisabled  = _watermarkDisabled;
    copy.watermarkImage     = _watermarkImage;
    copy.watermarkPosition  = _watermarkPosition;
    copy.endPicDisabled     = _endPicDisabled;
    copy.waterDisabled      = _waterDisabled;
    copy.waterImage         = _waterImage;
    copy.waterPosition      = _waterPosition;
    //API模板
    copy.enableExportTemplate = _enableExportTemplate;
    copy.uploadTemplatePath = _uploadTemplatePath;
    copy.createTemplateCategoryPath = _createTemplateCategoryPath;
    copy.enableTemplateFragment = _enableTemplateFragment;
    //草稿云备份
    copy.uploadCloudBackupPath = _uploadCloudBackupPath;
    copy.updateCloudBackupPath = _updateCloudBackupPath;
    copy.deleteCloudBackupPath = _deleteCloudBackupPath;
    copy.cloudBackupListPath = _cloudBackupListPath;
    copy.userUniqueId = _userUniqueId;
    
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    VEExportConfiguration *copy   = [[[self class] allocWithZone:zone] init];
    copy.outputVideoMaxDuration   = _outputVideoMaxDuration;
    copy.inputVideoMaxDuration    = _inputVideoMaxDuration;
    //设置视频片尾和码率
    copy.endingMediaDisabled= _endingMediaDisabled;
    copy.endingMedia        = _endingMedia;
    copy.endPicUserName     = _endPicUserName;
    copy.endPicDuration     = _endPicDuration;
    copy.endPicFadeDuration = _endPicFadeDuration;
    copy.endPicImagepath    = _endPicImagepath;
    copy.videoBitRate       = _videoBitRate;
    //设置水印是否可用
    copy.watermarkDisabled  = _watermarkDisabled;
    copy.watermarkImage     = _watermarkImage;
    copy.watermarkPosition  = _watermarkPosition;
    copy.endPicDisabled     = _endPicDisabled;
    copy.waterDisabled      = _waterDisabled;
    copy.waterImage         = _waterImage;
    copy.waterPosition      = _waterPosition;
    //API模板
    copy.enableExportTemplate = _enableExportTemplate;
    copy.uploadTemplatePath = _uploadTemplatePath;
    copy.createTemplateCategoryPath = _createTemplateCategoryPath;
    copy.enableTemplateFragment = _enableTemplateFragment;
    //草稿云备份
    copy.uploadCloudBackupPath = _uploadCloudBackupPath;
    copy.updateCloudBackupPath = _updateCloudBackupPath;
    copy.deleteCloudBackupPath = _deleteCloudBackupPath;
    copy.cloudBackupListPath = _cloudBackupListPath;
    copy.userUniqueId = _userUniqueId;
    
    return copy;
    
}

- (void)setEndingMediaDisabled:(bool)endingMediaDisabled {
    _endPicDisabled = endingMediaDisabled;
    _endingMediaDisabled = endingMediaDisabled;
}

- (void)setWatermarkDisabled:(bool)watermarkDisabled {
    _watermarkDisabled = watermarkDisabled;
    _waterDisabled = watermarkDisabled;
}

- (void)setWatermarkImage:(UIImage *)watermarkImage {
    _watermarkImage = watermarkImage;
    _waterImage = watermarkImage;
}

- (void)setWatermarkPosition:(VEWatermarkPosition)watermarkPosition {
    _watermarkPosition = watermarkPosition;
    _waterPosition = watermarkPosition;
}

- (void)setEndPicDisabled:(bool)endPicDisabled {
    _endPicDisabled = endPicDisabled;
    _endingMediaDisabled = endPicDisabled;
}

- (void)setWaterDisabled:(bool)waterDisabled {
    _waterDisabled = waterDisabled;
    _watermarkDisabled = waterDisabled;
}

- (void)setWaterText:(NSString *)waterText{
    _waterText = waterText;
    if(waterText.length>0){
        _waterImage = nil;
    }
}
- (void)setWaterImage:(UIImage *)waterImage{
    _waterImage = waterImage;
    _watermarkImage = waterImage;
    if(waterImage){
        _waterText  = nil;
    }
}

- (void)setWaterPosition:(VEWatermarkPosition)waterPosition {
    _waterPosition = waterPosition;
    _watermarkPosition = waterPosition;
}

@end
