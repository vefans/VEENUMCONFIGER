//
//  VEConfigManager.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/21.
//

#import "VEConfigManager.h"
#import <LibVECore/Common.h>
#import <SDWebImage/SDWebImage.h>

NSString *const VEStartExportNotification = @"VEStartExportNotification";

@implementation VEConfigManager
- (void)setAppKey:(NSString *)appKey{
    _appKey = appKey;
    if(![VEConfigManager sharedManager].editConfiguration.sourcesKey){
        [VEConfigManager sharedManager].editConfiguration.sourcesKey = _appKey;
    }
    if(![VEConfigManager sharedManager].peEditConfiguration.sourcesKey){
        [VEConfigManager sharedManager].peEditConfiguration.sourcesKey = _appKey;
    }
}
+ (instancetype)sharedManager
{
    static VEConfigManager *singleOjbect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleOjbect = [[self alloc] init];
    });
    
    NSString *style = [[NSUserDefaults standardUserDefaults] objectForKey:kVEInterfaceStyle];
    if( [style isEqualToString:@"Pro"] )
    {
        if( singleOjbect.editConfiguration.isSingletrack == NO )
            singleOjbect.editConfiguration.isSingletrack = YES;
        if( singleOjbect.peEditConfiguration.isSingletrack == NO )
            singleOjbect.peEditConfiguration.isSingletrack = YES;
    }
    [[SDImageCache sharedImageCache] config].maxMemoryCost = 50 * 1024 * 1024;
    [[SDImageCache sharedImageCache] config].maxMemoryCount = 50;
    
    return singleOjbect;
}

- (instancetype)init
{
    if (self = [super init]) {
        _directory = NSHomeDirectory();//[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];//
        _editConfiguration = [[VEEditConfiguration alloc] init];
        _cameraConfiguration = [[VECameraConfiguration alloc] init];
        _exportConfiguration = [[VEExportConfiguration alloc] init];
        _peEditConfiguration = [[VEEditConfiguration alloc] init];
        _peCameraConfiguration = [[VECameraConfiguration alloc] init];
        _peExportConfiguration = [[VEExportConfiguration alloc] init];
        _aiConfiguration = [[AIConfiguration alloc] init];
        _mainColor = UIColorFromRGB(0xffd500);
        _exportButtonTitleColor = _iPad_HD ? VIEW_IPAD_COLOR : [UIColor blackColor];
        _exportButtonBackgroundColor = _iPad_HD ? UIColorFromRGB(0x3c3d3d) : [UIColor whiteColor];
        _viewBackgroundColor = UIColorFromRGB(0x111111);//[UIColor blackColor];
        _navigationBackgroundColor = [UIColor blackColor];
        _navigationBarTitleColor = UIColorFromRGB(0xcccccc);
        _navigationBarTitleFont = [UIFont boldSystemFontOfSize:16];
        _freezeFXCategoryId = 57685258;
        _toolsTitleFont = [UIFont systemFontOfSize:10];
        //_toolsTitleColor = UIColorFromRGB(0xcccccc);
        _backgroundStyle = UIBgStyleLightContent;
        _isSelectFaces = NO;
        _hasInit = true;
        _enableBtnLikeTemp = NO;
        
    }
    return self;
}
- (void)setDirectory:(NSString *)directory{
    _directory = directory;
    [DirectoryManager sharedManager].directory = _directory;
}
- (UIColor *)viewBackgroundColor{
    return _viewBackgroundColor;
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

- (void)startExportWithMinWH:(int)minWH {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:VEStartExportNotification object:[NSNumber numberWithInt:minWH]];
    });
}

@end
