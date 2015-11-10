//
//  LogUtils.h
//  PaixieMall
//
//  Created by xhs on 14-12-4.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogUtils : NSObject

/**
 * Log的Enable值
 */
+ (BOOL)isLogEnabled;

/**
 * 设置Log能否打印 默认NO
 */
+ (void)setLogEnabled:(BOOL)enabled;

/**
 * 设置标记LOG输出
 */
+ (void)log:(NSString *)tag message:(NSString *)msg;

@end
