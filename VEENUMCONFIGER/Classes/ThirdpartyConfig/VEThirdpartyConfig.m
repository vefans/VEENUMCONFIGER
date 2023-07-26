//
//  VEThirdpartyConfig.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import "VEThirdpartyConfig.h"


@implementation PrivateCloudAIRecogConfig

- (instancetype)init {
    if (self = [super init]) {
        _appKey = @"";
        _tokenURL = @"";
        _uploadAudioFileURL = @"";
        _receiveCmdURL = @"";
    }
    return self;
}

@end

@implementation TencentCloudAIRecogConfig

- (instancetype)init {
    if (self = [super init]) {
        _appId = @"1259660397";
        _secretId = @"AKIDmOlskNuJdiY8Sqhxf8LI5wXtzpQ63K4Y";
        _secretKey = @"OXQcYEiwusa1EAqGPIxM5apoXzCBuACy";
    }
    return self;
}

@end

@implementation BaiDuCloudAIConfig

- (instancetype)init {
    if (self = [super init]) {
        _bodyAnalysisAppKey = @"Ph5tLQC2pFvL6GNTpKhGW1NG";
        _bodyAnalysisSecretKey = @"Eu0L4sUxAMMqgFvmTuYC8PqsLrqrQz2V";
        _imageEffectAppKey = @"yd0zA5MGT5pnV2UDajkO1VAw";
        _imageEffectSecretKey = @"5UwZYEOWFGCbuqg5391LcWGlRO5YmChP";
    }
    return self;
}

@end

@implementation NuiSDKConfig


@synthesize token;

- (instancetype)init {
    if (self = [super init]) {
        _accessKeyId = @"LTAI5tEZ76Dn9W4rWbidYkMF";
        _accessKeySecret = @"gPccwR4Lre0Ih7XmV8fR2gky16pfzs";
        _appKey = @"t5eSCO5f15lBLYvN";
    }
    
    return self;
}

@end
