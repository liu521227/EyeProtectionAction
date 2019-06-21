//
//  AppDelegate.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/24.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "AppDelegate.h"
#import "XGPush.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<XGPushDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[XGPush defaultManager]setEnableDebug:YES];
    [[XGPush defaultManager] startXGWithAppID:2200336927 appKey:@"I458XE1FH8WK" delegate:self];
    // 清除角标
    if ([XGPush defaultManager].xgApplicationBadgeNumber > 0) {
        [[XGPush defaultManager] setXgApplicationBadgeNumber:0];
    }
    [[XGPush defaultManager] reportXGNotificationInfo:launchOptions];
    return YES;
}

/**
 @brief 监控信鸽推送服务地启动情况
 
 @param isSuccess 信鸽推送是否启动成功
 @param error 信鸽推送启动错误的信息
 */
- (void)xgPushDidFinishStart:(BOOL)isSuccess error:(nullable NSError *)error{
    NSLog(@"-=--%@",error);
}

/**
 @brief 向信鸽服务器注册设备token的回调
 
 @param deviceToken 当前设备的token
 @param error 错误信息
 @note 当前的token已经注册过之后，将不会再调用此方法
 */
- (void)xgPushDidRegisteredDeviceToken:(nullable NSString *)deviceToken error:(nullable NSError *)error{
    NSLog(@"====%@",error);
}

/**
 收到推送的回调
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[XGPush defaultManager] reportXGNotificationInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知
// App 用户选择通知中的行为
// App 用户在通知中心清除消息
// 无论本地推送还是远程推送都会走这个回调
- (void)xgPushUserNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSLog(@"[XGDemo] click notification");
    if ([response.actionIdentifier isEqualToString:@"xgaction001"]) {
        NSLog(@"click from Action1");
    } else if ([response.actionIdentifier isEqualToString:@"xgaction002"]) {
        NSLog(@"click from Action2");
    }
    
    [[XGPush defaultManager] reportXGNotificationResponse:response];
    
    completionHandler();
}
#endif

/**
 统一收到通知消息的回调
 @param notification 消息对象
 @param completionHandler 完成回调
 @note SDK 3.2.0+
 */
- (void)xgPushDidReceiveRemoteNotification:(id)notification withCompletionHandler:(void (^)(NSUInteger))completionHandler {
    if ([notification isKindOfClass:[NSDictionary class]]) {
        [[XGPush defaultManager] reportXGNotificationInfo:(NSDictionary *)notification];
        completionHandler(UIBackgroundFetchResultNewData);
    } else if ([notification isKindOfClass:[UNNotification class]]) {
        [[XGPush defaultManager] reportXGNotificationInfo:((UNNotification *)notification).request.content.userInfo];
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
    }
}

- (void)xgPushDidSetBadge:(BOOL)isSuccess error:(NSError *)error {
    NSLog(@"%s, result %@, error %@", __FUNCTION__, error?@"NO":@"OK", error);
}


#pragma mark - UIApplicationDelegate

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
