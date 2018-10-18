//
//  UserItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserItem : NSObject

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *recommendCode;
@property (copy, nonatomic) NSString *recommendQcodePathUrl;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *headpicUrl;
@property (copy, nonatomic) NSString *recommendUrl;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *aliAccount;
@property (copy, nonatomic) NSString *wechatAccount;
@property (copy, nonatomic) NSString *taobaoAccount;
@property (assign, nonatomic) NSInteger recommendQcodePath;
@property (assign, nonatomic) NSInteger thirdPartyType;
@property (assign, nonatomic) NSInteger recommendId;
@property (assign, nonatomic) NSInteger headpic;
@property (assign, nonatomic) NSInteger recommendPid;
@property (assign, nonatomic) NSInteger enabled;
@property (assign, nonatomic) NSInteger viped;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger gender;
@property (assign, nonatomic) NSInteger recommendFid;

@property (copy, nonatomic) NSString *balanceMoney;


@end
