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
        [_global createHomeViewController];
    });
    return _global;
}

-(void) createHomeViewController
{
    
//    self.launchVC = [[LaunchViewController alloc] init];
//    self.cityWideVC = [[CityWideViewController alloc] init];
//    self.interCityVC = [[InterCityViewController alloc] init];
//    self.lifeVC = [[LifeViewController alloc] init];
//    self.mineVC = [[MineViewController alloc]init];
//    
//    TXNavigationController* cityWideNav = [[TXNavigationController alloc] initWithRootViewController:self.cityWideVC];
//    TXNavigationController* interCityNav = [[TXNavigationController alloc] initWithRootViewController:self.interCityVC];
//    TXNavigationController* lifeNav = [[TXNavigationController alloc] initWithRootViewController:self.lifeVC];
//    TXNavigationController* mineNav = [[TXNavigationController alloc] initWithRootViewController:self.mineVC];
//    
//    
//    [self.cityWideVC setTabBarItemTitle:@"市内配送" andImageName:@"tab-tc" andSelectedImageName:@"tab-tc-blue"];
//    [self.interCityVC setTabBarItemTitle:@"城际直达" andImageName:@"tab-cj" andSelectedImageName:@"tab-cj-blue"];
//    [self.lifeVC setTabBarItemTitle:@"运生活" andImageName:@"tab-sh" andSelectedImageName:@"tab-sh-blue"];
//    [self.mineVC setTabBarItemTitle:@"我" andImageName:@"tab-wo" andSelectedImageName:@"tab-wo-blue"];
//    
//    
//    self.mainTabVC = [[TXTabBarController alloc] init];
//    self.mainTabVC.delegate = self;
//    self.mainTabVC.viewControllers = @[cityWideNav,interCityNav,lifeNav,mineNav];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterMineController:) name:kNotify_For_LOGIN_SUCCESS_Notify object:nil];
}

- (void)goLoginController:(Login_After_Todo)todo{
    
//    self.loginVC = [[LoginViewController alloc] init];
//    self.loginVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    self.loginVC.todo = todo;
//    
//    TXNavigationController* loginNav = [[TXNavigationController alloc]initWithRootViewController:self.loginVC];
//    
//    [self.mainTabVC presentViewController:loginNav animated:YES completion:nil];
}





- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

- (void)enterMineController:(NSNotification *)notification{
    
}

@end
