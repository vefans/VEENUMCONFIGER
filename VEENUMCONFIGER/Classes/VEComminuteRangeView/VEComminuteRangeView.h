//
//  VEComminuteRangeView.h
//  VE
//
//  Created by emmet on 15/8/21.
//  Copyright (c) 2015年 emmet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VEENUMCONFIGER/VEMediaInfo.h>
#import <AVFoundation/AVFoundation.h>

@interface VEComminuteRangeView : UIImageView{
    
}

@property (nonatomic,strong)VEMediaInfo *file;
@property (nonatomic,strong)UIImage *thumb;
@property (nonatomic,strong)NSString *path;
@end

