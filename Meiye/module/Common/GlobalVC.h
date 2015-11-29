//
//  GlobalVC.h
//  Yundx
//
//  Created by Pro on 15/7/31.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TXTabBarController.h"
#import "LaunchViewController.h"
#import "TXLoginViewController.h"
#import "TXProductViewController.h"
#import "TXActivityViewController.h"
#import "TXStoreViewController.h"
#import "TXMineViewController.h"
#import "TXHomeViewController.h"
#import "TXNavigationController.h"

@interface GlobalVC : NSObject

@property (nonatomic, strong) TXTabBarController * o_mainTabVC;

@property (nonatomic, strong) LaunchViewController * o_launchVC;

@property (nonatomic,strong)TXLoginViewController* o_loginVC;
@property (nonatomic,strong)TXNavigationController* o_loginNavVC;



@property (nonatomic,strong)TXHomeViewController* o_homeVC;
@property (nonatomic,strong)TXProductViewController* o_productVC;
@property (nonatomic,strong)TXActivityViewController* o_activityVC;
@property (nonatomic,strong)TXStoreViewController* o_storeVC;
@property (nonatomic,strong)TXMineViewController* o_mineVC;


+(instancetype) sharedInstance;

//- (void)goMainTabBarController;

- (void)goLoginController:(Login_After_Todo)todo;

/**
 * 显示 未登录状态的首页
 */
-(void) showLoginViewAnimation:(BOOL)isAnimation;
/**
 * 显示tab 首页
 */
-(void) showMainTabVCAnimation:(BOOL)animation;

@end
