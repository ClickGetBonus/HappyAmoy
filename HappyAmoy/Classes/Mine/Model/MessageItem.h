//
//  MessageItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageItem : NSObject

@property (copy, nonatomic) NSString *noticeId;
@property (copy, nonatomic) NSString *role;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *msgId;
@property (copy, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger readed;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger customerId;


@end
