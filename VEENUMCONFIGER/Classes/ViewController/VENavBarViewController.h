//
//  VENavBarViewController.h
//  VEENUMCONFIGER
//
//  Created by 刘超 on 2021/2/16.
//

#import <UIKit/UIKit.h>
#import "VENavBarButton.h"
#import <VEENUMCONFIGER/VEENUMCONFIGER.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BackTypeCode) {
    NavBackCode,
    DisBackCode
};


@interface VENavBarViewController : UIViewController
@property(nonatomic, strong)UIView               *navBar;       //导航栏

@property(nonatomic, strong)VENavBarButton       *backBtn;      //返回按钮

@property(nonatomic,strong) VENavBarButton       *exportNavBarBtn; //导出按钮

@property(nonatomic, strong)UILabel              *titlelab;     //标题

@property(nonatomic, strong)UIView               *barline;      //分割线

@property(nonatomic, assign)BackTypeCode         typeCode;      //返回类型

@property(nonatomic, strong)UIView               *toolBar;

@property(nonatomic,strong) VENavBarButton       *finishToolBarBtn; //工具栏完成按钮

//隐藏导航栏
- (void)navBarHidden:(BOOL)hidden;
//返回事件
- (void)backAction;

@end

NS_ASSUME_NONNULL_END
