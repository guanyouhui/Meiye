//
//  LoginUtils.h
//  PaixieMall
//
//  Created by guoliang on 12-12-20.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"

@interface LoginUtils : NSObject

+ (Member *)checkLoginStatus;

/**
 * 清除自动登录的信息(账号、密码、cookie)
 */
+(void) clearLoginInfo;

/**
 * 将账号、密码、cookie 保存至 userdefault
 */
//+(void) saveLoginInfoToUserDefaultWithType:(Login_Type )type Account:(NSString*)account pswd:(NSString*)pswd ThirdpartyOpenId:(NSString*)ThirdpartyOpenId;

@end
