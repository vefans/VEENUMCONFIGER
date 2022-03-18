//
//  VENetworkMaterialBtn_Cell.m
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2020/8/31.
//  Copyright © 2020 iOS VESDK Team. All rights reserved.
//

#import "VENetworkMaterialBtn_Cell.h"

@implementation VENetworkMaterialBtn_Cell

- (void)dealloc{
//    NSLog(@"%s",__func__);
    if (_task) {
        [_task cancel];
    }
    if( [_btnCollectBtn isKindOfClass:[VEAddItemButton class]] )
    {
        VEAddItemButton * btn = (VEAddItemButton*)_btnCollectBtn;
        btn.isStartMove = false;
        [btn.thumbnailIV long_stopAnimating];
        btn.thumbnailIV.longGifData = nil;
        btn.thumbnailIV.image = nil;
        [btn stopScrollTitle];
        [btn.thumbnailIV removeFromSuperview];
        [btn removeFromSuperview];
        btn.thumbnailIV = nil;
        btn = nil;
    }else {
        if( [_btnCollectBtn isKindOfClass:[UIButton class]] )
        {
            LongCacheImageView * imageView = (LongCacheImageView*)[_btnCollectBtn viewWithTag:200000];
            if([imageView isKindOfClass:[LongCacheImageView class]]){
                
                [imageView long_stopAnimating];
                imageView.longGifData = nil;
                imageView.image = nil;
                [imageView removeFromSuperview];
                imageView = nil;
                [_btnCollectBtn removeFromSuperview];
                _btnCollectBtn = nil;
            }
        }
    }
}

@end
