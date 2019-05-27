//
//  EyeSelectHeightViewController.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/25.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "EyeSelectHeightViewController.h"

@interface EyeSelectHeightViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *selectHeightPickView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation EyeSelectHeightViewController

- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger i = 80; i<= 220; i++) {
        [self.dataArr addObject:[NSString stringWithFormat:@"%ldcm",i]];
    }
    [self.selectHeightPickView selectRow:98 inComponent:0 animated:YES];
    [self pickerView:self.selectHeightPickView didSelectRow:98 inComponent:0];

}


- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArr.count;
}

//列显示的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    return self.dataArr[row];
}

#pragma mark - delegate
// 选中某一组的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.titleL.text = self.dataArr[row];
}





@end
