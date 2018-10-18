//
//  NSString+MD5Addition.m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "NSString+MD5Addition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(MD5Addition)

+ (NSString *) stringFromMD5:(NSString *)string{
    
    if(string == nil || [string length] == 0)
        return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return [outputString autorelease];
}

-(NSString *)ruleWithPhone
{
    NSString *phone = @"";
    NSArray *array = [self componentsSeparatedByString:@"/"]; //从字符A中分隔成2个元素的数组
    NSString *pattern = @"[1-9]\\d{10}$"; // 只能输入数字

    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
   
    if ([array count]!=0)
    {
        for (NSString *child in array)
        {
            NSTextCheckingResult *result = [regex firstMatchInString:child options:0 range:NSMakeRange(0, [child length])];
            if (result) {
                phone = [child substringWithRange:result.range];
                NSLog(@"%@\n", [child substringWithRange:result.range]);
            }
        
        }
    }
    if ([phone isEqualToString:@""] || phone == nil)
    {
        phone = self;
    }
    
    return phone;
}

-(BOOL)ruleWithPhoneNumber
{
//    NSString *pattern = @"^1[3578]\\d{9}$"; // 限制只能输入11位的电话号码
    NSString *pattern = @"^[0-9]*$"; // 只能输入数字
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
    // 测试字符串
    NSArray *resultArray = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if ([resultArray count]==0)
    {// 不符合规则
        return YES;
    }
    return NO;
}

//只能输入身份证数字，15或者18位数字
-(BOOL)ruleWithIdCardNumber
{
    NSString *pattern = @"^(\\d{14}|\\d{17})(\\d|[xX])$"; // 只能输入15位或者18位的身份证
    NSRegularExpression *regex = [[NSRegularExpression alloc]initWithPattern:pattern options:0 error:nil];
    // 测试字符串
    NSArray *resultArray = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    if ([resultArray count]==0)
    {// 不符合规则
        return YES;
    }
    return NO;
}

//对一个字符串进行base64编码,并且返回
+ (NSString *)base64EncodeString:(NSString *)string
{
    //1.先转换为二进制数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    //2.对二进制数据进行base64编码,完成之后返回字符串
    return [data base64EncodedStringWithOptions:0];
}

//对base64编码之后的字符串解码,并且返回
+ (NSString *)base64DecodeString:(NSString *)string
{
    //注意:该字符串是base64编码后的字符串
    //1.转换为二进制数据(完成了解码的过程)
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    
    //2.把二进制数据在转换为字符串
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - 判断字符串是否为nil
+ (NSString *)judgeNilString:(NSString *)string {
    
    if ([string isEqualToString:@""] || string == nil || [string isEqualToString:@"(null)"]) {
        return @"";
    }
    return string;
}


@end
