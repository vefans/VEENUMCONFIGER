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
        if([VEConfigManager sharedManager].iPad_HD){
            [self.iconImageView setFrame:CGRectMake(10, 0, frame.size.width - 20, frame.size.height - 20)];
            [self.titleLabel setFrame:CGRectMake(0, frame.size.height - 20, frame.size.width, 20)];
        }else{
            [self.iconImageView setFrame:CGRectMake((frame.size.width - 24)/2, frame.size.height/2 -24, 24, 24)];
            [self.titleLabel setFrame:CGRectMake(0, (frame.size.height-30)/2 +10, frame.size.width, 30)];
        }
        
        self.layer.borderColor = Main_Color.CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

#pragma mark - 1.Setting View and Style

-(void)setupView{
    [self setBackgroundColor:[VEConfigManager sharedManager].iPad_HD ? VIEW_IPAD_COLOR : UIColorFromRGB(0x27262C)];
}


#pragma mark - 2.Custom Methods

-(void)setCellForoCropTypeModel:(VECropTypeModel*)cropTypeModel{
    float shaow = -5.0/90.0*cropTypeModel.height;
    if (cropTypeModel.isSelect) {
        self.layer.borderColor = Main_Color.CGColor;
        self.layer.borderWidth = [VEConfigManager sharedManager].iPad_HD ? 0 : 2;
        if( [cropTypeModel.title isKindOfClass:[NSString class]] )
        {
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:cropTypeModel.title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 12/90.0*cropTypeModel.height], NSForegroundColorAttributeName: Main_Color, NSStrokeWidthAttributeName:@(shaow),NSStrokeColorAttributeName:Main_Color
            }];
            self.titleLabel.attributedText = string;
        }
        else  if( [cropTypeModel.title isKindOfClass:[NSMutableAttributedString class]] )
        {
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
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    _height = cropTypeModel.height;
    
    if([VEConfigManager sharedManager].iPad_HD){
        [self.iconImageView setFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height - 20)];
        [self.titleLabel setFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
    }else{
        [self.iconImageView setFrame:CGRectMake((self.frame.size.width - 24.0/90.0*cropTypeModel.height)/2, self.frame.size.height/2 -24.0/90.0*cropTypeModel.height, 24.0/90.0*cropTypeModel.height, 24.0/90.0*cropTypeModel.height)];
        [self.titleLabel setFrame:CGRectMake(0, (self.frame.size.height-30.0/90.0*cropTypeModel.height)/2 +10.0/90.0*cropTypeModel.height, self.frame.size.width, 30.0/90.0*cropTypeModel.height)];
    }
    
}

-(void)setIsSelect:(BOOL)isSelect{
    _isSelect = isSelect;
}

-(void)layoutSubviews{
    if([VEConfigManager sharedManager].iPad_HD){
        [self.iconImageView setFrame:CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height - 20)];
        [self.titleLabel setFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
    }else{
        [self.iconImageView setFrame:CGRectMake((self.frame.size.width - 24.0/90.0*_height)/2, self.frame.size.height/2 -24.0/90.0*_height+2.0/90.0*_height, 24.0/90.0*_height, 24.0/90.0*_height)];
        [self.titleLabel setFrame:CGRectMake(0, (self.frame.size.height-30.0/90.0*_height)/2 +12.0/90.0*_height, self.frame.size.width, 30.0/90.0*_height)];
    }
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

