//
//  GoodsRankListCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsRankListCell.h"
#import "CommodityListItem.h"

@interface GoodsRankListCell ()

/**    容器    */
@property(nonatomic,strong) UIView *containerView;
/**    图标    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    优惠券类型    */
@property (strong, nonatomic) UILabel *ticketTypeLabel;
/**    标题    */
@property (strong, nonatomic) YYLabel *titleLabel;
/**    原价    */
@property (strong, nonatomic) UILabel *originalLabel;
/**    原价    */
@property (strong, nonatomic) UILabel *originalPriceLabel;
/**    销量    */
@property (strong, nonatomic) UILabel *salesCountLabel;
/**    券后价    */
@property (strong, nonatomic) UIButton *afterTicketButton;
/**    折扣价    */
@property (strong, nonatomic) UILabel *discountPriceLabel;
/**    优惠券    */
@property (strong, nonatomic) UIButton *ticketButton;
/**    排行榜标识    */
@property(nonatomic,strong) UIImageView *rankIcon;

@end

@implementation GoodsRankListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorWithHexString(@"#F3F3F6");
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = QHWhiteColor;
    containerView.layer.cornerRadius = AUTOSIZESCALEX(5);
    containerView.layer.masksToBounds = YES;
    containerView.layer.borderColor = ColorWithHexString(@"#B4ACAC").CGColor;
    containerView.layer.borderWidth = 0.5;
    [self.contentView addSubview:containerView];
    self.containerView = containerView;
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"appIcon_small") imageViewSize:CGSizeMake(120, 120)];
    [self.containerView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UIImageView *rankIcon = [[UIImageView alloc] init];
    rankIcon.image = ImageWithNamed(@"省惠优选排行榜1");
    [self.containerView addSubview:rankIcon];
    self.rankIcon = rankIcon;

    YYLabel *titleLabel = [[YYLabel alloc] init];
    titleLabel.numberOfLines = 2;
    // 还需要设置preferredMaxLayoutWidth最大的宽度值才可以生效多行效果
    titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - AUTOSIZESCALEX(165); //设置最大的宽度
    //    titleLabel.font = TextFont(15.5);
    //    titleLabel.textColor = RGB(85, 85, 85);
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: @"         恒源祥棉袜子男纯棉薄款船袜子春夏季低帮防臭吸汗抗菌"];
    text.yy_lineSpacing = AUTOSIZESCALEX(7.5);
    text.yy_font = TextFont(14);
    text.yy_color = ColorWithHexString(@"333333");
    titleLabel.attributedText = text;
    [self.containerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *ticketTypeLabel = [[UILabel alloc] init];
    ticketTypeLabel.text = @"天猫";
    ticketTypeLabel.layer.cornerRadius = 3;
    ticketTypeLabel.layer.masksToBounds = YES;
    ticketTypeLabel.backgroundColor = ColorWithHexString(@"CC0C0C");
    ticketTypeLabel.font = TextFont(11);
    ticketTypeLabel.textColor = QHWhiteColor;
    ticketTypeLabel.textAlignment = NSTextAlignmentCenter;
    [self.containerView addSubview:ticketTypeLabel];
    self.ticketTypeLabel = ticketTypeLabel;
    
    UILabel *originalLabel = [[UILabel alloc] init];
    originalLabel.text = @"原价";
    originalLabel.font = TextFont(12);
    originalLabel.textColor = ColorWithHexString(@"666666");
    [self.containerView addSubview:originalLabel];
    self.originalLabel = originalLabel;
    
    UILabel *originalPriceLabel = [[UILabel alloc] init];
    // 加横线
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString: @"¥ 59.00"];
    [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
    originalPriceLabel.attributedText = attribtStr;
    originalPriceLabel.font = TextFont(12);
    originalPriceLabel.textColor = ColorWithHexString(@"666666");
    [self.containerView addSubview:originalPriceLabel];
    self.originalPriceLabel = originalPriceLabel;
    
    UILabel *salesCountLabel = [[UILabel alloc] init];
    salesCountLabel.text = @"月销16287";
    salesCountLabel.font = TextFont(12);
    salesCountLabel.textColor = ColorWithHexString(@"666666");
    [self.containerView addSubview:salesCountLabel];
    self.salesCountLabel = salesCountLabel;
    
    //    UILabel *afterTicketLabel = [[UILabel alloc] init];
    //    afterTicketLabel.text = @"券后价";
    //    afterTicketLabel.layer.cornerRadius = 3;
    //    afterTicketLabel.layer.masksToBounds = YES;
    //    afterTicketLabel.backgroundColor = QHMainColor;
    //    afterTicketLabel.font = TextFont(12);
    //    afterTicketLabel.textColor = QHWhiteColor;
    //    afterTicketLabel.textAlignment = NSTextAlignmentCenter;
    //    [self.contentView addSubview:afterTicketLabel];
    //    self.afterTicketLabel = afterTicketLabel;
    
    UIButton *afterTicketButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [afterTicketButton setTitle:@"券后价" forState:UIControlStateNormal];
    [afterTicketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    afterTicketButton.titleLabel.font = TextFont(12);
    afterTicketButton.layer.cornerRadius = 3;
    afterTicketButton.layer.masksToBounds = YES;
    [afterTicketButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(18)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [self.containerView addSubview:afterTicketButton];
    self.afterTicketButton = afterTicketButton;
    
    
    UILabel *discountPriceLabel = [[UILabel alloc] init];
    discountPriceLabel.text = @"¥ 49.00";
    discountPriceLabel.font = TextFont(14);
    discountPriceLabel.textColor = QHPriceColor;
    [self.containerView addSubview:discountPriceLabel];
    self.discountPriceLabel = discountPriceLabel;
    
    UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ticketButton setTitle:@"10元券" forState:UIControlStateNormal];
    [ticketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    [ticketButton setBackgroundImage:ImageWithNamed(@"3元券bg") forState:UIControlStateNormal];
    //    ticketButton.backgroundColor = QHMainColor;
    ticketButton.titleLabel.font = TextFont(14);
    ticketButton.layer.cornerRadius = 3;
    ticketButton.layer.masksToBounds = YES;
    [self.containerView addSubview:ticketButton];
    self.ticketButton = ticketButton;

    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(AUTOSIZESCALEX(10));
        make.centerY.equalTo(self.containerView);
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(100), AUTOSIZESCALEX(100)));
    }];
    
    [self.rankIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(25), AUTOSIZESCALEX(30)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.containerView).offset(AUTOSIZESCALEX(-15));
    }];
    
    [self.ticketTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(1));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(15);
    }];
    
    [self.afterTicketButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(18);
    }];
    
    [self.discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.afterTicketButton.mas_right).offset(AUTOSIZESCALEX(7.5));
        make.centerY.equalTo(self.afterTicketButton);
    }];
    
    [self.ticketButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.centerY.equalTo(self.afterTicketButton);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(22);
    }];
    
    [self.originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.discountPriceLabel.mas_top).offset(AUTOSIZESCALEX(-10));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.originalLabel.mas_right).offset(AUTOSIZESCALEX(7.5));
        make.centerY.equalTo(self.originalLabel);
    }];
    
    [self.salesCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ticketButton).offset(AUTOSIZESCALEX(0));
        make.centerY.equalTo(self.originalLabel);
    }];
}

#pragma mark - Setter

- (void)setItem:(CommodityListItem *)item {
    _item = item;
    if (_item) {
        [self.iconImageView wy_setImageWithUrlString:_item.iconUrl placeholderImage:PlaceHolderMainImage];
        self.titleLabel.text = [NSString stringWithFormat:@"          %@",_item.name];
        // 宝贝类型，1-淘宝 2-天猫
        if (_item.type == 1) {
            self.ticketTypeLabel.text = @"淘宝";
            self.ticketTypeLabel.backgroundColor = ColorWithHexString(@"F06E35");
        } else {
            self.ticketTypeLabel.text = @"天猫";
            self.ticketTypeLabel.backgroundColor = ColorWithHexString(@"CC0C0C");
        }
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",_item.price]];
        [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
        self.originalPriceLabel.attributedText = attribtStr;
        self.discountPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f",_item.discountPrice];
        [self.ticketButton setTitle:[NSString stringWithFormat:@"%@元券",_item.couponAmount] forState:UIControlStateNormal];
        self.salesCountLabel.text = [NSString stringWithFormat:@"月销 %zd",_item.sellNum];
    }
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    if (_index == 0) {
        self.rankIcon.hidden = NO;
        self.rankIcon.image = ImageWithNamed(@"省惠优选排行榜1");
    } else if (_index == 1) {
        self.rankIcon.hidden = NO;
        self.rankIcon.image = ImageWithNamed(@"省惠优选排行榜2");
    } else if (_index == 2) {
        self.rankIcon.hidden = NO;
        self.rankIcon.image = ImageWithNamed(@"省惠优选排行榜3");
    } else {
        self.rankIcon.hidden = YES;
    }
}

@end
