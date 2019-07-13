//
//  AppDelegate.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/24.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "AppDelegate.h"
#import <XHLaunchAd/XHLaunchAd.h>
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchImage];
    //1.因为数据请求是异步的,请在数据请求前,调用下面方法配置数据等待时间.
    //2.设为3即表示:启动页将停留3s等待服务器返回广告数据,3s内等到广告数据,将正常显示广告,否则将不显示
    //3.数据获取成功,配置广告数据后,自动结束等待,显示广告
    //注意:请求广告数据前,必须设置此属性,否则会先进入window的的根控制器
//    [XHLaunchAd setWaitDataDuration:3];
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    imageAdconfiguration.duration = 3;
    NSString *imageName = [self defaultSplashImageMap][[self defaultSplashImageKey]];
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = [NSString stringWithFormat:@"%@.png",imageName];

    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    imageAdconfiguration.openModel = @"http://www.it7090.com";
    //显示图片开屏广告
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

/**
 广告点击事件代理方法
 */
-(void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint{
    
    NSLog(@"广告点击事件");
    
    /** openModel即配置广告数据设置的点击广告时打开页面参数(configuration.openModel) */
    
    if(openModel==nil) return;
    
    NSString *urlString = (NSString *)openModel;
    
    //此处跳转页面
    //WebViewController *VC = [[WebViewController alloc] init];
    //VC.URLString = urlString;
    ////此处不要直接取keyWindow
    //UIViewController* rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    //[rootVC.myNavigationController pushViewController:VC animated:YES];
    
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
