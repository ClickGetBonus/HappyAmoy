//
//  ForgetPswSecondController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ForgetPswSecondController.h"
#import "ForgetPswSecondEditView.h"
#import "LoginViewController.h"

@interface ForgetPswSecondController ()

@property (strong, nonatomic) ForgetPswSecondEditView *editView;
/**    下一步按钮    */
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation ForgetPswSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    ForgetPswSecondEditView *editView = [[ForgetPswSecondEditView alloc] init];
    [self.view addSubview:editView];
    self.editView = editView;
    
    WeakSelf
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 3;
    nextButton.layer.masksToBounds = YES;
    nextButton.titleLabel.font = TextFont(15);
    [nextButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(30), AUTOSIZESCALEX(40)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [nextButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    [nextButton setTitle:@"确定" forState:UIControlStateNormal];
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        
        [weakSelf.view endEditing:YES];
        
        if ([weakSelf.editView.psw isEqualToString:@""]) {
            [WYHud showMessage:@"请输入新密码!"];
            return;
        } else if ([weakSelf.editView.confirmPsw isEqualToString:@""]) {
            [WYHud showMessage:@"请再次输入新密码!"];
            return;
        } else if (![weakSelf.editView.psw isEqualToString:weakSelf.editView.confirmPsw]) {
            [WYHud showMessage:@"两次输入的密码不一致!"];
            return;
        }
        [weakSelf forgetPassword];
    }];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(10));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(100));
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
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

// 忘记密码
- (void)forgetPassword {

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mobile"] = self.mobile;
    parameters[@"smscode"] = self.smsCode;
    parameters[@"password"] = self.editView.psw;
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] postRequestWithUrl:@"/auth/forget" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [WYProgress showSuccessWithStatus:@"修改密码成功!"];
    
            for (UIViewController *tempVc in weakSelf.navigationController.viewControllers) {
                if ([tempVc isKindOfClass:[LoginViewController class]]) {
                    [weakSelf.navigationController popToViewController:tempVc animated:YES];
                }
            }
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {

    }];
}

@end
