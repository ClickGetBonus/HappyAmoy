//
//  AppDelegate.m
//  HappyAmoy
//
//  Created by apple on 2018/4/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "WYTabBarController.h"
#import "WYNavigationController.h"
#import "PushMessageDetailController.h"
#import "WYUMShareMnager.h"
#import <UMShare/UMShare.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "QHCrashManager.h"
#import "QHCheckVersion.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

#import <AlibcTradeSDK/AlibcTradeSDK.h>

@interface AppDelegate () <JPUSHRegisterDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 配置崩溃信息的捕捉
    [[QHCrashManager manager] configureCrash];
    // 配置阿里百川
    [self configureALiBaiChuan];
    // 配置友盟分享
    [[WYUMShareMnager manager] configUSharePlatforms];
    // 配置极光推送
    [self configureJPushWithOption:launchOptions];
    // 设置状态栏为白色字体
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    // 默认游客模式
    [LoginUserDefault userDefault].isTouristsMode = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:SCREEN_FRAME];
    
    self.window.backgroundColor = QHWhiteColor;
    
//    LoginViewController *loginVc = [[LoginViewController alloc] init];
//    WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:loginVc];
    self.window.rootViewController = [QHCheckVersion checkVersionWithOptions:launchOptions];;

    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 配置阿里百川
- (void)configureALiBaiChuan {
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        
    } failure:^(NSError *error) {
        WYLog(@"Init failed: %@", error.description);
    }];
    
    // 开发阶段打开日志开关，方便排查错误信息
    //默认调试模式打开日志,release关闭,可以不调用下面的函数
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
    
    // 配置全局的淘客参数
    //如果没有阿里妈妈的淘客账号,setTaokeParams函数需要调用
//    AlibcTradeTaokeParams *taokeParams = [[AlibcTradeTaokeParams alloc] init];
//    taokeParams.pid = @"mm_XXXXX"; //mm_XXXXX为你自己申请的阿里妈妈淘客pid
//    [[AlibcTradeSDK sharedInstance] setTaokeParams:taokeParams];
    
    //设置全局的app标识，在电商模块里等同于isv_code
    //没有申请过isv_code的接入方,默认不需要调用该函数
//    [[AlibcTradeSDK sharedInstance] setISVCode:@"your_isv_code"];
    
    // 设置全局配置，是否强制使用h5
    [[AlibcTradeSDK sharedInstance] setIsForceH5:NO];
}

#pragma mark - 配置极光推送
- (void)configureJPushWithOption:(NSDictionary *)launchOptions {
    
    WYLog(@"配置极光推送1");
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    WYLog(@"配置极光推送2");
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    
#ifdef DEBUG
    [JPUSHService setupWithOption:launchOptions appKey:@"c90821dae39427a186f2c147"
                          channel:@"APP Store"
                 apsForProduction:NO
            advertisingIdentifier:advertisingId];
#else
    [JPUSHService setupWithOption:launchOptions appKey:@"c90821dae39427a186f2c147"
                          channel:@"APP Store"
                 apsForProduction:YES
            advertisingIdentifier:advertisingId];
#endif
    WYLog(@"配置极光推送3");
    
    //2.1.9版本新增获取registration id block接口。
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [JPUSHService registrationIDCompletionHandler:^(int resCode,NSString *registrationID) {
            if(resCode == 0){
                [[WYUserDefaultManager shareManager] setRegistrationID:[NSString isEmpty:registrationID] ? @"" : registrationID];
                WYLog(@"手机的registrationID = = = %@",registrationID);
            }else{
                WYLog(@"获取 registrationID 失败");
            }
        }];
    });
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    WYLog(@"deviceToken = %@",deviceToken);
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    WYLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    WYFunc
    
    // 在线收到推送执行的方法
    
    WYLog(@"userInfo = %@",userInfo);
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    WYLog(@"userInfo = %@",userInfo);
    
    [LoginUserDefault userDefault].pushDict = @{@"UIApplicationLaunchOptionsRemoteNotificationKey":userInfo};
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    
    // 在线点击推送执行的方法
    UIViewController *currentVc = [NSString wy_getCurrentVC];

    PushMessageDetailController *pushVc = [[PushMessageDetailController alloc] init];

    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:0];

//    if([currentVc isKindOfClass:[LoginViewController class]] || [currentVc isKindOfClass:[CKRegisterViewController class]] || [currentVc isKindOfClass:[CKForgetPasswordController class]]) {
//        return;
//    }
    [currentVc.navigationController pushViewController:pushVc animated:YES];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    WYFunc
    
    WYLog(@"userInfo = %@",userInfo);
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    WYFunc
    
    WYLog(@"userInfo = %@",userInfo);
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    // 阿里百川
    if (![[AlibcTradeSDK sharedInstance] application:application
                                             openURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation]) {
        // 处理其他app跳转到自己的app
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        if (!result) {
            // 其他如支付等SDK的回调
            WYLog(@"9.0以后    ,   URL = %@",url);
            // 处理第三方分享、支付结果回调
//            [self handleThirdShareAndPayCallBack:url];
        }
    }
    [self handleThirdShareAndPayCallBack:url];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    // 阿里百川
    if (![[AlibcTradeSDK sharedInstance] application:app
                                             openURL:url
                                             options:options]) {
        //处理其他app跳转到自己的app，如果百川处理过会返回YES
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
        if (!result) {
            // 其他如支付等SDK的回调
            // 处理第三方分享、支付结果回调
//            [self handleThirdShareAndPayCallBack:url];
        }
    }
    [self handleThirdShareAndPayCallBack:url];

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
        WYLog(@"9.0以前的另一个处理方法吗   ,   URL = %@",url);
        // 处理第三方分享、支付结果回调
//        [self handleThirdShareAndPayCallBack:url];
    }
    [self handleThirdShareAndPayCallBack:url];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark - APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

// APP将要从后台返回，第一次打开的时候不会调用，只有从后台切换到前台的时候才会调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

#pragma mark - APP进入活跃状态，App 第一次打开的时候也会调用
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 消息角标设置为 0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    WYLog(@"角标设置成功!");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 处理第三方分享、支付结果回调
- (void)handleThirdShareAndPayCallBack:(NSURL *)url {
    
    if ([url.host isEqualToString:@"safepay"]) { // 支付宝支付
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            WYLog(@"支付宝钱包支付结果 = %@",resultDic);
            /**
             resultStatus结果码含义
             返回码     含义
             9000     订单支付成功
             8000     正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
             4000     订单支付失败
             5000     重复请求
             6001     用户中途取消
             6002     网络连接出错
             6004     支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
             其它     其它支付错误
             */
            NSString * memo = resultDic[@"memo"];
            
            if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) { // 支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccessNotificationName object:nil];
            }else{
                [WYProgress showErrorWithStatus:memo];
            }
        }];
    }else if ([url.host isEqualToString:@"pay"]) { // 微信支付
        // 处理微信的支付结果
        [WXApi handleOpenURL:url delegate:self];
    }
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp 具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp {
    
    //启动微信支付的response
    NSString *payResoult = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        switch (resp.errCode) {
            case 0: {
                if (resp.errCode == 0) { // 支付成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:PaySuccessNotificationName object:nil];
                }
            }
                break;
            case -1:
                [WYProgress showErrorWithStatus:@"支付失败!"];
                break;
            case -2:
                [WYProgress showErrorWithStatus:@"取消支付!"];
                break;
            default:
                payResoult = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                break;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
