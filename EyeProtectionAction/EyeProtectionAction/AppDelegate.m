//
//  AppDelegate.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/24.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "AppDelegate.h"
#import <XHLaunchAd/XHLaunchAd.h>
#import "EyeWebViewController.h"
#import "EyeModel.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    imageAdconfiguration.duration = 1;
    imageAdconfiguration.skipButtonType = SkipTypeNone;
    NSString *imageName = [self defaultSplashImageMap][[self defaultSplashImageKey]];
    imageAdconfiguration.imageNameOrURLString = [NSString stringWithFormat:@"%@.png",imageName];
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    //Required
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    [JPUSHService setupWithOption:launchOptions appKey:@"e542338f75bb8224ddde6fc5"
                          channel:@"App Store"
#if DEBUG
                 apsForProduction:NO
#else
                 apsForProduction:YES
#endif
            advertisingIdentifier:advertisingId];
    return YES;
}

- (NSDictionary *) defaultSplashImageMap {
    return @{@"750*1334":@"LaunchImage-800-667h",
             @"640*1136":@"LaunchImage-800-Portrait-736h",
             @"640*960":@"LaunchImage-700",
             @"1242*2208":@"LaunchImage-800-Portrait-736h",
             @"1125*2436":@"LaunchImage-1100-Portrait-2436h",
             @"828*1792":@"LaunchImage-1200-Portrait-1792h",
             @"1242*2688":@"LaunchImage-1200-Portrait-2688h"};
}

- (NSString*) defaultSplashImageKey {
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *key = [NSString stringWithFormat:@"%.0f*%.0f",size.width * scale,size.height*scale];
    return key;
}


//-(void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
//
//    if(openModel==nil) return;
//
//    NSString *urlString = (NSString *)openModel;
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    EyeWebViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"webViewId"];
//    EyeModel *model = [EyeModel new];
//    model.icon = urlString;
//    vc.eyeModel = model;
//    UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
//    [rootVC.navigationController pushViewController:vc animated:YES];
//
//}

#pragma mark - UIApplicationDelegate
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}


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
