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
    [self.titleLabel setFrame:CGRectMake(0, (self.frame.size.height-40.0/90.0*_height)/2, self.frame.size.width, 40.0/90.0*_height)];
}



-(void)setupView{
    [self setBackgroundColor:[VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : UIColorFromRGB(0x272727)];
}


#pragma mark - 2.Custom Methods

-(void)setCellForoCropTypeModel:(VECropTypeModel*)cropTypeModel{
    float shaow = -5.0/90.0*cropTypeModel.height;
    if (cropTypeModel.isSelect) {
        self.layer.borderColor = Main_Color.CGColor;
        self.layer.borderWidth = 2;
        if( [cropTypeModel.title isKindOfClass:[NSString class]] )
        {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cropTypeModel.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12/90.0*cropTypeModel.height], NSForegroundColorAttributeName: Main_Color, NSStrokeWidthAttributeName:@(shaow),NSStrokeColorAttributeName:Main_Color
            }];
            self.titleLabel.attributedText = string;
        }
        else  if( [cropTypeModel.title isKindOfClass:[NSMutableAttributedString class]] ){
            self.titleLabel.attributedText = cropTypeModel.selecctTitle;
        }
        self.iconImageView.image = cropTypeModel.iconSelecct;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconImageView.tintColor = Main_Color;
    }else{
        self.layer.borderColor = UIColorFromRGB(0x808080).CGColor;
        self.layer.borderWidth = 0;
        if( [cropTypeModel.title isKindOfClass:[NSString class]] )
        {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cropTypeModel.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12/90.0*cropTypeModel.height], NSForegroundColorAttributeName: UIColorFromRGB(0x808080), NSStrokeWidthAttributeName:@(shaow),NSStrokeColorAttributeName:UIColorFromRGB(0x808080)
            }];
            self.titleLabel.attributedText = string;
        }
        else if( [cropTypeModel.title isKindOfClass:[NSMutableAttributedString class]] )
            self.titleLabel.attributedText = cropTypeModel.title;
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconImageView.image = cropTypeModel.iconNormal;
    }
    _height = cropTypeModel.height;
    [self.titleLabel setFrame:CGRectMake(0, (self.frame.size.height-40.0/90.0*_height)/2, self.frame.size.width, 40.0/90.0*_height)];
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
