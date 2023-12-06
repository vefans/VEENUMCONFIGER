//
//  VEFiveCameraView.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/7/28.
//

#import "VEFiveCameraView.h"
#import <VEENUMCONFIGER/VEHelp.h>
#import <VEENUMCONFIGER/VESlider.h>

@interface VEFiveCameraView()<UIScrollViewDelegate>

/** VECore美颜  美白参数 0.0 - 1.0 默认 0.3
 */
@property (nonatomic, assign) float brightness;
/** VECore美颜  磨皮参数 0.0 - 1.0 默认0.6
 */
@property (nonatomic, assign) float blur;

/** VECore美颜  红润参数0.0~1.0,默认为0.0
 */
@property (nonatomic, assign) float beautyToneIntensity;

/** VECore大眼  大眼参数0.0~1.0,默认为0.3
    只支持iOS11.0以上
 */
@property (nonatomic, assign) float beautyBigEye;

/** VECore廋脸  廋脸参数0.0~1.0,默认为0.5
    只支持iOS11.0以上
 */
@property (nonatomic, assign) float beautyThinFace;

@property (nonatomic, strong)  FaceAttribute* faceAttribute;

@end

@implementation VEFiveCameraView

-(FaceAttribute *) getFaceAttribute
{
    return _faceAttribute;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
    {
        self.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : VIEW_COLOR;
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            self.backgroundColor = [VEConfigManager sharedManager].viewBackgroundColor;
        }
        // 左上和右上为圆角
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(16, 16)];
        CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ]  init];
        cornerRadiusLayer.frame = self.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        self.layer.mask = cornerRadiusLayer;
        [self initToolbarView];
        
        _blur = 0.6;
        _brightness = 0.3;
        _beautyThinFace = 0.5;
        _beautyBigEye = 0.3;
        
        _adjustmentSliders = [NSMutableArray new];
        _adjustmentNumberLabels = [NSMutableArray new];
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
                            
                            @{@"title":@"脸型",@"id":@(KBeauty_FaceWidth)},
                            @{@"title":@"下颔",@"id":@(KBeauty_ChinWidth)},
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
                [self initAdjView:CGRectMake(20, 50 * i, self.frame.size.width - 40, 50) atStr:list[i][@"title"]];
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
        }else{
            _beautyView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - 44 - kBottomSafeHeight - 60) / 2.0, CGRectGetWidth(self.frame), 60)];
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
            UIView *sliderSupView = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - 44) - (iPhone_X ? 34 : 0), CGRectGetWidth(self.frame), 44)];
            sliderSupView.backgroundColor = [UIColor clearColor];
            [self addSubview:sliderSupView];
            _adjustmentSliders = [NSMutableArray new];
            for (int i = 0; i<list.count; i++) {
                
                NSString *title = [list[i] objectForKey:@"title"];
                
                float ItemBtnWidth = [VEHelp widthForString:VELocalizedString(title, nil) andHeight:14 fontSize:12] ;
                ItemBtnWidth = MAX(ItemBtnWidth, 44);
                UIButton *toolItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_beautyView addSubview:toolItemBtn];
                toolItemBtn.frame = CGRectMake(contentsWidth, (_beautyView.frame.size.height - 60)/2.0, ItemBtnWidth, 60);
                toolItemBtn.tag = [[list[i] objectForKey:@"id"] integerValue];
                
                [toolItemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/%@默认",title]] forState:UIControlStateNormal];
                [toolItemBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/%@选中",title]] forState:UIControlStateSelected];
                [toolItemBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
                [toolItemBtn setTitleColor:Main_Color forState:UIControlStateSelected];
                if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                    [toolItemBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
                }
                [toolItemBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (ItemBtnWidth - 40)/2.0, 20, (ItemBtnWidth - 40)/2.0)];
                [toolItemBtn setTitleEdgeInsets:UIEdgeInsetsMake(40, -40, 0, 0)];
                
                
                [toolItemBtn setTitle:VELocalizedString(title, nil) forState:UIControlStateNormal];
                toolItemBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                toolItemBtn.titleLabel.font = [UIFont systemFontOfSize:10];
                
                [toolItemBtn addTarget:self action:@selector(toolBar_Btn:) forControlEvents:UIControlEventTouchUpInside];
                contentsWidth += ItemBtnWidth+25;
                                
                
                VESlider * slider = [[VESlider alloc] initWithFrame:CGRectMake(90, (CGRectGetHeight(sliderSupView.frame) - 35)/2.0,sliderSupView.frame.size.width - 100 - 44 - 30 , 35)];
                slider.tag = [list[i][@"id"] integerValue];
                UIImage *trackImage = [VEHelp imageWithColor:SliderMaximumTrackTintColor size:CGSizeMake(10, 2.0) cornerRadius:1];
                if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                    trackImage = [VEHelp imageWithColor:UIColorFromRGB(0xcccfd6) size:CGSizeMake(10, 2.0) cornerRadius:1];
                }
                [slider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
                [slider setMinimumValue:-1.0];
                [slider setMaximumValue:1.0];
                [slider setValue:0];
                slider.hidden = YES;
                [slider addTarget:self action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
                [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
                [slider addTarget:self action:@selector(endScrub:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
                [sliderSupView addSubview:slider];
                [_adjustmentSliders addObject:slider];
                         
                UIView *trackView = [[UIView alloc] initWithFrame:CGRectMake(slider.frame.size.width/2.0 ,CGRectGetMidY(slider.frame)-1, 0, 2)];
                trackView.backgroundColor = SliderMinimumTrackTintColor;
                if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                    trackView.backgroundColor = UIColorFromRGB(0x131313);
                }
                trackView.tag = 100 + slider.tag;
                trackView.hidden = YES;
                [sliderSupView addSubview:trackView];
                
                if( i == 0 )
                {
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.origin.x + (slider.frame.size.width - 30)/2.0, -10, 30, 15)];
                    label.text  = @"0";
                    label.textColor = [UIColor whiteColor];
                    if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                        label.textColor = UIColorFromRGB(0x131313);
                    }
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
        compareBtn.frame = CGRectMake(self.frame.size.width - (44 + 15), (CGRectGetHeight(self.frame) - 44) - (iPhone_X ? 34 : 0), 44, 44);
        [compareBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/skin/%@默认",@"对比"]] forState:UIControlStateNormal];
        [compareBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/skin/%@选中",@"对比"]] forState:UIControlStateSelected];
        [compareBtn addTarget:self action:@selector(compareBtnDown:) forControlEvents:UIControlEventTouchDown];
        [compareBtn addTarget:self action:@selector(compareBtnUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:compareBtn];
        
        UIButton * resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, compareBtn.frame.origin.y, 80, 44)];
        [resetBtn setImage:[VEHelp imageNamed:@"VirtualLive/美颜重置默认@3x"] forState:UIControlStateNormal];
        [resetBtn setImage:[VEHelp imageNamed:@"VirtualLive/美颜重置选中@3x"] forState:UIControlStateHighlighted];
        [resetBtn setTitle:VELocalizedString(@"重置", nil) forState:UIControlStateNormal];
        [resetBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
        [resetBtn setTitleColor:Main_Color forState:UIControlStateHighlighted];
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [resetBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
            [resetBtn setTitleColor:Main_Color forState:UIControlStateHighlighted];
        }
        resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        resetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [resetBtn addTarget:self action:@selector(resetAdjustment_Btn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resetBtn];
        
        _faceAttribute = [FaceAttribute new];
    }
    return self;
}

- (void)setDefaultValue{
    FaceAttribute *faceAttribute = _faceAttribute;
    {
        float defaultValue = 0.0;
        _adjustmentSliders[0].value = _blur;
        _adjustmentSliders[1].value = _brightness;
        _adjustmentSliders[2].value = _beautyToneIntensity;
        _adjustmentSliders[3].value = _beautyBigEye;
        _adjustmentSliders[4].value = _beautyThinFace;
        
        _adjustmentSliders[5].value = faceAttribute == nil ? defaultValue : faceAttribute.faceWidth;
        
        _adjustmentSliders[6].value = faceAttribute == nil ? defaultValue : faceAttribute.chinWidth;
        _adjustmentSliders[7].value = faceAttribute == nil ? defaultValue : faceAttribute.chinHeight;
        
        _adjustmentSliders[8].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeWidth;
        _adjustmentSliders[9].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeHeight;
        _adjustmentSliders[10].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeSlant;
        _adjustmentSliders[11].value = faceAttribute == nil ? defaultValue : faceAttribute.eyeDistance;
        
        _adjustmentSliders[12].value = faceAttribute == nil ? defaultValue : faceAttribute.noseWidth;
        _adjustmentSliders[13].value = faceAttribute == nil ? defaultValue : faceAttribute.noseHeight;
        
        _adjustmentSliders[14].value = faceAttribute == nil ? defaultValue : faceAttribute.mouthWidth;
        _adjustmentSliders[15].value = faceAttribute == nil ? defaultValue : faceAttribute.lipUpper;
        _adjustmentSliders[16].value = faceAttribute == nil ? defaultValue : faceAttribute.lipLower;
        
        _adjustmentSliders[17].value = faceAttribute == nil ? defaultValue : faceAttribute.smile;
        
        [_adjustmentSliders enumerateObjectsUsingBlock:^(UISlider * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ((UILabel *)[obj.superview viewWithTag:200 + obj.tag]).text = [NSString stringWithFormat:@"%.f",(obj.value * 100)];
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
    
    
    VESlider * slider = [[VESlider alloc] initWithFrame:CGRectMake(50, (CGRectGetHeight(rect) - 35)/2.0,view.frame.size.width - ([VEConfigManager sharedManager].iPad_HD ? 90 : 50) , 35)];
        [slider setMinimumValue:-1.0];
        [slider setMaximumValue:1.0];
        [slider setValue:0];

        [slider addTarget:self action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
        [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(endScrub:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside)];
       [_adjustmentSliders addObject:slider];
           [view addSubview:slider];
        
        UIView *trackView = [[UIView alloc] initWithFrame:CGRectMake(slider.frame.size.width/2.0 ,CGRectGetMidY(slider.frame), 0, 1)];
        trackView.backgroundColor = SliderMinimumTrackTintColor;
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            trackView.backgroundColor = UIColorFromRGB(0xefefef);
        }
        trackView.tag = 100 + slider.tag;
        [view addSubview:trackView];
       
   
       {
           UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, CGRectGetHeight(rect))];
           label.text  = VELocalizedString(str, nil);
           label.font = [UIFont systemFontOfSize:12];
           label.textAlignment = NSTextAlignmentCenter;
           label.textColor = TEXT_COLOR;
           if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
               label.textColor = UIColorFromRGB(0x131313);
           }
           [_adjustmentNumberLabels addObject:label];
           [view addSubview:label];
       }
        if([VEConfigManager sharedManager].iPad_HD){
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 40, 0, 40, CGRectGetHeight(rect))];
            label.text  = @"0";
            label.tag = 200 + slider.tag;
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = TEXT_COLOR;
            [view addSubview:label];
        }
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
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 44)];
    _toolbarView = view;
    [self addSubview:view];
    
    
    if(![VEConfigManager sharedManager].iPad_HD){
        _toolbarView.frame = CGRectMake(0, 0,self.frame.size.width, 0);
    }
    
    {
        
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(44, 0, self.frame.size.width - 88, 44)];
        if([VEConfigManager sharedManager].iPad_HD){
            scrollView.frame = CGRectMake(10, 0, self.frame.size.width - 20, 44);
        }
        [_toolbarView addSubview:scrollView];
        _ribbonScrollView = scrollView;
        
        if([VEConfigManager sharedManager].iPad_HD){
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.5, self.frame.size.width, 1.0/[UIScreen mainScreen].scale)];
            imageView.backgroundColor = UIColorFromRGB(0x2a2a2a);
            [_toolbarView addSubview:imageView];
            
            [self createIpadUIRibbonScroll];
        }
    }
}
-(void)createIpadUIRibbonScroll
{
    NSMutableArray * toolItems = [NSMutableArray new];
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"瘦脸",@"title",@(7),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"脸型",@"title",@(0),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"额头",@"title",@(1),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"下巴",@"title",@(2),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"眼睛",@"title",@(3),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"鼻子",@"title",@(4),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"嘴唇",@"title",@(5),@"id", nil];
        [toolItems addObject:dic1];
    }
    {
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"微笑",@"title",@(6),@"id", nil];
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
        if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
            [toolItemBtn setTitleColor:UIColorFromRGB(0x131313) forState:UIControlStateNormal];
        }
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

-(void)ipad_toolBar_Btn:(UIButton *) sender{
    if( _currentBtn )
    {
        _currentBtn.selected =NO;
    }
    sender.selected = YES;
    
    _currentBtn = sender;
    
    switch (sender.tag) {
        case 0://MARK: 脸型
        {
            [_beautyView setContentOffset:CGPointMake(0, 50 * 5)];
        }
            break;
        case 1://MARK: 额头
        {
            [_beautyView setContentOffset:CGPointMake(0, 50 * 6)];
        }
            break;
        case 2://MARK:下巴
        {
            [_beautyView setContentOffset:CGPointMake(0, 50 * 7)];
        }
            break;
        case 3://MARK: 眼睛
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 9)];
        }
            break;
        case 4://MARK: 鼻子
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 13)];
        }
            break;
        case 5://MARK: 嘴唇
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 15)];
        }
            break;
        case 6://MARK: 微笑
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 18)];
        }
            break;
        case 7://MARK: 瘦脸
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 0)];
        }
            break;
        default:
            break;
    }
}
-(void)toolBar_Btn:(UIButton *) sender
{
    for (VESlider * slider in _adjustmentSliders) {
        slider.hidden = (slider.tag != sender.tag);
        UIView *trackView = [slider.superview viewWithTag:100 + slider.tag];
        if(slider.tag == sender.tag){
            CGRect frame = _sliderValueLabel.frame;
            frame.origin.x =  slider.thumbRect.origin.x + slider.frame.origin.x - (30 - slider.thumbRect.size.width)/2.0;
            _sliderValueLabel.frame = frame;
            _sliderValueLabel.text = [NSString stringWithFormat:@"%.f",(slider.value * 100)];
            
            float trackImageHeight = slider.currentMinimumTrackImage.size.height;
            float thumbImageWidth = slider.currentThumbImage.size.width;
            if( slider.value < 0)
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
    
    if ([sender.superview isKindOfClass:[UIScrollView class]] && ![VEConfigManager sharedManager].iPad_HD) {
        UIScrollView *scrollView = (UIScrollView *)sender.superview;
        float margin = scrollView.frame.origin.x / 2.0;
        CGFloat offSetX = sender.center.x - scrollView.bounds.size.width * 0.5 + margin;
        CGFloat offsetX1 = (scrollView.contentSize.width - sender.center.x) - scrollView.bounds.size.width * 0.5;
        CGPoint offset = CGPointZero;
        if (offSetX > 0 && offsetX1 > 0) {
            offset = CGPointMake(offSetX, 0);
        }
        else if(offSetX < 0){
            offset = CGPointZero;
        }
        else if (offsetX1 < 0){
            offset = CGPointMake(scrollView.contentSize.width - scrollView.bounds.size.width, 0);
        }
        [scrollView setContentOffset:offset animated:YES];
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
- (void)beginScrub:(VESlider *)slider{
    [self sliderValueChanged:slider];
    _sliderValueLabel.hidden = NO;
}

- (void)scrub:(VESlider *)slider{
    NSLog(@"%d,%f",slider.tag,slider.value);
    [self sliderValueChanged:slider];
}

- (void)endScrub:(VESlider *)slider{
    if([VEConfigManager sharedManager].iPad_HD){
        _currentType = slider.tag;
    }
    [self sliderValueChanged:slider];
    _sliderValueLabel.hidden = YES;
}

-(void)sliderValueChanged:(VESlider *) slider
{
    float trackImageHeight = slider.currentMinimumTrackImage.size.height;
    float thumbImageWidth = slider.currentThumbImage.size.width;
    UIView *trackView = [slider.superview viewWithTag:100 + slider.tag];
    float y = CGRectGetMidY(slider.frame) - trackImageHeight/2.0 + 0.5;
    if( slider.value < 0)
    {
        float with = slider.frame.size.width/2.0 - (slider.frame.size.width  - thumbImageWidth )*( (slider.value - slider.minimumValue )/(slider.maximumValue - slider.minimumValue))  - thumbImageWidth  ;
        if( with >= 0 )
        {
            [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 - with + (3 * slider.value) + slider.frame.origin.x, y, with - (3 * slider.value), trackImageHeight) ];
        }else {
            [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 - with + (3 * slider.value) + slider.frame.origin.x, y,0, trackImageHeight)];
        }
    }else {
        float with = (slider.frame.size.width  - thumbImageWidth )*((slider.value - slider.minimumValue )/(slider.maximumValue - slider.minimumValue)) - slider.frame.size.width/2.0;
        if( with >= 0 )
        {
            [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 + slider.frame.origin.x, y, with + (3 * slider.value), trackImageHeight)];
        }else {
            [trackView setFrame:CGRectMake( slider.frame.size.width/2.0 + slider.frame.origin.x, y, 0, trackImageHeight)];
        }
    }
    if([VEConfigManager sharedManager].iPad_HD){
        ((UILabel *)[slider.superview viewWithTag:200 + slider.tag]).text = [NSString stringWithFormat:@"%.f",(slider.value * 100)];
    }else{
        CGRect frame = _sliderValueLabel.frame;
        frame.origin.x =  slider.thumbRect.origin.x + slider.frame.origin.x - (30 - slider.thumbRect.size.width)/2.0;
        _sliderValueLabel.frame = frame;
        _sliderValueLabel.text = [NSString stringWithFormat:@"%.f",(slider.value * 100)];
    }
    switch (_currentType) {
        case KBeauty_FaceWidth://MARK:  脸宽
        {
            _faceAttribute.faceWidth = slider.value;
        }
            break;
        case KBeauty_ChinWidth://MARK: 下颚宽
        {
            _faceAttribute.chinWidth = slider.value;
        }
            break;
        case KBeauty_ChinHeight://MARK: 下巴高
        {
            _faceAttribute.chinHeight = slider.value;
        }
            break;
        case KBeauty_EyeWidth://MARK: 眼睛宽
        {
            _faceAttribute.eyeWidth = slider.value;
        }
            break;
        case KBeauty_EyeHeight://MARK: 眼睛高
        {
            _faceAttribute.eyeHeight = slider.value;
        }
            break;
        case KBeauty_EyeSlant://MARK: 眼睛高
        {
            _faceAttribute.eyeSlant = slider.value;
        }
            break;
        case KBeauty_EyeDistance://MARK: 眼睛距离
        {
            _faceAttribute.eyeDistance = slider.value;
        }
            break;
        case KBeauty_NoseWidth://MARK: 鼻子宽
        {
            _faceAttribute.noseWidth = slider.value;
        }
            break;
        case KBeauty_NoseHeight://MARK: 鼻子高
        {
            _faceAttribute.noseHeight = slider.value;
        }
            break;
        case KBeauty_MouthWidth://MARK: 嘴宽
        {
            _faceAttribute.mouthWidth = slider.value;
        }
            break;
        case KBeauty_LipUpper://MARK: 上嘴唇
        {
            _faceAttribute.lipUpper = slider.value;
        }
            break;
        case KBeauty_LipLower://MARK: 下嘴唇
        {
            _faceAttribute.lipLower = slider.value;
        }
            break;
        case KBeauty_Smile://MARK: 微笑
        {
            _faceAttribute.smile = slider.value;
        }
            break;
        case KBeauty_BlurIntensity://MARK: 磨皮
        {
            _blur = slider.value;
        }
            break;
        case KBeauty_BrightIntensity://MARK: 亮肤
        {
            _brightness = slider.value;
        }
            break;
        case KBeauty_ToneIntensity://MARK: 红润
        {
            _beautyToneIntensity = slider.value;
        }
            break;
        case KBeauty_BigEyes://MARK: 大眼
        {
            _beautyBigEye = slider.value;
        }
            break;
        case KBeauty_FaceLift://MARK: 瘦脸
        {
            _beautyThinFace = slider.value;
        }
            break;
        default:
            break;
    }
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSenses_ValueChanged:atVIew:)] )
    {
        [_delegate fiveSenses_ValueChanged:slider atVIew:self];
    }
}

-(void)resetAdjustment_Btn:( UIButton * ) sender
{
#if 0
    float value = 0.5;
    if([VEConfigManager sharedManager].iPad_HD){
        switch (_currentType) {
            case KBeauty_BlurIntensity://MARK: 磨皮
            {
                value = 0.6;
            }
                break;
            case KBeauty_BrightIntensity://MARK: 亮肤
            {
                value = 0.3;
            }
                break;
            case KBeauty_ToneIntensity://MARK: 红润
            {
                value = 0;
            }
                break;
            case KBeauty_BigEyes://MARK: 大眼
            {
                value = 0.3;
            }
                break;
            case KBeauty_FaceLift://MARK: 瘦脸
            {
                value = 0.5;
            }
                break;
            default:
                break;
        }
    }
    for (int i = 0;i<_adjustmentSliders.count;i++) {
        if(_adjustmentSliders[i].tag == _currentType){
            [_adjustmentSliders[i] setValue:value];
            break;
        }
    }
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSenses_Reset:value:)] )
    {
        [_delegate fiveSenses_Reset:_currentType value:value];
    }
#else
    _faceAttribute = [FaceAttribute new];
    for (int i = 0;i<_adjustmentSliders.count;i++) {
        VESlider *slider = (VESlider *)_adjustmentSliders[i];
        [slider setValue:0];
        
        if([VEConfigManager sharedManager].iPad_HD){
            ((UILabel *)[slider.superview viewWithTag:200 + slider.tag]).text = [NSString stringWithFormat:@"%.f",(slider.value * 100)];
        }else {
            if(slider.tag == _currentBtn.tag){
                UIView *trackView = [slider.superview viewWithTag:100 + slider.tag];
                CGRect frame = trackView.frame;
                frame.size.width = 0;
                trackView.frame = frame;
                
                frame = _sliderValueLabel.frame;
                frame.origin.x =  slider.frame.origin.x + (slider.frame.size.width - 30)/2.0;
                _sliderValueLabel.frame = frame;
                _sliderValueLabel.text = [NSString stringWithFormat:@"%.f",(slider.value * 100)];
            }
        }
    }
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesResetAll)] ) {
        [_delegate fiveSensesResetAll];
    }
#endif
}

- (void)compareBtnDown:(UIButton *)sender {
#if 0
    float value = 0.5;
    if([VEConfigManager sharedManager].iPad_HD){
        switch (_currentType) {
            case KBeauty_BlurIntensity://MARK: 磨皮
            {
                value = 0.6;
            }
                break;
            case KBeauty_BrightIntensity://MARK: 亮肤
            {
                value = 0.3;
            }
                break;
            case KBeauty_ToneIntensity://MARK: 红润
            {
                value = 0;
            }
                break;
            case KBeauty_BigEyes://MARK: 大眼
            {
                value = 0.3;
            }
                break;
            case KBeauty_FaceLift://MARK: 瘦脸
            {
                value = 0.5;
            }
                break;
            default:
                break;
        }
    }
    for (int i = 0;i<_adjustmentSliders.count;i++) {
        if(_adjustmentSliders[i].tag == _currentType){
            [_adjustmentSliders[i] setValue:value];
            break;
        }
    }
    
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesCompare:value:)] )
    {
        [_delegate fiveSensesCompare:_currentType value:value];
    }
#else
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesResetAll)] ) {
        [_delegate fiveSensesResetAll];
    }
#endif
}

- (void)compareBtnUp:(UIButton *)sender {
#if 0
    FaceAttribute *faceAttribute = _faceAttribute;
    float value =  _currentType > KBeauty_Smile ? 0.0 : 0.5;
    {
        switch (_currentType) {
            case KBeauty_FaceWidth://MARK:  脸宽
            {
                value = faceAttribute.faceWidth;
            }
                break;
            case KBeauty_ChinWidth://MARK: 下颚宽
            {
                value = faceAttribute.chinWidth;
            }
                break;
            case KBeauty_ChinHeight://MARK: 下巴高
            {
                value = faceAttribute.chinHeight;
            }
                break;
            case KBeauty_EyeWidth://MARK: 眼睛宽
            {
                value = faceAttribute.eyeWidth;
            }
                break;
            case KBeauty_EyeHeight://MARK: 眼睛高
            {
                value = faceAttribute.eyeHeight;
            }
                break;
            case KBeauty_EyeSlant://MARK: 眼睛高
            {
                value = faceAttribute.eyeSlant;
            }
                break;
            case KBeauty_EyeDistance://MARK: 眼睛距离
            {
                value = faceAttribute.eyeDistance;
            }
                break;
            case KBeauty_NoseWidth://MARK: 鼻子宽
            {
                value = faceAttribute.noseWidth;
            }
                break;
            case KBeauty_NoseHeight://MARK: 鼻子高
            {
                value = faceAttribute.noseHeight;
            }
                break;
            case KBeauty_MouthWidth://MARK: 嘴宽
            {
                value = faceAttribute.mouthWidth;
            }
                break;
            case KBeauty_LipUpper://MARK: 上嘴唇
            {
                value = faceAttribute.lipUpper;
            }
                break;
            case KBeauty_LipLower://MARK: 下嘴唇
            {
                value = faceAttribute.lipLower;
            }
                break;
            case KBeauty_Smile://MARK: 微笑
            {
                value = faceAttribute.smile;
            }
                break;
            case KBeauty_BlurIntensity://MARK: 磨皮
            {
                value = _blur;
            }
                break;
            case KBeauty_BrightIntensity://MARK: 亮肤
            {
                value = _brightness;
            }
                break;
            case KBeauty_ToneIntensity://MARK: 红润
            {
                value = _beautyToneIntensity;
            }
                break;
            case KBeauty_BigEyes://MARK: 大眼
            {
                value = _beautyBigEye;
            }
                break;
            case KBeauty_FaceLift://MARK: 瘦脸
            {
                value = _beautyThinFace;
            }
                break;
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
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesCompareCompletion:value:)] )
    {
        [_delegate fiveSensesCompareCompletion:_currentType value:value];
    }
#else
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesCompareCompletionAll:)] )
    {
        [_delegate fiveSensesCompareCompletionAll:_faceAttribute];
    }
#endif
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
