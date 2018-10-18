//
//  AddressItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressItem : NSObject

@property (copy, nonatomic) NSString *addressId;
@property (copy, nonatomic) NSString *customerId;
@property (copy, nonatomic) NSString *deliveryName;
@property (copy, nonatomic) NSString *deliveryMobile;
@property (copy, nonatomic) NSString *provinceId;
@property (copy, nonatomic) NSString *provinceName;
@property (copy, nonatomic) NSString *cityId;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *areaId;
@property (copy, nonatomic) NSString *areaName;
@property (copy, nonatomic) NSString *address;

+ (instancetype)emptyItem;

@end
