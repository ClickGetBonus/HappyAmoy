//
//  SignInListItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInListItem : NSObject

@property (copy, nonatomic) NSString *signInId;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *customerId;
@property (assign, nonatomic) NSInteger socre;

@end
