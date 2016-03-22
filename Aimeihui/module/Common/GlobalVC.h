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

@interface GlobalVC : NSObject

@property (nonatomic, strong) TXTabBarController * mainTabVC;
@property (nonatomic, strong) LaunchViewController * launchVC;

+(instancetype) sharedInstance;

//- (void)goMainTabBarController;

//- (void)goLoginController:(Login_After_Todo)todo;

@end
