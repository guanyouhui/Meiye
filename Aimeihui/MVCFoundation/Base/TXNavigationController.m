//
//  TXNavigationController.m
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "TXNavigationController.h"

@interface TXNavigationController ()

@end

@implementation TXNavigationController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IOS7_OR_LATER) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (self.viewControllers.count <= 1)//关闭主界面的右
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

-(UIViewController*) popViewControllerAnimated:(BOOL)animated
{
    //还有2级的时候 判断是否 显示 tabbar
    if (self.viewControllers.count <= 2) {
        
        //        UIViewController* firstVC = [self.viewControllers firstObject];
        //
        //        if ([firstVC isKindOfClass:[PlatformCartViewController class]]) {
        //            self.tabBarController.tabBar.hidden = YES;
        //        }else{
        //            self.tabBarController.tabBar.hidden = NO;
        //        }
        
        self.tabBarController.tabBar.hidden = NO;
    }
    
    UIViewController* resultVC = [super popViewControllerAnimated:animated];
    
    return resultVC;
    
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
