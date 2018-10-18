//
//  QHCrashManager.m
//  QianHong
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import "QHCrashManager.h"
#import "CatchCrash.h"

static QHCrashManager *_instance = nil;

@implementation QHCrashManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (instancetype)manager {
    
    if (_instance == nil) {
        _instance = [[self alloc] init];
    }
    
    return _instance;
}

// 配置崩溃捕捉
- (void)configureCrash {
    
    // 注册崩溃消息上传
    [CatchCrash setDefaultHandler];

}

// 处理字典参数
- (NSString *)dealWithParam:(NSDictionary *)param
{
    NSArray *allkeys = [param allKeys];

    NSMutableString *result = [NSMutableString string];
    
    for (NSString *key in allkeys) {
        
        NSString *str = [NSString stringWithFormat:@"%@=%@&",key,param[key]];
        
        [result appendString:str];
    }
    return [result substringWithRange:NSMakeRange(0, result.length-1)];
}



@end
