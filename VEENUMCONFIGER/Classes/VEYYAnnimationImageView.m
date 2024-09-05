//
//  VEYYAnnimationImageView.m
//  VESpecialCamera
//
//  Created by mac on 2024/8/24.
//

#import "VEYYAnnimationImageView.h"
#import <YYImage/YYImage.h>
#import <YYWebImage/UIImageView+YYWebImage.h>
#import <YYWebImage/UIButton+YYWebImage.h>
#import <YYWebImage/YYWebImageManager.h>
#import <YYCache/YYCache.h>
#import <YYImage/YYAnimatedImageView.h>
#import <VEENUMCONFIGER/LongCacheImageView.h>
@interface VEYYAnnimationImageView()
{
    BOOL _isRelease;
}
@property(nonatomic, strong) YYAnimatedImageView *animatiionImageView;
@end

@implementation VEYYAnnimationImageView

+(NSInteger)gettAnimationImageView{
    return 123450;
}

+(UIImage *)getWebp:( NSString * ) path
{
    YYImage *imagee = [YYImage imageNamed:path];
    return imagee;
}

+(VEYYAnnimationImageView *) createAnimationImageView:( UIView * ) view atImageUrl:(NSURL *)imageUrl atPlaceholder:( UIImage * ) placeholder atIsRelease:( BOOL ) isRelease{
    VEYYAnnimationImageView * imageView = nil;
    if( [view viewWithTag:123450] )
    {
        imageView = [view viewWithTag:123450];
        [imageView removeFromSuperview];
        imageView = nil;
    }
    imageView = [[VEYYAnnimationImageView alloc] initWithFrame:view.bounds];
    imageView->_isRelease = isRelease;
    if( [view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[LongCacheImageView class]] )
    {
        imageView.contentMode = ((UIImageView*)view).contentMode;
    }
    else
    {
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    [imageView setImageUrl:imageUrl atPlaceholder:placeholder];
  
    [view addSubview:imageView];
    return imageView;
}

- (instancetype)initWithFrame:( CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.tag = 123450;
    }
    return self;
}

-(void)setImageUrl:(NSURL *)imageUrl  atPlaceholder:( UIImage * ) placeholder{
    if( self.animatiionImageView == nil )
    {
        self.animatiionImageView = [[YYAnimatedImageView alloc] initWithFrame:self.frame];
        self.animatiionImageView.contentMode = self.contentMode;
        [self addSubview:self.animatiionImageView];
    }
    if( _isRelease )
    {
        [self.animatiionImageView yy_cancelCurrentImageRequest];
    }
    [self.animatiionImageView yy_setImageWithURL:imageUrl placeholder:placeholder];
}

+(void)btn_LoadImagge:( UIButton * ) sender atUrl:( NSURL * ) url forState:( UIControlState ) state
{
    [sender yy_setImageWithURL:url forState:state placeholder:nil];
}

+(void)animatioonnImageView_CancelCurrentImageRequest:( UIView * ) view
{
    if( [view viewWithTag:123450] )
    {
        UIView * imageView = [view viewWithTag:123450];
        [imageView removeFromSuperview];
    }
}
- (void)dealloc
{
    if( self.animatiionImageView
//       && self->_isRelease
       )
    {
        [self.animatiionImageView yy_setImageWithURL:nil placeholder:nil];
        [self.animatiionImageView yy_cancelCurrentImageRequest];
        [self.animatiionImageView removeFromSuperview];
        self.animatiionImageView = nil;
        [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
        [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
    }
}
+( void )YYWebImageMarnager_RemoveAllObjects
{
    [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
//    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjectsWithBlock:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
