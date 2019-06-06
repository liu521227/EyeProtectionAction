//
//  MLDemoItem.m
//  MLPickerScrollView
//
//  Created by MelodyLuo on 15/8/14.
//  Copyright (c) 2015年 MelodyLuo. All rights reserved.
//

#define kITEM_WH ([[UIScreen mainScreen] bounds].size.width - 42 - 116) / 5
#define MLColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define kRGB220 MLColor(111, 135, 203, 1.0)
#define kRGB236 MLColor(51, 51, 51, 1.0)
#define E_Scale_Value(x)  [[UIScreen mainScreen] bounds].size.width / 375 * x

#import "MLDemoItem.h"
#import "JXButton.h"

@implementation MLDemoItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    _discount = [JXButton buttonWithType:UIButtonTypeCustom];
    _discount.enabled = NO;
    CGFloat itemW = kITEM_WH;
    CGFloat itemH = kITEM_WH;
    _discount.frame = CGRectMake(0, 0, itemW, itemH);
    [self addSubview:_discount];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [_discount setTitle:title forState:UIControlStateNormal];
    [_discount.titleLabel sizeToFit];
}

- (void)setRedTitle
{
    [_discount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setGrayTitle
{
    [_discount setTitleColor:kRGB220 forState:UIControlStateNormal];
}

/**
 *  改变item成红色. frame变大
 */
- (void)changeSizeOfItem
{
    [self setRedTitle];
    _discount.titleLabel.font = [UIFont systemFontOfSize:E_Scale_Value(22)];
}

/**
 *  改变item成灰色，frame变小
 */
- (void)backSizeOfItem
{
    [self setGrayTitle];
    _discount.titleLabel.font = [UIFont systemFontOfSize:E_Scale_Value(14)];

}

@end
