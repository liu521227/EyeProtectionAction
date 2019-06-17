//
//  SYDProgressHUD.m
//  SuYunDriver
//
//  Created by shirly on 2017/8/2.
//  Copyright © 2017年 58SuYun. All rights reserved.
//
//  SYDLoadingRemindSer.m
//  learned by zhangqifeng on 03/01/2018.
//  Copyright (c) 2018 zhangqifeng. All rights reserved.

#import "SYDLoadingRemindSer.h"
#import "MBProgressHUD.h"

static MBProgressHUD *hud;
@implementation SYDLoadingRemindSer

+ (void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (hud != nil) {
            [hud hideAnimated:YES];
            hud = nil;
        }
    });
}

+ (void)loading {
    [SYDLoadingRemindSer loading:@"加载中..."];
}

+ (void)loading:(NSString *)errMsg {
    [SYDLoadingRemindSer dismiss];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.detailsLabel.text = errMsg;
        
        [SYDLoadingRemindSer setHUDCommonProperty];
        [hud showAnimated:YES];
    });
}

+ (void)warning:(NSString *)errMsg {

    [self warning:errMsg stayForSecond:2 interaction:NO];
}

+ (void)warning:(NSString *)errMsg stayForSecond:(NSTimeInterval)second interaction:(BOOL)isEnabled {
    [SYDLoadingRemindSer dismiss];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = errMsg;
        hud.offset = CGPointMake(0.f, 0.f);
        hud.userInteractionEnabled = isEnabled;
        
        [SYDLoadingRemindSer setHUDCommonProperty];
        [hud hideAnimated:YES afterDelay:second];
    });
}


+ (void)setHUDCommonProperty {
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    hud.contentColor = [UIColor whiteColor];
    hud.bezelView.backgroundColor = [UIColor blackColor];
    hud.bezelView.alpha = 0.75;
    hud.removeFromSuperViewOnHide = YES;
}


@end
