//
//  PutForwardView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PutForwardView.h"

@interface PutForwardView()

/**    账号背景    */
@property (strong, nonatomic) UIButton *accountButton;
/**    账号    */
@property (strong, nonatomic) UILabel *accountLabel;
/**    下一步图标    */
@property (strong, nonatomic) UIImageView *nextImageView;
/**    secondView    */
@property (strong, nonatomic) UIView *secondBgView;
/**    输入框    */
@property (strong, nonatomic) UITextField *textField;
/**    选择按钮    */
@property (strong, nonatomic) UIButton *selectedButton;
/**    协议    */
@property (strong, nonatomic) YYLabel *protocolLabel;
/**    确认提现按钮    */
@property (strong, nonatomic) UIButton *confirmButton;

@end

@implementation PutForwardView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = RGB(245, 245, 245);
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {

    [self accountView];
    
    [self secondView];
    
    [self otherView];
}

// accountView
- (void)accountView {
    WeakSelf
    UIButton *accountButton = [UIButton buttonWithType:UIButtonTypeCustom];
    accountButton.backgroundColor = QHWhiteColor;
    [[accountButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        WYLog(@"accountButton");
        if ([weakSelf.delegate respondsToSelector:@selector(putForwardView:changeAccount:)]) {
            [weakSelf.delegate putForwardView:weakSelf changeAccount:@""];
        }
    }];
    [self addSubview:accountButton];
    self.accountButton = accountButton;
    
    [self.accountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(5));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(45));
    }];
    
    UILabel *accountLabel = [[UILabel alloc] init];
    accountLabel.text = [NSString stringWithFormat:@"支付宝账号：%@",[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].userItem.aliAccount]];
    
    [RACObserve([LoginUserDefault userDefault].userItem, aliAccount) subscribeNext:^(id x) {
        accountLabel.text = [NSString stringWithFormat:@"支付宝账号：%@",[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].userItem.aliAccount]];
    }];
    accountLabel.textColor = ColorWithHexString(@"#433F3F");
    accountLabel.textAlignment = NSTextAlignmentCenter;
    accountLabel.font = TextFont(14.0);
    [self.accountButton addSubview:accountLabel];
    self.accountLabel = accountLabel;
    
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(15));
    }];
    
    UIImageView *nextImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"next")];
    [self.accountButton addSubview:nextImageView];
    self.nextImageView = nextImageView;
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountButton).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(8));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
}

// secondView
- (void)secondView {
    UIView *secondBgView = [[UIView alloc] init];
    secondBgView.backgroundColor = QHWhiteColor;
    [self addSubview:secondBgView];
    self.secondBgView = secondBgView;
    
    [secondBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountButton.mas_bottom).offset(AUTOSIZESCALEX(5));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(125));
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = @"提现金额（服务费百分之一）";
    tipsLabel.textColor = ColorWithHexString(@"#433F3F");
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.font = TextFont(12);
    [secondBgView addSubview:tipsLabel];

    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondBgView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(secondBgView).offset(AUTOSIZESCALEX(15));
    }];
    
    UILabel *moneyTypeLabel = [[UILabel alloc] init];
    moneyTypeLabel.text = @"¥";
    moneyTypeLabel.textColor = ColorWithHexString(@"#010101");
    moneyTypeLabel.textAlignment = NSTextAlignmentCenter;
    moneyTypeLabel.font = TextFont(30);
    [secondBgView addSubview:moneyTypeLabel];
    
    [moneyTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(tipsLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = TextFont(30);
    textField.textColor = QHMainColor;
    textField.tintColor = QHMainColor;
//    textView.keyboardType = UIKeyboardTypeNumberPad;
    [secondBgView addSubview:textField];
    self.textField = textField;
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(moneyTypeLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(moneyTypeLabel.mas_right).offset(AUTOSIZESCALEX(10));
        make.width.mas_equalTo(AUTOSIZESCALEX(300));
//        make.height.equalTo(moneyTypeLabel);
//        make.height.mas_equalTo(AUTOSIZESCALEX(10));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [secondBgView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyTypeLabel.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(moneyTypeLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(secondBgView).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(1.0));
    }];

    UILabel *balanceLabel = [[UILabel alloc] init];
    
//    balanceLabel.text = @"可用余额888.88元";
    balanceLabel.text = [NSString stringWithFormat:@"可用余额%.2f元",[[LoginUserDefault userDefault].userItem.balanceMoney floatValue]];
    balanceLabel.textColor = ColorWithHexString(@"#999999");
    balanceLabel.font = TextFont(12);
    [secondBgView addSubview:balanceLabel];

    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(line).offset(AUTOSIZESCALEX(0));
    }];
    WeakSelf
    UIButton *allPutForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [allPutForwardButton setTitle:@"全部提现" forState:UIControlStateNormal];
    [allPutForwardButton setTitleColor:QHMainColor forState:UIControlStateNormal];
    allPutForwardButton.titleLabel.font = TextFont(12);
    allPutForwardButton.backgroundColor = QHWhiteColor;
    [[allPutForwardButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        WYLog(@"allPutForwardButton");
        
        weakSelf.textField.text = [NSString stringWithFormat:@"%.2f",[[LoginUserDefault userDefault].userItem.balanceMoney floatValue]];
    }];
    [secondBgView addSubview:allPutForwardButton];

    [allPutForwardButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(balanceLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(secondBgView).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(20));
    }];
}

// other
- (void)otherView {
    
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectedButton setBackgroundImage:ImageWithNamed(@"复选框选中") forState:UIControlStateNormal];
    [[selectedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        WYLog(@"allPutForwardButton");
    }];
    [self addSubview:selectedButton];
    
    [selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondBgView.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(12.5));
        make.height.equalTo(selectedButton.mas_width);
    }];
    
    WeakSelf
    
    YYLabel *protocolLabel = [[YYLabel alloc] init];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"查看并同意《提现须知》"];
    text.yy_font = TextFont(11);
    text.yy_color = ColorWithHexString(@"#433F3F");
    [text yy_setTextHighlightRange:NSMakeRange(5, 6)
                             color:QHMainColor
                   backgroundColor:[UIColor whiteColor]
                         tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                             WYLog(@"protocolTapAction");
                             if ([weakSelf.delegate respondsToSelector:@selector(putForwardView:checkProtocol:)]) {
                                 [weakSelf.delegate putForwardView:weakSelf checkProtocol:@""];
                             }
                         }];
    
    protocolLabel.attributedText = text;

    [self addSubview:protocolLabel];
    self.protocolLabel = protocolLabel;
    
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectedButton).offset(AUTOSIZESCALEX(1.5));
        make.left.equalTo(selectedButton.mas_right).offset(AUTOSIZESCALEX(7.5));
//        make.height.mas_equalTo(AUTOSIZESCALEX(12.5));
    }];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.layer.cornerRadius = 3;
    confirmButton.layer.masksToBounds = YES;
    [confirmButton setTitle:@"确认提现" forState:UIControlStateNormal];
    [confirmButton setTitleColor:QHBlackColor forState:UIControlStateNormal];
    confirmButton.titleLabel.font = TextFont(15);
//    confirmButton.backgroundColor = QHMainColor;
    [confirmButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(30), AUTOSIZESCALEX(42)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [[confirmButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        WYLog(@"confirmButton");
        [self endEditing:YES];
        if ([NSString isEmpty:weakSelf.textField.text]) {
            [WYProgress showErrorWithStatus:@"提现金额不能为空!"];
            return;
        }
        if ([weakSelf.delegate respondsToSelector:@selector(putForwardView:confirmPutForward:)]) {
            [weakSelf.delegate putForwardView:weakSelf confirmPutForward:weakSelf.textField.text];
        }
    }];
    [self addSubview:confirmButton];
    self.confirmButton = confirmButton;
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectedButton.mas_bottom).offset(AUTOSIZESCALEX(65));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(42));
    }];
    
}

@end
