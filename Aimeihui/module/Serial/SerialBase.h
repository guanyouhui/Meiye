//
//  SerialBase.h
//  WuLiuDS
//
//  Created by zhwx on 14-9-27.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paging.h"

#define START_KEY @"start"
#define COUNT_KEY @"count"



@interface SerialBase : NSObject

//错误部分
@property (nonatomic,strong) Erroring* o_error;

//单个对象
@property (nonatomic,strong) BaseObject* o_singleData;

//数组对象
@property (nonatomic,strong) Paging* o_paging;
@property (nonatomic,strong) NSMutableArray* o_resultDatas; //CargolngoResponse数组





/**
 * 解析错误
 */
-(Erroring*) parseErrorWithDictionary:(NSDictionary*)dic;


/**
 * 解析数组对象的 翻页对象
 */
-(Paging*) parsePageWithDictionary:(NSDictionary*)dic;


/**
 * 解析数组
 */
-(NSArray*) parseArrayWithDictionary:(NSDictionary*)dic;




/**
 * 序列化 请求的参数
 */
-(NSDictionary*) serialData;

/**
 * 反序列化成自身对象
 * 返回 Erroring 、 BaseObject 、 NSMutableArray 类型 对象  之一
 */
-(id) deserialWithDictionary:(NSDictionary*)dic;

@end
