//
//  TXTabBarController.m
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "TXTabBarController.h"

@interface TXTabBarController ()

@end

@implementation TXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customPhoneTabBar];
}

- (void)customPhoneTabBar {
    
    id appearance = [UITabBar appearance];
    
    [appearance setBackgroundColor:[UIColor whiteColor]];//背景颜色
//    if ([appearance respondsToSelector:@selector(setSelectedImageTintColor:)]) {
//        [appearance setSelectedImageTintColor:SUBJECT_COLOR];//文字颜色
//    }
//    [appearance  setTintColor:SUBJECT_COLOR];
    [appearance setBackgroundImage:[UIImage imageNamed:@"tab_bg"]];//背景图片
//    [appearance setSelectionIndicatorImage:[UIImage imageNamed:@"transparent"]];//覆盖层
    
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
