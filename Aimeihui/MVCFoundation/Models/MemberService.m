//
//  MemberService.m
//  PaixieMall
//
//  Created by allen on 12-12-13.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import "MemberService.h"
#import "LoginUtils.h"
#import "BPush.h"

@implementation MemberJsonResponseHandler

- (id)parseEntityFromJson:(NSDictionary *)jsonObject {
    
    Member *member = [[Member alloc] init];
    
    member.o_userId = [self parseStringWithJsonDic:jsonObject key:@"TokenId"];
    
    member.o_nickName = [self parseStringWithJsonDic:jsonObject key:@"Name"];
    
//    member.o_carNo = [self parseStringWithJsonDic:jsonObject key:@"CarNo"];
//    
//    member.o_recommendNo = [self parseStringWithJsonDic:jsonObject key:@"RecommendNo"];
//    
//    member.o_authenStatus = [self parseNumberWithJsonDic:jsonObject key:@"AuthenStatus"];
//    
//    member.o_isPush = [self parseNumberWithJsonDic:jsonObject key:@"IsPush"];
    
    return member;
    
}

@end

@implementation MemberService


//- (Member *)memberRegister:(MemberQueryParam *)param {
//    Member* result = [self getDetailWithoutCache:MEMBER_REGISTER_URI requestParam:[self getRegisterParam:param] reponseHandler:[[MemberJsonResponseHandler alloc] init]];
//    
//    if (result) {
//        HttpClient* http = (HttpClient*)self.httpClient;
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)http.o_response;
//        NSString* cookie = [[httpResponse allHeaderFields] objectForKey:@"Set-Cookie"];
//
////        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
////        NSArray* sinaweiboCookies = [cookies cookiesForURL:
////                                     [NSURL URLWithString:RPC_SCHEMA]];
////        for (NSHTTPCookie* cookie in sinaweiboCookies)
////        {
////            NSLog(@"NSHTTPCookieStorage cookie = %@\n\n\n---\n",cookie);
////        }
//
//        //保存用户名密码
//        [LoginUtils saveLoginInfoToUserDefaultWithAccount:param.o_phone pswd:param.o_password cookie:cookie];
//
//        [TalkingData setGlobalKV:@"username" value:result.o_userName];
//        [GlobalData shared].applicationHelper.o_newCookie = cookie;
//
//    }else{
//        
//        [LoginUtils saveLoginInfoToUserDefaultWithAccount:param.o_phone pswd:param.o_password cookie:@""];
//
//    }
//    return result;
//
//}

//登录类型（0:帐号 1:QQ  2:微信 ）
- (Member *)memberLoginWithLoginType:(Login_Type )type Account:(NSString *) account password:(NSString *)password thirdpartyOpenId:(NSString *)thirdpartyOpenId andAuto:(BOOL )autoLogin{
    
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc] init];
    [requestParam setValue:@(type - 1) forKey:@"LoginType"];
    if (type == Login_Type_Normal) {
        [requestParam setValue:account forKey:@"UserCode"];
        [requestParam setValue:password forKey:@"Password"];
    }else{
        [requestParam setValue:thirdpartyOpenId forKey:@"ThirdpartyOpenId"];
    }
    [requestParam setObjectNotNull:[BPush getChannelId] forKey:@"ChannelId"];//百度推送通道Id
    [requestParam setObjectNotNull:[BPush getUserId] forKey:@"UserId"];//百度推送UserId
    
    Member* result = [self getDetailWithoutCache:URI_Login requestParam:requestParam reponseHandler:[[MemberJsonResponseHandler alloc] init]];
    
    //保存用户对象
//    [Global sharedInstance].applicationHelper.loginedMember = result;
    
    //保存用户名密码
    if (!autoLogin) {
        password = nil;
    }
    
    if (type == Login_Type_Normal) {
//        [LoginUtils saveLoginInfoToUserDefaultWithType:type Account:account pswd:password ThirdpartyOpenId:nil];
    }else{
//        [LoginUtils saveLoginInfoToUserDefaultWithType:type Account:nil pswd:nil ThirdpartyOpenId:thirdpartyOpenId];
    }
    
    return result;

}

//- (void)memberLogout {
//    ApplicationHelper *applicationHelper = [[GlobalData shared] applicationHelper];
//    NSString *uuid = [applicationHelper uuid];
//    
//    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc] init];
//    [requestParam setValue:uuid forKey:@"uuid"];
//  
//    [self getDetailWithoutCache:MEMBER_LOGOUT_URI requestParam:requestParam reponseHandler:[[MemberJsonResponseHandler alloc] init]];
//    
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:@"" forKey:REMEMBER_COOKIE_PREFERENCE_KEY];
//    [defaults synchronize];
//    
//}

/**
 * 获取短信验证码
 */
- (void)getUserPhoneCodeWithPhone:(NSString *)phone type:(GetPhoneCodeType)type
{
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc] init];
    [requestParam setValue:phone forKey:@"phone"];
    [requestParam setValue:@(type) forKey:@"type"];
    
//    [self getDetailWithoutCache:GET_USER_PHONE_CODE_URI requestParam:requestParam reponseHandler:[[MemberJsonResponseHandler alloc] init]];
}


/**
 * 重置密码
 */
-(void) resetPasswordWithPhone:(NSString *)phone code:(NSString *)code pswd:(NSString *)pswd
{
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc] init];
    [requestParam setValue:phone forKey:@"phone"];
    [requestParam setValue:code forKey:@"code"];
    [requestParam setValue:pswd forKeyPath:@"password"];
    
//    [self getDetailWithoutCache:GET_USER_RESET_PSWD_URI requestParam:requestParam reponseHandler:[[MemberJsonResponseHandler alloc] init]];
}
@end
