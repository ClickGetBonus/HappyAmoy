//
//  WYUMShareMnager.m
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WYUMShareMnager.h"
#import <UMSocialQQHandler.h>
#import <UMSocialSinaHandler.h>
#import <UserNotifications/UserNotifications.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <UShareUI/UShareUI.h>
#import <AlipaySDK/AlipaySDK.h>
#import "APRSASigner.h"
#import <APOpenAPI.h>

@implementation WYUMShareMnager

+ (instancetype)manager {
    static WYUMShareMnager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [WYUMShareMnager new];
    });
    return manager;
}

- (void)configUSharePlatforms {
    
    //设置友盟社会化组件appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5b7ccb248f4a9d569d00000d"];
    
    //打开调试log的开关
    [[UMSocialManager defaultManager] openLog:NO];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxa6625e145fcd329a" appSecret:@"950087527b49e34831f84ef5aad270af" redirectURL:@"http://www.umeng.com/social"];
    
    [WXApi registerApp:@"wxa6625e145fcd329a"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
//    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106765921" appSecret:@"OQ05H1Iy7OVZre5V" redirectURL:@"http://www.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106867504" appSecret:@"1TIdMvh4LrPnjG7d" redirectURL:@"http://www.umeng.com/social"];

    //设置支持没有客户端情况下使用SSO授权
    [[UMSocialQQHandler defaultManager] setSupportWebView:NO];
    
    //设置分享到支付宝的应用Id，和分享url 链接
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_AlipaySession appKey:@"2018043002610992" appSecret:nil redirectURL:@"http://www.umeng.com/social"];
    
    [APOpenAPI registerApp:@"2018043002610992"];
    
    //设置分享到新浪的应用Id和appsecret，和分享url 链接
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"330999826" appSecret:@"473d8666992c1d7f67887b0b9fa15123" redirectURL:@"http://www.umeng.com/social"];
}


- (BOOL)applicationInnerApplication:(UIApplication *)app openURL:(NSURL *)url
{
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}


- (BOOL)isWechatSupport {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (BOOL)isQQSupport {
    return [TencentOAuth iphoneQQInstalled];
}

/**
 友盟分享UI
 
 @param completion 选择分享平台的回调
 */
- (void)showShareUIWithSelectionBlock:(void (^)(UMSocialPlatformType))completion {
    NSMutableArray * arr = [NSMutableArray array];
    [arr addObject:[NSNumber numberWithInteger:UMSocialPlatformType_WechatSession]];
    [arr addObject:[NSNumber numberWithInteger:UMSocialPlatformType_WechatTimeLine]];
//    [arr addObject:[NSNumber numberWithInteger:UMSocialPlatformType_QQ]];
//    [arr addObject:[NSNumber numberWithInteger:UMSocialPlatformType_AlipaySession]];
    
    [UMSocialUIManager setPreDefinePlatforms:arr];
    
    // 1行
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxRowCountForPortraitAndBottom = 1;
    // 4列
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 4;
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        completion(platformType);
    }];
}

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
- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType title:(NSString *)sharetitle desc:(NSString *)desc shareURL:(NSString *)url thumImage:(id)thumImage fromVc:(UIViewController *)fromVc completion:(void(^)(id result, NSError *error))completion {
    
    // 创建UMSocialMessageObject实例进行分享
    // 分享数据对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // 图片或图文分享
    //    NSString * title = sharetitle;
    //    UIImage * image = UMengShareIcon;
    
    // 图片分享参数可设置URL、NSData类型
    // 注意：由于iOS系统限制(iOS9+)，非HTTPS的URL图片可能会分享失败
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:sharetitle descr:desc thumImage:thumImage];
    shareObject.webpageUrl = url;
    if(platformType == UMSocialPlatformType_Sina){
        messageObject.text = desc;
    }
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:fromVc completion:^(id result, NSError *error) {
        completion(result,error);
    }];
}

/**
 友盟分享图片

 @param platformType 分享平台
 @param title 标题
 @param thumImage 缩略图
 @param shareImage 原图
 @param fromVc 控制器
 @param completion 分享回调
 */
- (void)shareImageWithPlatform:(UMSocialPlatformType)platformType title:(NSString *)title thumImage:(id)thumImage shareImage:(id)shareImage fromVc:(UIViewController *)fromVc completion:(void(^)(id result, NSError *error))completion {
    
    //     创建UMSocialMessageObject实例进行分享
    //     分享数据对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // 图片或图文分享
    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:title descr:@"" thumImage:shareImage];
    shareObject.shareImage = shareImage;
    messageObject.shareObject = shareObject;
    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        completion(result,error);
    }];
}


/**
 友盟第三方授权登录
 
 @param type 第三方平台
 @param completion 授权后的回调
 */
- (void)thirdLoginWithPlatform:(UMSocialPlatformType)type completion:(void(^)(UMSocialUserInfoResponse *result, NSError *error))completion {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:type currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            completion(nil,error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"uid: %@", resp.uid);
            NSLog(@"openid: %@", resp.openid);
            NSLog(@"unionid: %@", resp.unionId);
            NSLog(@"accessToken: %@", resp.accessToken);
            NSLog(@"expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"name: %@", resp.name);
            NSLog(@"iconurl: %@", resp.iconurl);
            NSLog(@"gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"originalResponse: %@", resp.originalResponse);
            
            completion(resp,error);
        }
    }];
}

// 支付宝登录
- (void)alipay_loginWithcompletion:(void(^)(NSString *result))completion {
    
    NSString *randomStr = [self returnRandomLetterAndNumber:24];
    NSString *app_id = @"2017052907379017";
    NSString *pid = @"2088621666647620";
    
//    NSString *rsa2PrivateKey = @"MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDl5FlA1qiFXGu/EUmakwUxcT5KIvjv4eCzk422+TasuJulDvQCyk3yPbAyTW2X3EBK6acMpd+L5JOFDEQ4ESXDnPKWidoIw/ahVqtRy49JQY3mGA5NU3BDY5HbXPg63AvgyzF+bIf1Mv72Ydq+RLVaBHWFe3SyXwQ/Wru/cD3cS5V9FhhaKMDE1ESf1xpuVeediHkZswwIeEpMK0+QzLaiMyPUlUnIaPwvPtQ35ti5iLScBOJKZ8iEmfpzAmxRbOjhpr+gvvujkH8xOanJNGp/V/tH1Oo/tXQlw75cwgtkhJHazBinre7ruDqb77f+WM9t6z2BBtrTCx0hCahxZZd/AgMBAAECggEBALWE5yB2HdwnTIAyQz7E5W3Tr85T7OFkJctFL7mQ76XTojnjI7JsUL18Dfq5/lXROAaulRM8idVopz5/oAHxMDNTYoyQzlLrgHqF94H/S+UY2NUcm3Zc8qCTJyDhOLMo+kwFxM/BHFz0ZjLesxxXHia0rKK4Bz2sHqtzlhkjpASjPjMjyG0yAzPLzHBjEhY7P26yt7E97Oz/dDzUPv9dnf/T2W3ItvvAugiR381zIhDQAl0DH6VWBPaMuiLYB0RhEUA3H83R/YYZ3k6azCT3zXxlhH1lAepWEJME03QfN8Ev0oXiTUdah2y3PFRAzeHDEj302MKuw1aawBmrpTXPMjECgYEA/SeEjzoGhOE9ALYYeyDk/1QH3pqmnHKudLY4pgwvQaMNV4Mdvspv3yVWY1swXBNFPICOyd36Xyzg09edccu67mSn0KhxIKu37kDdMf6QCwaa0BzbRzooua9xATQ+VNhec+FksWOxqhd4BFXvY5SLeemsomfP6iZbaECNE6UNQBkCgYEA6Hnj+h+Xofluuinua1TLuUtgZ9FixcymgCl1o4ThEV+v4GzdEcZYB8tP6yJdMXzcSmVBZ7B8qDkY1Iasy7hgiRGOigYQKuxpQh+it/ode1aCdh4ZpzhY3OilE63d0OnrURWsO3NNBvV4/Dig5MczEnU29X6+CCHRyznc8T5JJ1cCgYEA2zpHr4j+cEBmBaGsHaTk6sAoeHvQ4RbnQSc0c4eFvP+o5Colrj29F69L2orznCkMAlMKVIKo+ZbxtEK6k/tsDFqagTX9kd9jTy5Y35ylvQahNqxmsI4LCpKF+Bb4C528XfnIq128U6IzSv3oa4IOLytPVu0zvoAtFGEiSuraSLECgYBQq+uWolvmEz5/T4myqSxA0o1TuW9DIG8uzjRKWBQaCVBo2p4kSuXFXqIPAE/Cmod/MX/u0WmQnq+lIE7aKtMk/XivIMd/faZREdVPbnXIlQ6UmoFga8c6cWjHWXA9zM6hxpmLz8kM/yXKsIP0n8NzRkWaDy82dzXsBdpLxMdx5QKBgQCme8DPf5pdtC5PTlo8BbU2Rlm4vK8ml+ynBmlARAZ3DYhse8pa9MogtDQeixKIlG43uuLtrHUKmG2qDn3Um6rgDGci37YhZ1E1e+Unad6ZTf9NaeCzqp23go/OaQ6mui7GdxcanVk/M/X+aDqUEsq4gpCo7kxR0LPFpPc4CvscXQ==";
    
//    NSString *noSign = [NSString stringWithFormat:@"apiname=com.alipay.account.auth&app_id=%@&app_name=驰客&auth_type=AUTHACCOUNT&biz_type=openservice&method=alipay.open.auth.sdk.code.get&pid=%@&product_id=APP_FAST_LOGIN&scope=kuaijie&sign_type=RSA2&target_id=%@",app_id,pid,randomStr];
    
//    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:rsa2PrivateKey];
//
//    NSString *signedString = [signer signString:noSign withRSA2:YES];
//
//    NSString *sign = [NSString stringWithFormat:@"%@&sign=%@",noSign,signedString];
//
//    [[AlipaySDK defaultService] auth_V2WithInfo:sign fromScheme:@"ap2017052907379017" callback:^(NSDictionary *resultDic) {
//
//        completion(resultDic[@"result"]);
//
//    }];
    
    
    
    //    [[UMSocialManager defaultManager] authWithPlatform:UMSocialPlatformType_AlipaySession currentViewController:nil completion:^(id result, NSError *error) {
    //
    //        NSLog(@"result = %@",result);
    //
    //        NSLog(@"error = %@",error);
    //
    //    }];
}

/**
 生成一个随机字符串,包含大小写字母和数字
 
 @param count 生成多少位的字符串
 
 @return 随机字符串
 */
- (NSString *)returnRandomLetterAndNumber:(NSInteger)count {
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
}

- (NSString*)encodeString:(NSString*)unencodedString{
    // CharactersToBeEscaped = @":/?&;=;aliyunzixun@xxx.com#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&;=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}


@end
