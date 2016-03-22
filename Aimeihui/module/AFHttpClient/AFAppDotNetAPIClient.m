// AFAppDotNetAPIClient.h
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFAppDotNetAPIClient.h"
#import "JsonHandler.h"
#import "OpenUDID.h"


NSInteger  const gHttpTimeoutInterval = 20;

//NSString * _Nullable const AFAppDotNetAPIBaseURLString = @"http://api.paixie.net/?channel=5027&api_act=GetSystem&screenw=640&device=iphone&install_time=2015-09-15%2010:12:15&timestamp=2015-12-22%2000:44:02&imei=c8329da98333cc034f4b5696a5e795a36907b4e5&api_key=201504&sign=75F730C2CEFBC0AC8B4E667FB0ACF23E&v=2.4.4/";
//NSString * _Nullable const AFAppDotNetTempPathURLString = @"";

//NSString * const AFAppDotNetAPIBaseURLString = @"http://mp.f3322.org:8222/";
//NSString * const AFAppDotNetTempPathURLString = @"/wesoft-web";

NSString * const AFAppDotNetAPIBaseURLString = @"http://180.169.105.245:9009";

//NSString * const AFAppDotNetAPIBaseURLString = @"http://api.yundx.com/FreightApp";

NSString * const AFAppDotNetTempPathURLString = @"/FreightApp";


@implementation AFAppDotNetAPIClient

+ (instancetype)sharedClient {
    static AFAppDotNetAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AFAppDotNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        //json 提交
        _sharedClient.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        _sharedClient.requestSerializer.timeoutInterval = gHttpTimeoutInterval;
        
        ((AFJSONResponseSerializer*)_sharedClient.responseSerializer).removesKeysWithNullValues = YES;
        
//        _sharedClient.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    });
    
    return _sharedClient;
}

/**
 * 获取MBProgressHUD用于显示加载提示
 */
- (MBProgressHUD *) getMBProgressHUDWithView:(UIView*)fView
{

    MBProgressHUD* processHud = [[MBProgressHUD alloc] initWithView:fView];
    processHud.labelText = nil;
    processHud.mode = MBProgressHUDModeIndeterminate;
    processHud.delegate = nil;
    [fView addSubview:processHud];
//    [fView bringSubviewToFront:processHud];
    
    return processHud;
}


#pragma mark - Base Param
- (NSDictionary *)getSignValue:(NSString *)uri param:(NSDictionary *)param {
    //    uri = @"GetGoods";
    BOOL hasParam = NO;
    NSString *timeStamp = [ZUtilsDate stringWithFromat:@"yyyy-MM-dd HH:mm:ss" date:[NSDate date]];
    
    NSMutableDictionary *dataParam = [[NSMutableDictionary alloc] init];
    
    if (param != nil && param.count > 0) {
        hasParam = YES;
        NSArray *array = [param allKeys];
        
        array = [array sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
        
        for (NSString *key in array) {
            NSString *value = [param objectForKey:key];
            
            [dataParam setValue:value forKey:key];
        }
    }
    
    NSMutableDictionary *requestParam = [[NSMutableDictionary alloc] init];
    [requestParam setValue:uri forKey:@"Action"];
    [requestParam setValue:@([[ZUtilsApplication appMajorVersion] integerValue]) forKey:@"Version"];
    [requestParam setValue:@(1) forKey:@"Source"];
//    [requestParam setObjectNotNull:[Global sharedInstance].applicationHelper.loginedMember.o_userId forKey:@"TokenId"];
    [requestParam setValue:timeStamp forKey:@"RequestTime"];
    [requestParam setValue:[OpenUDID value] forKey:@"RandomStr"];
    [requestParam setValue:@"123456" forKey:@"Digest"];
    [requestParam setValue:[OpenUDID value] forKey:@"IMEI"];
    [requestParam addEntriesFromDictionary:dataParam];
    //    RandomStr={0}& RequestTime={1}&Ak={2}
    
    return requestParam;
}

#pragma mark- 
-(void) post:(nullable NSString*)URLString
 parameters:(nullable id)parameters
      class:(nullable Class)aClass
 extraClass:(nullable Class)eClass
   dsuccess:(nullable AFSuccessDetailBlock)dsuccess
   lsuccess:(nullable AFSuccessListBlock)lsuccess
    failure:(nullable AFFailureBlock)failure
processView:(nullable UIView*)processView
{
//    __block NSString* newUrlStr = URLString;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
//        newUrlStr = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//#else
//        newUrlStr = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//#endif
//        newUrl = FORMAT(@"%@",AFAppDotNetTempPathURLString);
        
        NSString * reuqestURLStr = [[NSURL URLWithString:AFAppDotNetTempPathURLString relativeToURL:self.baseURL] absoluteString];
        NSDictionary * requestParameters = [self getSignValue:URLString param:parameters];
        
        NSLog(@"GET Param Json Request:\nURL:%@\n\nParam:\n%@",reuqestURLStr,[ZUtilsString jsonStringWithDictionary:requestParameters]);
        __block MBProgressHUD* processHUD = nil;
        if (processView) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                processHUD = [self getMBProgressHUDWithView:processView];
                [processHUD show:YES];
            });
        }
        
        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:reuqestURLStr parameters:requestParameters error:nil];
        
//        if ([[GlobalData shared] liveToken].length > 0) {
//            [request setValue:[[GlobalData shared] liveToken] forHTTPHeaderField:@"token"];
//        }
//        
        request.timeoutInterval = self.requestSerializer.timeoutInterval;
        
        NSLog(@"GET Full Url:\n%@\n",request.URL);
        
        __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
            
            if (processView) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [processHUD hide:YES];
                });
            }
            
            //自定义修改
            NSHTTPURLResponse* hresponse = (NSHTTPURLResponse*)response;
            
            if (error || hresponse.statusCode != 200) {
                
                NSLog(@"GET Error Json Result:\n%@",[ZUtilsString jsonStringWithDictionary:responseObject]);
                
                Erroring* error = [[Erroring alloc] init];
                error.o_code = -1;
                error.o_message = @"网络请求失败";
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [JoProgressHUD makeToast:error.o_message];
                    if (failure) {
                        failure(error);
                    }
                });
                
            } else {
                id result = responseObject;
                
                JsonHandler* handler = [[JsonHandler alloc] init];
                result = [handler deserialWithDict:responseObject class:aClass extraClass:eClass];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //错误
                    if ([result isKindOfClass:[Erroring class]]){
                        [JoProgressHUD makeToast:((Erroring*)result).o_message];
                        if (failure) {
                            failure(result);
                        }
                        
                        //返回数组对象
                    }else if([result isKindOfClass:[NSArray class]]){
                        
                        if (lsuccess) {
                            lsuccess(handler);
                        }
                        
                        //返回单个对象
                    }else if([result isKindOfClass:[BaseObject class]]){
                        
                        if (dsuccess) {
                            dsuccess(result);
                        }
                        //无数据返回
                    }else{
                        if (dsuccess) {
                            dsuccess(nil);
                        }
//                        Erroring* error = [[Erroring alloc] init];
//                        error.o_code = -2;
//                        error.o_message = @"数据返回异常";
//                        
//                        [JoProgressHUD makeToast:error.o_message];
//                        if (failure) {
//                            failure(error);
//                        }
                    }
                    
                });
            }
        }];
        
        [task resume];
        
    });
    
}

//-(void) post:(nullable NSString*)URLString
//  parameters:(nullable id)parameters
//     success:(nullable AFSuccessBlock)success
//     failure:(nullable AFFailureBlock)failure
// processView:(nullable UIView*)processView
//{
//    __block NSString* newUrlStr = URLString;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
//        newUrlStr = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//#else
//        newUrlStr = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//#endif
//        newUrlStr = FORMAT(@"%@%@",AFAppDotNetTempPathURLString,URLString);
//        
//        NSLog(@"GET Param Json Request:\nURI:%@\nParam:\n%@",newUrlStr,[ZUtilsString jsonStringWithDictionary:parameters]);
//        __block MBProgressHUD* processHUD = nil;
//        if (processView) {
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                processHUD = [self getMBProgressHUDWithView:processView];
//                [processHUD show:YES];
//            });
//        }
//        
//        NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:newUrlStr relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
//        [request setValue:[[GlobalData shared] liveToken] forHTTPHeaderField:@"token"];
//        request.timeoutInterval = self.requestSerializer.timeoutInterval;
//        
//        NSLog(@"GET Full Url:\n%@\n",request.URL);
//        
//        __block NSURLSessionDataTask *task = [self dataTaskWithRequest:request completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
//            
//            if (processView) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [processHUD hide:YES];
//                });
//            }
//            
//            //自定义修改
//            NSHTTPURLResponse* hresponse = (NSHTTPURLResponse*)response;
//            
//            if (error || hresponse.statusCode != 200) {
//                NSDictionary* result = responseObject;
//                if (result && [ZUtilsString isNotEmpty:[result valueForKey:@"msg"]]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [JoProgressHUD makeToast:[result valueForKey:@"msg"]];
//                    });
//                    
//                }else{
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [JoProgressHUD makeToast:@"网络请求失败"];
//                    });
//                }
//                NSLog(@"GET Error Json Result:\n%@",[ZUtilsString jsonStringWithDictionary:responseObject]);
//                
//                if (failure) {
//                    failure(error);
//                }
//            } else {
//                if (success) {
//                    
//                    //NSLog(@"success = %@",[ZWXUtilsString jsonStringWithDictionary:responseObject]);
//                    success(responseObject);
//                }
//            }
//        }];
//        
//        [task resume];
//        
//    });
//    
//}



#pragma mark- 
-(void) post4Detail:(nullable NSString*)URLString
  parameters:(nullable id)parameters
       class:(nullable Class)aClass
     success:(nullable AFSuccessDetailBlock)success
     failure:(nullable AFFailureBlock)failure
 processView:(nullable UIView*)processView
{
    [self post:URLString parameters:parameters class:aClass extraClass:nil dsuccess:success lsuccess:nil failure:failure processView:processView];
}


-(void) post4List:(nullable NSString*)URLString
       parameters:(nullable id)parameters
            class:(nullable Class)aClass
          success:(nullable AFSuccessListBlock)success
          failure:(nullable AFFailureBlock)failure
      processView:(nullable UIView*)processView
{
    [self post:URLString parameters:parameters class:aClass extraClass:nil dsuccess:nil lsuccess:success failure:failure processView:processView];
}


-(void) post4List:(nullable NSString*)URLString
       parameters:(nullable id)parameters
            class:(nullable Class)aClass
       extraClass:(nullable Class)eClass
          success:(nullable AFSuccessListBlock)success
          failure:(nullable AFFailureBlock)failure
      processView:(nullable UIView*)processView
{
    [self post:URLString parameters:parameters class:aClass extraClass:eClass dsuccess:nil lsuccess:success failure:failure processView:processView];
}

@end
