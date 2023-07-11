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
    CGFloat maxWidth = window.frame.size.width - 100;
    CGFloat maxHeight = window.frame.size.height - 200;
    
    UIFont  *font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width + 10), ceilf(rect.size.height < maxHeight ? rect.size.height : maxHeight));
    size.width = size.width + 20;
    size.height = size.height + 20;
    CGRect textFrame = CGRectMake((window.frame.size.width - size.width)/2 , (window.frame.size.height - size.height)/2.0, size.width, size.height);
    tips = [[UITextView alloc] initWithFrame:textFrame];
    tips.text = text;
    tips.font = font;
    tips.textColor = [UIColor whiteColor];
    tips.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    tips.layer.cornerRadius = 5;
    tips.editable = NO;
    tips.selectable = NO;
    tips.scrollEnabled = NO;
    tips.textAlignment = NSTextAlignmentCenter;
    [tips sizeToFit];
    
    CGRect r = tips.frame;
    r.origin.y = (window.frame.size.height - r.size.height)/2.0;
    r.size.width = r.size.width + 20;
    r.origin.x = (window.frame.size.width - r.size.width)/2.0;
    tips.frame = r;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handlerGuesture:)];
//    [window addGestureRecognizer:tap];
    [window addSubview:tips];
    
    objc_setAssociatedObject(self, &_tapKey, tap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &_tipsKey, tips, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self performSelector:@selector(_dismiss) withObject:nil afterDelay:duration];
}
+(void)showMessage:(NSString * _Nullable)text pointy:(float)y duration:(float)duration {
    UITextView *tips = objc_getAssociatedObject(self, &_tipsKey);
    if(tips) {
        [self _dismiss];
        [NSThread sleepForTimeInterval:0.5f];
    }
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGFloat maxWidth = window.frame.size.width - 60;
    CGFloat maxHeight = window.frame.size.height - 200;
    
    UIFont  *font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
    CGRect rect = [string boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    CGSize size = CGSizeMake(ceilf(rect.size.width + 10), ceilf(rect.size.height < maxHeight ? rect.size.height : maxHeight));
    size.width = size.width + 20;
    size.height = size.height + 20;
    CGRect textFrame = CGRectMake((window.frame.size.width - size.width)/2 , (y - size.height/2.0), size.width, size.height);
    tips = [[UITextView alloc] initWithFrame:textFrame];
    tips.text = text;
    tips.font = font;
    tips.textColor = [UIColor whiteColor];
    tips.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    tips.layer.cornerRadius = 5;
    tips.editable = NO;
    tips.selectable = NO;
    tips.scrollEnabled = NO;
    tips.textAlignment = NSTextAlignmentCenter;
    [tips sizeToFit];
    CGRect r = tips.frame;
    r.origin.y = CGRectGetMidY(r) - r.size.height/2.0;
    r.size.height = r.size.height;
    r.size.width = r.size.width + 20;
    r.origin.x = CGRectGetMidX(r) - r.size.width/2.0;
    tips.frame = r;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handlerGuesture:)];
//    [window addGestureRecognizer:tap];
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
