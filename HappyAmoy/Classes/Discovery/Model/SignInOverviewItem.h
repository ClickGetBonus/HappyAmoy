//
//  SignInOverviewItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInOverviewItem : NSObject

@property (copy, nonatomic) NSString *signInId;
@property (copy, nonatomic) NSString *continuousStartDate;
@property (copy, nonatomic) NSString *lastSignDate;
@property (copy, nonatomic) NSString *customerId;
@property (assign, nonatomic) NSInteger continuousDay;
@property (assign, nonatomic) NSInteger socre;

@end
