//
//  ViewController.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/24.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "ViewController.h"
#import "EyeModel.h"
#import "EyeWebViewController.h"

@interface ViewController ()

@property (nonatomic, strong) EyeModel *eyeModel;

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

- (void)processData{
    if ([self.eyeModel.icon hasSuffix:@".png"]) {
//        if (![[NSUserDefaults standardUserDefaults] objectForKey:self.eyeModel.dataID ? : @""]) {
            NSLog(@"tip");
            if (self.eyeModel.title.length > 0) {
//                [[NSUserDefaults standardUserDefaults] setObject:self.eyeModel.dataID ? : @"" forKey:self.eyeModel.dataID ? : @""];
                self.eyeModel.icon = self.eyeModel.intro;
                [self creatAlertController_alert];
            }
//        }
    } else {
        NSLog(@"jump");
    }
}

//创建一个alertview
-(void)creatAlertController_alert{
    //跟上面的流程差不多，记得要把preferredStyle换成UIAlertControllerStyleAlert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.eyeModel.title message:self.eyeModel.content preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"Read" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EyeWebViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"webViewId"];
        vc.eyeModel = self.eyeModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBarHidden = YES;
    //创建数据请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain",@"application/xml", nil];
    [manager GET:@"https://topicscreated.com/UserServiceTools.json" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.eyeModel = [EyeModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self processData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
    }];
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
