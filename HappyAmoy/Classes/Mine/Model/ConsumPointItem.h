//
//  ConsumPointItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsumPointItem : NSObject

@property (copy, nonatomic) NSString *pointId;
@property (copy, nonatomic) NSString *customerId;
@property (copy, nonatomic) NSString *describe;
@property (copy, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger type;

@end
