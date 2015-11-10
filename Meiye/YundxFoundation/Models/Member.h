//
//  Member.h
//  PaixieMall
//
//  Created by Enways on 12-12-11.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import "Entity.h"

typedef NS_ENUM(NSInteger, AuthenStatus) {
    AuthenStatus_ToBeCertified , //待认证
    AuthenStatus_Certified,      //已认证
    AuthenStatus_Fail,           //认证失败
    AuthenStatus_Unauthorized,   //未认证
    AuthenStatus_certificating   //认证中
};

@interface Member : Entity

@property (copy, nonatomic) NSString * o_userId;//用户id
//@property (copy, nonatomic) NSString *o_userCode;//用户名 (保存使用)
@property (copy, nonatomic) NSString *o_nickName;//昵称
@property (copy, nonatomic) NSString *o_carNo;//车牌号
@property (copy, nonatomic) NSString *o_recommendNo;//邀请码
@property (assign, nonatomic) NSInteger o_authenStatus;//认证状态
@property (assign, nonatomic) BOOL o_isPush; //是否允许推送

+(NSString *) authenStatusString:(AuthenStatus)authenStatus;
+(UIImage *) authenStatusImage:(AuthenStatus)authenStatus;
@end