//
//  UIViewController+ProgressHUD.h
//  SuYunDriver
//
//  Created by 张佳炫 on 2017/9/2.
//  Copyright © 2017年 58SuYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (ProgressHUD)

@property (nonatomic, strong) MBProgressHUD *hud;

- (void)loading;

- (void)dismiss;

- (void)loading:(NSString *)errMsg;

- (void)warning:(NSString *)errMsg;

/**
 @param errMsg 提示信息
 @param isEnabled ProgressHUD是否可交互
 */
- (void)warning:(NSString *)errMsg interaction:(BOOL)isEnabled;

- (void)warning:(NSString *)errMsg stayForSecond:(NSTimeInterval)second;

- (void)warning:(NSString *)errMsg stayForSecond:(NSTimeInterval)second interaction:(BOOL)isEnabled;

//zhulinfang
- (void)warning:(NSString *)errMsg completion:(void (^ )(void))completion;

@end
