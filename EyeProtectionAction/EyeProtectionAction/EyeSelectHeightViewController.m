//
//  EyeSelectHeightViewController.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/25.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "EyeSelectHeightViewController.h"
#import <PGPickerView/PGPickerView.h>
#import "SystemMacro.h"

@interface EyeSelectHeightViewController ()<PGPickerViewDataSource,PGPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) PGPickerView *pgPickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeft;
@end

@implementation EyeSelectHeightViewController

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (PGPickerView *)pgPickerView
{
    if (!_pgPickerView) {
        _pgPickerView = [PGPickerView new];
        _pgPickerView.rowHeight = 38;
        _pgPickerView.textFontOfOtherRow = [UIFont systemFontOfSize:15];
        _pgPickerView.textColorOfOtherRow = [UIColor whiteColor];
        _pgPickerView.textFontOfSelectedRow = [UIFont systemFontOfSize:15];
        _pgPickerView.textColorOfSelectedRow = [UIColor whiteColor];
        _pgPickerView.delegate = self;
        _pgPickerView.dataSource = self;
        [self.view addSubview:_pgPickerView];
    }
    return _pgPickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;

    self.titleLeft.constant = E_Scale_Value(145);
    
    for (NSInteger i = 80; i<= 220; i++) {
        [self.dataArr addObject:[NSString stringWithFormat:@"%ldcm",i]];
    }
    if (kScreenBoundWidth < 321) {
        [self.pgPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
            make.right.mas_equalTo(25);
            make.height.mas_equalTo(322);
            make.width.mas_equalTo(130);
        }];
    }else {
        
        [self.pgPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(40);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(342);
            make.width.mas_equalTo(150);
        }];
    }
//    [self.pgPickerView selectRow:98 inComponent:0 animated:YES];
//    [self pickerView:self.pgPickerView didSelectRow:98 inComponent:0];

}

- (void)back
{
    [self.rt_navigationController popToRootViewControllerAnimated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull PGPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull PGPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArr.count;
}

//列显示的数据
- (NSString *)pickerView:(PGPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    return self.dataArr[row];
}

#pragma mark - delegate
// 选中某一组的某一行
- (void)pickerView:(PGPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.titleL.text = self.dataArr[row];
}


@end
