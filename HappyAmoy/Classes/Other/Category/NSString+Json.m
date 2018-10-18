//
//  NSString+Json.m
//  DianDian
//
//  Created by apple on 17/10/12.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "NSString+Json.h"

@implementation NSString (Json)

/**
 数组转换成JSON串字符串（有可读性）
 
 @param array 需要转换的数组
 
 @return JSON字符串
 */
+ (NSString *)arrayToReaderJSONString:(NSArray *)array

{
    NSError *error = nil;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (jsonData == nil) {
        return nil;
    }
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];

    return jsonString;
}
/**
 数组转换成JSON串字符串（没有可读性）

 @param array 需要转换的数组

 @return JSON字符串
 */
+ (NSString *)arrayToJSONString:(NSArray *)array {
    
    NSError *error = nil;

    NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                   options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                     error:&error];
    
    if (data == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
    return string;
}

/**
 把组数转换成json字符串，然后将json字符串进行处理，否则上传到服务器后特殊字符会被过滤，因为包含有特殊字符

 @param array 需要转换的数组

 @return 可以提交给后台的字符串
 */
+ (NSString *)handleJsonStringToBackstage:(NSArray *)array {
    
    NSString *jsonString = [self arrayToJSONString:array];
    
    NSString *baseString=(__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) jsonString, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);

    
    return baseString;
}

@end
