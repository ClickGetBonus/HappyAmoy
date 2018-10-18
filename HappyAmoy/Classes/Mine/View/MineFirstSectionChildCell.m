//
//  MineFirstSectionChildCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineFirstSectionChildCell.h"

@interface MineFirstSectionChildCell()



@end

@implementation MineFirstSectionChildCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIButton *iconImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    iconImageView.userInteractionEnabled = NO;
    [iconImageView setImage:ImageWithNamed(@"defaultHeadImage") forState:UIControlStateNormal];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.font = TextFont(12);
    typeLabel.text = @"会员奖励";
    typeLabel.textColor = ColorWithHexString(@"#333333");
    [self.contentView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.font = TextFont(14);;
    balanceLabel.text = @"0.00";
    balanceLabel.textColor = QHBlackColor;
    [self.contentView addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(25));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-19));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
    }];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(20));
        make.height.mas_equalTo(AUTOSIZESCALEX(13));
    }];
}

#pragma mark - Setter

- (void)setType:(NSString *)type {
    
    _type = type;
    
    self.typeLabel.text = _type;
    
    if ([_type isEqualToString:@"我的钱包"]) {
        self.iconImageView.hidden = NO;
        self.balanceLabel.hidden = YES;
    } else {
        self.iconImageView.hidden = YES;
        self.balanceLabel.hidden = NO;
    }
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
