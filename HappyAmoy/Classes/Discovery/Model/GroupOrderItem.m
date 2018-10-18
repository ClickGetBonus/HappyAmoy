//
//  GroupOrderItem.m
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupOrderItem.h"

@implementation GroupOrderItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"orderId":@"id"};
}

@end
