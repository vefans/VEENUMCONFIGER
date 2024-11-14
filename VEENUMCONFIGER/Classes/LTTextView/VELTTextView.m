//
//  VELTTextView.m
//  VEDeluxeDemo
//
//  Created by iOS VESDK Team on 16/7/8.
//  Copyright © 2016年 iOS VESDK Team. All rights reserved.
//

#import "VELTTextView.h"
#import "VEHelp.h"
#import "VEWindow.h"
#import "VECustomTextView.h"

//这里是限制字数
#define MAX_WOVEDeluxe_LIMIT 200


@interface VELTTextView ()<UITextViewDelegate,UITextFieldDelegate>



@end
@implementation VELTTextView

#pragma mark - --- init 视图初始化 ---

+ (instancetype )placeholderTextView{
//    init方法内部会自动调用initWithFrame:方法
    return [[self alloc]init];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0x272727);
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        if([VEConfigManager sharedManager].backgroundStyle== UIBgStyleDarkContent){
            self.backgroundColor = UIColorFromRGB(0xefefef);
        }
        _textAlignment = NSTextAlignmentCenter;
        [self setupUI];

    }
    return self;
}
- (void)setupUI{
    [self addSubview:self.placeholderTextView];
    [self addSubview:self.textView];

}
#pragma mark - --- delegate 视图委托 ---

/**
 * 这个方法专门用来布局子控件，一般在这里设置子控件的frame
 * 当控件本身的尺寸发生改变的时候，系统会自动调用这个方法
 *
 */
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.textView.frame = self.bounds;
    self.placeholderTextView.frame = self.bounds;
    if (_textAlignment == NSTextAlignmentCenter && _textView.frame.size.height > _textView.contentSize.height) {
        _textView.contentInset = UIEdgeInsetsMake((_textView.frame.size.height - _textView.contentSize.height) / 2, 0, 0, 0);
        _placeholderTextView.contentInset = UIEdgeInsetsMake((_placeholderTextView.frame.size.height - _placeholderTextView.contentSize.height) / 2, 0, 0, 0);
    }else {
        _textView.contentInset = UIEdgeInsetsZero;
        _placeholderTextView.contentInset = UIEdgeInsetsZero;
    }

}
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        [_delegate textViewShouldBeginEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (_delegate && [_delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [_delegate textViewDidBeginEditing:textView];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length <= 1 && text.length == 0 && range.location == 0) {
        self.placeholderTextView.hidden = NO;
    }else{
        self.placeholderTextView.hidden =YES;
    }

//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
    if( _delegate && [_delegate respondsToSelector:@selector(textView: shouldChangeTextInRange: replacementText:)] )
    {
        return [_delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    else{
        return YES;
    }
}

/*由于联想输入的时候，函数textView:shouldChangeTextInRange:replacementText:无法判断字数，
 因此使用textViewDidChange对TextView里面的字数进行判断
 */
- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    if (selectedRange && pos) {
        return;
    }
    if (_maxNum > 0 && textView.text.length > _maxNum) {
        [VEWindow showMessage:[NSString stringWithFormat:VELocalizedString(@"提示：字数最多%d个", nil), _maxNum] duration:2.0];
        NSString *s = [textView.text substringToIndex:_maxNum];
        [textView setText:s];
    }
    if( _delegate && [_delegate respondsToSelector:@selector(textViewDidChange:)] )
    {
        return [_delegate textViewDidChange:textView];
    }
//    if (textView.text.length == 0) {
//        self.placeholderTextView.hidden = NO;
//
//
//    }else{
//        self.placeholderTextView.hidden =YES;
//
//    }
//
//    //该判断用于联想输入
//    if (textView.text.length > MAX_WOVEDeluxe_LIMIT)
//    {
//        textView.text = [textView.text substringToIndex:MAX_WOVEDeluxe_LIMIT];
//    }
}


- (VECustomTextView *)textView{
    if (!_textView) {
        _textView = [[VECustomTextView alloc] initWithFrame:self.bounds];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.textColor = TEXT_COLOR;
        if([VEConfigManager sharedManager].backgroundStyle== UIBgStyleDarkContent){
            _textView.textColor = UIColorFromRGB(0x131313);
        }
        _textView.textAlignment = NSTextAlignmentLeft;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 5; // 行间距
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                     NSForegroundColorAttributeName:_textView.textColor,
                                     NSParagraphStyleAttributeName:paragraphStyle};
        _textView.typingAttributes = attributes;
        _textView.delegate = self;
    }

    return _textView;
}
- (UITextView *)placeholderTextView{
    if (!_placeholderTextView) {
        _placeholderTextView = [[UITextView alloc] initWithFrame:self.bounds];
        _placeholderTextView.backgroundColor = [UIColor clearColor];
        _placeholderTextView.font = [UIFont systemFontOfSize:13];
        _placeholderTextView.textColor = UIColorFromRGB(0x727272);
        if([VEConfigManager sharedManager].backgroundStyle== UIBgStyleDarkContent){
            _textView.textColor = UIColorFromRGB(0x131313);
        }
        _placeholderTextView.text = kDefaultSubtitleText;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 5; // 行间距
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                     NSForegroundColorAttributeName:_placeholderTextView.textColor,
                                     NSParagraphStyleAttributeName:paragraphStyle};
        _placeholderTextView.typingAttributes = attributes;
    }
    return _placeholderTextView;
}

- (void)setSelectedRange:(NSRange)selectedRange {
    if (NSEqualRanges(_selectedRange, selectedRange)) {
        return;
    }
    _selectedRange = selectedRange;
    if (selectedRange.length == 0) {
        if (_textView.attributedText) {
#if 0
            NSString *text = _textView.attributedText.string;
            _textView.attributedText = nil;
            _textView.text = text;
            
            if (_textView.attributedText) {//之前选中了所有文字的情况，需要重新设置
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.alignment = NSTextAlignmentLeft;
                paragraphStyle.lineSpacing = 5; // 行间距
                _textView.attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: _textView.font, NSForegroundColorAttributeName: _textView.textColor, NSParagraphStyleAttributeName: paragraphStyle}];
            }
#else
            NSMutableAttributedString *plainText = [[NSMutableAttributedString alloc] initWithString:_textView.attributedText.string];
            _textView.attributedText = plainText;
            _textView.text = _textView.attributedText.string;
#endif
        }
    }else {
        NSString *selectedStr = [VEHelp getSubstring:_textView.text targetRange:selectedRange];
        
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:_textView.text];
        NSRange selectedStrRrange = [[attributedText string] rangeOfString:selectedStr];
        [attributedText addAttribute:NSBackgroundColorAttributeName value:[UIColorFromRGB(0xdddff8) colorWithAlphaComponent:0.26] range:selectedStrRrange];
        [attributedText addAttribute:NSFontAttributeName value:_textView.font range:NSMakeRange(0, _textView.text.length)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:_textView.textColor range:NSMakeRange(0, _textView.text.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        paragraphStyle.lineSpacing = 5; // 行间距
        [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _textView.text.length)];
        _textView.attributedText = attributedText;
    }
}

@end


