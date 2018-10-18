//
//  ExchangeDetailCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeDetailCell.h"
#import "SwapGoogsListItem.h"

@interface ExchangeDetailCell()

/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    描述    */
@property(nonatomic,strong) UILabel *descLabel;
/**    金豆    */
@property(nonatomic,strong) UILabel *goldenLabel;
/**    价值    */
@property(nonatomic,strong) UILabel *valueLabel;
/**    库存    */
@property(nonatomic,strong) UILabel *inStockLabel;
/**    已兑    */
@property(nonatomic,strong) UILabel *haveExchangeLabel;

@end

@implementation ExchangeDetailCell

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
    titleLabel.textColor = ColorWithHexString(@"#000000");
    titleLabel.font = TextFont(14);
    titleLabel.text = @"爱奇艺VIP会员1个月";
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;

    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textColor = ColorWithHexString(@"#716E6E");
    descLabel.font = TextFont(12);
    descLabel.numberOfLines = 0;
    descLabel.text = @"爱奇艺黄金会员1个月。请务必填写正确手机号，如账号为邮箱请在在备注中填写！工作时间09：00-24：00，在工作时间3小时内完成充值。";
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    
    UILabel *goldenLabel = [[UILabel alloc] init];
    goldenLabel.textColor = ColorWithHexString(@"#F51111");
    goldenLabel.font = TextFont(14);
    goldenLabel.text = @"兑换：199金豆";
    [self.contentView addSubview:goldenLabel];
    self.goldenLabel = goldenLabel;

    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = ColorWithHexString(@"#716E6E");
    valueLabel.font = TextFont(12);
    valueLabel.text = @"价值：19元";
    [self.contentView addSubview:valueLabel];
    self.valueLabel = valueLabel;

    UILabel *inStockLabel = [[UILabel alloc] init];
    inStockLabel.textColor = ColorWithHexString(@"#716E6E");
    inStockLabel.font = TextFont(12);
    inStockLabel.text = @"库存：1000件";
    [self.contentView addSubview:inStockLabel];
    self.inStockLabel = inStockLabel;

    UILabel *haveExchangeLabel = [[UILabel alloc] init];
    haveExchangeLabel.textColor = ColorWithHexString(@"#716E6E");
    haveExchangeLabel.font = TextFont(12);
    haveExchangeLabel.text = @"已兑：22件";
    [self.contentView addSubview:haveExchangeLabel];
    self.haveExchangeLabel = haveExchangeLabel;

    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
    
    [self.goldenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(13));
    }];

    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldenLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];

    [self.inStockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.valueLabel).offset(AUTOSIZESCALEX(0));
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.equalTo(self.valueLabel);
    }];
    
    [self.haveExchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.valueLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.height.equalTo(self.valueLabel);
    }];

}

#pragma mark - Setter

- (void)setItem:(SwapGoogsListItem *)item {
    _item = item;
    if (_item) {
        self.titleLabel.text = _item.name;
        self.descLabel.text = _item.summary;
        self.goldenLabel.text = [NSString stringWithFormat:@"兑换：%zd麦粒",_item.score];
        self.valueLabel.text = [NSString stringWithFormat:@"价值：%@元",_item.price];
        self.inStockLabel.text = [NSString stringWithFormat:@"库存：%@件",_item.stock];
        self.haveExchangeLabel.text = [NSString stringWithFormat:@"已兑：%@件",_item.exchangeNum];
    }
}


@end
