//
//  WYUMShareMnager.h
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMShare/UMShare.h>

@interface WYUMShareMnager : NSObject

+ (instancetype)manager;

/**
 *  @brief  配置友盟分享参数
 */
- (void)configUSharePlatforms;

/**
 友盟分享UI

 @param completion 选择分享平台的回调
 */
- (void)showShareUIWithSelectionBlock:(void (^)(UMSocialPlatformType))completion;

/**
 友盟分享
 
 @param platformType 分享平台
 @param sharetitle 分享标题
 @param desc 分享详情
 @param url 分享URL
 @param thumImage 缩略图（UIImage或者NSData类型，或者image_url）
 @param fromVc 控制器
 @param completion 分享回调
 */
- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType title:(NSString *)sharetitle desc:(NSString *)desc shareURL:(NSString *)url thumImage:(id)thumImage fromVc:(UIViewController *)fromVc completion:(void(^)(id result, NSError *error))completion;

/**
 友盟分享图片
 
 @param platformType 分享平台
 @param title 标题
 @param thumImage 缩略图
 @param shareImage 原图
 @param fromVc 控制器
 @param completion 分享回调
 */
- (void)shareImageWithPlatform:(UMSocialPlatformType)platformType title:(NSString *)title thumImage:(id)thumImage shareImage:(id)shareImage fromVc:(UIViewController *)fromVc completion:(void(^)(id result, NSError *error))completion;

/**
 友盟第三方授权登录
 
 @param type 第三方平台
 @param completion 授权后的回调
 */
- (void)thirdLoginWithPlatform:(UMSocialPlatformType)type completion:(void(^)(UMSocialUserInfoResponse *result, NSError *error))completion;

@end
