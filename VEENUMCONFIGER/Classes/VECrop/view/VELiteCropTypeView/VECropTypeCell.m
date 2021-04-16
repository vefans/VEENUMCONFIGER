//
//  VECropTypeCell.m
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import "VECropTypeCell.h"


@implementation VECropTypeCell


#pragma mark - 1.Setting View and Style
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        [self addSubview:self.titleLabel];
        [self.titleLabel setFrame:CGRectMake(0, (frame.size.height-40)/2, frame.size.width, 40)];
        
        self.layer.borderColor = Main_Color.CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

-(void)layoutSubviews{
    [self.titleLabel setFrame:CGRectMake(0, (self.frame.size.height-40)/2, self.frame.size.width, 40)];
}



-(void)setupView{
    [self setBackgroundColor:UIColorFromRGB(0x27262C)];
}


#pragma mark - 2.Custom Methods

-(void)setCellForoCropTypeModel:(VECropTypeModel*)cropTypeModel{
    if (cropTypeModel.isSelect) {
        self.layer.borderColor = Main_Color.CGColor;
        self.layer.borderWidth = 2;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cropTypeModel.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: Main_Color, NSStrokeWidthAttributeName:@-5,NSStrokeColorAttributeName:Main_Color
        }];

        self.titleLabel.attributedText = string;
    }else{
        self.layer.borderColor = UIColorFromRGB(0x808080).CGColor;
        self.layer.borderWidth = 0;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cropTypeModel.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: UIColorFromRGB(0x808080), NSStrokeWidthAttributeName:@-5,NSStrokeColorAttributeName:UIColorFromRGB(0x808080)
        }];
        self.titleLabel.attributedText = string;
    }
}


-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;

}

#pragma mark - 3.Set & Get

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"1:1";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"PingFang SC" size: 12];
    }
    return _titleLabel;
}

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.tintColor = Main_Color;
    }
    return _iconImageView;
}

@end
