//
//  AddressItem.m
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddressItem.h"

@implementation AddressItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"addressId":@"id"};
}

+ (instancetype)emptyItem {
    AddressItem *item = [[AddressItem alloc] init];
    item.addressId = @"";
    item.customerId = @"";
    item.deliveryName = @"";
    item.deliveryMobile = @"";
    item.provinceId = @"";
    item.provinceName = @"";
    item.cityId = @"";
    item.cityName = @"";
    item.areaId = @"";
    item.areaName = @"";
    item.address = @"";
    return item;
}

@end
