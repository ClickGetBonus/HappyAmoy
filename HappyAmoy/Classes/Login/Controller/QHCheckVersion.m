//
//  QHCheckVersion.m
//  QianHong
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import "QHCheckVersion.h"
#import "LoginViewController.h"
#import "WYLaunchViewController.h"
#import "QHNewFetureController.h"
#import "WYTabBarController.h"
#import "JPUSHService.h"

@implementation QHCheckVersion

/**
 检查是否有新版本，返回根控制器
 
 @param launchOptions app信息
 @return 根控制器
 */
+ (UIViewController *)checkVersionWithOptions:(NSDictionary *)launchOptions {
    
    if ([self isNewVersion]) { // 第一次打开新版本显示新特性界面
        return [[QHNewFetureController alloc] init];
//        return [[WYTabBarController alloc] init];
    }
    if (launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) { // 点击远程推送打开的界面
        if (![NSString isEmpty:[[WYUserDefaultManager shareManager] userAccountNumber]] && ![NSString isEmpty:[[WYUserDefaultManager shareManager] userPassword]]) { // 有登录记录的直接登录
            
            [self directLogin:0];
            
        } else { // 显示主页
            return [[WYLaunchViewController alloc] init];

//            return [[WYTabBarController alloc] init];
        }
        // 占位控制器，应该显示一张启动图，这样可以有时间来登录获取数据，登录后显示主视图
        return [[WYLaunchViewController alloc] init];
    } else {
        if (![NSString isEmpty:[[WYUserDefaultManager shareManager] userAccountNumber]] && ![NSString isEmpty:[[WYUserDefaultManager shareManager] userPassword]]) { // 有登录记录的直接登录

            [self directLogin:0];

        } else { // 显示登录界面
//            return [[QHNewFetureController alloc] init];
            return [[WYLaunchViewController alloc] init];

//            return [[WYTabBarController alloc] init];
        }
        // 占位控制器，应该显示一张启动图，这样可以有时间来登录获取数据，登录后显示主视图
        return [[WYLaunchViewController alloc] init];
    }
}

// 远程推送直接登录
+ (void)directLogin:(NSInteger)controllerIndex {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mobile"] = [WYUserDefaultManager shareManager].userAccountNumber;
    parameters[@"password"] = [WYUserDefaultManager shareManager].userPassword;
    parameters[@"mobileCode"] = [NSString excludeEmptyQuestion:[[WYUserDefaultManager shareManager] registrationID]];
    WeakSelf
    [[NetworkSingleton sharedManager] postRequestWithUrl:@"/auth/login" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [LoginUserDefault userDefault].userItem = [UserItem mj_objectWithKeyValues:response[@"data"]];
            // 会员模式
            [LoginUserDefault userDefault].isTouristsMode = NO;
            [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;
            [weakSelf cacheRecommendQcode];
            // 设置推送别名
            [weakSelf setPushTag];
//            WYTabBarController *tabBarVc = [[WYTabBarController alloc] init];
//            [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];

}

// 显示登录界面,因为改为游客模式，所以直接跳到首页，不跳到登录页面强制登录了
+ (void)showLoginVc {
    
    [UIApplication sharedApplication].keyWindow.rootViewController = [[WYTabBarController alloc] init];
}

// 判断是否是新版本
+ (BOOL)isNewVersion {
    // 获取上一次打开APP的时候的版本
    NSString *lastTimeOpenVersion = [[WYUserDefaultManager shareManager] lastTimeOpenVersion];
    // 将上一次的版本与当前版本做比较
    if ([lastTimeOpenVersion isEqualToString:APP_VERSION]) {
        [LoginUserDefault userDefault].isShowPopupOfHome = NO;
        // 不是新版本
        return NO;
    } else {
        // 新版本，需要显示弹框
        [LoginUserDefault userDefault].isShowPopupOfHome = YES;
        // 新版本，需要显示新特性界面
        // 存储当前版本
        [[WYUserDefaultManager shareManager] saveLastTimeOpenVersion:APP_VERSION];
        
        return YES;
    }
}

// 缓存推荐二维码
+ (void)cacheRecommendQcode {
    UIImageView *qCodeImageView = [[UIImageView alloc] init];
    [qCodeImageView wy_setImageWithUrlString:[LoginUserDefault userDefault].userItem.recommendQcodePathUrl placeholderImage:PlaceHolderMainImage];
}

// 设置推送别名
+ (void)setPushTag {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [JPUSHService setTags:[NSSet setWithObjects:[LoginUserDefault userDefault].userItem.userId, nil] completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//            if (iResCode == 0) {
//                WYLog(@"设置tag成功 , seq = %zd",seq);
//            }
//        } seq:0];
        
        [JPUSHService setAlias:[LoginUserDefault userDefault].userItem.userId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            if (iResCode == 0) {
                WYLog(@"设置别名成功 , iAlias = %@ , seq = %zd",iAlias,seq);
            }
        } seq:0];
    });
    
}

@end
