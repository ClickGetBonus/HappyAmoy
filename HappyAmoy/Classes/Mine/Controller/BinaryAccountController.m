//
//  BinaryAccountController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BinaryAccountController.h"

@interface BinaryAccountController ()

/**    支付宝输入框    */
@property (strong, nonatomic) UITextField *textField;
/**    验证码输入框    */
@property (strong, nonatomic) UITextField *msgCodeTextField;
/**    获取验证码    */
@property(nonatomic,strong) UIButton *msgCodeButton;
/**    验证码    */
@property(nonatomic,copy) NSString *msgCodeOfRequest;
/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;

@end

/**     验证码倒计时时间    */
static const NSInteger countDownTime = 60;

@implementation BinaryAccountController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"绑定支付宝";
    
    self.view.backgroundColor = FooterViewBackgroundColor;
    
    [self setupUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.timer) {
        // 取消定时器
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

#pragma mark - UI

- (void)setupUI {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = QHWhiteColor;
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(5));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(44));
    }];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.text = @"支付宝账号：";
    typeLabel.textColor = ColorWithHexString(@"#797777");
    typeLabel.font = TextFont(13);
    [view addSubview:typeLabel];
 
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(view).offset(AUTOSIZESCALEX(15));
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.text = [NSString excludeEmptyQuestion:[LoginUserDefault userDefault].userItem.aliAccount];
    textField.textColor = ColorWithHexString(@"#797777");
    textField.font = TextFont(13);
    [view addSubview:textField];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(view).offset(AUTOSIZESCALEX(-80));
//        make.left.equalTo(typeLabel.mas_right).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(view).offset(AUTOSIZESCALEX(95));
    }];
    
    UIButton *bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bindButton.layer.cornerRadius = 10;
    bindButton.layer.masksToBounds = YES;
    [bindButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    bindButton.titleLabel.font = TextFont(10);
//    bindButton.backgroundColor = QHMainColor;
    if ([NSString isEmpty:[LoginUserDefault userDefault].userItem.aliAccount]) {
        [bindButton setTitle:@"未绑定" forState:UIControlStateNormal];
        [bindButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(20)) colorArray:@[(id)ColorWithHexString(@"#C2C2C2"),(id)ColorWithHexString(@"#A2A2A2")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    } else {
        [bindButton setTitle:@"已绑定" forState:UIControlStateNormal];
        [bindButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(20)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    }

    [view addSubview:bindButton];
    
    [bindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-25));
        make.width.mas_equalTo(AUTOSIZESCALEX(50));
        make.height.mas_equalTo(AUTOSIZESCALEX(20));
    }];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = QHWhiteColor;
    [self.view addSubview:view2];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(AUTOSIZESCALEX(0.5));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(44));
    }];

    UILabel *msgCodeLabel = [[UILabel alloc] init];
    msgCodeLabel.text = @"验证码：";
    msgCodeLabel.textColor = ColorWithHexString(@"#797777");
    msgCodeLabel.font = TextFont(13);
    [view2 addSubview:msgCodeLabel];
    [msgCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view2).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(view2).offset(AUTOSIZESCALEX(15));
    }];
    
    UITextField *msgCodeTextField = [[UITextField alloc] init];
    msgCodeTextField.textColor = ColorWithHexString(@"#797777");
    msgCodeTextField.font = TextFont(13);
    [view2 addSubview:msgCodeTextField];
    
    [msgCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view2).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(view2).offset(AUTOSIZESCALEX(-80));
        make.left.equalTo(view2).offset(AUTOSIZESCALEX(95));
    }];
    
    UIButton *msgCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    msgCodeButton.layer.cornerRadius = 10;
    msgCodeButton.layer.masksToBounds = YES;
    msgCodeButton.titleLabel.font = TextFont(10);
    [msgCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [msgCodeButton setTitleColor:QHBlackColor forState:UIControlStateNormal];
    [msgCodeButton setTitle:[NSString stringWithFormat:@"%zds",countDownTime] forState:UIControlStateSelected];
    [msgCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [msgCodeButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(20)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [msgCodeButton addTarget:self action:@selector(didClickMsgCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:msgCodeButton];
    self.msgCodeButton = msgCodeButton;
    [msgCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view2).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(75));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];

    WeakSelf
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.layer.cornerRadius = 3;
    confirmButton.layer.masksToBounds = YES;
    if ([NSString isEmpty:[LoginUserDefault userDefault].userItem.aliAccount]) {
        [confirmButton setTitle:@"确认绑定" forState:UIControlStateNormal];
    } else {
        [confirmButton setTitle:@"解除绑定" forState:UIControlStateNormal];
    }
    [confirmButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    confirmButton.titleLabel.font = TextFont(15);
//    confirmButton.backgroundColor = QHMainColor;
    [confirmButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(30), AUTOSIZESCALEX(40)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];

    [[confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [weakSelf.view endEditing:YES];
        
        if ([NSString isEmpty:msgCodeTextField.text]) {
            [WYProgress showErrorWithStatus:@"请输入验证码！"];
            return;
        }
        if (![weakSelf.msgCodeOfRequest isEqualToString:msgCodeTextField.text]) {
            [WYProgress showErrorWithStatus:@"验证码错误！"];
            return;
        }
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        NSString *aliAccount = textField.text;
        parameters[@"id"] = [LoginUserDefault userDefault].userItem.userId;
        if ([NSString isEmpty:[LoginUserDefault userDefault].userItem.aliAccount]) {
            parameters[@"aliAccount"] = aliAccount;
        } else {
            parameters[@"aliAccount"] = @"";
        }
        
        WeakSelf
        [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/edit" parameters:parameters successBlock:^(id response) {
            if ([response[@"code"] integerValue] == RequestSuccess) {
                if ([NSString isEmpty:[LoginUserDefault userDefault].userItem.aliAccount]) {
                    [WYProgress showSuccessWithStatus:@"绑定支付宝成功!"];
                    [LoginUserDefault userDefault].userItem.aliAccount = aliAccount;
                } else {
                    [WYProgress showSuccessWithStatus:@"解除绑定成功!"];
                    [LoginUserDefault userDefault].userItem.aliAccount = @"";
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                if ([NSString isEmpty:[LoginUserDefault userDefault].userItem.aliAccount]) {
                    [WYProgress showErrorWithStatus:@"绑定失败!"];
                } else {
                    [WYProgress showErrorWithStatus:@"解除绑定失败!"];
                }
            }
        } failureBlock:^(NSString *error) {
            
        }];

        
    }];
    [self.view addSubview:confirmButton];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view2.mas_bottom).offset(AUTOSIZESCALEX(55));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(30));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-30));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
}

#pragma mark - Button Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Button Action

// 获取验证码
- (void)didClickMsgCodeButton:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if (!sender.selected) {
        // 设置选中
        sender.selected = YES;
        // 设置不能再次点击
        sender.userInteractionEnabled = NO;
        [sender gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(20)) colorArray:@[(id)RGB(230, 230, 230),(id)RGB(230, 230, 230)] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
        
        // 倒计时
        [self countDown];
        
        // 获取验证码
        [self getSmscode];
    }
}

/**
 *  @brief  创建一个定时器用来验证码的倒计时
 */
- (void)countDown{
    
    WeakSelf
    
    __block int count = 0;
    
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        
        count++;
        
        [weakSelf.msgCodeButton setTitle:[NSString stringWithFormat:@"%zds",countDownTime - count] forState:UIControlStateSelected];
        
        if (count == countDownTime) {
            // 获取验证码按钮回复可以点击
            weakSelf.msgCodeButton.userInteractionEnabled = YES;
            // 获取验证码按钮取消选择状态
            weakSelf.msgCodeButton.selected = NO;
            [weakSelf.msgCodeButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(20)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
            
            [weakSelf.msgCodeButton setTitle:[NSString stringWithFormat:@"%zds",countDownTime] forState:UIControlStateSelected];
            if (weakSelf.timer) {
                // 取消定时器
                dispatch_cancel(weakSelf.timer);
                weakSelf.timer = nil;
            }
        }
    });
    // 开启定时器
    dispatch_resume(self.timer);
}

// 获取验证码
- (void)getSmscode {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mobile"] = [LoginUserDefault userDefault].userItem.mobile;
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/auth/smscode" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.msgCodeOfRequest = response[@"data"];
        } else {
            [WYHud showMessage:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

- (void)dealloc {
    WYFunc
}

@end
