//
//  EyePreparationTestViewController.m
//  EyeProtectionAction
//
//  Created by 秦晓康 on 2019/5/31.
//  Copyright © 2019 qxk. All rights reserved.
//

#import "EyePreparationTestViewController.h"
#import "CountLabel.h"
#import "EyeStartTestViewController.h"
@interface EyePreparationTestViewController ()
@property (weak, nonatomic) IBOutlet CountLabel *countdown;

@end

@implementation EyePreparationTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_countdown startCount];
    _countdown.ablock = ^{
        EyeStartTestViewController *vc = [[EyeStartTestViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
     };
    // Do any additional setup after loading the view.
    
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
