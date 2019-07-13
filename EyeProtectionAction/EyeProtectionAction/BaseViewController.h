//
//  BaseViewController.h
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/25.
//  Copyright © 2019 qxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "EyeTool.h"
#import <RTRootNavigationController/RTRootNavigationController.h>
#import "MJExtension.h"
#import <AFNetworking/AFNetworking.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define E_Scale_Value(x)  ScreenWidth / 375 * x
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
- (void)back;
@end

NS_ASSUME_NONNULL_END
