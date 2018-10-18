//
//  GlobalSearchListCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GlobalSearchListCell.h"
#import "CommodityListItem.h"
#import "SearchGoodsItem.h"

@interface GlobalSearchListCell()

/**    图标    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    优惠券类型    */
@property (strong, nonatomic) UILabel *ticketTypeLabel;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    原价    */
@property (strong, nonatomic) UILabel *originalPriceLabel;
/**    销量    */
@property (strong, nonatomic) UILabel *salesCountLabel;
/**    折扣价    */
//@property (strong, nonatomic) UILabel *discountPriceLabel;
/**    分享按钮    */
@property (strong, nonatomic) UIButton *shareButton;
/**    立即购买按钮    */
@property (strong, nonatomic) UIButton *buyButton;

@end

@implementation GlobalSearchListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    WeakSelf
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"appIcon_small") imageViewSize:CGSizeMake(AUTOSIZESCALEX(150), AUTOSIZESCALEX(150))];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    // 还需要设置preferredMaxLayoutWidth最大的宽度值才可以生效多行效果
//    titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH * 0.5 - AUTOSIZESCALEX(30); //设置最大的宽度
    titleLabel.font = TextFont(12);
    titleLabel.textColor = ColorWithHexString(@"333333");
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: @"          周生生小巧玲珑真金女款佩带好看"];
    text.yy_lineSpacing = AUTOSIZESCALEX(5);
//    text.yy_font = TextFont(12);
//    text.yy_color = ColorWithHexString(@"333333");
    titleLabel.attributedText = text;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *ticketTypeLabel = [[UILabel alloc] init];
    ticketTypeLabel.text = @"天猫";
    ticketTypeLabel.layer.cornerRadius = 3;
    ticketTypeLabel.layer.masksToBounds = YES;
    ticketTypeLabel.backgroundColor = ColorWithHexString(@"CC0C0C");
    ticketTypeLabel.font = TextFont(10);
    ticketTypeLabel.textColor = QHWhiteColor;
    ticketTypeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:ticketTypeLabel];
    self.ticketTypeLabel = ticketTypeLabel;
    
    UILabel *originalPriceLabel = [[UILabel alloc] init];
    // 加横线
    originalPriceLabel.text = @"￥45.00";
    originalPriceLabel.font = TextFont(12);
    originalPriceLabel.textColor = ColorWithHexString(@"#FB4F67");
    [self.contentView addSubview:originalPriceLabel];
    self.originalPriceLabel = originalPriceLabel;
    
    UILabel *salesCountLabel = [[UILabel alloc] init];
    salesCountLabel.text = @"月销 30万";
    salesCountLabel.font = TextFont(11);
    salesCountLabel.textColor = ColorWithHexString(@"333333");
    [self.contentView addSubview:salesCountLabel];
    self.salesCountLabel = salesCountLabel;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTitle:@"分享好友" forState:UIControlStateNormal];
    [shareButton setTitleColor:ColorWithHexString(@"#F9F8F8") forState:UIControlStateNormal];
    shareButton.titleLabel.font = TextFont(11);
    shareButton.layer.cornerRadius = AUTOSIZESCALEX(3);
    shareButton.layer.masksToBounds = YES;
    [shareButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(70), AUTOSIZESCALEX(20)) colorArray:@[(id)ColorWithHexString(@"#E0AE14"),(id)(id)ColorWithHexString(@"#EC8307")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [shareButton addTarget:self action:@selector(didClickShareButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shareButton];
    self.shareButton = shareButton;

    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
    buyButton.titleLabel.font = TextFont(11);
    buyButton.layer.cornerRadius = AUTOSIZESCALEX(3);
    buyButton.layer.masksToBounds = YES;
    [buyButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(70), AUTOSIZESCALEX(20)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [buyButton addTarget:self action:@selector(didClickBuyButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:buyButton];
    self.buyButton = buyButton;

    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.height.mas_equalTo(SCREEN_WIDTH * 0.5 - AUTOSIZESCALEX(20));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.ticketTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(-0.5));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(15);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.left.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(70));
        make.height.mas_equalTo(AUTOSIZESCALEX(20));
    }];
    
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.shareButton).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.width.equalTo(self.shareButton);
        make.height.equalTo(self.shareButton);
    }];

    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.shareButton.mas_top).offset(AUTOSIZESCALEX(-7.5));
    }];
    
    [self.salesCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.buyButton).offset(AUTOSIZESCALEX(0));
        make.centerY.equalTo(self.originalPriceLabel);
    }];
}

#pragma mark - Setter

- (void)setSearchItem:(SearchGoodsItem *)searchItem {
    _searchItem = searchItem;
    if (_searchItem) {
        [self.iconImageView wy_setImageWithUrlString:searchItem.cover placeholderImage:PlaceHolderMainImage];

        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"          %@",_searchItem.title]];
        text.yy_lineSpacing = AUTOSIZESCALEX(5);
//        text.yy_font = TextFont(12);
//        text.yy_color = ColorWithHexString(@"333333");
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.attributedText = text;

//        self.titleLabel.text = [NSString stringWithFormat:@"          %@",_searchItem.title];
        // 宝贝类型，1-淘宝 2-天猫
        if ([_searchItem.type isEqualToString:@"2"]) {
            self.ticketTypeLabel.text = @"淘宝";
            self.ticketTypeLabel.backgroundColor = ColorWithHexString(@"F06E35");
        } else {
            self.ticketTypeLabel.text = @"天猫";
            self.ticketTypeLabel.backgroundColor = ColorWithHexString(@"CC0C0C");
        }
        
        self.originalPriceLabel.text = [NSString stringWithFormat:@"￥%@",_searchItem.price];
        self.salesCountLabel.text = [NSString stringWithFormat:@"月销 %zd",_searchItem.quan];

        //        self.mineCommisionLabel.text = [NSString stringWithFormat:@"预估佣金￥%@",_searchItem.mineCommision];
    }
}

#pragma mark - Button Action

- (void)didClickShareButton {
    if ([_delegate respondsToSelector:@selector(globalSearchListCell:didClickShareButton:)]) {
        [_delegate globalSearchListCell:self didClickShareButton:self.searchItem];
    }
}

- (void)didClickBuyButton {
    if ([_delegate respondsToSelector:@selector(globalSearchListCell:didClickBuyButton:)]) {
        [_delegate globalSearchListCell:self didClickBuyButton:self.searchItem];
    }
}


@end
