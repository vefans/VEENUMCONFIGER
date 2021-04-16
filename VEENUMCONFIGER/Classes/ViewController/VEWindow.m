//
//  VEWindow.m

#import "VEWindow.h"
#import "objc/runtime.h"
@implementation VEWindow
static char _tipsKey;
static char _tapKey;

+(void)showMessage:(NSString * _Nullable)text duration:(float)duration {
    UITextView *tips = objc_getAssociatedObject(self, &_tipsKey);
    if(tips) {
        [self _dismiss];
        [NSThread sleepForTimeInterval:0.5f];
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGFloat maxWidth = 200;
    CGFloat maxHeight = window.frame.size.height - 200;
    CGFloat commonInset = 10;
    
    UIFont  *font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width), ceilf(rect.size.height < maxHeight ? rect.size.height : maxHeight));
    
    CGRect textFrame = CGRectMake(window.frame.size.width/2 - (size.width + commonInset * 2)/2 , (window.frame.size.height - (size.height + commonInset * 2))/2.0, size.width  + commonInset * 2, size.height + commonInset * 2);
    tips = [[UITextView alloc] initWithFrame:textFrame];
    tips.text = text;
    tips.font = font;
    tips.textColor = [UIColor whiteColor];
    tips.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    tips.layer.cornerRadius = 5;
    tips.editable = NO;
    tips.selectable = NO;
    tips.scrollEnabled = NO;
    tips.textContainer.lineFragmentPadding = 0;
    tips.contentInset = UIEdgeInsetsMake(commonInset, commonInset, commonInset, commonInset);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handlerGuesture:)];
    [window addGestureRecognizer:tap];
    [window addSubview:tips];
    
    objc_setAssociatedObject(self, &_tapKey, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &_tipsKey, tips, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self performSelector:@selector(_dismiss) withObject:nil afterDelay:duration];
}

+(void)_handlerGuesture:(UIGestureRecognizer *)sender {
    if(!sender || !sender.view)
        return;
    [self _dismiss];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_dismiss) object: nil];
}

+(void)_dismiss {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UITapGestureRecognizer *tap = objc_getAssociatedObject(self, &_tapKey);
    [window removeGestureRecognizer:tap];
    
    UITextView *tips = objc_getAssociatedObject(self, &_tipsKey);
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        tips.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [tips removeFromSuperview];
    }];
}

@end
