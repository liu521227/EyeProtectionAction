//
//  EyeTool.h
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/6/16.
//  Copyright © 2019年 qxk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EyeTool : NSObject
+ (instancetype)sharedSingleton;

@property (nonatomic, strong) NSMutableDictionary *testResultDic;
@property (nonatomic, assign) BOOL isLeftEye;
@end

NS_ASSUME_NONNULL_END
