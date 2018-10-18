//
//  GroupBuyRulesCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupBuyRulesCell.h"

@interface GroupBuyRulesCell ()

/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    规则    */
@property(nonatomic,strong) UILabel *rulesLabel;

@end

@implementation GroupBuyRulesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = ColorWithHexString(@"#FB4F67");
    titleLabel.font = TextFont(14);
    titleLabel.text = @"拼团规则";
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *rulesLabel = [[UILabel alloc] init];
    rulesLabel.numberOfLines = 0;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"1. 免费拼团，1个VIP会员1天只有1次拼团资格。\n2. 免费拼团邀请的对象须为未注册过平台账号的新用户。\n3. 开始拼团，到个人中心页面设置收货地址，否则视为无效。\n4. 拼团成功=2小时完成指定人数的任务。\n5. 拼团失败=2小时未能完成指定人数的任务。\n6. 商品拼团成功由团长免费获得商品，48小时内寄出。\n7. 部分偏远地方和限制地区导致无法发货，敬请见谅。\n8. 存在作弊行为的拼团订单视为无效订单。"];
    attribute.yy_lineSpacing = AUTOSIZESCALEX(8);
    rulesLabel.attributedText = attribute;
    rulesLabel.textColor = ColorWithHexString(@"#716D6D");
    rulesLabel.font = TextFont(13);
    [self.contentView addSubview:rulesLabel];
    self.rulesLabel = rulesLabel;
    
    [self addConstraints];
}

#pragma mark - Layout
- (void)addConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
    [self.rulesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
    
}

@end
