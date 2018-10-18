//
//  MineWalletView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineWalletView.h"

@interface MineWalletView()

/**    余额    */
@property (strong, nonatomic) UILabel *balanceLabel;
/**    转入钱包余额    */
@property (strong, nonatomic) UIButton *moneyBanlanceButton;

@end

@implementation MineWalletView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = SeparatorLineColor;
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];

    UILabel *myBalanceLabel = [[UILabel alloc] init];
    myBalanceLabel.text = @"钱包余额 (元)";
    myBalanceLabel.textColor = ColorWithHexString(@"#999999");
    myBalanceLabel.textAlignment = NSTextAlignmentCenter;
    myBalanceLabel.font = TextFont(14.0);
    [self addSubview:myBalanceLabel];
    
    [myBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(28));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(15));
    }];
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.text = @"0.00";
    balanceLabel.textColor = ColorWithHexString(@"#333333");
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.font = TextFont(36);
    [self addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myBalanceLabel.mas_bottom).offset(AUTOSIZESCALEX(20));
        make.left.equalTo(myBalanceLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceLabel.mas_bottom).offset(AUTOSIZESCALEX(25));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    WeakSelf
    UIButton *turnOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[turnOutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        WYLog(@"turnOutButton");
        if ([weakSelf.delegate respondsToSelector:@selector(mineWalletView:didClickTurnOutButton:)]) {
            [weakSelf.delegate mineWalletView:weakSelf didClickTurnOutButton:sender];
        }
    }];
    [self addSubview:turnOutButton];
    
    [turnOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
    
    UILabel *turnOutLabel = [[UILabel alloc] init];
    turnOutLabel.text = @"提现转出";
    turnOutLabel.textColor = ColorWithHexString(@"#FB4F67");
    turnOutLabel.font = TextFont(14);
    [turnOutButton addSubview:turnOutLabel];
    
    [turnOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(turnOutButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(turnOutButton).offset(AUTOSIZESCALEX(15));
    }];
    
    UIImageView *nextImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"next_red")];
    [turnOutButton addSubview:nextImageView];
    [nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(turnOutButton).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(turnOutButton).offset(AUTOSIZESCALEX(-15));
    }];

    UIView *balanceDetailView = [[UIView alloc] init];
    balanceDetailView.backgroundColor = ViewControllerBackgroundColor;
    [self addSubview:balanceDetailView];
    
    [balanceDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(turnOutButton.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"账单明细 :";
    detailLabel.textColor = ColorWithHexString(@"#666666");
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

- (void)setBalance:(CGFloat)balance {
    
    _balance = balance;
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",_balance];
}



@end
