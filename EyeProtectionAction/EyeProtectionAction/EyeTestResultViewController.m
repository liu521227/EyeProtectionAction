//
//  EyeTestResultViewController.m
//  EyeProtectionAction
//
//  Created by qxk on 2019/6/16.
//  Copyright © 2019年 qxk. All rights reserved.
//

#import "EyeTestResultViewController.h"

@interface EyeTestResultViewController ()
@property (weak, nonatomic) IBOutlet UILabel *leftResultL;

@property (weak, nonatomic) IBOutlet UILabel *rightResultL;
@end

@implementation EyeTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leftResultL.text = [EyeTool sharedSingleton].testResultDic[@"leftTestResul"];
    self.rightResultL.text = [EyeTool sharedSingleton].testResultDic[@"rightTestResul"];
}
- (void)back
{
    [self.rt_navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)clickSure:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
