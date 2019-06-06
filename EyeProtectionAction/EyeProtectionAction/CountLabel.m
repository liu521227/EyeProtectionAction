//
//  CountLabel.m
//  EyeProtectionAction
//
//  Created by 杨雪 on 2019/6/6.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "CountLabel.h"
@interface CountLabel()
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CountLabel

//开始倒计时
- (void)startCount{
    [self initTimer];
}

- (void)initTimer{
    //如果没有设置，则默认为3
    if (self.count == 0){
        self.count = 3;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];

}

- (void)countDown{
    if (_count > 0){
        self.text = [NSString stringWithFormat:@"%d",_count];
        CAKeyframeAnimation *anima2 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        //字体变化大小
        NSValue *value1 = [NSNumber numberWithFloat:2.0f];
        NSValue *value2 = [NSNumber numberWithFloat:1.0f];
        NSValue *value3 = [NSNumber numberWithFloat:0.5f];
        NSValue *value4 = [NSNumber numberWithFloat:0.8f];
        anima2.values = @[value1,value2,value3,value4];
        anima2.duration = 0.5;
        [self.layer addAnimation:anima2 forKey:@"scalsTime"];
        _count -= 1;
    }else {
        [_timer invalidate];
        [self removeFromSuperview];
        _ablock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
