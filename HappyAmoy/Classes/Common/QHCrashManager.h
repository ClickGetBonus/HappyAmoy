//
//  QHCrashManager.h
//  QianHong
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QHCrashManager : NSObject

/**
 *  @brief  单例
 */
+ (instancetype)manager;

/**
 *  @brief  配置信息
 */
- (void)configureCrash;

@end
