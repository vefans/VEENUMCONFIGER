//
//  VECustom.m
//  VEENUMCONFIGER
//
//  Created by macos team  on 2023/6/5.
//

#import "VECustomTextView.h"

@implementation VECustomTextView

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect orginalRect = [super caretRectForPosition:position];
    orginalRect.size.height = self.font.lineHeight + 2;
    
    return orginalRect;
}

@end
