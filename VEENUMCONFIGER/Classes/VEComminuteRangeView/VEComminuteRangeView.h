//
//  VEComminuteRangeView.h
//  VE
//
//  Created by iOS VESDK Team on 15/8/21.
//  Copyright (c) 2015年 iOS VESDK Team. All rights reserved.
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

