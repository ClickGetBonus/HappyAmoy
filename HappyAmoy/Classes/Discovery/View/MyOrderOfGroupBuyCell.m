//
//  MyOrderOfGroupBuyCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyOrderOfGroupBuyCell.h"
#import "GroupOrderItem.h"

@interface MyOrderOfGroupBuyCell ()

/**    图片    */
@property(nonatomic,strong) UIImageView *iconImageVIew;
/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    拼团价    */
@property(nonatomic,strong) UILabel *groupBuyPriceLabel;
/**    状态    */
@property(nonatomic,strong) UILabel *statusLabel;
/**    分割线    */
@property(nonatomic,strong) UIView *line;

@end

@implementation MyOrderOfGroupBuyCell

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
    iconImageVIew.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"省惠拼团banner") imageViewSize:CGSizeMake(AUTOSIZESCALEX(70), AUTOSIZESCALEX(70))];
    [self.contentView addSubview:iconImageVIew];
    self.iconImageVIew = iconImageVIew;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = ColorWithHexString(@"#333333");
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
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;

    UILabel *statusLabel = [[UILabel alloc] init];
    statusLabel.textColor = ColorWithHexString(@"#666666");
    statusLabel.font = TextFont(14);
    statusLabel.text = @"进行中";
    [self.contentView addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(12.5));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(70));
        make.height.mas_equalTo(AUTOSIZESCALEX(70));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageVIew).offset(AUTOSIZESCALEX(11));
        make.left.equalTo(self.iconImageVIew.mas_right).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
    [self.groupBuyPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageVIew.mas_bottom).offset(AUTOSIZESCALEX(-11));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(95));
        make.height.mas_equalTo(AUTOSIZESCALEX(0.5));
    }];

    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(AUTOSIZESCALEX(18));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-17));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
}

#pragma mark - Setter
- (void)setItem:(GroupOrderItem *)item {
    _item = item;
    if (_item) {
        [self.iconImageVIew wy_setImageWithUrlString:_item.iconUrl placeholderImage:PlaceHolderMainImage];
        self.titleLabel.text = _item.groupName;
        switch (_item.status) {
            case 0: { // 进行中
                self.statusLabel.text = @"进行中";
                self.statusLabel.textColor = ColorWithHexString(@"#666666");
            }
                break;
            case 1: { // 成功
                self.statusLabel.text = @"拼团成功";
                self.statusLabel.textColor = QHMainColor;
            }
                break;
            case 2: { // 失败
                self.statusLabel.text = @"拼团失败";
                self.statusLabel.textColor = ColorWithHexString(@"#666666");
            }
                break;
            case 3: { // 取消
                self.statusLabel.text = @"已取消";
                self.statusLabel.textColor = ColorWithHexString(@"#666666");
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - Button Action
// 立即兑换
- (void)didClickJoinButton {
    WYFunc
}


@end
