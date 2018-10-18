//
//  NSString+MD5Addition.h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(MD5Addition)

// MD5加密
+ (NSString *) stringFromMD5:(NSString *)string;

-(BOOL)ruleWithPhoneNumber; // 规定只能数字

-(NSString *)ruleWithPhone; // 获取需要的数字

-(BOOL)ruleWithIdCardNumber; // 只能输入身份证数字，15或者18位数字

//对一个字符串进行base64编码,并且返回
+(NSString *)base64EncodeString:(NSString *)string;

//对base64编码之后的字符串解码,并且返回
+(NSString *)base64DecodeString:(NSString *)string;

/**   判断字符串是否为nil   */
+ (NSString *)judgeNilString:(NSString *)string;

@end
