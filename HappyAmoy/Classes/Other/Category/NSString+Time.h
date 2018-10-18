//
//  NSString+Time.h
//  QianHong
//
//  Created by apple on 2018/3/30.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Time)

/**
 获取当前时间,默认格式为yyyy-MM-dd
 
 @return 当前时间
 */
+ (NSString *)getCurrentTime;

/**
 根据指定格式获取当前时间
 
 @return 当前时间
 */
+ (NSString *)getCurrentTimeWithDateFormat:(NSString *)dateFormat;

/**
 获取指定日期的星期, 1-星期天 , 2-星期一 , 3-星期二 , 4-星期三 , 5-星期四 , 6-星期五 , 7-星期六 ,
 
 @return 指定日期的星期
 */
+ (NSInteger)getWeekdayFromDateString:(NSString *)dateString;

/**
 给一个时间，给一个数，正数是以后n个月，负数是前n个月；
 
 @param date 时间
 @param month 相距月数
 @return 新的时间
 */
+ (NSString *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;

/**
 比较两个日期的大小
 
 @param firstDate 第一个日期
 @param secondDate 第二个日期
 @return 1、-1、0
 */
+ (int)compareDate:(NSString*)firstDate secondDate:(NSString*)secondDate;

/**
 根据出生日期计算年龄
 
 @param birthday 出生日期
 */
+ (NSInteger)calculateAge:(NSDate *)birthday;

/**
 与当前时间做比较，计算相差多少秒
 
 @param time 比较的时间
 @return 秒
 */
+ (NSTimeInterval)compareCurrentTime:(NSString *)time;

/**
 获取当前时间的时间戳,默认是秒级别的时间戳
 
 @return 时间戳
 */
+ (NSInteger)currentTimestamp;

/**
 获取当前时间的时间戳
 
 @param isMillisecond 是否是毫秒级别的时间戳
 @return 时间戳
 */
+ (NSInteger)currentTimestamp:(BOOL)isMillisecond;

/**
 时间戳转化为格式化字符串时间,默认是毫秒级别的
 
 @param timeStamp 时间戳
 @return 时间字符串
 */
+ (NSString *)timeWithTimeStamp:(NSString *)timeStamp;

/**
 时间戳转化为格式化字符串时间,默认格式 @"yyyy-MM-dd HH:mm:ss"
 
 @param timeStamp 时间戳
 @param isMillisecond 是否是毫秒级别的时间戳
 @return 时间字符串
 */
+ (NSString *)timeWithTimeStamp:(NSString *)timeStamp isMillisecond:(BOOL)isMillisecond;

/**
 时间戳转化为格式化字符串时间
 
 @param timeStamp 时间戳
 @param isMillisecond 是否是毫秒级别的时间戳
 @param dateFormat 时间格式
 @return 时间字符串
 */
+ (NSString *)timeWithTimeStamp:(NSString *)timeStamp isMillisecond:(BOOL)isMillisecond dateFormat:(NSString *)dateFormat;

/**
 NSDate转为格式化字符串，使用默认格式： yyyy-MM-dd HH:mm:ss
 
 @param date Date
 @return 时间字符串
 */
+ (NSString *)timeWithDate:(NSDate *)date;

/**
 NSDate转为对应格式的字符串
 
 @param date Date
 @param dateFormat 时间格式
 @return 时间字符串
 */
+ (NSString *)timeWithDate:(NSDate *)date dateFormat:(NSString *)dateFormat;

/**
 格式化字符串转为NSDate，默认格式为：yyyy-MM-dd
 
 @param timeString 格式化字符串
 @return Date
 */
+ (NSDate *)dateWithTimeString:(NSString *)timeString;

/**
 格式化字符串转为NSDate，默认格式为：yyyy-MM-dd
 
 @param timeString 格式化字符串
 @param dateFormat 日期格式
 @return Date
 */
+ (NSDate *)dateWithTimeString:(NSString *)timeString dateFormat:(NSString *)dateFormat;
@end
