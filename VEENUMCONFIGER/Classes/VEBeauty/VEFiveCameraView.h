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

-(void)fiveSensesCancelEdit:( VEFiveCameraView *) view;

-(void)fiveSenses_ValueChanged:(UISlider *) slider atVIew:(VEFiveCameraView *) view;

-(void)fiveSenses_Reset:(NSInteger) type atVIew:(VEFiveCameraView *) view;

-(void)fiveSensesCompare:(NSInteger) type atVIew:(VEFiveCameraView *)view;

-(void)fiveSensesCompareCompletion:(NSInteger) type atVIew:(VEFiveCameraView *)view;

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
@property (nonatomic, strong)  FaceAttribute* faceAttribute;
@property (nonatomic, strong)  FaceAttribute* oldFaceAttribute;
@property (nonatomic, strong)  CameraManager* camera;
//@property(nonatomic, strong)MediaAsset * currentMedia;
//@property(nonatomic, strong)MediaAsset * orginMedia;
@property(nonatomic, assign)CGRect currentFaceRect;
- (void)setDefaultValue;
- (void)resetAdjustment_Btn:(UIButton *)sender;
@end
