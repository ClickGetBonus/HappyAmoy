//
//  ExchangeGoodsCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeGoodsCell.h"
#import "SwapGoogsListItem.h"

@interface ExchangeGoodsCell ()

/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    横线    */
@property(nonatomic,strong) UIView *line;
/**    图片    */
@property(nonatomic,strong) UIImageView *goodsImageView;
/**    商品    */
@property(nonatomic,strong) UILabel *goodsLabel;
/**    金豆    */
@property(nonatomic,strong) UILabel *goldLabel;
/**    数量    */
@property(nonatomic,strong) UILabel *countLabel;

@end

@implementation ExchangeGoodsCell

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
    titleLabel.textColor = ColorWithHexString(@"#333333");
    titleLabel.font = TextFont(14);
    titleLabel.text = @"兑换商品";
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ColorWithHexString(@"#CCCCCC");
    [self.contentView addSubview:line];
    self.line = line;
    
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    goodsImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"省惠拼团banner") imageViewSize:CGSizeMake(AUTOSIZESCALEX(70), AUTOSIZESCALEX(70))];
    [self.contentView addSubview:goodsImageView];
    self.goodsImageView = goodsImageView;

    UILabel *goodsLabel = [[UILabel alloc] init];
    goodsLabel.textColor = ColorWithHexString(@"#333333");
    goodsLabel.font = TextFont(14);
    goodsLabel.text = @"爱奇艺VIP会员一个月";
    [self.contentView addSubview:goodsLabel];
    self.goodsLabel = goodsLabel;

    UILabel *goldLabel = [[UILabel alloc] init];
    goldLabel.textColor = ColorWithHexString(@"#FB4F67");
    goldLabel.font = TextFont(14);
    goldLabel.text = @"兑换：199金豆";
    [self.contentView addSubview:goldLabel];
    self.goldLabel = goldLabel;
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = ColorWithHexString(@"#333333");
    countLabel.font = TextFont(14);
    countLabel.text = @"x1";
    [self.contentView addSubview:countLabel];
    self.countLabel = countLabel;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(18));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(18));
        make.left.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(0.5));
    }];

    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(AUTOSIZESCALEX(13));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(70));
        make.height.mas_equalTo(AUTOSIZESCALEX(70));
    }];
    
    [self.goodsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(AUTOSIZESCALEX(26));
        make.left.equalTo(self.goodsImageView.mas_right).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
    [self.goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-26));
        make.left.equalTo(self.goodsLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.goldLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-60));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];

}

#pragma mark - Setter

- (void)setItem:(SwapGoogsListItem *)item {
    _item = item;
    if (_item) {
        [self.goodsImageView wy_setImageWithUrlString:_item.iconUrl placeholderImage:PlaceHolderMainImage];
        self.goodsLabel.text = _item.name;
        self.goldLabel.text = [NSString stringWithFormat:@"兑换：%zd麦粒",_item.score];
    }
}

@end
