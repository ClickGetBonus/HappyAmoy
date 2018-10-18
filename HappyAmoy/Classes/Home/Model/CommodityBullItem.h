//
//  CommodityBullItem.h
//  HappyAmoy
//
//  Created by lb on 2018/9/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommodityBullItem : NSObject

@property (assign, nonatomic) NSInteger itemId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger group_id;
@property (copy, nonatomic) NSString *imgurl;
@property (copy, nonatomic) NSString *catename;
@property (copy, nonatomic) NSString *sort_des;
@property (copy, nonatomic) NSString *present_price;
@property (copy, nonatomic) NSString *discount_price;
@property (copy, nonatomic) NSNumber *mineCommision;
@end
