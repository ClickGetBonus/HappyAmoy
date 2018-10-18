//
//  RewardBalanceView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RewardBalanceView.h"
#import "WebViewH5Controller.h"

@interface RewardBalanceView()

/**    余额    */
@property (strong, nonatomic) UILabel *balanceLabel;
/**    转入钱包余额    */
@property (strong, nonatomic) UIButton *moneyBanlanceButton;

@end

@implementation RewardBalanceView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"累计奖励"];
    [self addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(15));
        make.centerX.equalTo(self).offset(0);
        make.width.mas_equalTo(AUTOSIZESCALEX(60));
        make.height.mas_equalTo(AUTOSIZESCALEX(60));
    }];
    
    UILabel *myBalanceLabel = [[UILabel alloc] init];
    myBalanceLabel.text = @"累计麦穗";
    myBalanceLabel.textColor = ColorWithHexString(@"666666");
    myBalanceLabel.textAlignment = NSTextAlignmentCenter;
    myBalanceLabel.font = TextFont(16.0);
    [self addSubview:myBalanceLabel];
    
    [myBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.centerX.equalTo(self).offset(0);
        make.width.mas_equalTo(AUTOSIZESCALEX(150));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.text = @"0.00";
    balanceLabel.textColor = ColorWithHexString(@"262323");
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.font = TextFont(20);
    [self addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myBalanceLabel.mas_bottom).offset(AUTOSIZESCALEX(20));
        make.centerX.equalTo(self).offset(0);
        make.width.mas_equalTo(AUTOSIZESCALEX(150));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    
    UIButton *moneyBanlanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moneyBanlanceButton.titleLabel.font = TextFontBold(12);
    [moneyBanlanceButton setTitleColor:RGB(249, 142, 153) forState:UIControlStateNormal];
    [moneyBanlanceButton setTitle:@"兑换HGS >" forState:UIControlStateNormal];
    
    
    [self addSubview:moneyBanlanceButton];
    self.moneyBanlanceButton = moneyBanlanceButton;
    
    WeakSelf
    [[self.moneyBanlanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([weakSelf.delegate respondsToSelector:@selector(rewardBalanceView:toWallet:)]) {
            [weakSelf.delegate rewardBalanceView:weakSelf toWallet:0];
        }
    }];
    
    
    [moneyBanlanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(balanceLabel.mas_bottom).offset(AUTOSIZESCALEX(5));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-15));
    }];
    
    UIView *balanceDetailView = [[UIView alloc] init];
    balanceDetailView.backgroundColor = ViewControllerBackgroundColor;
    [self addSubview:balanceDetailView];
    
    [balanceDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceLabel.mas_bottom).offset(AUTOSIZESCALEX(20));
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.text = @"麦穗明细";
    detailLabel.font = TextFont(14.0);
    detailLabel.textColor = ColorWithHexString(@"666666");
    [balanceDetailView addSubview:detailLabel];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceDetailView).offset(0);
        make.left.equalTo(balanceDetailView).offset(AUTOSIZESCALEX(15));
        make.bottom.equalTo(balanceDetailView).offset(0);
        make.width.mas_equalTo(AUTOSIZESCALEX(150));
    }];
}

#pragma mark - Setter

- (void)setBalanceText:(NSString *)balanceText {
    
    _balanceText = balanceText;
    if (![NSString isEmpty:_balanceText]) {
        self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",[_balanceText floatValue]];
    }
}

@end
