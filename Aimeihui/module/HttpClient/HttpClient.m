//
//  HttpClient.m
//  PaixieMall
//
//  Created by zhwx on 14/12/9.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "HttpClient.h"
#import "LogUtils.h"
#import "SBJson.h"

@implementation HttpClient

-(id) init
{
    if (self = [super init]) {
        
        self.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        self.timeoutInterval = 30.0;
        self.requestEncoding = NSUTF8StringEncoding;
        self.responseEncoding = NSUTF8StringEncoding;
        self.o_response = nil;
    }
    return self;
}


/**
 @method sendGetRequest:requestParam:
 @abstract 向指定的URL发生Http请求，并返回远程的数据流。
 @param url Http的URL
 @param param 请求参数
 @return 远程服务返回的数据流
 */
- (NSData *)sendGetRequest:(NSString *)url requestParam:(NSDictionary *)param
{
    
    //    return [self sendPostRequest:url requestParam:param];
    
    
    
    NSString* paramStr = [self stringWithDataParams:param];
    NSString* utf8Str = [[NSString stringWithFormat:@"%@?%@",url,paramStr] stringByAddingPercentEscapesUsingEncoding:self.requestEncoding];//GBK 转 utf8
    //        NSString* str2 = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//urf8 转 GBK
    //    utf8Str = @"http://10.0.0.3:8116/timeout";
    [LogUtils log:[NSString stringWithFormat:@"Act = %@",param[@"Action"]] message:utf8Str];
    
    NSURL *turl = [NSURL URLWithString:utf8Str];
    
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest	requestWithURL:turl
                                                           cachePolicy:self.cachePolicy
                                                       timeoutInterval:self.timeoutInterval];
    [request setHTTPMethod:HTTP_GET_METHOD];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if ([self respondsToSelector:@selector(presendingRequest:)]) {
        [self presendingRequest:request];
    }
    
    NSError* error = nil;
    NSURLResponse* response = nil;
    // 保存返回数据
    NSData* resData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    self.o_response = response;
    
    //    NSString * str = [[NSString alloc] initWithData:resData encoding:self.responseEncoding];
    
    if (error) {
        NSLog(@"sendGetRequest error:-------\n%@\n-----response:-------\n%@",error,response);
        //请求超时【请求超时】
        if (error.code == -1001) {
            [NSException raise:NET_WORKING_TIMEOUT_EXCEPTION format:@"%@",error.userInfo[@"NSLocalizedDescription"]];
        }
        //无网络【未能连接到服务器】
        else if (error.code == -1004 || error.code == -1009) {
            [NSException raise:NET_WORKING_NONE_EXCEPTION format:@"%@",error.userInfo[@"NSLocalizedDescription"]];
        }
        return nil;
    }else{
        return resData;
    }
}

/**
 @method sendPostRequest:requestParam:
 @abstract 向指定的URL发生Http请求，并返回远程的数据流。
 @param url Http的URL
 @param param 请求参数
 @return 远程服务返回的数据流
 */
- (NSData *)sendPostRequest:(NSString *)url requestParam:(NSDictionary *)param
{
    NSString* utf8Str = [url stringByAddingPercentEscapesUsingEncoding:self.requestEncoding];//GBK 转 utf8
    //        NSString* str2 = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//urf8 转 GBK
    //    utf8Str = @"http://10.0.0.3:8116/timeout";
    [LogUtils log:[NSString stringWithFormat:@"Act = %@",param[@"Action"]] message:utf8Str];
    NSURL *turl = [NSURL URLWithString:utf8Str];
    
    //请求
    NSMutableURLRequest *request = [NSMutableURLRequest	requestWithURL:turl
                                                           cachePolicy:self.cachePolicy
                                                       timeoutInterval:self.timeoutInterval];
    [request setHTTPMethod:HTTP_POST_METHOD];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    //设置 body
    NSData* body = [self dataWithParams:param];
    [request setHTTPBody:body];
    
    
    
    if ([self respondsToSelector:@selector(presendingRequest:)]) {
        [self presendingRequest:request];
    }
    
    NSError* error = nil;
    NSURLResponse* response = nil;
    // 保存返回数据
    NSData* resData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    self.o_response = response;
    
    //    NSString * str = [[NSString alloc] initWithData:resData encoding:self.responseEncoding];
    
    
    if (error) {
        NSLog(@"sendPostRequest error:-------\n%@\n-----response:-------\n%@",error,response);
        //请求超时【请求超时】
        if (error.code == -1001) {
            [NSException raise:NET_WORKING_TIMEOUT_EXCEPTION format:@"%@",error.userInfo[@"NSLocalizedDescription"]];
        }
        //无网络【未能连接到服务器】
        else if (error.code == -1004 || error.code == -1009) {
            [NSException raise:NET_WORKING_NONE_EXCEPTION format:@"%@",error.userInfo[@"NSLocalizedDescription"]];
        }
        return nil;
    }else{
        return resData;
    }
}


-(NSData*) dataWithParams:(NSDictionary*)dictionary
{
    NSString* strParam = [self stringWithDataParams:dictionary];
    
    if (!strParam || ![strParam isKindOfClass:[NSString class]]) {
        return nil;
    }
    NSData* data = [strParam dataUsingEncoding:self.requestEncoding];
    return data;
}

/**
 * 将字典对象 拼接成 url 字符串
 */
-(NSString*) stringWithDataParams:(NSDictionary*)dictionary
{
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    //Data转换为JSON
    NSString* str = [dictionary JSONRepresentation];
    str = [NSString stringWithFormat:@"Data=%@",str];
    return str;
}
/**
 * 将字典对象 拼接成 url 字符串
 */
-(NSString*) stringWithParams:(NSDictionary*)dictionary
{
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSMutableString* allStr = [NSMutableString string];
    for (NSString* key in [dictionary allKeys]) {
        NSString* keyValue = dictionary[key];
        if (keyValue && [keyValue isKindOfClass:[NSString class]]  && keyValue.length>0) {
            
            NSString* kVStr = [NSString stringWithFormat:@"%@=%@&",key,keyValue];
            
            
            [allStr appendString:kVStr];
        }
    }
    [allStr deleteCharactersInRange:NSMakeRange(allStr.length-1, 1)];
    
    return allStr;
}



/**
 @method sendGetRequestAndReturnString:requestParam:
 @abstract 向指定的URL发生Http请求，并返回远程的数据字符串。
 @param url Http的URL
 @param param 请求参数
 @return 远程服务返回数据字符串
 */
- (NSString *)sendGetRequestAndReturnString:(NSString *)url requestParam:(NSDictionary *)param
{
    [LogUtils log:[NSString stringWithFormat:@"requestParam = %@",param] message:@""];
    NSData* data = [self sendGetRequest:url requestParam:param];
    
    NSString * str = [[NSString alloc] initWithData:data encoding:self.responseEncoding];
    [LogUtils log:[NSString stringWithFormat:@"response Act = %@",param[@"Action"]] message:str];
    return str;
    
}

/**
 @method sendGetRequestAndReturnString:requestParam:
 @abstract 向指定的URL发生Http请求，并返回远程的数据字符串。
 @param url Http的URL
 @param param 请求参数
 @return 远程服务返回数据字符串
 */
- (NSString *)sendPostRequestAndReturnString:(NSString *)url requestParam:(NSDictionary *)param
{
    [LogUtils log:[NSString stringWithFormat:@"requestParam = %@",param] message:@""];
    NSData* data = [self sendPostRequest:url requestParam:param];
    
    NSString * str = [[NSString alloc] initWithData:data encoding:self.responseEncoding];
    [LogUtils log:[NSString stringWithFormat:@"response Act = %@",param[@"Action"]] message:str];
    return str;
}


/**
 *	在发送http请求之前，对NSMutableURLRequest进行附加操作，例如添加header
 *
 *	@param	request
 */
- (void)presendingRequest:(NSMutableURLRequest *)request
{
    NSLog(@"子类【%@】未实现:【%s】",[self class],__FUNCTION__);
}


@end
