//
//  VEMusicInfo.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/13.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEMusicInfo : NSObject

/**使用音乐地址
 */
@property (nonatomic, strong) NSURL * _Nullable url;

/**音乐总时间范围
 */
@property (nonatomic, assign) CMTimeRange timeRange;

/**音乐截取时间范围
 */
@property (nonatomic, assign) CMTimeRange clipTimeRange;

/**音乐名称
 */
@property (nonatomic, strong) NSString *_Nullable name;

/**音量(0.0-1.0)
 */
@property (nonatomic, assign) float volume;

/**是否重复播放
 */
@property (nonatomic, assign) BOOL isRepeat;

@end

NS_ASSUME_NONNULL_END
