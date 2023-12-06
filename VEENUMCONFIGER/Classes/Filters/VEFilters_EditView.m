//
//  VEFilters_EditView.m
//  VEDeluxeSDK
//
//  Created by mac on 2023/11/14.
//

#import "VEFilters_EditView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import <VEENUMCONFIGER/VEDownTool.h>
#import <VEENUMCONFIGER/VEDefines.h>
#import <VEENUMCONFIGER/VENetworkMaterialBtn_Cell.h>
#import <VEENUMCONFIGER/VEReachability.h>
#import <VEENUMCONFIGER/VEHelp.h>
#import <VEENUMCONFIGER/VECircleView.h>
#import <VEENUMCONFIGER/VEWindow.h>
#import <ATMHud/ATMHud.h>

NSMutableArray   *_originalGlobalFilters;
NSMutableArray   *_originalFiltersName;
NSMutableDictionary   *_filter_CollectionPlists;

#pragma mark- 外部可能需要用到的数组
NSMutableArray   *_globalFilters;
NSMutableArray   *_filtersName;
NSMutableArray   *_filter_newFilterSortArray;
NSMutableArray   *_filter_newFiltersNameSortArray;

void(^(_loadFilterCallBack))(NSMutableArray * globalFilters);
NSString * _filterResourceURL;
NSString * _netMaterialTypeURL;

@interface VEFilters_EditView()<UIDocumentPickerDelegate, VECoreDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{

    BOOL _isLocalCube;
    VECore *_filterCore;
    NSURL *_filterUrl;
    
    float    collectionCellWidth;
    VEFileScrollViewChildItem *_currentScrollViewChildItem;
    BOOL    _isRefreshFilter;
    BOOL _isSelect;
    UIView *_barView;
}
@property(nonatomic,strong, nullable)ATMHud         *hud;

@end
@implementation VEFilters_EditView

+(void)releaseFilterArray
{
    [_originalGlobalFilters removeAllObjects];
    _originalGlobalFilters = nil;
    [_originalFiltersName removeAllObjects];
    _originalFiltersName = nil;

    [_globalFilters removeAllObjects];
    _globalFilters = nil;
    [_filtersName removeAllObjects];
    _filtersName = nil;

    [_filter_CollectionPlists removeAllObjects];
    _filter_CollectionPlists = nil;
    [_filter_newFilterSortArray removeAllObjects];
    _filter_newFilterSortArray = nil;
    [_filter_newFiltersNameSortArray removeAllObjects];
    _filter_newFiltersNameSortArray = nil;
    
    _loadFilterCallBack = nil;
    _filterResourceURL = nil;
    _netMaterialTypeURL = nil;
}

+( void )loadFilterType:(void(^)(NSMutableArray * globalFilters))callBack atFilterResourceURL:( NSString * ) filterResourceURL atNetMaterialTypeURL:( NSString * ) netMaterialTypeURL
{
    VEReachability *lexiu = [VEReachability reachabilityForInternetConnection];
    if([lexiu currentReachabilityStatus] == VEReachabilityStatus_NotReachable && filterResourceURL.length>0){
        _loadFilterCallBack = callBack;
        _filterResourceURL = filterResourceURL;
        _netMaterialTypeURL = netMaterialTypeURL;
    }
    _globalFilters = [NSMutableArray array];
    _originalGlobalFilters = [NSMutableArray new];
    NSString *appKey = [VEConfigManager sharedManager].appKey;
    
    WeakSelf(self);
    if([lexiu currentReachabilityStatus] != VEReachabilityStatus_NotReachable && filterResourceURL.length>0)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            StrongSelf(self);
            _filtersName = [NSMutableArray array];
            _originalFiltersName = [NSMutableArray new];
            NSMutableDictionary *itemDic = [NSMutableDictionary dictionary];
            if(appKey.length > 0)
                [itemDic setObject:appKey forKey:@"appkey"];
            [itemDic setObject:@"" forKey:@"cover"];
            [itemDic setObject:VELocalizedString(@"原始", nil) forKey:@"name"];
            [itemDic setObject:@"1530073782429" forKey:@"timestamp"];
            [itemDic setObject:@"1530073782429" forKey:@"updatetime"];
            [_filtersName addObject:itemDic];
            [_originalFiltersName addObject:itemDic];
            
            Filter* filter = [Filter new];
            filter.type = kFilterTypeNone;
            filter.netCover = itemDic[@"cover"];
            filter.name = itemDic[@"name"];
            [_globalFilters addObject:filter];
            [_originalGlobalFilters addObject:filter];
            
            NSDictionary * dic = (NSDictionary*)[VEHelp classificationParams:VENetworkResourceType_Filter atAppkey: appKey atURl:netMaterialTypeURL];
            NSMutableDictionary *filterCollectionPlists1 = nil;
            if( !dic )
            {
                NSDictionary *filterList = [VEHelp getNetworkMaterialWithType:@"file"
                                                                                  appkey:appKey
                                                                                 urlPath:filterResourceURL];
                if ([filterList[@"code"] intValue] == 0) {
                    [_filtersName addObjectsFromArray:filterList[@"data"]];
                    [_originalFiltersName addObjectsFromArray:filterList[@"data"]];
                }
            } else
            {
                NSString *filterPath = kFilterFolder;
                if(![[NSFileManager defaultManager] fileExistsAtPath:filterPath]){
                    [[NSFileManager defaultManager] createDirectoryAtPath:filterPath withIntermediateDirectories:YES attributes:nil error:nil];
                }

                {
                    filterCollectionPlists1 = [NSMutableDictionary new];
                    [filterCollectionPlists1 setObject:@"showchang" forKey:@"id"];
                    [filterCollectionPlists1 setObject:VELocalizedString(@"Collect", nil) forKey:@"name"];
                    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:kFilterCollectionPlist];
                    if( array == nil )
                    {
                        array = [NSMutableArray new];
                    }
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        {
                            NSString *strPath = obj[@"cover"];
                            strPath = [VEHelp getFileURLFromAbsolutePath_str:strPath];
                            obj[@"cover"] = strPath;
                        }
                        {
                            NSString *strPath = obj[@"file"];
                            strPath = [VEHelp getFileURLFromAbsolutePath_str:strPath];
                            obj[@"file"] = strPath;
                        }
                    }];
                    [filterCollectionPlists1 setObject:array forKey:@"data"];
                }
                _filter_CollectionPlists = filterCollectionPlists1;

                _filter_newFilterSortArray = [NSMutableArray new];
                [_filter_newFilterSortArray addObjectsFromArray:(NSArray*)dic];
                _filter_newFiltersNameSortArray = [NSMutableArray new];
                
                for (int i = 0; i < _filter_newFilterSortArray.count; i++) 
                {
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setObject:VENetworkResourceType_Filter forKey:@"type"];
                    [params setObject:[_filter_newFilterSortArray[i] objectForKey:@"id"]  forKey:@"category"];
                    [params setObject:[NSString stringWithFormat:@"%d" ,0] forKey: @"page_num"];
                    NSDictionary *dic2 = [VEHelp getNetworkMaterialWithParams:params
                                                                                  appkey:appKey urlPath:filterResourceURL];
                    if(dic2 && [[dic2 objectForKey:@"code"] integerValue] == 0)
                    {
                        NSMutableArray * currentFilterList = [dic2 objectForKey:@"data"];
                        if( _filter_newFiltersNameSortArray )
                        {
                            [_filter_newFiltersNameSortArray addObject:currentFilterList];
                            [_filtersName addObjectsFromArray:currentFilterList];
                            [_originalFiltersName addObjectsFromArray:currentFilterList];
                        }
                        for (NSDictionary *filterDic in currentFilterList) {
                            Filter* filter = [Filter new];
                            NSString *itemPath = [VEHelp getFilterDownloadPathWithDic:filterDic];
                            if ([[[filterDic[@"file"] pathExtension] lowercaseString] isEqualToString:@"acv"]){
                                filter.type = kFilterType_ACV;
                            }else if ([[[filterDic[@"file"] pathExtension] lowercaseString] isEqualToString:@"zip"]) {
                                filter.type = kFilterType_Mosaic;
                            }
                            else if ([itemPath.pathExtension.lowercaseString isEqualToString:@"cube"]) {
                                filter.type = kFilterType_3D_Lut_Cube;
                            }
                            else {
                                filter.type = kFilterType_LookUp;
                            }
                            filter.filterPath = itemPath;
                            filter.networkCategoryId = [_filter_newFilterSortArray[i] objectForKey:@"id"];
                            filter.networkResourceId = filterDic[@"id"];
                            filter.netCover = filterDic[@"cover"];
                            filter.name = filterDic[@"name"];
                            if( _globalFilters )
                            {
                                [_globalFilters addObject:filter];
                                [_originalGlobalFilters addObject:filter];
                            }
                        }
                    }
                    
                }
            }
//            _originalGlobalFilters = [[NSMutableArray alloc] initWithArray:_globalFilters];
//            _originalFiltersName = [[NSMutableArray alloc] initWithArray:_filtersName];
            if( filterCollectionPlists1 )
            {
                NSMutableArray * currentFilterList = filterCollectionPlists1[@"data"];
                //                [_filter_newFiltersNameSortArrayy addObject:currentFilterList];
                if( _filtersName )
                    [_filtersName addObjectsFromArray:currentFilterList];
                for (NSDictionary *filterDic in currentFilterList) {
                    Filter* filter = [Filter new];
                    NSString *itemPath = [VEHelp getFilterDownloadPathWithDic:filterDic];
                    
                    if( [filterDic[@"file"] containsString:@"LocalFilterFldoer"] )
                        itemPath = filterDic[@"file"];
                    
                    filter.type = kFilterType_3D_Lut_Cube;
                    filter.filterPath = itemPath;
                    filter.networkCategoryId = [filterCollectionPlists1 objectForKey:@"id"];
                    filter.networkResourceId = filterDic[@"id"];
                    filter.netCover = filterDic[@"cover"];
                    filter.name = filterDic[@"name"];
                    if( _globalFilters )
                        [_globalFilters addObject:filter];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_filter_newFiltersNameSortArray.count > 0) {
                    if( callBack )
                    {
                        [VEFilters_EditView createGlobalFilters];
                        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:_globalFilters];
                        callBack( array );
                    }
                }
            });
        });
    }
}

- (void)setCurrentCustomFilter:(CustomFilter *)currentCustomFilter
{
    _currentCustomFilter = currentCustomFilter;
    if( _currentCustomFilter )
    {
        if (_currentCustomFilter.builtInType == BuiltInFilter_Mosaic) {
            _stripBtn.hidden = NO;
            _stripBtn.selected = _currentCustomFilter.isStrip;
        }
        int index = 0;
        int type = 120000;
        int indexType = 0;
        for (int i = 0; i < _filter_newFiltersNameSortArray.count; i++) {
            NSArray * array = (NSArray *)_filter_newFiltersNameSortArray[i];
            if( [_filter_newFilterSortArray[i][@"id"] isEqualToString:_currentCustomFilter.networkCategoryId] )
            {
                currentlabelFilter = i;
                for (int j = 0; j < array.count; j++) {
                    if( [array[j][@"id"]isEqualToString:_currentCustomFilter.networkResourceId] )
                    {
                        indexType = j;
                        type = i;
                        break;
                    }
                }
                break;
            }
            else
                index += array.count;
        }
        
        _selectFilterIndex = index + indexType + 1;
         
        if( _filterCollectionView )
        {
            NSInteger desiredSection = 0;
            if( type != 120000 )
            {
                desiredSection = type;
                NSArray * array = (NSArray *)_filter_CollectionPlists[@"data"];
                CGPoint targetOffset = CGPointMake( index * (collectionCellWidth+10.0)
                                                   + desiredSection * (35.0-10) - 35.0/2.0 - 3.0/2.0 + ( (collectionCellWidth+10) * indexType )
                                                   , 0.0);
                if( desiredSection == 0 )
                    targetOffset = CGPointMake( (collectionCellWidth+10) * indexType, 0.0);
                [_filterCollectionView setContentOffset:targetOffset animated:NO];
                _isSelect = true;
                [self filterLabelBtn:[_fileterLabelNewScroView viewWithTag:type]];
                _isSelect = NO;
            }
            else
            {
                [_filterCollectionView setContentOffset:CGPointMake( 0 , 0) animated:NO];
                _isSelect = true;
                [self filterLabelBtn:[_fileterLabelNewScroView viewWithTag:0]];
                _isSelect = NO;
            }
        }
        
        _filterProgressSlider.enabled = true;
        _filterProgressSlider.value = currentCustomFilter.lookUpFilterIntensity;
    }
}

- (instancetype)initWithFrame:(CGRect)frame atEditFilters:(BOOL) isEditFilters
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectFilterIndex = -1;
        _isEditFilters = isEditFilters;
        [self setClipsToBounds:YES];
        
        self.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : [VEConfigManager sharedManager].viewBackgroundColor;
        
    }
    return self;
}
- (void)setSelectFilterIndex:(NSInteger)selectFilterIndex{
    _selectFilterIndex = selectFilterIndex;
}
- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
}

- (ATMHud *)hud{
    if(!_hud){
        UIViewController * next = (UIViewController*)_delegate;
        ATMHud * atmHud = [[ATMHud alloc] initWithDelegate:nil];
        _hud = atmHud;
        [next.navigationController.view addSubview:_hud.view];
    }
    return _hud;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isEditFilters = false;
        _selectFilterIndex = -1;
        [self setClipsToBounds:YES];
        
        self.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : [VEConfigManager sharedManager].viewBackgroundColor;
        
    }
    return self;
}

-(void)initUI
{
    currentlabelFilter = 0;
    if( !_filter_newFilterSortArray )
    {
        if( [VEConfigManager sharedManager].iPad_HD )
        {
            _loadView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44 - kBottomSafeHeight)];
            [self addSubview:_loadView];
        }
        else if( self.istPutOnTopTitleBar )
        {
            _loadView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height - 44 - kBottomSafeHeight)];
            [self addSubview:_loadView];
        }
        else
        {
            _loadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - kToolbarHeight)];
            [self addSubview:_loadView];
        }
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( (_loadView.frame.size.width - 60)/2.0, (_loadView.frame.size.height - 60.0)/2.0, 60, 60)];
        imageView.tag = 201201;
        [imageView sd_setImageWithURL:[NSURL fileURLWithPath:[VEHelp getResourceFromBundle:@"VEPESDK" resourceName:@"/animatSchedule_@3x" Type:@"png"]]];
        [_loadView addSubview:imageView];
        VEReachability *lexiu = [VEReachability reachabilityForInternetConnection];
        if([lexiu currentReachabilityStatus] != VEReachabilityStatus_NotReachable){
            
        }
        else{
            [self.hud setCaption:VELocalizedString(@"请检查网络，网络连接失败！", nil)];
            [self.hud show];
            [self.hud hideAfter:1];
            [VEFilters_EditView loadFilterType:^(NSMutableArray * _Nonnull globalFilters) {
                if( _loadFilterCallBack )
                {
                    _loadFilterCallBack( globalFilters );
                }
            } atFilterResourceURL:_filterResourceURL atNetMaterialTypeURL:_netMaterialTypeURL];
        }
//        if(![VEConfigManager sharedManager].iPad_HD){
//            _filterChildsView           = [UIScrollView new];
//            
//            float height = 100;
//            _filterChildsView.frame     = CGRectMake(0,40 + ( (self.frame.size.height - kToolbarHeight - 40) - height )/2.0, self.frame.size.width, height);
//            if([VEConfigManager sharedManager].iPad_HD){
//                _filterChildsView.frame     = CGRectMake(0,0 + ( (self.frame.size.height - kToolbarHeight - 0) - height )/2.0, self.frame.size.width, height);
//            }
//            _filterChildsView.backgroundColor                   = [UIColor clearColor];
//            _filterChildsView.showsHorizontalScrollIndicator    = NO;
//            _filterChildsView.showsVerticalScrollIndicator      = NO;
//            if(!self.filterProgressSlider.superview)
//                [self addSubview:_filterProgressSlider ];
//            
//            [self addSubview:_filterChildsView];
//            [self initFilterChildsView];
//            
//            self.fileterScrollView.hidden = NO;
//            
//        }else{
//            UILabel *noDatalabel = [[UILabel alloc] init];
//            noDatalabel.frame = CGRectMake(0, 40 + ( self.frame.size.height - 40 - 20 )/2.0, self.frame.size.width, 20);
//            noDatalabel.textAlignment = NSTextAlignmentCenter;
//            noDatalabel.textColor = [TEXT_COLOR colorWithAlphaComponent:0.5];
//            noDatalabel.font = [UIFont systemFontOfSize:16];
//            noDatalabel.text = VELocalizedString(@"请检查网络，网络连接失败", nil);
//            [self addSubview:noDatalabel];
//        }
    }
    else{
        [self addSubview:self.fileterNewView];
        
        self.fileterScrollView.hidden = NO;
        
        if(!self.filterProgressSlider.superview)
            [self addSubview:_filterProgressSlider ];
        _filterStrengthLabel.hidden = YES;
        _percentageLabel.hidden =  YES;
        
        _filterStrengthLabel = [[UILabel alloc] init];
        _filterStrengthLabel.textAlignment = NSTextAlignmentLeft;
        _filterStrengthLabel.textColor = [UIColor whiteColor];
        _filterStrengthLabel.font = [UIFont systemFontOfSize:12];
        _filterStrengthLabel.text = VELocalizedString(@"滤镜强度", nil);
        _filterStrengthLabel.frame = CGRectMake(15, ([VEConfigManager sharedManager].iPad_HD ? (self.frame.size.height - 30): (CGRectGetMaxY(_fileterNewView.frame) + (self.frame.size.height - CGRectGetMaxY(_fileterNewView.frame) - kToolbarHeight - 20)/2.0)), 50, 20);
        _filterProgressSlider.frame = CGRectMake([VEConfigManager sharedManager].iPad_HD ? 75 : 85, _filterStrengthLabel.frame.origin.y - 5, self.frame.size.width - ([VEConfigManager sharedManager].iPad_HD ? (65 + 80) : 85*2.0), 30);
        if ([VEConfigManager sharedManager].iPad_HD) {
            _filterStrengthLabel.frame = CGRectMake(15, (self.frame.size.height - 30), 50, 20);
            _filterProgressSlider.frame = CGRectMake(110, _filterStrengthLabel.frame.origin.y - 5, self.frame.size.width - 170, 30);
            [self addSubview:_filterStrengthLabel];
        }else {

            float y = CGRectGetMaxY(_filterCollectionView.frame) + (self.frame.size.height - CGRectGetMaxY(_filterCollectionView.frame) - kToolbarHeight - 30)/2.0 + 5;
            
            if( self.istPutOnTopTitleBar )
            {
                y = 44 + CGRectGetMaxY(_filterCollectionView.frame);
                if( ( self.frame.size.height - y - kBottomSafeHeight  - 30.0)/2.0 < 0 )
                    y = y;
                else
                    y = y + ( self.frame.size.height - y - kBottomSafeHeight - 30.0)/2.0;
            }
            else if( self.isHiddenTitleBar )
            {
                float height = (self.frame.size.height - CGRectGetMaxY(_fileterNewView.frame) - 30.0);
                if( height>10 )
                    y = CGRectGetMaxY(_fileterNewView.frame) + height/2.0;
                else
                    y = CGRectGetMaxY(_fileterNewView.frame) + height;
            }
            
            _filterStrengthLabel.frame = CGRectMake(15, y, 50, 20);
            _filterProgressSlider.frame = CGRectMake(70, y - 5, self.frame.size.width - 70*2.0, 30);
        }

        if( -1 == _selectFilterIndex )
        {
            _filterProgressSlider.enabled = NO;
        }
        
        if( !self.isHiddenTitleBar )
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            _stripBtn = btn;
            _stripBtn.frame =CGRectMake([VEConfigManager sharedManager].iPad_HD ? (self.frame.size.width - 80) : 0, _filterProgressSlider.frame.origin.y, 70, 30);
            _stripBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [_stripBtn setTitle:VELocalizedString(@"条纹", nil) forState:UIControlStateNormal];
            [_stripBtn setTitle:VELocalizedString(@"条纹", nil) forState:UIControlStateHighlighted];
            [_stripBtn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            [_stripBtn setTitleColor:Main_Color forState:UIControlStateSelected];
            [_stripBtn setImage:[VEHelp imageNamed:@"条纹默认_"] forState:UIControlStateNormal];
            UIImage *selectedImage = [VEHelp imageNamed:@"条纹选中_"];
            selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [_stripBtn setImage:selectedImage forState:UIControlStateSelected];
            _stripBtn.imageView.tintColor = Main_Color;
            [_stripBtn addTarget:self action:@selector(stripBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            _stripBtn.selected = YES;
            _stripBtn.hidden = YES;
            [self addSubview:_stripBtn];
        }
    }
    
    if( !_finishBtn )
        [self initToolBarView];
    
    if( self.isHiddenTitleBar )
    {
        _barView.hidden = TRUE;
        
    }
}

-(void)useToAllBtnOnClick:(UIButton *) sender
{
    sender.selected = !sender.selected;
}

- (void)stripBtnAction:(UIButton *)sener {
    sener.selected = !sener.selected;
    self.isEditFilters = true;
    if (_delegate && [_delegate respondsToSelector:@selector(filterStrip:atView:)]) {
        [_delegate filterStrip:sener.selected atView:self];
    }
}

- (void)initFilterChildsView {
    [_globalFilters enumerateObjectsUsingBlock:^(Filter*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VEFileScrollViewChildItem *item   = [[VEFileScrollViewChildItem alloc] initWithFrame:CGRectMake(idx*(self.filterChildsView.frame.size.height - 15)+10, 0, (self.filterChildsView.frame.size.height - 25), self.filterChildsView.frame.size.height)];
        item.backgroundColor        = [UIColor clearColor];
        if(self.editConfiguration.filterResourceURL.length>0){
            if(idx == 0){
                //                NSString* bundlePath    = [[NSBundle bundleForClass:self.class] pathForResource: @"VideoRecord" ofType :@"bundle"];
                //                NSBundle *bundle        = [NSBundle bundleWithPath:bundlePath];
                NSBundle *bundle = [VEHelp getRecordBundle];
                NSString *filePath      = [bundle pathForResource:[NSString stringWithFormat:@"%@",@"原图"] ofType:@"png"];
                item.itemIconView.image = [VEHelp imageWithContentOfPath:filePath];
            }else{
                [item.itemIconView sd_setImageWithURL:[NSURL URLWithString:obj.netCover]];
            }
        }else{
            NSString *path = [VEHelp pathInCacheDirectory:@"filterImage"];
            if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
                [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *photoPath     = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"image%@.jpg",obj.name]];
            item.itemIconView.image = [VEHelp imageWithContentOfPath:photoPath];
        }
        item.fontSize       = 10;
        item.type           = 2;
        item.delegate       = self;
        item.selectedColor  = Main_Color;
        item.normalColor    = UIColorFromRGB(0x888888);
        item.cornerRadius   = item.frame.size.width/2.0;
        item.exclusiveTouch = YES;
        item.itemIconView.backgroundColor   = [UIColor clearColor];
        item.itemTitleLabel.text            = VELocalizedString(obj.name, nil);
        item.tag                            = idx + 1;
        item.itemTitleLabel.adjustsFontSizeToFitWidth = YES;
        [item setSelected:(idx == _selectFilterIndex ? YES : NO)];
        
        //        item.itemIconView.layer.cornerRadius = 5;
        //        item.itemIconView.layer.masksToBounds = YES;
        //        item.itemIconView.userInteractionEnabled = YES;
        [self.filterChildsView addSubview:item];
    }];
    _filterChildsView.contentSize = CGSizeMake(_globalFilters.count * (_filterChildsView.frame.size.height - 15)+20, _filterChildsView.frame.size.height);
    
    if( -1 == _selectFilterIndex )
    {
        _filterProgressSlider.enabled = NO;
    }
    
    UIImageView *image;
    image.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)filterLabelBtn:(UIButton *) btn
{
    UIButton *oldBtn = [_fileterLabelNewScroView viewWithTag:currentlabelFilter];
    
    [_fileterLabelNewScroView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIButton class]] && obj.tag != 100){
            ((UIButton*)obj).selected = NO;
        }
    }];
    
    NSInteger oldCurrentlabelFilter = currentlabelFilter;
    
    if( btn.tag != 120000 )
    {
        int index = 0;
        for (int i = 0; i < _filter_newFiltersNameSortArray.count; i++) {
            NSArray * array = (NSArray *)_filter_newFiltersNameSortArray[i];
            index += array.count;
            if( i == btn.tag )
            {
                currentlabelFilter = i;
                index -= array.count;
                currentFilterIndex = index;
                break;
            }
        }
    }
    else{
        currentlabelFilter = btn.tag;
    }
    
    self.fileterScrollView.hidden = NO;
    
    btn.selected = YES;
    
    float margin = _fileterLabelNewScroView.frame.origin.x / 2.0;
    CGFloat offSetX = btn.center.x - _fileterLabelNewScroView.bounds.size.width * 0.5 + margin;
    CGFloat offsetX1 = (_fileterLabelNewScroView.contentSize.width - btn.center.x) - _fileterLabelNewScroView.bounds.size.width * 0.5;
    CGPoint offset = CGPointZero;
    if (offSetX > 0 && offsetX1 > 0) {
        offset = CGPointMake(offSetX, 0);
    }
    else if(offSetX < 0){
        offset = CGPointZero;
    }
    else if (offsetX1 < 0){
        offset = CGPointMake(_fileterLabelNewScroView.contentSize.width - _fileterLabelNewScroView.bounds.size.width, 0);
    }
    
    [_fileterLabelNewScroView setContentOffset:offset animated:( (oldBtn.frame.origin.x > _fileterLabelNewScroView.contentOffset.x) || ( oldBtn.frame.origin.x <  (_fileterLabelNewScroView.contentOffset.x + _fileterLabelNewScroView.frame.size.width)) )?NO:YES];
    
    if( _filterCollectionView && ( !_isSelect ) )
    {
        NSInteger desiredSection = 0;
        if( btn.tag != 120000 )
        {
            desiredSection = btn.tag;
            NSArray * array = (NSArray *)_filter_CollectionPlists[@"data"];
            CGPoint targetOffset = CGPointMake( currentFilterIndex * (collectionCellWidth+10.0) + desiredSection * (35.0-10) - 35.0/2.0 - 3.0/2.0, 0.0);
            if( desiredSection == 0 )
                targetOffset = CGPointMake(0.0, 0.0);
            [_filterCollectionView setContentOffset:targetOffset animated:YES];
            if( oldCurrentlabelFilter == 120000 )
                [_filterCollectionView reloadData];
        }
        else
        {
            [_filterCollectionView setContentOffset:CGPointMake(0, 0) animated:false];
            [_filterCollectionView reloadData];
        }
    }
}

-(void)scrollViewIndex:(int) fileterindex
{
    __block int index = 0;
    for (int i = 0; i < _filter_newFiltersNameSortArray.count; i++) {
        NSArray * array = (NSArray *)_filter_newFiltersNameSortArray[i];
        index += array.count;
        if( fileterindex <= index )
        {
            currentlabelFilter = i;
            index -= array.count;
            currentFilterIndex = index;
            _selectFilterIndex = fileterindex;
            _filterProgressSlider.enabled = YES;
            break;
        }
    }
//    if( next.currentFilterFile.filters )
//    {
//        oldFilterStrength = next.currentFilterFile.filters.filterArray[0].lookUpFilterIntensity;
//    }
    if(_filterCollectionView){
        if(fileterindex == -1){
            [_fileterLabelNewScroView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if([obj isKindOfClass:[UIButton class]] && obj.tag == currentlabelFilter){
                     ((UIButton*)obj).selected = NO;
                     [self filterLabelBtn:obj];
                     *stop = YES;
                 }
            }];
            _filterProgressSlider.enabled = NO;
        }else{
            _filterProgressSlider.enabled = YES;
            [_fileterLabelNewScroView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if([obj isKindOfClass:[UIButton class]]){
                     ((UIButton*)obj).selected = obj.tag == currentlabelFilter;
                 }
            }];
            NSInteger selectIndex = MAX(_selectFilterIndex - currentFilterIndex,0);
            [_filterCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:selectIndex inSection:(currentlabelFilter + 1)] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
    }
}


-(UIView *)fileterNewView
{
    if( !_fileterNewView )
    {
        float x = 45*2.0/5.0 + 20;
        _fileterLabelNewScroView  = [[UIScrollView alloc] initWithFrame:CGRectMake(x, 0, self.frame.size.width - x, 45)];
        _fileterLabelNewScroView.tag = 1000;
        _fileterLabelNewScroView.showsVerticalScrollIndicator  =NO;
        _fileterLabelNewScroView.showsHorizontalScrollIndicator = NO;
        
        _fileterNewView = [[UIView alloc] initWithFrame:CGRectMake(0, ([VEConfigManager sharedManager].iPad_HD ? 0 : self.istPutOnTopTitleBar?44:0), self.frame.size.width, (self.frame.size.height  - (([VEConfigManager sharedManager].iPad_HD ? 0 : (kToolbarHeight + 40)))))];
        if( self.isHiddenTitleBar )
        {
            _fileterNewView.frame = CGRectMake(0, ([VEConfigManager sharedManager].iPad_HD ? 0 : 0), self.frame.size.width, (self.frame.size.height  - (([VEConfigManager sharedManager].iPad_HD ? 0 : 40))) );
        }
        
        [self addSubview:_fileterNewView];
        
        
        //        [self scrollViewIndex:_selectFilterIndex-1];
        
        float contentWidth = 0;

        if( _filter_CollectionPlists )
        {
            NSString *str = [_filter_CollectionPlists objectForKey:@"name"];
            float ItemBtnWidth = [VEHelp widthForString:str andHeight:12.0 fontSize:12.0] + 20;
            
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(contentWidth, 0, ItemBtnWidth, _fileterLabelNewScroView.frame.size.height)];
            btn.titleLabel.tag = 120001;
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            [btn setTitleColor:Main_Color forState:UIControlStateSelected];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                [btn setTitleColor:UIColorFromRGB(0x727272) forState:UIControlStateNormal];
                [btn setTitleColor:Main_Color forState:UIControlStateSelected];
            }
            [btn addTarget:self action:@selector(filterLabelBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            
            btn.tag = 120000;
            if( 120000 == currentlabelFilter )
            {
                btn.selected = YES;
            }
            contentWidth += ItemBtnWidth;
            [_fileterLabelNewScroView addSubview:btn];
        }

        
        for (int i = 0; _filter_newFilterSortArray.count > i; i++) {
            
            NSString *str = [_filter_newFilterSortArray[i] objectForKey:@"name"];
            
            float ItemBtnWidth = [VEHelp widthForString:str andHeight:16 fontSize:16] + 20;
            
            
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(contentWidth, 0, ItemBtnWidth, _fileterLabelNewScroView.frame.size.height)];
            btn.titleLabel.font = [UIFont systemFontOfSize:12.0];
            [btn setTitle:str forState:UIControlStateNormal];
            [btn setTitleColor:TEXT_COLOR forState:UIControlStateNormal];
            [btn setTitleColor:Main_Color forState:UIControlStateSelected];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                [btn setTitleColor:UIColorFromRGB(0x727272) forState:UIControlStateNormal];
                [btn setTitleColor:Main_Color forState:UIControlStateSelected];
            }
            [btn addTarget:self action:@selector(filterLabelBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            
            btn.tag = i;
            if( i == currentlabelFilter )
            {
                btn.selected = YES;
            }
            contentWidth += ItemBtnWidth;
            [_fileterLabelNewScroView addSubview:btn];
        }
        
        UIButton *noBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, (_fileterLabelNewScroView.frame.size.height - 44)/2.0, _fileterLabelNewScroView.frame.size.height*3.0/7.0 + 20, 44)];
        noBtn.backgroundColor = self.backgroundColor;
        [noBtn setImage:[VEHelp imageWithContentOfFile:@"New_EditVideo/scrollViewChildImage/剪辑_滤镜无默认_"] forState:UIControlStateNormal];
        [noBtn setImage:[VEHelp imageWithContentOfFile:@"New_EditVideo/scrollViewChildImage/剪辑_滤镜无选中_"] forState:UIControlStateSelected];
        if (_selectFilterIndex <= 0) {
            noBtn.selected = YES;
        }
        noBtn.tag = 100;
        [noBtn addTarget:self action:@selector(noBtn_onclik) forControlEvents:UIControlEventTouchUpInside];
        [_fileterNewView addSubview:noBtn];
        
        _fileterLabelNewScroView.contentSize = CGSizeMake(contentWidth+20, 0);
        
        float fileterNewScroViewHeight = CGRectGetHeight(_fileterNewView.frame) - 45;
        {
            _originalItem  = [[VEFileScrollViewChildItem alloc] initWithFrame:CGRectMake(10, 0, fileterNewScroViewHeight - 20, fileterNewScroViewHeight)];
            _originalItem.backgroundColor        = [UIColor clearColor];
            {
                _originalItem.itemIconView.backgroundColor = UIColorFromRGB(0x27262c);
                UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _originalItem.itemIconView.frame.size.width, _originalItem.itemIconView.frame.size.height)];
                label.text = VELocalizedString(@"无", nil);
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
                label.font = [UIFont systemFontOfSize:15.0];
                [_originalItem.itemIconView addSubview:label];
            }
            
            _originalItem.fontSize       = 10;
            _originalItem.type           = 2;
            _originalItem.delegate       = self;
            _originalItem.selectedColor  = Main_Color;
            _originalItem.normalColor    = [UIColor colorWithWhite:1.0 alpha:0.5];
            _originalItem.cornerRadius   = _originalItem.frame.size.width/2.0;
            _originalItem.exclusiveTouch = YES;
            //            _originalItem.itemIconView.backgroundColor   = [UIColor clearColor];
            _originalItem.itemTitleLabel.text            = VELocalizedString(@"无滤镜", nil);
            _originalItem.tag                            = 0 + 1;
            _originalItem.itemTitleLabel.adjustsFontSizeToFitWidth = YES;
            [_originalItem setSelected:(0 == _selectFilterIndex ? YES : NO)];
            [_originalItem setCornerRadius:5];
            //            [_fileterNewView addSubview:_originalItem];
        }
        //
        [_fileterNewView addSubview:_fileterLabelNewScroView];
        _fileterScrollView.hidden = NO;
    }
    return _fileterNewView;
}

-(void)noBtn_onclik
{
    [self scrollViewChildItemTapCallBlock:_originalItem];

    if( _currentScrollViewChildItem )
    {
        [_currentScrollViewChildItem setSelected:NO];
        _currentScrollViewChildItem = nil;
    }

}

-( void )setNewFilterChildsView:( bool ) isYES atTypeIndex:(NSInteger) tag
{
    
    for (UIView *subview in _fileterScrollView.subviews) {
        if( [subview isKindOfClass:[VEFileScrollViewChildItem class] ] )
            [(VEFileScrollViewChildItem*)subview setSelected:NO];
    }
    
    if( tag == 0 )
    {
        [_originalItem setSelected:isYES];
        return;
    }
}

-(UIScrollView *)fileterScrollView
{
    [self InitFilterCollectionView];
    return nil;
}

//滤镜进度条
- (VESlider *)filterProgressSlider{
    if(!_filterProgressSlider){
        //float height = ((self.frame.size.height - kToolbarHeight ) - 40) > 120 ? 120 : 90 ;
        
        _filterStrengthLabel = [[UILabel alloc] init];
        _filterStrengthLabel.frame = CGRectMake(15, ([VEConfigManager sharedManager].iPad_HD ? (self.frame.size.height - 30):  self.istPutOnTopTitleBar? ((self.frame.size.height - _filterCollectionView.frame.size.height - _filterCollectionView.frame.origin.y - kBottomSafeHeight - 20)/2.0 + CGRectGetMaxY(_filterCollectionView.frame) + CGRectGetMaxY(_fileterNewView.frame)) :((self.frame.size.width - 65 - 65 + 50 + 5 )/2.0)), 50, 20);
        _filterStrengthLabel.textAlignment = NSTextAlignmentLeft;
        _filterStrengthLabel.textColor = UIColorFromRGB(0xffffff);
        _filterStrengthLabel.font = [UIFont systemFontOfSize:12];
        _filterStrengthLabel.text = VELocalizedString(@"滤镜强度", nil);
        if ([VEConfigManager sharedManager].iPad_HD) {
            [self addSubview:_filterStrengthLabel];
        }
        
        _filterProgressSlider = [[VESlider alloc] initWithFrame:CGRectMake(70, _filterStrengthLabel.frame.origin.y + _filterStrengthLabel.frame.size.height + 10, self.frame.size.width - 63*2, 30)];
        [_filterProgressSlider setMaximumValue:1];
        [_filterProgressSlider setMinimumValue:0];
        [_filterProgressSlider setValue:oldFilterStrength];
        _filterProgressSlider.backgroundColor = [UIColor clearColor];
        [_filterProgressSlider addTarget:self action:@selector(filterscrub) forControlEvents:UIControlEventValueChanged];
        [_filterProgressSlider addTarget:self action:@selector(filterendScrub) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside)];
    
        if(_filter_newFilterSortArray  || ![VEConfigManager sharedManager].iPad_HD){
            _percentageLabel = [[UILabel alloc] init];
            _percentageLabel.frame = CGRectMake(self.frame.size.width - 55, CGRectGetMinY(_filterProgressSlider.frame) + 5, 50, 20);
            _percentageLabel.textAlignment = NSTextAlignmentCenter;
            _percentageLabel.textColor = [UIColor whiteColor];
            if([VEConfigManager sharedManager].toolsTitleColor){
                _percentageLabel.textColor = [VEConfigManager sharedManager].toolsTitleColor;
            }
            _percentageLabel.font = [UIFont systemFontOfSize:12];
            
            float percent = oldFilterStrength*100.0;
            _percentageLabel.text = [NSString stringWithFormat:@"%d", (int)percent];
            [self addSubview:_percentageLabel];
            
        }
        if( _selectFilterIndex == -1 )
        {
            _filterProgressSlider.enabled = NO;
        }
    }
    return _filterProgressSlider;
}
//滤镜强度 滑动进度条
- (void)filterscrub{
    CGFloat current = _filterProgressSlider.value;
    float percent = current*100.0;
    if( !_filter_newFilterSortArray )
        _percentageLabel.text = [NSString stringWithFormat:@"%d",(int)percent];
    else
    {
        _percentageLabel.hidden = NO;
        _percentageLabel.frame = CGRectMake(current*_filterProgressSlider.frame.size.width+_filterProgressSlider.frame.origin.x - _percentageLabel.frame.size.width/2.0, _filterProgressSlider.frame.origin.y - _percentageLabel.frame.size.height + 5, _percentageLabel.frame.size.width, _percentageLabel.frame.size.height);
        _percentageLabel.text = [NSString stringWithFormat:@"%d",(int)percent];
    }
    
    self.isEditFilters = true;
    if( _delegate && [_delegate respondsToSelector:@selector(filterIntensity:atView:)] )
    {
        [_delegate filterIntensity:current atView:self];
    }
}

- (void)filterendScrub{
    CGFloat current = _filterProgressSlider.value;
    float percent = current*100.0;
    if( !_filter_newFilterSortArray )
        _percentageLabel.text = [NSString stringWithFormat:@"%d",(int)percent];
    else
    {
        _percentageLabel.hidden = YES;
        _percentageLabel.frame = CGRectMake(current*_filterProgressSlider.frame.size.width+_filterProgressSlider.frame.origin.x - _percentageLabel.frame.size.width/2.0, _filterProgressSlider.frame.origin.y - _percentageLabel.frame.size.height + 5, _percentageLabel.frame.size.width, _percentageLabel.frame.size.height);
        _percentageLabel.text = [NSString stringWithFormat:@"%d",(int)percent];
    }

    self.isEditFilters = true;
    if( _delegate && [_delegate respondsToSelector:@selector(filterIntensity:atView:)] )
    {
        [_delegate filterIntensity:current atView:self];
    }
}

- (void)refreshFilterChildItem{
    __weak typeof(self) myself = self;
    [_globalFilters enumerateObjectsUsingBlock:^(Filter*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        VEFileScrollViewChildItem *item   = [myself.filterChildsView viewWithTag:(idx + 1)];
        item.backgroundColor        = [UIColor clearColor];
        if(!item.itemIconView.image){
            if(self.editConfiguration.filterResourceURL.length>0){
                if(idx == 0){
                    //                    NSString* bundlePath    = [[NSBundle bundleForClass:self.class] pathForResource: @"VideoRecord" ofType :@"bundle"];
                    //                    NSBundle *bundle        = [NSBundle bundleWithPath:bundlePath];
                    NSBundle *bundle = [VEHelp getRecordBundle];
                    NSString *filePath      = [bundle pathForResource:[NSString stringWithFormat:@"%@",@"原图"] ofType:@"png"];
                    item.itemIconView.image = [VEHelp imageWithContentOfPath:filePath];
                }else{
                    [item.itemIconView sd_setImageWithURL:[NSURL URLWithString:obj.netCover]];
                }
            }else{
                NSString *path = [VEHelp pathInCacheDirectory:@"filterImage"];
                if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
                    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
                }
                NSString *photoPath     = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"image%@.jpg",obj.name]];
                item.itemIconView.image = [VEHelp imageWithContentOfPath:photoPath];
            }
        }
    }];
}

#pragma mark- VEFileScrollViewChildItemDelegate  水印 配乐 变声 滤镜

- (void)scrollViewChildItem_Collection:( VEFileScrollViewChildItem * ) item
{
    if(item.type == 2)//MARK: 滤镜
    {
        NSMutableDictionary *filterObj = _filtersName[item.tag - 1];
        //        [filterObj setObject:@"" forKey:@"polyglot"];
//        [filterObj setObject:[NSString stringWithFormat:@"%d", currentlabelFilter] forKey:@"filtertType"];
        [filterObj setObject:[NSString stringWithFormat:@"%d", item.filterType] forKey:@"filtertType"];
        [filterObj setObject:[NSString stringWithFormat:@"%ld", item.tag - 2] forKey:@"filtertItemIndex"];
//        [filterObj setObject:[NSString stringWithFormat:@"%ld", currentFilterIndex] forKey:@"currentFilterIndex"];
        [filterObj setObject:[NSString stringWithFormat:@"%ld", item.filterTypeCount] forKey:@"currentFilterIndex"];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if( ((NSArray*)_filter_CollectionPlists[@"data"]).count > 0 )
        {
            [array addObjectsFromArray:((NSArray*)_filter_CollectionPlists[@"data"])];
        }
        
        __block BOOL isCollection = true;
        __block NSMutableDictionary *removeObj = nil;
        [array enumerateObjectsUsingBlock:^(NSMutableDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if( [obj[@"id"] length] > 0 && [obj[@"id"] isEqualToString:filterObj[@"id"]] )
            {
                removeObj = obj;
                isCollection = false;
                *stop = true;
            }
        }];
        
        BOOL isAdd = true;
        if( isCollection )
        {
            item.isSelectCollection = true;
            [array addObject:filterObj];
        }
        else
        {
            item.isSelectCollection = NO;
            [array removeObject:removeObj];
            isAdd = false;
        }
        
        NSMutableDictionary * filterCollectionPlists = _filter_CollectionPlists;
        [filterCollectionPlists setObject:array forKey:@"data"];
        
        //        [NSMutableDictionary new];
        //        [filterCollectionPlists setObject:@"showchang" forKey:@"id"];
        //        [filterCollectionPlists setObject:VELocalizedString(@"收藏", nil) forKey:@"name"];
        //        [filterCollectionPlists setObject:[NSMutableDictionary arra] forKey:@"data"];
        BOOL success = [array writeToFile:kFilterCollectionPlist atomically:NO];
        if (!success) {
            NSLog(@"保存失败");
        }
        _filter_CollectionPlists = filterCollectionPlists;
        
        [VEFilters_EditView createGlobalFilters];
        if( currentlabelFilter == 120000 )
        {
            self.fileterScrollView.hidden = NO;
        }
        
        if( isCollection )
        {
            [self.hud setCaption:VELocalizedString(@"收藏成功", nil)];
            [self.hud show];
            [self.hud hideAfter:1];
        }
        else
        {
            [self.hud setCaption:VELocalizedString(@"已取消收藏", nil)];
            [self.hud show];
            [self.hud hideAfter:1];
        }
    }
}


- (void)scrollViewChildItemTapCallBlock:(VEFileScrollViewChildItem *)item{
    _filterProgressSlider.enabled = YES;
    if( (item.tag - 1) >= (_globalFilters.count) )
    {
        [self.hud setCaption:VELocalizedString(@"该滤镜还未加载成功！", nil)];
        [self.hud show];
        [self.hud hideAfter:1];
        return;
    }
    
    if(item.type == 2){//MARK: 滤镜
        if(self.editConfiguration.filterResourceURL.length>0){
            NSDictionary *obj = _filtersName[item.tag - 1];
            if(item.tag-1 == 0){
                [item setSelected:YES];
                UIButton *noBtn = [_fileterNewView viewWithTag:100];
                noBtn.selected = YES;
                
                _selectFilterIndex = item.tag-1;
                //滤镜强度
                [_filterProgressSlider setValue:0.0];
                _filterProgressSlider.enabled = NO;
                
                _percentageLabel.text = @"0";
                _filterStrength = 0.0;
                _stripBtn.hidden = YES;
                
                if( _currentCustomFilter  )
                {
                    self.isEditFilters = true;
                    if( _delegate && [_delegate respondsToSelector:@selector(cancelCustomFilter:atView:)] )
                    {
                        [_delegate cancelCustomFilter:_currentCustomFilter atView:self];
                    }
                    _currentCustomFilter = nil;
                }
                return ;
            }
            
            NSString *itemPath = [VEHelp getFilterDownloadPathWithDic:obj];
            if([[NSFileManager defaultManager] fileExistsAtPath:itemPath]){
                if( _fileterScrollView )
                {
                    [self setNewFilterChildsView:NO atTypeIndex:_selectFilterIndex];
                }else{
                    [((VEFileScrollViewChildItem *)[_filterChildsView viewWithTag:_selectFilterIndex+1]) setSelected:NO];
                }

                if( _currentScrollViewChildItem )
                {
                    [_currentScrollViewChildItem setSelected:NO];
                    _currentScrollViewChildItem = nil;
                }
                _currentScrollViewChildItem = item;
                _selectFilterIndex = item.tag -1;

                
                [item setSelected:YES];
                UIButton *noBtn = [_fileterNewView viewWithTag:100];
                noBtn.selected = NO;
                
                if ([item.superview isKindOfClass:[UIScrollView class]] && ![VEConfigManager sharedManager].iPad_HD) {
                    UIButton *itemBtn = item;
                    UIScrollView *scrollView = (UIScrollView *)itemBtn.superview;
                    float margin = scrollView.frame.origin.x / 2.0;
                    CGFloat offSetX = itemBtn.center.x - scrollView.bounds.size.width * 0.5 + margin;
                    CGFloat offsetX1 = (scrollView.contentSize.width - itemBtn.center.x) - scrollView.bounds.size.width * 0.5;
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
                
                _selectFilterIndex = item.tag-1;
                _filterProgressSlider.enabled = YES;
                //滤镜强度
                [_filterProgressSlider setValue:1.0];
                _percentageLabel.text = @"100";
                _filterStrength = 1.0;
                
                Filter *filter = _globalFilters[_selectFilterIndex];
                if (itemPath.pathExtension.length == 0) {
                    NSString *configPath = [VEHelp getConfigPathWithFolderPath:itemPath];
                    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
                    NSMutableDictionary *configDic = [VEHelp objectForData:jsonData];
                    jsonData = nil;
                    NSString *builtIn = configDic[@"builtIn"];
                    if (builtIn.length > 0) {
                        if ([builtIn isEqualToString:@"MosaicPixel"]) {//马赛克
                            filter.type = kFilterType_Mosaic;
                            filter.intensity = [configDic[@"intensity"] floatValue];
                            _stripBtn.selected = [configDic[@"strip"] boolValue];
                            _stripBtn.hidden = NO;
                            //滤镜强度
                            [_filterProgressSlider setValue:filter.intensity];
                            _percentageLabel.text = [NSString stringWithFormat:@"%d",(int)(filter.intensity*100.0)];
                            _filterStrength = filter.intensity;
                        }
                    }
                }else {
                    _stripBtn.hidden = YES;
                }
                
                _filterProgressSlider.hidden = NO;
                [_filterProgressSlider setEnabled:YES];
                [_filterProgressSlider setValue:1.0];
                
                if( _currentCustomFilter  )
                {
                    if( _delegate && [_delegate respondsToSelector:@selector(cancelCustomFilter:atView:)] )
                    {
                        [_delegate cancelCustomFilter:_currentCustomFilter atView:self];
                    }
                    _currentCustomFilter = nil;
                }
                
                _currentCustomFilter = [CustomFilter new];
                _currentCustomFilter.networkCategoryId = filter.networkCategoryId;
                _currentCustomFilter.networkResourceId = filter.networkResourceId;
                _currentCustomFilter.name =  item.titleLabel.text;
                _currentCustomFilter.path = filter.filterPath;
                _currentCustomFilter.overlayType =  CustomFilterOverlayTypeVirtualVideo;
                switch (filter.type) {
                    case kFilterType_LookUp:
                        _currentCustomFilter.builtInType = BuiltInFilter_lookUp;
                        break;
                    case  kFilterType_3D_Lut_Cube:
                        _currentCustomFilter.builtInType = BuiltInFilter_3D_Lut_Cube;
                        break;
                    case  kFilterType_Mosaic:
                        _currentCustomFilter.builtInType = BuiltInFilter_Mosaic;
                        break;
                    default:
                        break;
                }
                
                _currentCustomFilter.lookUpFilterIntensity = 1.0;
                _currentCustomFilter.isStrip = NO;
                
                if (itemPath.pathExtension.length == 0) {
                    NSString *configPath = [itemPath stringByAppendingPathComponent:@"filter/config.json"];
                    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:configPath];
                    NSMutableDictionary *configDic = [VEHelp objectForData:jsonData];
                    jsonData = nil;
                    NSString *builtIn = configDic[@"builtIn"];
                    if (builtIn.length > 0) {
                        if ([builtIn isEqualToString:@"MosaicPixel"]) {//马赛克
                            _currentCustomFilter.builtInType = BuiltInFilter_Mosaic;
                            _currentCustomFilter.lookUpFilterIntensity = [configDic[@"intensity"] floatValue];
                            _currentCustomFilter.isStrip = true;
                            _stripBtn.selected = [obj[@"strip"] boolValue];
                            if( _stripBtn.selected )
                            {
                                _stripBtn.imageView.tintColor = PESDKMain_Color;
                            }
                            else
                                _stripBtn.imageView.tintColor = PESDKTEXT_COLOR;
                            _stripBtn.hidden = NO;
                            //滤镜强度
                            [_filterProgressSlider setValue:filter.intensity];
                            _filterStrengthLabel.hidden = YES;
                        }
                    }
                    else{
                        _stripBtn.hidden = YES;
                        _filterStrengthLabel.hidden = NO;
                    }
                }
                else{
                    _stripBtn.hidden = YES;
                    _filterStrengthLabel.hidden = NO;
                }
                _currentCustomFilter.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(KPICDURATION, TIMESCALE));
                self.isEditFilters = true;
                if( _delegate && [_delegate respondsToSelector:@selector(addCustomFilter:atView:)] )
                {
                    [_delegate addCustomFilter:_currentCustomFilter atView:self];
                }
                return;
            }
            
            if( item.downloading )
                return;
            
            UILabel * ddprogress = [VEHelp loadProgressView:item.bounds];
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                ddprogress.textColor = UIColorFromRGB(0xffffff);
            }
            if([VEConfigManager sharedManager].iPad_HD){
                ddprogress = [VEHelp loadCircleProgressView:item.bounds];
            }
            item.downloading = YES;
            if( _fileterScrollView )
            {
                [self setNewFilterChildsView:NO atTypeIndex:_selectFilterIndex];
            }else{
                [((VEFileScrollViewChildItem *)[_filterChildsView viewWithTag:_selectFilterIndex+1]) setSelected:NO];
            }
            [item addSubview:ddprogress];
            if([ddprogress isKindOfClass:[UILabel class]]){
                ddprogress.text = [NSString stringWithFormat:@"%d%%",(int)(0.0*100)];
            }else{
                [((VECircleView *)[ddprogress viewWithTag:10]) setPercent:0.0];
            }
            WeakSelf(self);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                VEDownTool *tool = [[VEDownTool alloc] initWithURLPath:obj[@"file"] savePath:itemPath];
                tool.Progress = ^(float numProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if( (numProgress >= 0.0) && (numProgress <= 1.0)   )
                        {
                            if([ddprogress isKindOfClass:[UILabel class]]){
                                ddprogress.text = [NSString stringWithFormat:@"%d%%",(int)(numProgress*100)];
                            }else{
                                [((VECircleView *)[ddprogress viewWithTag:10]) setPercent:numProgress];
                            }
                        }
                    });
                };
                tool.Finish = ^(NSString *cachePath) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        StrongSelf(self);
                        if ([[cachePath pathExtension] isEqualToString:@"zip"]) {
                            [VEHelp OpenZip:cachePath unzipto:[cachePath stringByDeletingLastPathComponent]];
                        }
                        [ddprogress removeFromSuperview];
                        item.downloading = NO;
                        if([strongSelf downLoadingFilterCount]>=1){
                            return ;
                        }
                        Filter *filter = _globalFilters[item.tag - 1];
                        filter.filterPath = [VEHelp getFilterDownloadPathWithDic:obj];
                        _originalGlobalFilters[item.tag - 1] = filter;
                        [strongSelf scrollViewChildItemTapCallBlock:item];
                    });
                };
                [tool start];
            });
        }else{
            
            if( (_globalFilters == nil) || (_globalFilters.count <= _selectFilterIndex) )
            {
                return;
            }
            
            if( _fileterScrollView )
            {
                [self setNewFilterChildsView:NO atTypeIndex:_selectFilterIndex];
            }
            else{
                [((VEFileScrollViewChildItem *)[_filterChildsView viewWithTag:_selectFilterIndex+1]) setSelected:NO];
            }
            [item setSelected:YES];
            _selectFilterIndex = item.tag-1;
            
            if( -1 == _selectFilterIndex )
                _filterProgressSlider.enabled = NO;
            else
                _filterProgressSlider.enabled = YES;
            
            //滤镜强度
            [_filterProgressSlider setValue:1.0];
            _percentageLabel.text = @"100";
            _filterStrength = 1.0;
            Filter *filter = _globalFilters[_selectFilterIndex];
            
//            if( next.currentFilterFile.filters )
//            {
//                [next.customMultipleFilterArray removeObject:next.currentFilterFile.filters];
//                next.currentFilterFile.filters = nil;
//            }
//            
//            next.filterTime = next.videoCoreSDK.currentTime;
//            next.filterTimeRange = CMTimeRangeMake(next.filterTime,  CMTimeMakeWithSeconds(1.0, TIMESCALE));
            
//            if( !next.currentFilterFile.filters   )
//            {
//                next.currentFilterFile.filters =  [CustomMultipleFilter new];
//                next.currentFilterFile.filters.overlayType = CustomFilterOverlayTypeVirtualVideo;
//                next.currentFilterFile.filters.filterArray = [NSMutableArray new];
//                [next.currentFilterFile.filters.filterArray addObject:[CustomFilter new]];
//                next.currentFilterFile.filters.filterArray[0].overlayType = CustomFilterOverlayTypeVirtualVideo;
//            }
//            next.currentFilterFile.filters.networkCategoryId = filter.networkCategoryId;
//            next.currentFilterFile.filters.networkResourceId = filter.networkResourceId;
//            next.currentFilterFile.filters.filterArray[0].networkCategoryId = filter.networkCategoryId;
//            next.currentFilterFile.filters.filterArray[0].networkResourceId = filter.networkResourceId;
//            next.currentFilterFile.filters.filterArray[0].name = item.itemTitleLabel.text;
//            next.currentFilterFile.filters.filterArray[0].path = filter.filterPath;
//            next.currentFilterFile.filters.filterArray[0].builtInType = BuiltInFilter_lookUp;
//            next.currentFilterFile.filters.filterArray[0].lookUpFilterIntensity = 1.0;
//            next.currentFilterFile.filters.timeRange = next.filterTimeRange;
//            
//            [next.customMultipleFilterArray addObject:next.currentFilterFile.filters];
//            
//            [next refreshCustomFilterArray];
            
//            if(![next.videoCoreSDK isPlaying]){
//#if 1
//                [next refreshCurrentFrame];
//
//                [next.videoCoreSDK seekToTime:next.filterTime toleranceTime:kCMTimeZero completionHandler:^(BOOL finished) {
//                    if (!next.videoCoreSDK.isPlaying)
//                        [next playVideo:YES];
//                }];
//
//            }
        }
    }
    
    
}

/**检测有多少个Filter正在下载
 */
- (NSInteger)downLoadingFilterCount{
    __block int count = 0;
    [_filterChildsView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[VEFileScrollViewChildItem class]]){
            if(((VEFileScrollViewChildItem *)obj).downloading){
                count +=1;
            }
        }
    }];
    return count;
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([VEConfigManager sharedManager].iPad_HD){
        return;
    }
    if( scrollView == _fileterScrollView )
    {
        if( _fileterScrollView.contentOffset.x > (_fileterScrollView.contentSize.width - _fileterScrollView.frame.size.width + KScrollHeight) )
        {
            if(  currentlabelFilter <  (_filter_newFiltersNameSortArray.count - 1)  )
            {
                for (UIView *subview in _fileterScrollView.subviews) {
                    if( [subview isKindOfClass:[VEFileScrollViewChildItem class] ] )
                    {
                        ((VEFileScrollViewChildItem*)subview).itemIconView.image = nil;
                        [((VEFileScrollViewChildItem*)subview) removeFromSuperview];
                    }
                }
                [_fileterScrollView removeFromSuperview];
                _fileterScrollView = nil;
                
                _fileterScrollView.delegate = nil;
                [self filterLabelBtn:[_fileterLabelNewScroView viewWithTag:currentlabelFilter+1]];
            }
            else if( 120000 == currentlabelFilter )
            {
                [_fileterScrollView removeFromSuperview];
                _fileterScrollView = nil;
                _fileterScrollView.delegate = nil;
                [self filterLabelBtn:[_fileterLabelNewScroView viewWithTag:0]];
            }
        }
        else if(  _fileterScrollView.contentOffset.x < - KScrollHeight )
        {
            if( (currentlabelFilter > 0) && ( currentlabelFilter != 120000 ) )
            {
                for (UIView *subview in _fileterScrollView.subviews) {
                    if( [subview isKindOfClass:[VEFileScrollViewChildItem class] ] )
                    {
                        ((VEFileScrollViewChildItem*)subview).itemIconView.image = nil;
                        [((VEFileScrollViewChildItem*)subview) removeFromSuperview];
                    }
                }
                [_fileterScrollView removeFromSuperview];
                _fileterScrollView = nil;
                
                _fileterScrollView.delegate = nil;
                [self filterLabelBtn:[_fileterLabelNewScroView viewWithTag:currentlabelFilter-1]];
            }
            else if( currentlabelFilter == 0 )
            {
                [_fileterScrollView removeFromSuperview];
                _fileterScrollView = nil;
                _fileterScrollView.delegate = nil;
                [self filterLabelBtn:[_fileterLabelNewScroView viewWithTag:120000]];
            }
        }
    }

    else if( scrollView == _filterCollectionView && (currentlabelFilter != 120000) )
    {
        float offsetX = scrollView.contentOffset.x;
        int index = 0;
        BOOL isSelectCollection = false;
        
        {
            for (int i = 0;  i < _filter_newFiltersNameSortArray.count; i++) {
                NSArray * array = (NSArray *)_filter_newFiltersNameSortArray[i];
                index += array.count;
                float targetOffsetX = index * (collectionCellWidth+10.0)
                + i * (35.0-10) - 3.0 - 10.0 + 35.0/2.0;
                if( targetOffsetX > offsetX  )
                {
                    if( currentlabelFilter != i )
                    {
                        _isSelect = true;
                        [self filterLabelBtn:[_fileterLabelNewScroView viewWithTag:i]];
                        _isSelect = false;
                    }
                    isSelectCollection = true;
                    break;
                }
            }
            
            if( !isSelectCollection )
            {
                _isSelect = true;
                [self filterLabelBtn:[_fileterLabelNewScroView viewWithTag:_filter_newFiltersNameSortArray.count - 1]];
                _isSelect = false;
            }
        }
    }

}

- (void)initToolBarView{
   UIView *toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, ([VEConfigManager sharedManager].iPad_HD ? 0 : self.istPutOnTopTitleBar?0:(self.frame.size.height - kToolbarHeight)), self.frame.size.width, ([VEConfigManager sharedManager].iPad_HD ? 0 : 44))];
    _barView = toolBarView;
//    toolBarView.backgroundColor = [VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : [VEConfigManager sharedManager].viewBackgroundColor;//VIEW_COLOR;
    [self addSubview:toolBarView];
    
    if( !self.isCloseTitle )
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, toolBarView.frame.size.width - 50 * 2.0, 44)];
        [toolBarView addSubview:label];
        label.text = VELocalizedString(@"滤镜", nil);
        label.textColor =  [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(CGRectGetWidth(toolBarView.frame) - 49, 0, 44, 44);
    [finishBtn setImage:[VEHelp imageNamed:([VEConfigManager sharedManager].iPad_HD ? @"ipad/剪辑_勾_" : @"剪辑_勾_")] forState:UIControlStateNormal];
    [finishBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.tag = -1000;
    _finishBtn = finishBtn;
    if(![VEConfigManager sharedManager].iPad_HD){
        [toolBarView addSubview:finishBtn];
        [VEHelp animateView:toolBarView atUP:NO];
    }else{
        [self.superview addSubview:finishBtn];
    }
    if( !self.isShowCloseBtn )
    {
        UIButton * toobarCanvasCancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [toobarCanvasCancelBtn setImage:[VEHelp imageNamed:@"剪辑_叉_"] forState:UIControlStateNormal];
        [toobarCanvasCancelBtn addTarget:self action:@selector(filters_back) forControlEvents:UIControlEventTouchUpInside];
        [toolBarView addSubview:toobarCanvasCancelBtn];
        _otherBtn = toobarCanvasCancelBtn;
    }
    UILabel *ImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,self.istPutOnTopTitleBar?(toolBarView.frame.size.height - 1.0/[UIScreen mainScreen].scale):0, self.frame.size.width, 1.0/[UIScreen mainScreen].scale)];
    ImageLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [toolBarView addSubview:ImageLabel];
    
}

-(void)filters_back
{
    if( !self.isCloseAnimation )
    {
        CGRect rect = self.frame;
        __weak typeof(self) wSelf = self; //防止循环引用
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.25 animations:^{
            wSelf.frame = CGRectMake(rect.origin.x, rect.size.height + rect.origin.y, rect.size.width, 0);
        } completion:^(BOOL finished) {
            //        [wSelf removeFromSuperview];
            if( wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(FilterClose_View:)] )
            {
                [wSelf.delegate FilterClose_View:wSelf];
            }
        }];
    }
    else{
        if( self.delegate && [self.delegate respondsToSelector:@selector(FilterClose_View:)] )
        {
            [self.delegate FilterClose_View:self];
        }
    }
}

-(void)save
{
    if( _hud )
    {
        [_hud removeFromParentViewController];
        _hud = nil;
    }
    if( !self.isCloseAnimation )
    {
        CGRect rect = self.frame;
        __weak typeof(self) wSelf = self; //防止循环引用
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.25 animations:^{
            if([VEConfigManager sharedManager].iPad_HD){
                wSelf.frame = CGRectMake(rect.origin.x + rect.size.width, rect.origin.y, 0, rect.size.height);
            }else{
                wSelf.frame = CGRectMake(rect.origin.x, rect.size.height + rect.origin.y, rect.size.width, 0);
            }
        } completion:^(BOOL finished) {
            if( wSelf.isEditFilters || ( self.isShowCloseBtn ) )
            {
                if( wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(Filters_finish_Btn:)] )
                {
                    [wSelf.delegate Filters_finish_Btn:self];
                }
            }
            else{
                if( wSelf.delegate && [wSelf.delegate respondsToSelector:@selector(FilterClose_View:)] )
                {
                    [wSelf.delegate FilterClose_View:self];
                }
            }
            //        [wSelf removeFromSuperview];
        }];
    }
    else{
        if( self.isEditFilters || ( self.isShowCloseBtn ) )
        {
            if( self.delegate && [self.delegate respondsToSelector:@selector(Filters_finish_Btn:)] )
            {
                [self.delegate Filters_finish_Btn:self];
            }
        }
        else{
            if( self.delegate && [self.delegate respondsToSelector:@selector(FilterClose_View:)] )
            {
                [self.delegate FilterClose_View:self];
            }
        }
    }
}
- (void)dealloc{
    
    [_filterChildsView removeFromSuperview];
    [_filterProgressSlider removeFromSuperview];
    [_percentageLabel removeFromSuperview];
    
    //新滤镜
    [_fileterNewView removeFromSuperview];
    [_fileterLabelNewScroView removeFromSuperview];
    
    [_fileterScrollView removeFromSuperview];
    [_originalItem removeFromSuperview];
    
    [_filterStrengthLabel removeFromSuperview];
    
    [_filterCollectionView removeFromSuperview];
    
    _filterCollectionView = nil;
    _filterChildsView = nil;
    _filterProgressSlider = nil;
    _percentageLabel = nil;
    //新滤镜
    _fileterNewView = nil;
    _fileterLabelNewScroView = nil;
    _fileterScrollView = nil;
    _originalItem = nil;
    _filterStrengthLabel = nil;
}

#pragma mark- 本地cube
-(void)cubeBtn_onclik
{
    if( !_isLocalCube )
    {
        _isLocalCube = true;
        [self addCubeFromFileApp];
    }
}

- (void)addCubeFromFileApp {
    NSArray *documentTypes = @[ @"public.content",@"public.data"];
    
    UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeImport];
    documentPickerViewController.allowsMultipleSelection = YES;
    documentPickerViewController.delegate = self;
    [[VEHelp getCurrentViewController] presentViewController:documentPickerViewController animated:YES completion:nil];
}
// "文件" 取消
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller {
    // 在这里处理取消回调的逻辑
    _isLocalCube = false;
}
//“文件”app选择文件后代理
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    
    NSMutableArray *collectionPlists = _filter_CollectionPlists[@"data"];
    
    UIImage *image =[VEHelp imageWithContentOfFile:@"New_EditVideo/scrollViewChildImage/剪辑_滤镜本地原始图默认_@3x"];
    if(![[NSFileManager defaultManager] fileExistsAtPath:kFilterCubeLocalFloder]){
        [[NSFileManager defaultManager] createDirectoryAtPath:kFilterCubeLocalFloder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    BOOL isSave = false;
    for (NSURL *url in urls) {
        if( [[url absoluteString] containsString:@".cube"] )
        {
            NSString *strPath = [url absoluteString];
            strPath = [[VEHelp getCubeLocalFloderPath:kFilterCubeLocalFloder fileName:[NSString stringWithFormat:@"cube_%@.cube", [strPath pathExtension]]] absoluteString];
            strPath = [VEHelp getFileURLFromAbsolutePath_str:strPath];
            for ( NSDictionary *dic in collectionPlists ) {
                if( [dic[@"type"] isEqualToString:@"filter_LocalCube"] && ( [dic[@"file"] isEqualToString:strPath] ) )
                {
                    isSave = true;
                    break;
                }
            }
            if( !isSave )
            {
                NSURL *urlPath = [VEHelp getCubeLocalFloderPath:kFilterCubeLocalFloder fileName:[NSString stringWithFormat:@"cube_%@.cube", [strPath pathExtension]]];
                NSError *error = nil;
                NSData *fileData = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
                if (error) {
                    // 处理文件拷贝失败的情况
                    [VEWindow showMessage:VELocalizedString(@"cube滤镜添加失败！", nil) duration:2.0];
                    _isLocalCube = false;
                    if( _filterCore )
                    {
                        [_filterCore stop];
                        _filterCore = nil;
                    }
                    _filterUrl = nil;
                } else {
                    BOOL success = [fileData writeToURL:urlPath atomically:YES];
                    if (success) {
                        fileData = nil;
                        NSLog(@"File saved successfully.");
                        // 文件拷贝成功
                        _filterUrl = urlPath;
                        _filterCore = [VEHelp createFIlterImageCore:url];
                        _filterCore.delegate = self;
                        [_filterCore build];
                        return;
                    } else {
                        // 处理文件拷贝失败的情况
                        [VEWindow showMessage:VELocalizedString(@"cube滤镜添加失败！", nil) duration:2.0];
                        _isLocalCube = false;
                        if( _filterCore )
                        {
                            [_filterCore stop];
                            _filterCore = nil;
                        }
                        _filterUrl = nil;
                    }
                }
            }
            else
            {
                [VEWindow showMessage:VELocalizedString(@"该cube滤镜已经添加！", nil) duration:2.0];
                _isLocalCube = false;
                if( _filterCore )
                {
                    [_filterCore stop];
                    _filterCore = nil;
                }
                _filterUrl = nil;
            }
        }
        else{
            [VEWindow showMessage:VELocalizedString(@"本地cube滤镜只支持cube文件！", nil) duration:2.0];
            _isLocalCube = false;
            if( _filterCore )
            {
                [_filterCore stop];
                _filterCore = nil;
            }
            _filterUrl = nil;
        }
    }
}

#pragma mark- VECore filters
- (void)statusChanged:(VECore *)sender status:(VECoreStatus)status
{
    if( ( sender.status == kVECoreStatusReadyToPlay ) && (sender == _filterCore) && ( _filterUrl ) )
    {
        WeakSelf(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            StrongSelf(self);
            NSMutableArray *collectionPlists = _filter_CollectionPlists[@"data"];
            
            CGImageRef cgImage = [strongSelf->_filterCore copyCurrentCGImage];
            UIImage *filterImage = [UIImage imageWithCGImage:cgImage];
            
            if( filterImage )
            {
                [collectionPlists addObject:[VEHelp createFilterDictionaryWithImage:filterImage atFilterUrl:strongSelf->_filterUrl atCollectionPlistsCount:collectionPlists.count atFilterTypeIndex:_globalFilters.count - collectionPlists.count]];
//                [_filtersName addObject:collectionPlists[collectionPlists.count-1]];
//                {
//                    Filter* filter = [Filter new];
//                    NSString *itemPath = collectionPlists[collectionPlists.count-1][@"file"];
//                    filter.type = kFilterType_3D_Lut_Cube;
//                    filter.filterPath = itemPath;
//                    filter.networkCategoryId = [ _filter_CollectionPlists objectForKey:@"id"];
//                    filter.networkResourceId = collectionPlists[collectionPlists.count-1][@"id"];
//                    filter.netCover = collectionPlists[collectionPlists.count-1][@"cover"];
//                    filter.name = collectionPlists[collectionPlists.count-1][@"name"];
//                    [_globalFilters addObject:filter];
//                }
                NSError *error = nil;
                BOOL success = [collectionPlists writeToFile:kFilterCollectionPlist atomically:NO];
                if (!success) {
                    NSLog(@"保存失败，错误信息：%@", error);
                }
                strongSelf->_isRefreshFilter = true;
                [VEWindow showMessage:VELocalizedString(@"Collection successful", nil) duration:1.0];

                float filterScrollViewConteOffsetX = strongSelf->_filterCollectionView.contentOffset.x;

                strongSelf.fileterScrollView.hidden = NO;

                strongSelf->_filterCollectionView.contentOffset = CGPointMake(filterScrollViewConteOffsetX + strongSelf->collectionCellWidth + 10, 0);

            }
            else{
                [VEWindow showMessage:VELocalizedString(@"滤镜效果图获取失败！", nil) duration:1.0];
                [[NSFileManager defaultManager] removeItemAtURL:strongSelf->_filterUrl error:nil];
            }
            
            strongSelf->_isLocalCube = false;
            if( strongSelf->_filterCore )
            {
                [strongSelf->_filterCore stop];
                strongSelf->_filterCore = nil;
            }
            strongSelf->_filterUrl = nil;
        });
    }
}

-(void)InitFilterCollectionView
{
    if( _filterCollectionView )
    {
        _currentScrollViewChildItem = nil;
        [_filterCollectionView reloadData];
        return;
    }
    
    float fileterNewScroViewHeight = (self.frame.size.height - ([VEConfigManager sharedManager].iPad_HD ? 0 : kToolbarHeight) - 45 - CGRectGetHeight(self.fileterLabelNewScroView.frame));
    
    float width = (self.frame.size.width - 60)/5.0;
    if(![VEConfigManager sharedManager].iPad_HD){
        width = (self.frame.size.width - 45) / 4.8;
        if(iPad){
            width = 65;
        }
    }
    
    collectionCellWidth = width;
    
    UICollectionViewFlowLayout * flow_Video = [[UICollectionViewFlowLayout alloc] init];
    flow_Video.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow_Video.itemSize = CGSizeMake(width,width / 0.8);
    flow_Video.headerReferenceSize = CGSizeMake(0,0);
    flow_Video.footerReferenceSize = CGSizeMake(30, width / 0.8);
    
    _filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, self.fileterLabelNewScroView.frame.origin.y + self.fileterLabelNewScroView.frame.size.height, self.frame.size.width - 15, width / 0.8) collectionViewLayout:flow_Video];
    _filterCollectionView.showsHorizontalScrollIndicator = NO;
    _filterCollectionView.showsVerticalScrollIndicator = NO;
    // 使用类进行注册
    [_filterCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterViewIdentifier"];
    
    [_filterCollectionView registerClass:[VENetworkMaterialBtn_Cell class] forCellWithReuseIdentifier:@"filterCollectionCell"];
    
    _filterCollectionView.backgroundColor = [UIColor clearColor];
    _filterCollectionView.tag = 1000000;
    _filterCollectionView.dataSource = self;
    _filterCollectionView.delegate = self;
    
    [_fileterNewView addSubview:_filterCollectionView];
}

#pragma mark- UICollectionViewDelegate/UICollectViewdataSource
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if( currentlabelFilter == 120000 )
        return 1;
    else
        return _filter_newFilterSortArray.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if( currentlabelFilter == 120000 )
    {
        NSInteger count = 0;
        if( _filter_CollectionPlists )
        {
            NSArray * array = (NSArray *)_filter_CollectionPlists[@"data"];
            count = array.count;
        }
        return  1+count;
    }
    else
    {
        if( section <  _filter_newFiltersNameSortArray.count )
            return ((NSArray*)_filter_newFiltersNameSortArray[section]).count;
        else
            return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"filterCollectionCell";
    VENetworkMaterialBtn_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if( [cell.btnCollectBtn isKindOfClass:[VEFileScrollViewChildItem class]] )
    {
        VEFileScrollViewChildItem *scrollViewChildItem = (VEFileScrollViewChildItem*)cell.btnCollectBtn;
        if( scrollViewChildItem.itemIconView )
        {
            [scrollViewChildItem.itemIconView  sd_cancelCurrentImageLoad];
            scrollViewChildItem.itemIconView.image = nil;
            [scrollViewChildItem.itemIconView removeFromSuperview];
            scrollViewChildItem.itemIconView = nil;
        }
        [scrollViewChildItem.itemTitleLabel removeFromSuperview];
        scrollViewChildItem.itemTitleLabel = nil;
    }
    
    [cell.btnCollectBtn removeFromSuperview];
    cell.btnCollectBtn = nil;
    
    if(!cell){
        cell = [[VENetworkMaterialBtn_Cell alloc] initWithFrame:CGRectMake(0, 0, collectionCellWidth, collectionView.frame.size.height)];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if( currentlabelFilter == 120000 )
    {
        if( row == 0 )
        {
            UIButton *cubeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
            if([VEConfigManager sharedManager].iPad_HD){
                cubeBtn.frame = CGRectMake(0, 10, collectionCellWidth, collectionCellWidth + 20);
            }else{
                cubeBtn.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            }
            cubeBtn.backgroundColor = UIColorFromRGB(0x272727);
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                cubeBtn.backgroundColor = UIColorFromRGB(0xefefef);
            }
            cubeBtn.layer.cornerRadius = 5.0;
            cubeBtn.layer.masksToBounds = true;
            {
                UIImageView *itemIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 10.0, cubeBtn.frame.size.width - 20, cubeBtn.frame.size.width - 20)];
                itemIconView.layer.masksToBounds = YES;
                itemIconView.userInteractionEnabled = YES;
                itemIconView.contentMode = UIViewContentModeScaleAspectFill;
                itemIconView.clipsToBounds = YES;
                [cubeBtn addSubview:itemIconView];
                itemIconView.image = [VEHelp imageWithContentOfFile:@"New_EditVideo/scrollViewChildImage/剪辑_滤镜本地cube默认_"];
            }
            {
                UILabel *moveTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cubeBtn.frame.size.height - cubeBtn.frame.size.height * 0.25, cubeBtn.frame.size.width, cubeBtn.frame.size.height * 0.25)];
                moveTitleLabel.backgroundColor = UIColorFromRGB(0x5f4b44);
                moveTitleLabel.textColor = [UIColor whiteColor];
                if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                    moveTitleLabel.backgroundColor = UIColorFromRGB(0xefefef);
                    moveTitleLabel.textColor = UIColorFromRGB(0x131313);
                }
                moveTitleLabel.font = [UIFont systemFontOfSize:10>0?10:14];
                moveTitleLabel.textAlignment = NSTextAlignmentCenter;
                [cubeBtn addSubview:moveTitleLabel];
                moveTitleLabel.text = VELocalizedString(@"本地cube", nil);
            }
            
            cubeBtn.tag = 20000;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cubeBtn_onclik)];
            [cubeBtn addGestureRecognizer:gesture];
            [cell addSubview:cubeBtn];
            cell.btnCollectBtn = cubeBtn;
            return cell;
        }
        else
        {
            VEFileScrollViewChildItem *scrollViewChildItem = [self createScrollViewChildItem:row atSection:section atCollectionViewCell:cell];
            cell.btnCollectBtn = scrollViewChildItem;
            scrollViewChildItem.isLocalCubeFilter = true;
        }
    }
    else
    {
        VEFileScrollViewChildItem *scrollViewChildItem = [self createScrollViewChildItem:row atSection:section atCollectionViewCell:cell];
        cell.btnCollectBtn = scrollViewChildItem;
        scrollViewChildItem.isLocalCubeFilter = NO;
    }
    
    return cell;
}

-(VEFileScrollViewChildItem *)createScrollViewChildItem:( NSInteger ) idx atSection:( NSInteger ) section atCollectionViewCell:( UICollectionViewCell * ) cell
{
    UIColor *backgroundColor;
    NSString *str;
    NSMutableDictionary *obj;
    if( currentlabelFilter != 120000 )
    {
        if (_filter_newFiltersNameSortArray.count > (section)) {
            NSDictionary *categoryDic = _filter_newFilterSortArray[(section)];
            str = [categoryDic objectForKey:@"name"];
            if( isEnglish )
                str = [str substringToIndex:1];
            backgroundColor = [VEHelp getCategoryFilterBgColorWithDic:categoryDic categoryIndex:(section)];
            obj = ((NSArray *)_filter_newFiltersNameSortArray[ (section) ])[idx];
        }else {
            backgroundColor = [VEHelp getCategoryFilterBgColorWithDic:nil categoryIndex:(section)];
        }
    }
    else
    {
        backgroundColor = [VEHelp getCategoryFilterBgColorWithDic:nil categoryIndex:currentlabelFilter];
        obj = ((NSArray *)_filter_CollectionPlists[@"data"])[idx-1];
    }
    VEFileScrollViewChildItem *item;
//    if([VEConfigManager sharedManager].iPad_HD){
//        int section = floor(idx/5);
//        int row = fmod(idx, 5);
//        item = [[VEFileScrollViewChildItem alloc] initWithFrame:CGRectMake(0, section * (width + 20) + localHeight, width, width + 20)];
//        item.normalColor = [UIColor colorWithWhite:1.0 alpha:0.5];
//        item.itemTitleLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
//        [item setCornerRadius:5];
//    }else
    {
        item = [[VEFileScrollViewChildItem alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height) itemType:VEFileScrollItemType_Filter];
        item.itemTitleLabel.backgroundColor = backgroundColor;
    }
    NSString *cover;
    if (obj[@"cover2"] && [obj[@"cover2"] length] > 0) {
        cover = obj[@"cover2"];
    }else {
        cover = obj[@"cover"];
    }

    UIImage *image = nil;
    if( cover )
    {
        if( currentlabelFilter == 120000 )
            image = [VEHelp getFullImageWithUrl:[NSURL fileURLWithPath:cover]];
        
        if( image )
            item.itemIconView.image = image;
        else
            [item.itemIconView sd_setImageWithURL:[NSURL URLWithString:cover]];
    }

    [item.itemIconView sd_setImageWithURL:[NSURL URLWithString:cover]];


    if( currentlabelFilter == 120000 )
    {
        if( image )
            item.itemTitleLabel.backgroundColor = UIColorFromRGB(0x5f4b44);
        else{
            NSInteger filterType = [obj[@"filtertType"] integerValue];
            NSDictionary *categoryDic = _filter_newFilterSortArray[ [obj[@"filtertType"] integerValue]];
            item.itemTitleLabel.backgroundColor = [VEHelp getCategoryFilterBgColorWithDic:categoryDic categoryIndex:filterType];
            item.isSelectCollection = true;
            str = [categoryDic objectForKey:@"name"];
            if( isEnglish )
                str = [str substringToIndex:1];
        }
        item.isCollection = true;
    }
    else
    {
        
        for (NSDictionary *dic in _filter_CollectionPlists[@"data"]) {
            UIImage * coverImage = [VEHelp getFullImageWithUrl:[NSURL fileURLWithPath:dic[@"cover"]]];
            if ( (coverImage == nil) && [dic[@"id"] length] > 0 && [dic[@"id"] isEqualToString:obj[@"id"]] ) {
                item.isSelectCollection = true;
                break;
            }
        }
        item.isCollection = true;
//        if( section > 0 )
            item.filterType = section;
    }

    item.backgroundColor        = [UIColor clearColor];
    item.fontSize       = 10;
    item.type           = 2;
    item.delegate       = self;
    item.selectedColor  = Main_Color;
    item.exclusiveTouch = YES;
    item.itemIconView.backgroundColor   = [UIColor clearColor];
    item.tag                            = idx + currentFilterIndex + 2;
    if( currentlabelFilter == 120000 )
    {
        if( image )
        {
            str = VELocalizedString(@"我的", nil);
            if( isEnglish )
                str = [str substringToIndex:1];
            item.isSelectCollection = true;
        }
        item.itemTitleLabel.text = [NSString stringWithFormat:@"%@%ld",str, ([obj[@"filtertItemIndex"] integerValue] - [obj[@"currentFilterIndex"] integerValue] + 1)];
        item.tag = [obj[@"filtertItemIndex"] integerValue] + 2;
    }
    else
    {
        item.itemTitleLabel.text = [NSString stringWithFormat:@"%@%d",str,((int)idx)+1];
        int index = 0;
        for (int i = 0; i < _filter_newFiltersNameSortArray.count; i++) {
            NSArray * array = (NSArray *)_filter_newFiltersNameSortArray[i];
            index += array.count;
            if( i == section )
            {
                index -= array.count;
                break;
            }
        }
        item.filterTypeCount = index;
        item.tag = idx + index + 2;
    }
    item.itemTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    if( ((item.tag-1) == _selectFilterIndex) && ( _currentCustomFilter ) ) {
//        index = (int)idx;
        _currentScrollViewChildItem = item;
        [item setSelected:YES];
    }else {
        [item setSelected:NO];
    }
    [cell addSubview:item];
    
    return item;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterViewIdentifier" forIndexPath:indexPath];
        if( [footerView viewWithTag:1200] )
        {
            if( [[footerView viewWithTag:1200] isKindOfClass:[UILabel class]] )
            {
                [[footerView viewWithTag:1200]  removeFromSuperview];
            }
        }
        // 配置尾部视图
        // ...
        if( currentlabelFilter != 120000 )
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((footerView.frame.size.width - 3.0)/2.0, footerView.frame.size.height/2.0/2.0, 3.0, footerView.frame.size.height/2.0)];
            label.backgroundColor = UIColorFromRGB(0x1f1f1f);
            if([VEConfigManager sharedManager].backgroundStyle == UIBgStyleDarkContent){
                label.backgroundColor = UIColorFromRGB(0xefefef);
            }
            label.tag = 1200;
            label.layer.cornerRadius = 1;
            label.layer.masksToBounds = YES;
            [footerView addSubview:label];
        }
        
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if( currentlabelFilter != 120000 )
        return CGSizeMake(35.0, collectionView.bounds.size.height); // 返回您所需的尾部视图大小
    else
        return CGSizeMake(10.0, collectionView.bounds.size.height); // 返回您所需的尾部视图大小
}

+(NSMutableArray *)createGlobalFilters
{
    NSMutableDictionary *filterCollectionPlists = _filter_CollectionPlists;
    
    [_globalFilters removeAllObjects];
    _globalFilters = nil;
    _globalFilters = [[NSMutableArray alloc] initWithArray:_originalGlobalFilters];
    
    [_filtersName removeAllObjects];
    _filtersName = nil;
    _filtersName = [[NSMutableArray alloc] initWithArray:_originalFiltersName];
    
    if( filterCollectionPlists )
    {
        NSMutableArray * currentFilterList = filterCollectionPlists[@"data"];
        [_filtersName addObjectsFromArray:currentFilterList];
        for (NSDictionary *filterDic in currentFilterList) {
            Filter* filter = [Filter new];
            NSString *itemPath = [VEHelp getFilterDownloadPathWithDic:filterDic];
            
            if( [filterDic[@"file"] containsString:@"LocalFilterFldoer"] )
                itemPath = filterDic[@"file"];
                
            filter.type = kFilterType_3D_Lut_Cube;
            filter.filterPath = itemPath;
            filter.networkCategoryId = [filterCollectionPlists objectForKey:@"id"];
            filter.networkResourceId = filterDic[@"id"];
            filter.netCover = filterDic[@"cover"];
            filter.name = filterDic[@"name"];
            [_globalFilters addObject:filter];
        }
    }
    
    return _globalFilters;
}
@end
