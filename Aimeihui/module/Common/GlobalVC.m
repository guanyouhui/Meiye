//
//  GlobalVC.m
//  Yundx
//
//  Created by Pro on 15/7/31.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "GlobalVC.h"
#import "TXNavigationController.h"

@interface GlobalVC ()<UITabBarControllerDelegate>


@end
@implementation GlobalVC



+(instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    static GlobalVC* _global = nil;
    dispatch_once(&onceToken, ^{
        _global = [[GlobalVC alloc] init];
        [_global initComponents];
//        [_global createHomeViewController];
    });
    return _global;
}

- (void)initComponents {
    self.launchVC = [[LaunchViewController alloc] init];
}


//-(void) createHomeViewController
//{
//    
//    self.launchVC = [[LaunchViewController alloc] init];
//    self.homeVC = [[UserHomeViewController alloc] init];
//    self.orderVC = [[OrderHomeViewController alloc] init];
//    self.lifeVC = [[SuggestionViewController alloc] init];
//    self.mineVC = [[MineViewController alloc]init];
//    
//    TXNavigationController* cityWideNav = [[TXNavigationController alloc] initWithRootViewController:self.homeVC];
//    TXNavigationController* interCityNav = [[TXNavigationController alloc] initWithRootViewController:self.orderVC];
//    TXNavigationController* lifeNav = [[TXNavigationController alloc] initWithRootViewController:self.lifeVC];
//    TXNavigationController* mineNav = [[TXNavigationController alloc] initWithRootViewController:self.mineVC];
//    
//    
//    [self.homeVC setTabBarItemTitle:@"首页" andImageName:@"user_menu01" andSelectedImageName:@"user_menu1"];
//    [self.orderVC setTabBarItemTitle:@"订单" andImageName:@"user_menu02" andSelectedImageName:@"user_menu2"];
//    [self.lifeVC setTabBarItemTitle:@"客服" andImageName:@"user_menu03" andSelectedImageName:@"user_menu3"];
//    [self.mineVC setTabBarItemTitle:@"我的" andImageName:@"user_menu04" andSelectedImageName:@"user_menu4"];
//    
//    
//    self.mainTabVC = [[TXTabBarController alloc] init];
//    self.mainTabVC.delegate = self;
//    self.mainTabVC.viewControllers = @[cityWideNav,interCityNav,lifeNav,mineNav];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterMineController:) name:kNotify_For_LOGIN_SUCCESS_Notify object:nil];
//}
//
//- (void)goLoginController:(Login_After_Todo)todo{
//    
//    self.loginVC = [[LoginViewController alloc] init];
//    self.loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    self.loginVC.todo = todo;
//    
//    TXNavigationController* loginNav = [[TXNavigationController alloc]initWithRootViewController:self.loginVC];
//    
//    [self.mainTabVC presentViewController:loginNav animated:YES completion:nil];
//}
//
//
//
//
//
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    if (viewController == self.mineVC.navigationController || viewController == self.orderVC.navigationController) {
//        
//        Login_Type loginType = [[NSUserDefaults standardUserDefaults] integerForKey:UD_LOGIN_TYPE];
//        if (loginType == Login_Type_None) {
//            [[GlobalVC sharedInstance] goLoginController:Login_After_Todo_Mine];
//            
//            return NO;
//        }
//    }
//    
//    return YES;
//}
//
//- (void)enterMineController:(NSNotification *)notification{
//    Login_After_Todo todo = [[notification.userInfo objectForKey:kNotify_Object_Info_Todo] integerValue];
//    if (todo == Login_After_Todo_Mine) {
//        self.mainTabVC.selectedIndex = 3;
//    }
//}


@end
