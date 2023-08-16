//
//  VECustomButton.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 16/8/16.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VECustomButton;

@protocol VECustomButtonDelegate <NSObject>

@optional
-(void)custom_moveGesture:(UIGestureRecognizer *) recognizer atBtn:(UIButton *) btn;

@end

@interface VECustomButton : UIButton
@property (nonatomic,strong)NSMutableDictionary *paramsDic;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,assign)NSInteger indexRow;
@property (nonatomic,strong)id object;

@property (nonatomic, strong)NSString   *url;
@property (nonatomic, strong)NSString   *name;

@property(nonatomic,weak)id<VECustomButtonDelegate>   delegate;

-(void)set_Recognizer;

@end

@interface VETabButton : UIButton

/**
 *  The size of the selected state font. The default is consistent with the normal state.
 */
@property (nonatomic, assign) CGFloat selectedFontSize;

/**
 *  The size of the normal state font. The default is 14.
 */
@property (nonatomic, assign) CGFloat normalFontSize;

@end
