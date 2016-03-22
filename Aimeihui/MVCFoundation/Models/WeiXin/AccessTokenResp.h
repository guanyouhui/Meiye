//
//  AccessTokenResp.h
//  PaixieMall
//
//  Created by zhwx on 14-7-30.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessTokenResp : NSObject

@property (nonatomic,copy) NSString* o_accessToken; //接口调用凭证
@property (nonatomic,assign) int o_expriesIn;//access_token接口调用凭证超时时间，单位（秒）
@property (nonatomic,copy) NSString* o_refreshToken;//用户刷新access_token
@property (nonatomic,copy) NSString* o_openId;//授权用户唯一标识
@property (nonatomic,copy) NSString* o_scope;//用户授权的作用域，使用逗号（,）分隔


@property (nonatomic,assign) int o_errorCode;//错误代码
@property (nonatomic,copy) NSString* o_errorMsg;//错误信息

@end
