//
//  SYDProgressHUD.h
//  SuYunDriver
//
//  Created by shirly on 2017/8/2.
//  Copyright © 2017年 58SuYun. All rights reserved.

//  SYDLoadingRemindSer.h
//  learned by zhangqifeng on 03/01/2018.
//  Copyright (c) 2018 zhangqifeng. All rights reserved.

#import <Foundation/Foundation.h>

@interface SYDLoadingRemindSer : NSObject

+ (void)dismiss;

+ (void)loading;

+ (void)loading:(NSString *)errMsg;


+ (void)warning:(NSString *)errMsg;

+ (void)warning:(NSString *)errMsg stayForSecond:(NSTimeInterval)second interaction:(BOOL)isEnabled;

@end
