//
//  ForgetPswFirstController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ForgetPswFirstController.h"
#import "ForgetPswFirstEditView.h"
#import "ForgetPswSecondController.h"

@interface ForgetPswFirstController ()

@property (strong, nonatomic) ForgetPswFirstEditView *editView;
/**    下一步按钮    */
@property (strong, nonatomic) UIButton *nextButton;

@end

@implementation ForgetPswFirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    ForgetPswFirstEditView *editView = [[ForgetPswFirstEditView alloc] init];
    [self.view addSubview:editView];
    self.editView = editView;
    
    WeakSelf
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 3;
    nextButton.layer.masksToBounds = YES;
    nextButton.titleLabel.font = TextFont(15);
    [nextButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(30), AUTOSIZESCALEX(40)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [nextButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [[nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [weakSelf.view endEditing:YES];
        
        if ([weakSelf.editView.account isEqualToString:@""]) {
            [WYHud showMessage:@"请输入手机号!"];
            return;
        } else if ([weakSelf.editView.msgCode isEqualToString:@""]) {
            [WYHud showMessage:@"请输入验证码!"];
            return;
        } else if (![weakSelf.editView.msgCode isEqualToString:weakSelf.editView.msgCodeOfRequest])  { // 验证码不一致
            [WYHud showMessage:@"验证码不一致"];
            return;
        }
        
        ForgetPswSecondController *secondVc = [[ForgetPswSecondController alloc] init];
        secondVc.mobile = weakSelf.editView.account;
        secondVc.smsCode = weakSelf.editView.msgCode;
        [weakSelf.navigationController pushViewController:secondVc animated:YES];
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

@end
