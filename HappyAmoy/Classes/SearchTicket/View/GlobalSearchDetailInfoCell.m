//
//  GlobalSearchDetailInfoCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GlobalSearchDetailInfoCell.h"
#import "TaoBaoSearchItem.h"

@interface GlobalSearchDetailInfoCell ()

/**    包邮    */
@property (strong, nonatomic) UIButton *shipButton;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    折扣价    */
@property (strong, nonatomic) UILabel *discountPriceLabel;
/**    成交量    */
@property (strong, nonatomic) UILabel *volumeLabel;

@end

@implementation GlobalSearchDetailInfoCell

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
    titleLabel.numberOfLines = 2;
    titleLabel.font = TextFont(14);
    titleLabel.textColor = ColorWithHexString(@"333333");
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: @"           抢！双十一邀请爆款返场2小时！高领羊绒套头毛衣针织衫"];
    text.yy_lineSpacing = AUTOSIZESCALEX(10);
    titleLabel.attributedText = text;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIButton *shipButton = [[UIButton alloc] init];
    shipButton.layer.cornerRadius = 3;
    shipButton.layer.masksToBounds = YES;
    [shipButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(35), AUTOSIZESCALEX(18)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    shipButton.titleLabel.font = TextFont(13);
    [shipButton setTitle:@"包邮" forState:UIControlStateNormal];
    [shipButton setTintColor:QHWhiteColor];
    [self.contentView addSubview:shipButton];
    self.shipButton = shipButton;
    
    UILabel *discountPriceLabel = [[UILabel alloc] init];
    discountPriceLabel.text = @"￥88.00";
    discountPriceLabel.font = TextFont(14);
    discountPriceLabel.textColor = QHMainColor;
    [self.contentView addSubview:discountPriceLabel];
    self.discountPriceLabel = discountPriceLabel;
    
    UILabel *volumeLabel = [[UILabel alloc] init];
    volumeLabel.text = @"629笔成交";
    volumeLabel.font = TextFont(14);
    volumeLabel.textColor = ColorWithHexString(@"#666666");
    [self.contentView addSubview:volumeLabel];
    self.volumeLabel = volumeLabel;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
    }];
    
    [self.shipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(18);
    }];
    
    [self.discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(15);
    }];
    
    [self.volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.discountPriceLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(15);
    }];
}

#pragma mark - Setter

- (void)setSearchItem:(TaoBaoSearchItem *)searchItem {
    _searchItem = searchItem;
    if (_searchItem) {
        // 默认包邮
        self.shipButton.hidden = NO;
//        self.titleLabel.text = [NSString stringWithFormat:@"           %@",_searchItem.title];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"           %@",_searchItem.title]];
        text.yy_lineSpacing = AUTOSIZESCALEX(7);
        self.titleLabel.textColor = ColorWithHexString(@"333333");
        self.titleLabel.attributedText = text;

        self.discountPriceLabel.text = [NSString stringWithFormat:@"¥ %.2f",_searchItem.afterCouponPrice];
        self.volumeLabel.text = [NSString stringWithFormat:@"%zd笔成交",_searchItem.biz30Day];
    }
}

// 处理后台返回的时间
- (NSString *)handleDate:(NSString *)date {
    if ([NSString isEmpty:date]) {
        return @"";
    } else {
        if ([date containsString:@" 00:00"]) {
            return [date stringByReplacingOccurrencesOfString:@" 00:00" withString:@""];
        }
    }
    return date;
}


@end
