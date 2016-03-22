//
//  SNSWeiXinService.h
//  PaixieMall
//
//  Created by zhwx on 14-7-30.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "RpcBaseService.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "AccessTokenResp.h"
#import "SNSParam.h"
#import "WeiXinPayOrder.h"

typedef enum {
    WeiXinUserOperationType_Ok=0,
    WeiXinUserOperationType_Refuse,
    WeiXinUserOperationType_Cancel,
    WeiXinUserOperationType_Invalid,
    
}WeiXinUserOperationType;

//支付
@protocol SNSWeiXinPayServiceDelegate <NSObject>

-(void) weixinPaySuccess:(PayResp*) resp;
-(void) weixinPayFail:(PayResp*) resp;

@end

//登录
@protocol SNSWeiXinServiceDelegate <NSObject>

-(void) weixinUserOperationWithType:(WeiXinUserOperationType)type;
@end


@interface SNSWeiXinService : RpcBaseService<WXApiDelegate>

@property (nonatomic,unsafe_unretained)id<SNSWeiXinServiceDelegate> o_delegate;

//返回微信授权结果
@property (nonatomic,strong) SendAuthResp* o_sendAuthResp;
//返回token
@property (nonatomic,strong) AccessTokenResp* o_accessTokenResp;
//返回用户信息
@property (nonatomic,strong) SNSParam* o_userSNSParam;


+(instancetype) shareInstanced;


//--------------------微信登录-----------------------------

//发送登录请求（打开微信）【第一步】
-(void) sendLoginWeiXinRequestAuth;

//获取 AccessTokenResp 【第二步】
-(AccessTokenResp*) getLoginAccessToken;
//刷新 AccessTokenResp
-(AccessTokenResp*) refreshLoginAccessToken;
//获取 用户信息 【第三步】
-(SNSParam*) getWeiXinUserInfo;


//--------------------微信支付-----------------------------
@property (nonatomic,unsafe_unretained)id<SNSWeiXinPayServiceDelegate> o_payDelegate;
//返回的支付 token
@property (nonatomic,strong) AccessTokenResp* o_payAccessTokenResp;
//返回的预支付订单
@property (nonatomic,strong) WeiXinPayOrder* o_payOrder;

//获取 AccessTokenResp 【第一步】
-(AccessTokenResp*) getPayAccessToken;
//生成预支付订单 【第二步】
-(WeiXinPayOrder*) getPayOrderInfoWithPackage:(NSDictionary*)package;
//打开微信支付 【第三步】
-(void) sendWXPayRequestWithPrepayId:(NSString*)prepayId;



//签名 加密,生成 package 字符串
+(NSString*) makeSignWithPackage:(NSDictionary*)packageDic;
//签名加密(sha1) post的 的字段
+(NSString*) makeAppSignatureWith:(WeiXinPayOrder*)order;


//--------------------微信公众号-----------------------------
-(void) sendTest;
@end
