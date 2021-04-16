//
//  VEExportConfiguration.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import "VEExportConfiguration.h"

@implementation VEExportConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
        _audioChannelNumbers = 2;
        _outputVideoMaxDuration = 0;
        _inputVideoMaxDuration = 0;
        //设置视频片尾和码率
        _endPicDisabled = true;
        _endPicUserName = @" ";
        _videoBitRate   = 6.0;
        _endPicDuration = 2.0;
        _endPicFadeDuration = 1.0;
        //设置水印是否可用
        _waterDisabled = true;
        _waterText = nil;
        _waterImage = nil;
        _waterPosition = WATERPOSITION_LEFTBOTTOM;
        
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
    copy.endPicDisabled     = _endPicDisabled;
    copy.endPicUserName     = _endPicUserName;
    copy.endPicDuration     = _endPicDuration;
    copy.endPicFadeDuration = _endPicFadeDuration;
    copy.endPicImagepath    = _endPicImagepath;
    copy.videoBitRate       = _videoBitRate;
    //设置水印是否可用
    copy.waterDisabled      = _waterDisabled;
    copy.waterText          = _waterText;
    copy.waterImage         = _waterImage;
    copy.waterPosition      = _waterPosition;
    return copy;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    VEExportConfiguration *copy   = [[[self class] allocWithZone:zone] init];
    copy.outputVideoMaxDuration   = _outputVideoMaxDuration;
    copy.inputVideoMaxDuration    = _inputVideoMaxDuration;
    //设置视频片尾和码率
    copy.endPicDisabled     = _endPicDisabled;
    copy.endPicUserName     = _endPicUserName;
    copy.endPicDuration     = _endPicDuration;
    copy.endPicFadeDuration = _endPicFadeDuration;
    copy.endPicImagepath    = _endPicImagepath;
    copy.videoBitRate       = _videoBitRate;
    //设置水印是否可用
    copy.waterDisabled      = _waterDisabled;
    copy.waterText          = _waterText;
    copy.waterImage         = _waterImage;
    copy.waterPosition      = _waterPosition;
    return copy;
    
}

- (void)setWaterText:(NSString *)waterText{
    _waterText = waterText;
    if(waterText.length>0){
        _waterImage = nil;
    }
}
- (void)setWaterImage:(UIImage *)waterImage{
    _waterImage = waterImage;
    if(waterImage){
        _waterText  = nil;
    }
}

@end
