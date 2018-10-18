//
//  MemberRewardItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberRewardItem : NSObject

@property (copy, nonatomic) NSString *rewardId;
@property (copy, nonatomic) NSString *customerId;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSString *createTime;
@property (assign, nonatomic) CGFloat money;

@end
