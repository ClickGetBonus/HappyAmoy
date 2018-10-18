//
//  BrandAreaChildCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BrandAreaChildCell.h"
#import "CommodityListItem.h"

@interface BrandAreaChildCell()

/**    图标    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    折扣价    */
@property (strong, nonatomic) UILabel *discountPriceLabel;
/**    优惠券    */
@property (strong, nonatomic) UIButton *ticketButton;

@end

@implementation BrandAreaChildCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        
        self.contentView.layer.borderColor = QHMainColor.CGColor;
        self.contentView.layer.borderWidth = SeparatorLineHeight;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"appIcon_small") imageViewSize:CGSizeMake(AUTOSIZESCALEX(120), AUTOSIZESCALEX(120))];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ticketButton setTitle:@"领券减50元" forState:UIControlStateNormal];
    [ticketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
//    ticketButton.backgroundColor = QHMainColor;
    [ticketButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(75), AUTOSIZESCALEX(15)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    ticketButton.titleLabel.font = TextFont(10);
    ticketButton.layer.cornerRadius = 3;
    ticketButton.layer.masksToBounds = YES;
    [self.contentView addSubview:ticketButton];
    self.ticketButton = ticketButton;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.font = TextFont(12);
    titleLabel.textColor = ColorWithHexString(@"333333");
    titleLabel.text = @"周生生小巧玲珑真金女款佩带好看";
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *discountPriceLabel = [[UILabel alloc] init];
    discountPriceLabel.text = @"券后价 ¥ 49.00";
    discountPriceLabel.font = TextFont(12);
    discountPriceLabel.textColor = QHMainColor;
    [self.contentView addSubview:discountPriceLabel];
    self.discountPriceLabel = discountPriceLabel;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(5));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(5));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-5));
        make.height.mas_equalTo((SCREEN_WIDTH - AUTOSIZESCALEX(30) - AUTOSIZESCALEX(60)) * 0.5 - AUTOSIZESCALEX(10));
    }];
    
    [self.ticketButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ticketButton.mas_bottom).offset(AUTOSIZESCALEX(7.5));
        make.left.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
    }];
    
}

#pragma mark - Setter

- (void)setItem:(CommodityListItem *)item {
    _item = item;
    
    if (_item) {
        [self.iconImageView wy_setImageWithUrlString:_item.iconUrl placeholderImage:PlaceHolderMainImage];
        self.titleLabel.text = _item.name;
        [self.ticketButton setTitle:[NSString stringWithFormat:@"领券减%@元",_item.couponAmount] forState:UIControlStateNormal];
        self.discountPriceLabel.text = [NSString stringWithFormat:@"券后价 ¥ %.2f",_item.discountPrice];
    }
}

@end
