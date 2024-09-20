//
//  VEYYAnnimationImageView.h
//  VESpecialCamera
//
//  Created by mac on 2024/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VEYYAnnimationImageView : UIImageView

+(VEYYAnnimationImageView *) createAnimationImageView:( UIView * ) view atImageUrl:(NSURL *)imageUrl atPlaceholder:( UIImage * ) placeholder atIsRelease:( BOOL ) isRelease;

+(void)btn_LoadImagge:( UIButton * ) sender atUrl:( NSURL * ) url forState:( UIControlState ) state;

+(NSInteger)gettAnimationImageView;

+(UIImage *)getWebp:( NSString * ) path;

+(void)animatioonnImageView_CancelCurrentImageRequest:( UIView * ) view;

+( void )YYWebImageMarnager_RemoveAllObjects;

+(void)setDecodeForDisplay:( BOOL ) decodeForDisplay;
@end

NS_ASSUME_NONNULL_END
