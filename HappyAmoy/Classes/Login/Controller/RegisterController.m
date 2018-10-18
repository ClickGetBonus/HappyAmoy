//
//  RegisterController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RegisterController.h"
#import "RegisterEditView.h"

@interface RegisterController ()

@property (strong, nonatomic) RegisterEditView *editView;
/**    注册按钮    */
@property (strong, nonatomic) UIButton *registerButton;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"注册";
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    RegisterEditView *editView = [[RegisterEditView alloc] init];
    [self.view addSubview:editView];
    self.editView = editView;
    
    WeakSelf
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.layer.cornerRadius = 3;
    registerButton.layer.masksToBounds = YES;
    registerButton.titleLabel.font = TextFont(15);
    [registerButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(30), AUTOSIZESCALEX(40)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [registerButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    [registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [[registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [weakSelf.view endEditing:YES];
        
        if ([weakSelf.editView.account isEqualToString:@""]) {
            [WYHud showMessage:@"请输入手机号!"];
            return;
        } else if (![NSString checkMobilePhone:weakSelf.editView.account]) {
            [WYHud showMessage:@"请输入有效的手机号码!"];
            return;
        } else if ([weakSelf.editView.msgCode isEqualToString:@""]) {
            [WYHud showMessage:@"请输入验证码!"];
            return;
        } else if ([weakSelf.editView.password isEqualToString:@""]) {
            [WYHud showMessage:@"请输入密码!"];
            return;
        } else if (![weakSelf.editView.msgCode isEqualToString:weakSelf.editView.msgCodeOfRequest]) {
            [WYHud showMessage:@"验证码错误!"];
            return;
        }
        
        // 快速注册
        [weakSelf quicklyRegister];
        
    }];
    [self.view addSubview:registerButton];
    self.registerButton = registerButton;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(10));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(200));
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editView.mas_bottom).offset(AUTOSIZESCALEX(60));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
}

#pragma mark - Button Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private method

// 快速注册
- (void)quicklyRegister {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mobile"] = self.editView.account;
    parameters[@"smscode"] = self.editView.msgCode;
    parameters[@"password"] = self.editView.password;
    parameters[@"recommendCode"] = self.editView.invitatedCode;

    WeakSelf
    
    [[NetworkSingleton sharedManager] postRequestWithUrl:@"/auth/register" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [WYProgress showSuccessWithStatus:@"注册成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];

}


@end
