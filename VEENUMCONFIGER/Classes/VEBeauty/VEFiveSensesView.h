//
//  VEFiveSensesView.h
//  VEENUMCONFIGER
//
//  Created by mac on 2021/7/28.
//

#import <UIKit/UIKit.h>

@class VEFiveSensesView;

@protocol VEFiveSensesViewDelegate <NSObject>

-(void)fiveSensesEditCompletion:( VEFiveSensesView *) view;

-(void)fiveSensesCancelEdit:( VEFiveSensesView *) view;

-(void)fiveSenses_ValueChanged:(UISlider *) slider atVIew:(VEFiveSensesView *) view;

-(void)fiveSenses_Reset:(NSInteger) type atVIew:(VEFiveSensesView *) view;

-(void)fiveSensesCompare:(NSInteger) type atVIew:(VEFiveSensesView *)view;

-(void)fiveSensesCompareCompletion:(NSInteger) type atVIew:(VEFiveSensesView *)view;

@end

@interface VEFiveSensesView : UIView

@property(nonatomic, assign)NSInteger       currentType;
@property(nonatomic, assign)UIButton        *currentBtn;

@property(nonatomic, weak)UIView            *toolbarView;
@property(nonatomic, weak)UIScrollView    *ribbonScrollView;



@property(nonatomic,weak)id<VEFiveSensesViewDelegate>   delegate;

@property(nonatomic, strong)NSMutableArray<UIView *> * adjustmentViews;
@property(nonatomic, strong)NSMutableArray<UISlider *> * adjustmentSliders;
@property(nonatomic, strong)NSMutableArray<UILabel *> * adjustmentNumberLabels;

@property(nonatomic, assign)float  adjHeight;
@property(nonatomic, strong)MediaAsset * currentMedia;
@property(nonatomic, assign)CGRect currentFaceRect;

@end
