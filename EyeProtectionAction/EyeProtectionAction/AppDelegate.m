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
@interface AppDelegate ()

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
