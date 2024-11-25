//
//  VEConfigManager.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/21.
//

#import "VEConfigManager.h"
#import <LibVECore/Common.h>
#import <LibVECore/PECore.h>
#import "VEHelp.h"
#ifdef EnableSDWebImage
#import <SDWebImage/SDWebImage.h>
#endif

NSString *const VEStartExportNotification = @"VEStartExportNotification";
NSString *const VERemoveDefaultWatermarkNotification = @"VERemoveDefaultWatermarkNotification";

@implementation VEConfigManager

//判断是否可以使用 html 抠图
-(void)htmlSegmentation:( UIViewController * ) viewController
{
    if (@available(iOS 16.0, *))
    {
        @autoreleasepool {
            PECore * imageCoreSDK = [[PECore alloc] initWithAPPKey:[VEConfigManager sharedManager].appKey
                                                         APPSecret:[VEConfigManager sharedManager].appSecret
                                                        LicenceKey:[VEConfigManager sharedManager].licenceKey
                                                              size:CGSizeMake(1000, 1000)
                                                        resultFail:^(NSError *error) {
                NSLog(@"initSDKError:%@", error.localizedDescription);
            }];
            WeakSelf(self)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                StrongSelf(self);
                __block PECore * segmentCoreSDK = imageCoreSDK;
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0); // 创建信号量，初始值为0
                {
                    UIImage *image = [VEHelp imageWithContentOfFile:@"分享"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [imageCoreSDK segmentation_ImageWithImageData:UIImagePNGRepresentation(image) atView:viewController.view atCancelBtn:nil atIsDebug:true atCompletionHandler:^(NSString *message, id messageBody) {
                            if( [message isEqualToString:@"SegmentationImage"] )
                            {;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    segmentCoreSDK = nil;
                                });
                                dispatch_semaphore_signal(semaphore); // 发送信号量，标记请求完成
                            }
                            else if( [message isEqualToString:@"Progress"] )
                            {
                                NSLog(@"segmentation Image Progress: %.2f", [messageBody floatValue]);
                            }
                            else if( [message isEqualToString:@"Failure"] )
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    segmentCoreSDK = nil;
                                });
                                NSLog(@"segmentation Image Failure");
                                [VEConfigManager sharedManager].isNoHtmlAutoSegmentImage = true;
                                dispatch_semaphore_signal(semaphore); // 发送信号量，标记请求完成
                            }
                        }];
                    });
                }
            });
        }
    }else{
        [VEConfigManager sharedManager].isNoHtmlAutoSegmentImage = true;
    }
}

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
#ifdef EnableSDWebImage
    [[SDImageCache sharedImageCache] config].maxMemoryCost = 50 * 1024 * 1024;
    [[SDImageCache sharedImageCache] config].maxMemoryCount = 50;
#else
    [VEHelp setVeSDWebImageMaxMemory];
#endif
    return singleOjbect;
}

- (instancetype)init
{
    if (self = [super init]) {
        _subtiteJsonFontSize = 8.0;
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
        _selectedTypeColors = @[(id)UIColorFromRGB(0xdddff8).CGColor, (id)UIColorFromRGB(0xefe5e7).CGColor, (id)UIColorFromRGB(0xfbdcdb).CGColor];
        _textColorOnGradientView = [UIColor blackColor];
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
        case OtherLanguages:
            [[NSUserDefaults standardUserDefaults] setObject:@"system" forKey:kVELanguage];
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

- (void)removeDefaultWatermark {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:VERemoveDefaultWatermarkNotification object:nil];
    });
}

@end
