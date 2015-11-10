//
//  ZUtilsNet.h
//  ZUtilsLib
//
//  Created by zhwx on 14-5-25.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZUtilsNet : NSObject


/**
 * 获取本机的 外网IP  http://ip.3322.org/
 */
+(NSString*) getPublicNetworkIp;

/**
 * 获取本机的 外网IP  http://www.ip.cn/
 */
+(NSString*) getPublicNetworkIp2;

/**
 * 获取本机的 外网IP http://www.ip38.com/
 */
+(NSString*) getPublicNetworkIp3;


/**
 * 获取本机的内网IP
 */
+ (NSString *)getIPAddressWithIsIp4:(BOOL)isIPv4;

/**
 * 获取本机的内网IP
 */
+ (NSDictionary *)getIPAddresses;


/**
 * 获取一个自动增长的 unsigned short
 */
+(unsigned short) getAddShortValue;

/**
 * 测试是否是 大端 在前
 */
+(BOOL) isBitEndianTest;

/**
 * 交换 short 高低字节序
 */
+(short) swap16WithShort:(short)value;

/**
 * 交换 int 高低字节序
 */
+(int) swap32WithInt:(int)value;

/**
 * 交换 long long 高低字节序
 */
+(long long) swap64WithLongLong:(long long)value;


/**
 * 是否显示 加载网络(系统)
 */
+(void) showNetWorkIcon:(bool)bShow;


@end
