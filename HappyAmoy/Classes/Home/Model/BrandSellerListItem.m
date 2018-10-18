//
//  BrandSellerListItem.m
//  HappyAmoy
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BrandSellerListItem.h"
#import "CommodityListItem.h"

@implementation BrandSellerListItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"sellerId":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"commodityList":@"CommodityListItem"};
}

@end
