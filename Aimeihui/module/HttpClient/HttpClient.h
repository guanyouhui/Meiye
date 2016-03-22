//
//  HttpClient.h
//  PaixieMall
//
//  Created by zhwx on 14/12/9.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Exceptions.h"


#define HTTP_GET_METHOD @"GET"
#define HTTP_POST_METHOD @"POST"


/**
 * http 请求 管理类
 */
@interface HttpClient : NSObject {
    
}

/*
 * default 为 NSURLRequestReloadIgnoringLocalAndRemoteCacheData
 * 缓存是自定义存储
 */
@property (nonatomic) NSURLRequestCachePolicy cachePolicy;

/**
 请求超时时间，秒。
 */
@property (nonatomic) NSTimeInterval timeoutInterval;
@property (nonatomic) NSStringEncoding requestEncoding;
@property (nonatomic) NSStringEncoding responseEncoding;
/**
 * HTTP远程服务返回NSURLResponse
 */
@property (nonatomic,strong) NSURLResponse* o_response;

/**
 @method sendGetRequest:requestParam:
 @abstract 向指定的URL发生Http请求，并返回远程的数据流。
 @param url Http的URL
 @param param 请求参数
 @return 远程服务返回的数据流
 */
- (NSData *)sendGetRequest:(NSString *)url requestParam:(NSDictionary *)param;

/**
 @method sendPostRequest:requestParam:
 @abstract 向指定的URL发生Http请求，并返回远程的数据流。
 @param url Http的URL
 @param param 请求参数
 @return 远程服务返回的数据流
 */
- (NSData *)sendPostRequest:(NSString *)url requestParam:(NSDictionary *)param;


/**
 @method sendGetRequestAndReturnString:requestParam:
 @abstract 向指定的URL发生Http请求，并返回远程的数据字符串。
 @param url Http的URL
 @param param 请求参数
 @return 远程服务返回数据字符串
 */
- (NSString *)sendGetRequestAndReturnString:(NSString *)url requestParam:(NSDictionary *)param;

/**
 @method sendGetRequestAndReturnString:requestParam:
 @abstract 向指定的URL发生Http请求，并返回远程的数据字符串。
 @param url Http的URL
 @param param 请求参数
 @return 远程服务返回数据字符串
 */
- (NSString *)sendPostRequestAndReturnString:(NSString *)url requestParam:(NSDictionary *)param;


/**
 *	在发送http请求之前，对NSMutableURLRequest进行附加操作，例如添加header
 *
 *	@param	request
 */
- (void)presendingRequest:(NSMutableURLRequest *)request;


@end
