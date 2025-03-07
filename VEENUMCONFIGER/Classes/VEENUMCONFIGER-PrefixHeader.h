//
//  VEENUMCONFIGER-PrefixHeader.h
//  VEENUMCONFIGER
//
//  Created by iOS VESDK Team on 2021/1/14.
//

#import <UIKit/UIKit.h>
#import <VEENUMCONFIGER/VEDefines.h>
#import <VEENUMCONFIGER/VEConfigManager.h>

#define VEENUMCONFIGERLocalizedString(key,des) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"VEENUMCONFIGER.bundle/%@", isEnglish ? @"en" : @"zh-Hans"] ofType:@"lproj"]] localizedStringForKey:(key) value:des table:@"VEENUMCONFIGER_Localizable"]

#define AECHITECTURES_ARM64

//#define NEED_DEBUG  //开启调试日志

#ifdef NEED_DEBUG

#define NSLog(...) NSLog(__VA_ARGS__)

#else

#define NSLog(...)

#endif
