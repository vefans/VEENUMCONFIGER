//
//  UIImageView+LongCachePrivate.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/10/22.
//

#import <UIKit/UIKit.h>

@interface LongCacheImageView:UIImageView
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) NSData *longGifData;
@property (nonatomic, strong) NSNumber *longIndex;
@property (nonatomic, strong) NSNumber *timeDuration;
@property (nonatomic, strong) NSString *urlKey;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGImageSourceRef imageSourceRef;

- (void)playGif;
- (void)long_startAnimating;
- (void)long_stopAnimating;

@end
