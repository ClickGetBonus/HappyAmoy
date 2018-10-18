//
//  MemberMoneyChildCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MemberMoneyChildCell.h"

@interface MemberMoneyChildCell()

/**    图标    */
@property (strong, nonatomic) UIButton *iconImageView;
/**    类型    */
@property (strong, nonatomic) UILabel *typeLabel;
/**    余额    */
@property (strong, nonatomic) UILabel *balanceLabel;

@end

@implementation MemberMoneyChildCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIButton *iconImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconImageView setImage:ImageWithNamed(@"defaultHeadImage") forState:UIControlStateNormal];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.font = TextFont(14);
    typeLabel.text = @"分享麦穗";
    typeLabel.textColor = QHBlackColor;
    [self.contentView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.font = typeLabel.font;
    balanceLabel.text = @"0.00";
    balanceLabel.textColor = QHBlackColor;
    [self.contentView addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(25));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(10));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
}

#pragma mark - Setter

- (void)setType:(NSString *)type {
    
    _type = type;
    
    self.typeLabel.text = _type;
}

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    [self.iconImageView setImage:ImageWithNamed(_iconName) forState:UIControlStateNormal];
}

- (void)setBalance:(NSString *)balance {
    _balance = balance;
    
    self.balanceLabel.text = [NSString isEmpty:_balance] ? @"0.00" : _balance;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    switch (_index) {
        case 0: // 会员奖励
            self.balanceLabel.text = [LoginUserDefault userDefault].reward;
            break;
        case 1: // 消费积分
            self.balanceLabel.text = [LoginUserDefault userDefault].consumePoint;
            break;
        case 2: // 会员福利
            self.balanceLabel.text = [LoginUserDefault userDefault].walfare;
            break;
        case 3: // 我的钱包
            self.balanceLabel.text = [LoginUserDefault userDefault].wallet;
            break;
        default:
            break;
    }
}

@end
