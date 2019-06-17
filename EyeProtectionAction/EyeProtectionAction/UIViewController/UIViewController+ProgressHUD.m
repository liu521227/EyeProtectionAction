//
//  UIViewController+ProgressHUD.m
//  SuYunDriver
//
//  Created by 张佳炫 on 2017/9/2.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import "UIViewController+ProgressHUD.h"
#import <objc/runtime.h>

static char hudKey;

@implementation UIViewController (ProgressHUD)

- (void)dismiss{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud != nil) {
            [self.hud hideAnimated:YES];
            self.hud = nil;
        }
    });
}


- (void)loading{
    
    [self loading:@"加载中..."];
}

- (void)loading:(NSString *)errMsg{
    [self dismiss];
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = errMsg;
        self.hud = hud;
        [self setHUDCommonProperty];
        [self.hud showAnimated:YES];
    });
}


- (void)warning:(NSString *)errMsg{
    [self warning:errMsg interaction:YES];
}

- (void)warning:(NSString *)errMsg interaction:(BOOL)isEnabled{
    [self warning:errMsg stayForSecond:2 interaction:isEnabled];
}

- (void)warning:(NSString *)errMsg stayForSecond:(NSTimeInterval)second{
    [self warning:errMsg stayForSecond:second interaction:YES];
}

- (void)warning:(NSString *)errMsg completion:(void (^ )(void))completion{
    [self dismiss];
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = errMsg;
        hud.offset = CGPointMake(0.f, 0.f);
#warning "存疑: HUD内部执行有问题, 如果直接设置, 抢单页会卡死"
//        hud.completionBlock = completion;
        self.hud = hud;
        [self setHUDCommonProperty];
        [self.hud hideAnimated:YES afterDelay:2.f];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion();
    });
}

- (void)warning:(NSString *)errMsg stayForSecond:(NSTimeInterval)second interaction:(BOOL)isEnabled{
    [self dismiss];
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.text = errMsg;
        hud.offset = CGPointMake(0.f, 0.f);
        hud.userInteractionEnabled = isEnabled;
        self.hud = hud;
        [self setHUDCommonProperty];
        [self.hud hideAnimated:YES afterDelay:second];
    });
}


- (void)setHUDCommonProperty{
    self.hud.label.font = [UIFont systemFontOfSize:15];
    self.hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    self.hud.contentColor = [UIColor whiteColor];
    self.hud.bezelView.backgroundColor = [UIColor blackColor];
    self.hud.bezelView.alpha = 0.75;
    self.hud.removeFromSuperViewOnHide = YES;
}

- (MBProgressHUD *)hud
{
    return objc_getAssociatedObject(self, &hudKey);
}

- (void)setHud:(MBProgressHUD *)hud
{
    objc_setAssociatedObject(self, &hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
