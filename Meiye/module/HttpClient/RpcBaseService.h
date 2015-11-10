//
//  RpcBaseService.h
//  PaixieMall
//
//  Created by zhwx on 14/12/10.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "JsonResponseHandler.h"

//缓存策略
typedef enum {
    
    /**
     * 优先读取缓存，后访问网络。默认的缓存策略。
     */
    ReadCacheStrategy_READ_CACHE_FIRST = 0,
    
    /**
     * 只有在离线状态下读取缓存
     */
    ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE = 1,
    
    /**
     * 从不读取缓存
     */
    ReadCacheStrategy_NEVER_READ_CACHE = 2
    
} ReadCacheStrategy;

@interface RpcBaseService : NSObject {
    
}

@property (strong, nonatomic) HttpClient *httpClient;


/**
 @method isOnlineMode
 @abstract 判断设备当前是否处于联网状态
 */
- (BOOL)isOnlineMode;

#pragma mark- 缓存模块
/**
 @method getCacheDir
 @abstract 获取App的缓存目录
 @return 缓存目录对应的路径名称
 */
- (NSString *)getCacheDir;

/**
 @method getCachePeriodInMinutes
 @abstract 获取缓存有效期，单位分钟。默认为30分钟。(子类重写此方法，可修改值)
 @return 返回缓存有效期，单位为分钟
 */
- (int)getCachePeriodInMinutes;

/**
 @method deleteCacheByFilename:
 @abstract 根据缓存文件名删除缓存文件。
 @param filename 文件名
 */
- (void)deleteCacheByFilename:(NSString *)filename;

/**
 @method deleteCacheByFilename:
 @abstract 根据请求URL删除缓存文件。
 @param url 请求URL
 */
- (void)deleteCacheByRequestUrl:(NSString *)url;

/**
 @method deleteCacheByFilename: requestParam:
 @abstract 根据请求URL及参数删除缓存文件。
 @param url 请求URL
 @param param HTTP请求参数
 */
- (void)deleteCacheByRequestUrl:(NSString *)url requestParam:(NSDictionary *)param;

/**
 *	删除所有缓存
 */
- (void)clearCache;


#pragma mark- 请求相关
/**
 @method query:requestParam:reponseHandler
 @abstract 根据请求URL及参数发起远程请求，该方法使用JsonResponseHandler将返回的JSON结果解析成对应的Entity对象，并返回以该类型对象NSArray。  默认 ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE 方式
 @param url 请求URL
 @param param HTTP请求参数
 @return Entity数据集
 */
- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param;

/**
 @method query:requestParam:reponseHandler
 @abstract 根据请求URL及参数发起远程请求，该方法使用JsonResponseHandler将返回的JSON结果解析成对应的Entity对象，并返回以该类型对象NSArray。  默认 ReadCacheStrategy_READ_CACHE_ONLY_OFFLINE 方式
 @param url 请求URL
 @param param HTTP请求参数
 @param handler JSON解析器，通常为JsonResponseHandler的子类
 @return Entity数据集
 */
- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler;

/**
 *	查询数组记录，使用自定义缓存策略，如果有缓存策略，则采用默认缓存时效
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *	@param	strategy
 *
 *	@return
 */
- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy;

/**
 *	查询数组记录，使用自定义缓存策略及缓存时效
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *	@param	strategy
 *	@param	cachePeriodInMinutes
 *
 *	@return
 */
- (NSArray *)query:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy cachePeriod:(int)cachePeriodInMinutes;

/**
 *	查询数组记录，但不读取缓存
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *
 *	@return
 */
- (NSArray *)queryWithoutCache:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler;



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
- (id)getDetail:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy;

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
- (id)getDetail:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler cacheStrategy:(ReadCacheStrategy)strategy cachePeriod:(int)cachePeriodInMinutes;


/**
 *	获取记录详情，但不读取缓存
 *
 *	@param	url
 *	@param	param
 *
 *	@return
 */
- (id)getDetailWithoutCache:(NSString *)url requestParam:(NSDictionary *)param;

/**
 *	获取记录详情，但不读取缓存
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *
 *	@return
 */
- (id)getDetailWithoutCache:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler;



/**
 *	发送Post数据至远程服务器
 *
 *	@param	url
 *	@param	param
 *	@param	handler
 *
 *	@return
 */
- (id)sendPostWithoutCache:(NSString *)url requestParam:(NSDictionary *)param reponseHandler:(JsonResponseHandler *)handler;


#pragma mark- 辅助工具


/**
 @method buildQueryStringForCacheFile: requestParam:
 @abstract 根据URL及查询参数构建用于缓存的文件名
 @return
 */
- (NSString *)buildQueryStringForCacheFile:(NSString *)url requestParam:(NSDictionary *)param;

@end
