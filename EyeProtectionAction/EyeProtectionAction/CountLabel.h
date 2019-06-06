//
//  CountLabel.h
//  EyeProtectionAction
//
//  Created by 杨雪 on 2019/6/6.
//  Copyright © 2019 qxk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MyBlock)(void);
@interface CountLabel : UILabel
//开始倒计时时间
@property (nonatomic, assign) int count;

//执行这个方法开始倒计时
@property (nonatomic,copy)MyBlock ablock;
- (void)startCount;
@end

NS_ASSUME_NONNULL_END
