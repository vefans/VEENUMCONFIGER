//
//  VEFiveCameraView.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/7/28.
//

#import "VEFiveCameraView.h"
#import <VEENUMCONFIGER/VEHelp.h>
#import <VEENUMCONFIGER/VEPlaySlider.h>
@interface VEFiveCameraView()<UIScrollViewDelegate>
@end
@implementation VEFiveCameraView

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
                _adjustmentSliders[i].tag = [list[i][@"id"] integerValue];
                [_beautyView addSubview:_adjustmentViews[i]];
            }
            [self insertColorGradient:_beautyView];
            [self setDefaultValue];
            _beautyView.contentSize = CGSizeMake(0, list.count * 50);
        }else{
            _beautyView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 44 - 44)];
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
            UIView *sliderSupView = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame) - 44) - 15, CGRectGetWidth(self.frame), 44)];
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
                                
                
                VEPlaySlider * slider = [[VEPlaySlider alloc] initWithFrame:CGRectMake(70, (CGRectGetHeight(sliderSupView.frame) - 35)/2.0,sliderSupView.frame.size.width - 140 , 35)];
                slider.tag = [list[i][@"id"] integerValue];
                [slider setMinimumValue:0];
                [slider setMaximumValue:1.0];
                [slider setValue:0.5];
                slider.hidden = YES;
                
                UIImage *trackImage = [VEHelp imageWithColor:Main_Color size:CGSizeMake(10, 2.0) cornerRadius:1];
                [slider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
                trackImage = [VEHelp imageWithColor:SliderMaximumTrackTintColor size:CGSizeMake(10, 2.0) cornerRadius:1];
                [slider setMaximumTrackImage: trackImage forState:UIControlStateNormal];
                [slider setThumbImage:[VEHelp imageWithContentOfFile:@"New_EditVideo/LiteBeauty/拖动球"] forState:UIControlStateNormal];
                [slider addTarget:self action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
                [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
                [slider addTarget:self action:@selector(endScrub:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
                [sliderSupView addSubview:slider];
                [_adjustmentSliders addObject:slider];
                               
                if( i == 0 )
                {
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(slider.frame.size.width + slider.frame.origin.x + 10, -10, 30, 15)];
                    label.text  = @"50";
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont systemFontOfSize:12];
                    label.textAlignment = NSTextAlignmentCenter;
                    _sliderValueLabel = label;
                    [sliderSupView addSubview:_sliderValueLabel];
                    
                    toolItemBtn.selected = YES;
                    slider.hidden = NO;
                    _currentBtn = toolItemBtn;
                    _currentType = i;
                    
                    CGRect frame = _sliderValueLabel.frame;
                    frame.origin.x = slider.value * slider.frame.size.width + slider.frame.origin.x - frame.size.width / 2.0;
                    _sliderValueLabel.frame = frame;
                }
            }
            _beautyView.contentSize = CGSizeMake(contentsWidth, 0);
            
        }
        
        UIButton *compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        compareBtn.frame = CGRectMake(self.frame.size.width - (64 + 15), (CGRectGetHeight(self.frame) - 44) - 15 , 64, 44);
        [compareBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/skin/%@默认",@"对比"]] forState:UIControlStateNormal];
        [compareBtn setImage:[VEHelp imageNamed:[NSString stringWithFormat:@"VirtualLive/Beauty/skin/%@选中",@"对比"]] forState:UIControlStateSelected];
        [compareBtn addTarget:self action:@selector(compareBtnDown:) forControlEvents:UIControlEventTouchDown];
        [compareBtn addTarget:self action:@selector(compareBtnUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:compareBtn];
        
        UIButton * resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,(CGRectGetHeight(self.frame) - 44) - 15, 50, 44)];
        [resetBtn setTitle:VELocalizedString(@"还原", nil) forState:UIControlStateNormal];
        [resetBtn setTitleColor:UIColorFromRGB(0xbebebe) forState:UIControlStateNormal];
        [resetBtn setTitleColor:Main_Color forState:UIControlStateHighlighted];
        resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        resetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [resetBtn addTarget:self action:@selector(resetAdjustment_Btn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:resetBtn];
    }
    return self;
}
- (void)setDefaultValue{
    __block FaceAttribute *faceAttribute = _camera.faceAttribute;
    if(![VEConfigManager sharedManager].iPad_HD){
        _adjustmentSliders[0].value = faceAttribute == nil ? 0.5 : faceAttribute.faceWidth;
        
        _adjustmentSliders[1].value = faceAttribute == nil ? 0.5 : faceAttribute.chinWidth;
        _adjustmentSliders[2].value = faceAttribute == nil ? 0.5 : faceAttribute.chinHeight;
        
        _adjustmentSliders[3].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeWidth;
        _adjustmentSliders[4].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeHeight;
        _adjustmentSliders[5].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeSlant;
        _adjustmentSliders[6].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeDistance;
        
        _adjustmentSliders[7].value = faceAttribute == nil ? 0.5 : faceAttribute.noseWidth;
        _adjustmentSliders[8].value = faceAttribute == nil ? 0.5 : faceAttribute.noseHeight;
        
        _adjustmentSliders[9].value = faceAttribute == nil ? 0.5 : faceAttribute.mouthWidth;
        _adjustmentSliders[10].value = faceAttribute == nil ? 0.5 : faceAttribute.lipUpper;
        _adjustmentSliders[11].value = faceAttribute == nil ? 0.5 : faceAttribute.lipLower;
        
        _adjustmentSliders[12].value = faceAttribute == nil ? 0.5 : faceAttribute.smile;
        return;
    }
    {
        _adjustmentSliders[0].value = _camera.blur;
        _adjustmentSliders[1].value = _camera.brightness;
        _adjustmentSliders[2].value = _camera.beautyToneIntensity;
        _adjustmentSliders[3].value = _camera.beautyBigEye;
        _adjustmentSliders[4].value = _camera.beautyThinFace;
        
        _adjustmentSliders[5].value = faceAttribute == nil ? 0.5 : faceAttribute.faceWidth;
        
        _adjustmentSliders[6].value = faceAttribute == nil ? 0.5 : faceAttribute.chinWidth;
        _adjustmentSliders[7].value = faceAttribute == nil ? 0.5 : faceAttribute.chinHeight;
        
        _adjustmentSliders[8].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeWidth;
        _adjustmentSliders[9].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeHeight;
        _adjustmentSliders[10].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeSlant;
        _adjustmentSliders[11].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeDistance;
        
        _adjustmentSliders[12].value = faceAttribute == nil ? 0.5 : faceAttribute.noseWidth;
        _adjustmentSliders[13].value = faceAttribute == nil ? 0.5 : faceAttribute.noseHeight;
        
        _adjustmentSliders[14].value = faceAttribute == nil ? 0.5 : faceAttribute.mouthWidth;
        _adjustmentSliders[15].value = faceAttribute == nil ? 0.5 : faceAttribute.lipUpper;
        _adjustmentSliders[16].value = faceAttribute == nil ? 0.5 : faceAttribute.lipLower;
        
        _adjustmentSliders[17].value = faceAttribute == nil ? 0.5 : faceAttribute.smile;
        
        [_adjustmentSliders enumerateObjectsUsingBlock:^(UISlider * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ((UILabel *)[obj.superview viewWithTag:100]).text = [NSString stringWithFormat:@"%.f",(obj.value * 100)];
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
    
    {
        UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(50, (CGRectGetHeight(rect) - 35)/2.0,view.frame.size.width - ([VEConfigManager sharedManager].iPad_HD ? 90 : 50) , 35)];
        [slider setMinimumValue:0];
        [slider setMaximumValue:1.0];
        [slider setValue:0.5];

        [slider addTarget:self action:@selector(beginScrub:) forControlEvents:UIControlEventTouchDown];
        [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(endScrub:) forControlEvents:UIControlEventTouchUpInside];
        [slider addTarget:self action:@selector(endScrub:) forControlEvents:UIControlEventTouchCancel];
        [slider addTarget:self action:@selector(endScrub:) forControlEvents:UIControlEventTouchUpOutside];

        UIImage * theImage = [UIImage imageNamed:[VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/jianji/Adjust/剪辑-调色_球1@3x" Type:@"png"]];
        [slider setThumbImage:theImage forState:UIControlStateNormal];

        if([VEConfigManager sharedManager].iPad_HD){
            [slider setMaximumTrackImage:[VEHelp imageWithColor:UIColorFromRGB(0x2F302F) size:CGSizeMake(slider.frame.size.width, 1) cornerRadius:1] forState:UIControlStateNormal];
            [slider setMinimumTrackImage: [VEHelp imageWithColor:UIColorFromRGB(0x2F302F) size:CGSizeMake(slider.frame.size.width, 1) cornerRadius:1] forState:UIControlStateNormal];
        }else{
            UIImage *trackImage = [VEHelp imageWithColor:Main_Color size:CGSizeMake(10, 2.0) cornerRadius:1];
            [slider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
            trackImage = [VEHelp imageWithColor:SliderMaximumTrackTintColor size:CGSizeMake(10, 2.0) cornerRadius:1];
            [slider setMaximumTrackImage: trackImage forState:UIControlStateNormal];
        }
       [_adjustmentSliders addObject:slider];
           [view addSubview:slider];
       }
   
       {
           UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, CGRectGetHeight(rect))];
           label.text  = VELocalizedString(str, nil);
           label.font = [UIFont systemFontOfSize:12];
           label.textAlignment = NSTextAlignmentCenter;
           label.textColor = TEXT_COLOR;
           [_adjustmentNumberLabels addObject:label];
           [view addSubview:label];
       }
        if([VEConfigManager sharedManager].iPad_HD){
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width - 40, 0, 40, CGRectGetHeight(rect))];
            label.text  = @"";
            label.tag = 100;
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

- (void)setCamera:(CameraManager *)camera{
    _camera = camera;
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
    for (UISlider * slider in _adjustmentSliders) {
        slider.hidden = (slider.tag != sender.tag);
        if(slider.tag == sender.tag){
            CGRect frame = _sliderValueLabel.frame;
            frame.origin.x = slider.value * slider.frame.size.width + slider.frame.origin.x - frame.size.width / 2.0;
            _sliderValueLabel.frame = frame;
        }
    }
    if( _currentBtn )
    {
        _currentBtn.selected =NO;
    }
    _currentType = sender.tag;
    sender.selected = YES;
    _currentBtn = sender;
    
}

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
}

-(void)sliderValueChanged:(VEPlaySlider *) slider
{
    if([VEConfigManager sharedManager].iPad_HD){
        if(slider.tag == KBeauty_BlurIntensity){
            _camera.blur = slider.value;
        }else if(slider.tag == KBeauty_BrightIntensity){
            _camera.brightness = slider.value;
        }else if(slider.tag == KBeauty_ToneIntensity){
            _camera.beautyToneIntensity = slider.value;
        }else if(slider.tag == KBeauty_BigEyes){
            _camera.beautyBigEye = slider.value;
        }else if(slider.tag == KBeauty_FaceLift){
            _camera.beautyThinFace = slider.value;
        }
        ((UILabel *)[slider.superview viewWithTag:100]).text = [NSString stringWithFormat:@"%.f",(slider.value * 100)];
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
    [self setDefaultValue];
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSenses_Reset:atVIew:)] )
    {
        [_delegate fiveSenses_Reset:_currentType atVIew:self];
    }
}

- (void)compareBtnDown:(UIButton *)sender {
    _oldFaceAttribute = [_faceAttribute mutableCopy];
    float value =  sender.tag > KBeauty_Smile ? 0 : 0.5;
    for (int i = 0;i<_adjustmentSliders.count;i++) {
        if(_adjustmentSliders[i].tag == _currentType){
            value = 0.0;
            [_adjustmentSliders[i] setValue:value];
            break;
        }
    }
    
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesCompare:atVIew:)] )
    {
        [_delegate fiveSensesCompare:_currentType atVIew:self];
    }
}

- (void)compareBtnUp:(UIButton *)sender {
    __block FaceAttribute *faceAttribute = _camera.faceAttribute;
    float value =  _currentType > KBeauty_Smile ? 0.0 : 0.5;
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
            case KBeauty_EyeDistance://MARK: 眼睛距离
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
                value = _camera.blur;
            }
                break;
            case KBeauty_BrightIntensity://MARK: 亮肤
            {
                value = _camera.brightness;
            }
                break;
            case KBeauty_ToneIntensity://MARK: 红润
            {
                value = _camera.beautyToneIntensity;
            }
                break;//
            case KBeauty_BigEyes://MARK: 大眼
            {
                value = _camera.beautyBigEye;
            }
                break;//KBeauty_BigEyes
            case KBeauty_FaceLift://MARK: 瘦脸
            {
                value = _camera.beautyThinFace;
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
