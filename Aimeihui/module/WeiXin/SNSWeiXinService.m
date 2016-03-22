//
//  SNSWeiXinService.m
//  PaixieMall
//
//  Created by zhwx on 14-7-30.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "SNSWeiXinService.h"
#import "OpenUDID.h"


#define Login_WeiXin_State_String @"paixie_weixin_login"


@implementation SNSWeiXinService

+(instancetype)shareInstanced
{
    static SNSWeiXinService* o_snsWeiXinService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        o_snsWeiXinService = [[SNSWeiXinService alloc] init];
    });
    
    return o_snsWeiXinService;
}


#pragma mark- 微信登录

-(void) sendLoginWeiXinRequestAuth
{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state =  Login_WeiXin_State_String;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
}


//获取 AccessTokenResp
-(AccessTokenResp*) getLoginAccessToken
{
    NSString* requestUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WX_PAY_APP_ID,WX_PAY_APP_SCERET,self.o_sendAuthResp.code];
    
    NSURL* url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
    //如果是GET
    [URLRequest setHTTPMethod:@"GET"];
    //    //如果是POST
    //    [URLRequest setHTTPBody:[HTTPBodyStringdataUsingEncoding:NSUTF8StringEncoding]];
    //    [URLRequestsetHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse* res = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&res error:&error];
    
    if (res.statusCode == 200) {
        
        NSDictionary* resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        
        AccessTokenResp* accessToken = [[AccessTokenResp alloc] init];
        accessToken.o_accessToken = [resDic valueForKey:@"access_token"];
        NSNumber* expries = [resDic valueForKey:@"expires_in"];
        if (expries) {
            accessToken.o_expriesIn = expries.intValue;
        }
        accessToken.o_refreshToken = [resDic valueForKey:@"refresh_token"];
        accessToken.o_openId = [resDic valueForKey:@"openid"];
        accessToken.o_scope = [resDic valueForKey:@"scope"];
        
        
        NSNumber* errcode = [resDic valueForKey:@"errcode"];
        if (errcode) {
            accessToken.o_errorCode = errcode.intValue;
        }
        accessToken.o_errorMsg = [resDic valueForKey:@"errmsg"];
        
        
        self.o_accessTokenResp = accessToken;
        
        return accessToken;
    }
    return nil;
}


//刷新 AccessTokenResp
-(AccessTokenResp*) refreshLoginAccessToken
{
    NSString* requestUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",WX_PAY_APP_ID,self.o_accessTokenResp.o_refreshToken];
    
    NSURL* url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
    //如果是GET
    [URLRequest setHTTPMethod:@"GET"];
    //    //如果是POST
    //    [URLRequest setHTTPBody:[HTTPBodyStringdataUsingEncoding:NSUTF8StringEncoding]];
    //    [URLRequestsetHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse* res = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&res error:&error];
    
    if (res.statusCode == 200) {
        
        NSDictionary* resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        
        AccessTokenResp* accessToken = [[AccessTokenResp alloc] init];
        accessToken.o_accessToken = [resDic valueForKey:@"access_token"];
        NSNumber* expries = [resDic valueForKey:@"expires_in"];
        if (expries) {
            accessToken.o_expriesIn = expries.intValue;
        }
        accessToken.o_refreshToken = [resDic valueForKey:@"refresh_token"];
        accessToken.o_openId = [resDic valueForKey:@"openid"];
        accessToken.o_scope = [resDic valueForKey:@"scope"];
        
        
        NSNumber* errcode = [resDic valueForKey:@"errcode"];
        if (errcode) {
            accessToken.o_errorCode = errcode.intValue;
        }
        accessToken.o_errorMsg = [resDic valueForKey:@"errmsg"];
        
        
        self.o_accessTokenResp = accessToken;
        
        return accessToken;
    }
    return nil;
}



//获取 用户信息
-(SNSParam*) getWeiXinUserInfo
{
    NSString* requestUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?appid=%@&access_token=%@&openid=%@",WX_PAY_APP_ID,self.o_accessTokenResp.o_accessToken,self.o_accessTokenResp.o_openId];
    
    NSURL* url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
    //如果是GET
    [URLRequest setHTTPMethod:@"GET"];
    //    //如果是POST
    //    [URLRequest setHTTPBody:[HTTPBodyStringdataUsingEncoding:NSUTF8StringEncoding]];
    //    [URLRequestsetHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse* res = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&res error:&error];
    
    if (res.statusCode == 200) {
        
        NSDictionary* resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        
        SNSParam* param = [[SNSParam alloc] init];
        param.o_uid = [resDic valueForKey:@"openid"];
        param.o_nickName = [resDic valueForKey:@"nickname"];
        param.o_headImgUrl = [resDic valueForKey:@"headimgurl"];
        param.o_unionId = [resDic valueForKey:@"unionid"];
        
        NSNumber* sex = [resDic valueForKey:@"sex"];
        if (sex) {
            if (sex.intValue == 1) {
                param.o_sex = @"男";
            }else if (sex.intValue == 2){
                param.o_sex = @"女";
            }else{
                param.o_sex = @"未知";
            }
            
        }else{
            param.o_sex = @"未知";
        }
        
        param.o_platform = SNSLoginTypeWeiXin;
        
        NSLog(@"getWeiXinUserInfo=%@",resDic);
        self.o_userSNSParam = param;
        
        return param;
    }
    return nil;
}



#pragma mark- WXApiDelegate
/*! @brief 收到一个来自微信的请求，处理完后调用sendResp
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req
{
    NSLog(@"req = %@",req);
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp
{
    NSLog(@"resp = %@",NSStringFromClass([resp class]));
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        self.o_sendAuthResp = (SendAuthResp*)resp;
        NSLog(@"SendAuthResp code = %@",self.o_sendAuthResp.code);
        
        if (![self.o_delegate respondsToSelector:@selector(weixinUserOperationWithType:)]) {
            return;
        }
        
        
        if (self.o_sendAuthResp.errCode == 0) {
            //验证状态吗相同
            if ([self.o_sendAuthResp.state isEqualToString:Login_WeiXin_State_String]) {
                [self.o_delegate weixinUserOperationWithType:WeiXinUserOperationType_Ok];
                //验证状态码 不同 非法
            }else{
                NSLog(@"验证状态码不同,非法");
                [self.o_delegate weixinUserOperationWithType:WeiXinUserOperationType_Invalid];
            }
        }else if(self.o_sendAuthResp.errCode == -4){
            NSLog(@"用户拒绝授权");
            [self.o_delegate weixinUserOperationWithType:WeiXinUserOperationType_Refuse];
        }else{
            NSLog(@"用户取消");
            [self.o_delegate weixinUserOperationWithType:WeiXinUserOperationType_Cancel];
        }
        
        //支付返回的结果
    }else if ([resp isKindOfClass:[PayResp class]]){
        
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess: {
                if ([self.o_payDelegate respondsToSelector:@selector(weixinPaySuccess:)]) {
                    [self.o_payDelegate weixinPaySuccess:response];
                }
            }
                break;
            default: {
                if ([self.o_payDelegate respondsToSelector:@selector(weixinPayFail:)]) {
                    [self.o_payDelegate weixinPayFail:response];
                }
            }
                break;
        }
    }
    
    
}


#pragma mark- 微信支付
//--------------------微信支付-----------------------------
//获取 AccessTokenResp
-(AccessTokenResp*) getPayAccessToken
{
    NSString* requestUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%@&secret=%@",WX_PAY_APP_ID,WX_PAY_APP_SCERET];
    
    NSURL* url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
    //如果是GET
    [URLRequest setHTTPMethod:@"GET"];
    //    //如果是POST
    //    [URLRequest setHTTPBody:[HTTPBodyStringdataUsingEncoding:NSUTF8StringEncoding]];
    //    [URLRequestsetHTTPMethod:@"POST"];
    
    
    NSHTTPURLResponse* res = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&res error:&error];
    
    if (res.statusCode == 200) {
        
        NSDictionary* resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"获取 AccessTokenResp:%@",resDic);
        
        AccessTokenResp* accessToken = [[AccessTokenResp alloc] init];
        accessToken.o_accessToken = [resDic valueForKey:@"access_token"];
        NSNumber* expries = [resDic valueForKey:@"expires_in"];
        if (expries) {
            accessToken.o_expriesIn = expries.intValue;
        }
        
        
        NSNumber* errcode = [resDic valueForKey:@"errcode"];
        if (errcode) {
            accessToken.o_errorCode = errcode.intValue;
        }
        accessToken.o_errorMsg = [resDic valueForKey:@"errmsg"];
        
        
        self.o_payAccessTokenResp = accessToken;
        
        return accessToken;
    }
    return nil;
}


//生成预支付订单
-(WeiXinPayOrder*) getPayOrderInfoWithPackage:(NSDictionary *)package
{
    self.o_payOrder = [[WeiXinPayOrder alloc] init];
    
    self.o_payOrder.o_package = [SNSWeiXinService makeSignWithPackage:package];
    self.o_payOrder.o_app_signature = [SNSWeiXinService makeAppSignatureWith:self.o_payOrder];
    
    NSData* sendData = [self.o_payOrder serializeWithObject:self.o_payOrder];
    
    NSString* requestUrl = [NSString stringWithFormat:@"https://api.weixin.qq.com/pay/genprepay?access_token=%@",self.o_payAccessTokenResp.o_accessToken];
    
    NSURL* url = [NSURL URLWithString:requestUrl];
    NSMutableURLRequest *URLRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5.0];
    //    //如果是GET
    //    [URLRequest setHTTPMethod:@"POST"];
    //如果是POST
    [URLRequest setHTTPBody:sendData];
    [URLRequest setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse* res = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&res error:&error];
    
    if (res.statusCode == 200) {
        
        NSDictionary* resDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:nil];
        NSLog(@"生成预支付订单:%@",resDic);
        
        self.o_payOrder.o_prepayid = [resDic valueForKey:@"prepayid"];
        NSNumber* errcode = [resDic valueForKey:@"errcode"];
        if (errcode) {
            self.o_payOrder.o_errcode = errcode.intValue;
        }
        self.o_payOrder.o_errmsg = [resDic valueForKey:@"errmsg"];
        
        
        return [resDic valueForKey:@"prepayid"]?self.o_payOrder:nil;
    }
    return nil;
}



//调起微信支付
-(void) sendWXPayRequestWithPrepayId:(NSString*)prepayId
{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = WX_APP_PARTNER_ID;
    request.prepayId = prepayId;
    request.package = @"Sign=WXPay";
    request.nonceStr = self.o_payOrder.o_noncestr;
    request.timeStamp = self.o_payOrder.o_timestamp;
    
    // 构造参数列表
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:self.o_payOrder.o_appid forKey:@"appid"];
    [params setObject:self.o_payOrder.o_appkey forKey:@"appkey"];
    [params setObject:self.o_payOrder.o_noncestr forKey:@"noncestr"];
    [params setObject:request.package forKey:@"package"];
    [params setObject:self.o_payOrder.o_partnerid forKey:@"partnerid"];
    [params setObject:self.o_payOrder.o_prepayid forKey:@"prepayid"];
    [params setObject:FORMAT(@"%d",(unsigned int)self.o_payOrder.o_timestamp) forKey:@"timestamp"];
    
    
    NSArray *keys = [params allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成 signText
    NSMutableString *signText = [NSMutableString string];
    for (NSString *key in sortedArray) {
        [signText appendString:key];
        [signText appendString:@"="];
        [signText appendString:[params objectForKey:key]];
        if (key != sortedArray.lastObject) {
            [signText appendString:@"&"];
        }
    }
    
    NSString* signStr = [ZUtilsString sha1:signText];
    request.sign= signStr;
    
    [WXApi sendReq:request];
}



+(NSString*) makeSignWithPackage:(NSDictionary*)packageDic
{
    NSArray *keys = [packageDic allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成 package
    NSMutableString* package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[packageDic objectForKey:key]];
        [package appendString:@"&"];
    }
    [package appendString:@"key="];
    [package appendString:WX_APP_PARTNER_KEY]; // 注意:不能hardcode在客户端,建议genPackage这 个过程都由服务器端完成
    
    // 进行md5摘要前,params内容为原始内容,未经过url encode处理
    NSString* packageSign = [ZUtilsString md5:[package copy]].uppercaseString;
    
    
    // 生成 packageParamsString
    NSString *value = nil;
    package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        value = [packageDic objectForKey:key];
        
        // 对所有键值对中的 value 进行 urlencode 转码
        value = [ZUtilsString urlEncodeWithString:value];
        
        [package appendString:value];
        [package appendString:@"&"];
    }
    NSString *packageParamsString = [package substringWithRange:NSMakeRange(0, package.length - 1)];
    
    NSString *result = [NSString stringWithFormat:@"%@&sign=%@", packageParamsString, packageSign];
    NSLog(@"--- Package: %@", result);
    
    return result;
    
}


+(NSString*) makeAppSignatureWith:(WeiXinPayOrder*)order
{
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:order.o_appid forKey:@"appid"];
    [params setObject:order.o_appkey forKey:@"appkey"];
    [params setObject:order.o_noncestr forKey:@"noncestr"];
    [params setObject:order.o_package forKey:@"package"];
    [params setObject:FORMAT(@"%d",order.o_timestamp) forKey:@"timestamp"];
    [params setObject:order.o_traceid forKey:@"traceid"];
    
    NSArray *keys = [params allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成 package
    NSMutableString* appSignature = [NSMutableString string];
    for (NSString *key in sortedArray) {
        
        [appSignature appendString:key];
        [appSignature appendString:@"="];
        [appSignature appendString:[params objectForKey:key]];
        if (key != sortedArray.lastObject) {
            [appSignature appendString:@"&"];
        }
    }
    
    NSString* signStr = [ZUtilsString sha1:appSignature];
    
    return signStr;
}

#pragma mark- 微信沟通
//--------------------微信沟通-----------------------------
-(void) sendTest
{
    JumpToBizProfileReq *req = [[JumpToBizProfileReq alloc]init];
    req.profileType = WXBizProfileType_Device;
    //    enum WXBizProfileType{
    //        WXBizProfileType_Normal = 0, /*普通公众号添加这一段代码 */
    //        WXBizProfileType_Device = 1, /*硬件公众号添加这一段代码*/
    //    };
    req.username = @"gh_a95d75b99cb3"; /*公众号原始ID*/
    //req.extMsg = @"extMsg"; /*若为服务号或订阅号则本字段为空，硬件号则填写相关的硬件二维码串*/
    [WXApi sendReq:req];
}
@end
