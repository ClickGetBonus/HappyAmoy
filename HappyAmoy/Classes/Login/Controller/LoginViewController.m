//
//  LoginViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "RegisterController.h"
#import "ForgetPswFirstController.h"
#import "WYTabBarController.h"
#import "CheckProtocolController.h"
#import "WYNavigationController.h"
#import "BindPhoneViewController.h"
#import "MineViewController.h"
#import "VersionItem.h"
#import "JPUSHService.h"

@interface LoginViewController () <LoginViewDelegate>

/**    登录视图    */
@property (strong, nonatomic) LoginView *loginView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    
    WeakSelf
    // 监听微信登录后绑定手机号码
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:BindMobileAfterWeChatLoginNotificationName object:nil] subscribeNext:^(id x) {
        if (weakSelf.comeFromLoginOut) { // 从退出登录跳转过来的，直接返回到我的页面
            for (UIViewController *tempVc in self.navigationController.viewControllers) {
                if ([tempVc isKindOfClass:[MineViewController class]]) {
                    [weakSelf.navigationController popToViewController:tempVc animated:YES];
                }
            }
        } else {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [LoginUserDefault userDefault].isLoginVc = NO;
}

#pragma mark - UI

- (void)setupUI {
    LoginView *loginView = [[LoginView alloc] init];
    loginView.delegate = self;
    [self.view addSubview:loginView];
    self.loginView = loginView;
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Button Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - LoginViewDelegate

// 登录
- (void)loginView:(LoginView *)loginView loginWithMobile:(NSString *)mobile password:(NSString *)password loginWay:(LoginWay)loginWay {
    
    WYLog(@"mobile = %@ , password = %@ , loginWay = %zd",mobile,password,loginWay);
    
//    WYTabBarController *tabBarVc = [[WYTabBarController alloc] init];
//    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;

    [WYProgress show];
    
    WeakSelf

    if (loginWay == LoginWithPassword) { // 密码登录
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"mobile"] = mobile;
        parameters[@"password"] = password;
        parameters[@"mobileCode"] = [NSString excludeEmptyQuestion:[[WYUserDefaultManager shareManager] registrationID]];
        
        [[NetworkSingleton sharedManager] postRequestWithUrl:@"/auth/login" parameters:parameters successBlock:^(id response) {
            if ([response[@"code"] integerValue] == RequestSuccess) {
                
                [[WYUserDefaultManager shareManager] setUserAccountNumber:mobile];
                [[WYUserDefaultManager shareManager] setUserPassword:password];
                [LoginUserDefault userDefault].userItem = [UserItem mj_objectWithKeyValues:response[@"data"]];
                // 会员模式
                [LoginUserDefault userDefault].isTouristsMode = NO;
                [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;
                [weakSelf cacheRecommendQcode];
                // 获取版本更新内容
                [weakSelf getVersion];
                // 设置推送别名
                [weakSelf setPushTag];
                if (weakSelf.comeFromLoginOut) { // 从退出登录跳转过来的，直接返回到我的页面
                    for (UIViewController *tempVc in self.navigationController.viewControllers) {
                        if ([tempVc isKindOfClass:[MineViewController class]]) {
                            [weakSelf.navigationController popToViewController:tempVc animated:YES];
                        }
                    }
                } else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                if (weakSelf.loginCallBack) {
                    weakSelf.loginCallBack();
                }
//                WYTabBarController *tabBarVc = [[WYTabBarController alloc] init];
//                [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
            } else {
                [WYHud showMessage:response[@"msg"]];
            }
        } failureBlock:^(NSString *error) {
            
        }];
    } else { // 验证码登录
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"mobile"] = mobile;
        parameters[@"smscode"] = password;
        parameters[@"mobileCode"] = [NSString excludeEmptyQuestion:[[WYUserDefaultManager shareManager] registrationID]];
        
        [[NetworkSingleton sharedManager] postRequestWithUrl:@"/auth/smscodeLogin" parameters:parameters successBlock:^(id response) {
            if ([response[@"code"] integerValue] == RequestSuccess) {
                
                [[WYUserDefaultManager shareManager] setUserAccountNumber:mobile];
                [LoginUserDefault userDefault].userItem = [UserItem mj_objectWithKeyValues:response[@"data"]];
                // 会员模式
                [LoginUserDefault userDefault].isTouristsMode = NO;
                [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;
                [weakSelf cacheRecommendQcode];
                // 获取版本更新内容
                [weakSelf getVersion];
                // 设置推送别名
                [weakSelf setPushTag];
                if (weakSelf.comeFromLoginOut) { // 从退出登录跳转过来的，直接返回到我的页面
                    for (UIViewController *tempVc in self.navigationController.viewControllers) {
                        if ([tempVc isKindOfClass:[MineViewController class]]) {
                            [weakSelf.navigationController popToViewController:tempVc animated:YES];
                        }
                    }
                } else {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                if (weakSelf.loginCallBack) {
                    weakSelf.loginCallBack();
                }
//                WYTabBarController *tabBarVc = [[WYTabBarController alloc] init];
//                [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
            } else {
                [WYHud showMessage:response[@"msg"]];
            }
        } failureBlock:^(NSString *error) {
            
        }];
    }
}

// 注册
- (void)loginView:(LoginView *)loginView registerWithMobile:(NSString *)mobile {
    RegisterController *registerVc = [[RegisterController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

// 忘记密码
- (void)loginView:(LoginView *)loginView forgetPswWithMobile:(NSString *)mobile {
    ForgetPswFirstController *firstVc = [[ForgetPswFirstController alloc] init];
    [self.navigationController pushViewController:firstVc animated:YES];
}

// 查看协议
- (void)loginView:(LoginView *)loginView checkProtocol:(NSString *)protocol {
    CheckProtocolController *protocolVc = [[CheckProtocolController alloc] init];
    protocolVc.title = @"好麦用户协议";
    [self.navigationController pushViewController:protocolVc animated:YES];
}

// 微信登录
- (void)loginView:(LoginView *)loginView loginWithWeChat:(NSString *)mobile {
    
    WeakSelf

    [[WYUMShareMnager manager] thirdLoginWithPlatform:UMSocialPlatformType_WechatSession completion:^(UMSocialUserInfoResponse *result, NSError *error) {
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [WYProgress show];
            });
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"thirdPartyType"] = @"1";
            parameters[@"thirdPartyUid"] = result.openid;
            parameters[@"nickname"] = result.name;
            parameters[@"thirdPartyHeadpic"] = result.iconurl;
            parameters[@"mobileCode"] = [NSString excludeEmptyQuestion:[[WYUserDefaultManager shareManager] registrationID]];
            
            [[NetworkSingleton sharedManager] postRequestWithUrl:@"/auth/thirdLogin" parameters:parameters successBlock:^(id response) {
                if ([response[@"code"] integerValue] == RequestSuccess) {
                    [LoginUserDefault userDefault].userItem = [UserItem mj_objectWithKeyValues:response[@"data"]];
                    // 会员模式
                    [LoginUserDefault userDefault].isTouristsMode = NO;
                    [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;
                    [weakSelf cacheRecommendQcode];
                    // 获取版本更新内容
                    [weakSelf getVersion];
                    // 设置推送别名
                    [weakSelf setPushTag];
                    if ([NSString isEmpty:[LoginUserDefault userDefault].userItem.mobile]) { // 还没绑定手机号码
                        BindPhoneViewController *phoneVc = [[BindPhoneViewController alloc] init];
                        phoneVc.isComeFromWeChat = YES;
                        WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:phoneVc];
                        [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
                    } else { // 已绑定手机号码
                        if (weakSelf.comeFromLoginOut) { // 从退出登录跳转过来的，直接返回到我的页面
                            for (UIViewController *tempVc in self.navigationController.viewControllers) {
                                if ([tempVc isKindOfClass:[MineViewController class]]) {
                                    [weakSelf.navigationController popToViewController:tempVc animated:YES];
                                }
                            }
                        } else {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
                        if (weakSelf.loginCallBack) {
                            weakSelf.loginCallBack();
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [WYHud showMessage:response[@"msg"]];
                    });
                }
            } failureBlock:^(NSString *error) {
                
            }];
        }
        WYLog(@"result.uid = %@ , result.openId = %@ , name = %@ , iconurl = %@ , error = %@",result.uid,result.openid,result.name,result.iconurl,error);
    }];
}

#pragma mark - Private method

// 缓存推荐二维码
- (void)cacheRecommendQcode {
    UIImageView *qCodeImageView = [[UIImageView alloc] init];
    [qCodeImageView wy_setImageWithUrlString:[LoginUserDefault userDefault].userItem.recommendQcodePathUrl placeholderImage:PlaceHolderMainImage];
}

// 版本更新
- (void)getVersion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"machineType"] = @"2";
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/version" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [LoginUserDefault userDefault].versionItem = [VersionItem mj_objectWithKeyValues:response[@"data"]];
            [LoginUserDefault userDefault].versionDataHaveChanged = ![LoginUserDefault userDefault].versionDataHaveChanged;
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 设置推送别名
- (void)setPushTag {
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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
