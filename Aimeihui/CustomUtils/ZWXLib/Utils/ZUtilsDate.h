//
//  ZUtilsDate.h
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_SECOND (1)
#define D_MINUTE (60 * D_SECOND)
#define D_HOUR   (60 * D_MINUTE)
#define D_DAY    (24 * D_HOUR)
#define D_MONTH	 (30 * D_DAY)
#define D_YEAR   (12 * D_MONTH)

@interface ZUtilsDate : NSObject
/**
 * 用 NSDate 获取 年、月、日、时、分、秒
 */
+ (void) getYear:(NSInteger*)year
          month:(NSInteger*)month
            day:(NSInteger*)day
           hour:(NSInteger*)hour
         minute:(NSInteger*)minute
         second:(NSInteger*)second
       withDate:(NSDate*)date;

/**
 *  用 NSDate 获取 星期几
 */
+ (NSString*) getWeekWithDate:(NSDate*)date;


/**
 * nsdate to nsstring
 */
+ (NSString*) stringWithFromat:(NSString*)format date:(NSDate*)date;


/**
 * nsdate to nsstring
 */
+ (NSString*) stringWithDate:(NSDate*)date;

/**
 * 获取当前时间string （format:yyyy-MM-dd HH:mm:ss）
 */
+ (NSString *)getCurrentTimeStr;

/**
 * 获取当前日期string （format:yyyy-MM-dd）
 */
+ (NSString *)getCurrentDateStr;

/**
 * 获取当前时间
 */
+ (NSDate *)currentTime;

/**
 * 根据时间戳转日期 (秒)
 */
+ (NSDate *)getTimeFromSeconds:(double)seconds;

/**
 * 根据长时间戳转日期  （毫秒）
 */
+ (NSDate *)getTimeFromLongMilseconds:(double)longMilseconds;


/**
 * 根据描述时间转日期（format:yyyy-MM-dd HH:mm:ss）
 */
+ (NSDate *)getTimeFromDateString:(NSString *)dateString;

/**
 * 根据时区获取当前时间
 */
+ (NSDate *)currentTime:(NSTimeZone *)zone;

/**
 * 根据时区和时间戳获取当前时间 （秒）
 */
+ (NSDate *)getTimeFromSeconds:(double)seconds timeZone:(NSTimeZone *)zone;

/**
 * 根据时区和长时间戳获取当前时间  （毫秒）
 */
+ (NSDate *)getTimeFromLongMilseconds:(double)longMilseconds timeZone:(NSTimeZone *)zone;

/*
 A. 显示的时间是当天
 那么显示消息发布的时间，以“时:分”的格式显示
 B. 显示的时间是昨天
 那么显示消息发布的时间，以“昨天 时:分”的格式显示
 C. 显示的时间是昨天之前，且是当年
 那么显示消息发布的日期，以“月-日”的格式显示
 D. 显示的时间不是当年
 那么显示消息发布的年月日，以“年-月-日”的格式显示
 */
+ (NSString *)timeAgoWithDate:(NSDate *)date;

/* 剩余时间
 
 1. 如剩余时大于或等于1天，那么展示剩余X天，X为实际天数的向下取整，如25小时，那么显示：剩余1天，50小时显示剩余2天
 2. 如剩余时间小于1天且大于或等于1小时，那么展示剩余Y小时，Y为实际小时数的向下取整，如150分种，那么显示：剩余2小时
 3. 如剩余时间小于1小时且大于或等于1分钟，那么展示剩余Z分钟，Z为实际分钟数的向下取整，如150秒，那么显示剩余2分钟。
 4. 如小于60秒，那么显示“即将过期”
 */
+ (NSString *)remainingTimeWithServiceDate:(NSDate *)date endDate:(NSDate *)endDate;

/* 剩余时间
 * 格式：x天x时x分x秒
 */
+ (NSString *)longRemainingTimeWithServiceDate:(NSDate *)date endDate:(NSDate *)endDate;

@end
