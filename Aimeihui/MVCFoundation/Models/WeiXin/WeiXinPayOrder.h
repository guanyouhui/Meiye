//
//  WeiXinPayOrder.h
//  PaixieMall
//
//  Created by zhwx on 14-7-31.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 微信预支付订单 请求  和 返回结果
 */

@interface WeiXinPayOrder : NSObject

@property (nonatomic,copy) NSString* o_appid; //应用唯一标识,在微信开放平台提交应用审核通过后获得
@property (nonatomic,copy) NSString* o_appkey; // WX_APP_KEY
@property (nonatomic,copy) NSString* o_partnerid;// WX_APP_PARTNER_ID
@property (nonatomic,copy) NSString* o_traceid; //商家对用户的唯一标识,如果用微信 SSO,此处建议填写 授权用户的 openid
@property (nonatomic,copy) NSString* o_noncestr; //32位内的随机串,防重发
@property (nonatomic,copy) NSString* o_package; //订单详情(具体生成方法见后文)
@property (nonatomic,assign) int o_timestamp; //时间戳,为 1970 年 1 月 1 日 00:00 到请求发起时间的秒 数
@property (nonatomic,copy) NSString* o_app_signature; //签名(具体生成方法见后文)
@property (nonatomic,copy) NSString* o_sign_method; //加密方式,默认为 sha1


//返回
@property (nonatomic,copy) NSString* o_prepayid; //
@property (nonatomic,assign) int o_errcode;//0 正确
@property (nonatomic,copy) NSString* o_errmsg; //


-(NSData*) serializeWithObject:(WeiXinPayOrder *)object;



@end
