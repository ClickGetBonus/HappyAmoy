//
//  ConsumPointView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ConsumPointView.h"

@interface ConsumPointView()

/**    余额    */
@property (strong, nonatomic) UILabel *balanceLabel;
/**    积分在路上    */
@property (strong, nonatomic) UILabel *onTheRoadLabel;
/**    收到的积分    */
@property (strong, nonatomic) UILabel *receiveLabel;
/**    积分转换    */
@property (strong, nonatomic) UILabel *changeLabel;

/**    转入钱包余额    */
@property (strong, nonatomic) UIButton *moneyBanlanceButton;

@end

@implementation ConsumPointView

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
    myBalanceLabel.text = @"累计麦粒";
    myBalanceLabel.textColor = RGB(134, 134, 134);
    myBalanceLabel.textAlignment = NSTextAlignmentCenter;
    myBalanceLabel.font = TextFont(14.0);
    [self addSubview:myBalanceLabel];
    
    [myBalanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(20));
        make.centerX.equalTo(self).offset(0);
        make.width.mas_equalTo(AUTOSIZESCALEX(150));
        make.height.mas_equalTo(AUTOSIZESCALEX(10));
    }];
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.text = @"0.00";
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.font = TextFont(21.0);
    [self addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myBalanceLabel.mas_bottom).offset(AUTOSIZESCALEX(17.5));
        make.centerX.equalTo(self).offset(0);
        make.width.mas_equalTo(AUTOSIZESCALEX(150));
        make.height.mas_equalTo(AUTOSIZESCALEX(17.5));
    }];
    
    UIButton *moneyBanlanceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moneyBanlanceButton.titleLabel.font = TextFontBold(12);
    [moneyBanlanceButton setTitleColor:RGB(249, 142, 153) forState:UIControlStateNormal];
    [moneyBanlanceButton setTitle:@"兑换麦穗 >" forState:UIControlStateNormal];
    [self addSubview:moneyBanlanceButton];
    self.moneyBanlanceButton = moneyBanlanceButton;
    [moneyBanlanceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceLabel.mas_bottom).offset(AUTOSIZESCALEX(5));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-15));
    }];
    WeakSelf
    [[self.moneyBanlanceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([weakSelf.delegate respondsToSelector:@selector(consumPointView:scoreToWallet:)]) {
            [weakSelf.delegate consumPointView:weakSelf scoreToWallet:weakSelf.currentScore];
        }
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyBanlanceButton.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UILabel *onTheRoadLabel = [[UILabel alloc] init];
    onTheRoadLabel.numberOfLines = 2;
    onTheRoadLabel.font = TextFont(15);
    onTheRoadLabel.textColor = RGB(134, 134, 134);
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:@"麦粒在路上\n0"];
    attribute1.yy_lineSpacing = AUTOSIZESCALEX(10);
    [attribute1 addAttribute:NSForegroundColorAttributeName value:RGB(87, 87, 87) range:NSMakeRange(5, attribute1.length - 5)];
    onTheRoadLabel.attributedText = attribute1;
    onTheRoadLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:onTheRoadLabel];
    self.onTheRoadLabel = onTheRoadLabel;
    [onTheRoadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.width.equalTo(self).multipliedBy(0.3333);
        make.height.mas_equalTo(AUTOSIZESCALEX(65));
    }];
    
    UILabel *receiveLabel = [[UILabel alloc] init];
    receiveLabel.numberOfLines = 2;
    receiveLabel.font = TextFont(15);
    receiveLabel.textColor = RGB(134, 134, 134);
    NSMutableAttributedString *attribute2 = [[NSMutableAttributedString alloc] initWithString:@"收到的积分\n0"];
    attribute2.yy_lineSpacing = AUTOSIZESCALEX(10);
    [attribute2 addAttribute:NSForegroundColorAttributeName value:RGB(87, 87, 87) range:NSMakeRange(5, attribute2.length - 5)];
    receiveLabel.attributedText = attribute2;
    receiveLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:receiveLabel];
    self.receiveLabel = receiveLabel;
    [receiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(onTheRoadLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(onTheRoadLabel.mas_right).offset(AUTOSIZESCALEX(0));
        make.width.equalTo(onTheRoadLabel);
        make.height.equalTo(onTheRoadLabel);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = SeparatorLineColor;
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(onTheRoadLabel.mas_right).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
        make.height.mas_equalTo(AUTOSIZESCALEX(65));
    }];
    
    UILabel *changeLabel = [[UILabel alloc] init];
    changeLabel.numberOfLines = 2;
    changeLabel.font = TextFont(15);
    changeLabel.textColor = RGB(134, 134, 134);
    NSMutableAttributedString *attribute3 = [[NSMutableAttributedString alloc] initWithString:@"麦粒转换\n0"];
    attribute3.yy_lineSpacing = AUTOSIZESCALEX(10);
    [attribute3 addAttribute:NSForegroundColorAttributeName value:RGB(87, 87, 87) range:NSMakeRange(4, attribute3.length - 4)];
    changeLabel.attributedText = attribute3;
    changeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:changeLabel];
    self.changeLabel = changeLabel;
    [changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(onTheRoadLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(receiveLabel.mas_right).offset(AUTOSIZESCALEX(0));
        make.width.equalTo(onTheRoadLabel);
        make.height.equalTo(onTheRoadLabel);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = SeparatorLineColor;
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(receiveLabel.mas_right).offset(AUTOSIZESCALEX(0));
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

- (void)setCurrentScore:(NSInteger)currentScore {
    _currentScore = currentScore;
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收到的麦粒\n%zd",_currentScore]];
    attribute1.yy_lineSpacing = AUTOSIZESCALEX(10);
    [attribute1 addAttribute:NSForegroundColorAttributeName value:RGB(87, 87, 87) range:NSMakeRange(5, attribute1.length - 5)];
    self.receiveLabel.attributedText = attribute1;
    self.receiveLabel.textAlignment = NSTextAlignmentCenter;
}


- (void)setConvertedAmount:(CGFloat)convertedAmount{
    _convertedAmount = convertedAmount;
    self.balanceLabel.text = [NSString stringWithFormat:@"%.2f",_convertedAmount];
}


- (void)setGoingScore:(NSInteger)goingScore {
    _goingScore = goingScore;
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"麦粒在路上\n%zd",_goingScore]];
    attribute1.yy_lineSpacing = AUTOSIZESCALEX(10);
    [attribute1 addAttribute:NSForegroundColorAttributeName value:RGB(87, 87, 87) range:NSMakeRange(5, attribute1.length - 5)];
    self.onTheRoadLabel.attributedText = attribute1;
    self.onTheRoadLabel.textAlignment = NSTextAlignmentCenter;

}

- (void)setChangeScore:(NSInteger)changeScore {
    _changeScore = changeScore;
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"麦粒转换\n%zd",_changeScore]];
    attribute1.yy_lineSpacing = AUTOSIZESCALEX(10);
    [attribute1 addAttribute:NSForegroundColorAttributeName value:RGB(87, 87, 87) range:NSMakeRange(4, attribute1.length - 4)];
    self.changeLabel.attributedText = attribute1;
    self.changeLabel.textAlignment = NSTextAlignmentCenter;
}

@end
