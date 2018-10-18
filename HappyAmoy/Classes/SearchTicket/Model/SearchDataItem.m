//
//  SearchDataItem.m
//  HappyAmoy
//
//  Created by lb on 2018/9/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SearchDataItem.h"

@implementation SearchDataItem
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"itemId":@"id"};
}
@end
