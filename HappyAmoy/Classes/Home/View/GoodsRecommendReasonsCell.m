//
//  GoodsRecommendReasonsCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsRecommendReasonsCell.h"
#import "CommodityDetailItem.h"

@interface GoodsRecommendReasonsCell()

/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation GoodsRecommendReasonsCell

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
    titleLabel.numberOfLines = 0;
    titleLabel.font = TextFont(15);
    titleLabel.textColor = RGB(85, 85, 85);
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: @"抢！双十一邀请爆款返场2小时！高领羊绒套头毛衣针织衫"];
    text.yy_lineSpacing = AUTOSIZESCALEX(5);
    titleLabel.attributedText = text;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
}

#pragma mark - Setter

- (void)setItem:(CommodityDetailItem *)item {
    _item = item;
    if (_item) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",_item.summary];
    }
}


@end
