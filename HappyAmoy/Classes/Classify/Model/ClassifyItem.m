//
//  ClassifyItem.m
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ClassifyItem.h"

@implementation ClassifyItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"classifyId":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"hotCategories": @"ClassifyItem",@"subCategories": @"ClassifyItem"};
}


@end
