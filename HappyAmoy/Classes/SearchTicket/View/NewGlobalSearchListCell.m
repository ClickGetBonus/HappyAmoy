//
//  NewGlobalSearchListCell.m
//  HappyAmoy
//
//  Created by VictoryLam on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewGlobalSearchListCell.h"
#import "SearchGoodsItem.h"

@interface NewGlobalSearchListCell()
@property(nonatomic, strong) UIImageView *mineCommisionBg;
/**    图标    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    优惠券类型    */
@property (strong, nonatomic) UILabel *ticketTypeLabel;
///**    标题    */
//@property (strong, nonatomic) YYLabel *titleLabel;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;

/**    原价    */
@property (strong, nonatomic) UILabel *originalPriceLabel;
/**    销量    */
@property (strong, nonatomic) UILabel *salesCountLabel;
/**    折扣价    */
@property (strong, nonatomic) UILabel *discountPriceLabel;
/**    优惠券    */
@property (strong, nonatomic) UIButton *ticketButton;
/**    收藏按钮    */
@property (strong, nonatomic) UIButton *collectedButton;
/**    预估佣金    */
@property(nonatomic,strong) UILabel *mineCommisionLabel;
//**   背景       */
@property(nonatomic,strong) UIImageView *mineCommisionView;
/**    视频播放按钮    */
@property(nonatomic,strong) UIButton *playButton;

@property(nonatomic, strong) UIImageView *tagBgView;


@end

@implementation NewGlobalSearchListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupTbUI];
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI
- (void)setupZiyingUI {
    
    WeakSelf
    _mineCommisionBg = [[UIImageView alloc] init];
    _mineCommisionBg.image = ImageWithNamed(@"bg_sp");
    _mineCommisionBg.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_mineCommisionBg];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    //    iconImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"appIcon_small") imageViewSize:CGSizeMake(AUTOSIZESCALEX(150), AUTOSIZESCALEX(150))];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.hidden = YES;
    [playButton setImage:ImageWithNamed(@"视频") forState:UIControlStateNormal];
    [[playButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
//        if ([weakSelf.delegate respondsToSelector:@selector(NewGlobalSearchListCell:didPlayVideo:)]) {
//            [weakSelf.delegate NewGlobalSearchListCell:weakSelf didPlayVideo:weakSelf.item];
//        }
    }];
    [self.contentView addSubview:playButton];
    self.playButton = playButton;
    
    UIImageView *mineCommisionView = [[UIImageView alloc]init];
    [mineCommisionView setImage: [UIImage imageNamed:@"bg_sp"]];
    mineCommisionView.alpha = 0.8;
    [self.contentView addSubview:mineCommisionView];
    self.mineCommisionView = mineCommisionView;
    
    UILabel *mineCommisionLabel = [[UILabel alloc] init];
    mineCommisionLabel.text = @"预估麦穗 7.52";
    mineCommisionLabel.font = TextFont(12);
    mineCommisionLabel.textColor = ColorWithHexString(@"#ffffff");
    //    UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_sp.png"]];
    //    mineCommisionLabel.backgroundColor = [ColorWithHexString(@"#ffb42b") colorWithAlphaComponent:0.8];
    //    mineCommisionLabel.backgroundColor = [bgColor colorWithAlphaComponent:0.8];
    mineCommisionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:mineCommisionLabel];
    self.mineCommisionLabel = mineCommisionLabel;
    
    
    UIButton *collectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectedButton.hidden = YES;
    [collectedButton setImage:ImageWithNamed(@"已收藏") forState:UIControlStateNormal];
    [[collectedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
//        if ([weakSelf.delegate respondsToSelector:@selector(NewGlobalSearchListCell:didCancelCollected:)]) {
//            [weakSelf.delegate NewGlobalSearchListCell:weakSelf didCancelCollected:weakSelf.item];
//        }
    }];
    [self.contentView addSubview:collectedButton];
    self.collectedButton = collectedButton;
    
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
    //    ticketTypeLabel.backgroundColor = ColorWithHexString(@"CC0C0C");
    ticketTypeLabel.backgroundColor = [UIColor colorWithRed:60/255.0 green:17/255.0 blue:9/255.0 alpha:1];
    ticketTypeLabel.font = TextFont(10);
    //    ticketTypeLabel.textColor = QHWhiteColor;
    ticketTypeLabel.textColor = [UIColor colorWithRed:239/255.0 green:223/255.0 blue:143/255.0 alpha:1];
    ticketTypeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:ticketTypeLabel];
    self.ticketTypeLabel = ticketTypeLabel;
    
    UILabel *originalPriceLabel = [[UILabel alloc] init];
    // 加横线
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString: @"¥ 59.00"];
    [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
    originalPriceLabel.attributedText = attribtStr;
    originalPriceLabel.font = TextFont(12);
    originalPriceLabel.textColor = ColorWithHexString(@"333333");
    [self.contentView addSubview:originalPriceLabel];
    self.originalPriceLabel = originalPriceLabel;
    
    UILabel *salesCountLabel = [[UILabel alloc] init];
//    salesCountLabel.text = @"月销 30万";
    salesCountLabel.font = TextFont(11);
    salesCountLabel.textColor = ColorWithHexString(@"333333");
    [self.contentView addSubview:salesCountLabel];
    self.salesCountLabel = salesCountLabel;
    
    //    UILabel *discountPriceLabel = [[UILabel alloc] init];
    //    discountPriceLabel.text = @"券后价 ¥ 49.00";
    //    discountPriceLabel.font = TextFont(12);
    //    discountPriceLabel.textColor = QHPriceColor;
    //    [self.contentView addSubview:discountPriceLabel];
    //    self.discountPriceLabel = discountPriceLabel;
    
    //    UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [ticketButton setTitle:@"10元券" forState:UIControlStateNormal];
    //    [ticketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    //    //    ticketButton.backgroundColor = QHMainColor;
    //    [ticketButton setBackgroundImage:ImageWithNamed(@"3元券bg") forState:UIControlStateNormal];
    //    ticketButton.titleLabel.font = TextFont(12);
    //    ticketButton.layer.cornerRadius = 3;
    //    ticketButton.layer.masksToBounds = YES;
    //    [self.contentView addSubview:ticketButton];
    //    self.ticketButton = ticketButton;
    
    [self addZYConstraints];
}


- (void)setupTbUI {
    
    WeakSelf
    
    _mineCommisionBg = [[UIImageView alloc] init];
    _mineCommisionBg.image = ImageWithNamed(@"bg_sp");
    _mineCommisionBg.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_mineCommisionBg];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    //    iconImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"appIcon_small") imageViewSize:CGSizeMake(AUTOSIZESCALEX(150), AUTOSIZESCALEX(150))];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.hidden = YES;
    [playButton setImage:ImageWithNamed(@"视频") forState:UIControlStateNormal];
    [[playButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
//        if ([weakSelf.delegate respondsToSelector:@selector(goodsListCell:didPlayVideo:)]) {
//            [weakSelf.delegate goodsListCell:weakSelf didPlayVideo:weakSelf.item];
//        }
    }];
    [self.contentView addSubview:playButton];
    self.playButton = playButton;
    
    UIImageView *mineCommisionView = [[UIImageView alloc]init];
    [mineCommisionView setImage: [UIImage imageNamed:@"bg_sp"]];
    mineCommisionView.alpha = 0.8;
    [self.contentView addSubview:mineCommisionView];
    self.mineCommisionView = mineCommisionView;
    
    
    UILabel *mineCommisionLabel = [[UILabel alloc] init];
    mineCommisionLabel.text = @"预估麦穗 7.52";
    mineCommisionLabel.font = TextFont(12);
    mineCommisionLabel.textColor = ColorWithHexString(@"#ffffff");
    //    mineCommisionLabel.backgroundColor = [ColorWithHexString(@"#ffb42b") colorWithAlphaComponent:0.8];
    mineCommisionLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:mineCommisionLabel];
    self.mineCommisionLabel = mineCommisionLabel;
    
    UIButton *collectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    collectedButton.hidden = YES;
    [collectedButton setImage:ImageWithNamed(@"已收藏") forState:UIControlStateNormal];
    [[collectedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
//        if ([weakSelf.delegate respondsToSelector:@selector(goodsListCell:didCancelCollected:)]) {
//            [weakSelf.delegate goodsListCell:weakSelf didCancelCollected:weakSelf.item];
//        }
    }];
    [self.contentView addSubview:collectedButton];
    self.collectedButton = collectedButton;
    
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
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString: @"¥ 59.00"];
    [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
    originalPriceLabel.attributedText = attribtStr;
    originalPriceLabel.font = TextFont(12);
    originalPriceLabel.textColor = ColorWithHexString(@"333333");
    [self.contentView addSubview:originalPriceLabel];
    self.originalPriceLabel = originalPriceLabel;
    
    UILabel *salesCountLabel = [[UILabel alloc] init];
//    salesCountLabel.text = @"月销 30万";
    salesCountLabel.font = TextFont(11);
    salesCountLabel.textColor = ColorWithHexString(@"333333");
    [self.contentView addSubview:salesCountLabel];
    self.salesCountLabel = salesCountLabel;
    
    UILabel *discountPriceLabel = [[UILabel alloc] init];
    discountPriceLabel.text = @"券后价 ¥ 49.00";
    discountPriceLabel.font = TextFont(12);
    discountPriceLabel.textColor = QHPriceColor;
    [self.contentView addSubview:discountPriceLabel];
    self.discountPriceLabel = discountPriceLabel;
    
    UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ticketButton setTitle:@"10元券" forState:UIControlStateNormal];
    [ticketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    //    ticketButton.backgroundColor = QHMainColor;
    [ticketButton setBackgroundImage:ImageWithNamed(@"3元券bg") forState:UIControlStateNormal];
    ticketButton.titleLabel.font = TextFont(12);
    ticketButton.layer.cornerRadius = 3;
    ticketButton.layer.masksToBounds = YES;
    [self.contentView addSubview:ticketButton];
    self.ticketButton = ticketButton;
    
    [self addTbConstraints];
}
#pragma mark - Layout

- (void)addZYConstraints {
    
    self.discountPriceLabel.hidden = YES;
    self.ticketButton.hidden = YES;
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.height.mas_equalTo(SCREEN_WIDTH * 0.5 - AUTOSIZESCALEX(20));
    }];
    
    [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.iconImageView);
        make.height.mas_equalTo(AUTOSIZESCALEX(36));
        make.width.mas_equalTo(AUTOSIZESCALEX(36));
    }];
        
    [self.mineCommisionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(4));
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
    [self.mineCommisionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.right.mas_equalTo(self.mineCommisionLabel.mas_right).mas_offset(6);
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
    [self.collectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(-10));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.ticketTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(-0.5));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(15);
    }];
    
    //    [self.discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    //        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
    //    }];
    //
    //    [self.ticketButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
    //        make.centerY.equalTo(self.discountPriceLabel);
    //        make.width.mas_equalTo(55);
    //        make.height.mas_equalTo(20);
    //    }];
    
    [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.mas_bottom).offset(AUTOSIZESCALEX(-10));
    }];
    
    [self.salesCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.centerY.equalTo(self.originalPriceLabel);
    }];
}

- (void)addTbConstraints {
    self.discountPriceLabel.hidden = NO;
    self.ticketButton.hidden = NO;
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.height.mas_equalTo(SCREEN_WIDTH * 0.5 - AUTOSIZESCALEX(20));
    }];
    
    [self.playButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.iconImageView);
        make.height.mas_equalTo(AUTOSIZESCALEX(36));
        make.width.mas_equalTo(AUTOSIZESCALEX(36));
    }];
    
    [self.mineCommisionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
    [self.mineCommisionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.right.mas_equalTo(self.mineCommisionLabel.mas_right).mas_offset(10);
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
    [self.collectedButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(-10));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.ticketTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(-0.5));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(15);
    }];
    
    [self.discountPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.ticketButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.centerY.equalTo(self.discountPriceLabel);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(20);
    }];
    
    [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.discountPriceLabel.mas_top).offset(AUTOSIZESCALEX(-10));
    }];
    
    [self.salesCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ticketButton).offset(AUTOSIZESCALEX(0));
        make.centerY.equalTo(self.originalPriceLabel);
    }];
    
}

#pragma mark-
- (void)setSearchGoodsItem:(SearchGoodsItem *)searchGoodsItem
{
    _searchGoodsItem = searchGoodsItem;
    if ([searchGoodsItem.type isEqualToString:@"2"]) {
//        self.ticketTypeLabel.text = @"淘宝";
//        self.ticketTypeLabel.backgroundColor = ColorWithHexString(@"F06E35");
//        [self setupTbUI];
        [self addTbConstraints];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_searchGoodsItem.cover] placeholderImage:PlaceHolderMainImage];
        //        self.titleLabel.text = [NSString stringWithFormat:@"          %@",_item.name];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"          %@",_searchGoodsItem.title]];
        text.yy_lineSpacing = AUTOSIZESCALEX(5);
        self.titleLabel.attributedText = text;
        
        // 宝贝类型，1-淘宝 2-天猫
//        if (_item.type == 1) {
            self.ticketTypeLabel.text = @"淘宝";
            self.ticketTypeLabel.backgroundColor = ColorWithHexString(@"F06E35");
//        } else {
//            self.ticketTypeLabel.text = @"天猫";
//            self.ticketTypeLabel.backgroundColor = ColorWithHexString(@"CC0C0C");
//        }
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@",_searchGoodsItem.price_old]];
        [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
        self.originalPriceLabel.attributedText = attribtStr;
        self.discountPriceLabel.text = [NSString stringWithFormat:@"券后价 ¥ %@",_searchGoodsItem.price];
        [self.ticketButton setTitle:[NSString stringWithFormat:@"%@元券",_searchGoodsItem.quan] forState:UIControlStateNormal];
//        self.salesCountLabel.text = [NSString stringWithFormat:@"月销 %zd",_searchGoodsItem.sellNum];
        self.salesCountLabel.text = [NSString stringWithFormat:@"月销 %@",searchGoodsItem.volume];
        self.mineCommisionLabel.text = [NSString stringWithFormat:@"预估麦穗 %.2ld",(long)_searchGoodsItem.maisui];
    } else {
//        self.ticketTypeLabel.text = @"天猫";
//        self.ticketTypeLabel.backgroundColor = ColorWithHexString(@"CC0C0C");
//        [self setupZiyingUI];
        [self addZYConstraints];
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_searchGoodsItem.cover] placeholderImage:PlaceHolderMainImage];
        //        self.titleLabel.text = [NSString stringWithFormat:@"          %@",_item.name];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"          %@",_searchGoodsItem.title]];
        text.yy_lineSpacing = AUTOSIZESCALEX(5);
        self.titleLabel.attributedText = text;
        
        // 宝贝类型，1-淘宝 2-天猫
        //        if (_item.type == 1) {
//        self.ticketTypeLabel.text = _searchGoodsItem.sort_des;
        //            self.ticketTypeLabel.backgroundColor = ColorWithHexString(@"F06E35");
        //        } else {
        //            self.ticketTypeLabel.text = @"天猫";
        //            self.ticketTypeLabel.backgroundColor = ColorWithHexString(@"CC0C0C");
        //        }
        //        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %.2f",_item.present_price]];
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@",_searchGoodsItem.price]];
        [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
        self.originalPriceLabel.attributedText = attribtStr;
        //        self.discountPriceLabel.text = [NSString stringWithFormat:@"券后价 ¥ %.2f",_item.discountPrice];
        //        [self.ticketButton setTitle:[NSString stringWithFormat:@"%@元券",_item.couponAmount] forState:UIControlStateNormal];
                self.salesCountLabel.text = [NSString stringWithFormat:@"月销 %zd",searchGoodsItem.volume];
        self.salesCountLabel.text = _searchGoodsItem.price_old;
        self.salesCountLabel.textColor = [UIColor redColor];
        NSInteger mineCommision = _searchGoodsItem.maisui ;
        if (mineCommision ==0) {
            self.mineCommisionView.hidden = YES;
            self.mineCommisionLabel.hidden = YES;
        }else{
            self.mineCommisionView.hidden = NO;
            self.mineCommisionLabel.hidden = NO;
            self.mineCommisionLabel.text = [NSString stringWithFormat:@"预估麦穗 %.2ld",(long)mineCommision];
        }
    }
}
@end
