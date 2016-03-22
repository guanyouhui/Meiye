//
//  JsonHandler.m
//  WuLiuDS
//
//  Created by zhwx on 14-9-27.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import "JsonHandler.h"

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
#define JSON_KEY_RECORD @"ResultInfo" //错误提示
#define JSON_KEY_LIST @"List" //数组对象

@implementation BaseObject

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return nil;
}
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    return nil;
}
- (NSDictionary *)dictionaryRepresentation
{
    return nil;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

}

- (id)copyWithZone:(NSZone *)zone
{

    return nil;
}


@end

@implementation Erroring



@end




@implementation JsonHandler

-(id) init
{
    if (self = [super init]) {
        self.o_paging = [[Paging alloc] init];
        self.o_resultDatas = [NSMutableArray array];
        self.o_singleData = [[BaseObject alloc] init];
    }
    return self;
}


/**
 * 解析错误
 */
-(Erroring*) parseErrorWithDict:(NSDictionary *)dict
{
    NSString* msg = dict[JSON_KEY_RECORD];
    NSString * code = FORMAT(@"%@",dict[JSON_KEY_STATUS]);
    
    if (![code isEqualToString:ResultCode_Success]) {
        self.o_error = [[Erroring alloc] init];
        self.o_error.o_code = code.intValue;
        self.o_error.o_message = msg;
        return self.o_error;
    }
    return nil;
}

/**
 * 解析单个对象
 */
-(BaseObject*) parseObjectWithDict:(NSDictionary*)dict class:(Class)aClass
{
    self.o_singleData = [aClass modelObjectWithDictionary:dict];
    self.o_singleData.responseObject = dict;
    
    return self.o_singleData;
}


/**
 * 解析数字类型 （符合数字类型规则，返回数字类型，否则返回 0.0）
 */
-(double) parseNumberWithJsonValue:(NSNumber*)value
{
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return value.doubleValue;
    }
    return 0.0;
}

/**
 * 解析数组对象的 翻页对象
 */
-(Paging*) parsePageWithDict:(NSDictionary*)dict
{
    if (dict && [dict allKeys].count > 0) {
        
        self.o_paging.page = [self parseNumberWithJsonValue:dict[JSON_KEY_PAGE]];
        self.o_paging.pageSize = [self parseNumberWithJsonValue:dict[JSON_KEY_PAGE_SIZE]];
        self.o_paging.pages = [self parseNumberWithJsonValue:dict[JSON_KEY_PAGES]];
        self.o_paging.records = [self parseNumberWithJsonValue:dict[JSON_KEY_RECORDS]];
    }
    return self.o_paging;
}


/**
 * 解析数组对象的
 */
-(NSArray*) parseArrayWithArray:(NSArray*)array class:(Class)aClass
{
    if (aClass) {
        self.o_resultDatas = [NSMutableArray array];
        
        for (NSDictionary* tDict in array) {
            BaseObject* tObject = [aClass modelObjectWithDictionary:tDict];
            if (tObject) {
                [self.o_resultDatas addObject:tObject];
            }
        }
    }else{
        self.o_resultDatas = [NSMutableArray arrayWithArray:array];
    }
    
    return self.o_resultDatas;
}



-(NSDictionary*) serialWithData:(BaseObject *)objc
{
    NSDictionary* result = [objc dictionaryRepresentation];
    return result;
}

/**
 * 解析 aClass、eClass 对象
 * 返回 Erroring 、 BaseObject 、 NSMutableArray  nil 类型 对象  之一
 */
-(id) deserialWithDict:(NSDictionary*)dict class:(Class)aClass extraClass:(Class)eClass
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    self.o_resultDict = dict;
    
    //有错误 直接返回 
    if ([self parseErrorWithDict:dict]) {
        return self.o_error;
    }
    
    NSArray * List = dict[JSON_KEY_LIST];
    
    //数组对象
    if ([List isKindOfClass:[NSArray class]] && List.count > 0) {
        
        //解析 page
        [self parsePageWithDict:dict[JSON_KEY_PAGING]];
        
        //解析数组内容
        NSArray* resArray = [self parseArrayWithArray:List class:aClass];
        
        return resArray;
    }
    //单个对象
    else if ([dict isKindOfClass:[NSDictionary class]]) {
        
        BaseObject* resDict = [self parseObjectWithDict:dict class:aClass];
        
        return resDict;
    }

    //解析字段 有问题
    self.o_error = [[Erroring alloc] init];

    self.o_error.o_message = @"返回字段格式错误";
    return self.o_error;
}

@end
