//
//  AppMacro.h
//  MyFramework
//
//  Created by zhangxi on 14-9-9.
//  Copyright (c) 2014年 renrendai. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - 系统版本
// 系统版本
#define SystemOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define IS_SYSTEM_VERSION(v) ([[UIDevice currentDevice] systemVersion].floatValue >= v && [[UIDevice currentDevice] systemVersion].floatValue < v + 1)

#define IS_IOS7 IS_SYSTEM_VERSION(7.0)
#define IS_IOS8 IS_SYSTEM_VERSION(8.0)
#define IS_IOS9 IS_SYSTEM_VERSION(9.0)
#define IS_IOS10 IS_SYSTEM_VERSION(10.0)

#define IS_IOS7_LATER (SystemOSVersion >= 7.0)
#define IS_IOS8_LATER (SystemOSVersion >= 8.0)
#define IS_IOS9_LATER (SystemOSVersion >= 9.0)
#define IS_IOS10_LATER (SystemOSVersion >= 10.0)
#define IS_IOS12_LATER (SystemOSVersion >= 12.0)

// 1 像素
#define PX_1 1/[[UIScreen mainScreen] scale]

//字体
#define SYFontWithSize(value) [UIFont systemFontOfSize:value]
#define SYBoldFontWithSize(value) [UIFont boldSystemFontOfSize:value]
// 手机型号
#pragma mark - 手机型号

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kScreenBounds       ([UIScreen mainScreen].bounds)
#define kScreenSize         ([UIScreen mainScreen].bounds.size)
#define kScreenBoundWidth   ([UIScreen mainScreen].bounds.size.width)
#define kScreenBoundHeight  ([UIScreen mainScreen].bounds.size.height)

#define ScaleY(Y) (Y / 375.0 * [UIScreen mainScreen].bounds.size.width)

#define kScreenScaleBase375(x)    ((x == 375) ? 1 : ((kScreenSize.width - x)/(375 - x)))//x 不参与计算比例


#define IS_IPHONE4      kScreenBoundHeight == 480
#define IS_IPHONE5      kScreenBoundHeight == 568
#define IS_IPHONE6      kScreenBoundHeight == 667
#define IS_IPHONE6P     kScreenBoundHeight == 736
#define IS_IPHONEX      kScreenBoundHeight == 812



#pragma mark - 默认参数
//
#define kStateBarHeight (IS_IPHONEX ? 44.0 : 20.0)

#define kNavigationHeight  (kStateBarHeight + 44.0)


#define kTabbarSafeAeraHeight (IS_IPHONEX ? 34 : 0)

#define kTabbarHeight (kTabbarSafeAeraHeight + 49.0)

#define KeyWindow ([UIApplication sharedApplication].keyWindow)

// 根试图
#define kRootNavigation ((UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController)
#define kRootViewController ([UIApplication sharedApplication].delegate.window.rootViewController)

#define kRootNavigationPush(__vc, __bool) (dispatch_async(dispatch_get_main_queue(), ^{[kRootNavigation pushViewController:__vc animated:__bool];}))
#define kRootNavigationPop(__bool) (dispatch_async(dispatch_get_main_queue(), ^{[kRootNavigation popViewControllerAnimated:NO];}))
#define kRootNavigationPopToRoot(__bool) (dispatch_async(dispatch_get_main_queue(), ^{[kRootNavigation popToRootViewControllerAnimated:__bool];}))
#define kRootNavigationPopTo(__vc, __bool) (dispatch_async(dispatch_get_main_queue(), ^{[kRootNavigation popToViewController:__vc animated:__bool];}))

#define ColorOfHex(value) [UIColor colorWithRed:((value&0xFF0000)>>16)/255.0 green:((value&0xFF00)>>8)/255.0 blue:(value&0xFF)/255.0 alpha:1.0]

//定义日志框架
#ifdef DEBUG
#define NSLog(format, ...) printf("[%s]   v%s [第%d行] %s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define NSLog(format, ...)
#endif




