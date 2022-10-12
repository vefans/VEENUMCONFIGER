//
//  VENetworkMaterialCollectionViewCell.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/8/31.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VENetworkMaterialCollectionViewCell.h"
#import "VENetworkMaterialBtn_Cell.h"
#import "VENetworkMaterialView.h"
#import <SDWebImage/SDImageCache.h>
#import <VEENUMCONFIGER/LongCacheImageView.h>
@implementation VECell_CollectionView

- (void)setContentOffset:(CGPoint)contentOffset{
    NSLog(@"%s : %@",__func__,NSStringFromCGPoint(contentOffset));
    [super setContentOffset:contentOffset];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated{
    NSLog(@"%s : %@",__func__,NSStringFromCGPoint(contentOffset));
    if (animated) {
        if (@available(iOS 16.0, *)) {//20221009 iOS16.0 animated为true时，会将contentOffset设为(0,0)
            WeakSelf(self);
            [UIView animateWithDuration:0.3 animations:^{
                StrongSelf(self);
                strongSelf.contentOffset = contentOffset;
            }];
        }else {
            [super setContentOffset:contentOffset animated:animated];
        }
    }else {
        [super setContentOffset:contentOffset animated:animated];
    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset{
    if([VEConfigManager sharedManager].iPad_HD){
        contentInset.top = 15;
    }
    NSLog(@"%s ,top:%f,left:%f,bottom:%f,right:%f",__func__,contentInset.top,contentInset.left,contentInset.bottom,contentInset.right);
    [super setContentInset:contentInset];
}
- (void)setContentSize:(CGSize)contentSize{
    NSLog(@"%s : %@",__func__,NSStringFromCGSize(contentSize));
    [super setContentSize:contentSize];
    if(![VEConfigManager sharedManager].iPad_HD){
        return;
    }
    if(contentSize.height <= self.frame.size.height){
        self.scrollEnabled = NO;
    }
}
@end
@interface VENetworkMaterialCollectionViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property(nonatomic, assign) float cellWidth;
@property(nonatomic, assign) float cellHeight;
@property(nonatomic, assign) float              collectionOffsetX;
@property(nonatomic, assign) float              collectionOffsetPointX;
@property(nonatomic, assign) BOOL               isVertical_Cell;

@end

@implementation VENetworkMaterialCollectionViewCell

-(void)initCollectView:(BOOL) isVertical_Cell atWidth:(float) cellWidth atHeight:(float) cellHeight minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing
{
    UICollectionViewFlowLayout * flow_Video = [[UICollectionViewFlowLayout alloc] init];
    _cellWidth = cellWidth;
    _cellHeight = cellHeight;
    _isVertical_Cell = isVertical_Cell;
    
    if( isVertical_Cell )
    {
        flow_Video.scrollDirection = UICollectionViewScrollDirectionVertical;
        flow_Video.itemSize = CGSizeMake(floor(_cellWidth),floor(_cellHeight));
    }
    else
    {
        flow_Video.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flow_Video.itemSize = CGSizeMake(_cellWidth,self.bounds.size.height);
    }
    
    flow_Video.headerReferenceSize = CGSizeMake(0,0);
    flow_Video.footerReferenceSize = CGSizeMake(0,0);
    
    flow_Video.minimumInteritemSpacing = minimumInteritemSpacing;
    flow_Video.minimumLineSpacing = minimumLineSpacing;
        
    VECell_CollectionView * videoCollectionView =  [[VECell_CollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow_Video];
    videoCollectionView.backgroundColor = [UIColor clearColor];
    ((UIScrollView*)videoCollectionView).delegate = self;
    videoCollectionView.tag = 1000000;
    videoCollectionView.dataSource = self;
    videoCollectionView.delegate = self;
    
    [videoCollectionView registerClass:[VENetworkMaterialBtn_Cell class] forCellWithReuseIdentifier:@"VENetworkMaterialBtn_Cell"];
    _collectionView = videoCollectionView;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:_collectionView];
}

#pragma mark-scrollView
#pragma mark - UIScrollViewDelegate (时间轴的更新操作)
//开始滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if( _isDragToChange &&  _delegate && [_delegate respondsToSelector:@selector(cell_ScrollViewWillBeginDragging:)] )
    {
        [_delegate cell_ScrollViewWillBeginDragging:scrollView];
    }
}
/**
 滚动中
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(  _isDragToChange && _delegate && [_delegate respondsToSelector:@selector(cell_ScrollViewDidScroll:)] )
    {
        [_delegate cell_ScrollViewDidScroll:scrollView];
    }
}

/**滚动停止
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if( _isDragToChange &&  _delegate && [_delegate respondsToSelector:@selector(cell_ScrollViewDidEndDecelerating:)] )
    {
        [_delegate cell_ScrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale
{
    if( _isDragToChange &&  _delegate && [_delegate respondsToSelector:@selector(cell_ScrollViewDidEndDecelerating:)] )
    {
        [_delegate cell_ScrollViewDidEndDecelerating:scrollView];
    }
}

/**手指停止滑动
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if( _isDragToChange && _delegate && [_delegate respondsToSelector:@selector(cell_ScrollViewDidEndDragging:willDecelerate:)] )
    {
        [_delegate cell_ScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
    if( _isNotMove )
        return;
    
    VENetworkMaterialView * network = (VENetworkMaterialView*)_delegate;
    double conffsetX = scrollView.contentOffset.x;
    NSInteger index = self.tag;
    if( conffsetX > (scrollView.contentSize.width - scrollView.frame.size.width + scrollView.frame.size.height/2.0) )
    {
        network.isAddCount = 0;
        index++;
        if( index > (network.CollectionViewCount-1) )
            index = network.CollectionViewCount-1;
    }
    else if( conffsetX < (-(scrollView.frame.size.height/2.0)) )
    {
        network.isAddCount = 1;
        index--;
        if( index < 0 )
            index = 0;
    }
    
    if( index != self.tag )
    {
        __weak typeof(self) myself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            myself.collectionView.contentOffset = CGPointMake(0, 0);
            if( myself.delegate && [myself.delegate respondsToSelector:@selector(CellIndex:)] )
            {
                [myself.delegate CellIndex:index ];
            }
        });
    }
}

#pragma mark-拖动
-(void)moveGesture:(UIGestureRecognizer *) recognizer
{
    if(  _isDragToChange && _delegate && [_delegate respondsToSelector:@selector(cell_MoveGesture:)] )
    {
        [_delegate cell_MoveGesture:recognizer];
    }
}

#pragma mark- UICollectionViewDelegate/UICollectViewdataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //NSInteger count = ((float)self.bounds.size.height)/_cellHeight;
    return 1;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _indexCount;
//    NSInteger count = self.bounds.size.height/_cellHeight;
//    NSInteger  cellCount = _indexCount/count;
//   if( (section +1) < count )
//   {
//       return  (_indexCount == (cellCount*count) )?cellCount:(cellCount+1);
//   }
//    else
//    {
//        if( count == 1  )
//        {
//            return _indexCount;
//        }
//        else if(_indexCount == cellCount*count){
//            return  cellCount;
//        }
//        else{
//            return _indexCount - (cellCount*section);
//        }
//    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"VENetworkMaterialBtn_Cell";
    VENetworkMaterialBtn_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSLog(@"VENetworkMaterialBtn_Cell:%zd,%zd",indexPath.section,indexPath.row);
    if(!cell){
        cell = [[VENetworkMaterialBtn_Cell alloc] initWithFrame:CGRectMake(0, 0, _cellWidth, _cellHeight)];
    }
    if( _delegate && [_delegate respondsToSelector:@selector(btnCollectCell:atIndexCount:collectionView:cell:)] )
    {
//        [[cell viewWithTag:2500] removeFromSuperview];
        if( cell.btnCollectBtn )
        {
            [cell.btnCollectBtn removeFromSuperview];
            cell.btnCollectBtn = nil;
        }
        
        UIView * view = [_delegate btnCollectCell:indexPath.row atIndexCount:_index collectionView:collectionView cell:cell];
//        view.tag = 2500;
        cell.btnCollectBtn = view;
        [cell addSubview:view];
    }
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    
    return cell;
}

-(void)setIsNotMove:(bool)isNotMove
{
//    if( !isNotMove )
//    {
//        if( !_isVertical_Cell )
//        {
//            UIPanGestureRecognizer* moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
//            [_collectionView addGestureRecognizer:moveGesture];
//        }
//    }
    _isNotMove = isNotMove;
}

// 控制翻页
//- (void) moveGesture:(UIGestureRecognizer *) recognizer
//{
//    if( _isNotMove )
//        return;
//
//    if (recognizer.state == UIGestureRecognizerStateBegan) {
//        _collectionOffsetPointX = _collectionView.contentOffset.x;
//        _collectionOffsetX = [recognizer locationInView:self.superview].x;
//
//    }else if (recognizer.state == UIGestureRecognizerStateChanged){
//
//        float x = _collectionOffsetPointX + (_collectionOffsetX - [recognizer locationInView:self.superview].x );
//
//        [_collectionView setContentOffset:CGPointMake(x, 0) animated:false];
//
//    }else if (recognizer.state == UIGestureRecognizerStateEnded)
//    {
//        float x = _collectionOffsetPointX + (_collectionOffsetX - [recognizer locationInView:self.superview].x );
//
//        [_collectionView setContentOffset:CGPointMake(x, 0) animated:false];
//
//        float leftX = x - _collectionOffsetPointX;
//
//        BOOL isLeft = true;
//
//        if( leftX == 0 )
//        {
//            [_collectionView setContentOffset:CGPointMake(_collectionOffsetPointX, 0) animated:true];
//            return;
//        }
//        else if( leftX > 0 )
//        {
//            isLeft = false;
//        }
//
//        _collectionView.contentOffset = CGPointMake(x, 0);
//
//        VENetworkMaterialView * network = (VENetworkMaterialView*)_delegate;
//
//        double conffsetX = _collectionView.contentOffset.x;
//
//        NSInteger index = self.tag;
//        if( conffsetX > (_collectionView.contentSize.width - _collectionView.frame.size.width + _collectionView.frame.size.height/2.0) )
//        {
//            index++;
//
//            if( index > (network.CollectionViewCount-1) )
//            {
//                index = network.CollectionViewCount-1;
//
//            }
//        }
//        else if( conffsetX < (-(_collectionView.frame.size.height/2.0)) )
//        {
//            index--;
//            if( index < 0 )
//            {
//                index = 0;
//            }
//        }
//
//        if( index != self.tag )
//        {
//            __weak typeof(self) myself = self;
//            dispatch_async(dispatch_get_main_queue(), ^{
//
//                myself.collectionView.contentOffset = CGPointMake(0, 0);
//
//                if( myself.delegate && [myself.delegate respondsToSelector:@selector(CellIndex:)] )
//                {
//                    [myself.delegate CellIndex:index ];
//                }
//                [network.collectionView setContentOffset:CGPointMake(network.collectionView.frame.size.width*(index), 0) animated:false];
//            });
//        }
//        else{
//            if( conffsetX > _collectionView.contentSize.width - _collectionView.frame.size.width )
//            {
//                _collectionView.contentOffset = CGPointMake(_collectionView.contentSize.width - _collectionView.frame.size.width, 0);
//            }
//            else if( conffsetX < 0 ){
//                _collectionView.contentOffset = CGPointMake(0, 0);
//            }
//        }
//    }
//}

/**手指停止滑动
 */
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//
//
//}

- (void)dealloc{
    [self.collectionView removeFromSuperview];
    [[self.collectionView visibleCells] enumerateObjectsUsingBlock:^(__kindof VENetworkMaterialBtn_Cell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *iCell = obj.btnCollectBtn;
        if([iCell isKindOfClass:[VEAddItemButton class]]){
            VEAddItemButton *btn = (VEAddItemButton *)iCell;
            [btn.thumbnailIV long_stopAnimating];
            btn.thumbnailIV.longGifData = nil;
            btn.thumbnailIV.image = nil;
            [btn.thumbnailIV removeFromSuperview];
            btn.thumbnailIV = nil;
            [btn removeFromSuperview];
            btn = nil;
            [iCell removeFromSuperview];
            iCell = nil;
        }else{
            LongCacheImageView *imageView = (LongCacheImageView *)[iCell viewWithTag:200000];
            if([imageView isKindOfClass:[LongCacheImageView class]]){
                [imageView long_stopAnimating];
                imageView.longGifData = nil;
                imageView.image = nil;
            }
            [imageView removeFromSuperview];
            imageView = nil;
            [iCell removeFromSuperview];
            iCell = nil;
        }
    }];
    self.collectionView = nil;
    self.delegate = nil;
//    NSLog(@"%s",__func__);
}

@end
