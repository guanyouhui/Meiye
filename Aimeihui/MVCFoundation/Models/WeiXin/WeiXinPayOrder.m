//
//  WeiXinPayOrder.m
//  PaixieMall
//
//  Created by zhwx on 14-7-31.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "WeiXinPayOrder.h"
#import "OpenUDID.h"

@implementation WeiXinPayOrder


-(id) init
{
    if (self = [super init]) {
        
        self.o_appid = WX_PAY_APP_ID;
        self.o_appkey = WX_APP_KEY;
        self.o_partnerid = WX_APP_PARTNER_ID;
        self.o_traceid = @"crestxu_1406949344"; //可 空
        self.o_noncestr = FORMAT(@"%d",(int)[[NSDate date] timeIntervalSince1970]);
        self.o_package = @"Sign=WXPay";
        self.o_timestamp = [[NSDate date] timeIntervalSince1970];
        self.o_app_signature = nil;
        self.o_sign_method = @"sha1";
        
    }
    return self;
}


-(NSData*) serializeWithObject:(WeiXinPayOrder *)object
{
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    [dic setValue:self.o_appid forKey:@"appid"];
    [dic setValue:self.o_appkey forKey:@"appkey"];
    [dic setValue:self.o_traceid forKey:@"traceid"];
    [dic setValue:self.o_noncestr forKey:@"noncestr"];
    [dic setValue:self.o_package forKey:@"package"];
    [dic setValue:FORMAT(@"%d",self.o_timestamp) forKey:@"timestamp"];
    [dic setValue:self.o_app_signature forKey:@"app_signature"];
    [dic setValue:self.o_sign_method forKey:@"sign_method"];
    
    
    
    
    
    
    
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    return jsonData;
}

@end
