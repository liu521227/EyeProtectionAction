//
//  XKXWebViewController.m
//  XKXWeightTool
//
//  Created by shirly on 2019/6/9.
//

#import "XKXWebViewController.h"
#import "SYDLoadingRemindSer.h"
#import <Masonry.h>

@interface XKXWebViewController ()<UIWebViewDelegate>

@end

@implementation XKXWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SYDLoadingRemindSer loading];
    
    
    [self.view addSubview:self.webVC];
    [self.webVC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}

- (UIWebView *)webVC {
    if (_webVC == nil) {
        _webVC = [[UIWebView alloc] init];
        _webVC.delegate = self;
    }
    return _webVC;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView API_DEPRECATED("No longer supported.", ios(2.0, 12.0)) {
    [SYDLoadingRemindSer dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SYDLoadingRemindSer dismiss];
//    [SYDLoadingRemindSer warning:@"%@", error];
}

@end
