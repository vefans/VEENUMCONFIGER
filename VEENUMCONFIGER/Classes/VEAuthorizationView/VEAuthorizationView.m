//
//  VEAuthorizationView.m
//  AFNetworking
//
//  Created by macos team  on 2022/1/24.
//

#import "VEAuthorizationView.h"
#import "VEDefines.h"
#import "VEHelp.h"
#import <Speech/SFSpeechRecognizer.h>
#import <MediaPlayer/MPMediaLibrary.h>

@interface VEAuthorizationView()
{
    NSMutableArray *_typeArray;
}

@end

@implementation VEAuthorizationView

- (instancetype)initWithTypeArray:(NSMutableArray *)typeArray {
    if (self = [super init]) {
        _typeArray = [NSMutableArray arrayWithArray:typeArray];
        self.frame = CGRectMake(0, 0, kWIDTH, kHEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        float itemBtnSize = 62.0;
        float width = kWIDTH * 0.56;
        float height = itemBtnSize * typeArray.count + 25*2 + 26 + 36;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH - width)/2.0, (kHEIGHT - height)/2.0, width, height)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5.0;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, width, 26)];
        titleLbl.text = VELocalizedString(@"权限申请", nil);
        titleLbl.font = [UIFont boldSystemFontOfSize:14];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = [UIColor blackColor];
        [bgView addSubview:titleLbl];
        
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame), width, 36)];
        messageLbl.text = [NSString stringWithFormat:VELocalizedString(@"“%@”需要使用以下权限", nil), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]];
        messageLbl.font = [UIFont systemFontOfSize:12];
        messageLbl.textAlignment = NSTextAlignmentCenter;
        messageLbl.textColor = [UIColor blackColor];
        [bgView addSubview:messageLbl];
        
        for (int i = 0; i < typeArray.count; i++) {
            VEAuthorizationType type = [typeArray[i] integerValue];
            NSString *title;
            NSString *subStr;
            switch (type) {
                case VEAuthorizationType_Album:
                    title = @"相册";
                    subStr = VELocalizedString(@"需要访问你的相册", nil);
                    break;
                case VEAuthorizationType_Camera:
                    title = @"相机";
                    subStr = VELocalizedString(@"需要访问你的相机", nil);
                    break;
                case VEAuthorizationType_Microphone:
                    title = @"麦克风";
                    subStr = VELocalizedString(@"需要访问你的麦克风", nil);
                    break;
                case VEAuthorizationType_SpeechRecog:
                    title = @"语音识别";
                    subStr = VELocalizedString(@"需要访问你的语音识别", nil);
                    break;
                case VEAuthorizationType_Music:
                    title = @"媒体资料库";
                    subStr = VELocalizedString(@"需要访问你的媒体资料库", nil);
                    break;
                    
                default:
                    break;
            }
            UIButton *itemBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(messageLbl.frame) + i * itemBtnSize, width, itemBtnSize)];
            UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(width * 0.1, (itemBtnSize - 36)/2.0, 36, 36)];
            iconView.image = [VEHelp imageWithContentOfFile:[NSString stringWithFormat:@"Authorization/%@权限_@3x", title]];
            [itemBtn addSubview:iconView];
            
            NSString *str = [NSString stringWithFormat:VELocalizedString(@"%@权限", nil), title];
            NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", str, subStr]];
            [attriStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length)];
            [attriStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x888888) range:NSMakeRange(str.length + 1, subStr.length)];
            [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
            [attriStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(str.length + 1, subStr.length)];
            UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + width * 0.1, 0, width - (CGRectGetMaxX(iconView.frame) + width * 0.1), itemBtnSize)];
            titleLbl.attributedText = attriStr;
            titleLbl.numberOfLines = 0;
            [itemBtn addSubview:titleLbl];
            
            itemBtn.tag = type;
            [itemBtn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:itemBtn];
        }
    }
    
    return self;
}

- (void)tapGesture {
    if (_requestHandler) {
        _requestHandler(VEAuthorizationStatus_NotDetermined);
    }
    [self removeFromSuperview];
}

- (void)itemBtnAction:(UIButton *)sender {
    VEAuthorizationType type = sender.tag;
    
    WeakSelf(self);
    __block VEAuthorizationStatus authorStatus = VEAuthorizationStatus_NotDetermined;
    switch (type) {
        case VEAuthorizationType_Album:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    StrongSelf(self);
                    switch (status) {
                        case PHAuthorizationStatusNotDetermined:
                            authorStatus = VEAuthorizationStatus_NotDetermined;
                            break;
                        case PHAuthorizationStatusRestricted:
                            authorStatus = VEAuthorizationStatus_Restricted;
                            break;
                        case PHAuthorizationStatusDenied:
                            authorStatus = VEAuthorizationStatus_Denied;
                            break;
                            
                        default:
                            authorStatus = VEAuthorizationStatus_Authorized;
                            break;
                    }
                    if (strongSelf.requestHandler) {
                        strongSelf.requestHandler(authorStatus);
                    }
                    [strongSelf removeFromSuperview];
                });
            }];
        }
            break;
        case VEAuthorizationType_Camera:
        {
            if (_typeArray.count == 1) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
                    if (granted && audioAuthStatus == AVAuthorizationStatusAuthorized) {
                        authorStatus = VEAuthorizationStatus_Authorized;
                    }else {
                        authorStatus = VEAuthorizationStatus_Denied;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        StrongSelf(self);
                        if (strongSelf.requestHandler) {
                            strongSelf.requestHandler(authorStatus);
                        }
                        [strongSelf removeFromSuperview];
                    });
                }];
            }else {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    StrongSelf(self);
                    [strongSelf->_typeArray removeObject:[NSNumber numberWithInteger:VEAuthorizationType_Camera]];
                }];
            }
        }
            break;
        case VEAuthorizationType_Microphone:
        {
            if (_typeArray.count == 1) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    if (granted && videoAuthStatus == AVAuthorizationStatusAuthorized) {
                        authorStatus = VEAuthorizationStatus_Authorized;
                    }else {
                        authorStatus = VEAuthorizationStatus_Denied;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        StrongSelf(self);
                        if (strongSelf.requestHandler) {
                            strongSelf.requestHandler(authorStatus);
                        }
                        [strongSelf removeFromSuperview];
                    });
                }];
            }else {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                    StrongSelf(self);
                    [strongSelf->_typeArray removeObject:[NSNumber numberWithInteger:VEAuthorizationType_Microphone]];
                }];
            }
        }
            break;
        case VEAuthorizationType_SpeechRecog:
        {
            if (@available(iOS 10.0, *)) {
                [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        authorStatus = (VEAuthorizationStatus)status;
                        StrongSelf(self);
                        if (strongSelf.requestHandler) {
                            strongSelf.requestHandler(authorStatus);
                        }
                        [strongSelf removeFromSuperview];
                    });
                }];
            } else {
                // Fallback on earlier versions
            }
        }
            break;
        case VEAuthorizationType_Music:
        {
            if (@available(iOS 9.3, *)) {
                [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus authorizationStatus)
                 {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        authorStatus = (VEAuthorizationStatus)authorizationStatus;
                        StrongSelf(self);
                        if (strongSelf.requestHandler) {
                            strongSelf.requestHandler(authorStatus);
                        }
                        [strongSelf removeFromSuperview];
                    });
                }];
            }else {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        authorStatus = VEAuthorizationStatus_Authorized;
                    }else {
                        authorStatus = VEAuthorizationStatus_Denied;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        StrongSelf(self);
                        if (strongSelf.requestHandler) {
                            strongSelf.requestHandler(authorStatus);
                        }
                        [strongSelf removeFromSuperview];
                    });
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

@end
