#import <UIKit/UIKit.h>

@interface CustomSliderView : UIButton

@property (nonatomic ,assign) BOOL hideBaifenbi;
@property (nonatomic ,strong) NSArray *baifenbiArr;
@property (nonatomic ,strong) UIColor *normalBgColor;
@property (nonatomic ,strong) UIColor *selectedBgColor;
@property (nonatomic ,strong) UIColor *normalCycleColor;
@property (nonatomic ,strong) UIColor *currentCycleColor;
@property (nonatomic ,strong) UIColor *currentCycleBoardColor;
@property (nonatomic ,assign) NSInteger currentIndex;
@property (nonatomic ,strong) void(^selectedIndexCallback)(NSInteger index, NSString *valueStr);
@property (nonatomic ,strong) void(^changeSliderCallback)(float progress);
@property (nonatomic ,assign) BOOL hideTopIndex;

@end


@protocol CustomDoubleSliderDelegate <NSObject>

- (void)customDoubleSliderChangeValue:(float)value state:(UIGestureRecognizerState)state isMinValue:(BOOL)isMinValue;

- (void)customDoubleSliderChangeMiddleTimeRange:(CMTimeRange)timeRange state:(UIGestureRecognizerState)state;

- (void)customDoubleSliderChangeMiddleTimeRange:(CMTimeRange)timeRange state:(UIGestureRecognizerState)state isMinValue:(BOOL)isMinValue;

@end

typedef NS_ENUM(NSInteger, CustomDoubleSliderTyep){
    CustomDoubleSliderTyep_Left,
    CustomDoubleSliderTyep_Right,
    CustomDoubleSliderTyep_Middle,
};

@interface CustomDoubleSlider : UIView

/**
 设置最小值
 */
@property (nonatomic,assign)CGFloat minValue;

/**
 设置最大值
 */
@property (nonatomic,assign)CGFloat maxValue;

/**
 设置min 颜色，默认为UIColorFromRGB(0x48cce2)
 */
@property (nonatomic,strong)UIColor *minTintColor;

/**
 设置max 颜色，默认为UIColorFromRGB(0xf73e5f)
 */
@property (nonatomic,strong)UIColor *maxTintColor;

/**
 设置主轨道颜色DBAA31
 */
@property (nonatomic,strong)UIColor *mainTintColor;

/**
 设置中间轨道颜色，默认为UIColorFromRGB(0xdead37)
 */
@property (nonatomic,strong)UIColor *middleTintColor;

/**
 是否显示数值，默认为YES
 */
@property (nonatomic,assign)BOOL isShowLabel;

/**
 延迟多少秒隐藏数值，isShowLabel 设置为YES时有效，默认-1 不隐藏
 */
@property (nonatomic,assign)float delayTime;
/**
 显示较小的数Label
 */
@property (nonatomic,strong)UILabel *minLabel;

/**
 显示较大的数Label
 */
@property (nonatomic,strong)UILabel *maxLabel;

/**
 当前最小值
 */
@property (nonatomic,assign)CGFloat currentMinValue;

/**
 当前最大值
 */
@property (nonatomic,assign)CGFloat currentMaxValue;

/**
 是否显示中间轨道，默认为NO
 */
@property (nonatomic,assign) BOOL isShowMiddleTrack;
/**
 当前中间时间范围
 */
@property (nonatomic,assign)CMTimeRange currentMiddelTimeRange;
@property (nonatomic,assign)float middelMinTimeDuration;

/**
 显示 min 滑块
 */
@property (nonatomic,strong)UIImageView *minThumbImageView;

/**
 显示 max 滑块
 */
@property (nonatomic,strong)UIImageView *maxThumbImageView;

/**
 显示中间左边滑块
 */
@property (nonatomic,strong)UIImageView *middleLeftThumbImageView;

/**
 显示中间右边滑块
 */
@property (nonatomic,strong)UIImageView *middleRightThumbImageView;

/**
 min 滑块图片，默认为nil
 */
@property (nonatomic,strong)UIImage *minThumbImage;

/**
  max 滑块图片，默认为nil
 */
@property (nonatomic,strong)UIImage *maxThumbImage;

/**
 设置min 滑块 颜色，默认为whiteColor
 */
@property (nonatomic,weak)UIColor *minThumbColor;

/**
 设置max 滑块 颜色，默认为whiteColor
 */
@property (nonatomic,weak)UIColor *maxThumbColor;

/**
 设置单位
 */
@property (nonatomic,copy)NSString * unit;

@property (nonatomic, assign) CustomDoubleSliderTyep currentType;

@property (nonatomic, weak) id<CustomDoubleSliderDelegate> delegate;

- (void)showMinView;
- (void)showMaxView;
- (void)showMiddleView;
- (void)hiddenLabel;
@end
