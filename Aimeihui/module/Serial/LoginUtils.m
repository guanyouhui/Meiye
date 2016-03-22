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
            
        default:{
            
            //没有密码说明 不能自动登录
            NSString * ud_username = [accountDefaults objectForKey:UD_USER_ACOUNT];
            NSString * ud_password = [accountDefaults objectForKey:UD_USER_PASSWORD];
            NSString * ud_ThirdpartyOpenId = [accountDefaults objectForKey:UD_USER_ThirdpartyOpenId];
            if ([ZUtilsString isEmpty:ud_password] && [ZUtilsString isEmpty:ud_ThirdpartyOpenId]) {
                return nil;
            }
            
            //有密码 可以请求登录
            
            if ([ZUtilsString isNotEmpty:ud_username]) {
                @try {
                    member = [memberService memberLoginWithLoginType:loginType Account:ud_username password:ud_password thirdpartyOpenId:ud_ThirdpartyOpenId andAuto:YES];
                    
                }
                @catch (NSException *exception) {
                    NSLog(@"normal checkLoginStatus exception");
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setInteger:Login_Type_None forKey:UD_LOGIN_TYPE];
                    [defaults synchronize];
                    
                }
            }
        }
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
    [accountDefaults removeObjectForKey:UD_USER_ThirdpartyOpenId];
    
    [accountDefaults synchronize];
    
}

/**
 * 将账号、密码、cookie 保存至 userdefault
 */
+(void) saveLoginInfoToUserDefaultWithType:(Login_Type )type Account:(NSString*)account pswd:(NSString*)pswd ThirdpartyOpenId:(NSString*)ThirdpartyOpenId
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setObject:account forKey:UD_USER_ACOUNT];
    if (pswd) {
        [defaults setObject:pswd forKey:UD_USER_PASSWORD];
        [defaults setInteger:Login_Type_Normal forKey:UD_LOGIN_TYPE];
    }else if (ThirdpartyOpenId) {
        [defaults setObject:ThirdpartyOpenId forKey:@"ThirdpartyOpenId"];
        [defaults setInteger:type forKey:UD_LOGIN_TYPE];
    }else{
        [defaults setInteger:Login_Type_None forKey:UD_LOGIN_TYPE];
    }
    
    [defaults synchronize];
    
}

@end
