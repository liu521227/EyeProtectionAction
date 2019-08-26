//
//  EyeWebViewController.m
//  EyeProtectionAction
//
//  Created by qxk on 2019/7/13.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "EyeWebViewController.h"
#import "Masonry.h"
#import <RTRootNavigationController/RTRootNavigationController.h>
#import <SVProgressHUD/SVProgressHUD.h>
@interface EyeWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation EyeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"black"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back)];
    if (self.eyeModel.natTitle.length > 0) {
        self.title = self.eyeModel.natTitle;
    }
    [SVProgressHUD show];
    self.webView = [UIWebView new];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
//    if (@available(iOS 11.0, *)) {
//        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
//
    NSURL *remoteURL = [NSURL URLWithString:self.eyeModel.icon];
    NSURLRequest *request =[NSURLRequest requestWithURL:remoteURL];
    [self.webView loadRequest:request];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];

}

- (void)back{
    [self.rt_navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

@end
