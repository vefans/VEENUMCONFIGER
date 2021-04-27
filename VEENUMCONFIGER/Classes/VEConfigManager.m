//
//  VEConfigManager.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/21.
//

#import "VEConfigManager.h"

@implementation VEConfigManager

+ (instancetype)sharedManager
{
    static VEConfigManager *singleOjbect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleOjbect = [[self alloc] init];
    });
    return singleOjbect;
}

- (instancetype)init
{
    if (self = [super init]) {
        _editConfiguration = [[VEEditConfiguration alloc] init];
        _cameraConfiguration = [[VECameraConfiguration alloc] init];
        _exportConfiguration = [[VEExportConfiguration alloc] init];
        _mainColor = UIColorFromRGB(0xffd500);
        _exportButtonTitleColor = UIColorFromRGB(0x27262c);
        _viewBackgroundColor = [UIColor blackColor];
        _navigationBackgroundColor = [UIColor blackColor];
        _navigationBarTitleColor = [UIColor whiteColor];
        _navigationBarTitleFont = [UIFont boldSystemFontOfSize:20];
        _freezeFXCategoryId = 57685258;
    }
    return self;
}

- (void)setLanguage:(SUPPORTLANGUAGE)language {
    _language = language;
    switch (language) {
        case CHINESE:
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:kVELanguage];
            break;
            
        case ENGLISH:
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:kVELanguage];
            break;
        
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end