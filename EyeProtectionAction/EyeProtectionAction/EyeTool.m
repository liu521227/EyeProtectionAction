//
//  EyeTool.m
//  EyeProtectionAction
//
//  Created by qxk on 2019/6/16.
//  Copyright © 2019年 qxk. All rights reserved.
//

#import "EyeTool.h"

@implementation EyeTool
+ (instancetype)sharedSingleton {
    static EyeTool *_sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
