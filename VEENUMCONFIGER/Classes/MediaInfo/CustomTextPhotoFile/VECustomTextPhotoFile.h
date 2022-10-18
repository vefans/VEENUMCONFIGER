//
//  VECustomTextPhotoFile.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 15/11/9.
//  Copyright © 2015年 iOS VESDK Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ContentAlignment) {
    kContentAlignmentCenter,
    kContentAlignmentLeft,
    kContentAlignmentRight
};

@interface VECustomTextPhotoFile : NSObject

@property (nonatomic,assign)CGSize      photoRectSize;
@property (nonatomic,assign)NSInteger   textColorIndex;
@property (nonatomic,assign)NSInteger   backColorIndex;
@property (nonatomic,copy)NSString    *textContent;
@property (nonatomic,copy)NSString    *font_Name;
@property (nonatomic,copy)NSString    *fontPath;
@property (nonatomic,copy)NSString      *filePath;
@property (nonatomic,assign)float       font_pointSize;
@property (nonatomic,assign)ContentAlignment    contentAlignment;
@property (nonatomic,strong)UIColor *textColor;
@property (nonatomic,strong)CATextLayer *textLayer;

- (void)refreshTextLayer;

@end
