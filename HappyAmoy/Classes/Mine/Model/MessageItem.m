//
//  MessageItem.m
//  HappyAmoy
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MessageItem.h"

@implementation MessageItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"noticeId":@"id"};
}

@end
