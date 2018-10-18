//
//  MemberRankSecondSectionCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MemberRankSecondSectionCell.h"
#import "MemberRankItem.h"

@interface MemberRankSecondSectionCell ()

@property(nonatomic,strong) UILabel *rankNoLabel;
@property(nonatomic,strong) UIImageView *iconImageView;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *rewardLabel;
@property(nonatomic,strong) UIView *line;

@end

@implementation MemberRankSecondSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *rankNoLabel = [[UILabel alloc] init];
    rankNoLabel.textColor = ColorWithHexString(@"#333333");
    rankNoLabel.font = TextFont(12);
    rankNoLabel.text = @"NO.4";
    [self.contentView addSubview:rankNoLabel];
    self.rankNoLabel = rankNoLabel;
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.cornerRadius = AUTOSIZESCALEX(20);
    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = PlaceHolderImage;
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = ColorWithHexString(@"#333333");
    nameLabel.font = TextFont(12);
    nameLabel.text = @"皮皮蛋蛋";
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *rewardLabel = [[UILabel alloc] init];
    rewardLabel.textColor = ColorWithHexString(@"#333333");
    rewardLabel.font = TextFont(12);
    rewardLabel.text = @"奖励：500.0";
    [self.contentView addSubview:rewardLabel];
    self.rewardLabel = rewardLabel;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.rankNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
    }];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(65));
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(40), AUTOSIZESCALEX(40)));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Setter

- (void)setIndex:(NSInteger)index {
    _index = index;
}

- (void)setItem:(MemberRankItem *)item {
    _item = item;
    if (_item) {
        self.rankNoLabel.text = [NSString stringWithFormat:@"NO.%zd",self.index];
        [self.iconImageView wy_setImageWithUrlString:_item.headpicUrl placeholderImage:PlaceHolderImage];
        self.nameLabel.text = _item.nickname;
        NSString *money = [NSString stringWithFormat:@"%.2f",[_item.money floatValue]];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖励：%@",money]];
        [attribute addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"#FF1848") range:NSMakeRange(3, money.length)];
        self.rewardLabel.attributedText = attribute;

//        self.rewardLabel.text = [NSString stringWithFormat:@"奖励：%@",_item.money];
    }
}

@end
