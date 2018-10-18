//
//  GroupBuyDetailItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerGroupItem.h"

@interface GroupBuyDetailItem : NSObject

@property (copy, nonatomic) NSString *groupId;
@property (strong, nonatomic) CustomerGroupItem *customerGroup;
@property (strong, nonatomic) NSArray *imagesUrls;
@property (copy, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSArray *custList;
@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *labels;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *price;

@property (assign, nonatomic) NSInteger targetNum;
@property (assign, nonatomic) NSInteger groupNum;
@property (assign, nonatomic) NSInteger stock;
@property (assign, nonatomic) NSInteger enabled;
@property (assign, nonatomic) NSInteger canOpen;

@end
