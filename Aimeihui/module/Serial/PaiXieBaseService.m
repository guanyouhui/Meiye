//
//  PaiXieBaseService.m
//  PaixieMall
//
//  Created by hi allen on 12-12-11.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import "PaiXieBaseService.h"
#import "Constant.h"
#import "ServiceUrls.h"
 
#import "SBJson.h"
#import "OpenUDID.h"
#import "Global.h"
#import "HttpClient.h"


static NSString *cacheDir;

@interface PaiXieBaseService() {
    
}

@end

@implementation PaiXieBaseService

- (id)init {
    self = [super init];
    
    if (self) {
        self.httpClient = [[HttpClient alloc] init];
        if (cacheDir == nil) {
            
            NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            cacheDir = [[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"paixiemall"];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDir]) {
                BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
                NSAssert(bo,@"创建【缓存目录】失败");
            }
            
//            @"/var/mobile/Containers/Data/Application/0406B2CC-AEBD-4FFE-B6DC-9A123AEECA9D/Library/Caches/PaiXieMall/paixiemall"
            
        }
    }
    return self;
}

+ (NSString *)getRpcUrl:(NSString *)uri {
    return uri;
}

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
//    [requestParam setObjectNotNull:applicationHelper.loginedMember.o_userId forKey:@"TokenId"];
    [requestParam setValue:timeStamp forKey:@"RequestTime"];
    [requestParam setValue:[OpenUDID value] forKey:@"RandomStr"];
    [requestParam setValue:@"123456" forKey:@"Digest"];
    [requestParam setValue:[OpenUDID value] forKey:@"IMEI"];
    [requestParam addEntriesFromDictionary:dataParam];
//    RandomStr={0}& RequestTime={1}&Ak={2}

    return requestParam;
}

- (BOOL)isOnlineMode {
    return YES;
}

- (NSString *)getCacheDir {
    return cacheDir;
}

- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy cachePeriod:(int)cachePeriodInMinutes {
    return [super query:SERVICE_CONNECT_RUL requestParam:[self getSignValue:url param:param] reponseHandler:handler cacheStrategy:strategy cachePeriod:cachePeriodInMinutes];
}

- (id)getDetail:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy cachePeriod:(int)cachePeriodInMinutes {
    return [super getDetail:SERVICE_CONNECT_RUL requestParam:[self getSignValue:url param:param] reponseHandler:handler cacheStrategy:strategy cachePeriod:cachePeriodInMinutes];
}

- (id)sendPostWithoutCache:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler {
    return [super sendPostWithoutCache:SERVICE_CONNECT_RUL requestParam:[self getSignValue:url param:param] reponseHandler:handler];
}

- (NSString *)buildQueryStringForCacheFile:(NSString *)url requestParam:(NSDictionary *)param {
    NSMutableDictionary *cacheParam = [[NSMutableDictionary alloc] initWithDictionary:param];
    [cacheParam removeObjectForKey:@"sign"];
    [cacheParam removeObjectForKey:@"timestamp"];
    
    return [super buildQueryStringForCacheFile:url requestParam:cacheParam];
}

//------add by zwx-------
#pragma mark- add by zwx
- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param
{
    return [super query:SERVICE_CONNECT_RUL requestParam:[self getSignValue:url param:param]];
}

- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler
{
    return [super query:SERVICE_CONNECT_RUL requestParam:[self getSignValue:url param:param] reponseHandler:handler];
}

- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy
{
    return [super query:SERVICE_CONNECT_RUL requestParam:[self getSignValue:url param:param] reponseHandler:handler cacheStrategy:strategy];
}

- (NSArray *)queryWithoutCache:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler
{
    return [super queryWithoutCache:SERVICE_CONNECT_RUL requestParam:[self getSignValue:url param:param] reponseHandler:handler];
}

- (id)getDetail:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy
{
    return [super getDetail:SERVICE_CONNECT_RUL requestParam:[self getSignValue:url param:param] reponseHandler:handler cacheStrategy:strategy];
}

- (id)getDetailWithoutCache:(NSString *)url requestParam:(NSDictionary *)param{
    return [super getDetailWithoutCache:SERVICE_CONNECT_RUL requestParam:[self getSignValue:url param:param]];
}
- (id)getDetailWithoutCache:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler
{
    return [super getDetailWithoutCache:SERVICE_CONNECT_RUL requestParam:[self getSignValue:url param:param] reponseHandler:handler];
}



@end
