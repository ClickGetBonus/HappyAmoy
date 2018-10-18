//
//  CommodityDetailItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommodityDetailItem : NSObject

@property (copy, nonatomic) NSString *commodityId;
@property (copy, nonatomic) NSString *itemId;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *couponStartDate;
@property (copy, nonatomic) NSString *couponUrl;
@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *couponEndDate;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *taoToken;
@property (strong, nonatomic) NSArray *imageUrls;
@property (assign, nonatomic) NSInteger module;
@property (assign, nonatomic) NSInteger freeShip;
@property (assign, nonatomic) NSInteger needBuyed;
@property (assign, nonatomic) NSInteger sellNum;
@property (assign, nonatomic) NSInteger brandSellerId;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger todayRecommended;
@property (assign, nonatomic) NSInteger categoryId;
@property (assign, nonatomic) NSInteger collected;
@property (copy, nonatomic) NSString *couponAmount;
@property (assign, nonatomic) CGFloat discountPrice;
@property (assign, nonatomic) CGFloat price;
@property (copy, nonatomic) NSString *mineCommision;


@end
