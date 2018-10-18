//
//  QHCheckVersion.h
//  QianHong
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHCheckVersion : NSObject

/**
 检查是否有新版本，返回根控制器

 @param launchOptions app信息
 @return 根控制器
 */
+ (UIViewController *)checkVersionWithOptions:(NSDictionary *)launchOptions;

@end
