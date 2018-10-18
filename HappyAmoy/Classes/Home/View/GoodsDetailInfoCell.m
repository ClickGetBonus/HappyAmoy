//
//  GoodsDetailInfoCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsDetailInfoCell.h"
#import "CommodityDetailItem.h"
#import "TaoBaoSearchItem.h"

@interface GoodsDetailInfoCell()

/**    包邮    */
@property (strong, nonatomic) UIButton *shipButton;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    原价    */
@property (strong, nonatomic) UILabel *originalPriceLabel;
/**    折扣价    */
@property (strong, nonatomic) UILabel *discountPriceLabel;
/**    成交量    */
@property (strong, nonatomic) UILabel *volumeLabel;
/**    券额    */
@property (strong, nonatomic) UILabel *ticketAmountLabel;
/**    使用期限    */
@property (strong, nonatomic) UILabel *deadlineLabel;
/**    立即领券    */
@property (strong, nonatomic) UILabel *takeTicketLabel;
/**    领券按钮    */
@property (strong, nonatomic) UIButton *ticketButton;
/**    竖线    */
//@property (strong, nonatomic) UIView *line;

@end

@implementation GoodsDetailInfoCell

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
    titleLabel.font = TextFont(15);
    titleLabel.textColor = RGB(85, 85, 85);
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: @""];
    text.yy_lineSpacing = AUTOSIZESCALEX(5);
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

    UILabel *originalPriceLabel = [[UILabel alloc] init];
    // 加横线
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString: @"原价 ¥ "];
    [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
    originalPriceLabel.attributedText = attribtStr;
    originalPriceLabel.font = TextFont(14);
    originalPriceLabel.textColor = RGB(160, 160, 160);
    [self.contentView addSubview:originalPriceLabel];
    self.originalPriceLabel = originalPriceLabel;

    UILabel *discountPriceLabel = [[UILabel alloc] init];
    discountPriceLabel.text = @"券后价 ¥ ";
    discountPriceLabel.font = TextFont(14);
    discountPriceLabel.textColor = QHPriceColor;
    [self.contentView addSubview:discountPriceLabel];
    self.discountPriceLabel = discountPriceLabel;
    
    UILabel *volumeLabel = [[UILabel alloc] init];
    volumeLabel.text = @"";
    volumeLabel.font = TextFont(14);
    volumeLabel.textColor = RGB(90, 90, 90);
    [self.contentView addSubview:volumeLabel];
    self.volumeLabel = volumeLabel;
    
    WeakSelf
    UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    ticketButton.backgroundColor = QHMainColor;
//    ticketButton.layer.cornerRadius = 3;
//    ticketButton.layer.masksToBounds = YES;
    [ticketButton setBackgroundImage:ImageWithNamed(@"200元优惠券bg") forState:UIControlStateNormal];
    [[ticketButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([weakSelf.delegate respondsToSelector:@selector(goodsDetailInfoCell:takeTicket:)]) {
            [weakSelf.delegate goodsDetailInfoCell:weakSelf takeTicket:weakSelf.item];
        }
    }];
    [self.contentView addSubview:ticketButton];
    self.ticketButton = ticketButton;
    
    UILabel *ticketAmountLabel = [[UILabel alloc] init];
    ticketAmountLabel.text = @"";
    ticketAmountLabel.font = TextFont(16);
    ticketAmountLabel.textColor = ColorWithHexString(@"FAF5F5");
    [self.ticketButton addSubview:ticketAmountLabel];
    self.ticketAmountLabel = ticketAmountLabel;

    UILabel *deadlineLabel = [[UILabel alloc] init];
    deadlineLabel.text = @"";
    deadlineLabel.font = TextFont(11);
    deadlineLabel.textColor = ColorWithHexString(@"FAF5F5");
    [self.ticketButton addSubview:deadlineLabel];
    self.deadlineLabel = deadlineLabel;

    UILabel *takeTicketLabel = [[UILabel alloc] init];
    takeTicketLabel.text = @"立即领券";
    takeTicketLabel.font = TextFont(13);
    takeTicketLabel.textColor = ColorWithHexString(@"F5F5F5");
    [self.ticketButton addSubview:takeTicketLabel];
    self.takeTicketLabel = takeTicketLabel;

//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = QHWhiteColor;
//    [self.ticketButton addSubview:line];
//    self.line = line;

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
    
    [self.ticketButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(68);
    }];
    
    [self.ticketAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ticketButton).offset(AUTOSIZESCALEX(12.5));
        make.centerX.equalTo(self.ticketButton).offset(AUTOSIZESCALEX(-45));
    }];
    
    [self.deadlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ticketAmountLabel.mas_bottom).offset(AUTOSIZESCALEX(7.5));
        make.centerX.equalTo(self.ticketAmountLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.takeTicketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.ticketButton).offset(AUTOSIZESCALEX(-20));
        make.centerY.equalTo(self.ticketButton).offset(AUTOSIZESCALEX(0));
    }];
    
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.takeTicketLabel.mas_left).offset(AUTOSIZESCALEX(-20));
//        make.centerY.equalTo(self.ticketButton).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(SeparatorLineHeight);
//        make.height.mas_equalTo(40);
//    }];
    
    [self.discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ticketButton.mas_top).offset(AUTOSIZESCALEX(-15));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.discountPriceLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.ticketButton).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.discountPriceLabel.mas_top).offset(AUTOSIZESCALEX(-10));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
    }];
}

#pragma mark - Setter

- (void)setItem:(CommodityDetailItem *)item {
    _item = item;
    if (_item) {
        if (_item.freeShip == 1) { // 包邮
            self.shipButton.hidden = NO;
            self.titleLabel.text = [NSString stringWithFormat:@"           %@",_item.name];
        } else {
            self.shipButton.hidden = YES;
            self.titleLabel.text = [NSString stringWithFormat:@"%@",_item.name];
        }
        self.discountPriceLabel.text = [NSString stringWithFormat:@"券后价 ¥ %.2f",_item.discountPrice];
        self.volumeLabel.text = [NSString stringWithFormat:@"%zd笔成交",_item.sellNum];
        self.ticketAmountLabel.text = [NSString stringWithFormat:@"%@元优惠券",_item.couponAmount];
        self.deadlineLabel.text = [NSString stringWithFormat:@"使用期限：%@-%@",[self handleDate:_item.couponStartDate],[self handleDate:_item.couponEndDate]];
        
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"原价 ¥ %.2f",_item.price]];
        [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
        self.originalPriceLabel.attributedText = attribtStr;

    }
}

- (void)setSearchItem:(TaoBaoSearchItem *)searchItem {
    _searchItem = searchItem;
    if (_searchItem) {
        // 默认包邮
        self.shipButton.hidden = NO;
        self.titleLabel.text = [NSString stringWithFormat:@"           %@",_searchItem.title];
        
        self.discountPriceLabel.text = [NSString stringWithFormat:@"券后价 ¥ %.2f",_searchItem.afterCouponPrice];
        self.volumeLabel.text = [NSString stringWithFormat:@"%zd笔成交",_searchItem.biz30Day];
        self.ticketAmountLabel.text = [NSString stringWithFormat:@"%.0f元优惠券",_searchItem.couponPrice];
//        self.deadlineLabel.text = [NSString stringWithFormat:@"使用期限：%@-%@",[self handleDate:_item.couponStartDate],[self handleDate:_item.couponEndDate]];
        
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"原价 ¥ %.2f",_searchItem.currentPrice]];
        [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
        self.originalPriceLabel.attributedText = attribtStr;
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
