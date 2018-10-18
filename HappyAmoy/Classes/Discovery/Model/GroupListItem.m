//
//  GroupListItem.m
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupListItem.h"

@implementation GroupListItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"groupId":@"id"};
}

@end
