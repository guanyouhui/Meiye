//
//  JsonHandler.h
//  WuLiuDS
//
//  Created by zhwx on 14-9-27.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paging.h"

/**
 * 分页字段
 */
#define JSON_KEY_PAGING @"Paging"
#define JSON_KEY_PAGE @"Page"
#define JSON_KEY_PAGE_SIZE @"Page_Size"
#define JSON_KEY_PAGES @"Pages"
#define JSON_KEY_RECORDS @"Records"

////数据字段
//#define JSON_KEY_DATA @"data"
////扩展(附加)数据字段
//#define JSON_KEY_EXTRA_DATA @"extra_data"
//
////错误码字段
//#define JSON_KEY_CODE @"code"
//#define JSON_KEY_MSG @"msg"


/**
 *  Module 对象基类
 */
@interface BaseObject : NSObject<NSCoding, NSCopying> //(暂时没有 写 Modle，采用字典)

@property (nonatomic,strong) NSDictionary* responseObject;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end



@interface Erroring : NSObject

@property (nonatomic,copy) NSString* o_message;
@property (nonatomic,assign) NSInteger o_code;
@property (nonatomic,copy) NSString* o_request;//请求的地址

@end



/**
 *  序列化、反序列化(解析对象)基类
 */
@interface JsonHandler : NSObject

//整个字典数据
@property (nonatomic,strong) NSDictionary* o_resultDict;

//错误部分
@property (nonatomic,strong) Erroring* o_error;

//单个对象
@property (nonatomic,strong) BaseObject* o_singleData;

//数组对象
@property (nonatomic,strong) Paging* o_paging;
@property (nonatomic,strong) NSMutableArray* o_resultDatas;
//额外附加对象(数组返回list 不够用 可以增加此字段)
@property (nonatomic,strong) BaseObject* o_extraData;

#pragma mark-


/**
 * 序列化 请求的参数
 */
-(NSDictionary*) serialWithData:(BaseObject*)objc;

/**
 * 解析 aClass、eClass 对象
 * 返回 Erroring 、 BaseObject 、 NSMutableArray  nil 类型 对象  之一
 */
-(id) deserialWithDict:(NSDictionary*)dict class:(Class)aClass extraClass:(Class)eClass;


@end
