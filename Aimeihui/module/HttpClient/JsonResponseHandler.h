//
//  JsonResponseHandler.h
//  PaixieMall
//
//  Created by zhwx on 14/12/9.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paging.h"
#import "Entity.h"

#define ResultCode_Success @"00"

#define ResultCode_FormatError @"01"
#define ResultCode_FormatError_Exception @"请求数据格式错误"

#define ResultCode_SignatureError @"02"
#define ResultCode_SignatureError_Exception @"签名不通过"

#define ResultCode_TokenIdInvalid @"03"
#define ResultCode_TokenIdInvalid_Exception @"TokenId无效"

#define ResultCode_AppError @"98"
//#define ResultCode_AppError_Exception @"应用程序(业务)错误"

#define ResultCode_ServiceError @"99"
#define ResultCode_ServiceError_Exception @"很抱歉,系统错误"

/**
 * 协议规定 的一些 特殊字段名称
 */
#define JSON_KEY_STATUS @"ResultCode"
//#define JSON_KEY_STATUS_CODE 200
#define JSON_KEY_RECORD @"ResultInfo" //并没什么卵用
#define JSON_KEY_LIST @"List" //数组对象
//#define JSON_KEY_EXECPTION @"ResultCode"//异常 编号
//#define JSON_KEY_EXECPTION_DES @"msg" //服务端 下发的异常描述
#define JSON_KEY_ENTITY_ID @"Id"

/**
 * 统一的非逻辑异常提示
 */
#define UNIFIED_ERROR_MSG @"服务器异常，请稍后再试"

/**
 * json-》对象 。 【子类 实现此接口，用于解析 Module】
 * 单个对象: 调用一次。
 * 数组对象: 调用多次
 */
@protocol EntityParseDelegate <NSObject>

- (id)parseEntityFromJson:(NSDictionary *)jsonObject;

@end


/**
 * json 解析成对象的  根类
 */
@interface JsonResponseHandler : NSObject<EntityParseDelegate> {
    
    
}

/**
 * 解析成 对象 的代理。 默认为self
 */
@property (weak, nonatomic) id<EntityParseDelegate> delegate;

#pragma mark- 保存解析结果
/**
 * 单个对象的 解析结果。
 */
@property (strong, nonatomic) id item;
/**
 * 数组对象的 解析结果。
 */
@property (strong, nonatomic) NSMutableArray *items;

/**
 * 若为数组对象。则同时 产生页码对象
 */
@property (strong, nonatomic) Paging *paging;

#pragma mark- 服务器返回的最原始的字段对象
/**
 * 接收到的 jsonstr -》 字段对象。
 */
@property (strong,nonatomic)NSDictionary* o_jsonDic;


#pragma mark - 验证数据是否有效
/**
 * 验证json对象 是否有值。 【NSNull ， nil】 返回NO。
 */
- (BOOL)validateNode:(id)jsonValue;
/**
 * 验证string 是否有值。 【NSNull ， nil，length《=0】 返回NO。
 */
- (BOOL)validateStringNode:(NSString *)jsonValue;

#pragma mark - 工具
/**
 * 解析字符串 （符合字符串规则，返回字符串，否则返回 nil）
 */
-(NSString*) parseStringWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key;

/**
 * 解析数字类型 （符合数字类型规则，返回数字类型，否则返回 0.0）
 */
-(double) parseNumberWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key;

/**
 * 解析日期 （符合日期规则，返回日期，否则返回 nil）
 */
-(NSDate*) parseDateWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key;


#pragma mark - 解析 (非重写解析逻辑，此模块方法不需要主动调用)
/**
 * 最原始的 解析返回的 网络字符串。（重写此方法可以 完全替代解析的整个过程）
 */
- (void)parse:(NSString *)jsonStr;

/**
 * @abstract 自由解析整个JSON对象 （重写此方法可以 替代解析 json字符串的过程）
 */
- (void)parseJsonObjectFreely:(NSDictionary *)jsonObject;

/**
 * 解析业务异常【服务端返回的 逻辑异常】
 */
- (void)parseRemoteException:(NSString *)exception;
/**
 * 解析 Recordset 对象 (数组)
 */
- (void)parseRecordset:(NSArray *)recordset;
/**
 * 解析 Record 对象（单个对象）
 */
- (id)parseRecord:(NSDictionary *)record;


@end
