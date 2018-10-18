//
//  LoginUtil.h
//  HappyAmoy
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginUtil : NSObject

/**
 判断是否已经登录，默认登录后不回调

 @param fatherVc 父控制器
 @param completedHandler 登录的回调
 */
+ (void)loginWithFatherVc:(UIViewController *)fatherVc completedHandler:(void(^)(void))completedHandler;

/**
 判断是否已经登录
 
 @param fatherVc 父控制器
 @param shouldCallBackAfterLogin 登录后是否需要回调
 @param completedHandler 登录的回调
 */
+ (void)loginWithFatherVc:(UIViewController *)fatherVc shouldCallBackAfterLogin:(BOOL)shouldCallBackAfterLogin completedHandler:(void(^)(void))completedHandler;

@end
