//
//  VELTTextView.h
//  LTTextvViewDemo
//
//  Created by WJX on 16/7/8.
//  Copyright © 2016年 wjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VELTTextView;

@protocol VELTTextViewDelegate <NSObject>
@optional
- (void)textViewShouldBeginEditing:(UITextView *)textView;
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(UITextView *)textView;
@end

@interface VELTTextView : UIView

@property (weak, nonatomic) id<VELTTextViewDelegate>  delegate;

/**  */
@property (nonatomic, strong) UITextView  *textView;

/** 占位*/
@property (nonatomic, strong) UITextView  *placeholderTextView;

+ (instancetype)placeholderTextView;
@end
