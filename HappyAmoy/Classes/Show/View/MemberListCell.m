//
//  MemberListCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MemberListCell.h"

@interface MemberListCell()

/**    排名    */
@property (strong, nonatomic) UILabel *rankLabel;
/**    会员    */
@property (strong, nonatomic) UILabel *memberLabel;
/**    奖励    */
@property (strong, nonatomic) UILabel *rewardLabel;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation MemberListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *rankLabel = [[UILabel alloc] init];
    rankLabel.textColor = ColorWithHexString(@"#666666");
    rankLabel.text = @"NO 1";
    rankLabel.font = TextFont(14);
    rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:rankLabel];
    self.rankLabel = rankLabel;
    
    UILabel *memberLabel = [[UILabel alloc] init];
    memberLabel.textColor = ColorWithHexString(@"#666666");
    memberLabel.text = @"一把火";
    memberLabel.font = TextFont(14);
    memberLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:memberLabel];
    self.memberLabel = memberLabel;
    
    UILabel *rewardLabel = [[UILabel alloc] init];
    rewardLabel.textColor = ColorWithHexString(@"#666666");
    rewardLabel.text = @"0.00";
    rewardLabel.font = TextFont(14);
    rewardLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:rewardLabel];
    self.rewardLabel = rewardLabel;

    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = QHMainColor;
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(75));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
    
    [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rankLabel).offset(AUTOSIZESCALEX(0));
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(self.rankLabel);
        make.height.mas_equalTo(self.rankLabel);
    }];
    
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rankLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(90));
        make.height.mas_equalTo(self.rankLabel);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Setter

- (void)setSort:(NSInteger)sort {
    _sort = sort;
    
    self.rankLabel.text = [NSString stringWithFormat:@"NO.%zd",_sort];

    if (_sort == 1) {
        self.rankLabel.textColor = ColorWithHexString(@"#F1244D");
    } else if (_sort == 2) {
        self.rankLabel.textColor = ColorWithHexString(@"#FB4F67");
    } else if (_sort == 3) {
        self.rankLabel.textColor = ColorWithHexString(@"#F9CC54");
    } else {
        self.rankLabel.textColor = ColorWithHexString(@"#666666");
    }
}

- (void)setMemberName:(NSString *)memberName {
    _memberName = memberName;
    self.memberLabel.text = _memberName;
}

- (void)setReward:(NSString *)reward {
    _reward = reward;
    self.rewardLabel.text = [NSString stringWithFormat:@"%.2f",[_reward floatValue]];
}

@end
