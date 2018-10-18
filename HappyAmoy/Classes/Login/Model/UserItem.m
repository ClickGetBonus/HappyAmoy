//
//  UserItem.m
//  HappyAmoy
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"userId":@"id"};
}

@end
