//
//  SerialBase.m
//  WuLiuDS
//
//  Created by zhwx on 14-9-27.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import "SerialBase.h"

@implementation BaseObject



@end

@implementation Erroring



@end




@implementation SerialBase

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
-(Erroring*) parseErrorWithDictionary:(NSDictionary *)dic
{
    NSString* msg = [dic valueForKey:@"msg"];
    NSNumber* code = [dic valueForKey:@"code"];
    NSString* request = [dic valueForKey:@"request"];
    
    if ((msg && code) || (msg && request) || (code && request)) {
        self.o_error = [[Erroring alloc] init];
        self.o_error.o_code = code.intValue;
        self.o_error.o_message = msg;
        self.o_error.o_request = request;
    }
    return self.o_error;
}

/**
 * 解析数组对象的 翻页对象
 */
-(Paging*) parsePageWithDictionary:(NSDictionary*)dic
{
    
    NSNumber* start = [dic valueForKey:@"start"];
    NSNumber* count = [dic valueForKey:@"count"];
    NSNumber* total = [dic valueForKey:@"total"];

    if (total) {
        
        if (count) {
            self.o_paging.pageSize = count.intValue;
        }
        if (start) {
            self.o_paging.page = start.intValue / (self.o_paging.pageSize<=0?1:self.o_paging.pageSize) + 1;
        }

        
        self.o_paging.records = total.intValue;
        
        self.o_paging.pages = (self.o_paging.records / (self.o_paging.pageSize<=0?1:self.o_paging.pageSize))
        + ((self.o_paging.records % (self.o_paging.pageSize<=0?1:self.o_paging.pageSize))>0?1:0);
        
        

    }
    return self.o_paging;
}


/**
 * 解析数组对象的
 */
-(NSArray*) parseArrayWithDictionary:(NSDictionary*)dic
{
    NSArray* datas = [dic valueForKey:@"data"];
    
    return datas;
}



-(NSDictionary*) serialData
{
    return nil;
}

-(id) deserialWithDictionary:(NSDictionary*)dic
{
    //有错误 直接返回 nil
    if ([self parseErrorWithDictionary:dic]) {
        return self.o_error;
    }
    
    //解析 page
    Paging* resPaging = [self parsePageWithDictionary:dic];
    NSArray* resArray = [self parseArrayWithDictionary:dic];
    if (resPaging && resArray) {
        
        self.o_resultDatas = [NSMutableArray arrayWithArray:resArray];
        return resArray;
    }
    
    
    return self.o_singleData;
}

@end
