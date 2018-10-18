//
//  CatchCrash.m
//  XJLFirstProject
//
//  Created by zhangjing on 2017/11/16.
//  Copyright © 2017年 萧峰. All rights reserved.
//

#import "CatchCrash.h"
//#import "common.h"
//#import "HuoShuSDKMgr.h"

// 将unicode文字转换为中文
NSString *changess(NSString *bbb) {
    NSString *temp1 = [bbb stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *temp2 = [temp1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *temp3 = [[@"\"" stringByAppendingString:temp2] stringByAppendingString:@"\""];
    NSData *tempData = [temp3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    //    NSLog(@"lall=-%@",returnStr);
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

// 崩溃时的回调函数
void UncaughtExceptionHandler(NSException * exception) {
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason]; // // 崩溃的原因  可以有崩溃的原因(数组越界,字典nil,调用未知方法...) 崩溃的控制器以及方法
    NSString * name = [exception name];
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:reason forKey:@"reason"];
    [tempDict setObject:name forKey:@"name"];
    [tempDict setObject:arr forKey:@"detail"];
    [tempDict setObject:[NSString getCurrentTimeWithDateFormat:@"yyyy-MM-dd HH:mm"] forKey:@"time"];
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:tempDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString * errorData =  [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];

    //    NSString *errorData = [NSString stringWithFormat:@"name:%@---reason:%@---detail:%@---",name,reason,[arr componentsJoinedByString:@","]];
    NSString *elementErrorStr = @"";
    NSData *data = [NSData dataWithContentsOfFile:CrashMessagePath];
    NSError *err = nil;
    if (data !=nil) {
        NSMutableDictionary *openLogDict = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&err];
        [openLogDict setObject:errorData forKey:[NSString getCurrentTimeWithDateFormat:@"yyyy-MM-dd HH:mm"]];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:openLogDict options:NSJSONWritingPrettyPrinted error:&err];
        elementErrorStr =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        NSMutableDictionary *errorDict = [[NSMutableDictionary alloc]init];
        [errorDict setObject:errorData forKey:[NSString getCurrentTimeWithDateFormat:@"yyyy-MM-dd HH:mm"]];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:errorDict options:NSJSONWritingPrettyPrinted error:&err];
        elementErrorStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    // 将一个txt文件写入沙盒
    [elementErrorStr writeToFile:CrashMessagePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

}

@implementation CatchCrash

+ (void)setDefaultHandler {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

@end

