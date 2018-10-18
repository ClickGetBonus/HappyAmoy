//
//  WYUserDefaultManager.h
//  DianDian
//
//  Created by apple on 17/11/7.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYUserDefaultManager : NSObject

+ (instancetype)shareManager;

/**     保存用户登录账号      */
- (void)setUserAccountNumber:(NSString *)userAccountNumber;

/**     获取用户登录账号      */
- (NSString *)userAccountNumber;

/**     保存用户登录密码（未加密的密码）     */
- (void)setUserPassword:(NSString *)userPassword;

/**     获取用户登录密码（未加密的密码）     */
- (NSString *)userPassword;

/**     保存用户登录密码（加密后的密码））     */
- (void)setUserPasswordOfSecret:(NSString *)userPasswordOfSecret;

/**     获取用户登录密码（加密后的密码）     */
- (NSString *)userPasswordOfSecret;

/**     保存极光推送设备号     */
- (void)setRegistrationID:(NSString *)registrationID;

/**     获取极光推送设备号     */
- (NSString *)registrationID;

/**     保存上一次打开APP的时候的版本     */
- (void)saveLastTimeOpenVersion:(NSString *)lastTimeOpenVersion;

/**     获取上一次打开APP的时候的版本     */
- (NSString *)lastTimeOpenVersion;

/**     保存是否第一次设置消息通知     */
- (void)saveFirstMessageNoticeSetting:(BOOL)firstMessageNoticeSetting;
/**     获取是否第一次设置消息通知     */
- (BOOL)firstMessageNoticeSetting;
/**     保存接收新消息通知设置     */
- (void)saveReceiveMessageNoticeSetting:(BOOL)receiveMessageNoticeSetting;
/**     获取接收新消息通知设置     */
- (BOOL)receiveMessageNoticeSetting;
/**     保存消息通知声音设置     */
- (void)saveMessageNoticeSoundSetting:(BOOL)messageNoticeSoundSetting;
/**     获取接收新消息通知设置     */
- (BOOL)messageNoticeSoundSetting;
/**     保存消息通知振动设置     */
- (void)saveMessageNoticeVibrationSetting:(BOOL)messageNoticeVibrationSetting;
/**     获取消息通知振动设置     */
- (BOOL)messageNoticeVibrationSetting;

@end
