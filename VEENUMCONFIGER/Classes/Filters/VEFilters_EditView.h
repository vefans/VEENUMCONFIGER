//
//  VEFilters_EditView.h
//  VEFileSDK
//
//  Created by mac on 2023/11/14.
//

#import <UIKit/UIKit.h>
#import <VEENUMCONFIGER/VESlider.h>
#import "VEFileScrollViewChildItem.h"
#import <VEENUMCONFIGER/VEDownTool.h>

NS_ASSUME_NONNULL_BEGIN
@class VEFilters_EditView;

@protocol VEFilters_EditViewDelegate <NSObject>

@optional
-(void)Filters_finish_Btn:(VEFilters_EditView * _Nullable) filterEditView;
-(void)FilterClose_View:( VEFilters_EditView * _Nullable ) filterEditView;
//取消
-(void)cancelCustomFilter:(CustomFilter * _Nullable) customFilter atView:(VEFilters_EditView * _Nullable) view;
//添加
-(void)addCustomFilter:(CustomFilter * _Nullable) customFilter atView:(VEFilters_EditView * _Nullable) view;

-(void)filterIntensity:( float ) value atView:(VEFilters_EditView * _Nullable) view;

-(void)filterStrip:( BOOL ) isStrip atView:(VEFilters_EditView * _Nullable) view;
@end
@interface VEFilters_EditView : UIView<VEFileScrollViewChildItemDelegate,UIScrollViewDelegate>
{
    int                     currentlabelFilter;
    int                     currentFilterIndex;
    float                        oldFilterStrength;     //旧 滤镜强度
}
//清除滤镜参数
+(void)releaseFilterArray;
//下载滤镜分类及滤镜
+( void )loadFilterType:(void(^)(NSMutableArray * globalFilters))callBack atFilterResourceURL:( NSString * ) filterResourceURL atNetMaterialTypeURL:( NSString * ) netMaterialTypeURL;
//重新构建滤镜数组
+(NSMutableArray *)createGlobalFilters;
//下载网络资源中
@property (nonatomic,strong) UIView  *loadView;
//是否隐藏标题
@property(nonatomic, assign) BOOL isHiddenTitleBar;
//标题栏是否置顶
@property(nonatomic, assign) BOOL istPutOnTopTitleBar;
//是否显示关闭按钮
@property(nonatomic, assign) BOOL isShowCloseBtn;
//是否关闭动画
@property(nonatomic, assign) BOOL isCloseAnimation;
//是否关闭标题
@property(nonatomic, assign) BOOL isCloseTitle;


@property(nonatomic, strong) UIButton *otherBtn;
@property(nonatomic,strong)UIButton *finishBtn;
@property(nonatomic,weak)id<VEFilters_EditViewDelegate>   delegate;

@property(nonatomic,assign)BOOL             isEditFilters;

@property(nonatomic,strong)UICollectionView *filterCollectionView;
@property(nonatomic,strong)UIScrollView     *filterChildsView;
@property(nonatomic,strong)VESlider        *filterProgressSlider;
@property(nonatomic,strong)UILabel          *percentageLabel;
@property(nonatomic,weak)UIButton                *stripBtn;
//新滤镜
@property (nonatomic, strong) UIView    * fileterNewView;
@property (nonatomic, strong) UIScrollView    *fileterLabelNewScroView;

@property (nonatomic, strong) UIScrollView    *fileterScrollView;
@property(nonatomic,strong)VEFileScrollViewChildItem *originalItem;

@property (nonatomic, strong) UILabel   *filterStrengthLabel;

@property(nonatomic,assign)NSInteger       selectFilterIndex;

@property(nonatomic,assign)float                        filterStrength;
@property(nonatomic,strong)CustomMultipleFilter       *oldFilters;

@property(nonatomic, weak) UIButton *noButton;

-(void)scrollViewIndex:(int) fileterindex;

//滤镜强度

-(void)initUI;

- (instancetype)initWithFrame:(CGRect)frame atEditFilters:(BOOL) isEditFilters;
-(void)save;

@property(nonatomic, strong)CustomFilter *currentCustomFilter;

@property (nonatomic,strong) VEEditConfiguration     *editConfiguration;
@end

NS_ASSUME_NONNULL_END
