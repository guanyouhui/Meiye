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
        [_global createLoginViewController];
        [_global createHomeViewController];
    });
    return _global;
}


#pragma mark- 创建全局的 所有首页控制器
-(void) createLoginViewController
{
    _o_launchVC = [[LaunchViewController alloc] init];
    _o_loginVC = [[TXLoginViewController alloc] init];
    _o_loginNavVC = [[TXNavigationController alloc] initWithRootViewController:_o_loginVC];
}


-(void) createHomeViewController
{
    _o_homeVC= [[TXHomeViewController alloc] init];
    _o_productVC = [[TXProductViewController alloc] init];
    _o_activityVC = [[TXActivityViewController alloc] init];
    _o_storeVC = [[TXStoreViewController alloc]init];
    _o_mineVC = [[TXMineViewController alloc] init];
    
    
    TXNavigationController* zHomeNav = [[TXNavigationController alloc] initWithRootViewController:_o_homeVC];
    TXNavigationController* zProductNav = [[TXNavigationController alloc] initWithRootViewController:_o_productVC];
    TXNavigationController* zActivityNav = [[TXNavigationController alloc] initWithRootViewController:_o_activityVC];
    TXNavigationController* zStoreNav = [[TXNavigationController alloc] initWithRootViewController:_o_storeVC];
    TXNavigationController* zMineNav = [[TXNavigationController alloc] initWithRootViewController:_o_mineVC];
    
    
    [_o_homeVC setTabBarItemImageName:@"lab1" withSelectedImageName:@"lab1_p"];
    [_o_productVC setTabBarItemImageName:@"lab2" withSelectedImageName:@"lab2_p"];
    [_o_activityVC setTabBarItemImageName:@"lab3" withSelectedImageName:@"lab3_p"];
    [_o_storeVC setTabBarItemImageName:@"lab4" withSelectedImageName:@"lab4_p"];
    [_o_mineVC setTabBarItemImageName:@"lab5" withSelectedImageName:@"lab5_p"];
    
    
    _o_mainTabVC = [[TXTabBarController alloc] init];
    _o_mainTabVC.viewControllers = @[zHomeNav,zProductNav,zActivityNav,zStoreNav,zMineNav];
}


#pragma mark - 切换Window控制器
/**
 * 显示 未登录状态的首页
 */
-(void) showLoginViewAnimation:(BOOL)isAnimation
{
    [LoginUtils clearLoginInfo];
    
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    if (isAnimation) {
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [transtion setType:@"oglFlip"];
        [transtion setSubtype:kCATransitionFromLeft];
        [app.window.layer addAnimation:transtion forKey:@"transtionKey"];
    }
    app.window.rootViewController = self.o_loginNavVC;
}


/**
 * 显示tab 首页
 */
-(void) showMainTabVCAnimation:(BOOL)animation
{
    //切换到首页的 时候重新创建
    [self createHomeViewController];
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    if (animation) {
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [transtion setType:@"oglFlip"];
        [transtion setSubtype:kCATransitionFromLeft];
        [app.window.layer addAnimation:transtion forKey:@"transtionKey"];
    }
    app.window.rootViewController = self.o_mainTabVC;
}



#pragma end mark



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
