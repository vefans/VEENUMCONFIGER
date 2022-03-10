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
    UIView *_bgView;
}

@end

@implementation VEAuthorizationView

- (instancetype)initWithTypeArray:(NSMutableArray *)typeArray {
    if (self = [super init]) {
        _typeArray = [NSMutableArray arrayWithArray:typeArray];
        self.frame = CGRectMake(0, 0, kWIDTH, kHEIGHT);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        
        float itemBtnSize = 62.0;
        float width = 270;
        float height = itemBtnSize * typeArray.count + 25*2 + 26 + 36 + 44;
        _bgView = [[UIView alloc] initWithFrame:CGRectMake((kWIDTH - width)/2.0, (kHEIGHT - height)/2.0, width, height)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5.0;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, width, 26)];
        titleLbl.text = VELocalizedString(@"权限申请", nil);
        titleLbl.font = [UIFont boldSystemFontOfSize:14];
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = [UIColor blackColor];
        [_bgView addSubview:titleLbl];
        
        NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
        NSString *bundleName = [bundleDic objectForKey:@"CFBundleDisplayName"];
        if (bundleName.length == 0) {
            bundleName = [bundleDic objectForKey:@"CFBundleName"];
        }
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame), width, 36)];
        messageLbl.text = [NSString stringWithFormat:VELocalizedString(@"“%@”需要使用以下权限", nil), bundleName];
        messageLbl.font = [UIFont systemFontOfSize:12];
        messageLbl.textAlignment = NSTextAlignmentCenter;
        messageLbl.textColor = [UIColor blackColor];
        [_bgView addSubview:messageLbl];
        
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
//            [itemBtn addTarget:self action:@selector(itemBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:itemBtn];
        }
        
        width = _bgView.frame.size.width * 0.43;
        for (int i = 0; i < 2; i++) {
            UIButton *itemBtn = [[UIButton alloc] init];
            if (i == 0) {
                itemBtn.frame = CGRectMake((_bgView.frame.size.width - width * 2.0) / 3.0, CGRectGetMaxY(messageLbl.frame) + typeArray.count * itemBtnSize + (44 - 35)/2.0, width, 35);
                itemBtn.backgroundColor = UIColorFromRGB(0xa1a1a1);
                [itemBtn setTitle:VELocalizedString(@"拒绝", nil) forState:UIControlStateNormal];
                [itemBtn setTitleColor:VE_EXPORTBTN_TITLE_COLOR forState:UIControlStateNormal];
            }else {
                itemBtn.frame = CGRectMake((_bgView.frame.size.width - width * 2.0) / 3.0 * 2.0 + width, CGRectGetMaxY(messageLbl.frame) + typeArray.count * itemBtnSize + (44 - 35)/2.0, width, 35);
                itemBtn.backgroundColor = Main_Color;
                [itemBtn setTitle:VELocalizedString(@"同意", nil) forState:UIControlStateNormal];
                [itemBtn setTitleColor:VE_EXPORTBTN_TITLE_COLOR forState:UIControlStateNormal];
            }
            itemBtn.layer.cornerRadius = itemBtn.frame.size.height / 2.0;
            itemBtn.layer.masksToBounds = YES;
            itemBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            itemBtn.tag = i + 1;
            [itemBtn addTarget:self action:@selector(authorizeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bgView addSubview:itemBtn];
        }
    }
    
    return self;
}

- (void)tapGesture:(UIGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    if (CGRectContainsPoint(_bgView.frame, point)) {
        return;
    }
    [self removeFromSuperview];
    if (_requestHandler) {
        _requestHandler(VEAuthorizationStatus_NotDetermined);
    }
}

- (void)authorizeBtnAction:(UIButton *)sender {
    if (sender.tag == 1) {
        [self removeFromSuperview];
        if (_requestHandler) {
            _requestHandler(VEAuthorizationStatus_NotDetermined);
        }
    }else {
        self.hidden = YES;
        VEAuthorizationType type = [_typeArray.firstObject integerValue];
        [self authorizationWithType:type];
    }
}

- (void)authorizationWithType:(VEAuthorizationType)type {
    if (_typeArray.count > 0) {
        [_typeArray removeObjectAtIndex:0];
    }
    WeakSelf(self);
    __block VEAuthorizationStatus authorStatus = VEAuthorizationStatus_NotDetermined;
    switch (type) {
        case VEAuthorizationType_Album:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
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
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf authorizationCompletion:authorStatus];
                });
            }];
        }
            break;
        case VEAuthorizationType_Camera:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    authorStatus = VEAuthorizationStatus_Authorized;
                }else {
                    authorStatus = VEAuthorizationStatus_Denied;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf authorizationCompletion:authorStatus];
                });
            }];
        }
            break;
        case VEAuthorizationType_Microphone:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    authorStatus = VEAuthorizationStatus_Authorized;
                }else {
                    authorStatus = VEAuthorizationStatus_Denied;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf authorizationCompletion:authorStatus];
                });
            }];
        }
            break;
        case VEAuthorizationType_SpeechRecog:
        {
            if (@available(iOS 10.0, *)) {
                [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
                    authorStatus = (VEAuthorizationStatus)status;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf authorizationCompletion:authorStatus];
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
                    authorStatus = (VEAuthorizationStatus)authorizationStatus;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf authorizationCompletion:authorStatus];
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
                        [weakSelf authorizationCompletion:authorStatus];
                    });
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)authorizationCompletion:(VEAuthorizationStatus)authorStatus {
    if (_typeArray.count == 0 || authorStatus != VEAuthorizationStatus_Authorized) {
        if (_requestHandler) {
            _requestHandler(authorStatus);
        }
        [self removeFromSuperview];
    }else {
        VEAuthorizationType type = [_typeArray.firstObject integerValue];
        [self authorizationWithType:type];
    }
}

@end
