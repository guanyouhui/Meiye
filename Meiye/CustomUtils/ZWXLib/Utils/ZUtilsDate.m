//
//  ZUtilsDate.m
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import "ZUtilsDate.h"


@implementation ZUtilsDate
/**
 * 用 NSDate 获取 年、月、日、时、分、秒
 */
+(void) getYear:(NSInteger*)year
          month:(NSInteger*)month
            day:(NSInteger*)day
           hour:(NSInteger*)hour
         minute:(NSInteger*)minute
         second:(NSInteger*)second
       withDate:(NSDate*)date
{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents* comps = [gregorian components:unitFlags fromDate:date];
    
    *year = [comps year];
    *month = [comps month];
    *day = [comps day];
    *hour = [comps hour];
    *minute = [comps minute];
    *second = [comps second];
    
}

/**
 *  用 NSDate 获取 星期几
 */
+(NSString*) getWeekWithDate:(NSDate*)date
{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents* comps = [gregorian components:unitFlags fromDate:date];
    
    NSInteger weekIndex = [comps weekday];
    
    NSString* weekStr = nil;
    
    switch (weekIndex) {
        case 1:
            weekStr = @"星期日";
            break;
        case 2:
            weekStr = @"星期一";
            break;
        case 3:
            weekStr = @"星期二";
            break;
        case 4:
            weekStr = @"星期三";
            break;
        case 5:
            weekStr = @"星期四";
            break;
        case 6:
            weekStr = @"星期五";
            break;
        case 7:
            weekStr = @"星期六";
            break;
            
        default:
            weekStr = nil;
            break;
    }
    return weekStr;
}


/**
 * nsdate to nsstring
 */
+(NSString*) stringWithFromat:(NSString *)format date:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}


+ (NSDate *)currentTime
{
    NSDate *currentDate = [NSDate date];
    return currentDate;
}


/**
 * 获取当前时间string （format:yyyy-MM-dd HH:mm:ss）
 */
+ (NSString *)getCurrentTimeStr{
    NSDate *  timeDate=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:timeDate];
}

/**
 * 获取当前日期string （format:yyyy-MM-dd）
 */

+ (NSString *)getCurrentDateStr{
    NSDate *  timeDate=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:timeDate];
}

/**
 * 根据时间戳转日期
 */
+ (NSDate *)getTimeFromSeconds:(double)seconds
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:seconds];
    return confromTimesp;
}

+ (NSDate *)getTimeFromLongMilseconds:(double)longMilseconds
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:longMilseconds/1000];
    return confromTimesp;
}

/**
 * 根据描述时间转日期（format:yyyy-MM-dd HH:mm:ss）
 */
+ (NSDate *)getTimeFromDateString:(NSString *)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter dateFromString:dateString];
}


+ (NSDate *)currentTime:(NSTimeZone *)zone
{
    NSDate *date = [NSDate date];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}

/**
 * 根据时区和时间戳获取当前时间
 */
+ (NSDate *)getTimeFromSeconds:(double)seconds timeZone:(NSTimeZone *)zone
{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
    
    NSDate *newDate = [confromTimesp dateByAddingTimeInterval:interval];
    
    return newDate;
}

/**
 * 根据时区和长时间戳获取当前时间  （毫秒）
 */
+ (NSDate *)getTimeFromLongMilseconds:(double)longMilseconds timeZone:(NSTimeZone *)zone
{
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:longMilseconds/1000];
    //    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
    //    confromTimesp = [confromTimesp dateByAddingTimeInterval:interval];
    
    return confromTimesp;
}

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
+ (NSString *)timeAgoWithDate:(NSDate *)date
{
    NSDate* nowDate = [NSDate date];
    
    //计算今天的起点时间
    NSDate* startTodayDate = [self getTimeFromDateString:[self stringWithFromat:@"yyyy-MM-dd 00:00:00" date:nowDate]];
    
    //计算昨天的起点时间
    NSDate* yesterday = [NSDate dateWithTimeInterval:(-24*60*60.0) sinceDate:nowDate];
    NSDate* startYesterdayDate = [self getTimeFromDateString:[self stringWithFromat:@"yyyy-MM-dd 00:00:00" date:yesterday]];
    
    //计算今年的起点时间
    NSDate* startThisYearDate = [self getTimeFromDateString:[self stringWithFromat:@"yyyy-01-01 00:00:00" date:nowDate]];
    
    //计算 【date 和 今天、昨天、今年的起点】 时间间隔
    NSTimeInterval todayDistanceValue = [date timeIntervalSinceDate:startTodayDate];
    NSTimeInterval yesterdayDistanceValue = [date timeIntervalSinceDate:startYesterdayDate];
    NSTimeInterval thisYearDistanceValue = [date timeIntervalSinceDate:startThisYearDate];
    
    if (todayDistanceValue >= 0) {
        return [ZUtilsDate stringWithFromat:@"HH:mm" date:date];
    }else if (yesterdayDistanceValue >= 0){
        return [NSString stringWithFormat:@"昨天 %@",[ZUtilsDate stringWithFromat:@"HH:mm" date:date]];
    }else if (thisYearDistanceValue >= 0){
        return [ZUtilsDate stringWithFromat:@"MM-dd" date:date];
    }else{
        return [ZUtilsDate stringWithFromat:@"yyyy-MM-dd" date:date];
    }
    
}


/* 剩余时间
 
 1. 如剩余时大于或等于1天，那么展示剩余X天，X为实际天数的向下取整，如25小时，那么显示：剩余1天，50小时显示剩余2天
 2. 如剩余时间小于1天且大于或等于1小时，那么展示剩余Y小时，Y为实际小时数的向下取整，如150分种，那么显示：剩余2小时
 3. 如剩余时间小于1小时且大于或等于1分钟，那么展示剩余Z分钟，Z为实际分钟数的向下取整，如150秒，那么显示剩余2分钟。
 4. 如小于60秒，那么显示“即将过期”
 */
+ (NSString *)remainingTimeWithServiceDate:(NSDate *)date endDate:(NSDate *)endDate{
    
    if (!date || !endDate)
        return nil;

    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算2个时间的差值
    NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:date toDate:endDate options:0];

    if (dateComponents.day > 0) {
        
        return FORMAT(@"剩余%ld天",dateComponents.day);
        
    }else if (dateComponents.hour > 0){
        
        return FORMAT(@"剩余%ld小时",dateComponents.hour);
        
    }else if (dateComponents.minute > 0){
        
        return FORMAT(@"剩余%ld分钟",dateComponents.minute);
        
    }else if (dateComponents.second > 0){
        
        return @"即将过期";
        
    }
    else {
        return nil;
    }
    
    
//    NSTimeInterval distanceValue = [endDate timeIntervalSinceDate:date];
//    if (distanceValue >= D_DAY) {
//        
//        int dayCount = distanceValue / D_DAY;
//        return FORMAT(@"剩余%d天",dayCount);
//        
//    }else if (distanceValue >= D_HOUR){
//        
//        int hourCount = distanceValue / D_HOUR;
//        return FORMAT(@"剩余%d小时",hourCount);
//        
//    }else if (distanceValue >= D_MINUTE){
//        
//        int minuteCount = distanceValue / D_MINUTE;
//        return FORMAT(@"剩余%d分钟",minuteCount);
//        
//    }else if (distanceValue > 0){
//        
//        return @"即将过期";
//        
//    }
//    else {
//        return nil;
//    }
}

/* 剩余时间
 * 格式：x天x时x分x秒
 */
+ (NSString *)longRemainingTimeWithServiceDate:(NSDate *)date endDate:(NSDate *)endDate{

    if (!date || !endDate || [date timeIntervalSince1970]==0 || [endDate timeIntervalSince1970]==0)
        return nil;
    
    NSMutableString * remainingStr = [NSMutableString string];
    
    
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    //计算2个时间的差值
    NSDateComponents *dateComponents = [gregorian components:unitFlags fromDate:date toDate:endDate options:0];

    if (dateComponents.day>0) {
        [remainingStr appendFormat:@"%ld天",dateComponents.day];
    }
    if (dateComponents.hour>0) {
        [remainingStr appendFormat:@"%ld时",dateComponents.hour];
    }
    if (dateComponents.minute>0) {
        [remainingStr appendFormat:@"%ld分",dateComponents.minute];
    }
    if (dateComponents.second>0) {
        [remainingStr appendFormat:@"%ld秒",dateComponents.second];
    }
    return remainingStr;
}

@end
