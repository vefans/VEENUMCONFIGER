//
//  MediaInfo.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/11/3.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <VEENUMCONFIGER/VEDefines.h>

@interface VEMediaInfo : NSObject
/**文件类型
 */
@property(nonatomic,assign)MediaType        fileType;
/** 缩略图
 */
@property(nonatomic,copy  )UIImage          * _Nullable thumbImage;
/**视频 GIF 文件 缩略图保存路径 (  用于需要视频缩略图展示时加载  )
*/
@property(nonatomic,copy)NSString         * _Nullable filtImagePatch;
/** 图片是否是Gif
 */
@property(nonatomic,assign)BOOL             isGif;
/**GifData
 */
@property(nonatomic,copy  )NSData           * _Nullable gifData;
/**图片显示时长
 */
@property(nonatomic,assign)CMTime           imageDurationTime;
@property(nonatomic,assign)CMTimeRange      imageTimeRange;
/**视频（或图片）地址
 */
@property(nonatomic,copy  )NSURL            * _Nullable contentURL;
@property(nonatomic,copy  )NSString         * _Nullable localIdentifier;
@property(nonatomic,assign)CMTimeRange      videoActualTimeRange;

@end
