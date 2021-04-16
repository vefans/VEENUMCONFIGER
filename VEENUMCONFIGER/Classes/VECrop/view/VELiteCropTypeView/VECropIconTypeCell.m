//
//  VECropIconTypeCell.m
//  VEENUMCONFIGER
//
//  Created by ios VESDK Team on 2021/3/19.
//

#import "VECropIconTypeCell.h"


@interface VECropIconTypeCell()
@end

@implementation VECropIconTypeCell


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.iconImageView];
        [self.iconImageView setFrame:CGRectMake((frame.size.width - 24)/2, frame.size.height/2 -24, 24, 24)];
        [self.titleLabel setFrame:CGRectMake(0, (frame.size.height-30)/2 +10, frame.size.width, 30)];
        
        self.layer.borderColor = Main_Color.CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
        
    }
    return self;
}

#pragma mark - 1.Setting View and Style

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
        self.iconImageView.image = cropTypeModel.iconSelecct;
        self.iconImageView.tintColor = Main_Color;
    }else{
        self.layer.borderColor = UIColorFromRGB(0x808080).CGColor;
        self.layer.borderWidth = 0;
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cropTypeModel.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12], NSForegroundColorAttributeName: UIColorFromRGB(0x808080), NSStrokeWidthAttributeName:@-5,NSStrokeColorAttributeName:UIColorFromRGB(0x808080)
        }];
        self.titleLabel.attributedText = string;
        self.iconImageView.image = cropTypeModel.iconNormal;
    }
    
    
    
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
}

-(void)layoutSubviews{
    
    [self.iconImageView setFrame:CGRectMake((self.frame.size.width - 24)/2, self.frame.size.height/2 -24+2, 24, 24)];
    [self.titleLabel setFrame:CGRectMake(0, (self.frame.size.height-30)/2 +12, self.frame.size.width, 30)];
}

#pragma mark - 3.Set & Get

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"1:1";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:@"PingFang SC" size: 12];
    }
    return _titleLabel;
}

-(UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

@end

