//
//  veCorePlayer.m
//  VEDeluxeSDK
//
//  Created by iOS VESDK Team. on 2018/8/15.
//  Copyright © 2018 iOS VESDK Team. All rights reserved.

#define MAXCACHENUM 20    //最大缓存数

#import "VEAPITemplatePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "VEReachability.h"
#import "VEHelp.h"
#import "VEDefines.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface VEAPITemplatePlayer ()
{
    id                      _timeObserver;
    BOOL                    isPause;
}

@property (nonatomic,strong)MBProgressHUD *progressHUD;
@property (nonatomic,weak) id<VEAPITemplatePlayerDelegate > _Nullable delegate;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem  *playerItem;
@property (nonatomic,   copy) NSString *savePath;   //视频播放完后保存的本地路径
@property (nonatomic,   copy) NSString *videoPath;


@property (nonatomic, assign) BOOL needLoad; //需要下载
@property (nonatomic, strong) UIView *line;  //动画线
@property (nonatomic, strong) CAAnimationGroup *animGroup ; //动画数组
/**是否竖屏
 */
@property (nonatomic,assign) BOOL isPortrait;
@property (nonatomic,assign) float proportion;
@property (nonatomic,strong) UIView *progressSup;

@end

@implementation VEAPITemplatePlayer

+ (nonnull instancetype)sharedPlayer {
    static dispatch_once_t once;
    static VEAPITemplatePlayer *sourctDelegate;
    dispatch_once(&once, ^{
        sourctDelegate = [[VEAPITemplatePlayer alloc] init];
    });
    return sourctDelegate;
}

- (void)dealloc {
    NSLog(@"-->%s",__FUNCTION__);
    [self removePlayerItemObserver];
    if (_player) {
        [_player pause];
        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
        [_player replaceCurrentItemWithPlayerItem:nil];
        [_player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
        _player = nil;
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopAnimation];
    [_progressHUD removeFromSuperview];
    _progressHUD = nil;
    [self.line.layer removeAllAnimations];
    [self.line removeFromSuperview];
    self.line = nil;
}

- (float)duration{
    if(!_playerItem){
        return 0;
    }
    return CMTimeGetSeconds(_playerItem.duration);
}

- (CMTime)currentTime{
    if(!_player){
        return kCMTimeZero;
    }
    return _player.currentTime;
}

- (void)setPlayerFrame:(CGRect)frame{
    self.frame = frame;
    _playerLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _playerLayer.position = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
    if(self.progressSup){
        self.line.frame = CGRectMake(kWIDTH/2-5, frame.size.height - _lineToBottomHeight, 10, 2.0);
    }else{
        self.line.frame = CGRectMake(kWIDTH/2-5, frame.size.height - 2.0, 10, 2.0);
    }
}

#pragma mark - initUI
- (instancetype)initWithFrame:(CGRect)frame urlPath:(NSString *)urlPath delegate:(id)delegate completionHandler:(nullable void (^)(NSError *error))handler{
    return [self initWithFrame:frame urlPath:urlPath  wh_Proportion:0 delegate:delegate completionHandler:handler];
}
- (instancetype)initWithFrame:(CGRect)frame urlPath:(NSString *)urlPath wh_Proportion:(float)proportion delegate:(id)delegate completionHandler:(nullable void (^)(NSError *error))handler{
    return [self initWithFrame:frame urlPath:urlPath  wh_Proportion:0 progressSup:nil delegate:delegate completionHandler:handler];
}
- (instancetype)initWithFrame:(CGRect)frame urlPath:(NSString *)urlPath wh_Proportion:(float)proportion progressSup:(UIView *)progressSup delegate:(id)delegate completionHandler:(nullable void (^)(NSError *error))handler{
    self = [super initWithFrame:frame];
    if (self) {
        _progressSup = progressSup;
        _delegate = delegate;
        _repeat = YES;
        _mute = YES;
        _onlyCache = NO;
        _isPortrait = (proportion<1.0);
        _proportion = proportion;
        isPause = YES;
        [self setUrlPath:urlPath completionHandler:handler];
    }
    return self;
}

- (void)setUrlPath:(NSString *)urlPath completionHandler:(void (^)(NSError *))handler {    
    if (_player) {
        [_player pause];
        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [self removePlayerItemObserver];
        _playerItem = nil;
        [_player replaceCurrentItemWithPlayerItem:nil];
    }
    NSString*documentPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cachesVideosPath = [documentPath stringByAppendingPathComponent:@"cachesVideos"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:cachesVideosPath]){
        [fileManager createDirectoryAtPath:cachesVideosPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString*savePath = [NSString stringWithFormat:@"%@/%lu.%@",cachesVideosPath,(unsigned long)[urlPath hash],[urlPath pathExtension]];
    
    NSArray *tempFileList = [[NSArray alloc] initWithArray:[fileManager contentsOfDirectoryAtPath:cachesVideosPath error:nil]];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    [tempFileList enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *itemPath = [cachesVideosPath stringByAppendingPathComponent:obj];
        NSError *error = nil;
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:itemPath error:&error];
        
        if (fileAttributes != nil) {
            NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
            NSInteger timeSp = [[NSNumber numberWithDouble:[fileCreateDate timeIntervalSince1970]] integerValue];
            [list addObject:[[NSDictionary alloc] initWithObjectsAndKeys:itemPath,@"filepath",@(timeSp),@"date", nil]];
        }
        else {
            NSLog(@"Path (%@) is invalid.", cachesVideosPath);
        }
    }];
    
    [list sortUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull obj1, NSDictionary * _Nonnull obj2) {
        if([obj1[@"date"] doubleValue] < [obj2[@"date"] doubleValue]){
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    if(list.count > MAXCACHENUM){
        for (int i = MAXCACHENUM; i < list.count; i++) {
            NSDictionary *item = list[i];
            NSString *i_path = item[@"filepath"];
            [fileManager removeItemAtPath:i_path error:nil];
        }
    }
//        [self initAnimationView];

    
    if ([fileManager fileExistsAtPath:savePath]) {
        _videoPath = savePath;
        _needLoad = NO;
        
    }else{
        _needLoad = YES;
        _videoPath = urlPath;
        [self startAnimation];
    }
    
    _savePath = savePath;
    
    AVAsset *asset = nil;
    if (!_videoPath) {
        NSDictionary *userInfo= [NSDictionary dictionaryWithObject:VELocalizedString(@"文件路径错误", nil) forKey:NSLocalizedDescriptionKey];
        NSError *error = [NSError errorWithDomain:@"com.VEAPITemplatePlayer.ErrorDomain" code:VESDKErrorCode_FilePath userInfo:userInfo];
        if(handler) {
            handler(error);
        }
    }else {
        if ([_videoPath hasPrefix:@"http"]) {
            asset = [AVAsset assetWithURL:[NSURL URLWithString:_videoPath]];
        }else{
            _videoPath = [_videoPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#%^{}\"[]|\\<> "].invertedSet];
            asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:_videoPath]];
            if (![asset isPlayable]) {
                [fileManager removeItemAtPath:savePath error:nil];
                _needLoad = YES;
                _videoPath = urlPath;
                [self startAnimation];
                asset = nil;
                asset = [AVAsset assetWithURL:[NSURL URLWithString:_videoPath]];
            }
        }
        if (_needLoad) {
            VEReachability *lexiu = [VEReachability reachabilityForInternetConnection];
            if([lexiu currentReachabilityStatus] == VEReachabilityStatus_NotReachable){
                NSDictionary *userInfo= [NSDictionary dictionaryWithObject:VELocalizedString(@"无可用的网络", nil) forKey:NSLocalizedDescriptionKey];
                NSError *error = [NSError errorWithDomain:@"com.VEAPITemplatePlayer.ErrorDomain" code:VESDKErrorCode_NotReachable userInfo:userInfo];
                if(handler) {
                    handler(error);
                }
                return;
            }
        }
    }
    __weak typeof(self)weakSelf = self;
    [asset loadValuesAsynchronouslyForKeys:@[@"playable"] completionHandler:^{
        dispatch_async( dispatch_get_main_queue(), ^{
            [weakSelf initPlayer:asset];
            if(handler) {
                handler(nil);
            }
        });
    }];
}

- (void)initPlayer:(AVAsset *)asset
{
    //视频方向自动调整
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    
    //手机静音模式也播放声音，如果想要与手机是否静音同步删掉即可
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if (![session.category isEqualToString:AVAudioSessionCategoryPlayAndRecord] && ![session.category isEqualToString:AVAudioSessionCategoryPlayback]) {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    }
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
    _playerItem = playerItem;
    if (_player) {
        [_player replaceCurrentItemWithPlayerItem:_playerItem];
        _playerLayer.player = _player;
        if (_needLoad) {
            [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
            [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
            [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    }else {
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = self.bounds;
//        if(!_isPortrait){
//            float height = self.frame.size.height;//self.bounds.size.width / _proportion;
//            _playerLayer.frame = CGRectMake(0, (CGRectGetHeight(self.bounds) - height)/2.0, CGRectGetWidth(self.bounds), height);
//            
//            _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
//        }else{
//            _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//        }
        [self.layer addSublayer:_playerLayer];
        [self initOthers];
        [self initNotificationAndKVO];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _playerLayer.backgroundColor = backgroundColor.CGColor;
}

- (void)setVideoGravity:(AVLayerVideoGravity)videoGravity {
    _playerLayer.videoGravity = videoGravity;
}

- (void)initOthers
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    
//    UITapGestureRecognizer*singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnAction_pause)];
//    [self addGestureRecognizer:singleTapGestureRecognizer];
}

- (void)setLineToBottomHeight:(float)lineToBottomHeight{
    _lineToBottomHeight = lineToBottomHeight;
    if(self.line){
        if(self.progressSup){
            CGRect rect = self.line.frame;
            rect.origin.y = self.progressSup.frame.size.height - lineToBottomHeight;
            self.line.frame = rect;
        }else{
            CGRect rect = self.line.frame;
            rect.origin.y = self.frame.size.height - rect.size.height;
            self.line.frame = rect;
        }
    }
}

- (void)initAnimationView
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kWIDTH/2-5, kHEIGHT-2.0, 10, 2.0)];
    line.backgroundColor = Main_Color;
    if(self.progressSup){
        [line setFrame:CGRectMake(kWIDTH/2-5, 0, 10, 2.0)];
        [self.progressSup addSubview:line];
    }else{
        [self addSubview:line];
    }
    line.hidden = YES;
    self.line = line;
    
    CGFloat scan = kWIDTH/10;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    NSValue *value = [NSNumber numberWithFloat:1.0f];
    NSValue *value1 = [NSNumber numberWithFloat:scan];
    animation.duration = 0.5;
    animation.values = @[value,value1];
    
    CABasicAnimation *banOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    banOpacity.fromValue = [NSNumber numberWithFloat:1.0];
    banOpacity.toValue = [NSNumber numberWithFloat:0.0];
    banOpacity.duration = 0.2;
    banOpacity.beginTime = 0.3;
    banOpacity.removedOnCompletion = NO;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = 0.5f;
    animGroup.animations = @[animation,banOpacity];
    animGroup.repeatCount=MAXFLOAT;
    self.animGroup = animGroup;
}

- (MBProgressHUD *)progressHUD{
    if(!_progressHUD){
        //圆形进度条
        _progressHUD = [[MBProgressHUD alloc] initWithView:self];
        MBRoundProgressView * customView = [[MBRoundProgressView alloc] init];
        _progressHUD.customView = customView;
        customView.backgroundTintColor = [UIColor grayColor];
        customView.progressTintColor = [UIColor blackColor];
        customView.annular = YES;
        _progressHUD.removeFromSuperViewOnHide = YES;
        _progressHUD.mode = MBProgressHUDModeAnnularDeterminate;//MBProgressHUDModeDeterminate;
        _progressHUD.animationType = MBProgressHUDAnimationFade;
        [self addSubview:_progressHUD];
        _progressHUD.label.text = VELocalizedString(@"加载中,请稍候...", nil);
    }
    return _progressHUD;
}

- (void)initNotificationAndKVO
{
    // 进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:UIApplicationDidEnterBackgroundNotification object:nil];
    // 回到前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    //播放完一遍
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    
    if (_needLoad) {
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    }else if (_delegate && [_delegate respondsToSelector:@selector(autoPlay:)]) {
        [_delegate autoPlay:self];
    }
    __weak typeof(self) weakSelf = self;
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:NULL usingBlock:^(CMTime time) {
        if (weakSelf.delegate &&[weakSelf.delegate respondsToSelector:@selector(playCurrentTime:)]) {
            [weakSelf.delegate playCurrentTime:time];
        }
    }];
}

- (void)removePlayerItemObserver {
    if (_needLoad && _playerItem) {
        id info = _playerItem.observationInfo;
        NSArray *array = [info valueForKey:@"_observances"];
        for (id objc in array) {
            id Properties = [objc valueForKeyPath:@"_property"];
            NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
            if ([keyPath isEqualToString:@"status"]
                || [keyPath isEqualToString:@"loadedTimeRanges"]
                || [keyPath isEqualToString:@"playbackBufferEmpty"]
                || [keyPath isEqualToString:@"playbackLikelyToKeepUp"])
            {
                if (_playerItem) {
                    [_playerItem removeObserver:self forKeyPath:keyPath];
                }
            }
        }
    }
}

#pragma mark - action

- (void)btnAction_pause
{
    if (_delegate && [_delegate respondsToSelector:@selector(tapPlayer)]) {
        [_delegate tapPlayer];
    }
}

- (void)setMute:(BOOL)mute{
    _mute = mute;
    _player.muted = mute;
}

- (void)setOnlyCache:(BOOL)onlyCache{
    _onlyCache = onlyCache;
}
- (void)setIsPortrait:(BOOL)isPortrait{
    _isPortrait = isPortrait;
    
}

- (void)seekToTime:(CMTime)time toleranceTime:(CMTime)tolerance completionHandler:(void (^)(BOOL))completionHandler{
    if(!_player){
        return;
    }
    [_player seekToTime:time toleranceBefore:tolerance toleranceAfter:tolerance completionHandler:completionHandler];
}

- (void)play
{
    if (!_player) {
        return;
    }
    if(self.onlyCache){
        return;
    }
    _isplaying = YES;
    [_player play];
    isPause = NO;
    if (!_needLoad && _delegate && [_delegate respondsToSelector:@selector(autoPlay:)]) {
        [_delegate autoPlay:self];
    }
}

- (void)pause
{
    [_player pause];
    _isplaying = NO;
    isPause = YES;
}

- (void)stop
{
    isPause = YES;
    if (_player) {
        [_player removeTimeObserver:_timeObserver];
        [_player pause];
        [_player.currentItem cancelPendingSeeks];
        [_player.currentItem.asset cancelLoading];
        [_player replaceCurrentItemWithPlayerItem:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    _timeObserver = nil;
    [self removePlayerItemObserver];
    _player = nil;
    [_playerLayer removeFromSuperlayer];
    _playerLayer = nil;
    [self.line.layer removeAllAnimations];
    [self.line removeFromSuperview];
    self.line = nil;
    _playerItem = nil;
}

- (void)startAnimation
{
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:_videoPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_videoPath] || ![asset isPlayable]) {
        [self.progressHUD showAnimated:YES];
    }
    
    if (!self.line.hidden) {
        return;
    }
    self.line.hidden = NO;
    [self.line.superview bringSubviewToFront:self.line];
    [self.line.layer addAnimation:self.animGroup forKey:@"animGroup"];
}

- (void)stopAnimation
{
    [self.progressHUD hideAnimated:NO];
    [self.line.layer removeAllAnimations];
    self.line.hidden= YES;
}

#pragma mark - Notification

- (void)enterForeground
{
    //动画进入后台以后会停止，回到前台先判断之前是否在动画
    if (self.line.hidden) {
        return;
    }
    self.line.hidden = YES;
    [self startAnimation];
}

//视频播放完通知
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    if(_repeat){ 
        [_player seekToTime:kCMTimeZero];
        [self play];
    }else{
        if([_delegate respondsToSelector:@selector(playerItemDidReachEnd:)]){
            [_delegate playerItemDidReachEnd:self];
        }
    }
}

//监听获得消息
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    WeakSelf(self);
    //NSLog(@"====>%@",self.videoPath);
    dispatch_async(dispatch_get_main_queue(), ^{
        StrongSelf(self);
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        
        if ([keyPath isEqualToString:@"status"]) {
            if ([playerItem status] == AVPlayerStatusReadyToPlay) {
                
//                CGFloat duration = playerItem.duration.value / playerItem.duration.timescale; //视频总时间
//                NSLog(@"准备好播放了，总时间：%.2f", duration);//还可以获得播放的进度，这里可以给播放进度条赋值了
                if ([_delegate respondsToSelector:@selector(autoPlay:)]) {
                    [_delegate autoPlay:strongSelf];
                }
            } else if ([playerItem status] == AVPlayerStatusFailed || [playerItem status] == AVPlayerStatusUnknown) {
                [strongSelf pause];
            }
            
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {  //监听播放器的下载进度
            
            NSArray *loadedTimeRanges = [playerItem loadedTimeRanges];
            CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
            float startSeconds = CMTimeGetSeconds(timeRange.start);
            float durationSeconds = CMTimeGetSeconds(timeRange.duration);
            NSTimeInterval timeInterval = startSeconds + durationSeconds;// 计算缓冲总进度
            CMTime duration = playerItem.duration;
            CGFloat totalDuration = CMTimeGetSeconds(duration);
            
            NSLog(@"------------->下载进度：%.2f   %f  %f", timeInterval / totalDuration,timeInterval,totalDuration);
            
            CGFloat timeee = [[NSString stringWithFormat:@"%.3f",timeInterval] floatValue];
            CGFloat totall = [[NSString stringWithFormat:@"%.3f",totalDuration] floatValue];
            
            if (timeee >= totall) {
                
                NSLog(@"下载完");
                [strongSelf saveVideo:playerItem];
            }
            
        } else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) { //监听播放器在缓冲数据的状态
            NSLog(@"缓冲不足暂停了");
            [strongSelf startAnimation];
            
        } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            NSLog(@"缓冲达到可播放程度了");
            [strongSelf stopAnimation];
            if (!isPause) {
                [strongSelf play];
            }
        }
    });
}

- (void)saveVideo:(AVPlayerItem *)playerItem {
    [self stopAnimation];
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    NSError *erroraudio = nil;
    //获取AVAsset中的音频 或 者视频
    AVAssetTrack *assetAudioTrack = [[playerItem.asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    //向通道内加入音频或者视频
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, playerItem.asset.duration)
                        ofTrack:assetAudioTrack
                         atTime:kCMTimeZero
                          error:&erroraudio];
    
    NSError *errorVideo = nil;
    AVAssetTrack *assetVideoTrack = [[playerItem.asset tracksWithMediaType:AVMediaTypeVideo]firstObject];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, playerItem.asset.duration)
                        ofTrack:assetVideoTrack
                         atTime:kCMTimeZero
                          error:&errorVideo];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                      presetName:AVAssetExportPresetPassthrough];
    
    exporter.outputURL = [NSURL fileURLWithPath:_savePath];;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    WeakSelf(self);
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        StrongSelf(self);
        if( exporter.status == AVAssetExportSessionStatusCompleted && _needLoad){
            NSLog(@"保存成功");
            [strongSelf removePlayerItemObserver];
            _needLoad = NO;
            //保存到相册（如果要保存到相册，需要先确认项目是否允许访问相册）
            // UISaveVideoAtPathToSavedPhotosAlbum(_savePath, nil, nil, nil);
            
        }else if( exporter.status == AVAssetExportSessionStatusFailed ){
            
            NSLog(@"保存失败");
        }
    }];
}

@end
