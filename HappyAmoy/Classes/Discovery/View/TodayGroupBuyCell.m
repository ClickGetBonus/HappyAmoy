//
//  TodayGroupBuyCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TodayGroupBuyCell.h"
#import "GroupListItem.h"

@interface TodayGroupBuyCell ()

/**    图片    */
@property(nonatomic,strong) UIImageView *iconImageVIew;
/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    拼团价    */
@property(nonatomic,strong) UILabel *groupBuyPriceLabel;
/**    市场价    */
@property(nonatomic,strong) UILabel *marketPriceLabel;
/**    已拼    */
@property(nonatomic,strong) UILabel *alreadyLabel;
/**    剩余    */
@property(nonatomic,strong) UILabel *remainLabel;
/**    马上拼团按钮    */
@property(nonatomic,strong) UIButton *joinButton;

@end

@implementation TodayGroupBuyCell

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
    iconImageVIew.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"省惠拼团banner") imageViewSize:CGSizeMake(AUTOSIZESCALEX(375), AUTOSIZESCALEX(200))];
    [self.contentView addSubview:iconImageVIew];
    self.iconImageVIew = iconImageVIew;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = ColorWithHexString(@"#000000");
    titleLabel.font = TextFont(14);
    titleLabel.text = @"山东红富士苹果 4斤";
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *groupBuyPriceLabel = [[UILabel alloc] init];
    groupBuyPriceLabel.textColor = ColorWithHexString(@"#FB4F67");
    groupBuyPriceLabel.font = TextFont(14);
    groupBuyPriceLabel.text = @"拼团价:￥0";
    [self.contentView addSubview:groupBuyPriceLabel];
    self.groupBuyPriceLabel = groupBuyPriceLabel;
    
    UILabel *marketPriceLabel = [[UILabel alloc] init];
    marketPriceLabel.textColor = ColorWithHexString(@"#888890");
    marketPriceLabel.font = TextFont(12);
    marketPriceLabel.text = @"市场价:￥45.00";
    [self.contentView addSubview:marketPriceLabel];
    self.marketPriceLabel = marketPriceLabel;
    
    UILabel *alreadyLabel = [[UILabel alloc] init];
    alreadyLabel.textColor = ColorWithHexString(@"#888890");
    alreadyLabel.font = TextFont(12);
    alreadyLabel.text = @"已拼：1287";
    [self.contentView addSubview:alreadyLabel];
    self.alreadyLabel = alreadyLabel;
    
    UILabel *remainLabel = [[UILabel alloc] init];
    remainLabel.textColor = ColorWithHexString(@"#888890");
    remainLabel.font = TextFont(12);
    remainLabel.text = @"剩余：53";
    [self.contentView addSubview:remainLabel];
    self.remainLabel = remainLabel;

    UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    joinButton.layer.cornerRadius = AUTOSIZESCALEX(12.5);
    joinButton.layer.masksToBounds = YES;
    [joinButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(75), AUTOSIZESCALEX(25)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    joinButton.userInteractionEnabled = NO;
    [joinButton setTitle:@"马上拼团" forState:UIControlStateNormal];
    [joinButton setTitleColor:ColorWithHexString(@"#FFFFFF") forState:UIControlStateNormal];
    joinButton.titleLabel.font = TextFont(13);
    [joinButton addTarget:self action:@selector(didClickJoinButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:joinButton];
    self.joinButton = joinButton;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(200));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageVIew.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-100));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
    [self.groupBuyPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.marketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
    }];
    
    [self.alreadyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.marketPriceLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.marketPriceLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
    }];
    
    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.alreadyLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(120));
        make.height.equalTo(self.alreadyLabel);
    }];

    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(75));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];
}

#pragma mark - Setter

- (void)setItem:(GroupListItem *)item {
    _item = item;
    if (_item) {
        [self.iconImageVIew wy_setImageWithUrlString:_item.iconUrl placeholderImage:PlaceHolderMainImage];
        self.titleLabel.text = _item.name;
        self.marketPriceLabel.text = [NSString stringWithFormat:@"市场价:￥%@",_item.price];
        self.alreadyLabel.text = [NSString stringWithFormat:@"已拼：%zd",_item.groupNum];
        self.remainLabel.text = [NSString stringWithFormat:@"剩余：%zd",_item.stock];
        if (_item.stock == 0) { // 拼完了
            [self.joinButton setTitle:@"拼完了" forState:UIControlStateNormal];
            [self.joinButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(75), AUTOSIZESCALEX(25)) colorArray:@[(id)ColorWithHexString(@"#CCCCCC"),(id)(id)ColorWithHexString(@"#CCCCCC")] percentageArray:@[@(0.5),@(1)] gradientType:GradientFromLeftToRight];
        } else {
            [self.joinButton setTitle:@"马上拼团" forState:UIControlStateNormal];
            [self.joinButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(75), AUTOSIZESCALEX(25)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
        }
    }
}

#pragma mark - Button Action
// 立即兑换
- (void)didClickJoinButton {
    WYFunc
}

@end
