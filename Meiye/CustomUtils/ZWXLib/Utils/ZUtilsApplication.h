//
//  ZUtilsApplication.h
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZUtilsApplication : NSObject

/**
 * 获取App显示名称
 */
+ (NSString *)appDisplayName;

/**
 * 获取App主版本号(2.1.0)
 */
+ (NSString *)appMajorVersion;

/**
 * 获取App次版本号 (2015020201)
 */
+ (NSString *)appMinorVersion;

/**
 *	获取当前Application的keyWindow
 */
+ (UIWindow *)appWindow;

@end
