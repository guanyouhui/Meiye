//
//  Entity.h
//  PaixieMall
//
//  Created by zhwx on 14/12/9.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Module 统一数据类的 基类，便于有可能需求需要统一管理
 */
@interface Entity : NSObject

@property (copy, nonatomic) NSString *entityId;

- (id)initWithId:(NSString *)entityId;

@end
