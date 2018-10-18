//
//  MemberWelfareView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MemberWelfareView.h"

@interface MemberWelfareView()

/**    累计福利    */
@property (strong, nonatomic) UILabel *totalBalanceLabel;
/**    在路上的福利    */
@property (strong, nonatomic) UILabel *goingBalanceLabel;
/**    收到的福利    */
@property (strong, nonatomic) UILabel *balanceLabel;

/**    转入钱包余额    */
@property (strong, nonatomic) UIButton *moneyBanlanceButton;

@end

@implementation MemberWelfareView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *myBalanceLabel = [[UILabel alloc] init];
    myBalanceLabel.text = @"累计麦穗";
    myBalanceLabel.textColor = ColorWithHexString(@"999999");
    myBalanceLabel.textAlignment = NSTextAlignmentCenter;
    myBalanceLabel.font = TextFont(14.0);
    [self addSubview:myBalanceLabel];
    
    [myBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(20));
        make.centerX.equalTo(self).offset(0);
        make.width.mas_equalTo(AUTOSIZESCALEX(150));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
    UILabel *totalBalanceLabel = [[UILabel alloc] init];
    totalBalanceLabel.text = @"0.00";
    totalBalanceLabel.textAlignment = NSTextAlignmentCenter;
    totalBalanceLabel.textColor = ColorWithHexString(@"333333");
    totalBalanceLabel.font = TextFont(24);
    [self addSubview:totalBalanceLabel];
    self.totalBalanceLabel = totalBalanceLabel;
    
    [self.totalBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myBalanceLabel.mas_bottom).offset(AUTOSIZESCALEX(20));
        make.centerX.equalTo(self).offset(0);
        make.width.mas_equalTo(AUTOSIZESCALEX(150));
        make.height.mas_equalTo(AUTOSIZESCALEX(18));
    }];
    
    UIButton *moneyBanlanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moneyBanlanceButton.titleLabel.font = TextFontBold(12);
    [moneyBanlanceButton setTitleColor:RGB(249, 142, 153) forState:UIControlStateNormal];
    [moneyBanlanceButton setTitle:@"兑换HGS >" forState:UIControlStateNormal];
    [self addSubview:moneyBanlanceButton];
    self.moneyBanlanceButton = moneyBanlanceButton;
    
    WeakSelf
    [[self.moneyBanlanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([weakSelf.delegate respondsToSelector:@selector(memberWelfareView:toWallet:)]) {
            [weakSelf.delegate memberWelfareView:weakSelf toWallet:0];
        }
    }];
    
    [moneyBanlanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalBalanceLabel.mas_bottom).offset(AUTOSIZESCALEX(5));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(10));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyBanlanceButton.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UILabel *goingBalanceLabel = [[UILabel alloc] init];
    goingBalanceLabel.numberOfLines = 2;
    goingBalanceLabel.font = TextFont(14);
    goingBalanceLabel.textColor = ColorWithHexString(@"666666");
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:@"福利在路上\n0.00"];
    attribute1.yy_lineSpacing = AUTOSIZESCALEX(10);
    [attribute1 addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"000000") range:NSMakeRange(5, attribute1.length - 5)];
    [attribute1 addAttribute:NSFontAttributeName value:TextFont(16) range:NSMakeRange(5, attribute1.length - 5)];
    goingBalanceLabel.attributedText = attribute1;
    goingBalanceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:goingBalanceLabel];
    self.goingBalanceLabel = goingBalanceLabel;
    [self.goingBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.width.equalTo(self).multipliedBy(0.499);
        make.height.mas_equalTo(AUTOSIZESCALEX(65));
    }];
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.numberOfLines = 2;
    balanceLabel.font = TextFont(14);
    balanceLabel.textColor = ColorWithHexString(@"666666");
    NSMutableAttributedString *attribute2 = [[NSMutableAttributedString alloc] initWithString:@"收到的福利\n0.00"];
    attribute2.yy_lineSpacing = AUTOSIZESCALEX(10);
    [attribute2 addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"000000") range:NSMakeRange(5, attribute1.length - 5)];
    [attribute2 addAttribute:NSFontAttributeName value:TextFont(16) range:NSMakeRange(5, attribute1.length - 5)];
    balanceLabel.attributedText = attribute2;
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goingBalanceLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.goingBalanceLabel.mas_right).offset(AUTOSIZESCALEX(0));
        make.width.equalTo(self.goingBalanceLabel);
        make.height.equalTo(self.goingBalanceLabel);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = SeparatorLineColor;
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
        make.height.mas_equalTo(AUTOSIZESCALEX(65));
    }];
    
    UIView *balanceDetailView = [[UIView alloc] init];
    balanceDetailView.backgroundColor = ViewControllerBackgroundColor;
    [self addSubview:balanceDetailView];
    
    [balanceDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"奖励明细";
    detailLabel.textColor = ColorWithHexString(@"666666");
    detailLabel.font = TextFont(14.0);
    [balanceDetailView addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceDetailView).offset(0);
        make.left.equalTo(balanceDetailView).offset(AUTOSIZESCALEX(15));
        make.bottom.equalTo(balanceDetailView).offset(0);
        make.width.mas_equalTo(AUTOSIZESCALEX(150));
    }];
}

#pragma mark - Setter

- (void)setBalance:(NSString *)balance {
    _balance = balance;
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收到的麦穗\n%.2f",[_balance floatValue]]];
    attribute1.yy_lineSpacing = AUTOSIZESCALEX(10);
    [attribute1 addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"000000") range:NSMakeRange(5, attribute1.length - 5)];
    [attribute1 addAttribute:NSFontAttributeName value:TextFont(16) range:NSMakeRange(5, attribute1.length - 5)];
    self.balanceLabel.attributedText = attribute1;
    self.balanceLabel.textAlignment = NSTextAlignmentCenter;

//    self.balanceLabel.text = _balance;
}

- (void)setTotalBalance:(NSString *)totalBalance {
    _totalBalance = totalBalance;
    self.totalBalanceLabel.text = [NSString stringWithFormat:@"%.2f",[_totalBalance floatValue]];
}

- (void)setGoingBalance:(NSString *)goingBalance {
    _goingBalance = goingBalance;
    
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"麦穗在路上\n%.2f",[_goingBalance floatValue]]];
    attribute1.yy_lineSpacing = AUTOSIZESCALEX(10);
    [attribute1 addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"000000") range:NSMakeRange(5, attribute1.length - 5)];
    [attribute1 addAttribute:NSFontAttributeName value:TextFont(16) range:NSMakeRange(5, attribute1.length - 5)];
    self.goingBalanceLabel.attributedText = attribute1;
    self.goingBalanceLabel.textAlignment = NSTextAlignmentCenter;

//    self.goingBalanceLabel.text = _goingBalance;
}

@end
