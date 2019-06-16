//
//  EyeTool.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/6/16.
//  Copyright © 2019年 qxk. All rights reserved.
//

#import "EyeTool.h"

@implementation EyeTool
+ (instancetype)sharedSingleton {
    static EyeTool *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //不能再使用alloc方法
        //因为已经重写了allocWithZone方法，所以这里要调用父类的分配空间的方法
        _sharedSingleton = [[EyeTool alloc] init];
    });
    return _sharedSingleton;
}

- (NSMutableDictionary *)testResultDic
{
    if (!_testResultDic) {
        _testResultDic = [NSMutableDictionary new];
    }
    return _testResultDic;
}

@end
