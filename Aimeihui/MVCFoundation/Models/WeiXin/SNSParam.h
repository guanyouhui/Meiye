//
//  SNSParam.h
//  PaixieMall
//
//  Created by Bird Fu on 13-3-5.
//  Copyright (c) 2013年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum SNSLoginType{
    SNSLoginTypeWeiXin = 1,
    SNSLoginTypeSina,
    SNSLoginTypeQQ,
}SNSLoginType;

typedef enum SNSRegisterType{
    SNSRegisterType_Done = 1,//1、此账号(手机号)已注册 ，已注册账号 不需要手机验证码。
    SNSRegisterType_None     //2、此账号(手机号)未注册
}SNSRegisterType;

//#define WEIXIN_PLATFORM  1
//#define WEIBO_PLATFORM   2
//#define QQ_PLATFORM      3


@interface SNSParam : NSObject

@property (copy, nonatomic) NSString *o_uid;
@property (copy, nonatomic) NSString *o_nickName;
@property (copy, nonatomic) NSString *o_email;
@property (copy, nonatomic) NSString *o_phone;
@property (nonatomic) int o_platform;

//微信用
@property (copy, nonatomic) NSString *o_unionId;//多公众号 共用的ID
@property (copy, nonatomic) NSString *o_headImgUrl;//头像
@property (copy, nonatomic) NSString *o_sex;//性别



@end


@interface SNSBindParam : Entity

@property (copy, nonatomic) NSString *o_userName;
@property (copy, nonatomic) NSString *o_password;
@property (nonatomic,assign) SNSRegisterType o_registerType;
@property (copy, nonatomic) NSString *o_code;

@property (nonatomic) SNSLoginType o_platform;
@property (copy, nonatomic) NSString *o_uid;
@property (copy, nonatomic) NSString *o_unionId;//多公众号 共用的ID
@property (copy, nonatomic) NSString *o_nickName;
@property (copy, nonatomic) NSString *o_email;
@property (copy, nonatomic) NSString *o_headImgUrl;//头像

@end
