//
//  ZUtilsApplication.m
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import "ZUtilsApplication.h"

@implementation ZUtilsApplication

/**
 * 获取App显示名称
 */
+ (NSString *)appDisplayName
{
    //app应用相关信息的获取
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppName = [dicInfo objectForKey:@"CFBundleDisplayName"];
    return strAppName;
}

/**
 * 获取App主版本号
 */
+ (NSString *)appMajorVersion
{
    //app应用相关信息的获取
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppBuild = [dicInfo objectForKey:@"CFBundleShortVersionString"];
    return strAppBuild;
}

/**
 * 获取App次版本号
 */
+ (NSString *)appMinorVersion
{
    //app应用相关信息的获取
    NSDictionary *dicInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppVersion = [dicInfo objectForKey:@"CFBundleVersion"];
    return strAppVersion;
}

/**
 *	获取当前Application的keyWindow
 */
+ (UIWindow *)appWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    return window;
}


@end
