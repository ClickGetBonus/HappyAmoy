//
//  LoginUtil.m
//  HappyAmoy
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LoginUtil.h"
#import "LoginViewController.h"

@implementation LoginUtil

/**
 判断是否已经登录，默认登录后不回调
 
 @param fatherVc 父控制器
 @param completedHandler 登录的回调
 */
+ (void)loginWithFatherVc:(UIViewController *)fatherVc completedHandler:(void(^)(void))completedHandler {
    [self loginWithFatherVc:fatherVc shouldCallBackAfterLogin:NO completedHandler:completedHandler];
}

/**
 判断是否已经登录
 
 @param fatherVc 父控制器
 @param shouldCallBackAfterLogin 登录后是否需要回调
 @param completedHandler 登录的回调
 */
+ (void)loginWithFatherVc:(UIViewController *)fatherVc shouldCallBackAfterLogin:(BOOL)shouldCallBackAfterLogin completedHandler:(void(^)(void))completedHandler {
    if ([LoginUserDefault userDefault].isTouristsMode) { // 游客模式需要登录
        LoginViewController *loginVc = [[LoginViewController alloc] init];
        if (shouldCallBackAfterLogin) {
            loginVc.loginCallBack = ^{
                if (completedHandler) {
                    completedHandler();
                }
            };
        }
        [LoginUserDefault userDefault].isLoginVc = YES;
        [fatherVc.navigationController pushViewController:loginVc animated:YES];
    } else {
        if (completedHandler) {
            completedHandler();
        }
    }
}


@end
