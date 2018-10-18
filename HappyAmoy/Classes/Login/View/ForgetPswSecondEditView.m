//
//  ForgetPswSecondEditView.m
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ForgetPswSecondEditView.h"

@interface ForgetPswSecondEditView ()

/**    新密码图标    */
@property (strong, nonatomic) UIButton *pswButton;
/**    确认密码图标    */
@property (strong, nonatomic) UIButton *confirmPswButton;
/**    新密码输入框    */
@property (strong, nonatomic) UITextField *pswTextField;
/**    确认密码输入框    */
@property (strong, nonatomic) UITextField *confirmPswTextField;

@end

@implementation ForgetPswSecondEditView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIButton *pswButton = [[UIButton alloc] init];
    [pswButton setImage:ImageWithNamed(@"密码(1)") forState:UIControlStateNormal];
    [self addSubview:pswButton];
    self.pswButton = pswButton;
    
    [self.pswButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(10));
        make.width.mas_equalTo(AUTOSIZESCALEX(20));
        make.height.mas_equalTo(AUTOSIZESCALEX(20));
    }];
    
    UITextField *pswTextField = [[UITextField alloc] init];
    [self settingTextField:pswTextField placeholder:@"请输入新密码" placeholderColor:ColorWithHexString(@"#999999")];
    pswTextField.text = [[WYUserDefaultManager shareManager] userAccountNumber];
    pswTextField.keyboardType = UIKeyboardTypeNumberPad;
    pswTextField.secureTextEntry = YES;
    [self addSubview:pswTextField];
    self.pswTextField = pswTextField;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = RGB(240, 240, 240);
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pswButton.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self).offset(0);
        make.width.equalTo(self).offset(0);
        make.height.mas_equalTo(AUTOSIZESCALEX(1));
    }];
    
    [self.pswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pswButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.pswButton.mas_right).offset(AUTOSIZESCALEX(12));
        make.width.equalTo(self).multipliedBy(0.8);
        make.height.equalTo(self.pswButton).offset(0);
    }];
    
    UIButton *confirmPswButton = [[UIButton alloc] init];
    [confirmPswButton setImage:ImageWithNamed(@"密码(1)") forState:UIControlStateNormal];
    [self addSubview:confirmPswButton];
    self.confirmPswButton = confirmPswButton;
    
    [self.confirmPswButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.pswButton).offset(0);
        make.width.equalTo(self.pswButton);
        make.height.equalTo(self.pswButton);
    }];
    
    UITextField *confirmPswTextField = [[UITextField alloc] init];
    [self settingTextField:confirmPswTextField placeholder:@"再次输入新密码" placeholderColor:ColorWithHexString(@"#999999")];
    confirmPswTextField.text = [[WYUserDefaultManager shareManager] userPassword];
    confirmPswTextField.secureTextEntry = YES;
    [self addSubview:confirmPswTextField];
    self.confirmPswTextField = confirmPswTextField;
    
    [self.confirmPswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.confirmPswButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.pswTextField).offset(AUTOSIZESCALEX(0));
        make.width.equalTo(self.pswTextField);
        make.height.equalTo(self.pswTextField).offset(0);
    }];
}

#pragma mark - Getter

- (NSString *)psw {
    
    _psw = self.pswTextField.text;
    
    return _psw;
}

- (NSString *)confirmPsw {
    
    _confirmPsw = self.confirmPswTextField.text;
    
    return _confirmPsw;
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
