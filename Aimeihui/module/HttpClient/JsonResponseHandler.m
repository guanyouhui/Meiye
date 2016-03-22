//
//  JsonResponseHandler.m
//  PaixieMall
//
//  Created by zhwx on 14/12/9.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "JsonResponseHandler.h"


@interface JsonResponseHandler ()



@end


@implementation JsonResponseHandler

-(id) init
{
    if (self = [super init]) {
        self.o_jsonDic = nil;
        self.paging = [[Paging alloc] init];
        self.item = nil;
        self.items = [NSMutableArray array];
        self.delegate = self;
    }
    return self;
}


#pragma mark-
- (BOOL)validateNode:(id)jsonValue
{
    if (jsonValue && ![jsonValue isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)validateStringNode:(NSString *)jsonValue
{
    if (![jsonValue isKindOfClass:[NSNull class]] && [jsonValue isKindOfClass:[NSString class]] && jsonValue.length>0) {
        return YES;
    }
    return NO;
}

#pragma mark- 解析
- (void)parse:(NSString *)jsonStr
{
    if (!jsonStr || ![jsonStr isKindOfClass:[NSString class]] || jsonStr.length<=0) {
        [self parseRemoteException:@"返回Json 为空"];
        return;
    }
    
    
    
    //转成 utf8
    NSData* tdata = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    NSDictionary* recDic = [NSJSONSerialization JSONObjectWithData:tdata options:NSJSONReadingAllowFragments error:&error];
    
    if (error) {
        [self parseRemoteException:@"Json 格式错误"];
        return;
    }
    
    [self parseJsonObjectFreely:recDic];
    
}

/**
 * @abstract 自由解析整个JSON对象
 *
 */
- (void)parseJsonObjectFreely:(NSDictionary *)jsonObject
{
    self.o_jsonDic = jsonObject;
    
    //服务端传 code 值为 NSNumber 或者 NSString
//    id exceptionCodeValue = self.o_jsonDic[JSON_KEY_EXECPTION];
//    NSString* codeStr = @"";
//    if (exceptionCodeValue) {
//        if ([exceptionCodeValue isKindOfClass:[NSString class]]) {
//            codeStr = exceptionCodeValue;
//        }else if ([exceptionCodeValue isKindOfClass:[NSNumber class]]) {
//            codeStr = ((NSNumber*)exceptionCodeValue).stringValue;
//        }
//    }
    
    //解析异常字段
//    if ([self validateStringNode:codeStr]) {
//        [self parseRemoteException:codeStr];
//        return;
//    }
    
    //解析status
    NSString* status = self.o_jsonDic[JSON_KEY_STATUS];
    if (!status || ![status isEqualToString:ResultCode_Success]) {
        if ([status isEqualToString:ResultCode_FormatError]) {
            [self parseRemoteException:ResultCode_FormatError_Exception];
        }
        else if ([status isEqualToString:ResultCode_SignatureError]) {
            [self parseRemoteException:ResultCode_SignatureError_Exception];
        }
        else if ([status isEqualToString:ResultCode_TokenIdInvalid]) {
            [self parseRemoteException:ResultCode_TokenIdInvalid_Exception];
        }
        else if ([status isEqualToString:ResultCode_AppError]) {
            [self parseRemoteException:self.o_jsonDic[JSON_KEY_RECORD]];
        }
        else if ([status isEqualToString:ResultCode_ServiceError]) {
            [self parseRemoteException:ResultCode_ServiceError_Exception];
        }
        
        return;
    }
    
    //解析 record
    if ([self validateNode:self.o_jsonDic]) {
        [self parseRecord:self.o_jsonDic];
    }
    
    //解析 数组对象
    if ([self validateNode:self.o_jsonDic[JSON_KEY_LIST]]) {
        [self parseRecordset:self.o_jsonDic[JSON_KEY_LIST]];
    }
    
    //解析 Paging
    if ([self validateNode:self.o_jsonDic[JSON_KEY_PAGING]]) {
        [self parsePaging:self.o_jsonDic[JSON_KEY_PAGING]];
    }
    
}



- (void)parseRemoteException:(NSString *)exception
{
    [NSException raise:exception format:@""];
//    //有服务器返回的动态异常  则返回服务端的异常描述
//    NSString* customDes = self.o_jsonDic[JSON_KEY_EXECPTION_DES];
//    if ([self validateStringNode:customDes]) {
//        [NSException raise:exception format:@"%@", customDes];
//    }else{
//        [NSException raise:exception format:@"%@", UNIFIED_ERROR_MSG];
//    }
}

- (void)parsePaging:(NSDictionary *)pagingDic
{
    if ([pagingDic isKindOfClass:[NSDictionary class]]) {
        self.paging.page = [self parseNumberWithJsonDic:pagingDic key:JSON_KEY_PAGE];
        self.paging.pageSize = [self parseNumberWithJsonDic:pagingDic key:JSON_KEY_PAGE_SIZE];
        self.paging.pages = [self parseNumberWithJsonDic:pagingDic key:JSON_KEY_PAGES];
        self.paging.records = [self parseNumberWithJsonDic:pagingDic key:JSON_KEY_RECORDS];
    }
}


- (void)parseRecordset:(NSArray *)recordset
{
    if (![recordset isKindOfClass:[NSArray class]] || recordset.count<=0) {
        return;
    }
    for (NSDictionary* record in recordset) {
        id item = [self parseRecord:record];
        if (item) {
            [self.items addObject:item];
        }
    }
}
- (id)parseRecord:(NSDictionary *)record
{
    self.item = record;
    //如果为空 则不解析
    if (![record isKindOfClass:[NSDictionary class]] || record.allKeys.count<=0) {
        return nil;
    }
    
    if ([self.delegate respondsToSelector:@selector(parseEntityFromJson:)]) {
        NSObject * item = [self.delegate parseEntityFromJson:record];
        
        if (item) {
            self.item = item;
        }
        //解析 id 字段
        if (self.item && [self.item isKindOfClass:[Entity class]]) {
            ((Entity*)self.item).entityId = [self parseEntity:record];
        }
    }
    return self.item;
}

- (id)parseEntity:(NSDictionary *)record
{
    id entity_id = [record objectForKey:JSON_KEY_ENTITY_ID];
    if ([entity_id isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%lld",[((NSNumber*)entity_id) longLongValue]];
    }else if ([entity_id isKindOfClass:[NSString class]]){
        return entity_id;
    }
    return nil;
}


#pragma mark- EntityParseDelegate

-(id) parseEntityFromJson:(NSDictionary *)jsonObject
{
//    NSLog(@"子类【%@】未实现:【%s】",[self class],__FUNCTION__);
    return nil;
}



#pragma mark - 工具
/**
 * 解析字符串 （符合字符串规则，返回字符串，否则返回 nil）
 */
-(NSString*) parseStringWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key
{
    NSString *strValue = [jsonDic objectForKey:key];
    if ([self validateStringNode:strValue]) {
        return strValue;
    }
    return nil;
}

/**
 * 解析数字类型 （符合数字类型规则，返回数字类型，否则返回 0.0）
 */
-(double) parseNumberWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key
{
    NSNumber *strValue = [jsonDic objectForKey:key];
    if ([self validateNode:strValue]) {
        return strValue.doubleValue;
    }
    return 0.0;
}

/**
 * 解析日期 （符合日期规则，返回日期，否则返回 nil）
 */
-(NSDate*) parseDateWithJsonDic:(NSDictionary*)jsonDic key:(NSString*)key
{
    NSNumber *strValue = [jsonDic objectForKey:key];
    if ([self validateNode:strValue]) {
        
        if (strValue.doubleValue > 0.0) {
            NSDate * tDate = [NSDate dateWithTimeIntervalSince1970:strValue.doubleValue];
            return tDate;
        }
    }
    
    return nil;
}




@end
