//
//  LoginUserDefault.m
//  DianDian
//
//  Created by apple on 17/10/11.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "LoginUserDefault.h"
#import "UserItem.h"

@interface LoginUserDefault ()


@end

static LoginUserDefault *_instance = nil;

@implementation LoginUserDefault

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
    
}

+ (instancetype)userDefault {
    
    if (_instance == nil) {
        
        _instance = [[self alloc] init];
        
    }
    
    return _instance;
}

- (void)setDataWithDict:(NSDictionary *)dict {
    
    _userItem = [UserItem mj_objectWithKeyValues:dict];
}

- (NSMutableArray *)shareImageArray {
    if (!_shareImageArray) {
        _shareImageArray = [NSMutableArray array];
    }
    return _shareImageArray;
}


@end
