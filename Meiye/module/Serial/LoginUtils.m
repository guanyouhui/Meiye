//
//  LoginUtils.m
//  PaixieMall
//
//  Created by guoliang on 12-12-20.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import "LoginUtils.h"
#import "MemberService.h"

@implementation LoginUtils

+ (Member *)checkLoginStatus {
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    MemberService *memberService = [[MemberService alloc] init];

    Member *member = nil;

    Login_Type loginType = [accountDefaults integerForKey:UD_LOGIN_TYPE];
    switch (loginType) {
        case Login_Type_None:
        {
            return nil;
        }
            break;
        case Login_Type_Normal:
        {
            //没有密码说明 不能自动登录
            NSString * ud_username = [accountDefaults objectForKey:UD_USER_ACOUNT];
            NSString * ud_password = [accountDefaults objectForKey:UD_USER_PASSWORD];
            if ([ZUtilsString isEmpty:ud_password]) {
                return member;
            }
            //有密码 可以请求登录
            
            if ([ZUtilsString isNotEmpty:ud_username]) {
                @try {
                    member = [memberService memberLoginWithAccount:ud_username password:ud_password];
                    
                }
                @catch (NSException *exception) {
                    NSLog(@"normal checkLoginStatus exception");
                }
            }
        }
            break;
        default:
            break;
    }
    
    return member;
    
}


/**
 * 清除自动登录的信息(账号、密码、cookie)
 */
+(void) clearLoginInfo
{
    NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
    
    [accountDefaults removeObjectForKey:UD_USER_PASSWORD];
    [accountDefaults removeObjectForKey:UD_LOGIN_TYPE];
    
    [accountDefaults synchronize];
    
}

/**
 * 将账号、密码、cookie 保存至 userdefault
 */
+(void) saveLoginInfoToUserDefaultWithAccount:(NSString*)account pswd:(NSString*)pswd 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:account forKey:UD_USER_ACOUNT];
    [defaults setObject:pswd forKey:UD_USER_PASSWORD];
    [defaults setInteger:Login_Type_Normal forKey:UD_LOGIN_TYPE];
    
    [defaults synchronize];
    
}

@end
