//
//  NSString+Time.m
//  QianHong
//
//  Created by apple on 2018/3/30.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import "NSString+Time.h"

@implementation NSString (Time)

/**
 获取当前时间,默认格式为yyyy-MM-dd
 
 @return 当前时间
 */
+ (NSString *)getCurrentTime {
    return [self getCurrentTimeWithDateFormat:@"yyyy-MM-dd"];
}

/**
 根据指定格式获取当前时间
 
 @return 当前时间
 */
+ (NSString *)getCurrentTimeWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:[NSDate date]];
}

/**
 获取指定日期的星期, 1-星期天 , 2-星期一 , 3-星期二 , 4-星期三 , 5-星期四 , 6-星期五 , 7-星期六 ,
 
 @return 指定日期的星期
 */
+ (NSInteger)getWeekdayFromDateString:(NSString *)dateString {
    
    //    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSDate *inputDate = [NSString dateWithTimeString:dateString];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/SuZhou"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return theComponents.weekday;
}

/**
 给一个时间，给一个数，正数是以后n个月，负数是前n个月；
 
 @param date 时间
 @param month 相距月数
 @return 新的时间
 */
+ (NSString *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month {
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    dateFormater.dateFormat = @"yyyy-MM-dd";
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return [dateFormater stringFromDate:mDate];
}

/**
 比较两个日期的大小
 
 @param firstDate 第一个日期
 @param secondDate 第二个日期
 @return 1、-1、0
 */
+ (int)compareDate:(NSString*)firstDate secondDate:(NSString*)secondDate {
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [df dateFromString:firstDate];
    NSDate *dt2 = [df dateFromString:secondDate];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
        // secondDate 比 firstDate 大
        case NSOrderedAscending: ci = 1; break;
        // secondDate 比 firstDate 小
        case NSOrderedDescending: ci = -1; break;
        // firstDate = secondDate
        case NSOrderedSame: ci = 0; break;
        default: WYLog(@"erorr dates %@, %@", dt2, dt1); break;
    }
    return ci;
}

/**
 根据出生日期计算年龄
 
 @param birthday 出生日期
 */
+ (NSInteger)calculateAge:(NSDate *)birthday {
    // 今天
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:birthday toDate:today options:0];
    //距现在多少年、月、日
    NSInteger age = [components year];
    
    return age;
}

/**
 与当前时间做比较，计算相差多少秒

 @param time 比较的时间
 @return 秒
 */
+ (NSTimeInterval)compareCurrentTime:(NSString *)time
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:wy_dateFormatter];
    NSDate *timeDate = [dateFormatter dateFromString:time];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    
    return timeInterval;
}

/**
 获取当前时间的时间戳,默认是秒级别的时间戳

 @return 时间戳
 */
+ (NSInteger)currentTimestamp {
    return [self currentTimestamp:NO];
}

/**
 获取当前时间的时间戳
 
 @param isMillisecond 是否是毫秒级别的时间戳
 @return 时间戳
 */
+ (NSInteger)currentTimestamp:(BOOL)isMillisecond {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:wy_dateFormatter]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间
    WYLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];
    
    // 当前的时间戳（毫秒）
    WYLog(@"设备当前的时间戳（毫秒）:%ld",(long)timeSp * 1000);

    // 秒级别的时间戳
    return (isMillisecond ? timeSp * 1000 : timeSp);
}

/**
 时间戳转化为格式化字符串时间,默认是毫秒级别的

 @param timeStamp 时间戳
 @return 时间字符串
 */
+ (NSString *)timeWithTimeStamp:(NSString *)timeStamp {
    return [self timeWithTimeStamp:timeStamp isMillisecond:YES];
}

/**
 时间戳转化为格式化字符串时间,默认格式 @"yyyy-MM-dd HH:mm:ss"

 @param timeStamp 时间戳
 @param isMillisecond 是否是毫秒级别的时间戳
 @return 时间字符串
 */
+ (NSString *)timeWithTimeStamp:(NSString *)timeStamp isMillisecond:(BOOL)isMillisecond {
    return [self timeWithTimeStamp:timeStamp isMillisecond:isMillisecond dateFormat:wy_dateFormatter];
}

/**
 时间戳转化为格式化字符串时间

 @param timeStamp 时间戳
 @param isMillisecond 是否是毫秒级别的时间戳
 @param dateFormat 时间格式
 @return 时间字符串
 */
+ (NSString *)timeWithTimeStamp:(NSString *)timeStamp isMillisecond:(BOOL)isMillisecond dateFormat:(NSString *)dateFormat {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateFormat];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue] / (isMillisecond ? 1000.0 : 1.0)];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

/**
 NSDate转为格式化字符串，使用默认格式： yyyy-MM-dd HH:mm:ss

 @param date Date
 @return 时间字符串
 */
+ (NSString *)timeWithDate:(NSDate *)date {
    return [self timeWithDate:date dateFormat:wy_dateFormatter];
}

/**
 NSDate转为对应格式的字符串

 @param date Date
 @param dateFormat 时间格式
 @return 时间字符串
 */
+ (NSString *)timeWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:date];
}

/**
 格式化字符串转为NSDate，默认格式为：yyyy-MM-dd

 @param timeString 格式化字符串
 @return Date
 */
+ (NSDate *)dateWithTimeString:(NSString *)timeString {
    return [self dateWithTimeString:timeString dateFormat:@"yyyy-MM-dd"];
}

/**
 格式化字符串转为NSDate，默认格式为：yyyy-MM-dd

 @param timeString 格式化字符串
 @param dateFormat 日期格式
 @return Date
 */
+ (NSDate *)dateWithTimeString:(NSString *)timeString dateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter dateFromString:timeString];
}



@end
