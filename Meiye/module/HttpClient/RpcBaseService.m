//
//  RpcBaseService.m
//  PaixieMall
//
//  Created by zhwx on 14/12/10.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "RpcBaseService.h"
#import <CommonCrypto/CommonDigest.h>
#import "LogUtils.h"


/**
 * 默认的缓存有效期
 */
#define DEFAULT_CachePeriodInMinutes 30.0f

@implementation RpcBaseService


-(id) init
{
    if (self = [super init]) {
        self.httpClient = [[HttpClient alloc] init];
    }
    return self;
}


/**
 @method isOnlineMode
 @abstract 判断设备当前是否处于联网状态
 */
- (BOOL)isOnlineMode
{
    return YES;
}

#pragma mark- 缓存模块
/**
 @method getCacheDir
 @abstract 获取App的缓存目录
 @return 缓存目录对应的路径名称
 */
- (NSString *)getCacheDir
{
    NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* cacheDir = [[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"paixiemall"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDir]) {
        BOOL bo = [[NSFileManager defaultManager] createDirectoryAtPath:cacheDir withIntermediateDirectories:YES attributes:nil error:nil];
        NSAssert(bo,@"创建目录失败");
    }
    return cacheDir;
}

/**
 @method getCachePeriodInMinutes
 @abstract 获取缓存有效期，单位分钟。默认为30分钟。
 @return 返回缓存有效期，单位为分钟
 */
- (int)getCachePeriodInMinutes
{
    return DEFAULT_CachePeriodInMinutes;
}


/**
 @method deleteCacheByFilename:
 @abstract 根据缓存文件名删除缓存文件。
 @param filename 文件名
 */
- (void)deleteCacheByFilename:(NSString *)filename
{
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self getCacheDir] stringByAppendingPathComponent:filename];
    
    if ([fileManager removeItemAtPath:filePath error:&error] != YES) {
        NSInteger errCode = (error!=nil ? error.code : -1);
        NSLog(@"Removing file error: [error code:%ld], [file:%@]", (long)errCode, filePath);
    }
    
}

/**
 @method deleteCacheByFilename:
 @abstract 根据请求URL删除缓存文件。
 @param url 请求URL
 */
- (void)deleteCacheByRequestUrl:(NSString *)url
{
    [self deleteCacheByRequestUrl:url requestParam:nil];
}

/**
 @method deleteCacheByFilename: requestParam:
 @abstract 根据请求URL及参数删除缓存文件。
 @param url 请求URL
 @param param HTTP请求参数
 */
- (void)deleteCacheByRequestUrl:(NSString *)url requestParam:(NSDictionary *)param
{
    NSString* fileName = [self buildQueryStringForCacheFile:url requestParam:param];
    [self deleteCacheByFilename:fileName];
}

/**
 *	删除所有缓存
 */
- (void)clearCache
{
    NSString* directory = [self getCacheDir];
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSLog(@"Removing dir: %@", directory);
    
    NSArray* files = [fileManager contentsOfDirectoryAtPath:directory error:nil];
    
    for (NSString *file in files) {
        NSString *filePath = [directory stringByAppendingPathComponent:file];
        NSLog(@"Removing file : %@", filePath);
        
        if ([fileManager removeItemAtPath:filePath error:&error] != YES) {
            NSInteger errCode = (error!=nil ? error.code : -1);
            NSLog(@"Removing file error: [error code:%ld], [file:%@]", (long)errCode, filePath);
        }
    }
    
}

/**
 * 判断缓存是否有效
 * filePath 文件的绝对路径， minute 缓存有效分钟数
 */
-(BOOL) isValidateCacheFile:(NSString*)filePath minute:(NSInteger)minute
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    /***************判断缓存文件是否存在***********************/
    if (![fileManager fileExistsAtPath:filePath]){
        return NO;
    }
    
    /***************判断缓存是否有效***********************/
    //当前时间
    NSDate* nowDate = [NSDate date];
    
    //修改时间
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:nil];
    NSDate* modifyDate = [fileAttributes fileModificationDate];
    
    //计算间隔
    NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:modifyDate];
    
    if ((minute*60) < fabs(timeInterval)) {
        return NO;
    }
    return YES;
}



#pragma mark- 跑出网络异常
-(void) thrownAnNetWorkErrorException
{
    [NSException raise:NET_WORKING_NONE_EXCEPTION format:@"%@",@"isOnlineMode = 0"];
}




#pragma mark- 保存缓存数据到文件

-(void) saveAsynData:(NSString*)dataStr ToFile:(NSString*)filePath
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [dataStr writeToFile:filePath atomically:YES encoding:self.httpClient.responseEncoding error:nil];
    });
}


#pragma mark- 请求相关

-(JsonResponseHandler*) getDefaultBaseJsonParseObject
{
    JsonResponseHandler* handler = [[JsonResponseHandler alloc] init];
    return handler;
}


/**
 @method query:requestParam:reponseHandler
 @abstract 根据请求URL及参数发起远程请求，该方法使用JsonResponseHandler将返回的JSON结果解析成对应的Entity对象，并返回以该类型对象NSArray。  默认 ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE 方式
 @param url 请求URL
 @param param HTTP请求参数
 @return Entity数据集
 */
- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param{
    return [self query:url requestParam:param reponseHandler:nil];
}

/**
 @method query:requestParam:reponseHandler
 @abstract 根据请求URL及参数发起远程请求，该方法使用JsonResponseHandler将返回的JSON结果解析成对应的Entity对象，并返回以该类型对象NSArray。
 @param url 请求URL
 @param param HTTP请求参数
 @param handler JSON解析器，通常为JsonResponseHandler的子类
 @return Entity数据集
 */
- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler
{
    handler = handler?handler:[self getDefaultBaseJsonParseObject];
    
    ReadCacheStrategy strategy = ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE;
    
    NSString* filePath = [[self getCacheDir] stringByAppendingPathComponent:[self buildQueryStringForCacheFile:url requestParam:param]];
    
    //判断缓存
    BOOL isHaveCacheData = [self isValidateCacheFile:filePath minute:[self getCachePeriodInMinutes]];
    
    if (strategy == ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE) {
        
        NSString* resultStr = nil;
        //存在
        if (isHaveCacheData) {
            
            if ([self isOnlineMode]) {
                resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                [handler parse:resultStr];
                
                [self saveAsynData:resultStr ToFile:filePath];
                return handler.items;
            }else{
                [LogUtils log:@"取缓存" message:@"ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE"];
                resultStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:self.httpClient.responseEncoding];
                [handler parse:resultStr];
                return handler.items;
            }
        }else{
            
            if ([self isOnlineMode]) {
                resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                [handler parse:resultStr];
                
                [self saveAsynData:resultStr ToFile:filePath];
                return handler.items;
            }else{
                [self thrownAnNetWorkErrorException];
                return nil;
            }
        }
        
    }
    return nil;
}

/**
 *	查询记录，使用自定义缓存策略，如果有缓存策略，则采用默认缓存时效
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *	@param	strategy
 *
 *	@return
 */
- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy
{
    
    handler = handler?handler:[self getDefaultBaseJsonParseObject];
    
    NSString* filePath = [[self getCacheDir] stringByAppendingPathComponent:[self buildQueryStringForCacheFile:url requestParam:param]];
    
    //判断缓存
    BOOL isHaveCacheData = [self isValidateCacheFile:filePath minute:[self getCachePeriodInMinutes]];
    
    if (strategy == ReadCacheStrategy_READ_CACHE_FIRST) {
        
        NSString* resultStr = nil;
        //存在
        if (isHaveCacheData) {
            [LogUtils log:@"取缓存" message:@"ReadCacheStrategy_READ_CACHE_FIRST"];
            resultStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:self.httpClient.responseEncoding];
            [handler parse:resultStr];
            
            if ([self isOnlineMode]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString* newStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                    [newStr writeToFile:filePath atomically:YES encoding:self.httpClient.responseEncoding error:nil];
                });
            }
            
            return handler.items;
            
        }else{
            if (![self isOnlineMode]) {
                [self thrownAnNetWorkErrorException];
                return nil;
            }
            
            resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
            [handler parse:resultStr];
            
            [self saveAsynData:resultStr ToFile:filePath];
            return handler.items;
        }
        
        
    }else if (strategy == ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE){
        
        NSString* resultStr = nil;
        //存在
        if (isHaveCacheData) {
            
            if ([self isOnlineMode]) {
                resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                [handler parse:resultStr];
                
                [self saveAsynData:resultStr ToFile:filePath];
                return handler.items;
            }else{
                [LogUtils log:@"取缓存" message:@"ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE"];
                resultStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:self.httpClient.responseEncoding];
                [handler parse:resultStr];
                return handler.items;
            }
        }else{
            
            if ([self isOnlineMode]) {
                resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                [handler parse:resultStr];
                
                [self saveAsynData:resultStr ToFile:filePath];
                return handler.items;
            }else{
                [self thrownAnNetWorkErrorException];
                return nil;
            }
        }
        
    }else if (strategy == ReadCacheStrategy_NEVER_READ_CACHE){
        
        if (![self isOnlineMode]) {
            [self thrownAnNetWorkErrorException];
            return nil;
        }
        
        NSString* resultStr = nil;
        resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
        [handler parse:resultStr];
        
        [self saveAsynData:resultStr ToFile:filePath];
        return handler.items;
    }
    
    return nil;
}

/**
 *	查询记录，使用自定义缓存策略及缓存时效
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *	@param	strategy
 *	@param	cachePeriodInMinutes
 *
 *	@return
 */
- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy cachePeriod:(int)cachePeriodInMinutes
{
    handler = handler?handler:[self getDefaultBaseJsonParseObject];
    
    NSString* filePath = [[self getCacheDir] stringByAppendingPathComponent:[self buildQueryStringForCacheFile:url requestParam:param]];
    
    //判断缓存
    BOOL isHaveCacheData = [self isValidateCacheFile:filePath minute:cachePeriodInMinutes];
    
    if (strategy == ReadCacheStrategy_READ_CACHE_FIRST) {
        
        NSString* resultStr = nil;
        //存在
        if (isHaveCacheData) {
            [LogUtils log:@"取缓存" message:@"ReadCacheStrategy_READ_CACHE_FIRST"];
            resultStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:self.httpClient.responseEncoding];
            [handler parse:resultStr];
            
            if ([self isOnlineMode]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString* newStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                    [newStr writeToFile:filePath atomically:YES encoding:self.httpClient.responseEncoding error:nil];
                });
            }
            
            return handler.items;
            
        }else{
            if (![self isOnlineMode]) {
                [self thrownAnNetWorkErrorException];
                return nil;
            }
            
            resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
            [handler parse:resultStr];
            
            [self saveAsynData:resultStr ToFile:filePath];
            return handler.items;
        }
        
        
    }else if (strategy == ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE){
        
        NSString* resultStr = nil;
        //存在
        if (isHaveCacheData) {
            
            if ([self isOnlineMode]) {
                resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                [handler parse:resultStr];
                
                [self saveAsynData:resultStr ToFile:filePath];
                return handler.items;
            }else{
                [LogUtils log:@"取缓存" message:@"ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE"];
                resultStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:self.httpClient.responseEncoding];
                [handler parse:resultStr];
                return handler.items;
            }
        }else{
            
            if ([self isOnlineMode]) {
                resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                [handler parse:resultStr];
                
                [self saveAsynData:resultStr ToFile:filePath];
                return handler.items;
            }else{
                [self thrownAnNetWorkErrorException];
                return nil;
            }
        }
        
    }else if (strategy == ReadCacheStrategy_NEVER_READ_CACHE){
        
        if (![self isOnlineMode]) {
            [self thrownAnNetWorkErrorException];
            return nil;
        }
        
        NSString* resultStr = nil;
        resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
        [handler parse:resultStr];
        
        [self saveAsynData:resultStr ToFile:filePath];
        return handler.items;
    }
    
    return nil;
}

/**
 *	查询记录，但不读取缓存
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *
 *	@return
 */
- (NSArray *)queryWithoutCache:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler
{
    handler = handler?handler:[self getDefaultBaseJsonParseObject];
    if (![self isOnlineMode]) {
        [self thrownAnNetWorkErrorException];
        return nil;
    }
    
    NSString* filePath = [[self getCacheDir] stringByAppendingPathComponent:[self buildQueryStringForCacheFile:url requestParam:param]];
    
    NSString* resultStr = nil;
    resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
    [handler parse:resultStr];
    
    [self saveAsynData:resultStr ToFile:filePath];
    return handler.items;
    
}

/**
 *	获取记录详情，使用自定义缓存策略，如果有缓存策略，则采用默认缓存时效
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *	@param	strategy
 *
 *	@return
 */
- (id)getDetail:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy
{
    handler = handler?handler:[self getDefaultBaseJsonParseObject];
    
    NSString* filePath = [[self getCacheDir] stringByAppendingPathComponent:[self buildQueryStringForCacheFile:url requestParam:param]];
    
    //判断缓存
    BOOL isHaveCacheData = [self isValidateCacheFile:filePath minute:[self getCachePeriodInMinutes]];
    
    if (strategy == ReadCacheStrategy_READ_CACHE_FIRST) {
        
        NSString* resultStr = nil;
        //存在
        if (isHaveCacheData) {
            [LogUtils log:@"取缓存" message:@"ReadCacheStrategy_READ_CACHE_FIRST"];
            resultStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:self.httpClient.responseEncoding];
            [handler parse:resultStr];
            
            if ([self isOnlineMode]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString* newStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                    [newStr writeToFile:filePath atomically:YES encoding:self.httpClient.responseEncoding error:nil];
                });
            }
            
            return handler.item;
            
        }else{
            
            if (![self isOnlineMode]) {
                [self thrownAnNetWorkErrorException];
                return nil;
            }
            
            resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
            [handler parse:resultStr];
            
            [self saveAsynData:resultStr ToFile:filePath];
            return handler.item;
        }
        
        
    }else if (strategy == ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE){
        
        NSString* resultStr = nil;
        //存在
        if (isHaveCacheData) {
            
            if ([self isOnlineMode]) {
                resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                [handler parse:resultStr];
                
                [self saveAsynData:resultStr ToFile:filePath];
                return handler.item;
            }else{
                [LogUtils log:@"取缓存" message:@"ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE"];
                resultStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:self.httpClient.responseEncoding];
                [handler parse:resultStr];
                return handler.item;
            }
        }else{
            
            if ([self isOnlineMode]) {
                resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                [handler parse:resultStr];
                
                [self saveAsynData:resultStr ToFile:filePath];
                return handler.item;
            }else{
                [self thrownAnNetWorkErrorException];
                return nil;
            }
        }
        
    }else if (strategy == ReadCacheStrategy_NEVER_READ_CACHE){
        
        if (![self isOnlineMode]) {
            [self thrownAnNetWorkErrorException];
            return nil;
        }
        
        NSString* resultStr = nil;
        resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
        [handler parse:resultStr];
        
        [self saveAsynData:resultStr ToFile:filePath];
        return handler.item;
    }
    
    return nil;
}

/**
 *	获取记录详情，使用自定义缓存策略及缓存时效
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *	@param	strategy
 *	@param	cachePeriodInMinutes
 *
 *	@return
 */
- (id)getDetail:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy cachePeriod:(int)cachePeriodInMinutes
{
    handler = handler?handler:[self getDefaultBaseJsonParseObject];
    
    NSString* filePath = [[self getCacheDir] stringByAppendingPathComponent:[self buildQueryStringForCacheFile:url requestParam:param]];
    
    //判断缓存
    BOOL isHaveCacheData = [self isValidateCacheFile:filePath minute:cachePeriodInMinutes];
    
    if (strategy == ReadCacheStrategy_READ_CACHE_FIRST) {
        
        NSString* resultStr = nil;
        //存在
        if (isHaveCacheData) {
            [LogUtils log:@"取缓存" message:@"ReadCacheStrategy_READ_CACHE_FIRST"];
            resultStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:self.httpClient.responseEncoding];
            [handler parse:resultStr];
            
            if ([self isOnlineMode]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString* newStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                    [newStr writeToFile:filePath atomically:YES encoding:self.httpClient.responseEncoding error:nil];
                });
            }
            
            return handler.item;
            
        }else{
            
            if (![self isOnlineMode]) {
                [self thrownAnNetWorkErrorException];
                return nil;
            }
            
            resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
            [handler parse:resultStr];
            
            [self saveAsynData:resultStr ToFile:filePath];
            return handler.item;
        }
        
        
    }else if (strategy == ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE){
        
        NSString* resultStr = nil;
        //存在
        if (isHaveCacheData) {
            
            if ([self isOnlineMode]) {
                resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                [handler parse:resultStr];
                
                [self saveAsynData:resultStr ToFile:filePath];
                return handler.item;
            }else{
                [LogUtils log:@"取缓存" message:@"ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE"];
                resultStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:filePath] encoding:self.httpClient.responseEncoding];
                [handler parse:resultStr];
                return handler.item;
            }
        }else{
            
            if ([self isOnlineMode]) {
                resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
                [handler parse:resultStr];
                
                [self saveAsynData:resultStr ToFile:filePath];
                return handler.item;
            }else{
                [self thrownAnNetWorkErrorException];
                return nil;
            }
        }
        
    }else if (strategy == ReadCacheStrategy_NEVER_READ_CACHE){
        
        if (![self isOnlineMode]) {
            [self thrownAnNetWorkErrorException];
            return nil;
        }
        
        NSString* resultStr = nil;
        resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
        [handler parse:resultStr];
        
        [self saveAsynData:resultStr ToFile:filePath];
        return handler.item;
    }
    
    return nil;
}

/**
 *	获取记录详情，但不读取缓存
 *
 *	@param	url
 *	@param	param
 *
 *	@return
 */
- (id)getDetailWithoutCache:(NSString *)url requestParam:(NSDictionary *)param{
    return [self getDetailWithoutCache:url requestParam:param reponseHandler:nil];
}
/**
 *	获取记录详情，但不读取缓存
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *
 *	@return
 */
- (id)getDetailWithoutCache:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler
{
    handler = handler?handler:[self getDefaultBaseJsonParseObject];
    if (![self isOnlineMode]) {
        [self thrownAnNetWorkErrorException];
        return nil;
    }
    
    NSString* filePath = [[self getCacheDir] stringByAppendingPathComponent:[self buildQueryStringForCacheFile:url requestParam:param]];
    
    NSString* resultStr = nil;
    resultStr = [self.httpClient sendGetRequestAndReturnString:url requestParam:param];
    [handler parse:resultStr];
    
    [self saveAsynData:resultStr ToFile:filePath];
    return handler.item;
    
}

/**
 *	发送Post数据至远程服务器
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *
 *	@return
 */
- (id)sendPostWithoutCache:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler
{
    handler = handler?handler:[self getDefaultBaseJsonParseObject];
    if (![self isOnlineMode]) {
        [self thrownAnNetWorkErrorException];
        return nil;
    }
    
    NSString* resultStr = [self.httpClient sendPostRequestAndReturnString:url requestParam:param];
    [handler parse:resultStr];
    
    NSString* filePath = [[self getCacheDir] stringByAppendingPathComponent:[self buildQueryStringForCacheFile:url requestParam:param]];
    [self saveAsynData:resultStr ToFile:filePath];
    
    return handler.item;
}


#pragma mark- 辅助工具

/**
 *	对文件名MD5
 *
 *	@return
 */
+ (NSString *) makeMD5WithString:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (uint32_t)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


/**
 @method buildQueryStringForCacheFile: requestParam:
 @abstract 根据URL及查询参数构建用于缓存的文件名
 @return
 */
- (NSString *)buildQueryStringForCacheFile:(NSString *)url requestParam:(NSDictionary *)param
{
    if (!param) {
        return [[self class] makeMD5WithString:url];
    }
    
    NSMutableString* allStr = [NSMutableString string];
    for (NSString* key in [param allKeys]) {
        
        NSString* keyValue = param[key];
        if (keyValue && [keyValue isKindOfClass:[NSString class]]  && keyValue.length>0) {
            
            NSString* kVStr = [NSString stringWithFormat:@"%@=%@&",key,keyValue];
            [allStr appendString:kVStr];
        }
        
    }
    [allStr deleteCharactersInRange:NSMakeRange(allStr.length-1, 1)];
    
    return [[self class] makeMD5WithString:allStr];
}
@end
