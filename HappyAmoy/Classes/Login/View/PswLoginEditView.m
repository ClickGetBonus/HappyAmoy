//
//  PswLoginEditView.m
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PswLoginEditView.h"

@interface PswLoginEditView ()

/**    账号图标    */
@property (strong, nonatomic) UIButton *accountIconImageView;
/**    密码图标    */
@property (strong, nonatomic) UIButton *passwordIconImageView;
/**    账号输入框    */
@property (strong, nonatomic) UITextField *accountTextField;
/**    密码输入框    */
@property (strong, nonatomic) UITextField *passwordTextField;

@end

@implementation PswLoginEditView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIButton *accountIconImageView = [[UIButton alloc] init];
    [accountIconImageView setImage:ImageWithNamed(@"手机") forState:UIControlStateNormal];
    [self addSubview:accountIconImageView];
    self.accountIconImageView = accountIconImageView;
    
    [self.accountIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(10));
        make.width.mas_equalTo(AUTOSIZESCALEX(20));
        make.height.mas_equalTo(AUTOSIZESCALEX(20));
    }];
    
    UITextField *accountTextField = [[UITextField alloc] init];
    [self settingTextField:accountTextField placeholder:@"请输入手机号" placeholderColor:ColorWithHexString(@"#999999")];
    accountTextField.text = [[WYUserDefaultManager shareManager] userAccountNumber];
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:accountTextField];
    self.accountTextField = accountTextField;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ColorWithHexString(@"#CCCCCC");
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountIconImageView.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self).offset(0);
        make.width.equalTo(self).offset(0);
        make.height.mas_equalTo(AUTOSIZESCALEX(1));
    }];
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountIconImageView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.accountIconImageView.mas_right).offset(AUTOSIZESCALEX(12));
        make.width.equalTo(self).multipliedBy(0.9);
        make.height.equalTo(self.accountIconImageView).offset(0);
    }];
    
    UIButton *passwordIconImageView = [[UIButton alloc] init];
    [passwordIconImageView setImage:ImageWithNamed(@"密码(1)") forState:UIControlStateNormal];
    [self addSubview:passwordIconImageView];
    self.passwordIconImageView = passwordIconImageView;
    
    [self.passwordIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.accountIconImageView).offset(0);
        make.width.equalTo(self.accountIconImageView);
        make.height.equalTo(self.accountIconImageView);
    }];
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    [self settingTextField:passwordTextField placeholder:@"请输入密码（6至8位数字和字母）" placeholderColor:ColorWithHexString(@"#999999")];
    passwordTextField.text = [[WYUserDefaultManager shareManager] userPassword];
    passwordTextField.secureTextEntry = YES;
    [self addSubview:passwordTextField];
    self.passwordTextField = passwordTextField;
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordIconImageView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.accountTextField).offset(AUTOSIZESCALEX(0));
        make.width.equalTo(self.accountTextField);
        make.height.equalTo(self.accountTextField).offset(0);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = line.backgroundColor;
    [self addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordIconImageView.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self).offset(0);
        make.width.equalTo(self).offset(0);
        make.height.equalTo(line).offset(0);
        make.bottom.equalTo(self);
    }];
}

#pragma mark - Getter

- (NSString *)account {
    
    _account = self.accountTextField.text;
    
    return _account;
}

- (NSString *)password {
    
    _password = self.passwordTextField.text;
    
    return _password;
}

#pragma mark - Private method
- (void)settingTextField:(UITextField *)textField placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor {
    
    textField.font = TextFont(13.0);
    // 设置placeholder的文字颜色
    textField.textColor = QHBlackColor;
    // 创建属性字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    // 设置font
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13.0];
    // 设置颜色
    attrs[NSForegroundColorAttributeName] = placeholderColor;
    // 初始化富文本占位字符串
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:placeholder attributes:attrs];
    textField.attributedPlaceholder = attStr;
    // 设置光标颜色
    textField.tintColor = QHMainColor;
    
}

@end
