//
//  BindPhoneView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BindPhoneView.h"

@interface BindPhoneView()

/**    手机图标    */
@property (strong, nonatomic) UIImageView *phoneIconImageView;
/**    验证码图标    */
@property (strong, nonatomic) UIImageView *msgCodeIconImageView;
/**    手机号输入框    */
@property (strong, nonatomic) UITextField *phoneTextField;
/**    验证码输入框    */
@property (strong, nonatomic) UITextField *msgCodeTextField;
/**    获取验证码按钮    */
@property (strong, nonatomic) UIButton *msgCodeButton;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;

/**    验证码    */
@property (copy, nonatomic) NSString *verificationCode;

/**    当前获取验证码的手机号码    */
@property (strong, nonatomic) NSString *currentPhoneNumber;

/**    提示语    */
@property (strong, nonatomic) UILabel *tipsLabel;
/**    手机号    */
@property (strong, nonatomic) UILabel *mobileLabel;

@end

/**     验证码倒计时时间    */
static const NSInteger countDownTime = 60;


@implementation BindPhoneView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    if (![NSString isEmpty:[LoginUserDefault userDefault].userItem.mobile]) { // 已绑定手机
        
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = @"您当前绑定的手机号";
        tipsLabel.textColor = RGB(100, 100, 100);
        tipsLabel.font = TextFont(14);
        [self addSubview:tipsLabel];
        self.tipsLabel = tipsLabel;
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(AUTOSIZESCALEX(15));
            make.left.equalTo(self).offset(AUTOSIZESCALEX(30));
        }];

        UILabel *mobileLabel = [[UILabel alloc] init];
        mobileLabel.text = [LoginUserDefault userDefault].userItem.mobile;
        mobileLabel.textColor = RGB(237, 47, 82);
        mobileLabel.font = TextFontBold(30);
        [self addSubview:mobileLabel];
        self.mobileLabel = mobileLabel;
        [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tipsLabel.mas_bottom).offset(AUTOSIZESCALEX(10));
            make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
        }];
        return;
    }
    
    UIImageView *phoneIconImageView = [[UIImageView alloc] init];
    phoneIconImageView.image = ImageWithNamed(@"手机");
    [self addSubview:phoneIconImageView];
    self.phoneIconImageView = phoneIconImageView;
    
    UIImageView *msgCodeIconImageView = [[UIImageView alloc] init];
    msgCodeIconImageView.image = ImageWithNamed(@"验证码拷贝");;
    [self addSubview:msgCodeIconImageView];
    self.msgCodeIconImageView = msgCodeIconImageView;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self addSubview:line];
    self.line = line;

    UITextField *phoneTextField = [[UITextField alloc] init];
    phoneTextField.placeholder = @"请输入手机号";
    phoneTextField.font = TextFont(16);
    [self addSubview:phoneTextField];
    self.phoneTextField = phoneTextField;
    
    UITextField *msgCodeTextField = [[UITextField alloc] init];
    msgCodeTextField.placeholder = @"请输入验证码";
    msgCodeTextField.font = TextFont(16);
    [self addSubview:msgCodeTextField];
    self.msgCodeTextField = msgCodeTextField;

    UIButton *msgCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [msgCodeButton setTitle:[NSString stringWithFormat:@"%zds",countDownTime] forState:UIControlStateSelected];
    [msgCodeButton setTitleColor:QHBlackColor forState:UIControlStateNormal];
    [msgCodeButton setTitleColor:QHBlackColor forState:UIControlStateSelected];
    msgCodeButton.titleLabel.font = TextFont(10);
    msgCodeButton.layer.cornerRadius = AUTOSIZESCALEX(10);
    [msgCodeButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(75), AUTOSIZESCALEX(30)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];

    msgCodeButton.layer.masksToBounds = YES;
    [self addSubview:msgCodeButton];
    self.msgCodeButton = msgCodeButton;
    
    WeakSelf
    [[msgCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf endEditing:YES];
        
        UIButton *sender = (UIButton *)x;
        
        if ([weakSelf.phoneTextField.text isEqualToString:@""]) {
            [WYHud showMessage:@"请输入手机号码！"];
            return;
        }
        weakSelf.currentPhoneNumber = weakSelf.phoneTextField.text;
        if (![NSString checkMobilePhone:weakSelf.phoneTextField.text]) {
            [WYProgress showErrorWithStatus:@"请输入正确格式的手机号码!"];
            return;
        }
        if (!sender.selected) {
            // 设置选中
            sender.selected = YES;
            [sender gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(75), AUTOSIZESCALEX(30)) colorArray:@[(id)RGB(230, 230, 230),(id)RGB(230, 230, 230)] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
            // 设置不能再次点击
            sender.userInteractionEnabled = NO;
            // 倒计时
            [weakSelf countDown];
            // 获取验证码
            [weakSelf getSmscode];
        }
    }];
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.phoneIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(12.5));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(30));
        make.width.mas_equalTo(AUTOSIZESCALEX(20));
        make.height.mas_equalTo(AUTOSIZESCALEX(20));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneIconImageView.mas_bottom).offset(AUTOSIZESCALEX(12.5));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    [self.msgCodeIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(AUTOSIZESCALEX(12.5));
        make.left.equalTo(self.phoneIconImageView).offset(AUTOSIZESCALEX(0));
        make.width.equalTo(self.phoneIconImageView);
        make.height.equalTo(self.phoneIconImageView);
    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneIconImageView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.phoneIconImageView.mas_right).offset(AUTOSIZESCALEX(17.5));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-20));
    }];
    
    [self.msgCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.msgCodeIconImageView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.phoneTextField).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(160));
    }];
    
    [self.msgCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.msgCodeIconImageView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-20));
        make.width.mas_equalTo(AUTOSIZESCALEX(75));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];
}

#pragma mark - Getter

- (NSString *)phoneNumber {
    return self.phoneTextField.text;
}

- (NSString *)msgCode {
    return self.msgCodeTextField.text;
}

#pragma mark - Private method
// 获取验证码
- (void)getSmscode {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"mobile"] = self.phoneTextField.text;
    
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

#pragma mark - 创建一个定时器用来验证码的倒计时
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

            [weakSelf.msgCodeButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(75), AUTOSIZESCALEX(30)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];

            // 取消定时器
            dispatch_cancel(self.timer);
            self.timer = nil;
        }
    });
    // 开启定时器
    dispatch_resume(self.timer);
}


@end
