//
//  VECropTypeView.m
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import "VECropTypeView.h"

#import "VECropTypeCell.h"
#import "VECropIconTypeCell.h"

@interface VECropTypeView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

///数据源
@property(nonatomic, strong)NSMutableArray      *dataArray;

@property(nonatomic, assign)CGFloat collectionViewHeight;


@end

static NSString *cellID = @"VECropTypeCell";

static NSString *cellIconID = @"VECropIconTypeCell";

@implementation VECropTypeView

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
       UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //行与行间的距离
        flowLayout.minimumLineSpacing = 0;
        //列与列间的距离
        flowLayout.minimumInteritemSpacing = 0;
        //设置item的大小
        flowLayout.itemSize = CGSizeMake(0,0);
        //边界值
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        
        self.collectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,frame.size.width,frame.size.height) collectionViewLayout:flowLayout];
        // 设置UICollectionView为横向滚动
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        
        //竖直滚动
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        [self addSubview:self.collectionView];
        
        //注册Cell
        [self.collectionView registerClass:[VECropTypeCell class] forCellWithReuseIdentifier:cellID];
        
        //注册Cell
        [self.collectionView registerClass:[VECropIconTypeCell class] forCellWithReuseIdentifier:cellIconID];
        [self.collectionView reloadData];
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.collectionView.frame = CGRectMake(0, 0,frame.size.width,frame.size.height);
}
#pragma mark - 1.Setting View and Style

-(void)reloadDataForDataArray:(NSMutableArray*)dataArray{
    self.dataArray = dataArray;
    [self.collectionView reloadData];
    float width =0;
    if([VEConfigManager sharedManager].iPad_HD){
        width = self.dataArray.count * 65;
//        for (VECropTypeModel *cropTypeModel in self.dataArray) {
//            if (cropTypeModel.cropType == VE_VECROPTYPE_FREE) {
//                width += 52.0/90.0*self.frame.size.height;
//            }else if(cropTypeModel.cropType == VE_VECROPTYPE_ORIGINAL){
//
//                width += 52.0/90.0*self.frame.size.height;
//
//            }else if(cropTypeModel.cropType == VE_VECROPTYPE_9TO16){
//
//                width += 52.0/90.0*self.frame.size.height;
//
//            }else if(cropTypeModel.cropType == VE_VECROPTYPE_16TO9){
//
//                width += 90.0/90.0*self.frame.size.height;
//
//            }else if(cropTypeModel.cropType == VE_VECROPTYPE_1TO1){
//
//                width += 52.0/90.0*self.frame.size.height;
//
//            }else if(cropTypeModel.cropType == VE_VECROPTYPE_6TO7){
//
//                width += 55.0/90.0*self.frame.size.height;
//
//            }else if(cropTypeModel.cropType == VE_VECROPTYPE_4TO5){
//
//                width += 56.0/90.0*self.frame.size.height;
//
//            }else if(cropTypeModel.cropType == VE_VECROPTYPE_4TO3){
//
//                width += 70.0/90.0*self.frame.size.height;
//
//            }else if(cropTypeModel.cropType == VE_VECROPTYPE_3TO4){
//
//                width += 52.0/90.0*self.frame.size.height;
//
//            }
//            width += 10;
//        }
        CGRect r = self.collectionView.frame;
        r.size.width = MIN(width, self.frame.size.width);
        r.origin.x = (CGRectGetWidth(self.frame) - r.size.width)/2.0;
        self.collectionView.frame = r;
        [self.collectionView setContentSize:CGSizeMake(width, self.collectionView.frame.size.height)];
    }
}

-(void)didSelectItemAtIndexPathRow:(NSInteger)row{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:row];
    
    [self setCellWithdidSelectItemAtIndexPath:indexPath];
    
    
}



#pragma mark CollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    

    return [self.dataArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    VECropTypeModel * cropTypeModel = [self.dataArray objectAtIndex:indexPath.section];
    
    if (cropTypeModel.isHaveIcon) {
        VECropIconTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIconID forIndexPath:indexPath];
        [cell setCellForoCropTypeModel:cropTypeModel];
        return cell;
    }else {
        VECropTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        [cell setCellForoCropTypeModel:cropTypeModel];
        return cell;
        
    }
    return nil;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setCellWithdidSelectItemAtIndexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(cropTypeView:selectItemAtIndexPath:)]) {
        [self.delegate cropTypeView:self selectItemAtIndexPath:indexPath];
    }
}

-(void)setCellWithdidSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (int i = 0; i<[self.dataArray count];i++) {
        VECropTypeModel * cropTypeModel = [self.dataArray objectAtIndex:i];
        if (i==indexPath.section) {
            cropTypeModel.isSelect = YES;
            
        }else{
            cropTypeModel.isSelect = NO;
        }
    }
    [self.collectionView reloadData];
}

#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    VECropTypeModel * cropTypeModel = [self.dataArray objectAtIndex:section];
    if([VEConfigManager sharedManager].iPad_HD){
        return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
    }

    
    if (cropTypeModel.cropType == VE_VECROPTYPE_FREE) {
        return UIEdgeInsetsMake(38.0/90.0*self.frame.size.height, 0, 0, 8.0/90.0*self.frame.size.height);//（上、左、下、右）自由
    }else if(cropTypeModel.cropType == VE_VECROPTYPE_ORIGINAL){
        return UIEdgeInsetsMake(38.0/90.0*self.frame.size.height, 0, 0, 8.0/90.0*self.frame.size.height);//（上、左、下、右）原比列
    }else if(cropTypeModel.cropType == VE_VECROPTYPE_9TO16){
        return UIEdgeInsetsMake(0, 0, 0, 8.0/90.0*self.frame.size.height);//（上、左、下、右）9:16
    }else if(cropTypeModel.cropType == VE_VECROPTYPE_16TO9){
        return UIEdgeInsetsMake(38.0/90.0*self.frame.size.height, 0, 0, 8.0/90.0*self.frame.size.height);//（上、左、下、右）16:9
    }else if(cropTypeModel.cropType == VE_VECROPTYPE_1TO1){
        return UIEdgeInsetsMake(38.0/90.0*self.frame.size.height, 0, 0, 8.0/90.0*self.frame.size.height);//（上、左、下、右）1:1
    }else if(cropTypeModel.cropType == VE_VECROPTYPE_6TO7){
        return UIEdgeInsetsMake(13.0/90.0*self.frame.size.height, 0, 0, 8.0/90.0*self.frame.size.height);//（上、左、下、右）6:7
    }else if(cropTypeModel.cropType == VE_VECROPTYPE_4TO5){
        return UIEdgeInsetsMake(18.0/90.0*self.frame.size.height, 0, 0, 8.0/90.0*self.frame.size.height);//（上、左、下、右）4:5
    }else if(cropTypeModel.cropType == VE_VECROPTYPE_4TO3){
        return UIEdgeInsetsMake(38.0/90.0*self.frame.size.height, 0, 0, 8.0/90.0*self.frame.size.height);//（上、左、下、右）4:3
    }else if(cropTypeModel.cropType == VE_VECROPTYPE_3TO4){
        return UIEdgeInsetsMake(20.0/90.0*self.frame.size.height, 0, 0, 8.0/90.0*self.frame.size.height);//（上、左、下、右）3:4
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VECropTypeModel * cropTypeModel = [self.dataArray objectAtIndex:indexPath.section];
    
    if([VEConfigManager sharedManager].iPad_HD){
        return CGSizeMake(65, 65);//（上、左、下、右）
    }
    
    if (cropTypeModel.cropType == VE_VECROPTYPE_FREE) {
        return CGSizeMake(52.0/90.0*self.frame.size.height, 52.0/90.0*self.frame.size.height);//返回两个小的cell的尺寸 自由
    }else if(cropTypeModel.cropType == VE_VECROPTYPE_ORIGINAL){

        return CGSizeMake(52.0/90.0*self.frame.size.height, 52.0/90.0*self.frame.size.height);//返回两个小的cell的尺寸 原比列

    }else if(cropTypeModel.cropType == VE_VECROPTYPE_9TO16){

        return CGSizeMake(52.0/90.0*self.frame.size.height, 90.0/90.0*self.frame.size.height);//返回两个小的cell的尺寸 9:16

    }else if(cropTypeModel.cropType == VE_VECROPTYPE_16TO9){

        return CGSizeMake(90.0/90.0*self.frame.size.height, 52.0/90.0*self.frame.size.height);//返回两个小的cell的尺寸 16:9

    }else if(cropTypeModel.cropType == VE_VECROPTYPE_1TO1){

        return CGSizeMake(52.0/90.0*self.frame.size.height, 52.0/90.0*self.frame.size.height);//返回两个小的cell的尺寸 1:1

    }else if(cropTypeModel.cropType == VE_VECROPTYPE_6TO7){

        return CGSizeMake(55.0/90.0*self.frame.size.height, 77.0/90.0*self.frame.size.height);//返回两个小的cell的尺寸 6:7

    }else if(cropTypeModel.cropType == VE_VECROPTYPE_4TO5){

        return CGSizeMake(56.0/90.0*self.frame.size.height, 72.0/90.0*self.frame.size.height);//返回两个小的cell的尺寸 4:5

    }else if(cropTypeModel.cropType == VE_VECROPTYPE_4TO3){

        return CGSizeMake(70.0/90.0*self.frame.size.height, 52.0/90.0*self.frame.size.height);//返回两个小的cell的尺寸 4:3

    }else if(cropTypeModel.cropType == VE_VECROPTYPE_3TO4){

        return CGSizeMake(52.0/90.0*self.frame.size.height, 70.0/90.0*self.frame.size.height);//返回两个小的cell的尺寸 3:4

    }
    return CGSizeMake(0, 0);

   

}


#pragma mark - 3.Set & Get




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end


