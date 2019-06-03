//
//  BaseViewController.h
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/25.
//  Copyright © 2019 qxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define E_Scale_Value(x)  ScreenWidth / 375 * x
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

@end

NS_ASSUME_NONNULL_END
