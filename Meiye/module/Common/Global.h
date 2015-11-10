//
//  Global.h
//  WuLiuDS
//
//  Created by zhwx on 14-9-9.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationHelper.h"
#import "MemberService.h"
//#import "SplashViewController.h"
//#import "LoginViewController.h"
//#import "WorkPlatformViewController.h"
//#import "SupplyViewController.h"
//#import "ContactViewController.h"
//#import "SettingViewController.h"
//#import "ZWXBaseTabBarViewController.h"
//#import "ZWXNavViewController.h"

//#import "LoginResponse.h"


@interface Global : NSObject


@property (strong, nonatomic, readonly) ApplicationHelper *applicationHelper;

// 方法
+(instancetype) sharedInstance;

+ (Login_Type)loginType;

//@property (nonatomic,strong) SplashViewController* o_splashVC;
//
//@property (nonatomic,strong) LoginViewController* o_loginVC;
//@property (nonatomic,strong) ZWXNavViewController* o_loginNavVC;
//
//@property (nonatomic,strong) WorkPlatformViewController* o_workPlatformVC;
//@property (nonatomic,strong) SupplyViewController* o_supplyVC;
//@property (nonatomic,strong) ContactViewController* o_chatVC;
//@property (nonatomic,strong) SettingViewController* o_settingVC;
//@property (nonatomic,strong) ZWXBaseTabBarViewController* o_tabbarVC;
//
//
//@property (nonatomic,strong) LoginResponse* o_loginResponse;
//@property (nonatomic,strong) NSDictionary* o_userInfoDic;

@end
