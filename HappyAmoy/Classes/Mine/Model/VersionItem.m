//
//  VersionItem.m
//  HappyAmoy
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "VersionItem.h"

@implementation VersionItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"versionId":@"id"};
}

@end
