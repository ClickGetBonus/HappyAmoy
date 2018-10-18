//
//  LoginView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

// 登录方式
typedef NS_ENUM(NSUInteger,LoginWay){
    // 密码登录
    LoginWithPassword = 1,
    // 手机号登录
    LoginWithSmsCode = 2,
};

@class LoginView;

@protocol LoginViewDelegate <NSObject>

@optional

- (void)loginView:(LoginView *)loginView loginWithMobile:(NSString *)mobile password:(NSString *)password loginWay:(LoginWay)loginWay;
- (void)loginView:(LoginView *)loginView registerWithMobile:(NSString *)mobile;
- (void)loginView:(LoginView *)loginView forgetPswWithMobile:(NSString *)mobile;
- (void)loginView:(LoginView *)loginView loginWithWeChat:(NSString *)mobile;
- (void)loginView:(LoginView *)loginView checkProtocol:(NSString *)protocol;


@end

@interface LoginView : UIView

/**    代理    */
@property (weak, nonatomic) id<LoginViewDelegate> delegate;

@end
