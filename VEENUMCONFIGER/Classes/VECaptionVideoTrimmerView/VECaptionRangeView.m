//
//  VECaptionRangeView.m
//  VE
//
//  Created by iOS VESDK Team on 15/9/28.
//  Copyright © 2015年 iOS VESDK Team. All rights reserved.
//

#import "VECaptionRangeView.h"
#import "VEHelp.h"
@implementation VECaptionRangeView

- (instancetype)init{
    self = [super init];
    if(self){
        self.file =[[VEVideoCaptionInfo alloc] init];
        self.file.scale = 0.8;
        self.layer.borderColor = ([VEConfigManager sharedManager].iPad_HD ? [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0] : [UIColor whiteColor]).CGColor;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    CGRect newFrame = frame;
    if(isnan(frame.size.width)){
        newFrame.size.width = 0;
    }
    if(isnan(frame.size.height)){
        newFrame.size.height = 0;
    }
    if(isnan(frame.origin.x)){
        newFrame.origin.x = 0;
    }
    if(isnan(frame.origin.y)){
        newFrame.origin.y = 0;
    }
    if (self = [super initWithFrame:newFrame]) {
        self.file =[[VEVideoCaptionInfo alloc] init];
        self.layer.borderColor = ([VEConfigManager sharedManager].iPad_HD ? [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0] : [UIColor whiteColor]).CGColor;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setCaptionText:(NSString *)captionText{
    self.titleLabel.text = captionText;
    [self setTitle:captionText forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.userInteractionEnabled = YES;
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.text = self.file.captionText;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = MATERIALMASKCOLOR;
        self.layer.borderWidth = 2.0;
        NSString * str = [VEHelp getLocalizedString:@"点击输入文字"];
        if (self.file.captionText.length > 0 && ![self.file.captionText isEqualToString:@"点击输入文字"] && ![self.file.captionText isEqualToString:str]) {
            [self setTitle:self.file.captionText forState:UIControlStateNormal];
        }
        self.titleLabel.hidden = NO;
        self.layer.cornerRadius = 5.0;
        
        CGRect frame = self.frame;
        frame.origin.y = 3;
        frame.size.height = self.superview.frame.size.height - 5;
        self.frame = frame;
    }else {
        self.backgroundColor = ADDEDMATERIALCOLOR;
        self.layer.borderWidth = 0.0;
        [self setTitle:@"" forState:UIControlStateNormal];
        self.layer.cornerRadius = 0.0;
        
        CGRect frame = self.frame;
        frame.origin.y = 0;
        frame.size.height = 2.0;
        self.frame = frame;
    }
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

@end

