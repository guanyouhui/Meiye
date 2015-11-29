//
//  TXLoginViewController.m
//  Meiye
//
//  Created by Pro on 15/11/29.
//  Copyright © 2015年 王庭协. All rights reserved.
//

#import "TXLoginViewController.h"

@interface TXLoginViewController ()

@end

@implementation TXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)loginAction:(id)sender {
    [[GlobalVC sharedInstance] showMainTabVCAnimation:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
