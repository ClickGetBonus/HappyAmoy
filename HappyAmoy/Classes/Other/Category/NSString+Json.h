//
//  NSString+Json.h
//  DianDian
//
//  Created by apple on 17/10/12.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

/**
 数组转换成JSON串字符串（有可读性）
 
 @param array 需要转换的数组
 
 @return JSON字符串
 */
+ (NSString *)arrayToReaderJSONString:(NSArray *)array;
/**
 数组转换成JSON串字符串（没有可读性）
 
 @param array 需要转换的数组
 
 @return JSON字符串
 */
+ (NSString *)arrayToJSONString:(NSArray *)array;

/**
 把组数装换成json字符串，然后将json字符串进行处理，否则上传到服务器后特殊字符会被过滤，因为包含有特殊字符
 
 @param array 需要转换的数组
 
 @return 可以提交给后台的字符串
 */
+ (NSString *)handleJsonStringToBackstage:(NSArray *)array;


@end
