//
//  VEAPITemplateRecordViewController.h
//  VEDeluxeSDK
//
//  Created by iOS VESDK Team  on 2021/7/16.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class  VEAPITemplateRecordViewController;

@protocol VEAPITemplateRecordViewControllerDelegate <NSObject>
@optional
-(void)templateRecordView_BackShot:( BOOL ) isBackShot atViewController:( VEAPITemplateRecordViewController * ) viewController;
@end

@interface VEAPITemplateRecordViewController : UIViewController

@property (weak) id <VEAPITemplateRecordViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL  isBackShot;

@property (nonatomic, assign) BOOL  isPhotoMain;
@property (nonatomic, assign) float    photoMainTooBarHeight;

/** 录制支持类型
 */
@property (nonatomic, assign) SUPPORTFILETYPE supportType;

/** 录制默认类型
 */
@property (nonatomic, assign) BOOL isRecordVideo;

/** 录制大小
 */
@property (nonatomic, assign) CGSize recordSize;

/** 录制时长
 */
@property (nonatomic, assign) float recordDuration;

/** 预览视频地址
 */
@property (nonatomic, strong) NSString *previewVideoPath;

/** 预览时长
 */
@property (nonatomic, assign) CMTimeRange previewTimeRange;

@property (nonatomic, strong) MediaAsset *media;

@property (nonatomic, strong) VECore *videoCoreSDK;

@property (nonatomic, copy) void (^recordCompletionBlock)(NSString *outputPath);

@property (nonatomic, copy) void (^completionHandler)(void);

@property (nonatomic, copy) void (^completionTipsHandler)(void);

@property (nonatomic, copy) void (^showViewHandler)( BOOL isHidden );

@property (nonatomic, copy) void (^previewPlayHandler)( NSURL * outPath );

-(void)playStop;

- (void) deleteItems;

-(void)startCamera;

@property (nonatomic, assign) BOOL  isDisableSave;

@end
