//
//  AppDelegate.m
//  EyeProtectionAction
//
//  Created by qxk on 2019/5/24.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "AppDelegate.h"
#import <XHLaunchAd/XHLaunchAd.h>
#import "EyeWebViewController.h"
#import "EyeModel.h"
#import "JPUSHService.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
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
    [JPUSHService setupWithOption:launchOptions appKey:@"e542338f75bb8224ddde6fc5"
                          channel:@"App Store"
#if DEBUG
                 apsForProduction:NO
#else
                 apsForProduction:YES
#endif
            advertisingIdentifier:nil];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}

- (NSDictionary *) defaultSplashImageMap {
    return @{@"750*1334":@"LaunchImage-800-667h",
             @"640*1136":@"LaunchImage-800-Portrait-736h",
             @"640*960":@"LaunchImage-700",
             @"1242*2208":@"LaunchImage-800-Portrait-736h",
             @"1125*2436":@"LaunchImage-1100-Portrait-2436h",
             @"828*1792":@"LaunchImage-1200-Portrait-1792h@2x",
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
    
    /// Required - DeviceToken
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
    }else{
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
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
