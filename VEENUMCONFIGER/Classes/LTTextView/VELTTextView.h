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
-(BOOL)textView:(UITextView *_Nullable)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *_Nullable)text;
- (void)textViewDidChange:(UITextView *_Nullable)textView;
@end

@interface VELTTextView : UIView

@property (weak, nonatomic) id<VELTTextViewDelegate> _Nullable delegate;

/**  */
@property (nonatomic, strong, nullable) UITextView  *textView;

/** 占位*/
@property (nonatomic, strong, nullable) UITextView  *placeholderTextView;

+ (instancetype _Nullable )placeholderTextView;
@end
