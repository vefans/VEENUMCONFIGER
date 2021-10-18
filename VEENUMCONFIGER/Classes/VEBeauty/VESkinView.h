//
//  VESkinView.h
//  VEENUMCONFIGER
//
//  Created by mac on 2021/7/28.
//

#import <UIKit/UIKit.h>

@class VESkinView;

@protocol VESkinViewDelegate <NSObject>

-(void)skinEditCompletion:( VESkinView *) view;

-(void)skinCancelEdit:( VESkinView *) view slider:(UISlider *) slider;

-(void)skinValueChanged:(UISlider *) slider atVIew:(VESkinView *) view;

-(void)skinReset:(UISlider *) slider atVIew:(VESkinView *) view;

-(void)skinCompare:(VESkinView *)view;

-(void)skinCompareCompletion:(UISlider *) slider atVIew:(VESkinView *)view;

@end

@interface VESkinView : UIView

@property(nonatomic, strong)UILabel *titleLbl;
@property(nonatomic, weak)UIView            *toolbarView;
@property(nonatomic, assign)KBeautyCategoryType beautyCategoryType;
@property(nonatomic, strong)MediaAsset * currentMedia;

@property(nonatomic,weak)id<VESkinViewDelegate>   delegate;

@property(nonatomic, weak)UISlider   *adjustmentSlider;
@property(nonatomic, weak)UILabel    *adjustmentNumberLabel;
@property(nonatomic, assign)CGRect currentFaceRect;

@end
