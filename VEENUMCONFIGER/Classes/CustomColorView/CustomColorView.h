//
//  CustomColorView.h
//  PEImageInfo
//
//  Created by emmet-mac on 2023/4/23.
//

#import <UIKit/UIKit.h>
#import <VEENUMCONFIGER/VESlider.h>
#import "ColorDragView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ColorButton : UIButton
@property (nonatomic,strong)UIView *selectedView;
@end

@class CustomColorView;
@protocol CustomColorViewDelegate <NSObject>

-(void)colorViewClose_View:( CustomColorView * _Nullable ) view;

- (void)colorViewChangeColor:(UIColor *)color;

@end
@interface CustomColorView : UIView<ColorDragViewDelegate>{
    
}
@property (nonatomic,strong)NSMutableArray *otherColors;
@property (nonatomic,strong)NSMutableArray *colors;
@property (nonatomic,strong)UIView *colorBottomView;
@property (nonatomic,strong)UIButton *moreColorsBtn;
@property (nonatomic,strong)VESlider *moreColorSlider;
@property (nonatomic,strong)UIImageView  *sliderBgView;
@property (nonatomic,strong)UIScrollView *colorView;
@property (nonatomic,assign)NSInteger selectColorIndex;
@property(nonatomic,weak)id<CustomColorViewDelegate>   delegate;
@property (nonatomic,strong)UIView *customColorView;
@property (nonatomic,strong)ColorDragView *customShowColorView;
@property (nonatomic,strong)UIView *lastColorView;
@property (nonatomic,strong)UIScrollView *otherColorScrollView;
@property (nonatomic,strong)UIButton *otherColorAddBtn;
@property (nonatomic,strong)UIButton *doneBtn;
- (void)changeDragViewColorIndex:(NSInteger )selectColorIndex;
- (void)refreshOtherColorScrollView;
- (NSString *) UIColorToHexString:(UIColor *)uiColor;
- (UIColor *) RedoColorWithHexString:(NSString *)strColor;
- (void)setSelectDragColor:(UIColor *)color;
- (void)setSelectColor:(UIColor *) color;
@end

NS_ASSUME_NONNULL_END
