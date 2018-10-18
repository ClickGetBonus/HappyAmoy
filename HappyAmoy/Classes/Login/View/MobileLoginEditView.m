//
//  MobileLoginEditView.m
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MobileLoginEditView.h"

@interface MobileLoginEditView ()

/**    账号图标    */
@property (strong, nonatomic) UIButton *accountIconButton;
/**    验证码图标    */
@property (strong, nonatomic) UIButton *msgCodeButton;
/**    账号输入框    */
@property (strong, nonatomic) UITextField *accountTextField;
/**    验证码输入框    */
@property (strong, nonatomic) UITextField *msgCodeTextField;
/**    获取验证码按钮    */
@property (strong, nonatomic) UIButton *getMsgCodeButton;
/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;

@end

/**     验证码倒计时时间    */
static const NSInteger countDownTime = 60;

@implementation MobileLoginEditView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIButton *accountIconButton = [[UIButton alloc] init];
    [accountIconButton setImage:ImageWithNamed(@"手机") forState:UIControlStateNormal];
    [self addSubview:accountIconButton];
    self.accountIconButton = accountIconButton;
    
    [self.accountIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(10));
        make.width.mas_equalTo(AUTOSIZESCALEX(20));
        make.height.mas_equalTo(AUTOSIZESCALEX(20));
    }];
    
    UITextField *accountTextField = [[UITextField alloc] init];
    [self settingTextField:accountTextField placeholder:@"请输入手机号" placeholderColor:ColorWithHexString(@"#999999")];
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    accountTextField.text = [[WYUserDefaultManager shareManager] userAccountNumber];
    [self addSubview:accountTextField];
    self.accountTextField = accountTextField;
    
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountIconButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.accountIconButton.mas_right).offset(AUTOSIZESCALEX(12));
        make.width.equalTo(self).multipliedBy(0.75);
        make.height.equalTo(self.accountIconButton).offset(0);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ColorWithHexString(@"#CCCCCC");
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountIconButton.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self).offset(0);
        make.width.equalTo(self).offset(0);
        make.height.mas_equalTo(AUTOSIZESCALEX(1));
    }];
    
    UIButton *msgCodeButton = [[UIButton alloc] init];
    [msgCodeButton setImage:ImageWithNamed(@"验证码拷贝") forState:UIControlStateNormal];
    [self addSubview:msgCodeButton];
    self.msgCodeButton = msgCodeButton;
    
    [self.msgCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.accountIconButton).offset(0);
        make.width.equalTo(self.accountIconButton);
        make.height.equalTo(self.accountIconButton);
    }];
    
    UITextField *msgCodeTextField = [[UITextField alloc] init];
    [self settingTextField:msgCodeTextField placeholder:@"请输入验证码" placeholderColor:ColorWithHexString(@"#999999")];
    [self addSubview:msgCodeTextField];
    self.msgCodeTextField = msgCodeTextField;
    
    UIButton *getMsgCodeButton = [[UIButton alloc] init];
    [getMsgCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getMsgCodeButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    [getMsgCodeButton setTitle:[NSString stringWithFormat:@"%zds",countDownTime] forState:UIControlStateSelected];
    [getMsgCodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    getMsgCodeButton.titleLabel.font = TextFont(10);
    getMsgCodeButton.layer.cornerRadius = AUTOSIZESCALEX(10);
    getMsgCodeButton.layer.masksToBounds = YES;
    [getMsgCodeButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(20)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [getMsgCodeButton addTarget:self action:@selector(didClickMsgCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:getMsgCodeButton];
    self.getMsgCodeButton = getMsgCodeButton;
    
    [self.getMsgCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(msgCodeButton).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(75));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];
    
    [self.msgCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.msgCodeButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.accountTextField).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.getMsgCodeButton.mas_left).offset(AUTOSIZESCALEX(-20));
        make.height.equalTo(self.accountTextField).offset(0);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = line.backgroundColor;
    [self addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.msgCodeButton.mas_bottom).offset(AUTOSIZESCALEX(15));
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

- (NSString *)msgCode {
    
    _msgCode = self.msgCodeTextField.text;
    
    return _msgCode;
}

#pragma mark - Button Action

// 获取验证码
- (void)didClickMsgCodeButton:(UIButton *)sender {
    
    if ([self.accountTextField.text isEqualToString:@""]) {
        [WYHud showMessage:@"请输入手机号码!"];
        return;
    }
    if (![NSString checkMobilePhone:self.accountTextField.text]) {
        [WYHud showMessage:@"请输入有效的手机号码!"];
        return;
    }
    
    [self endEditing:YES];
    
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
        
        [weakSelf.getMsgCodeButton setTitle:[NSString stringWithFormat:@"%zds",countDownTime - count] forState:UIControlStateSelected];
        
        if (count == countDownTime) {
            // 获取验证码按钮回复可以点击
            weakSelf.getMsgCodeButton.userInteractionEnabled = YES;
            // 获取验证码按钮取消选择状态
            weakSelf.getMsgCodeButton.selected = NO;
            [weakSelf.getMsgCodeButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(20)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];

            [weakSelf.getMsgCodeButton setTitle:[NSString stringWithFormat:@"%zds",countDownTime] forState:UIControlStateSelected];

            // 取消定时器
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
    });
    // 开启定时器
    dispatch_resume(self.timer);
}

// 获取验证码
- (void)getSmscode {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mobile"] = self.accountTextField.text;
    
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

@end
