//
//  VEFiveCameraView.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/7/28.
//

#import <UIKit/UIKit.h>
#import <LibVECore/LibVECore.h>
@class VEFiveCameraView;

@protocol VEFiveCameraViewDelegate <NSObject>

-(void)fiveSensesEditCompletion:( VEFiveCameraView *) view;

-(void)fiveSenses_ValueChanged:(UISlider *) slider atVIew:(VEFiveCameraView *) view;

-(void)fiveSenses_Reset:(NSInteger) type value:(float)value;

-(void)fiveSensesCompare:(NSInteger) type value:(float)value;

-(void)fiveSensesCompareCompletion:(NSInteger) type value:(float)value;

- (void)fiveSensesResetAll;
- (void)fiveSensesCompareCompletionAll:(FaceAttribute *)faceAttribute;

@end

@interface VEFiveCameraView : UIView
{
    MediaAsset *_editMedia;//用于对比
}

@property(nonatomic, assign)NSInteger       currentType;
@property(nonatomic, assign)UIButton        *currentBtn;

@property(nonatomic, weak)UIView            *toolbarView;
@property(nonatomic, weak)UIScrollView    *ribbonScrollView;

@property(nonatomic, strong)UIScrollView *beautyView;

@property(nonatomic,weak)id<VEFiveCameraViewDelegate>   delegate;

@property(nonatomic, strong)NSMutableArray<UIView *> * adjustmentViews;
@property(nonatomic, strong)NSMutableArray<UISlider *> * adjustmentSliders;
@property(nonatomic, strong)NSMutableArray<UILabel *> * adjustmentNumberLabels;
@property(nonatomic, strong)UILabel *sliderValueLabel;
@property(nonatomic, assign)float  adjHeight;
- (void)setDefaultValue;
- (void)resetAdjustment_Btn:(UIButton *)sender;
-(FaceAttribute *) getFaceAttribute;
@end
