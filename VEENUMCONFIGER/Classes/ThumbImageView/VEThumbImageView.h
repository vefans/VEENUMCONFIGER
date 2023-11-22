//
//  VEThumbImageView.h
//  VEDeluxe
//
//  Created by iOS VESDK Team on 15/8/17.
//  Copyright (c) 2015年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <VEENUMCONFIGER/VEMediaInfo.h>

@protocol VEThumbImageViewDelegate;

@interface VEThumbImageView : UIImageView
{
    NSString *imageName;
    
    /* VEThumbImageViews have a "home," which is their location in the containing scroll view. Keeping this distinct */
    /* from their frame makes it easier to handle dragging and reordering them. We can change their relative       */
    /* positions by changing their homes, without having to worry about whether they have currently been dragged   */
    /* somewhere else. Also, we don't lose track of where they belong while they are being moved.                  */
    CGRect home;
    CALayer *shadowLayer;
    BOOL dragging;
    CGPoint touchLocation;
    double  touchBeginTime;
}
/**转场类型
 */
@property(nonatomic,strong)NSString         *transitionTypeName;
/**转场时间
 */
@property(nonatomic,assign)double           transitionDuration;
@property(nonatomic,copy)NSString           *transitionName;
@property(nonatomic,copy)NSURL              *transitionMask;
@property (strong, nonatomic) VEMediaInfo        *contentFile;

@property (copy, nonatomic) NSString        *assetMusicPath;
@property (assign, nonatomic)BOOL           tap;
@property (nonatomic ,assign) float startTimeInTotalVideoTime;

@property (strong, nonatomic)UIImageView    *coverView;

@property (nonatomic,strong)UIImageView     *thumbIconView;

@property (nonatomic,strong)UIView          *maskView;

@property (strong, nonatomic)UILabel        *thumbIdlabel;

@property (assign, nonatomic)NSInteger       thumbId;

@property (strong, nonatomic)UILabel        *thumbFileTypelabel;

@property (strong, nonatomic)UILabel        *thumbDurationlabel;

@property (strong, nonatomic)UIButton       *thumbDeletedBtn;
@property (assign, nonatomic) BOOL          isAlbum;

@property (assign, nonatomic) BOOL          selected;

@property (assign, nonatomic) BOOL          deleted;

//@property (assign, nonatomic) BOOL          isCrop;

//@property (strong, nonatomic) AVURLAsset    *urlAsset;

//@property (nonatomic ,assign) CMTimeRange   clipTimeRange;

@property (nonatomic ,assign) CMTimeRange   clipSliderTimeRange;

//@property (nonatomic ,assign) CMTimeRange   speedTimeRange;

//@property (nonatomic ,assign) Float64       totalVideoTime;

//@property (nonatomic ,assign) float         speed;

//@property (nonatomic ,assign) float         speedIndex;

@property (nonatomic, strong) id            imageName;

@property (nonatomic, assign) CGRect        home;
@property (nonatomic, assign) BOOL          enableMovePostion;
@property (nonatomic, assign) BOOL          canMovePostion;
@property (nonatomic, assign) BOOL          cancelMovePostion;

@property (nonatomic, assign) CGPoint       touchLocation;

//@property (nonatomic, assign) float          clipRectScale;
//
//@property (nonatomic, assign) CGRect         clipRect;

//@property (nonatomic, assign) float         clipPrivatValue;

//@property (nonatomic, strong) NSMutableArray      *movePointsAndcurrentTimes;

/**倒序参数记录
 */
//@property (assign, nonatomic) BOOL          isReverse;
//
//@property (assign, nonatomic) BOOL          isReversedVideoCached;  //已经倒放过
//
//@property (strong, nonatomic) AVURLAsset    *reverseUrlAsset;
//
//@property (nonatomic ,assign) CMTimeRange   reverseClipTimeRange;
//
//@property (nonatomic ,assign) CMTimeRange   reverseClipSliderTimeRange;
//
//@property (nonatomic ,assign) CMTimeRange   reverseSpeedTimeRange;
//
//@property (nonatomic ,assign) Float64       reverseTotalVideoTime;


@property (weak) id <VEThumbImageViewDelegate> delegate;


@property (nonatomic,strong) VECustomTextPhotoFile *customTextPhotoFile;


- (instancetype)initWithSize:(CGSize )t_size;

- (void)selectThumb:(BOOL)selected;
- (void)goHome;  // animates return to home location
- (void)moveByOffset:(CGPoint)offset withEvent:(UIEvent *)event; // change frame lo

- (void)AddtThumbIconViewSide;
- (void)removeDurationBackColor;

@property (nonatomic,assign) bool isEdit;   //是否片段编辑

@end



@protocol VEThumbImageViewDelegate <NSObject>

@optional
- (void)thumbImageViewWaslongLongTap:(VEThumbImageView *)tiv;
- (void)thumbImageViewWaslongLongTapEnd:(VEThumbImageView *)tiv;
- (void)thumbDeletedThumbFile:(VEThumbImageView *)tiv;
- (void)thumbImageViewWasTapped:(VEThumbImageView *)tiv touchUpTiv:(BOOL)isTouchUpTiv;
- (void)thumbImageViewStartedTracking:(VEThumbImageView *)tiv;
- (void)thumbImageViewMoved:(VEThumbImageView *)tiv withEvent:(UIEvent *)event;
- (void)thumbImageViewStoppedTracking:(VEThumbImageView *)tiv withEvent:(UIEvent *)event;

- (void)thumbImageViewResetPhotoMain:(VEThumbImageView *) tive;
@end
