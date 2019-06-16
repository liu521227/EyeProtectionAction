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

typedef enum : NSUInteger {
    EyeImageOrientationTypeTop,
    EyeImageOrientationTypeLeft,
    EyeImageOrientationTypeBottom,
    EyeImageOrientationTypeRight
} EyeImageOrientationType;

@interface EyeStartTestViewController ()<MLPickerScrollViewDataSource,MLPickerScrollViewDelegate>

@property (nonatomic, strong) MLPickerScrollView *pickerScollView;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *decimalData;
@property (nonatomic, strong) NSMutableArray *pointsData;
@property (nonatomic, strong) NSMutableArray *fontArr;
@property(nonatomic, strong) NSMutableDictionary *imageData;
@property (weak, nonatomic) IBOutlet UIButton *decimalBtn;
@property (weak, nonatomic) IBOutlet UIButton *pointsBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointsTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pointsHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *decimalTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *decimalHeight;
@property (weak, nonatomic) IBOutlet UIButton *invisibilityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) NSMutableDictionary *resultDic;

/**
 当前数据
 */
@property (nonatomic, strong) NSDictionary *selectDataDic;

/**
 当前位置
 */
@property (nonatomic, assign) NSInteger selectIndex;

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

- (NSDictionary *)selectDataDic
{
    if (!_selectDataDic) {
        _selectDataDic = [NSDictionary new];
    }
    return _selectDataDic;
}

- (NSMutableDictionary *)resultDic
{
    if (!_resultDic) {
        _resultDic = [NSMutableDictionary new];
    }
    return _resultDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.decimalBtn.layer.borderWidth = 2;
    self.decimalBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.invisibilityBtn.layer.borderWidth = 2;
    self.invisibilityBtn.layer.borderColor = RGBA(56, 78, 134, 1).CGColor;
    
    NSArray *decimalTitleArray = @[@"4.0",@"4.1",@"4.2",@"4.3",@"4.4",@"4.5",@"4.6",@"4.7",@"4.8",@"4.9",@"5.0",@"5.1",@"5.2",@"5.3"];
    NSArray *pointsTitleArray = @[@"0.1",@"0.12",@"0.15",@"0.2",@"0.25",@"0.3",@"0.4",@"0.5",@"0.6",@"0.8",@"1.0",@"1.2",@"1.5",@"2.0"];
    NSArray *fontArr = @[@"0.1",@"0.12",@"0.15",@"0.2",@"0.25",@"0.3",@"0.4",@"0.5",@"0.6",@"0.8",@"1.0",@"1.2",@"1.5",@"2.0"];
    self.fontArr = [NSMutableArray arrayWithArray:fontArr];
    for (int i = 0; i < decimalTitleArray.count; i++) {
        MLDemoModel *model = [[MLDemoModel alloc] init];
        model.dicountTitle = [decimalTitleArray objectAtIndex:i];
        [self.decimalData addObject:model];
    }
    for (int i = 0; i < pointsTitleArray.count; i++) {
        MLDemoModel *model = [[MLDemoModel alloc] init];
        model.dicountTitle = [pointsTitleArray objectAtIndex:i];
        [self.pointsData addObject:model];
    }
    self.data = [NSMutableArray arrayWithArray:self.pointsData];
    NSMutableDictionary *imageData = [NSMutableDictionary new];
    for (NSInteger i = 0; i < self.data.count; i++) {
        NSArray *dataArr = @[@{@"image":[self zd_imageWithColor:[UIColor orangeColor] size:CGSizeMake(50, 50) text:[NSString stringWithFormat:@"%ld上",i] textAttributes:nil circular:YES],@"orientation":@(EyeImageOrientationTypeTop)},@{@"image":[self zd_imageWithColor:[UIColor orangeColor] size:CGSizeMake(50, 50) text:[NSString stringWithFormat:@"%ld左",i] textAttributes:nil circular:YES],@"orientation":@(EyeImageOrientationTypeLeft)},@{@"image":[self zd_imageWithColor:[UIColor orangeColor] size:CGSizeMake(50, 50) text:[NSString stringWithFormat:@"%ld下",i] textAttributes:nil circular:YES],@"orientation":@(EyeImageOrientationTypeBottom)},@{@"image":[self zd_imageWithColor:[UIColor orangeColor] size:CGSizeMake(50, 50) text:[NSString stringWithFormat:@"%ld右",i] textAttributes:nil circular:YES],@"orientation":@(EyeImageOrientationTypeRight)}];
        imageData[[NSString stringWithFormat:@"%ld",i]] = dataArr;
    }
    self.imageData = imageData;
    
    CGFloat withH = (self.view.frame.size.width - 42 - 116) / 5;
    // 2.初始化
    self.pickerScollView = [[MLPickerScrollView alloc] init];
    _pickerScollView.itemWidth = withH; //刚好显示5个的宽度
    _pickerScollView.itemHeight = withH;
    _pickerScollView.firstItemX = (self.view.frame.size.width - 42 - 116) / 2 - 20;
    _pickerScollView.dataSource = self;
    _pickerScollView.delegate = self;
    [self.view addSubview:_pickerScollView];
    [self.bgView addSubview:_pickerScollView];
    [_pickerScollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(self.bgView);
        make.left.mas_equalTo(53);
        make.right.mas_equalTo(-53);
    }];
    
    self.bgView.layer.borderWidth = 2;
    self.bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    // 3.刷新数据
    [_pickerScollView reloadData];
    _pickerScollView.seletedIndex = 0;
    [_pickerScollView scollToSelectdIndex:0];
}

- (void)back
{
    [self.rt_navigationController popToRootViewControllerAnimated:YES];
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
    self.data = [NSMutableArray arrayWithArray:self.decimalData];
    [self.pickerScollView reloadData];

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
    self.data = [NSMutableArray arrayWithArray:self.pointsData];
    [self.pickerScollView reloadData];
}
- (IBAction)clickInvisibilityBtn:(UIButton *)sender {
    if ([EyeTool sharedSingleton].isLeftEye == NO) {
        [EyeTool sharedSingleton].isLeftEye = YES;
        NSLog(@"开始左眼测试");
        [EyeTool sharedSingleton].testResultDic[@"rightTestResul"] = [NSString stringWithFormat:@"%@",((MLDemoModel *)self.data[self.selectIndex]).dicountTitle];
        [self performSegueWithIdentifier:@"seleteEye"sender:self];
    } else {
        [EyeTool sharedSingleton].testResultDic[@"leftTestResul"] = [NSString stringWithFormat:@"%@",((MLDemoModel *)self.data[self.selectIndex]).dicountTitle];
        NSLog(@"结束");
        [self performSegueWithIdentifier:@"EyeTestResult"sender:self];
    }
}
- (IBAction)clickTopBtn:(UIButton *)sender {
    [self chooseCheck:(EyeImageOrientationTypeTop)];
}
- (IBAction)clickRightBtn:(UIButton *)sender {
    [self chooseCheck:(EyeImageOrientationTypeRight)];
}
- (IBAction)clickLeftBtn:(id)sender {
    [self chooseCheck:(EyeImageOrientationTypeLeft)];
}
- (IBAction)clickBottomBtn:(id)sender {
    [self chooseCheck:(EyeImageOrientationTypeBottom)];
}

/**
选择校验
 @param imageOrientationType 选择方向
 */
- (void)chooseCheck:(EyeImageOrientationType)imageOrientationType{
    NSInteger nextIndex;
    if ([self.selectDataDic[@"orientation"] integerValue] == imageOrientationType) {
        //选择正确
        nextIndex = self.selectIndex + 1;
        if (nextIndex < self.data.count) {
            _pickerScollView.seletedIndex = nextIndex;
            [_pickerScollView scollToSelectdIndex:nextIndex];
            return;
        }
    }
    if ([EyeTool sharedSingleton].isLeftEye == NO) {
        [EyeTool sharedSingleton].isLeftEye = YES;
        NSLog(@"开始左眼测试");
        [EyeTool sharedSingleton].testResultDic[@"rightTestResul"] = [NSString stringWithFormat:@"%@",((MLDemoModel *)self.data[self.selectIndex]).dicountTitle];
        [self performSegueWithIdentifier:@"seleteEye"sender:self];
    } else {
        [EyeTool sharedSingleton].testResultDic[@"leftTestResul"] = [NSString stringWithFormat:@"%@",((MLDemoModel *)self.data[self.selectIndex]).dicountTitle];
        NSLog(@"结束");
        [self performSegueWithIdentifier:@"EyeTestResult"sender:self];
    }
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
    NSArray *data = self.imageData[[NSString stringWithFormat:@"%ld",index]];
    NSInteger i = arc4random() % 4;
    NSDictionary *imageDic = data[i];
    self.selectDataDic = imageDic;
    self.selectIndex = index;
    self.selectImage.image = imageDic[@"image"];
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

/**
 绘制图片
 
 @param color 背景色
 @param size 大小
 @param text 文字
 @param textAttributes 字体设置
 @param isCircular 是否圆形
 @return 图片
 */
- (UIImage *)zd_imageWithColor:(UIColor *)color
                          size:(CGSize)size
                          text:(NSString *)text
                textAttributes:(NSDictionary *)textAttributes
                      circular:(BOOL)isCircular
{
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // circular
    if (isCircular) {
        CGPathRef path = CGPathCreateWithEllipseInRect(rect, NULL);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    // color
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    // text
    CGSize textSize = [text sizeWithAttributes:textAttributes];
    [text drawInRect:CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height) withAttributes:textAttributes];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
