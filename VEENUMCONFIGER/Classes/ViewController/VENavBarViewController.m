//
//  VENavBarViewController.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/2/16.
//

#import "VENavBarViewController.h"
@implementation VEToolBarView
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
@end
@interface VENavBarViewController ()

@end

@implementation VENavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SCREEN_BACKGROUND_COLOR;
    
}

#pragma mark 导航栏布局
- (UIView *)navBar {
    if (!_navBar) {
        //关闭自动设置边距
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        if (@available(iOS 11.0, *)) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
        
        _navBar = [[UIView alloc] initWithFrame:CGRectMake(0,0,kWIDTH,kNavgationBar_Height)];
        [self.view addSubview:_navBar];

        self.titlelab = [[UILabel alloc] initWithFrame:CGRectMake(50,kStatusBarHeight,kWIDTH-100, kNavgationBar_Height-kStatusBarHeight)];
        self.titlelab.textColor = VE_NAV_TITLE_COLOR;
        [self.titlelab setFont:NAVIBARTITLEFONT];
        self.titlelab.textAlignment = NSTextAlignmentCenter;
        [_navBar addSubview:self.titlelab];
        
        [self.backBtn setFrame:CGRectMake(0, kStatusBarHeight + ((kNavgationBar_Height-kStatusBarHeight -44)/2), 44, 44)];
        [_navBar addSubview:self.backBtn];
        
        _exportNavBarBtn = [VENavBarButton buttonWithType:UIButtonTypeCustom];
        _exportNavBarBtn.frame = CGRectMake(kWIDTH - ([VEConfigManager sharedManager].iPad_HD ? 74 : 54 + 12), kStatusBarHeight + ((kNavgationBar_Height-kStatusBarHeight -26)/2), ([VEConfigManager sharedManager].iPad_HD ? 64 : 54), 26);
        [_exportNavBarBtn setTitle:VELocalizedString(@"导出", nil) forState:UIControlStateNormal];
        [_exportNavBarBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:([VEConfigManager sharedManager].iPad_HD ? 14 : 13)]];
        [_exportNavBarBtn setTitleColor:([VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : [UIColor blackColor]) forState:UIControlStateNormal];
        _exportNavBarBtn.layer.cornerRadius = 2.0;
        _exportNavBarBtn.layer.masksToBounds = YES;
        _exportNavBarBtn.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? UIColorFromRGB(0x3c3d3d) : [UIColor whiteColor];
        [_navBar addSubview:_exportNavBarBtn];
        
        self.barline = [[UIView alloc] initWithFrame:CGRectMake(0, kNavgationBar_Height - 0.5, kWIDTH, 0.5)];
        self.barline.backgroundColor = UIColorFromRGB(0x272727);//_navBar.backgroundColor;
        [_navBar addSubview:self.barline];
    }
    return _navBar;
}

- (VEToolBarView *)toolBar {
    if (!_toolBar) {
        if([VEConfigManager sharedManager].iPad_HD){
            _toolBar = [[VEToolBarView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kToolbarHeight)];
        }else{
            if([VEConfigManager sharedManager].editConfiguration.isSingletrack && iPad){
                _toolBar = [[VEToolBarView alloc] initWithFrame:CGRectMake(0, kHEIGHT - kToolbarHeight - ipadToolBarHeight, kWIDTH, kToolbarHeight + ipadToolBarHeight)];
            }else{
                _toolBar = [[VEToolBarView alloc] initWithFrame:CGRectMake(0, kHEIGHT - kToolbarHeight, kWIDTH, kToolbarHeight)];
            }
            _toolBar.backgroundColor = TOOLBAR_COLOR;
            [self.view addSubview:_toolBar];
        }

        self.titlelab = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, kWIDTH-100, 44)];
        self.titlelab.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        [self.titlelab setFont:[UIFont boldSystemFontOfSize:17.0]];
        self.titlelab.textAlignment = NSTextAlignmentCenter;
        [_toolBar addSubview:self.titlelab];
        
        [self.backBtn setFrame:CGRectMake(0, 0, 44, 44)];
        [_toolBar addSubview:self.backBtn];
        
        _finishToolBarBtn = [VENavBarButton buttonWithType:UIButtonTypeCustom];
        _finishToolBarBtn.frame = CGRectMake(kWIDTH - 44, 0, 44, 44);
        [_finishToolBarBtn setImage:[VEHelp imageWithContentOfFile:([VEConfigManager sharedManager].iPad_HD ? @"ipad/剪辑_勾_" : @"剪辑_勾_")] forState:UIControlStateNormal];
        
        
        
        [_toolBar addSubview:_finishToolBarBtn];
        
        if( [VEConfigManager sharedManager].isPictureEditing )
        {
            _toolBar.backgroundColor = UIColorFromRGB(0x1a1a1a);//[UIColor whiteColor];
            self.titlelab.textColor = PESDKTEXT_COLOR;
            [_finishToolBarBtn setImage:[VEHelp imageNamed:@"/PESDKImage/PESDK_勾@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]] forState:UIControlStateNormal];
        }
    }
    return _toolBar;
}

#pragma mark 隐藏导航栏
- (void)navBarHidden:(BOOL)hidden {
    self.navBar.hidden = hidden;
}

#pragma mark 返回事件
- (void)backAction {
    
    [[[UIApplication sharedApplication].delegate window] endEditing:YES];
    
    if(self.typeCode == DisBackCode){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(VENavBarButton *)backBtn{
    if (_backBtn == nil) {
        _backBtn = [VENavBarButton buttonWithType:UIButtonTypeCustom];
        if (_navBar) {
            [_backBtn setImage:[VEHelp imageWithContentOfFile:@"/New_EditVideo/剪辑_返回默认_"] forState:UIControlStateNormal];
        }else {
            [_backBtn setImage:[VEHelp imageWithContentOfFile:@"剪辑_叉_"] forState:UIControlStateNormal];
        }
        
        if( [VEConfigManager sharedManager].isPictureEditing )
        {
            [_backBtn setImage:[VEHelp imageNamed:@"/PESDKImage/PESDK_返回@3x" atBundle:[VEHelp getBundleName:@"VEPESDK"]] forState:UIControlStateNormal];
        }
        
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
