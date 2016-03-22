//
//  ZPayManager.h
//  TinyShop
//
//  Created by zhwx on 15/12/9.
//  Copyright © 2015年 zhenwanxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 支付类型
 */
typedef enum : NSUInteger {
    ZPayType_Alipay = 0,//支付宝
    ZPayType_WeiXin,//微信
    ZPayType_Union,//银联
} ZPayType;


/**
 支付结果类型
 */
typedef enum : NSUInteger {
    ZPayResultType_Success = 0,//成功
    ZPayResultType_Cancel,//取消
    ZPayResultType_NetError,//网络错误
    ZPayResultType_Failed,//失败
    ZPayResultType_SignError,//签名数据异常（银联特有）
    ZPayResultType_DataException,//获取支付信息异常(微信特有)
    ZPayResultType_UnInstall,//未安装 (微信特有)
    ZPayResultType_UnSupport,//版本不支持 (微信特有)
} ZPayResultType;


/**
 *  支付结果代理
 */
@protocol PayResultDelegate <NSObject>

//app可以根据需求，是否显示 error信息。
//如: [NSString stringWithFormat:@"支付失败:%@",error]
-(void) payFinishedWithResult:(ZPayResultType)resultType payType:(ZPayType)payType error:(NSString*)error;

@end


#define UPPay_AppScheme @"UPPayTinyShop"//银联
 extern NSString* kUPPayFinishedNotify;//银联支付结束通知

/**
 *  所有支付方式管理类
 */
@interface ZPayManager : NSObject

@property (nonatomic,weak) id<PayResultDelegate> o_delegate;//代理
@property (nonatomic,weak) UIViewController* o_payVC;//付款页面控制器，通常和 o_delegate 相同。（目前仅仅是银联支付 需要）


+(instancetype) shareInstance;


#pragma mark- 支付宝、微信、银联
/**
 *  支付宝支付
 *
 *  @param tradeNo     交易号
 *  @param productName 商品名称
 *  @param amount      金额
 *  @param callBackUrl 回调地址
 */
-(void) payOrderByAlixPayWithTradeNo:(NSString*)tradeNo
                         productName:(NSString*)productName
                              amount:(double)amount
                         callbackUrl:(NSString*)callBackUrl;

/**
 *  微信支付
 *
 *  @param partnerId 商家向财付通申请的商家id
 *  @param prepayId  预支付订单
 *  @param nonceStr  随机串，防重发
 *  @param timeStamp 时间戳，防重发
 *  @param package   商家根据财付通文档填写的数据和签名
 *  @param sign      商家根据微信开放平台文档对数据做的签名
 */
-(void) payOrderByWeiXinWithPartnerId:(NSString*)partnerId
                             prepayId:(NSString*)prepayId
                             nonceStr:(NSString*)nonceStr
                            timeStamp:(NSTimeInterval)timeStamp
                              package:(NSString*)package
                                 sign:(NSString*)sign;

/**
 *  银联支付
 *
 *  @param tn 银联支付tn值
 */
-(void) payOrderByUnionPayWithTN:(NSString*)tn;


@end
