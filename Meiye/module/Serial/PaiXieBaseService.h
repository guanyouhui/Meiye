//
//  PaiXieBaseService.h
//  PaixieMall
//
//  Created by hi allen on 12-12-11.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RpcBaseService.h"

/**
 * 自定义 service 请求
 */
@interface PaiXieBaseService : RpcBaseService

@property (readonly, nonatomic) NSString *deviceFamily;
@property (readonly, nonatomic) NSString *screenWidth;


- (NSDictionary *)getSignValue:(NSString *)uri param:(NSDictionary *)param;

- (NSString *)deviceFamily;

- (NSString *)screenWidth;

@end
