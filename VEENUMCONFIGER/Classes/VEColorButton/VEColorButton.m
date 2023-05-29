//
//  VEColorButton.m
//  AFNetworking
//
//  Created by macos team  on 2023/4/28.
//

#import "VEColorButton.h"

@interface VEColorButton ()

@property (nonatomic, strong) UIView *selectedView;

@end

@implementation VEColorButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = frame.size.height / 2.0;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (UIView *)selectedView{
    if(!_selectedView){
        _selectedView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.height - 4)];
        _selectedView.layer.borderColor = ([VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : VIEW_COLOR).CGColor;
        _selectedView.layer.borderWidth = 2.5;
        _selectedView.layer.cornerRadius = CGRectGetWidth(_selectedView.frame)/2.0;
        _selectedView.layer.masksToBounds = YES;
        [self addSubview:_selectedView];
    }
    return _selectedView;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        self.selectedView.hidden = NO;
    }else{
        _selectedView.hidden = YES;
    }
}

@end
