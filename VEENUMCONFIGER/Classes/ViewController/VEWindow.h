//
//  VEWindow.h


#import <UIKit/UIKit.h>
@interface VEWindow : UIWindow

+(void)showMessage:(NSString * _Nullable )text duration:(float)duration;
+(void)showMessage:(NSString * _Nullable)text pointy:(float)y duration:(float)duration;
@end
