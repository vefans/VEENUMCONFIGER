//
//  VENetworkMaterialView.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/8/31.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VENetworkMaterialView.h"
#import "VENetworkMaterialCollectionViewCell.h"
#import <SDWebImage/SDImageCache.h>
@implementation VENet_CollectionView

- (void)setContentOffset:(CGPoint)contentOffset{
    //if(contentOffset.y > 25 && contentOffset.y < 25 && [VEConfigManager sharedManager].iPad_HD)
//    {
//        contentOffset.y = -25;
//    }
    NSLog(@"%s : %@",__func__,NSStringFromCGPoint(contentOffset));
    [super setContentOffset:contentOffset];
}

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated{
    //if(contentOffset.y > 25 && contentOffset.y < 25 && [VEConfigManager sharedManager].iPad_HD)
//    {
//        contentOffset.y = -25;
//    }
    NSLog(@"%s : %@",__func__,NSStringFromCGPoint(contentOffset));
    [super setContentOffset:contentOffset animated:animated];
}
- (void)setContentInset:(UIEdgeInsets)contentInset{
    NSLog(@"%s ,top:%f,left:%f,bottom:%f,right:%f",__func__,contentInset.top,contentInset.left,contentInset.bottom,contentInset.right);
    [super setContentInset:contentInset];
}
- (void)setContentSize:(CGSize)contentSize{
    NSLog(@"%s : %@",__func__,NSStringFromCGSize(contentSize));
    if(![VEConfigManager sharedManager].iPad_HD){
        return;
    }
    [super setContentSize:contentSize];
    if(contentSize.height <= self.frame.size.height){
        self.scrollEnabled = NO;
    }
}
@end
@interface VENetworkMaterialView()<UICollectionViewDataSource,UICollectionViewDelegate,VENetworkMaterialCollectionViewCellDelegate
//,UIScrollViewDelegate
>
{
    NSTimer     *stopTimer;
}

@property(nonatomic, assign) float              currentOffsetX;//CollectView的偏移值

@property(nonatomic, assign) NSInteger          lineItemCount;//竖排时，一行的素材数

@property(nonatomic, assign) NSInteger          selectedItemIndex;//当前选中
@property(nonatomic, assign) BOOL               isVertical_Cell;
@property(nonatomic, assign) float              cellWidth;
@property(nonatomic, assign) float              cellHeight;
@property(nonatomic, strong) CAGradientLayer *topLayer;
@property(nonatomic, strong) CAGradientLayer *bottomLayer;
@property(nonatomic, assign) VENetworkMaterialCollectionViewCell *currentCell;

@end


@implementation VENetworkMaterialView
- (void) insertColorGradient:(UIView *)view superview:(UIView *)superview{
    if(![VEConfigManager sharedManager].iPad_HD){
        return;
    }
    UIColor *colorOne = [VIEW_IPAD_COLOR colorWithAlphaComponent:0.0];
    UIColor *colorTwo = VIEW_IPAD_COLOR;
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor,nil];
    
    _topLayer = [CAGradientLayer layer];
    _topLayer.colors = colors;
    _topLayer.frame = CGRectMake(0, CGRectGetMinY(view.frame), view.frame.size.width, 10);
    _topLayer.startPoint = CGPointMake(0, 1);
    _topLayer.endPoint = CGPointMake(0,0);
    [view.superview.layer insertSublayer:_topLayer above:0];
    _bottomLayer = [CAGradientLayer layer];
    _bottomLayer.colors = colors;
    _bottomLayer.frame = CGRectMake(0, CGRectGetMaxY(view.frame) - 15, view.frame.size.width, 15);
    _bottomLayer.startPoint = CGPointMake(0, 0);
    _bottomLayer.endPoint = CGPointMake(0, 1);
    [view.superview.layer insertSublayer:_bottomLayer above:0];
//    if([VEConfigManager sharedManager].iPad_HD)
//    _collectionView.contentInset = UIEdgeInsetsMake(15, 0, 15, 0);
    
}
- (instancetype)initWithFrame:(CGRect)frame atCount:(NSInteger) count atIsVertical_Cell:(BOOL) isVertical_Cell atWidth:(float) cellWidth atHeight:(float) cellHeight
{
    if (self = [super initWithFrame:frame]) {
        _CollectionViewCount = count;
        _currentCellIndex = -1;
        _cellWidth = cellWidth;
        _isVertical_Cell = isVertical_Cell;
        _isNotMove = false;
        _cellHeight = cellHeight;
        //               _collectionView.contentInset = UIEdgeInsetsMake(0, self.frame.size.width/2.0, 0, self.frame.size.width/2.0);
    }
    return self;
    
}

-(void)initCollectView{
    [self initCollectView:UIEdgeInsetsMake(0, 0, 0, 0)];
}

-(void)initCollectView:(UIEdgeInsets)contentInset
{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout.itemSize = CGSizeMake(self.bounds.size.width,self.bounds.size.height);
    _flowLayout.headerReferenceSize = CGSizeMake(0,0);
    _flowLayout.footerReferenceSize = CGSizeMake(0,0);
    _flowLayout.minimumLineSpacing = 0.0;
    _flowLayout.minimumInteritemSpacing = 0.0;
    _flowLayout.sectionInset = contentInset;
    
    VENet_CollectionView * videoCollectionView =  [[VENet_CollectionView alloc] initWithFrame: self.bounds collectionViewLayout:_flowLayout];
    videoCollectionView.tag = 1000000;
    videoCollectionView.dataSource = self;
    videoCollectionView.delegate = self;
//    ((UIScrollView*)videoCollectionView).delegate = self;
    [videoCollectionView registerClass:[VENetworkMaterialCollectionViewCell class] forCellWithReuseIdentifier:@"NetworkMaterialCollectionViewCell"];
    _collectionView = videoCollectionView;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
//    _collectionView.contentInset = UIEdgeInsetsMake(50, 0, 50, 0);
    [self addSubview:_collectionView];
    if( _isVertical_Cell  )
    {
        [self insertColorGradient:_collectionView superview:self];
        UIPanGestureRecognizer* moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
        [_collectionView addGestureRecognizer:moveGesture];
    }
    else{
        self.collectionView.scrollEnabled = NO;
    }
}

-(void)setContentSizeZero
{
    _collectionView.contentSize = CGSizeMake(0, [VEConfigManager sharedManager].iPad_HD ? -5 : 0);
}

- (void)setCurrentOffsetX:(float)offsetX
            lineItemCount:(NSInteger)lineItemCount
        selectedItemIndex:(NSInteger)selectedItemIndex
{
    _currentOffsetX = offsetX;
    _lineItemCount = lineItemCount;
    _selectedItemIndex = selectedItemIndex;
}

// 控制翻页
- (void) moveGesture:(UIGestureRecognizer *) recognizer{
    
    if( _CollectionViewCount == 1 )
    {
        [_collectionView setContentOffset:CGPointMake(0,  [VEConfigManager sharedManager].iPad_HD ? -5 : 0) animated:false];
        return;
    }
    
    if( _isNotMove )
    {
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _collectionOffsetPointX = _collectionView.contentOffset.x;
        _collectionOffsetX = [recognizer locationInView:self.superview].x;
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        
        float x = _collectionOffsetPointX + (_collectionOffsetX - [recognizer locationInView:self.superview].x );
        
        if( x > ((_CollectionViewCount-1)*self.frame.size.width) )
        {
            x = (_CollectionViewCount-1)*self.frame.size.width;
        }
        
        [_collectionView setContentOffset:CGPointMake(x,  [VEConfigManager sharedManager].iPad_HD ? -5 : 0) animated:false];
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        float x = _collectionOffsetPointX + (_collectionOffsetX - [recognizer locationInView:self.superview].x );
        
        [_collectionView setContentOffset:CGPointMake(x,  [VEConfigManager sharedManager].iPad_HD ? -5 : 0) animated:false];
        
        float leftX = x - _collectionOffsetPointX;
        
        BOOL isLeft = true;
        
        if( leftX == 0 )
        {
            [_collectionView setContentOffset:CGPointMake(_collectionOffsetPointX,  [VEConfigManager sharedManager].iPad_HD ? -5 : 0) animated:true];
            return;
        }
        else if( leftX > 0 )
        {
            isLeft = false;
        }
        
        if( x > ((_CollectionViewCount-1)*self.frame.size.width) )
        {
            x = (_CollectionViewCount-1)*self.frame.size.width;
        }
        
        _collectionView.contentOffset = CGPointMake(x, [VEConfigManager sharedManager].iPad_HD ? -5 : 0);
        
        if( _isVertical_Cell )
        {
            double conffsetX = _collectionView.contentOffset.x;
            
            NSInteger index = (NSInteger)(conffsetX/_collectionView.frame.size.width);
            double RemaininX = conffsetX - _collectionView.frame.size.width*index;
            if( ((RemaininX >= 10) && !isLeft)
               || (RemaininX >= (_collectionView.frame.size.width - 10)) )
            {
                if( index > (_CollectionViewCount-1) )
                {
                    index = _CollectionViewCount-1;
                }
                else
                {
                    index++;
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.userInteractionEnabled = NO;
                self->stopTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(stop_Timer) userInfo:nil repeats:YES];
                
                if( self.delegate && [self.delegate respondsToSelector:@selector(CellIndex:atNetwork:)] )
                {
                    [self.delegate CellIndex:index atNetwork:self];
                }
                
                [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width*(index), [VEConfigManager sharedManager].iPad_HD ? -5 : 0) animated:true];
            });
        }
        else{
            
        }
    }
}



#pragma mark- UICollectionViewDelegate/UICollectViewdataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _CollectionViewCount;
}

-(void)freNetWorkMaterialVIew
{
    [_collectionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if( [obj isKindOfClass:[VENetworkMaterialCollectionViewCell class]] )
        {
            VENetworkMaterialCollectionViewCell *cell = ( VENetworkMaterialCollectionViewCell * )obj;
            [cell.collectionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if(  [obj1 isKindOfClass:[VENetworkMaterialBtn_Cell class]] )
                {
                    if( _delegate && [_delegate respondsToSelector:@selector(freedCell:)] )
                    {
                        [_delegate freedCell:obj1];
                    }
                }
            }];
        }
        
    }];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"NetworkMaterialCollectionViewCell";
    VENetworkMaterialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    if( self.isImageShow )
    {
        if(!cell){
            cell = [[VENetworkMaterialCollectionViewCell alloc] initWithFrame:CGRectMake(self.bounds.size.width*indexPath.row, 0, self.bounds.size.width, self.bounds.size.height)];
        }
        
        if( cell.imageView )
        {
            [cell.imageView removeFromSuperview];
            cell.imageView = nil;
        }
        
        if( _delegate && [_delegate respondsToSelector:@selector(ImageViewCollectCell:atNetwork:)] )
        {
            UIView * view  = [_delegate ImageViewCollectCell:indexPath.row atNetwork:self];
            cell.imageView =  view;
            [cell addSubview:cell.imageView];
        }
    }
    else{
        if(!cell){
            cell = [[VENetworkMaterialCollectionViewCell alloc] initWithFrame:CGRectMake(self.bounds.size.width*indexPath.row, 0, self.bounds.size.width, self.bounds.size.height)];
        }
        else
        {
            [[SDImageCache sharedImageCache] clearMemory];
        }
        cell.index = 0;
        [cell.collectionView setContentOffset:CGPointMake(0, 0)];
        
        if( _delegate && [_delegate respondsToSelector:@selector(indexCountCell:atNetwork:)] )
            cell.indexCount = [_delegate indexCountCell:indexPath.row atNetwork:self];
        
        cell.index = indexPath.row;
        
        if( cell.collectionView  )
        {
            [cell.collectionView removeFromSuperview];
            cell.collectionView = nil;
        }
        
        cell.isDragToChange = _isDragToChange;
        
        [cell initCollectView:_isVertical_Cell atWidth:_cellWidth atHeight:_cellHeight minimumInteritemSpacing:_cellMinimumInteritemSpacing minimumLineSpacing:_cellMinimumLineSpacing];
        cell.collectionView.contentInset = UIEdgeInsetsMake(0, _cellMinimumInteritemSpacing + (_isVertical_Cell ? 2 : 0), 0, _cellMinimumInteritemSpacing + (_isVertical_Cell ? 2 : 0));
       
        if( (!_isImageShow) && ( !_isVertical_Cell ) && (!_isNotMove)  )
        {
            if( (_currentCellIndex != -1) && (_currentCellIndex == indexPath.row ) )
            {
                _currentCell = cell;
                [self performSelector:@selector(setCellOffset) withObject:nil afterDelay:0.2];
            }
        }
        cell.tag = indexPath.row;
        
        cell.isNotMove = _isNotMove;
    }
    return cell;
}

-(void)setCellOffset
{
    if(  _isAddCount != 1 )
        [_currentCell.collectionView setContentOffset:CGPointMake(0, 0)];
    else
        [_currentCell.collectionView setContentOffset:CGPointMake(_currentCell.collectionView.contentSize.width -  _currentCell.collectionView.frame.size.width, 0)];
    _currentCellIndex = -1;
}

#pragma mark- 释放
-(void)freedCell:( id ) cell
{
    if( _delegate && [_delegate respondsToSelector:@selector(freedCell:)] )
    {
        [_delegate freedCell:cell];
    }
}

#pragma mark- 界面组装
-(UIView *)btnCollectCell:(NSInteger) index atIndexCount:(NSInteger) indexCount collectionView:(UICollectionView *)collectionView cell:(nonnull VENetworkMaterialBtn_Cell *)cell
{
    if (_selectedItemIndex > 0 && collectionView.superview.frame.origin.x == _currentOffsetX) {
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        if (_lineItemCount > 0) {
            NSInteger index = _selectedItemIndex / _lineItemCount;
            float y = layout.itemSize.height * index;
            if (y + layout.itemSize.height > collectionView.frame.size.height) {
                y = MIN(y, collectionView.contentSize.height - collectionView.frame.size.height);
                [collectionView setContentOffset:CGPointMake(0, y) animated:YES];
            }
        }else {
            float x = (layout.itemSize.width + layout.minimumLineSpacing) * _selectedItemIndex;
            if (x + layout.itemSize.width > collectionView.frame.size.width) {
                x = MIN(x, collectionView.contentSize.width - collectionView.frame.size.width);
                [collectionView setContentOffset:CGPointMake(x, 0) animated:YES];
            }
        }
        _selectedItemIndex = 0;
    }
    if( _delegate && [_delegate respondsToSelector:@selector(btnCollectCell:atIndexCount:atNetwork:cell:)] )
        return [_delegate btnCollectCell:index atIndexCount:indexCount atNetwork:self cell:cell];
    else
        return nil;
}

-(void)CellIndex:(NSInteger) index
{
    self.userInteractionEnabled = NO;
    stopTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(stop_Timer) userInfo:nil repeats:YES];
    
    if( _delegate && [_delegate respondsToSelector:@selector(CellIndex:atNetwork:)] )
    {
        _currentCellIndex = index;
        [_delegate CellIndex:index atNetwork:self];
        [_collectionView setContentOffset:CGPointMake(_collectionView.frame.size.width*(index), 0) animated:true];
        [_collectionView reloadData];
    }
}

- (void)dealloc{
    [self.collectionView removeFromSuperview];
    self.collectionView.delegate = nil;
    self.collectionView = nil;
    self.delegate = nil;
    NSLog(@"%s",__func__);
}

-(void)stop_Timer
{
    self.userInteractionEnabled = YES;
    
    if(stopTimer){
        [stopTimer invalidate];
        stopTimer = nil;
    }
}

#pragma mark - UIScrollViewDelegate (时间轴的更新操作)
//开始滑动
- (void)cell_ScrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if( _delegate && [_delegate respondsToSelector:@selector(netWrokMaterial_ScrollViewWillBeginDragging:)] )
    {
        [_delegate netWrokMaterial_ScrollViewWillBeginDragging:scrollView];
    }
}
/**
 滚动中
 */
- (void)cell_ScrollViewDidScroll:(UIScrollView *)scrollView
{
    if( _delegate && [_delegate respondsToSelector:@selector(netWrokMaterial_ScrollViewWillBeginDragging:)] )
    {
        [_delegate netWrokMaterial_ScrollViewDidScroll:scrollView];
    }
}

/**滚动停止
 */
- (void)cell_ScrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if( _delegate && [_delegate respondsToSelector:@selector(netWrokMaterial_ScrollViewWillBeginDragging:)] )
    {
        [_delegate netWrokMaterial_ScrollViewDidEndDecelerating:scrollView];
    }
}

/**手指停止滑动
 */
- (void)cell_ScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if( _delegate && [_delegate respondsToSelector:@selector(netWrokMaterial_ScrollViewDidEndDragging:willDecelerate:)] )
    {
        [_delegate netWrokMaterial_ScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

-(void)cell_MoveGesture:(UIGestureRecognizer *) recognizer
{
    if( _delegate && [_delegate respondsToSelector:@selector(netWrokMaterial_MoveGesture:)] )
    {
        [_delegate netWrokMaterial_MoveGesture:recognizer];
    }
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _collectionView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    if([VEConfigManager sharedManager].iPad_HD){
        _topLayer.frame = CGRectMake(0, CGRectGetMinY(_collectionView.frame), _collectionView.frame.size.width, 15);
        _bottomLayer.frame = CGRectMake(0, CGRectGetMaxY(_collectionView.frame) - 20, _collectionView.frame.size.width, 20);
        _flowLayout.itemSize = CGSizeMake(frame.size.width,frame.size.height);
    }
}
@end
