//
//  VEConfigManager.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/21.
//

#import <Foundation/Foundation.h>
#import <VEENUMCONFIGER/VECameraConfiguration.h>
#import <VEENUMCONFIGER/VEEditConfiguration.h>
#import <VEENUMCONFIGER/VEExportConfiguration.h>

/**支持的语言
 */
typedef NS_ENUM(NSInteger, SUPPORTLANGUAGE){
    CHINESE,    //中文
    
    ENGLISH,     //英文
    Spanish,//西语
    Portuguese,//葡语
    Russian,//俄语
    Japanese,//日语
    French,//法语
    Korean,//韩语
    ChineseTraditional,//繁体中文
    OtherLanguages,// 其他语言
};

//编辑完成导出结束回调
typedef void(^VECompletionHandler) (NSString * videoPath);
//编辑取消回调
typedef void(^VECancelHandler) (void);
//编辑取消回调
typedef void(^VEFailedHandler) (NSError * error);

@protocol VESDKDelegate <NSObject>

@optional

/** 设置faceU普通道具
 */
- (void)faceUItemChanged:(NSString *)itemPath;

/** 设置faceU美颜参数
 */
- (void)faceUBeautyParamChanged:(VEFaceUBeautyParams *)beautyParams;

/** 销毁faceU全部道具
 */
- (void)destroyFaceU;

/*
 *录制时，摄像头捕获帧回调，可对帧进行处理
 */
- (void)willOutputCameraSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/*
 *如果需要自定义相册则需要实现此函数
 */
- (void)selectVideoAndImageResult:(UINavigationController *)nav callbackBlock:(void (^)(NSMutableArray *lists))callbackBlock;

/*
 *如果需要自定义相册则需要实现此函数（添加视频）
 */
- (void)selectVideosResult:(UINavigationController *)nav callbackBlock:(void (^)(NSMutableArray *lists))callbackBlock;

/*
 *如果需要自定义相册则需要实现此函数（添加图片）
 */
- (void)selectImagesResult:(UINavigationController *)nav callbackBlock:(void (^)(NSMutableArray *lists))callbackBlock;

/** 保存草稿
 */
- (void)saveDraftResult:(NSError *)error;

@end

@interface VEConfigManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic,strong) NSMutableArray          *edit_functionLists;
@property (nonatomic,strong) VEExportConfiguration   *exportConfiguration;
@property (nonatomic,strong) VEEditConfiguration     *editConfiguration;
@property (nonatomic,strong) VECameraConfiguration   *cameraConfiguration;
/**视频输出路径
 */
@property (copy,nonatomic)NSString  * outPath;
/**视频输出路径
 */
@property (copy,nonatomic)NSString  * draftPath;

/** 需扫描的缓存文件夹名称
 */
@property (copy,nonatomic)NSString  * appAlbumCacheName;
/** 缓存文件夹类型，默认为kFolderNone
 */
@property (nonatomic, assign) FolderType folderType;

@property (copy,nonatomic)NSString  * appKey;
@property (copy,nonatomic)NSString  * licenceKey;
@property (copy,nonatomic)NSString  * appSecret;

@property (nonatomic, assign) BOOL       statusBarHidden;
@property (nonatomic, assign) float      videoAverageBitRate;
@property (nonatomic, assign) CGRect     waterLayerRect;

@property (nonatomic, copy) VECompletionHandler   callbackBlock;
@property(nonatomic,copy) VECancelHandler cancelHandler;
@property(nonatomic,copy) VEFailedHandler failedHandler;

@property (nonatomic, weak) id<VESDKDelegate> veSDKDelegate;

@property (nonatomic, assign) BOOL isSingleFunc;

/**  语言设置
 */
@property (nonatomic,assign) SUPPORTLANGUAGE language;

/** APP的主色调
 *  默认为：0xffd500
 */
@property (nonatomic, strong) UIColor *mainColor;

/** APP中导出按钮的文字颜色
 *  默认为：0x27262c
 */
@property (nonatomic, strong) UIColor *exportButtonTitleColor;

/** APP中界面的背景色
 *  默认为：[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *viewBackgroundColor;

/** APP中的导航栏背景色
 *  默认为：[UIColor blackColor]
 */
@property (nonatomic, strong) UIColor *navigationBackgroundColor;

/** APP中的导航栏文字颜色
 *  默认为：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *navigationBarTitleColor;

/** APP中的导航栏文字字体
 *  默认为：[UIFont boldSystemFontOfSize:20]
 */
@property (nonatomic, strong) UIFont *navigationBarTitleFont;

/** 后台返回的“定格”特效分类id
 *  默认为：57685258
 */
@property (nonatomic, assign) int freezeFXCategoryId;

@end
