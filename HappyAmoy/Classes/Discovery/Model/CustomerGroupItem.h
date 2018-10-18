//
//  CustomerGroupItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerGroupItem : NSObject

@property (copy, nonatomic) NSString *groupBuyId;
@property (copy, nonatomic) NSString *delivered;
@property (assign, nonatomic) NSInteger targetNum;
@property (assign, nonatomic) NSInteger residueSecond;
@property (copy, nonatomic) NSString *statusDesc;
@property (assign, nonatomic) NSInteger inviteNum;
@property (copy, nonatomic) NSString *customerId;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *endTime;
@property (copy, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSArray *custList;
@property (assign, nonatomic) NSInteger status; //状态 0-初始 1-完成 2-失败 3-取消

@end
