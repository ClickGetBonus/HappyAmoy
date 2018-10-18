//
//  GroupOrderItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupOrderItem : NSObject

@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) NSString *groupName;
@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *createTime;
// 状态 0-初始 1-完成 2-失败 3-取消
@property (assign, nonatomic) NSInteger status;

@end
