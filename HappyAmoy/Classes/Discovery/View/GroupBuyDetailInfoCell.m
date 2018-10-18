//
//  GroupBuyDetailInfoCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupBuyDetailInfoCell.h"
#import "GroupBuyDetailItem.h"

@interface GroupBuyDetailInfoCell ()

/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    已拼    */
@property(nonatomic,strong) UILabel *alreadyLabel;
/**    剩余    */
@property(nonatomic,strong) UILabel *remainLabel;
/**    拼团价    */
@property(nonatomic,strong) UILabel *priceLabel;
/**    说明1    */
@property(nonatomic,strong) UILabel *descLabel1;
/**    说明2    */
@property(nonatomic,strong) UILabel *descLabel2;
/**    说明3    */
@property(nonatomic,strong) UILabel *descLabel3;
/**    说明4    */
@property(nonatomic,strong) UILabel *descLabel4;

@end

@implementation GroupBuyDetailInfoCell

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
    titleLabel.textColor = ColorWithHexString(@"#000000");
    titleLabel.font = TextFont(14);
    titleLabel.text = @"山东红富士苹果 4斤";
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *alreadyLabel = [[UILabel alloc] init];
    alreadyLabel.textColor = ColorWithHexString(@"#393737");
    alreadyLabel.font = TextFont(13);
    alreadyLabel.text = @"已拼：1250";
    [self.contentView addSubview:alreadyLabel];
    self.alreadyLabel = alreadyLabel;
    
    UILabel *remainLabel = [[UILabel alloc] init];
    remainLabel.textColor = ColorWithHexString(@"#393737");
    remainLabel.font = TextFont(13);
    remainLabel.text = @"剩余：520";
    [self.contentView addSubview:remainLabel];
    self.remainLabel = remainLabel;

    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = ColorWithHexString(@"#F54C4C");
    priceLabel.font = TextFont(14);
    priceLabel.text = @"拼团价：￥0";
    [self.contentView addSubview:priceLabel];
    self.priceLabel = priceLabel;

    UILabel *descLabel1 = [[UILabel alloc] init];
    descLabel1.textColor = ColorWithHexString(@"#999999");
    descLabel1.font = TextFont(13);
    descLabel1.text = @"正品保障";
    [self.contentView addSubview:descLabel1];
    self.descLabel1 = descLabel1;

    UILabel *descLabel2 = [[UILabel alloc] init];
    descLabel2.textColor = ColorWithHexString(@"#999999");
    descLabel2.font = TextFont(13);
    descLabel2.text = @"全新商品";
    [self.contentView addSubview:descLabel2];
    self.descLabel2 = descLabel2;

    UILabel *descLabel3 = [[UILabel alloc] init];
    descLabel3.textColor = ColorWithHexString(@"#999999");
    descLabel3.font = TextFont(13);
    descLabel3.text = @"全国包邮";
    [self.contentView addSubview:descLabel3];
    self.descLabel3 = descLabel3;

    UILabel *descLabel4 = [[UILabel alloc] init];
    descLabel4.textColor = ColorWithHexString(@"#999999");
    descLabel4.font = TextFont(13);
    descLabel4.text = @"快速发货";
    [self.contentView addSubview:descLabel4];
    self.descLabel4 = descLabel4;

    [self addConstraints];
}

#pragma mark - Layout
- (void)addConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
    [self.alreadyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(13));
    }];
    
    [self.remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.alreadyLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(112));
        make.height.equalTo(self.alreadyLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.alreadyLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];

    [self.descLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alreadyLabel.mas_bottom).offset(AUTOSIZESCALEX(17));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(13));
    }];
    
    [self.descLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.descLabel1).offset(AUTOSIZESCALEX(0));
        make.centerX.equalTo(self.contentView).multipliedBy(0.75);
        make.height.equalTo(self.descLabel1);
    }];

    [self.descLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.descLabel1).offset(AUTOSIZESCALEX(0));
        make.centerX.equalTo(self.contentView).multipliedBy(1.25);
        make.height.equalTo(self.descLabel1);
    }];

    [self.descLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.descLabel1).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.equalTo(self.descLabel1);
    }];
}

#pragma mark - Setter

- (void)setItem:(GroupBuyDetailItem *)item {
    _item = item;
    if (_item) {
        self.titleLabel.text = _item.name;
        self.alreadyLabel.text = [NSString stringWithFormat:@"已拼：%zd",_item.groupNum];
        self.remainLabel.text = [NSString stringWithFormat:@"剩余：%zd",_item.stock];
        
        if ([NSString isEmpty:_item.labels]) {
            self.descLabel1.hidden = self.descLabel2.hidden = self.descLabel3.hidden = self.descLabel4.hidden = YES;
        } else {
            self.descLabel1.hidden = self.descLabel2.hidden = self.descLabel3.hidden = self.descLabel4.hidden = NO;

            if ([_item.labels containsString:@","]) {
                NSArray *labels = [_item.labels componentsSeparatedByString:@","];
                if (labels.count >= 4) {
                    self.descLabel1.text = labels[0];
                    self.descLabel2.text = labels[1];
                    self.descLabel3.text = labels[2];
                    self.descLabel4.text = labels[3];
                } else if (labels.count == 3) {
                    self.descLabel1.text = labels[0];
                    self.descLabel2.text = labels[1];
                    self.descLabel3.text = labels[2];
                    self.descLabel4.hidden = YES;
                } else if (labels.count == 2) {
                    self.descLabel1.text = labels[0];
                    self.descLabel2.text = labels[1];
                    self.descLabel3.hidden = YES;
                    self.descLabel4.hidden = YES;
                }
            } else {
                self.descLabel1.text = _item.labels;
            }
        }
    }
}

@end
