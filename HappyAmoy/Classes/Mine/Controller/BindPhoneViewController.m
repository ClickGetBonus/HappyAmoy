//
//  BindPhoneViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "BindPhoneView.h"

@interface BindPhoneViewController ()

@property (strong, nonatomic) BindPhoneView *bindView;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"绑定手机号";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    BindPhoneView *bindView = [[BindPhoneView alloc] init];
    [self.view addSubview:bindView];
    self.bindView = bindView;
    
    [self.bindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(10) + kNavHeight);
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(90));
    }];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.layer.cornerRadius = 3;
    confirmButton.layer.masksToBounds = YES;
    confirmButton.titleLabel.font = TextFont(15);
    if ([NSString isEmpty:[LoginUserDefault userDefault].userItem.mobile]) { // 未绑定手机
        [confirmButton setTitle:@"确认绑定" forState:UIControlStateNormal];
    } else {
        [confirmButton setTitle:@"已绑定" forState:UIControlStateNormal];
    }
    [confirmButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
//    [confirmButton setBackgroundColor:QHMainColor];
    [confirmButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(60), AUTOSIZESCALEX(40)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [self.view addSubview:confirmButton];
    WeakSelf
    [[confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.view endEditing:YES];
        if (![NSString isEmpty:[LoginUserDefault userDefault].userItem.mobile]) { // 已绑定手机
            [weakSelf.navigationController popViewControllerAnimated:YES];
            return ;
        }
        if ([NSString isEmpty:bindView.phoneNumber]) {
            [WYHud showMessage:@"请输入手机号码"];
            return;
        } else if ([NSString isEmpty:bindView.msgCode]) {
            [WYHud showMessage:@"请输入验证码"];
            return;
        } else if (![bindView.msgCode isEqualToString:bindView.msgCodeOfRequest]) {
            [WYHud showMessage:@"验证码错误!"];
            return;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
        parameters[@"smscode"] = bindView.msgCode;
        parameters[@"mobile"] = bindView.phoneNumber;
        
        [[NetworkSingleton sharedManager] postRequestWithUrl:@"/auth/bindPhone" parameters:parameters successBlock:^(id response) {
            if ([response[@"code"] integerValue] == RequestSuccess) {
                [WYProgress showSuccessWithStatus:@"绑定手机号成功!"];
                if (weakSelf.isComeFromWeChat) { // 来自微信登录后的绑定号码
                    if (weakSelf.isComeFromWeChat) { // 来自微信登录后的绑定号码
                        [LoginUserDefault userDefault].userItem = [UserItem mj_objectWithKeyValues:response[@"data"]];
                        // 会员模式
                        [LoginUserDefault userDefault].isTouristsMode = NO;
                        [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;
                        [[NSNotificationCenter defaultCenter] postNotificationName:BindMobileAfterWeChatLoginNotificationName object:nil];
                        [weakSelf dismissViewControllerAnimated:NO completion:nil];
                    } else {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        });
                    }
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                }
            } else {
                [WYProgress showErrorWithStatus:response[@"msg"]];
            }
        } failureBlock:^(NSString *error) {
            
        }];
    }];

    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bindView.mas_bottom).offset(AUTOSIZESCALEX(50));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(30));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-30));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
    
}

#pragma mark - Button Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
