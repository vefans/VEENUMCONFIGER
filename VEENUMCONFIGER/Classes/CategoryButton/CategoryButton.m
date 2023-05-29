//
//  CategoryButton.m
//  VEENUMCONFIGER
//
//  Created by emmet-mac on 2023/4/20.
//

#import "CategoryButton.h"

@implementation CategoryButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _lineView = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 15) / 2.0, frame.size.height - 10, 15, 2)];
        _lineView.backgroundColor = Main_Color;
        _lineView.layer.cornerRadius = 1;
        _lineView.layer.masksToBounds = YES;
        _lineView.hidden = YES;
        [self addSubview:_lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        _lineView.hidden = NO;
    }else{
        _lineView.hidden = YES;
    }
}
@end

@implementation EMButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(frame)/2.0 - 20, frame.size.width - 20, 20)];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_textLabel];
        
        _desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_textLabel.frame), frame.size.width - 20, 15)];
        _desLabel.textColor = [UIColor blackColor];
        _desLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_desLabel];
    }
    return self;
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _textLabel.frame = CGRectMake(10, CGRectGetHeight(frame)/2.0 - 20, frame.size.width - 20, 20);
    _desLabel.frame = CGRectMake(10, CGRectGetMaxY(_textLabel.frame), frame.size.width - 20, 15);
}
@end
