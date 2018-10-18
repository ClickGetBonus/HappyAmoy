//
//  RewardBalanceCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RewardBalanceCell.h"
#import "MemberRewardItem.h"
#import "ConsumPointItem.h"

@interface RewardBalanceCell()

/**    描述    */
@property (strong, nonatomic) UILabel *describeLabel;
/**    创建时间    */
@property (strong, nonatomic) UILabel *creatimeLabel;
/**    金钱    */
@property (strong, nonatomic) UILabel *moneyLabel;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation RewardBalanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *describeLabel = [[UILabel alloc] init];
    describeLabel.textColor = ColorWithHexString(@"333333");
    describeLabel.font = TextFont(13.0);
    describeLabel.text = @"会员小明购物消费奖励";
    [self.contentView addSubview:describeLabel];
    self.describeLabel = describeLabel;
    
    UILabel *creatimeLabel = [[UILabel alloc] init];
    creatimeLabel.textColor = ColorWithHexString(@"999999");
    creatimeLabel.font = TextFont(10.0);
    creatimeLabel.text = @"2017-10-26 20:16:18";
    [self.contentView addSubview:creatimeLabel];
    self.creatimeLabel = creatimeLabel;
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.font = TextFontBold(13.0);
    moneyLabel.textColor = ColorWithHexString(@"262323");
    moneyLabel.text = @"5.00";
    [self.contentView addSubview:moneyLabel];
    self.moneyLabel = moneyLabel;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    // 添加约束
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-60));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.describeLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];

    [self.creatimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(AUTOSIZESCALEX(-15));
        make.right.equalTo(self.moneyLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(8));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Setter

- (void)setItem:(MemberRewardItem *)item {
    _item = item;
    
    if (_item) {
        self.describeLabel.text = _item.detail;
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",_item.money];
        self.creatimeLabel.text = _item.createTime;
    }
}

- (void)setPointItem:(ConsumPointItem *)pointItem {
    _pointItem = pointItem;
    if (_pointItem) {
        self.describeLabel.text = _pointItem.describe;
        if (_pointItem.type == 1) { // 消费获得积分
            self.moneyLabel.text = [NSString stringWithFormat:@"%zd",_pointItem.score];
        } else { // 积分转入余额
            self.moneyLabel.text = [NSString stringWithFormat:@"%zd",_pointItem.score];
        }
        self.creatimeLabel.text = _pointItem.createTime;
    }
}


@end
