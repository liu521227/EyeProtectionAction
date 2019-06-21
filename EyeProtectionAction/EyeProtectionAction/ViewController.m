//
//  ViewController.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/24.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "ViewController.h"
#import "EyeTool.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[EyeTool sharedSingleton].testResultDic removeAllObjects];
    [EyeTool sharedSingleton].isLeftEye = NO;
    [EyeTool sharedSingleton].isDecimal = NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"post返回结果：\n %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        NSLog(@"请求失败 %@",error);

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
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

@end
