//
//  VEFiveSensesView.m
//  VEENUMCONFIGER
//
//  Created by mac on 2021/7/28.
//

#import "VEFiveSensesView.h"
#import <VEENUMCONFIGER/VEHelp.h>

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
        {
            UIButton * resetBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, [VEConfigManager sharedManager].iPad_HD ? (self.frame.size.height - 40) : (self.frame.size.height - kPlayerViewOriginX - 40), 50, 28)];
            [resetBtn setTitle:VELocalizedString(@"还原", nil) forState:UIControlStateNormal];
            [resetBtn setTitleColor:UIColorFromRGB(0xbebebe) forState:UIControlStateNormal];
            [resetBtn setTitleColor:Main_Color forState:UIControlStateHighlighted];
            resetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            resetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [resetBtn addTarget:self action:@selector(resetAdjustment_Btn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:resetBtn];
            
            UIButton *compareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            compareBtn.frame = CGRectMake(self.frame.size.width - (64 + 15), resetBtn.frame.origin.y, 64, 28);
            [compareBtn setTitle:VELocalizedString(@"toning_compare", nil) forState:UIControlStateNormal];
            [compareBtn setTitleColor:Main_Color forState:UIControlStateNormal];
            [compareBtn setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
            compareBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            compareBtn.layer.cornerRadius = 28/2.0;
            compareBtn.layer.borderColor = UIColorFromRGB(0x626267).CGColor;
            compareBtn.layer.borderWidth = 1.0;
            [compareBtn addTarget:self action:@selector(compareBtnDown:) forControlEvents:UIControlEventTouchDown];
            [compareBtn addTarget:self action:@selector(compareBtnUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
            [self addSubview:compareBtn];
        }
        
        _adjustmentSliders = [NSMutableArray new];
        _adjustmentNumberLabels = [NSMutableArray new];
        _adjustmentViews = [NSMutableArray new];
        
        _adjHeight = (self.frame.size.height - kPlayerViewOriginX - 40 - 44)/2.0;
        
        if([VEConfigManager sharedManager].iPad_HD){
            _beautyView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 44 - 44)];
            _beautyView.backgroundColor = [UIColor clearColor];
            [self addSubview:_beautyView];
            NSArray *list = @[@{@"title":@"脸宽",@"id":@(KBeauty_FaceWidth)},
                              @{@"title":@"额高",@"id":@(KBeauty_Forehead)},
                              @{@"title":@"下颚宽",@"id":@(KBeauty_ChinWidth)},
                              @{@"title":@"下巴高",@"id":@(KBeauty_ChinHeight)},
                              //@{@"title":@"眼睛大小",@"id":@(KBeauty_EyeSize)},
                              @{@"title":@"眼睛宽",@"id":@(KBeauty_EyeWidth)},
                              @{@"title":@"眼睛高",@"id":@(KBeauty_EyeHeight)},
                              @{@"title":@"眼睛倾斜",@"id":@(KBeauty_EyeSlant)},
                              @{@"title":@"眼睛距离",@"id":@(KBeauty_EyeDistance)},
//                              @{@"title":@"鼻子大小",@"id":@(KBeauty_NoseSize)},
                              @{@"title":@"鼻子宽",@"id":@(KBeauty_NoseWidth)},
                              @{@"title":@"鼻子高",@"id":@(KBeauty_NoseHeight)},
                              @{@"title":@"嘴巴宽",@"id":@(KBeauty_MouthWidth)},
                              @{@"title":@"上嘴唇",@"id":@(KBeauty_LipUpper)},
                              @{@"title":@"下嘴唇",@"id":@(KBeauty_LipLower)},
                              @{@"title":@"微笑",@"id":@(KBeauty_Smile)},
                              @{@"title":@"磨皮",@"id":@(KBeauty_BlurIntensity)},
                              @{@"title":@"美白",@"id":@(KBeauty_BrightIntensity)},
                              @{@"title":@"红润",@"id":@(KBeauty_ToneIntensity)},
                              @{@"title":@"大眼",@"id":@(KBeauty_BigEyes)},
                              @{@"title":@"瘦脸",@"id":@(KBeauty_FaceLift)}
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
            [self initAdjView:CGRectMake(20, (_adjHeight*2.0 - 35)/2.0 + 44, self.frame.size.width - 40, 35) atStr:@"脸宽"];
            [self initAdjView:CGRectMake(20, (_adjHeight - 35)/2.0 + 44 + 5, (self.frame.size.width - 40)/2.0 - 10, 35) atStr:@"眼睛倾斜"];
            [self initAdjView:CGRectMake(30 + (self.frame.size.width - 40)/2.0, (_adjHeight - 35)/2.0 + 44 + 5, (self.frame.size.width - 40)/2.0 - 10, 35) atStr:@"眼睛距离"];
            [self initAdjView:CGRectMake(20, (_adjHeight - 35)/2.0 + _adjHeight + 44 - 5, self.frame.size.width - 40, 35) atStr:@"下巴高"];
        }
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
        
        _adjustmentSliders[0].value = faceAttribute == nil ? 0.5 : faceAttribute.faceWidth;
        _adjustmentSliders[1].value = faceAttribute == nil ? 0.5 : faceAttribute.forehead;
        
        _adjustmentSliders[2].value = faceAttribute == nil ? 0.5 : faceAttribute.chinWidth;
        _adjustmentSliders[3].value = faceAttribute == nil ? 0.5 : faceAttribute.chinHeight;
        
        _adjustmentSliders[4].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeWidth;
        _adjustmentSliders[5].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeHeight;
        _adjustmentSliders[6].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeSlant;
        _adjustmentSliders[7].value = faceAttribute == nil ? 0.5 : faceAttribute.eyeDistance;
        
        _adjustmentSliders[8].value = faceAttribute == nil ? 0.5 : faceAttribute.noseWidth;
        _adjustmentSliders[9].value = faceAttribute == nil ? 0.5 : faceAttribute.noseHeight;
        
        _adjustmentSliders[10].value = faceAttribute == nil ? 0.5 : faceAttribute.mouthWidth;
        _adjustmentSliders[11].value = faceAttribute == nil ? 0.5 : faceAttribute.lipUpper;
        _adjustmentSliders[12].value = faceAttribute == nil ? 0.5 : faceAttribute.lipLower;
        
        _adjustmentSliders[13].value = faceAttribute == nil ? 0.5 : faceAttribute.smile;
        
        _adjustmentSliders[14].value = _currentMedia.beautyBlurIntensity;
        _adjustmentSliders[15].value = _currentMedia.beautyBrightIntensity;
        _adjustmentSliders[16].value = _currentMedia.beautyToneIntensity;
        _adjustmentSliders[17].value = _currentMedia.beautyBigEyeIntensity;
        _adjustmentSliders[18].value = _currentMedia.beautyThinFaceIntensity;
        [_adjustmentSliders enumerateObjectsUsingBlock:^(UISlider * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ((UILabel *)[obj.superview viewWithTag:100]).text = [NSString stringWithFormat:@"%.f",(obj.value * 100)];
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
            UIImage *trackImage = [VEHelp imageWithColor:Main_Color size:slider.frame.size cornerRadius:1];
            [slider setMinimumTrackImage:trackImage forState:UIControlStateNormal];
            [slider setMaximumTrackImage: [UIImage imageNamed:[VEHelp getResourceFromBundle:@"VEEditSDK" resourceName:@"/jianji/Adjust/剪辑-调色_轨道1@1x" Type:@"png"]] forState:UIControlStateNormal];
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
            [btn setImage:[VEHelp imageNamed:@"/剪辑_勾_@3x"] forState:UIControlStateNormal];
            [btn setImage:[VEHelp imageNamed:@"/剪辑_勾_@3x"] forState:UIControlStateSelected];
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
        }else{
            [self createRibbonScroll];
        }
    }
}
-(void)createIpadUIRibbonScroll
{
    NSMutableArray * toolItems = [NSMutableArray new];
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
    {
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"其他",@"title",@(7),@"id", nil];
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
-(void)createRibbonScroll
{
    NSMutableArray * toolItems = [NSMutableArray new];
    {
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"脸型",@"title",@(0),@"id", nil];
    [toolItems addObject:dic1];
    }
    {
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"下巴",@"title",@(1),@"id", nil];
    [toolItems addObject:dic1];
    }
    {
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"眼睛",@"title",@(4),@"id", nil];
    [toolItems addObject:dic1];
    }
    {
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"嘴唇",@"title",@(5),@"id", nil];
    [toolItems addObject:dic1];
    }
    {
    NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"微笑",@"title",@(3),@"id", nil];
    [toolItems addObject:dic1];
    }
    {
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"鼻子",@"title",@(6),@"id", nil];
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
        
        [toolItemBtn addTarget:self action:@selector(toolBar_Btn:) forControlEvents:UIControlEventTouchUpInside];
        
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
            [_beautyView setContentOffset:CGPointMake(0, 50 * 0)];
        }
            break;
        case 1://MARK: 额头
        {
            [_beautyView setContentOffset:CGPointMake(0, 50 * 1)];
        }
            break;
        case 2://MARK:下巴
        {
            [_beautyView setContentOffset:CGPointMake(0, 50 * 2)];
        }
            break;
        case 3://MARK:眼睛
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 4)];
        }
            break;
        case 4://MARK:鼻子
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 8)];
        }
            break;
        case 5://MARK: 嘴唇
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 10)];
        }
            break;
        case 6://MARK: 微笑
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 13)];
        }
            break;
        case 7://MARK: 其他
        {
            
            [_beautyView setContentOffset:CGPointMake(0, 50 * 14)];
        }
            break;
        default:
            break;
    }
}
-(void)toolBar_Btn:(UIButton *) sender
{
    
    if( _currentBtn )
    {
        _currentBtn.selected =NO;
    }
    _currentType = sender.tag;
    
    sender.selected = YES;
    
    _currentBtn = sender;
    
    __block FaceAttribute *faceAttribute = nil;
    [self.adjustmentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.hidden = YES;
    }];
    [_currentMedia.multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(_currentFaceRect, CGPointMake(obj.faceRect.origin.x + obj.faceRect.size.width / 2.0, obj.faceRect.origin.y + obj.faceRect.size.height / 2.0)) || CGRectEqualToRect(_currentFaceRect, obj.faceRect)) {
            faceAttribute = obj;
            *stop = YES;
        }
    }];
    
    float value =  0.5;
    switch (_currentType) {
        case 0://MARK: 脸型
        {
                self.adjustmentViews[0].hidden = NO;
                CGRect rect = self.adjustmentViews[0].frame;
                rect.origin.x = 20;
                rect.origin.y = (_adjHeight*2.0 - 35)/2.0 + 44;
                self.adjustmentViews[0].frame = rect;
                if( faceAttribute )
                {
                    value = faceAttribute.faceWidth;
                }
                [_adjustmentSliders[0] setValue:value];
                self.adjustmentSliders[0].tag = KBeauty_FaceWidth;
                _adjustmentNumberLabels[0].text = VELocalizedString(@"脸宽", nil);
        }
            break;
        case 1://MARK: 下巴
        {
                self.adjustmentViews[0].hidden = NO;
                CGRect rect = self.adjustmentViews[0].frame;
                rect.origin.x = 20;
                rect.origin.y = (_adjHeight - 35)/2.0 + 44;
                self.adjustmentViews[0].frame = rect;
                if( faceAttribute )
                {
                    value = faceAttribute.chinWidth;
                }
                [_adjustmentSliders[0] setValue:value];
                self.adjustmentSliders[0].tag = KBeauty_ChinWidth;
                _adjustmentNumberLabels[0].text = VELocalizedString(@"下颚宽", nil);
                
                self.adjustmentViews[3].hidden = NO;
                if( faceAttribute )
                {
                    value = faceAttribute.chinHeight;
                }
                [_adjustmentSliders[3] setValue:value];
                _adjustmentSliders[3].tag = KBeauty_ChinHeight;
                _adjustmentNumberLabels[3].text = VELocalizedString(@"下巴高", nil);
        }
            break;
        case 2://MARK: 额头
        {
                self.adjustmentViews[0].hidden = NO;
                CGRect rect = self.adjustmentViews[0].frame;
                rect.origin.x = 20;
                rect.origin.y = (_adjHeight*2.0 - 35)/2.0 + 44;
                self.adjustmentViews[0].frame = rect;
                if( faceAttribute )
                {
                    value = faceAttribute.forehead;
                }
                [_adjustmentSliders[0] setValue:value];
                _adjustmentNumberLabels[0].text = VELocalizedString(@"额头高", nil);
                _adjustmentSliders[0].tag =  KBeauty_Forehead;
        }
            break;
        case 3://MARK: 微笑
        {
                self.adjustmentViews[0].hidden = NO;
                CGRect rect = self.adjustmentViews[0].frame;
                rect.origin.x = 20;
                rect.origin.y = (_adjHeight*2.0 - 35)/2.0 + 44;
                self.adjustmentViews[0].frame = rect;
                if( faceAttribute )
                {
                    value = faceAttribute.smile;
                }
                [_adjustmentSliders[0] setValue:value];
                _adjustmentNumberLabels[0].text = VELocalizedString(@"微笑", nil);
                _adjustmentSliders[0].tag = KBeauty_Smile;
        }
            break;
        case 4://MARK: 眼睛
        {
                {
                    self.adjustmentViews[1].hidden = NO;
                    if( faceAttribute )
                    {
                        value = faceAttribute.eyeSlant;
                    }
                    [_adjustmentSliders[1] setValue:value];
                    _adjustmentNumberLabels[1].text = VELocalizedString(@"倾斜", nil);
                    _adjustmentSliders[1].tag = KBeauty_EyeSlant;
                }
                
                {
                    self.adjustmentViews[2].hidden = NO;
                    if( faceAttribute )
                    {
                        value = faceAttribute.eyeDistance;
                    }
                    [_adjustmentSliders[2] setValue:value];
                    _adjustmentNumberLabels[2].text = VELocalizedString(@"距离", nil);
                    _adjustmentSliders[2].tag = KBeauty_EyeDistance;
                }
                
                {
                    self.adjustmentViews[3].hidden = NO;
                    if( faceAttribute )
                    {
                        value = faceAttribute.eyeWidth;
                    }
                    [_adjustmentSliders[3] setValue:value];
                    _adjustmentNumberLabels[3].text = VELocalizedString(@"大小", nil);
                    _adjustmentSliders[3].tag = KBeauty_EyeSize;
                }
        }
            break;
        case 5://MARK: 嘴唇
        {
                {
                    self.adjustmentViews[1].hidden = NO;
                    if( faceAttribute )
                    {
                        value = faceAttribute.lipUpper;
                    }
                    [_adjustmentSliders[1] setValue:value];
                    _adjustmentNumberLabels[1].text = VELocalizedString(@"上嘴唇", nil);
                    _adjustmentSliders[1].tag = KBeauty_LipUpper;
                }
                
                {
                    self.adjustmentViews[2].hidden = NO;
                    if( faceAttribute )
                    {
                        value = faceAttribute.lipLower;
                    }
                    [_adjustmentSliders[2] setValue:value];
                    _adjustmentNumberLabels[2].text = VELocalizedString(@"下嘴唇", nil);
                    _adjustmentSliders[2].tag = KBeauty_LipLower;
                }
                
                {
                    self.adjustmentViews[3].hidden = NO;
                    if( faceAttribute )
                    {
                        value = faceAttribute.mouthWidth;
                    }
                    [_adjustmentSliders[3] setValue:value];
                    _adjustmentNumberLabels[3].text = VELocalizedString(@"嘴巴宽", nil);
                    _adjustmentSliders[3].tag = KBeauty_MouthWidth;
                }
        }
            break;
        case 6://MARK: 鼻子
        {
                self.adjustmentViews[0].hidden = NO;
                CGRect rect = self.adjustmentViews[0].frame;
                rect.origin.x = 20;
                rect.origin.y = (_adjHeight*2.0 - 35)/2.0 + 44;
                self.adjustmentViews[0].frame = rect;
                if( faceAttribute )
                {
                    value = faceAttribute.noseWidth;
                }
                [_adjustmentSliders[0] setValue:value];
                _adjustmentNumberLabels[0].text = VELocalizedString(@"大小", nil);
                _adjustmentSliders[0].tag = KBeauty_NoseSize;
        }
            break;
        default:
            break;
    }
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
- (void)beginScrub:(UISlider *)slider{
    [self sliderValueChanged:slider];
}

- (void)scrub:(UISlider *)slider{
    [self sliderValueChanged:slider];
}

- (void)endScrub:(UISlider *)slider{
    if([VEConfigManager sharedManager].iPad_HD){
        _currentType = slider.tag;
    }
    [self sliderValueChanged:slider];
}

-(void)sliderValueChanged:(UISlider *) slider
{
    if([VEConfigManager sharedManager].iPad_HD){
        ((UILabel *)[slider.superview viewWithTag:100]).text = [NSString stringWithFormat:@"%.f",(slider.value * 100)];
    }
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSenses_ValueChanged:atVIew:)] )
    {
        [_delegate fiveSenses_ValueChanged:slider atVIew:self];
    }
}

-(void)resetAdjustment_Btn:( UIButton * ) sender
{
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSenses_Reset:atVIew:)] )
    {
        [_delegate fiveSenses_Reset:_currentType atVIew:self];
    }
}

- (void)compareBtnDown:(UIButton *)sender {
    _editMedia = [_currentMedia copy];
    float value =  sender.tag > KBeauty_Smile ? 0 : 0.5;
    if([VEConfigManager sharedManager].iPad_HD){
        for (int i = 0;i<_adjustmentSliders.count;i++) {
            if(_adjustmentSliders[i].tag == _currentType){
                [_adjustmentSliders[i] setValue:value];
                break;
            }
        }
    }else{
        switch (_currentType) {
            case 0://MARK: 脸型
            {
                [_adjustmentSliders[0] setValue:value];
            }
                break;
            case 1://MARK: 下巴
            {
                [_adjustmentSliders[0] setValue:value];
                [_adjustmentSliders[3] setValue:value];
            }
                break;
            case 2://MARK: 额头
            {
                [_adjustmentSliders[0] setValue:value];
            }
                break;
            case 3://MARK: 微笑
            {
                [_adjustmentSliders[0] setValue:value];
            }
                break;
            case 4://MARK: 眼睛
            {
                [_adjustmentSliders[1] setValue:value];
                [_adjustmentSliders[2] setValue:value];
                [_adjustmentSliders[3] setValue:value];
            }
                break;
            case 5://MARK: 嘴唇
            {
                [_adjustmentSliders[1] setValue:value];
                [_adjustmentSliders[2] setValue:value];
                [_adjustmentSliders[3] setValue:value];
            }
                break;
            case 6://MARK: 鼻子
            {
                [_adjustmentSliders[0] setValue:value];
            }
                break;
            default:
                break;
        }
    }
    
    if( _delegate && [_delegate respondsToSelector:@selector(fiveSensesCompare:atVIew:)] )
    {
        [_delegate fiveSensesCompare:_currentType atVIew:self];
    }
}

- (void)compareBtnUp:(UIButton *)sender {
    __block FaceAttribute *faceAttribute = nil;
    [_editMedia.multipleFaceAttribute enumerateObjectsUsingBlock:^(FaceAttribute * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(_currentFaceRect, CGPointMake(obj.faceRect.origin.x + obj.faceRect.size.width / 2.0, obj.faceRect.origin.y + obj.faceRect.size.height / 2.0)) || CGRectEqualToRect(_currentFaceRect, obj.faceRect)) {
            faceAttribute = obj;
            *stop = YES;
        }
    }];
    float value =  _currentType > KBeauty_Smile ? 0.0 : 0.5;
    if([VEConfigManager sharedManager].iPad_HD){
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
            default:
                break;
                
                /*
                 
                 @{@"title":@"磨皮",@"id":@(KBeauty_BlurIntensity)},
                 @{@"title":@"美白",@"id":@(KBeauty_BrightIntensity)},
                 @{@"title":@"红润",@"id":@(KBeauty_ToneIntensity)},
                 @{@"title":@"大眼",@"id":@(KBeauty_BigEyes)},
                 @{@"title":@"瘦脸",@"id":@(KBeauty_FaceLift)}
                 */
        }
        for (int i = 0;i<_adjustmentSliders.count;i++) {
            if(_adjustmentSliders[i].tag == _currentType){
                [_adjustmentSliders[i] setValue:value];
                break;
            }
        }
        
    }else{
        switch (_currentType) {
            case 0://MARK: 脸型
            {
                if( faceAttribute )
                {
                    value = faceAttribute.faceWidth;
                }
                [_adjustmentSliders[0] setValue:value];
            }
                break;
            case 1://MARK: 下巴
            {
                if( faceAttribute )
                {
                    value = faceAttribute.chinWidth;
                }
                [_adjustmentSliders[0] setValue:value];
                if( faceAttribute )
                {
                    value = faceAttribute.chinHeight;
                }
                [_adjustmentSliders[3] setValue:value];
            }
                break;
            case 2://MARK: 额头
            {
                if( faceAttribute )
                {
                    value = faceAttribute.forehead;
                }
                [_adjustmentSliders[0] setValue:value];
            }
                break;
            case 3://MARK: 微笑
            {
                if( faceAttribute )
                {
                    value = faceAttribute.smile;
                }
                [_adjustmentSliders[0] setValue:value];
            }
                break;
            case 4://MARK: 眼睛
            {
                if( faceAttribute )
                {
                    value = faceAttribute.eyeSlant;
                }
                [_adjustmentSliders[1] setValue:value];
                if( faceAttribute )
                {
                    value = faceAttribute.eyeDistance;
                }
                [_adjustmentSliders[2] setValue:value];
                if( faceAttribute )
                {
                    value = faceAttribute.eyeWidth;
                }
                [_adjustmentSliders[3] setValue:value];
            }
                break;
            case 5://MARK: 嘴唇
            {
                if( faceAttribute )
                {
                    value = faceAttribute.lipUpper;
                }
                [_adjustmentSliders[1] setValue:value];
                if( faceAttribute )
                {
                    value = faceAttribute.lipLower;
                }
                [_adjustmentSliders[2] setValue:value];
                if( faceAttribute )
                {
                    value = faceAttribute.mouthWidth;
                }
                [_adjustmentSliders[3] setValue:value];
            }
                break;
            case 6://MARK: 鼻子
            {
                if( faceAttribute )
                {
                    value = faceAttribute.noseWidth;
                }
                [_adjustmentSliders[0] setValue:value];
            }
                break;
            default:
                break;
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
@end
