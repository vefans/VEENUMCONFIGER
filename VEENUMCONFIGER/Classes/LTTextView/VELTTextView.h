//
//  VELTTextView.h
//  VEDeluxeDemo
//
//  Created by iOS VESDK Team on 16/7/8.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VECustomTextView.h"

@class VELTTextView;

@protocol VELTTextViewDelegate <NSObject>
@optional
- (void)textViewShouldBeginEditing:(UITextView *)textView;
- (void)textViewDidBeginEditing:(UITextView *)textView;
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(UITextView *)textView;
@end

@interface VELTTextView : UIView

//默认0，无限制
@property (nonatomic, assign) int maxNum;

@property (weak, nonatomic) id<VELTTextViewDelegate>  delegate;

/**  */
@property (nonatomic, strong) VECustomTextView  *textView;

/** 占位*/
@property (nonatomic, strong) UITextView  *placeholderTextView;

/** Default is NSTextAlignmentCenter .*/
@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, assign) NSRange selectedRange;

+ (instancetype)placeholderTextView;
@end
