//
//  ViewController.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/24.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "ViewController.h"
#import "EyeTool.h"
#import "XKXWebViewController.h"

#import "XKXGetIntroRequest.h"
#import "XKXIntroViewModel.h"
#import "SYDloadingRemindSer.h"

#import <NSObject+YYModel.h>
#import "SystemMacro.h"
#import <Masonry.h>
@interface ViewController ()

@property (nonatomic, strong) XKXIntroViewModel *model;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[EyeTool sharedSingleton].testResultDic removeAllObjects];
    [EyeTool sharedSingleton].isLeftEye = NO;
    [EyeTool sharedSingleton].isDecimal = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
     [self XKX_loadrqu];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (IBAction)startCheck:(UIButton *)sender {
    
}
- (IBAction)explain:(UIButton *)sender {
    
}
- (void)XKX_loadrqu {
    
    [SYDLoadingRemindSer loading];
    
    __weak __typeof(self) weakSelf = self;
    XKXGetIntroRequest *request = [[XKXGetIntroRequest alloc] init];
    request.successBlock = ^(SYBaseApiRequest * _Nonnull api, id  _Nullable responseObject) {
        [SYDLoadingRemindSer dismiss];
        
        weakSelf.model = [XKXIntroViewModel yy_modelWithDictionary:responseObject[@"data"]];
        if ([weakSelf.model.icon containsString:@".png"] == NO) {
            XKXWebViewController *webVC = [[XKXWebViewController alloc] init];
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:weakSelf.model.icon]];
            [webVC.webVC loadRequest:request];
            [self.navigationController pushViewController:webVC animated:YES];
        }
        
        
    };
    request.failBlock = ^(SYBaseApiRequest * _Nonnull api, SYResponseErrorType errorType, NSString * _Nullable errStr) {
        // 请求失败逻辑
        
        [SYDLoadingRemindSer warning:errStr];
        [self XKX_showLoadFaildView];
        
    };
    [request loadData];
    // [self.activityIndicator stopAnimating];
}
    
    static UIView *loadFailView;
- (void)XKX_showLoadFaildView {
    
    if (loadFailView == nil) {
        loadFailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenBoundWidth, kScreenBoundHeight)];
        loadFailView.backgroundColor = [UIColor whiteColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"Failed to load, click to try again" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(XKX_failBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [loadFailView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(CGPointZero);
        }];
    }
    
    [self.view addSubview:loadFailView];
}
    
- (void)XKX_failBtnClicked:(UIButton *)btn {
    
    [loadFailView removeFromSuperview];
    
    [self XKX_loadrqu];
}
@end
