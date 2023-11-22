//
//  ExitCloseView.m
//  VEENUMCONFIGER
//
//  Created by mac on 2023/11/13.
//

#import "ExitCloseView.h"
#import "VEHelp.h"

@implementation ExitCloseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        float height = 48;
        float width = 178.0;
        
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake( 15.0, (iPhone_X ? 44 : 0) + 44, width, height)];
//        [self.saveBtn setContentCompressionResistancePriority:998.f forAxis:UILayoutConstraintAxisHorizontal];;
        [self addSubview:_saveBtn];
        self.saveBtn.backgroundColor = [UIColor whiteColor];
        [self.saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0, self.saveBtn.frame.size.width - 15.0*2.0, height)];
            label.font = [UIFont systemFontOfSize:14];
            label.text =  VELocalizedString(@"Save Draft and Exit",nil);
            label.textColor = [UIColor blackColor];
            [self.saveBtn addSubview:label];
            
            float btnWidth = [VEHelp widthForString:label.text andHeight:height font:label.font] + 70;
            if (btnWidth > width) {
                width = btnWidth;
                _saveBtn.frame = CGRectMake( 15.0, (iPhone_X ? 44 : 0) + 44, width, height);
                label.frame = CGRectMake(20.0, 0, self.saveBtn.frame.size.width - 15.0*2.0, height);
            }
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.saveBtn.frame.size.width - 35.0 - 10.0, (self.saveBtn.frame.size.height - 35.0)/2.0, 35.0, 35.0)];
            imageView.image = [VEHelp imageNamed:@"/exit/退出选项-保存草稿并退出"];
            [self.saveBtn addSubview:imageView];
        }
        {
            UIImage *image = [VEHelp gradientImageWithColors:[NSMutableArray arrayWithObjects:UIColorFromRGB(0xdddff8),UIColorFromRGB(0xefe5e7),UIColorFromRGB(0xfbdcdb), nil] size:self.saveBtn.frame.size cornerRadius:5.0];
            [self.saveBtn setImage:image forState:UIControlStateNormal];
        }
        self.saveBtn.layer.cornerRadius =  self.saveBtn.frame.size.height/2.0;
        self.saveBtn.layer.masksToBounds = true;
        
        self.noSaveBtn = [[UIButton alloc] initWithFrame:CGRectMake( 15.0, (iPhone_X ? 44 : 0) + 44 + 20 + height, width, height)];
        [self addSubview:_noSaveBtn];
        self.noSaveBtn.backgroundColor = [UIColor whiteColor];
        [self.noSaveBtn addTarget:self action:@selector(noSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0, self.noSaveBtn.frame.size.width - 15.0*2.0, height)];
            label.font = [UIFont systemFontOfSize:14];
            label.text =  VELocalizedString(@"Do not save",nil);
            label.textColor = [UIColor blackColor];
            [self.noSaveBtn addSubview:label];
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.noSaveBtn.frame.size.width - 35.0 - 10.0, (self.noSaveBtn.frame.size.height - 35.0)/2.0, 35.0, 35.0)];
            imageView.image = [VEHelp imageNamed:@"/exit/退出选项-不保存"];
            [self.noSaveBtn addSubview:imageView];
        }
        self.noSaveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.noSaveBtn.layer.cornerRadius =  self.noSaveBtn.frame.size.height/2.0;
        self.noSaveBtn.layer.masksToBounds = true;
        
        self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake( 15.0, (iPhone_X ? 44 : 0) + 44 + 20 + height + 20 + height, width, height)];
        [self addSubview:_cancelBtn];
        self.cancelBtn.backgroundColor = [UIColor whiteColor];
        [self.cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        {
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0, self.cancelBtn.frame.size.width - 15.0*2.0, height)];
            label.font = [UIFont systemFontOfSize:14];
            label.text =  VELocalizedString(@"取消",nil);
            label.textColor = [UIColor blackColor];
            [self.cancelBtn addSubview:label];
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.cancelBtn.frame.size.width - 35.0 - 10.0, (self.cancelBtn.frame.size.height - 35.0)/2.0, 35.0, 35.0)];
            imageView.image = [VEHelp imageNamed:@"/exit/退出选项-取消"];
            [self.cancelBtn addSubview:imageView];
        }
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.cancelBtn.layer.cornerRadius = self.cancelBtn.frame.size.height/2.0;
        self.cancelBtn.layer.masksToBounds = true;
    }
    return self;
}

-(void)saveBtn:( UIButton * ) btn
{
    if( _delegate && [_delegate respondsToSelector:@selector(saveChange:)] )
    {
        [_delegate saveChange:self];
    }
}
-(void)noSaveBtn:( UIButton * ) btn
{
    if( _delegate && [_delegate respondsToSelector:@selector(noSaveChange:)] )
    {
        [_delegate noSaveChange:self];
    }
}
-(void)cancelBtn:( UIButton * ) btn
{
    if( _delegate && [_delegate respondsToSelector:@selector(cancelChange:)] )
    {
        [_delegate cancelChange:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
