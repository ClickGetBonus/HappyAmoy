//
//  GroupListItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupListItem : NSObject

@property (copy, nonatomic) NSString *groupId;
@property (copy, nonatomic) NSString *labels;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *createTime;
@property (strong, nonatomic) NSArray *custList;
@property (copy, nonatomic) NSString *iconUrl;
@property (strong, nonatomic) NSArray *imagesUrls;
@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSInteger targetNum;
@property (assign, nonatomic) NSInteger groupNum;
@property (assign, nonatomic) NSInteger stock;
@property (assign, nonatomic) NSInteger enabled;


@end
