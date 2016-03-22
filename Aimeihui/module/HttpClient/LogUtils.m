//
//  LogUtils.m
//  PaixieMall
//
//  Created by xhs on 14-12-4.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "LogUtils.h"

    
static BOOL isEnabled = YES;
@implementation LogUtils

/**
 * Log的Enable值
 */
+ (BOOL)isLogEnabled
{
    return isEnabled;
}

/**
 * 设置Log能否打印 
 */
+ (void)setLogEnabled:(BOOL)enabled
{
    isEnabled = enabled;
}

/**
 * 设置标记LOG输出
 */
+ (void)log:(NSString *)tag message:(NSString *)msg
{
    if (isEnabled) {
        NSLog(@"LogTag:%@ ------ LogMsg:\n%@",tag,msg);
    }
}
@end
