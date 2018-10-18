//
//  LoginView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LoginView.h"
#import "PswLoginEditView.h"
#import "MobileLoginEditView.h"

@interface LoginView()

/**    应用图标    */
@property (strong, nonatomic) UIImageView *appIcon;
/**    标题    */
//@property (strong, nonatomic) UILabel *titleLabel;
/**    密码登录按钮    */
@property (strong, nonatomic) UIButton *pswLoginButton;
/**    手机登录按钮    */
@property (strong, nonatomic) UIButton *mobileLoginButton;
/**    线条    */
@property (strong, nonatomic) UIView *line;
/**    密码登录的view    */
@property (strong, nonatomic) PswLoginEditView *pswLoginView;
/**    手机登录的view    */
@property (strong, nonatomic) MobileLoginEditView *mobileLoginView;
/**    登录按钮    */
@property (strong, nonatomic) UIButton *loginButton;
/**    注册账号按钮    */
@property (strong, nonatomic) UIButton *registerButton;
/**    忘记密码    */
@property (strong, nonatomic) UIButton *forgetPswButton;
/**    微信登录    */
@property (strong, nonatomic) UIButton *wechatButton;
/**    用户协议    */
@property (strong, nonatomic) YYLabel *protocolLabel;

@end

@implementation LoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    WeakSelf
    
    UIImageView *appIcon = [[UIImageView alloc] initWithImage:ImageWithNamed(@"圆形logo")];
    [self addSubview:appIcon];
    self.appIcon = appIcon;
    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.text = @"网购达人";
//    titleLabel.textColor = QHMainColor;
//    titleLabel.font = TextFont(30);
////    titleLabel.font = [UIFont fontWithName:@"YuppySC-Regular" size:30];
//    [self addSubview:titleLabel];
//    self.titleLabel = titleLabel;
    
    UIButton *pswLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pswLoginButton.titleLabel.font = TextFont(14);
    [pswLoginButton setTitleColor:ColorWithHexString(@"#666666") forState:UIControlStateNormal];
    [pswLoginButton setTitleColor:QHMainColor forState:UIControlStateSelected];
    [pswLoginButton setTitle:@"密码登录" forState:UIControlStateNormal];
    pswLoginButton.selected = YES;
    [[pswLoginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        sender.selected = !sender.selected;
        weakSelf.mobileLoginButton.selected = !sender.selected;
        weakSelf.pswLoginView.hidden = !sender.selected;
        weakSelf.mobileLoginView.hidden = sender.selected;
        if (sender.selected) {
            [weakSelf.line mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.pswLoginButton).offset(AUTOSIZESCALEX(0));
                make.top.equalTo(weakSelf.pswLoginButton.mas_bottom).offset(AUTOSIZESCALEX(20));
                make.width.equalTo(weakSelf.pswLoginButton).offset(AUTOSIZESCALEX(0));
                make.height.mas_equalTo(AUTOSIZESCALEX(1));
            }];
        }
    }];
    [self addSubview:pswLoginButton];
    self.pswLoginButton = pswLoginButton;

    UIButton *mobileLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mobileLoginButton.titleLabel.font = TextFont(14);
    [mobileLoginButton setTitleColor:ColorWithHexString(@"#666666") forState:UIControlStateNormal];
    [mobileLoginButton setTitleColor:QHMainColor forState:UIControlStateSelected];
    [mobileLoginButton setTitle:@"手机登录" forState:UIControlStateNormal];
    [[mobileLoginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        sender.selected = !sender.selected;
        weakSelf.pswLoginButton.selected = !sender.selected;
        weakSelf.pswLoginView.hidden = sender.selected;
        weakSelf.mobileLoginView.hidden = !sender.selected;
        if (sender.selected) {
            [weakSelf.line mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.mobileLoginButton).offset(AUTOSIZESCALEX(0));
                make.top.equalTo(weakSelf.mobileLoginButton.mas_bottom).offset(AUTOSIZESCALEX(20));
                make.width.equalTo(weakSelf.mobileLoginButton).offset(AUTOSIZESCALEX(0));
                make.height.mas_equalTo(AUTOSIZESCALEX(1));
            }];
        }
    }];
    [self addSubview:mobileLoginButton];
    self.mobileLoginButton = mobileLoginButton;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = QHMainColor;
    [self addSubview:line];
    self.line = line;
    
    PswLoginEditView *pswLoginView = [[PswLoginEditView alloc] init];
    [self addSubview:pswLoginView];
    self.pswLoginView = pswLoginView;

    MobileLoginEditView *mobileLoginView = [[MobileLoginEditView alloc] init];
    mobileLoginView.hidden = YES;
    [self addSubview:mobileLoginView];
    self.mobileLoginView = mobileLoginView;

    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.layer.cornerRadius = 3;
    loginButton.layer.masksToBounds = YES;
    loginButton.titleLabel.font = TextFont(14);
//    [loginButton setBackgroundColor:QHMainColor];
    [loginButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    [loginButton setTitle:@"快速登录" forState:UIControlStateNormal];
    [loginButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(100), AUTOSIZESCALEX(40)) colorArray:@[(id)ColorWithHexString(@"ffb42b"),(id)ColorWithHexString(@"ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [[loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [weakSelf endEditing:YES];
        if (weakSelf.pswLoginButton.selected) {
            if ([weakSelf.pswLoginView.account isEqualToString:@""]) { // 手机号
                [WYHud showMessage:@"请输入手机号"];
                return ;
            } else if ([weakSelf.pswLoginView.password isEqualToString:@""]) { // 密码
                [WYHud showMessage:@"请输入密码"];
                return ;
            }
        } else {
            if ([weakSelf.mobileLoginView.account isEqualToString:@""]) { // 手机号
                [WYHud showMessage:@"请输入手机号"];
                return ;
            } else if ([weakSelf.mobileLoginView.msgCode isEqualToString:@""]) { // 验证码
                [WYHud showMessage:@"请输入验证码"];
                return ;
            } else if (![weakSelf.mobileLoginView.msgCode isEqualToString:weakSelf.mobileLoginView.msgCodeOfRequest])  { // 验证码不一致
                [WYHud showMessage:@"验证码不一致"];
                return;
            }
        }
        if ([weakSelf.delegate respondsToSelector:@selector(loginView:loginWithMobile:password:loginWay:)]) {
            if (self.pswLoginButton.selected) {
                [weakSelf.delegate loginView:weakSelf loginWithMobile:weakSelf.pswLoginView.account password:weakSelf.pswLoginView.password loginWay: LoginWithPassword];
            } else {
                [weakSelf.delegate loginView:weakSelf loginWithMobile:weakSelf.mobileLoginView.account password:weakSelf.mobileLoginView.msgCode loginWay:LoginWithSmsCode];
            }
        }
    }];
    [self addSubview:loginButton];
    self.loginButton = loginButton;

    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.titleLabel.font = TextFont(12);
    [registerButton setTitleColor:ColorWithHexString(@"#666666") forState:UIControlStateNormal];
    [registerButton setTitle:@"注册账号 >" forState:UIControlStateNormal];
    [[registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        if ([weakSelf.delegate respondsToSelector:@selector(loginView:registerWithMobile:)]) {
            [weakSelf.delegate loginView:weakSelf registerWithMobile:@""];
        }
    }];
    [self addSubview:registerButton];
    self.registerButton = registerButton;

    UIButton *forgetPswButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPswButton.titleLabel.font = TextFont(12);
    [forgetPswButton setTitleColor:ColorWithHexString(@"#4B749D") forState:UIControlStateNormal];
    [forgetPswButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [[forgetPswButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        if ([weakSelf.delegate respondsToSelector:@selector(loginView:forgetPswWithMobile:)]) {
            [weakSelf.delegate loginView:weakSelf forgetPswWithMobile:@""];
        }
    }];
    [self addSubview:forgetPswButton];
    self.forgetPswButton = forgetPswButton;

//    UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [wechatButton setImage:ImageWithNamed(@"微信登录") forState:UIControlStateNormal];
//    wechatButton.titleLabel.font = TextFont(14);
//    [wechatButton setTitleColor:ColorWithHexString(@"#666666") forState:UIControlStateNormal];
//    [wechatButton setTitle:@"微信登录" forState:UIControlStateNormal];
//    [[wechatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
//        if ([weakSelf.delegate respondsToSelector:@selector(loginView:loginWithWeChat:)]) {
//            [weakSelf.delegate loginView:weakSelf loginWithWeChat:@""];
//        }
//    }];
//    [self addSubview:wechatButton];
//    self.wechatButton = wechatButton;
    
    YYLabel *protocolLabel = [[YYLabel alloc] init];
//    protocolLabel.text = @"登录表示已同意《省钱王用户协议》";
    protocolLabel.font = TextFont(11);
    protocolLabel.textColor = ColorWithHexString(@"#666666");
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"登录表示已同意《好麦用户协议》"];
    [attribute addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"#666666") range:NSMakeRange(0, 7)];
    [attribute yy_setTextHighlightRange:NSMakeRange(7, attribute.length - 7) color:QHMainColor backgroundColor:QHWhiteColor tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if ([weakSelf.delegate respondsToSelector:@selector(loginView:checkProtocol:)]) {
            [weakSelf.delegate loginView:weakSelf checkProtocol:@""];
        }
    }];
    protocolLabel.attributedText = attribute;
    [self addSubview:protocolLabel];
    self.protocolLabel = protocolLabel;
    
    [self addConstraints];
    
//    wechatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//    [wechatButton setTitleEdgeInsets:UIEdgeInsetsMake(wechatButton.imageView.frame.size.height + AUTOSIZESCALEX(5),-wechatButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [wechatButton setImageEdgeInsets:UIEdgeInsetsMake(-wechatButton.titleLabel.bounds.size.height - AUTOSIZESCALEX(5), 0.0,0.0, -wechatButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
//    self.line.frame = CGRectMake(self.pswLoginButton.x, self.pswLoginButton.bottom_WY, self.pswLoginButton.width, AUTOSIZESCALEX(1));
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEY(100));
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(100));
        make.height.mas_equalTo(AUTOSIZESCALEX(100));
    }];
    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(AUTOSIZESCALEX(90));
//        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
//    }];
    
    [self.pswLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEY(220));
        make.right.equalTo(self.mas_centerX).offset(AUTOSIZESCALEX(-30));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.mobileLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pswLoginButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.mas_centerX).offset(AUTOSIZESCALEX(30));
        make.height.equalTo(self.pswLoginButton);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.pswLoginButton).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.pswLoginButton.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.width.equalTo(self.pswLoginButton).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(1));
    }];
    
    CGFloat topSpace = 40;
    if (UI_IS_IPHONE4) {
        topSpace = 20;
    }
    
    [self.pswLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(AUTOSIZESCALEX(topSpace));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(50));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-50));
        make.height.mas_equalTo(AUTOSIZESCALEX(100));
    }];
    
    [self.mobileLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(AUTOSIZESCALEX(topSpace));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(50));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-50));
        make.height.mas_equalTo(AUTOSIZESCALEX(100));
    }];
    
    CGFloat bottomSpace = AUTOSIZESCALEX(280);
    if (UI_IS_IPHONE4) {
        bottomSpace = 150;
    }
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self).offset(AUTOSIZESCALEX(-bottomSpace));
        make.top.mas_equalTo(self.pswLoginView.mas_bottom).mas_offset(AUTOSIZESCALEY(10));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(50));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-50));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.loginButton).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
    }];
    
    [self.forgetPswButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.registerButton).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.loginButton).offset(AUTOSIZESCALEX(0));
        make.height.equalTo(self.registerButton);
    }];
    
    [self.protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(AUTOSIZESCALEX(-30));
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
    }];
    
    CGFloat space = 60;
    if (UI_IS_IPHONE4) {
        space = 20;
    }
    
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.protocolLabel.mas_top).offset(AUTOSIZESCALEX(-space));
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
    }];
}

@end
