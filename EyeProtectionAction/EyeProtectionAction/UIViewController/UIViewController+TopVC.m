//
//  UIViewController+TopVC.m
//  SuYunDriver
//
//  Created by shirly on 2019/3/1.
//  Copyright © 2019年 58SuYun. All rights reserved.
//

#import "UIViewController+TopVC.h"

@implementation UIViewController (TopVC)

+ (UIViewController *)topViewController {
    
    UIViewController *rootViewController =[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    return [self getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            
            return vc;
        }
    }
}

@end
