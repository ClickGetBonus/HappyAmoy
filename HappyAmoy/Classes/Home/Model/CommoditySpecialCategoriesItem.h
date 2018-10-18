//
//  CommoditySpecialCategoriesItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommoditySpecialCategoriesItem : NSObject

@property (copy, nonatomic) NSString *specialCategoriesId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger icon;
@property (assign, nonatomic) NSInteger sort;
@property (assign, nonatomic) NSInteger enabled;

@end
