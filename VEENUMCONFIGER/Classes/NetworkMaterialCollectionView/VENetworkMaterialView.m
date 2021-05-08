//
//  VENetworkMaterialView.m
//  VEENUMCONFIGER
//
//  Created by apple on 2020/8/31.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VENetworkMaterialView.h"
#import "VENetworkMaterialCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>

@interface VENetworkMaterialView()<UICollectionViewDataSource,UICollectionViewDelegate,VENetworkMaterialCollectionViewCellDelegate
//,UIScrollViewDelegate
>
{
    NSTimer     *stopTimer;
}



@property(nonatomic, assign) BOOL               isVertical_Cell;
@property(nonatomic, assign) float              cellWidth;
@property(nonatomic, assign) float              cellHeight;

@end


@implementation VENetworkMaterialView

- (instancetype)initWithFrame:(CGRect)frame atCount:(NSInteger) count atIsVertical_Cell:(BOOL) isVertical_Cell atWidth:(float) cellWidth atHeight:(float) cellHeight
{
    if (self = [super initWithFrame:frame]) {
        _CollectionViewCount = count;
        _cellWidth = cellWidth;
        _isVertical_Cell = isVertical_Cell;
        _isNotMove = false;
        _cellHeight = cellHeight;
        //               _collectionView.contentInset = UIEdgeInsetsMake(0, self.frame.size.width/2.0, 0, self.frame.size.width/2.0);
    }
    return self;
    
}

-(void)initCollectView
{
    UICollectionViewFlowLayout * flow_Video = [[UICollectionViewFlowLayout alloc] init];
    flow_Video.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow_Video.itemSize = CGSizeMake(self.bounds.size.width,self.bounds.size.height);
    flow_Video.headerReferenceSize = CGSizeMake(0,0);
    flow_Video.footerReferenceSize = CGSizeMake(0,0);
    flow_Video.minimumLineSpacing = 0.0;
    flow_Video.minimumInteritemSpacing = 0.0;
    
    UICollectionView * videoCollectionView =  [[UICollectionView alloc] initWithFrame:
                                               
                                               
                                               
                                               self.bounds collectionViewLayout:flow_Video];
    videoCollectionView.backgroundColor = [UIColor clearColor];
    videoCollectionView.tag = 1000000;
    videoCollectionView.dataSource = self;
    videoCollectionView.delegate = self;
//    ((UIScrollView*)videoCollectionView).delegate = self;
    [videoCollectionView registerClass:[VENetworkMaterialCollectionViewCell class] forCellWithReuseIdentifier:@"NetworkMaterialCollectionViewCell"];
    _collectionView = videoCollectionView;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    UIPanGestureRecognizer* moveGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGesture:)];
    [_collectionView addGestureRecognizer:moveGesture];
}
//#pragma mark - UIScrollViewDelegate (时间轴的更新操作)
////开始滑动
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    _collectionOffsetPointX = scrollView.contentOffset.x;
//}
///**滚动停止
// */
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    float x =  scrollView.contentOffset.x ;
//
//    float leftX = x - _collectionOffsetPointX;
//
//    BOOL isLeft = true;
//
//    if( leftX == 0 )
//    {
//        [_collectionView setContentOffset:CGPointMake(_collectionOffsetPointX, 0) animated:true];
//        return;
//    }
//    else if( leftX > 0 )
//    {
//        isLeft = false;
//    }
//
//    if( x > ((_CollectionViewCount-1)*self.frame.size.width) )
//    {
//        x = (_CollectionViewCount-1)*self.frame.size.width;
//    }
//
//    _collectionView.contentOffset = CGPointMake(x, 0);
//
//    if( _isVertical_Cell )
//    {
//        double conffsetX = _collectionView.contentOffset.x;
//
//        NSInteger index = (NSInteger)(conffsetX/_collectionView.frame.size.width);
//        double RemaininX = conffsetX - _collectionView.frame.size.width*index;
//        if( ((RemaininX >= 10) && !isLeft)
//           || (RemaininX >= (_collectionView.frame.size.width - 10)) )
//        {
//            if( index > (_CollectionViewCount-1) )
//            {
//                index = _CollectionViewCount-1;
//            }
//            else
//            {
//                index++;
//            }
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if( _delegate && [_delegate respondsToSelector:@selector(CellIndex:atNetwork:)] )
//            {
//                [_delegate CellIndex:index atNetwork:self];
//            }
//
//            [_collectionView setContentOffset:CGPointMake(_collectionView.frame.size.width*(index), 0) animated:true];
//        });
//    }
//    else{
//
//    }
//}
//
///**手指停止滑动
// */
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    float x =  scrollView.contentOffset.x;
//
//    [_collectionView setContentOffset:CGPointMake(x, 0) animated:false];
//
//    float leftX = x - _collectionOffsetPointX;
//
//    BOOL isLeft = true;
//
//    if( leftX == 0 )
//    {
//        [_collectionView setContentOffset:CGPointMake(_collectionOffsetPointX, 0) animated:true];
//        return;
//    }
//    else if( leftX > 0 )
//    {
//        isLeft = false;
//    }
//
//    if( x > ((_CollectionViewCount-1)*self.frame.size.width) )
//    {
//        x = (_CollectionViewCount-1)*self.frame.size.width;
//    }
//
//    _collectionView.contentOffset = CGPointMake(x, 0);
//
//    if( _isVertical_Cell )
//    {
//        double conffsetX = _collectionView.contentOffset.x;
//
//        NSInteger index = (NSInteger)(conffsetX/_collectionView.frame.size.width);
//        double RemaininX = conffsetX - _collectionView.frame.size.width*index;
//        if( ((RemaininX >= 10) && !isLeft)
//           || (RemaininX >= (_collectionView.frame.size.width - 10)) )
//        {
//            if( index > (_CollectionViewCount-1) )
//            {
//                index = _CollectionViewCount-1;
//            }
//            else
//            {
//                index++;
//            }
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if( _delegate && [_delegate respondsToSelector:@selector(CellIndex:atNetwork:)] )
//            {
//                [_delegate CellIndex:index atNetwork:self];
//            }
//
//            [_collectionView setContentOffset:CGPointMake(_collectionView.frame.size.width*(index), 0) animated:true];
//        });
//    }
//    else{
//
//    }
//}
// 控制翻页
- (void) moveGesture:(UIGestureRecognizer *) recognizer{
    
    if( _CollectionViewCount == 1 )
    {
        [_collectionView setContentOffset:CGPointMake(0, 0) animated:false];
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
        
        [_collectionView setContentOffset:CGPointMake(x, 0) animated:false];
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        float x = _collectionOffsetPointX + (_collectionOffsetX - [recognizer locationInView:self.superview].x );
        
        [_collectionView setContentOffset:CGPointMake(x, 0) animated:false];
        
        float leftX = x - _collectionOffsetPointX;
        
        BOOL isLeft = true;
        
        if( leftX == 0 )
        {
            [_collectionView setContentOffset:CGPointMake(_collectionOffsetPointX, 0) animated:true];
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
        
        _collectionView.contentOffset = CGPointMake(x, 0);
        
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
                
                [self.collectionView setContentOffset:CGPointMake(self.collectionView.frame.size.width*(index), 0) animated:true];
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

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"NetworkMaterialCollectionViewCell";
    VENetworkMaterialCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.isNotMove = _isNotMove;
    
    if(!cell){
        cell = [[VENetworkMaterialCollectionViewCell alloc] initWithFrame:CGRectMake(self.bounds.size.width*indexPath.row, 0, self.bounds.size.width, self.bounds.size.height)];
    }
    else
    {
        [[SDImageCache sharedImageCache] clearMemory];
    }
    
    if( _delegate && [_delegate respondsToSelector:@selector(indexCountCell:atNetwork:)] )
        cell.indexCount = [_delegate indexCountCell:indexPath.row atNetwork:self];
    cell.index = indexPath.row;
    
    if( !cell.collectionView )
    {
        [cell initCollectView:_isVertical_Cell atWidth:_cellWidth atHeight:_cellHeight];
    }
    else{
        [cell.collectionView reloadData];
    }
    
    cell.tag = indexPath.row;
    
    return cell;
}

#pragma mark- 界面组装
-(UIView *)btnCollectCell:(NSInteger) index atIndexCount:(NSInteger) indexCount
{
    if( _delegate && [_delegate respondsToSelector:@selector(btnCollectCell:atIndexCount:atNetwork:)] )
        return [_delegate btnCollectCell:index atIndexCount:indexCount atNetwork:self];
    else
        return nil;
}

-(void)CellIndex:(NSInteger) index
{
    self.userInteractionEnabled = NO;
    stopTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(stop_Timer) userInfo:nil repeats:YES];
    
    if( _delegate && [_delegate respondsToSelector:@selector(CellIndex:atNetwork:)] )
    {
        [_delegate CellIndex:index atNetwork:self];
    }
    
}

- (void)dealloc{
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

@end