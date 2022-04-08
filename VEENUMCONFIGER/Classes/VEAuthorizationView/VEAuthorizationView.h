//
//  VEAuthorizationView.h
//  AFNetworking
//
//  Created by iOS VESDK Team  on 2022/1/24.
//

#import <UIKit/UIKit.h>

//#define kUseVEAuthorizationView //20220408 客户反馈因这个界面上架被拒

typedef NS_ENUM(NSInteger, VEAuthorizationType) {
    VEAuthorizationType_Album,          //相册
    VEAuthorizationType_Camera,         //相机
    VEAuthorizationType_Microphone,     //麦克风
    VEAuthorizationType_SpeechRecog,    //语音识别
    VEAuthorizationType_Music,          //媒体资料库
};

typedef NS_ENUM(NSInteger, VEAuthorizationStatus) {
    VEAuthorizationStatus_NotDetermined,    //未设置
    VEAuthorizationStatus_Denied,           //拒绝
    VEAuthorizationStatus_Restricted,       //限制
    VEAuthorizationStatus_Authorized,       //已授权
};

typedef void (^ VEAuthorizationRequestHandler)(VEAuthorizationStatus status);

@interface VEAuthorizationView : UIView

- (instancetype)initWithTypeArray:(NSMutableArray *)typeArray;

@property (nonatomic, copy) VEAuthorizationRequestHandler requestHandler;

@end
