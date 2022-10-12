//
//  VEFiveSensesView.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/7/28.
//

#import "VEFiveSensesView.h"
#import <VEENUMCONFIGER/VEHelp.h>
#import <VEENUMCONFIGER/VEPlaySlider.h>
@interface VEFiveSensesView()<UIScrollViewDelegate>
@property(nonatomic, weak)UILabel * sliderValueLabel;
@end
@implementation VEFiveSensesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        self.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : VIEW_COLOR;
        // 左上和右上为圆角
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
        cornerRadiusLayer.frame = self.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        self.layer.mask = cornerRadiusLayer;
        [self initToolbarView];
//        {
//            UIButton * resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, [VEConfigManager sharedManager].iPad_HD ? (self.frame.size.height - 40) : (self.frame.size.height - kPlayerViewOriginX - 40), 80, 35)];
//            [resetBtn setImage:[VEHelp imageNamed:@"剪辑_重置默认_"] forState:UIControlStateNormal];
//            [resetBtn setImage:[VEHelp imageNamed:@"剪辑_重置选中_"] forState:UIControlStateHighlighted];
//            [resetBtn setTitle:VELocalizedString(@"重置", nil) forState:UIControlStateNormal];
//            [resetBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
//            [resetBtn setTitleColor:UIColorFromRGB(0x3c3d3d) forState:UIControlStateHighlighted];
//            resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//            [resetBtn addTarget:self action:@selector(resetAdjustment_Btn:) forControlEvents:UIControlEventTouchUpInside];
//            [self addSubview:resetBtn];
//            
//            UIButton *compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            compareBtn.frame = CGRectMake(self.frame.size.width - (64 + 15), resetBtn.frame.origin.y, 64, 28);
//            [compareBtn setTitle:VELocalizedString(@"toning_compare", nil) forState:UIControlStateNormal];
//            [compareBtn setTitleColor:Main_Color forState:UIControlStateNormal];
//            [compareBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
//            compareBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
//            compareBtn.layer.cornerRadius = 28/2.0;
//            compareBtn.layer.borderColor = UIColorFromRGB(0x626267).CGColor;
//            compareBtn.layer.borderWidth = 1.0;
//            [compareBtn addTarget:self action:@selector(compareBtnDown:) forControlEvents:UIControlEventTouchDown];
//            [compareBtn addTarget:self action:@selector(compareBtnUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
//            [self addSubview:compareBtn];
//        }
        
        _adjustmentSliders = [NSMutableArray new];
        _adjustmentNumberBtns = [NSMutableArray new];
        _adjustmentViews = [NSMutableArray new];
        
        _adjHeight = (self.frame.size.height - kPlayerViewOriginX - 40 - 44)/2.0;
        
        if([VEConfigManager sharedManager].iPad_HD){
            _beautyView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 44 - 44)];
            _beautyView.backgroundColor = [UIColor clearColor];
            _beautyView.delegate = self;
            [self addSubview:_beautyView];
            NSArray *list = @[
                            @{@"title":@"磨皮",@"id":@(KBeauty_BlurIntensity)},
                            @{@"title":@"美白",@"id":@(KBeauty_BrightIntensity)},
                            @{@"title":@"红润",@"id":@(KBeauty_ToneIntensity)},
                            @{@"title":@"大眼",@"id":@(KBeauty_BigEyes)},
                            @{@"title":@"瘦脸",@"id":@(KBeauty_FaceLift)},
                            @{@"title":@"脸宽",@"id":@(KBeauty_FaceWidth)},
                            @{@"title":@"下颌",@"id":@(KBeauty_ChinWidth)},
                            @{@"title":@"下巴",@"id":@(KBeauty_ChinHeight)},
                            @{@"title":@"眼宽",@"id":@(KBeauty_EyeWidth)},
                            @{@"title":@"眼高",@"id":@(KBeauty_EyeHeight)},
                            @{@"title":@"倾斜",@"id":@(KBeauty_EyeSlant)},
                            @{@"title":@"眼距",@"id":@(KBeauty_EyeDistance)},
                            @{@"title":@"鼻宽",@"id":@(KBeauty_NoseWidth)},
                            @{@"title":@"鼻高",@"id":@(KBeauty_NoseHeight)},
                            @{@"title":@"嘴宽",@"id":@(KBeauty_MouthWidth)},
                            @{@"title":@"上嘴唇",@"id":@(KBeauty_LipUpper)},
                            @{@"title":@"下嘴唇",@"id":@(KBeauty_LipLower)},
                            @{@"title":@"微笑",@"id":@(KBeauty_Smile)}
                              ];
            
            
            for (int i = 0; i<list.count; i++) {
                [self initAdjView:CGRectMake(0, 50 * i, self.frame.size.width, 50) atStr:list[i][@"title"]];
                UISlider *slider = _adjustmentSliders[i];
                slider.tag = [list[i][@"id"] integerValue];
                if (slider.tag == KBeauty_BlurIntensity
                    || slider.tag == KBeauty_BrightIntensity
                    || slider.tag == KBeauty_ToneIntensity
                    || slider.tag == KBeauty_BigEyes
                    || slider.tag == KBeauty_FaceLift)
                {
                    slider.minimumValue = 0.0;
                }
                [_beautyView addSubview:_adjustmentViews[i]];
            }
            [self insertColorGradient:_beautyView];
            [self setDefaultValue];
            _beautyView.contentSize = CGSizeMake(0, list.count * 50);
        }
        else{
            _beautyView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 14, CGRectGetWidth(self.frame), 60)];
            _beautyView.backgroundColor = [UIColor clearColor];
            _beautyView.showsHorizontalScrollIndicator = NO;
            _beautyView.showsVerticalScrollIndicator = NO;
            _beautyView.delegate = self;
            [self addSubview:_beautyView];
            NSArray *list = @[
                            @{@"title":@"脸型",@"id":@(KBeauty_FaceWidth)},
                            @{@"title":@"下颌",@"id":@(KBeauty_ChinWidth)},
                            @{@"title":@"下巴",@"id":@(KBeauty_ChinHeight)},
                            @{@"title":@"眼宽",@"id":@(KBeauty_EyeWidth)},
                            @{@"title":@"眼高",@"id":@(KBeauty_EyeHeight)},
                            @{@"title":@"倾斜",@"id":@(KBeauty_EyeSlant)},
                            @{@"title":@"眼距",@"id":@(KBeauty_EyeDistance)},
                            @{@"title":@"鼻宽",@"id":@(KBeauty_NoseWidth)},
                            @{@"title":@"鼻高",@"id":@(KBeauty_NoseHeight)},
                            @{@"title":@"嘴宽",@"id":@(KBeauty_MouthWidth)},
                            @{@"title":@"上嘴唇",@"id":@(KBeauty_LipUpper)},
                            @{@"title":@"下嘴唇",@"id":@(KBeauty_LipLower)},
                            @{@"title":@"微笑",@"id":@(KBeauty_Smile)}
                              ];
            
            float contentsWidth = 20;
            UIView *sliderSupView = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - 44) - 10, CGRectGetWidth(self.frame), 44)];
            sliderSupView.backgroundColor = [UIColor clearColor];
            [self addSubview:sliderSupView];
            _adjustmentSliders = [NSMutableArray new];
            for (int i = 0; i<list.count; i++) {
                
                NSString *title = [list[i] objectForKey:@"title"];
                
                float ItemBtnWidth = [VEHelp widthForString:VELocalizedString(title, nil) andHeight:14 fontSize:12] ;
                ItemBtnWidth = MAX(ItemBtnWidth, 44);
                UIButton *toolItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_beautyView addSubview:toolItemBtn];
                toolItemBtn.frame = CGRectMake(contentsWidth, (_beautyView.frame.size.height - 60)/2.0, ItemBtnWidth, 40 + 20);
                toolItemBtn.tag = [[list[i] objectForKey:@"id"] integerValue];
                
                [toolItemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/%@默认",title]] forState:UIControlStateNormal];
                [toolItemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/%@选中",title]] forState:UIControlStateSelected];
                [toolItemBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
                [toolItemBtn setTitleColor:Main_Color forState:UIControlStateSelected];
                [toolItemBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (ItemBtnWidth - 40)/2.0, 20, (ItemBtnWidth - 40)/2.0)];
                [toolItemBtn setTitleEdgeInsets:UIEdgeInsetsMake(40, -40, 0, 0)];
                
                
                [toolItemBtn setTitle:VELocalizedString(title, nil) forState:UIControlStateNormal];
                toolItemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                toolItemBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                
                [toolItemBtn addTarget:self action:@selector(toolBar_Btn:) forControlEvents:UIControlEventTouchUpInside];
                contentsWidth += ItemBtnWidth+25;
                                
                
                VEPlaySlider * slider = [[VEPlaySlider alloc] initWithFrame:CGRectMake(63, (CGRectGetHeight(sliderSupView.frame) - 35)/2.0,sliderSupView.frame.size.width - 63*2 , 35)];
                slider.tag = [list[i][@"id"] integerValue];
                [slider setMinimumValue:-1.0];
                [slider setMaximumValue:1.0];
                [slider setValue:0];
                slider.hidden = YES;
                
                UIImage *trackImage = [VEHelp imageWithColor:SliderMaximumTrackTintColor size:CGSizeMake(10, 2.0) cornerRadius:1];
                [slider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
                [slider setMaximumTrackImage: trackImage forState:UIControlStateNormal];
                [slider setThumbImage:[VEHelp imageWithContentOfFile:@"New_EditVideo/LiteBeauty/拖动球"] forState:UIControlStateNormal];
                [slider addTarget:self action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
                [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
                [slider addTarget:self action:@selector(endScrub:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
                [sliderSupView addSubview:slider];
                [_adjustmentSliders addObject:slider];
                
                UIView *trackView = [[UIView alloc] initWithFrame:CGRectMake(slider.frame.size.width/2.0 ,CGRectGetMidY(slider.frame), 0, 2)];
                trackView.backgroundColor = Main_Color;
                trackView.tag = 100 + slider.tag;
                trackView.hidden = YES;
                [sliderSupView addSubview:trackView];
                               
                if( i == 0 )
                {
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x + (slider.frame.size.width - 30)/2.0, -10, 30, 15)];
                    label.text  = @"0";
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont systemFontOfSize:12];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.hidden = YES;
                    _sliderValueLabel = label;
                    [sliderSupView addSubview:_sliderValueLabel];
                    
                    toolItemBtn.selected = YES;
                    slider.hidden = NO;
                    trackView.hidden = NO;
                    _currentBtn = toolItemBtn;
                    _currentType = i;
                }
            }
            _beautyView.contentSize = CGSizeMake(contentsWidth, 0);
            
        }
        
        UIButton *compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        compareBtn.frame = CGRectMake(self.frame.size.width - 63 + (63 - 40)/2.0, (CGRectGetHeight(self.frame) - 44) - 10 , 40, 44);
        [compareBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/skin/%@默认",@"对比"]] forState:UIControlStateNormal];
        [compareBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/skin/%@选中",@"对比"]] forState:UIControlStateSelected];
        [compareBtn addTarget:self action:@selector(compareBtnDown:) forControlEvents:UIControlEventTouchDown];
        [compareBtn addTarget:self action:@selector(compareBtnUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self addSubview:compareBtn];
        
//        UIButton * resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,(CGRectGetHeight(self.frame) - 44) - 10, 70, 44)];
//        [resetBtn setImage:[VEHelp imageNamed:@"剪辑_重置默认_"] forState:UIControlStateNormal];
//        [resetBtn setImage:[VEHelp imageNamed:@"剪辑_重置选中_"] forState:UIControlStateHighlighted];
//        [resetBtn setTitle:VELocalizedString(@"还原", nil) forState:UIControlStateNormal];
//        [resetBtn setTitleColor:UIColorFromRGB(0xbebebe) forState:UIControlStateNormal];
//        [resetBtn setTitleColor:Main_Color forState:UIControlStateHighlighted];
//        resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        resetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        [resetBtn addTarget:self action:@selector(resetAdjustment_Btn:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:resetBtn];
//        else{
////            [self initAdjView:CGRectMake(0, (_adjHeight*2.0 - 35)/2.0 + 44, self.frame.size.width, 35) atStr:@"脸宽"];
////            [self initAdjView:CGRectMake(0, (_adjHeight - 35)/2.0 + 44 + 5, self.frame.size.width/2.0 - 10, 35) atStr:@"眼睛倾斜"];
////            [self initAdjView:CGRectMake(10 + self.frame.size.width/2.0, (_adjHeight - 35)/2.0 + 44 + 5, self.frame.size.width/2.0 - 10, 35) atStr:@"眼睛距离"];
////            [self initAdjView:CGRectMake(0, (_adjHeight - 35)/2.0 + _adjHeight + 44 - 5, self.frame.size.width, 35) atStr:@"下巴高"];
//        }
    }
    return self;
}
- (void)setDefaultValue{
    __block FaceAttribute *faceAttribute = nil;
    [_currentMedia.multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(_currentFaceRect, CGPointMake(obj.faceRect.origin.x + obj.faceRect.size.width / 2.0, obj.faceRect.origin.y + obj.faceRect.size.height / 2.0)) || CGRectEqualToRect(_currentFaceRect, obj.faceRect)) {
            faceAttribute = obj;
            *stop = YES;
        }
    }];
    {
        NSInteger index = 5;
        if([VEConfigManager sharedManager].iPad_HD){
            index = 0;
            _adjustmentSliders[0].value = _orginMedia.beautyBlurIntensity;
            _adjustmentSliders[1].value = _orginMedia.beautyBrightIntensity;
            _adjustmentSliders[2].value = _orginMedia.beautyToneIntensity;
            _adjustmentSliders[3].value = _orginMedia.beautyBigEyeIntensity;
            _adjustmentSliders[4].value = _orginMedia.beautyThinFaceIntensity;
        }
        float defaultValue = 0.0;
        
        _adjustmentSliders[5 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.faceWidth;
        
        _adjustmentSliders[6 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.chinWidth;
        _adjustmentSliders[7 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.chinHeight;
        
        _adjustmentSliders[8 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeWidth;
        _adjustmentSliders[9 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeHeight;
        _adjustmentSliders[10 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeSlant;
        _adjustmentSliders[11 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeDistance;
        
        _adjustmentSliders[12 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.noseWidth;
        _adjustmentSliders[13 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.noseHeight;
        
        _adjustmentSliders[14 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.mouthWidth;
        _adjustmentSliders[15 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.lipUpper;
        _adjustmentSliders[16 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.lipLower;
        
        _adjustmentSliders[17 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.smile;
        
        [_adjustmentSliders enumerateObjectsUsingBlock:^(UISlider * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self sliderValueChanged:obj];
        }];
    }
}

-(void)initAdjView:(CGRect)  rect atStr:( NSString * ) str
{
    UIView * view = [[UIView alloc] initWithFrame:rect];
    if(![VEConfigManager sharedManager].iPad_HD){
        [self addSubview:view];
    }
    [_adjustmentViews addObject:view];
    
    
        UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake([VEConfigManager sharedManager].iPad_HD ? 90 : 63, (CGRectGetHeight(rect) - 35)/2.0, view.frame.size.width - 140, 35)];
        [slider setMinimumValue:-1.0];
        [slider setMaximumValue:1.0];
        [slider setValue:0];

        [slider addTarget:self action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
        [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(endScrub:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];

        UIImage * theImage = [UIImage imageNamed:[VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"New_EditVideo/LiteBeauty/拖动球@3x" Type:@"png"]];
        [slider setThumbImage:theImage forState:UIControlStateNormal];

        [slider setMaximumTrackImage:[VEHelp imageWithColor:UIColorFromRGB(0x2F302F) size:CGSizeMake(slider.frame.size.width, 1) cornerRadius:1] forState:UIControlStateNormal];
        [slider setMinimumTrackImage: [VEHelp imageWithColor:UIColorFromRGB(0x2F302F) size:CGSizeMake(slider.frame.size.width, 1) cornerRadius:1] forState:UIControlStateNormal];
       [_adjustmentSliders addObject:slider];
           [view addSubview:slider];
        
        if(([VEConfigManager sharedManager].iPad_HD &&
           ![str isEqualToString:@"磨皮"] &&
           ![str isEqualToString:@"美白"] &&
           ![str isEqualToString:@"红润"] &&
           ![str isEqualToString:@"大眼"] &&
           ![str isEqualToString:@"瘦脸"]) || ![VEConfigManager sharedManager].iPad_HD){
            
            UIView *trackView = [[UIView alloc] initWithFrame:CGRectMake(slider.frame.size.width/2.0 ,CGRectGetMidY(slider.frame), 0, 1)];
            trackView.backgroundColor = Main_Color;
            trackView.tag = 100 + slider.tag;
            [view addSubview:trackView];
        }else{
            if([VEConfigManager sharedManager].iPad_HD){
                [slider setMinimumTrackImage: [VEHelp imageWithColor:Main_Color size:CGSizeMake(slider.frame.size.width, 1) cornerRadius:1] forState:UIControlStateNormal];
            }
        }
       
   
       {
           float ItemBtnWidth = [VEHelp widthForString:VELocalizedString(str, nil) andHeight:14 fontSize:12] + 40 ;
           ItemBtnWidth = MAX(ItemBtnWidth, 64);
           UIButton *toolItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
           [view addSubview:toolItemBtn];
           toolItemBtn.frame = CGRectMake(0, (view.frame.size.height - 40)/2.0, ItemBtnWidth, 40);
           toolItemBtn.tag = 1000;
           if([str isEqualToString:@"脸宽"]){
               [toolItemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/%@默认",@"脸型"]] forState:UIControlStateNormal];
               [toolItemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/%@选中",@"脸型"]] forState:UIControlStateSelected];
           }else{
               if(_adjustmentNumberBtns.count <6){
                   [toolItemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/skin/%@默认",str]] forState:UIControlStateNormal];
                   [toolItemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/skin/%@选中",str]] forState:UIControlStateSelected];
               }else{
                   [toolItemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/%@默认",str]] forState:UIControlStateNormal];
                   [toolItemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/%@选中",str]] forState:UIControlStateSelected];
               }
           }
           [toolItemBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
           [toolItemBtn setTitleColor:TEXT_COLOR forState:UIControlStateSelected];
           [toolItemBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, (ItemBtnWidth - 40))];
           toolItemBtn.adjustsImageWhenHighlighted = NO;
           toolItemBtn.userInteractionEnabled = NO;
           [toolItemBtn setTitle:VELocalizedString(str, nil) forState:UIControlStateNormal];
           toolItemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
           toolItemBtn.titleLabel.font = [UIFont systemFontOfSize:12];
           
           [_adjustmentNumberBtns addObject:toolItemBtn];
           
           
           
       }
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 40, 0, 40, CGRectGetHeight(rect))];
    label.text  = @"0";
    label.tag = 200;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = TEXT_COLOR;
    [view addSubview:label];
}
- (void) insertColorGradient:(UIView *)view {
    if(![VEConfigManager sharedManager].iPad_HD){
        return;
    }
    UIColor *colorOne = [VIEW_IPAD_COLOR colorWithAlphaComponent:0.0];
    UIColor *colorTwo = VIEW_IPAD_COLOR;
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor,nil];
    
    CAGradientLayer *topLayer = [CAGradientLayer layer];
    topLayer.colors = colors;
    topLayer.frame = CGRectMake(0, CGRectGetMinY(view.frame), view.frame.size.width, 20);
    topLayer.startPoint = CGPointMake(0, 1);
    topLayer.endPoint = CGPointMake(0,0);
    [view.superview.layer insertSublayer:topLayer above:0];
    CAGradientLayer *bottomLayer = [CAGradientLayer layer];
    bottomLayer.colors = colors;
    bottomLayer.frame = CGRectMake(0, CGRectGetMaxY(view.frame) - 20, view.frame.size.width, 20);
    bottomLayer.startPoint = CGPointMake(0, 0);
    bottomLayer.endPoint = CGPointMake(0, 1);
    [view.superview.layer insertSublayer:bottomLayer above:0];
    
}
-(void)initToolbarView {
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, (![VEConfigManager sharedManager].iPad_HD ? 0 : 44))];
    _toolbarView = view;
    if(![VEConfigManager sharedManager].iPad_HD){
        return;
    }
    [self addSubview:view];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.5, self.frame.size.width, 0.5)];
    imageView.backgroundColor = UIColorFromRGB(0x2a2a2a);
    [_toolbarView addSubview:imageView];
    
    if(![VEConfigManager sharedManager].iPad_HD){
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((44 - 40)/2.0, (44 - 40)/2.0, 40, 40)];
            [_toolbarView addSubview:btn];
            [btn setImage:[VEHelp imageNamed:@"/jianji/music/剪辑-剪辑-音乐_关闭默认_@3x"] forState:UIControlStateNormal];
            [btn setImage:[VEHelp imageNamed:@"/jianji/music/剪辑-剪辑-音乐_关闭默认_@3x"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(close_Btn:) forControlEvents:UIControlEventTouchUpInside];
        }
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 44 + (44 - 40)/2.0, (44 - 40)/2.0, 40, 40)];
            [_toolbarView addSubview:btn];
            [btn setImage:[VEHelp imageNamed:@"/PESDKImage/PESDK_勾@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]]  forState:UIControlStateNormal];
            [btn setImage:[VEHelp imageNamed:@"/PESDKImage/PESDK_勾@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]]  forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(return_Btn:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    {
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(44, 0, self.frame.size.width - 88, 44)];
        if([VEConfigManager sharedManager].iPad_HD){
            scrollView.frame = CGRectMake(10, 0, self.frame.size.width - 20, 44);
        }
        [_toolbarView addSubview:scrollView];
        _ribbonScrollView = scrollView;
        
        if([VEConfigManager sharedManager].iPad_HD){
            [self createIpadUIRibbonScroll];
        }
    }
}
-(void)createIpadUIRibbonScroll
{
    NSMutableArray * toolItems = [NSMutableArray new];
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"瘦脸",@"title",@(6),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"脸型",@"title",@(0),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"下巴",@"title",@(1),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"眼睛",@"title",@(2),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"鼻子",@"title",@(3),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"嘴唇",@"title",@(4),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"微笑",@"title",@(5),@"id", nil];
    [toolItems addObject:dic1];
    }
    __block float contentsWidth = 10;
    __block NSMutableArray * btnArray = [NSMutableArray new];
    [toolItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = [toolItems[idx] objectForKey:@"title"];
        
        float ItemBtnWidth = [VEHelp widthForString:VELocalizedString(title, nil) andHeight:14 fontSize:14] ;
        
        UIButton *toolItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.ribbonScrollView addSubview:toolItemBtn];
        toolItemBtn.frame = CGRectMake(contentsWidth, 0, ItemBtnWidth, self.ribbonScrollView.frame.size.height);
        toolItemBtn.tag = [[toolItems[idx] objectForKey:@"id"] integerValue];
    
        [toolItemBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [toolItemBtn setTitleColor:Main_Color forState:UIControlStateSelected];
        if( idx == 0 )
        {
            toolItemBtn.selected = YES;
            _currentBtn = toolItemBtn;
            _currentType = idx;
        }
        
        [toolItemBtn setTitle:VELocalizedString(title, nil) forState:UIControlStateNormal];
        toolItemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        toolItemBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [toolItemBtn addTarget:self action:@selector(ipad_toolBar_Btn:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnArray addObject:toolItemBtn];
        contentsWidth += ItemBtnWidth+25;
    }];
    
    if( contentsWidth < self.ribbonScrollView.frame.size.width )
    {
        float  offsetX  = (self.ribbonScrollView.frame.size.width - contentsWidth)/2.0;
        [btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *toolItemBtn = (UIButton*)obj;
            CGRect rect = toolItemBtn.frame;
            rect.origin.x += offsetX;
            toolItemBtn.frame = rect;
        }];
        contentsWidth = self.ribbonScrollView.frame.size.width;
    }
    self.ribbonScrollView.contentSize = CGSizeMake(contentsWidth, 0);
    self.ribbonScrollView.showsVerticalScrollIndicator = NO;
    self.ribbonScrollView.showsHorizontalScrollIndicator = NO;
    [btnArray removeAllObjects];
}

-(void)setCurrentMedia:(MediaAsset *)currentMedia
{
    _currentMedia = currentMedia;
    _orginMedia = [_currentMedia mutableCopy];
    if([VEConfigManager sharedManager].iPad_HD){
        [self ipad_toolBar_Btn:_currentBtn];
    }else{
        [self toolBar_Btn:_currentBtn];
    }
}
-(void)ipad_toolBar_Btn:(UIButton *) sender{
    if( _currentBtn )
    {
        _currentBtn.selected =NO;
    }
    //_currentType = sender.tag;
    
    sender.selected = YES;
    
    _currentBtn = sender;
    
    switch (sender.tag) {
        case 0://MARK: 脸型
        {
            [_beautyView setContentOffset:CGPointMake(0, 50 * 5)];
        }
            break;
        case 1://MARK:下巴
        {
            [_beautyView setContentOffset:CGPointMake(0, 50 * 6)];
        }
            break;
        case 2://MARK: 眼睛
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 8)];
        }
            break;
        case 3://MARK: 鼻子
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 12)];
        }
            break;
        case 4://MARK: 嘴唇
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 14)];
        }
            break;
        case 5://MARK: 微笑
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 17)];
        }
            break;
        case 6://MARK: 瘦脸
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 0)];
        }
            break;
        default:
            [_beautyView setContentOffset:CGPointMake(0, 0)];
            break;
    }
}

-(void)toolBar_Btn:(UIButton *) sender
{
    for (VEPlaySlider * slider in _adjustmentSliders) {
        slider.hidden = (slider.tag != sender.tag);
        UIView *trackView = [slider.superview viewWithTag:100 + slider.tag];
        if([VEConfigManager sharedManager].iPad_HD){
            trackView = [slider.superview viewWithTag:100];
        }
        if(slider.tag == sender.tag){
            CGRect frame = _sliderValueLabel.frame;
            frame.origin.x =  slider.thumbRect.origin.x + slider.frame.origin.x - (30 - slider.thumbRect.size.width)/2.0;
            _sliderValueLabel.frame = frame;
            _sliderValueLabel.text = [NSString stringWithFormat:@"%.f",(slider.value * 100)];
            
            float trackImageHeight = slider.currentMinimumTrackImage.size.height;
            float thumbImageWidth = slider.currentThumbImage.size.width;
            if( slider.value < slider.maximumValue /2.0)
            {
                float with = slider.frame.size.width/2.0 - (slider.frame.size.width  - thumbImageWidth )*( (slider.value - slider.minimumValue )/(slider.maximumValue - slider.minimumValue))  - thumbImageWidth  ;
                if( with >= 0 )
                {
                    [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 - with + slider.frame.origin.x, CGRectGetMidY(slider.frame) - trackImageHeight/2.0, with, trackImageHeight) ];
                }else {
                    [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 - with+ slider.frame.origin.x, CGRectGetMidY(slider.frame) - trackImageHeight/2.0,0, trackImageHeight)];
                }
            }else {
                float with = (slider.frame.size.width  - thumbImageWidth )*((slider.value - slider.minimumValue )/(slider.maximumValue - slider.minimumValue)) - slider.frame.size.width/2.0;
                if( with >= 0 )
                {
                    [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 + slider.frame.origin.x, CGRectGetMidY(slider.frame) - trackImageHeight/2.0, with, trackImageHeight)];
                }else {
                    [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 + slider.frame.origin.x, CGRectGetMidY(slider.frame) - trackImageHeight/2.0, 0, trackImageHeight)];
                }
            }
            slider.hidden = NO;
            trackView.hidden = NO;
        }else {
            slider.hidden = YES;
            trackView.hidden = YES;
        }
    }
    if( _currentBtn )
    {
        _currentBtn.selected =NO;
    }
    _currentType = sender.tag;
    sender.selected = YES;
    _currentBtn = sender;
    
    __block FaceAttribute *faceAttribute = nil;
    [_currentMedia.multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(_currentFaceRect, CGPointMake(obj.faceRect.origin.x + obj.faceRect.size.width / 2.0, obj.faceRect.origin.y + obj.faceRect.size.height / 2.0)) || CGRectEqualToRect(_currentFaceRect, obj.faceRect)) {
            faceAttribute = obj;
            *stop = YES;
        }
    }];
    
    float value =  0.0;
    switch (_currentType) {
        case 0://MARK: 脸型
        {
            if( faceAttribute )
            {
                value = faceAttribute.faceWidth;
            }
            [_adjustmentSliders[0] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[0]];
        }
            break;
        case 1://MARK: 下巴
        {
            if( faceAttribute )
            {
                value = faceAttribute.chinWidth;
            }
            [_adjustmentSliders[1] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[1]];
                
        }
            break;
        case 2://MARK: 下巴
        {
            if( faceAttribute )
            {
                value = faceAttribute.chinHeight;
            }
            [_adjustmentSliders[2] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[2]];
        }
            break;
        case 3://MARK: 眼宽
        {
            if( faceAttribute )
            {
                value = faceAttribute.eyeSlant;
            }
            [_adjustmentSliders[3] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[3]];
                
        }
            break;
        case 4://MARK: 眼睛
        {
            if( faceAttribute )
            {
                value = faceAttribute.eyeSlant;
            }
            [_adjustmentSliders[4] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[4]];
                
        }
            break;
        case 5://MARK: 倾斜
        {
            if( faceAttribute )
            {
                value = faceAttribute.eyeSlant;
            }
            [_adjustmentSliders[5] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[5]];
        }
            break;
        case 6://MARK: 眼距
        {
            if( faceAttribute )
            {
                value = faceAttribute.eyeDistance;
            }
            [_adjustmentSliders[6] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[6]];
        }
            break;
        case 7://MARK: 鼻宽
        {
            if( faceAttribute )
            {
                value = faceAttribute.noseWidth;
            }
            [_adjustmentSliders[7] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[7]];
        }
            break;
        case 8://MARK: 鼻高
        {
            
            if( faceAttribute )
            {
                value = faceAttribute.noseHeight;
            }
            [_adjustmentSliders[8] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[8]];
        }
            break;
            
        case 9://MARK: 嘴宽
        {
            
            if( faceAttribute )
            {
                value = faceAttribute.mouthWidth;
            }
            [_adjustmentSliders[9] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[9]];
        }
            break;
            
        case 10://MARK: 上嘴唇
        {
            
            if( faceAttribute )
            {
                value = faceAttribute.lipUpper;
            }
            [_adjustmentSliders[10] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[10]];
        }
            break;
            
        case 11://MARK: 下嘴唇
        {
            
            if( faceAttribute )
            {
                value = faceAttribute.lipLower;
            }
            [_adjustmentSliders[10] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[11]];
        }
            break;
       
        case 12://MARK: 微笑
        {
            if( faceAttribute )
            {
                value = faceAttribute.smile;
            }
            [_adjustmentSliders[0] setValue:value];
            [self sliderValueChanged:_adjustmentSliders[12]];
        }
            break;
        default:
            break;
    }
}

//-(void)toolBar_Btn:(UIButton *) sender
//{
//
//    if( _currentBtn )
//    {
//        _currentBtn.selected =NO;
//    }
//    _currentType = sender.tag;
//
//    sender.selected = YES;
//
//    _currentBtn = sender;
//
//    [self.adjustmentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.hidden = YES;
//    }];
//    __block FaceAttribute *faceAttribute = nil;
//    [_currentMedia.multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (CGRectContainsPoint(_currentFaceRect, CGPointMake(obj.faceRect.origin.x + obj.faceRect.size.width / 2.0, obj.faceRect.origin.y + obj.faceRect.size.height / 2.0)) || CGRectEqualToRect(_currentFaceRect, obj.faceRect)) {
//            faceAttribute = obj;
//            *stop = YES;
//        }
//    }];
//
//    float value =  0.5;
//    switch (_currentType) {
//        case 0://MARK: 脸型
//        {
//                self.adjustmentViews[0].hidden = NO;
//                CGRect rect = self.adjustmentViews[0].frame;
//                rect.origin.y = (_adjHeight*2.0 - 35)/2.0 + 44;
//                self.adjustmentViews[0].frame = rect;
//                if( faceAttribute )
//                {
//                    value = faceAttribute.faceWidth;
//                }
//                [_adjustmentSliders[0] setValue:value];
//                self.adjustmentSliders[0].tag = KBeauty_FaceWidth;
//                _adjustmentNumberLabels[0].text = VELocalizedString(@"脸宽", nil);
//        }
//            break;
//        case 1://MARK: 下巴
//        {
//                self.adjustmentViews[0].hidden = NO;
//                CGRect rect = self.adjustmentViews[0].frame;
//                rect.origin.y = (_adjHeight - 35)/2.0 + 44;
//                self.adjustmentViews[0].frame = rect;
//                if( faceAttribute )
//                {
//                    value = faceAttribute.chinWidth;
//                }
//                [_adjustmentSliders[0] setValue:value];
//                self.adjustmentSliders[0].tag = KBeauty_ChinWidth;
//                _adjustmentNumberLabels[0].text = VELocalizedString(@"下颚宽", nil);
//
//                self.adjustmentViews[3].hidden = NO;
//                if( faceAttribute )
//                {
//                    value = faceAttribute.chinHeight;
//                }
//                [_adjustmentSliders[3] setValue:value];
//                _adjustmentSliders[3].tag = KBeauty_ChinHeight;
//                _adjustmentNumberLabels[3].text = VELocalizedString(@"下巴高", nil);
//        }
//            break;
//        case 2://MARK: 额头
//        {
//                self.adjustmentViews[0].hidden = NO;
//                CGRect rect = self.adjustmentViews[0].frame;
//                rect.origin.y = (_adjHeight*2.0 - 35)/2.0 + 44;
//                self.adjustmentViews[0].frame = rect;
//                if( faceAttribute )
//                {
//                    value = faceAttribute.forehead;
//                }
//                [_adjustmentSliders[0] setValue:value];
//                _adjustmentNumberLabels[0].text = VELocalizedString(@"额头高", nil);
//                _adjustmentSliders[0].tag =  KBeauty_Forehead;
//        }
//            break;
//        case 3://MARK: 微笑
//        {
//                self.adjustmentViews[0].hidden = NO;
//                CGRect rect = self.adjustmentViews[0].frame;
//                rect.origin.x = 0;
//                rect.origin.y = (_adjHeight*2.0 - 35)/2.0 + 44;
//                self.adjustmentViews[0].frame = rect;
//                if( faceAttribute )
//                {
//                    value = faceAttribute.smile;
//                }
//                [_adjustmentSliders[0] setValue:value];
//                _adjustmentNumberLabels[0].text = VELocalizedString(@"微笑", nil);
//                _adjustmentSliders[0].tag = KBeauty_Smile;
//        }
//            break;
//        case 4://MARK: 眼睛
//        {
//                {
//                    self.adjustmentViews[1].hidden = NO;
//                    if( faceAttribute )
//                    {
//                        value = faceAttribute.eyeSlant;
//                    }
//                    [_adjustmentSliders[1] setValue:value];
//                    _adjustmentNumberLabels[1].text = VELocalizedString(@"倾斜", nil);
//                    _adjustmentSliders[1].tag = KBeauty_EyeSlant;
//                }
//
//                {
//                    self.adjustmentViews[2].hidden = NO;
//                    if( faceAttribute )
//                    {
//                        value = faceAttribute.eyeDistance;
//                    }
//                    [_adjustmentSliders[2] setValue:value];
//                    _adjustmentNumberLabels[2].text = VELocalizedString(@"距离", nil);
//                    _adjustmentSliders[2].tag = KBeauty_EyeDistance;
//                }
//
//                {
//                    self.adjustmentViews[3].hidden = NO;
//                    if( faceAttribute )
//                    {
//                        value = faceAttribute.eyeWidth;
//                    }
//                    [_adjustmentSliders[3] setValue:value];
//                    _adjustmentNumberLabels[3].text = VELocalizedString(@"大小", nil);
//                    _adjustmentSliders[3].tag = KBeauty_EyeSize;
//                }
//        }
//            break;
//        case 5://MARK: 嘴唇
//        {
//                {
//                    self.adjustmentViews[1].hidden = NO;
//                    if( faceAttribute )
//                    {
//                        value = faceAttribute.lipUpper;
//                    }
//                    [_adjustmentSliders[1] setValue:value];
//                    _adjustmentNumberLabels[1].text = VELocalizedString(@"上嘴唇", nil);
//                    _adjustmentSliders[1].tag = KBeauty_LipUpper;
//                }
//
//                {
//                    self.adjustmentViews[2].hidden = NO;
//                    if( faceAttribute )
//                    {
//                        value = faceAttribute.lipLower;
//                    }
//                    [_adjustmentSliders[2] setValue:value];
//                    _adjustmentNumberLabels[2].text = VELocalizedString(@"下嘴唇", nil);
//                    _adjustmentSliders[2].tag = KBeauty_LipLower;
//                }
//
//                {
//                    self.adjustmentViews[3].hidden = NO;
//                    if( faceAttribute )
//                    {
//                        value = faceAttribute.mouthWidth;
//                    }
//                    [_adjustmentSliders[3] setValue:value];
//                    _adjustmentNumberLabels[3].text = VELocalizedString(@"嘴巴宽", nil);
//                    _adjustmentSliders[3].tag = KBeauty_MouthWidth;
//                }
//        }
//            break;
//        case 6://MARK: 鼻子
//        {
//                self.adjustmentViews[0].hidden = NO;
//                CGRect rect = self.adjustmentViews[0].frame;
//                rect.origin.y = (_adjHeight*2.0 - 35)/2.0 + 44;
//                self.adjustmentViews[0].frame = rect;
//                if( faceAttribute )
//                {
//                    value = faceAttribute.noseWidth;
//                }
//                [_adjustmentSliders[0] setValue:value];
//                _adjustmentNumberLabels[0].text = VELocalizedString(@"大小", nil);
//                _adjustmentSliders[0].tag = KBeauty_NoseSize;
//        }
//            break;
//        default:
//            break;
//    }
//}

-(void)close_Btn:(UIButton *) sender
{
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesCancelEdit:)] )
    {
        [_delegate fiveSensesCancelEdit:self];
    }
}

-(void)return_Btn:(UIButton *) sender
{
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesEditCompletion:)] )
    {
        [_delegate fiveSensesEditCompletion:self];
    }
}

#pragma mark-滑动进度条
- (void)beginScrub:(VEPlaySlider *)slider{
    [self sliderValueChanged:slider];
    _sliderValueLabel.hidden = NO;
}

- (void)scrub:(VEPlaySlider *)slider{
    NSLog(@"%d,%f",slider.tag,slider.value);
    [self sliderValueChanged:slider];
}

- (void)endScrub:(VEPlaySlider *)slider{
    if([VEConfigManager sharedManager].iPad_HD){
        _currentType = slider.tag;
    }
    [self sliderValueChanged:slider];
    _sliderValueLabel.hidden = YES;
}

-(void)sliderValueChanged:(VEPlaySlider *) slider
{
    float trackImageHeight = slider.currentMinimumTrackImage.size.height;
    float thumbImageWidth = slider.currentThumbImage.size.width;
    UIView *trackView = [slider.superview viewWithTag:100 + slider.tag];
    if([VEConfigManager sharedManager].iPad_HD){
        trackView = [slider.superview viewWithTag:100];
    }
    if( slider.value < slider.maximumValue /2.0)
    {
        float with = slider.frame.size.width/2.0 - (slider.frame.size.width  - thumbImageWidth )*( (slider.value - slider.minimumValue )/(slider.maximumValue - slider.minimumValue))  - thumbImageWidth  ;
        if( with >= 0 )
        {
            [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 - with + slider.frame.origin.x, CGRectGetMidY(slider.frame) - trackImageHeight/2.0, with, trackImageHeight) ];
        }else {
            [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 - with+ slider.frame.origin.x, CGRectGetMidY(slider.frame) - trackImageHeight/2.0,0, trackImageHeight)];
        }
    }else {
        float with = (slider.frame.size.width  - thumbImageWidth )*((slider.value - slider.minimumValue )/(slider.maximumValue - slider.minimumValue)) - slider.frame.size.width/2.0;
        if( with >= 0 )
        {
            [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 + slider.frame.origin.x, CGRectGetMidY(slider.frame) - trackImageHeight/2.0, with, trackImageHeight)];
        }else {
            [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 + slider.frame.origin.x, CGRectGetMidY(slider.frame) - trackImageHeight/2.0, 0, trackImageHeight)];
        }
    }
    if([VEConfigManager sharedManager].iPad_HD){
        if(slider.tag == KBeauty_BlurIntensity){
            _currentMedia.beautyBlurIntensity = slider.value;
        }else if(slider.tag == KBeauty_BrightIntensity){
            _currentMedia.beautyBrightIntensity = slider.value;
        }else if(slider.tag == KBeauty_ToneIntensity){
            _currentMedia.beautyToneIntensity = slider.value;
        }else if(slider.tag == KBeauty_BigEyes){
            _currentMedia.beautyBigEyeIntensity = slider.value;
        }else if(slider.tag == KBeauty_FaceLift){
            _currentMedia.beautyThinFaceIntensity = slider.value;
        }
        ((UILabel *)[slider.superview viewWithTag:200]).text = [NSString stringWithFormat:@"%.f",(slider.value * 100)];
    }else{
        CGRect frame = _sliderValueLabel.frame;
        frame.origin.x =  slider.thumbRect.origin.x + slider.frame.origin.x - (30 - slider.thumbRect.size.width)/2.0;
        _sliderValueLabel.frame = frame;
        _sliderValueLabel.text = [NSString stringWithFormat:@"%.f",(slider.value * 100)];
    }
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSenses_ValueChanged:atVIew:)] )
    {
        [_delegate fiveSenses_ValueChanged:slider atVIew:self];
    }
}

-(void)resetAdjustment_Btn:( UIButton * ) sender
{
#if 0
    if(![VEConfigManager sharedManager].iPad_HD || _currentType < KBeauty_BlurIntensity){
        [self setDefaultValue];
    }
#else   //20220721 重置/对比是恢复原始状态
    _currentMedia.beautyBlurIntensity = 0.0;
    _currentMedia.beautyBrightIntensity = 0.0;
    _currentMedia.beautyToneIntensity = 0.0;
    _currentMedia.beautyBigEyeIntensity = 0.0;
    _currentMedia.beautyThinFaceIntensity = 0.0;
    [_currentMedia.multipleFaceAttribute removeAllObjects];
    
    NSInteger index = 5;
    if([VEConfigManager sharedManager].iPad_HD){
        index = 0;
        _adjustmentSliders[0].value = 0;
        _adjustmentSliders[1].value = 0;
        _adjustmentSliders[2].value = 0;
        _adjustmentSliders[3].value = 0;
        _adjustmentSliders[4].value = 0;
    }
    
    float defaultValue = 0.0;
    _adjustmentSliders[5 - index].value = defaultValue;
    
    _adjustmentSliders[6 - index].value = defaultValue;
    _adjustmentSliders[7 - index].value = defaultValue;
    
    _adjustmentSliders[8 - index].value = defaultValue;
    _adjustmentSliders[9 - index].value = defaultValue;
    _adjustmentSliders[10 - index].value = defaultValue;
    _adjustmentSliders[11 - index].value = defaultValue;
    
    _adjustmentSliders[12 - index].value = defaultValue;
    _adjustmentSliders[13 - index].value = defaultValue;
    
    _adjustmentSliders[14 - index].value = defaultValue;
    _adjustmentSliders[15 - index].value = defaultValue;
    _adjustmentSliders[16 - index].value = defaultValue;
    
    _adjustmentSliders[17 - index].value = defaultValue;
    
    [_adjustmentSliders enumerateObjectsUsingBlock:^(UISlider * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self sliderValueChanged:obj];
    }];
#endif
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSenses_Reset:atVIew:)] )
    {
        [_delegate fiveSenses_Reset:_currentType atVIew:self];
    }
}

- (void)compareBtnDown:(UIButton *)sender {
    _sliderValueLabel.hidden = YES;
    _editMedia = [_currentMedia copy];
#if 0
    float value =  sender.tag > KBeauty_Smile ? 0 : 0.5;
    {
        for (int i = 0;i<_adjustmentSliders.count;i++) {
            if(_adjustmentSliders[i].tag == _currentType){
                [_adjustmentSliders[i] setValue:value];
                break;
            }
        }
    }
#endif
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesCompare:atVIew:)] )
    {
        [_delegate fiveSensesCompare:_currentType atVIew:self];
    }
}

- (void)compareBtnUp:(UIButton *)sender {
#if 0
    __block FaceAttribute *faceAttribute = nil;
    [_editMedia.multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(_currentFaceRect, CGPointMake(obj.faceRect.origin.x + obj.faceRect.size.width / 2.0, obj.faceRect.origin.y + obj.faceRect.size.height / 2.0)) || CGRectEqualToRect(_currentFaceRect, obj.faceRect)) {
            faceAttribute = obj;
            *stop = YES;
        }
    }];
    float value =  _currentType > KBeauty_Smile ? 0.0 : 0.5;
    //if([VEConfigManager sharedManager].iPad_HD)
    {
        switch (_currentType) {
            case KBeauty_FaceWidth://MARK:  脸宽
            {
                if( faceAttribute )
                {
                    value = faceAttribute.faceWidth;
                }
            }
                break;
            case KBeauty_Forehead://MARK: 额高
            {
                if( faceAttribute )
                {
                    value = faceAttribute.forehead;
                }
            }
                break;
            case KBeauty_ChinWidth://MARK: 下颚宽
            {
                if( faceAttribute )
                {
                    value = faceAttribute.chinWidth;
                }
            }
                break;
            case KBeauty_ChinHeight://MARK: 下巴高
            {
                if( faceAttribute )
                {
                    value = faceAttribute.chinHeight;
                }
            }
                break;
            case KBeauty_EyeWidth://MARK: 眼睛宽
            {
                if( faceAttribute )
                {
                    value = faceAttribute.eyeWidth;
                }
            }
                break;
            case KBeauty_EyeHeight://MARK: 眼睛高
            {
                if( faceAttribute )
                {
                    value = faceAttribute.eyeHeight;
                }
            }
                break;
            case KBeauty_EyeSlant://MARK: 眼睛高
            {
                if( faceAttribute )
                {
                    value = faceAttribute.eyeSlant;
                }
            }
                break;
            case KBeauty_EyeDistance://MARK: 眼睛大小
            {
                if( faceAttribute )
                {
                    value = faceAttribute.eyeDistance;
                }
            }
                break;
            case KBeauty_NoseWidth://MARK: 鼻子宽
            {
                if( faceAttribute )
                {
                    value = faceAttribute.noseWidth;
                }
            }
                break;
            case KBeauty_NoseHeight://MARK: 鼻子高
            {
                if( faceAttribute )
                {
                    value = faceAttribute.noseHeight;
                }
            }
                break;
            case KBeauty_MouthWidth://MARK: 嘴宽
            {
                if( faceAttribute )
                {
                    value = faceAttribute.mouthWidth;
                }
            }
                break;
            case KBeauty_LipUpper://MARK: 上嘴唇
            {
                if( faceAttribute )
                {
                    value = faceAttribute.lipUpper;
                }
            }
                break;
            case KBeauty_LipLower://MARK: 下嘴唇
            {
                if( faceAttribute )
                {
                    value = faceAttribute.lipLower;
                }
            }
                break;
            case KBeauty_Smile://MARK: 微笑
            {
                if( faceAttribute )
                {
                    value = faceAttribute.smile;
                }
            }
                break;
            case KBeauty_BlurIntensity://MARK: 磨皮
            {
                value = _editMedia.beautyBlurIntensity;
            }
                break;
            case KBeauty_BrightIntensity://MARK: 亮肤
            {
                value = _editMedia.beautyBrightIntensity;
            }
                break;
            case KBeauty_ToneIntensity://MARK: 红润
            {
                value = _editMedia.beautyToneIntensity;
            }
                break;//
            case KBeauty_BigEyes://MARK: 红润
            {
                value = _editMedia.beautyBigEyeIntensity;
            }
                break;//KBeauty_BigEyes
            case KBeauty_FaceLift://MARK: 瘦脸
            {
                value = _editMedia.beautyThinFaceIntensity;
            }
                break;//
            default:
                break;
        }
        for (int i = 0;i<_adjustmentSliders.count;i++) {
            if(_adjustmentSliders[i].tag == _currentType){
                [_adjustmentSliders[i] setValue:value];
                break;
            }
        }
        
    }
#else
    __block FaceAttribute *faceAttribute = nil;
    [_editMedia.multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_currentMedia.multipleFaceAttribute addObject:obj];
        if (CGRectContainsPoint(_currentFaceRect, CGPointMake(obj.faceRect.origin.x + obj.faceRect.size.width / 2.0, obj.faceRect.origin.y + obj.faceRect.size.height / 2.0)) || CGRectEqualToRect(_currentFaceRect, obj.faceRect)) {
            faceAttribute = obj;
        }
    }];
    _currentMedia.beautyBlurIntensity = _editMedia.beautyBlurIntensity;
    _currentMedia.beautyToneIntensity = _editMedia.beautyToneIntensity;
    _currentMedia.beautyBrightIntensity = _editMedia.beautyBrightIntensity;
    {
        NSInteger index = 5;
        if([VEConfigManager sharedManager].iPad_HD){
            index = 0;
            _adjustmentSliders[0].value = _editMedia.beautyBlurIntensity;
            _adjustmentSliders[1].value = _editMedia.beautyBrightIntensity;
            _adjustmentSliders[2].value = _editMedia.beautyToneIntensity;
            _adjustmentSliders[3].value = _editMedia.beautyBigEyeIntensity;
            _adjustmentSliders[4].value = _editMedia.beautyThinFaceIntensity;
        }
        
        float defaultValue = 0.0;
        _adjustmentSliders[5 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.faceWidth;
        
        _adjustmentSliders[6 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.chinWidth;
        _adjustmentSliders[7 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.chinHeight;
        
        _adjustmentSliders[8 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeWidth;
        _adjustmentSliders[9 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeHeight;
        _adjustmentSliders[10 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeSlant;
        _adjustmentSliders[11 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeDistance;
        
        _adjustmentSliders[12 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.noseWidth;
        _adjustmentSliders[13 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.noseHeight;
        
        _adjustmentSliders[14 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.mouthWidth;
        _adjustmentSliders[15 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.lipUpper;
        _adjustmentSliders[16 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.lipLower;
        
        _adjustmentSliders[17 - index].value = faceAttribute == nil ? defaultValue : faceAttribute.smile;
        
        [_adjustmentSliders enumerateObjectsUsingBlock:^(UISlider * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self sliderValueChanged:obj];
        }];
    }
#endif
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesCompareCompletion:atVIew:)] )
    {
        [_delegate fiveSensesCompareCompletion:_currentType atVIew:self];
    }
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(![VEConfigManager sharedManager].iPad_HD){
        return;
    }
    NSInteger tag = 0;
    if(scrollView.contentOffset.y < 50 * 5){
        //MARK: 瘦脸
        tag = 7;
    }else if(scrollView.contentOffset.y < 50 * 6){
        //MARK: 脸型
        tag = 0;
    }else if(scrollView.contentOffset.y < 50 * 7){
        //MARK: 额头
        tag = 1;
    }else if(scrollView.contentOffset.y < 50 * 9){
        //MARK:下巴
        tag = 2;
    }else if(scrollView.contentOffset.y < 50 * 13){
        //MARK: 眼睛
        tag = 3;
    }else if(scrollView.contentOffset.y < 50 * 15){
        //MARK: 鼻子
        tag = 4;
    }else if(scrollView.contentOffset.y < 50 * 18){
        //MARK: 嘴唇
        tag = 5;
    }else{
        tag = 6;
    }
    
    [self.ribbonScrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIButton class]]){
            obj.selected = (obj.tag == tag);
        }
    }];
    
    
}
@end
