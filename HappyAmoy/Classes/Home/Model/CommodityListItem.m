//
//  CommodityListItem.m
//  HappyAmoy
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CommodityListItem.h"

@implementation CommodityListItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"listId":@"id"};
}

@end
