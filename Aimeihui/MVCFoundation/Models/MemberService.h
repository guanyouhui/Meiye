//
//  MemberService.h
//  PaixieMall
//
//  Created by allen on 12-12-13.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import "PaiXieBaseService.h"
#import "Member.h"


typedef enum{
    GetPhoneCodeType_Register = 1,//注册
    GetPhoneCodeType_Reset,//重置密码
}GetPhoneCodeType;

typedef NS_ENUM(NSInteger, Login_Type) {
    Login_Type_None=0, //未登录
    Login_Type_Normal, //普通登录
    Login_Type_QQ, //QQ登录
    Login_Type_Wechat, //wechat登录
    Login_Type_Sina //sina登录
};

typedef NS_ENUM(NSInteger, Login_After_Todo) {
    Login_After_Todo_None=0, //不作操作
    Login_After_Todo_Mine, //进入我的
    Login_After_Todo_GetOrder, //抢单
    Login_After_Todo_BookingOrder //下单
};

@interface MemberJsonResponseHandler : JsonResponseHandler

@end

@interface MemberService : PaiXieBaseService


/**
 * 用户注册
 */
//- (Member *)memberRegister:(MemberQueryParam *)param;

//登录类型（0:帐号 1:QQ  2:微信 ）
- (Member *)memberLoginWithLoginType:(Login_Type )type Account:(NSString *) account password:(NSString *)password thirdpartyOpenId:(NSString *)thirdpartyOpenId andAuto:(BOOL )autoLogin;

/**
 * 获取短信验证码
 */
- (void)getUserPhoneCodeWithPhone:(NSString*)phone type:(GetPhoneCodeType)type;

@end
