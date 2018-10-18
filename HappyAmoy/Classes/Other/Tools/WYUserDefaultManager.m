//
//  WYUserDefaultManager.m
//  DianDian
//
//  Created by apple on 17/11/7.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "WYUserDefaultManager.h"

@interface WYUserDefaultManager ()

@end

static WYUserDefaultManager *_instance = nil;

/**     用户登录账号    */
static NSString *keyForUserAccountNumber = @"keyForUserAccountNumber";
/**     用户登录密码（未加密的密码）    */
static NSString *keyForUserPassword = @"keyForUserPassword";
/**     用户登录密码（加密后的密码）    */
static NSString *keyForUserPasswordOfSecret = @"keyForUserPasswordOfSecret";
/**     极光推送设备号    */
static NSString *keyForRegistrationID = @"keyForRegistrationID";

/**     用户上一次打开APP的版本    */
static NSString *keyForLastTimeOpenVersion = @"keyForLastTimeOpenVersion";

/**     是否第一次设置消息通知设置    */
static NSString *keyForFirstMessageNoticeSetting = @"keyForFirstMessageNoticeSetting";
/**     接收新消息通知设置    */
static NSString *keyForReceiveMessageNoticeSetting = @"keyForReceiveMessageNoticeSetting";
/**     消息通知声音设置    */
static NSString *keyForMessageNoticeSoundSetting = @"keyForMessageNoticeSoundSetting";
/**     消息通知振动设置    */
static NSString *keyForMessageNoticeVibrationSetting = @"keyForMessageNoticeVibrationSetting";

@implementation WYUserDefaultManager

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    
    return _instance;
}

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

#pragma mark - 保存用户登录账号
- (void)setUserAccountNumber:(NSString *)userAccountNumber {
    
    [[NSUserDefaults standardUserDefaults] setObject:userAccountNumber forKey:keyForUserAccountNumber];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取用户登录账号
- (NSString *)userAccountNumber {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyForUserAccountNumber];
}

#pragma mark - 保存用户登录密码（未加密的密码）
- (void)setUserPassword:(NSString *)userPassword {
    
    [[NSUserDefaults standardUserDefaults] setObject:userPassword forKey:keyForUserPassword];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取用户登录密码（未加密的密码）
- (NSString *)userPassword {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyForUserPassword];
}

#pragma mark - 保存用户登录密码（加密后的密码）
- (void)setUserPasswordOfSecret:(NSString *)userPasswordOfSecret {
    
    [[NSUserDefaults standardUserDefaults] setObject:userPasswordOfSecret forKey:keyForUserPasswordOfSecret];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取用户登录密码（加密后的密码）
- (NSString *)userPasswordOfSecret {
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyForUserPasswordOfSecret];
}

#pragma mark - 保存极光推送设备号
- (void)setRegistrationID:(NSString *)registrationID {
    [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:keyForRegistrationID];
    // 立即存储
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取极光推送设备号
- (NSString *)registrationID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyForRegistrationID];    
}

#pragma mark - 保存上一次打开APP的时候的版本
- (void)saveLastTimeOpenVersion:(NSString *)lastTimeOpenVersion {
    
    [[NSUserDefaults standardUserDefaults] setObject:lastTimeOpenVersion forKey:keyForLastTimeOpenVersion];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取上一次打开APP的时候的版本
- (NSString *)lastTimeOpenVersion {
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyForLastTimeOpenVersion];
}

#pragma mark - 保存是否第一次设置消息通知
- (void)saveFirstMessageNoticeSetting:(BOOL)firstMessageNoticeSetting {
    [[NSUserDefaults standardUserDefaults] setBool:firstMessageNoticeSetting forKey:keyForFirstMessageNoticeSetting];
    // 立即存储
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取是否第一次设置消息通知
- (BOOL)firstMessageNoticeSetting {
    return [[NSUserDefaults standardUserDefaults] boolForKey:keyForFirstMessageNoticeSetting];
}

#pragma mark - 保存接收新消息通知设置
- (void)saveReceiveMessageNoticeSetting:(BOOL)receiveMessageNoticeSetting {
    [[NSUserDefaults standardUserDefaults] setBool:receiveMessageNoticeSetting forKey:keyForReceiveMessageNoticeSetting];
    // 立即存储
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取接收新消息通知设置
- (BOOL)receiveMessageNoticeSetting {
    return [[NSUserDefaults standardUserDefaults] boolForKey:keyForReceiveMessageNoticeSetting];
}

#pragma mark - 保存消息通知声音设置
- (void)saveMessageNoticeSoundSetting:(BOOL)messageNoticeSoundSetting {
    [[NSUserDefaults standardUserDefaults] setBool:messageNoticeSoundSetting forKey:keyForMessageNoticeSoundSetting];
    // 立即存储
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取接收新消息通知设置
- (BOOL)messageNoticeSoundSetting {
    return [[NSUserDefaults standardUserDefaults] boolForKey:keyForMessageNoticeSoundSetting];
}

#pragma mark - 保存消息通知振动设置
- (void)saveMessageNoticeVibrationSetting:(BOOL)messageNoticeVibrationSetting {
    [[NSUserDefaults standardUserDefaults] setBool:messageNoticeVibrationSetting forKey:keyForMessageNoticeVibrationSetting];
    // 立即存储
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 获取消息通知振动设置
- (BOOL)messageNoticeVibrationSetting {
    return [[NSUserDefaults standardUserDefaults] boolForKey:keyForMessageNoticeVibrationSetting];
}


@end
