//
//  EyeStartTestViewController.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/6/3.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "EyeStartTestViewController.h"
#import "MLPickerScrollView.h"
#import "MLDemoItem.h"
#import "MLDemoModel.h"

@interface EyeStartTestViewController ()<MLPickerScrollViewDataSource,MLPickerScrollViewDelegate>

@property (nonatomic, strong) MLPickerScrollView *pickerScollView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *decimalData;
@property (nonatomic, strong) NSMutableArray *pointsData;
@property (weak, nonatomic) IBOutlet UILabel *selectTextL;
@property (weak, nonatomic) IBOutlet UIButton *decimalBtn;
@property (weak, nonatomic) IBOutlet UIButton *pointsBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointsTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *decimalTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *decimalHeight;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

@implementation EyeStartTestViewController

- (NSMutableArray *)decimalData
{
    if (!_decimalData) {
        _decimalData = [NSMutableArray array];
    }
    return _decimalData;
}

- (NSMutableArray *)pointsData
{
    if (!_pointsData) {
        _pointsData = [NSMutableArray array];
    }
    return _pointsData;
}

- (NSMutableArray *)data
{
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.layer.borderWidth = 2;
    self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.decimalBtn.layer.borderWidth = 2;
    self.decimalBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    NSArray *decimalTitleArray = @[@"4.0",@"4.1",@"4.2",@"4.3",@"4.4",@"4.5",@"4.6",@"4.7",@"4.8",@"4.9",@"5.0",@"5.1",@"5.2",@"5.3"];
    NSArray *pointsTitleArray1 = @[@"0.1",@"0.12",@"0.15",@"0.2",@"0.25",@"0.3",@"0.4",@"0.5",@"0.6",@"0.8",@"1.0",@"1.2",@"1.5",@"2.0"];

    for (int i = 0; i < decimalTitleArray.count; i++) {
        MLDemoModel *model = [[MLDemoModel alloc] init];
        model.dicountTitle = [decimalTitleArray objectAtIndex:i];
        [self.decimalData addObject:model];
    }
    for (int i = 0; i < pointsTitleArray1.count; i++) {
        MLDemoModel *model = [[MLDemoModel alloc] init];
        model.dicountTitle = [pointsTitleArray1 objectAtIndex:i];
        [self.pointsData addObject:model];
    }
    self.data = [NSMutableArray arrayWithArray:self.decimalData];
    // 2.初始化
    self.pickerScollView = [[MLPickerScrollView alloc] init];
    _pickerScollView.itemWidth = (self.view.frame.size.width - 42 - 136) / 5; //刚好显示5个的宽度
    _pickerScollView.itemHeight = (self.view.frame.size.width - 42 - 136) / 5;
    _pickerScollView.firstItemX = (self.view.frame.size.width - 42 - 136) / 2 - 20;
    _pickerScollView.dataSource = self;
    _pickerScollView.delegate = self;
    [self.view addSubview:_pickerScollView];
    [self.bgView addSubview:_pickerScollView];
    [_pickerScollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bgView);
        make.left.mas_equalTo(68);
        make.right.mas_equalTo(-68);
    }];
    // 3.刷新数据
    [_pickerScollView reloadData];
    _pickerScollView.seletedIndex = 3;
    [_pickerScollView scollToSelectdIndex:3];
}
- (IBAction)clickDecimalBtn:(UIButton *)sender {
    [sender setTitleEdgeInsets:(UIEdgeInsetsMake(10, 0, 0, 0))];
    [self.pointsBtn setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [sender setTitleColor:RGBA(15, 40, 120, 1) forState:(UIControlStateNormal)];
    [self.pointsBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.pointsTop.constant = 30;
    self.pointsHeight.constant = 44;
    self.decimalTop.constant = 20;
    self.decimalHeight.constant = 54;
    self.decimalBtn.layer.borderWidth = 0;
    self.decimalBtn.layer.masksToBounds = NO;
    self.pointsBtn.layer.cornerRadius = 7;
    self.pointsBtn.layer.masksToBounds = YES;
    self.pointsBtn.layer.borderWidth = 2;
    self.pointsBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.decimalBtn setBackgroundImage:[UIImage imageNamed:@"switchover"] forState:(UIControlStateNormal)];
    [self.pointsBtn setBackgroundImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];

}
- (IBAction)clickPointsBtn:(UIButton *)sender {
    [sender setTitleEdgeInsets:(UIEdgeInsetsMake(10, 0, 0, 0))];
    [sender setTitleColor:RGBA(15, 40, 120, 1) forState:(UIControlStateNormal)];
    [self.decimalBtn setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.decimalBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.pointsTop.constant = 20;
    self.pointsHeight.constant = 54;
    self.decimalTop.constant = 30;
    self.decimalHeight.constant = 44;
    self.pointsBtn.layer.borderWidth = 0;
    self.pointsBtn.layer.masksToBounds = NO;
    self.decimalBtn.layer.cornerRadius = 7;
    self.decimalBtn.layer.masksToBounds = YES;
    self.decimalBtn.layer.borderWidth = 2;
    self.decimalBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.pointsBtn setBackgroundImage:[UIImage imageNamed:@"switchover"] forState:(UIControlStateNormal)];
    [self.decimalBtn setBackgroundImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
}

#pragma mark - dataSource
- (NSInteger)numberOfItemAtPickerScrollView:(MLPickerScrollView *)pickerScrollView
{
    return self.data.count;
}

- (MLPickerItem *)pickerScrollView:(MLPickerScrollView *)pickerScrollView itemAtIndex:(NSInteger)index
{
    // creat
    MLDemoItem *item = [[MLDemoItem alloc] initWithFrame:CGRectMake(0, 0, 40,40)];
    
    // assignment
    MLDemoModel *model = [self.data objectAtIndex:index];
    model.dicountIndex = index;//标记数据模型上的index 取出来赋值也行
    item.title = model.dicountTitle;
    [item setRedTitle];
    
    // tap
    item.PickerItemSelectBlock = ^(NSInteger d){
        [self.pickerScollView scollToSelectdIndex:d];
    };
    
    return item;
}

- (void)pickerScrollView:(MLPickerScrollView *)menuScrollView
   didSelecteItemAtIndex:(NSInteger)index{
    
    MLDemoModel *model = [self.data objectAtIndex:index];
    self.selectTextL.font = [UIFont systemFontOfSize:48];
}

#pragma mark - delegate
- (void)itemForIndexChange:(MLPickerItem *)item
{
    [item changeSizeOfItem];
}

- (void)itemForIndexBack:(MLPickerItem *)item
{
    [item backSizeOfItem];
}

@end
