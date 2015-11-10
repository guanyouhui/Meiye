//
//  ServiceUrls.h
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#ifndef Yundx_ServiceUrls_h
#define Yundx_ServiceUrls_h

// 测试账号
// 15160025545
// 13666094649
// 123456

/**
 * 服务器 地址
 */
#define SERVICE_API_URL NSLocalizedString(@"Service_Api_URL", nil)
#define SERVICE_MP_URL NSLocalizedString(@"Service_Mp_URL", nil)

/**
 * 接口 地址
 */
#define SERVICE_CONNECT_RUL [NSString stringWithFormat:@"%@/Carrier",SERVICE_API_URL]

/**
 * 关于 地址
 */
#define SERVICE_ABOUT_RUL [NSString stringWithFormat:@"%@/App/Home/About",SERVICE_MP_URL]

/**
 * 微社区 地址
 */
#define SERVICE_WEISHEQU_RUL @"http://m.wsq.qq.com/263271856"

/**
 * 意见反馈 地址
 */
#define SERVICE_SUGGESTION_RUL [NSString stringWithFormat:@"%@/App/Suggestion",SERVICE_MP_URL]

/**
 * 邀请码分享 地址
 */
#define SERVICE_INVITE_RUL(code) [NSString stringWithFormat:@"%@/Invite?code=%@",SERVICE_MP_URL,code]

/**
 * 运生活 地址
 * 打开运生活是要增加如下字段值:
 TokenId=&CityName={当前城市}& Longitude={经度}& Latitude={纬度}&Address={具体地址}
 */
#define SERVICE_LIFE_RUL [NSString stringWithFormat:@"%@/Life",SERVICE_MP_URL]

/**
 * 提现规则说明 地址
 */
#define SERVICE_WITHDRAW_RUL [NSString stringWithFormat:@"%@/App/Article?Id= 079340CE93C34C12AF49BA0EE0F0672C",SERVICE_MP_URL]

/**
 * 注册服务协议说明地址
 */
#define SERVICE_PROTOCOL_RUL [NSString stringWithFormat:@"%@/App/Article?Id=A95F70ED2374465DAEFCF09A457CD169",SERVICE_MP_URL]

/**
 * 上传文件
 */
#define URI_Upload(linkId,type,tokenId) [NSString stringWithFormat:@"Common/Upload?Id=%@&Type=%d&TokenId=%@",linkId,type,tokenId] //3.18	文件上传 **

#define URI_Register @"Register"//3.2	用户注册
#define URI_MobileSend @"MobileSend" //3.3	手机发送验证码
#define URI_CarRegister @"CarRegister" //3.4	车辆信息登记(车辆认证)
#define URI_Login @"Login" //3.5	用户登录
#define URI_RetrievePassword @"RetrievePassword" //3.6	忘记密码
#define URI_UserInfo @"UserInfo"//3.7	用户信息
#define URI_ChangePassword @"ChangePassword" //3.8	修改密码
#define URI_LogOut @"LogOut" //3.9	注销
#define URI_FindCity @"FindCity" //3.10	查找城市
#define URI_FindLocalOrder @"FindLocalOrder" //3.11	同城配送
#define URI_Accept @"Accept" //3.12	抢单
#define URI_FindIntercityOrder @"FindIntercityOrder" //3.13	城际配送
#define URI_FindMyOrder @"FindMyOrder"//3.14	我的订单
#define URI_OrderDetail @"OrderDetail" //3.15	订单详情
#define URI_OrderSign @"OrderSign" //3.16	订单签收
#define URI_SendSignCode @"SendSignCode" //3.17	发送签收码
#define URI_Track @"Track" //3.19	位置跟踪
#define URI_Advert @"Advert" //3.20	广告下载
#define URI_Wallet @"Wallet" //3.21	我的钱包
#define URI_InComeList @"InComeList" //3.22	收支明细
#define URI_FindMyBankCard @"FindMyBankCard" //3.23	我的银行卡
#define URI_AddBankCard @"AddBankCard" //3.24	添加银行卡
#define URI_RemoveBankCard @"RemoveBankCard" //3.25	移除银行卡
#define URI_EncashmentApply @"EncashmentApply" //3.26	申请提现
#define URI_Config @"Config" //3.27	系统设置
#define URI_Invite @"Invite" //3.28	邀请朋友
#define URI_Dictionary @"Dictionary" //3.29	数据字典

#define URI_FindPackOrderList @"FindPackOrderList" //抢单详情
#define URI_FindMyAcceptInfo @"FindMyAcceptInfo" //3.31	我的抢单信息


#endif
