//
//  ZUtilsDevice.h
//  PaixieMall
//
//  Created by zhwx on 15/1/7.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZUtilsDevice : NSObject

/**
 * 是否为Retina屏幕
 */
+ (BOOL)isRetina;

/**
 * 是否为3.5吋Retina屏幕
 */
+ (BOOL)isRetina3Inch;

/**
 * 是否为4吋Retina屏幕
 */
+ (BOOL)isRetina4Inch;

/**
 * 获得设备操作系统版本
 */
+ (CGFloat)deviceSystemVersion;

/**
 * 获得设备类型 @"iPhone", @"iPod touch" 等
 *//**
    * 获得设备类型
    */
+ (NSString *)deviceModel;

/**
 * 获得设备型号 @"iPhone6.1", @"iPhone7.1" 等
 */
- (NSString*)deviceMachine;

/**
 * 获得设备当前连接到的WIFI SSID （SSID全称Service Set IDentifier, 即Wifi网络的公开名称）
 */
+ (NSString *)fetchCurrentSSID;

@end
