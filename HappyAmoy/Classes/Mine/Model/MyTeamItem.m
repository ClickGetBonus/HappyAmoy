//
//  MyTeamItem.m
//  HappyAmoy
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyTeamItem.h"

@implementation MyTeamItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"teamId":@"id"};
}

@end
