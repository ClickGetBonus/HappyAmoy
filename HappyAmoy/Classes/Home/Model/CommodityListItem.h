//
//  CommodityListItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommodityListItem : NSObject

@property (copy, nonatomic) NSString *itemId;
@property (copy, nonatomic) NSString *currentId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *videoUrl;
@property (assign, nonatomic) CGFloat mineCommision;
@property (assign, nonatomic) CGFloat price;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) CGFloat iscountPrice;
@property (assign, nonatomic) NSInteger sellNum;
@property (copy, nonatomic) NSString *couponAmount;
@property (assign, nonatomic) CGFloat discountPrice;
@property (copy, nonatomic) NSString *categoryId;

@end
