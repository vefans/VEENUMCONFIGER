//
//  VEPlaySlider.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/2/17.
//

#import "VEPlaySlider.h"
#import "VEHelp.h"
@interface VEPlaySlider()<UIGestureRecognizerDelegate>

@end

@implementation VEPlaySlider
#pragma mark - 1.Life Cycle

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfiguration];
        [self setupViews];
    }
    return self;
}

#pragma mark - 2.Setting View and Style

-(void)initConfiguration{
    
}

- (void)setupViews{
    
    /// 属性配置
    // minimumValue  : 当值可以改变时，滑块可以滑动到最小位置的值，默认为0.0
    self.minimumValue = 0.0;
    // maximumValue : 当值可以改变时，滑块可以滑动到最大位置的值，默认为1.0
    self.maximumValue = 1.0;
    // 当前值，这个值是介于滑块的最大值和最小值之间的，如果没有设置边界值，默认为0-1；
    self.value = 0;

    // continuous : 如果设置YES，在拖动滑块的任何时候，滑块的值都会改变。默认设置为YES
    [self setContinuous:YES];


    // minimumTrackTintColor : 小于滑块当前值滑块条的颜色，默认为蓝色
    self.minimumTrackTintColor = Main_Color;
    // maximumTrackTintColor: 大于滑块当前值滑块条的颜色，默认为白色
    self.maximumTrackTintColor = Color(255,255,255,0.32);
    // thumbTintColor : 当前滑块的颜色，默认为白色
    [self setThumbImage:[VEHelp imageWithContentOfFile:@"play_slider_thumb"] forState:UIControlStateNormal];

    [self addTarget:self action:@selector(playSliderValue:) forControlEvents:UIControlEventValueChanged];
    
    [self addTarget:self action:@selector(sliderValurChanged:forEvent:) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    

   
    
}
#pragma mark - 3 Request Data


#pragma mark - 4.Custom Methods

- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
//    CGPoint touchPoint = [sender locationInView:self];
//    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.x / self.frame.size.width );
//    [self setValue:value animated:YES];
//    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(playSlider:withPlayValue:)]) {
//        [self.delegate playSlider:self withPlayValue:value];
//    }
    
}

-(void)playSliderValue:(id)sender{
    UISlider *slider=(UISlider *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(playSlider:withPlayValue:)]) {
        [self.delegate playSlider:self withPlayValue:slider.value];
    }
    
}

- (void)sliderValurChanged:(UISlider*)slider forEvent:(UIEvent*)event {
    UITouch*touchEvent = [[event allTouches]anyObject];
    switch(touchEvent.phase) {
            case UITouchPhaseBegan:{
                if (self.delegate && [self.delegate respondsToSelector:@selector(playSliderTouchesBegan:withEvent:)]) {
                    [self.delegate playSliderTouchesBegan:self withEvent:event];
                }
            }
            break;
        case UITouchPhaseMoved:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(playSliderTouchesMoved:withEvent:)]) {
                    [self.delegate playSliderTouchesMoved:self withEvent:event];
                }
            }
            break;
        case UITouchPhaseEnded:
            {
                if (self.delegate && [self.delegate respondsToSelector:@selector(playSliderTouchesEnded:withEvent:)]) {
                    [self.delegate playSliderTouchesEnded:self withEvent:event];
                }
            }
            break;
        default:
            break;
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self setNeedsLayout];
}


#pragma mark - 5.DataSource and Delegate


#pragma mark - 6.Set & Get

#pragma mark - 7.Notification

#pragma mark - 8.Event Response

@end
