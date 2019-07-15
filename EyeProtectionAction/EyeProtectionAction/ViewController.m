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
        if ([[NSUserDefaults standardUserDefaults] objectForKey:self.eyeModel.dataID ? : @""]) {
            NSLog(@"tip");
            if (self.eyeModel.title.length > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:self.eyeModel.dataID ? : @"" forKey:self.eyeModel.dataID ? : @""];
                self.eyeModel.icon = self.eyeModel.intro;
                [self creatAlertController_alert];
            }
        }
    } else {
        NSLog(@"jump");
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EyeWebViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"webViewId"];
        vc.eyeModel = self.eyeModel;
        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
    }
}

-(void)creatAlertController_alert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:self.eyeModel.title message:self.eyeModel.tipContent preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"No Thanks" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain",@"application/xml", nil];//topicscreated.com   hhipa123.oss-cn-shanghai.aliyuncs.com
    NSString *url = [NSString stringWithFormat:@"https://topicscreated.com/tipsInstructions.json?timestamp=%@",[self getNowTimeTimestamp2]];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        self.eyeModel = [EyeModel mj_objectWithKeyValues:responseObject[@"data"]];
        [self processData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.userInfo);
    }];
}

-(NSString *)getNowTimeTimestamp2{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型;
    return timeString;
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
