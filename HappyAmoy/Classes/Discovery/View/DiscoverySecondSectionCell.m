//
//  DiscoverySecondSectionCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DiscoverySecondSectionCell.h"
#import "SwapGoogsListItem.h"

@interface DiscoverySecondSectionCell()

/**    图片    */
@property(nonatomic,strong) UIImageView *iconImageVIew;
/**    产品名称    */
@property(nonatomic,strong) UILabel *productNameLabel;
/**    已兑    */
@property(nonatomic,strong) UILabel *alreadyExchangeLabel;
/**    剩余    */
@property(nonatomic,strong) UILabel *remainLabel;
/**    价值    */
@property(nonatomic,strong) UILabel *valueLabel;
/**    立即兑换按钮    */
@property(nonatomic,strong) UIButton *exchangeButton;
/**    分割线    */
@property(nonatomic,strong) UIView *line;

@end

@implementation DiscoverySecondSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    UIImageView *iconImageVIew = [[UIImageView alloc] init];
    iconImageVIew.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"省惠拼团banner") imageViewSize:CGSizeMake(AUTOSIZESCALEX(80), AUTOSIZESCALEX(80))];
    [self.contentView addSubview:iconImageVIew];
    self.iconImageVIew = iconImageVIew;

    UILabel *productNameLabel = [[UILabel alloc] init];
    productNameLabel.textColor = ColorWithHexString(@"#6D6767");
    productNameLabel.font = TextFont(12);
    productNameLabel.text = @"爱奇艺VIP会员1个月";
    [self.contentView addSubview:productNameLabel];
    self.productNameLabel = productNameLabel;
    
    UILabel *alreadyExchangeLabel = [[UILabel alloc] init];
    alreadyExchangeLabel.textColor = ColorWithHexString(@"#6D6767");
    alreadyExchangeLabel.font = TextFont(12);
    alreadyExchangeLabel.text = @"已兑 22 件";
    [self.contentView addSubview:alreadyExchangeLabel];
    self.alreadyExchangeLabel = alreadyExchangeLabel;
    
    UILabel *remainLabel = [[UILabel alloc] init];
    remainLabel.textColor = ColorWithHexString(@"#6D6767");
    remainLabel.font = TextFont(12);
    remainLabel.text = @"剩余 55 件";
    [self.contentView addSubview:remainLabel];
    self.remainLabel = remainLabel;

    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.textColor = ColorWithHexString(@"#6D6767");
    valueLabel.font = TextFont(12);
    valueLabel.text = @"价值 19 元";
    [self.contentView addSubview:valueLabel];
    self.valueLabel = valueLabel;
    
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exchangeButton.layer.cornerRadius = AUTOSIZESCALEX(3);
    exchangeButton.layer.masksToBounds = YES;
    [exchangeButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(100), AUTOSIZESCALEX(25)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [exchangeButton setTitle:@"132麦粒兑换" forState:UIControlStateNormal];
    exchangeButton.userInteractionEnabled = NO;
    [exchangeButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
    exchangeButton.titleLabel.font = TextFont(12);
    [exchangeButton addTarget:self action:@selector(didClickExchangeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:exchangeButton];
    self.exchangeButton = exchangeButton;

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(18));
        make.width.mas_equalTo(AUTOSIZESCALEX(80));
        make.height.mas_equalTo(AUTOSIZESCALEX(80));
    }];

    [self.productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(12));
        make.left.equalTo(self.iconImageVIew.mas_right).offset(AUTOSIZESCALEX(15));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
    }];
    
    [self.alreadyExchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productNameLabel.mas_bottom).offset(AUTOSIZESCALEX(12));
        make.left.equalTo(self.productNameLabel).offset(AUTOSIZESCALEX(0));
        make.height.equalTo(self.productNameLabel);
    }];

    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alreadyExchangeLabel.mas_bottom).offset(AUTOSIZESCALEX(12));
        make.left.equalTo(self.productNameLabel).offset(AUTOSIZESCALEX(0));
        make.height.equalTo(self.productNameLabel);
    }];

    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remainLabel.mas_bottom).offset(AUTOSIZESCALEX(12));
        make.left.equalTo(self.productNameLabel).offset(AUTOSIZESCALEX(0));
        make.height.equalTo(self.productNameLabel);
    }];

    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(100));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];

    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Setter

- (void)setItem:(SwapGoogsListItem *)item {
    _item = item;
    if (_item) {
        [self.iconImageVIew wy_setImageWithUrlString:_item.iconUrl placeholderImage:PlaceHolderMainImage];
        self.productNameLabel.text = _item.name;
        [self.exchangeButton setTitle:[NSString stringWithFormat:@"%zd麦粒兑换",_item.score] forState:UIControlStateNormal];
        self.valueLabel.text = [NSString stringWithFormat:@"价值 %@ 元",_item.price];

        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已兑 %@ 件",_item.exchangeNum]];
        [attribute addAttribute:NSForegroundColorAttributeName value:QHMainColor range:NSMakeRange(3, [_item.exchangeNum length])];
        self.alreadyExchangeLabel.attributedText = attribute;
        
        NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"剩余 %@ 件",_item.stock]];
        [attribute1 addAttribute:NSForegroundColorAttributeName value:QHMainColor range:NSMakeRange(3, [_item.stock length])];
        self.remainLabel.attributedText = attribute1;

    }
}

#pragma mark - Button Action
// 立即兑换
- (void)didClickExchangeButton {
    WYFunc
}

@end
