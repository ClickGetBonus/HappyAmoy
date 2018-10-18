//
//  MemberRankFirstSectionCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MemberRankFirstSectionCell.h"
#import "MemberRankItem.h"

@interface MemberRankFirstSectionCell ()

@property(nonatomic,strong) UIImageView *bgImageView;

@property(nonatomic,strong) UIView *NO1ContainerView;
@property(nonatomic,strong) UIImageView *NO1CrownImageView;
@property(nonatomic,strong) UIImageView *NO1IconImageView;
@property(nonatomic,strong) UIImageView *NO1ImageView;
@property(nonatomic,strong) UILabel *NO1NameLabel;
@property(nonatomic,strong) UILabel *NO1RewardLabel;

@property(nonatomic,strong) UIView *NO2ContainerView;
@property(nonatomic,strong) UIImageView *NO2CrownImageView;
@property(nonatomic,strong) UIImageView *NO2IconImageView;
@property(nonatomic,strong) UIImageView *NO2ImageView;
@property(nonatomic,strong) UILabel *NO2NameLabel;
@property(nonatomic,strong) UILabel *NO2RewardLabel;

@property(nonatomic,strong) UIView *NO3ContainerView;
@property(nonatomic,strong) UIImageView *NO3CrownImageView;
@property(nonatomic,strong) UIImageView *NO3IconImageView;
@property(nonatomic,strong) UIImageView *NO3ImageView;
@property(nonatomic,strong) UILabel *NO3NameLabel;
@property(nonatomic,strong) UILabel *NO3RewardLabel;

@end

@implementation MemberRankFirstSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ViewControllerBackgroundColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = ImageWithNamed(@"会员背景");
    [self.contentView addSubview:bgImageView];
    self.bgImageView = bgImageView;
    // NO1
    UIView *NO1ContainerView = [[UIView alloc] init];
    NO1ContainerView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:NO1ContainerView];
    self.NO1ContainerView = NO1ContainerView;
    
    UIImageView *NO1CrownImageView = [[UIImageView alloc] init];
    NO1CrownImageView.image = ImageWithNamed(@"NO1_Crown");
    [self.NO1ContainerView addSubview:NO1CrownImageView];
    self.NO1CrownImageView = NO1CrownImageView;

    UIImageView *NO1IconImageView = [[UIImageView alloc] init];
    NO1IconImageView.image = PlaceHolderImage;
    NO1IconImageView.layer.cornerRadius = AUTOSIZESCALEX(27.5);
    NO1IconImageView.layer.masksToBounds = YES;
    [self.NO1ContainerView addSubview:NO1IconImageView];
    self.NO1IconImageView = NO1IconImageView;

    UIImageView *NO1ImageView = [[UIImageView alloc] init];
    NO1ImageView.image = ImageWithNamed(@"NO1");
    [self.NO1ContainerView addSubview:NO1ImageView];
    self.NO1ImageView = NO1ImageView;

    UILabel *NO1NameLabel = [[UILabel alloc] init];
    NO1NameLabel.numberOfLines = 2;
    NO1NameLabel.textColor = ColorWithHexString(@"#4C4B4B");
    NO1NameLabel.font = TextFont(12);
    NO1NameLabel.text = @"冰冰小仙女";
    NO1NameLabel.textAlignment = NSTextAlignmentCenter;
    [self.NO1ContainerView addSubview:NO1NameLabel];
    self.NO1NameLabel = NO1NameLabel;
    
    UILabel *NO1RewardLabel = [[UILabel alloc] init];
    NO1RewardLabel.textColor = ColorWithHexString(@"#333333");
    NO1RewardLabel.font = TextFont(12);
    NO1RewardLabel.text = @"奖励：888.88";
    [self.NO1ContainerView addSubview:NO1RewardLabel];
    self.NO1RewardLabel = NO1RewardLabel;

    // NO2
    UIView *NO2ContainerView = [[UIView alloc] init];
    NO2ContainerView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:NO2ContainerView];
    self.NO2ContainerView = NO2ContainerView;
    
    UIImageView *NO2CrownImageView = [[UIImageView alloc] init];
    NO2CrownImageView.image = ImageWithNamed(@"NO2_Crown");
    [self.NO2ContainerView addSubview:NO2CrownImageView];
    self.NO2CrownImageView = NO2CrownImageView;
    
    UIImageView *NO2IconImageView = [[UIImageView alloc] init];
    NO2IconImageView.image = PlaceHolderImage;
    NO2IconImageView.layer.cornerRadius = AUTOSIZESCALEX(25);
    NO2IconImageView.layer.masksToBounds = YES;
    [self.NO2ContainerView addSubview:NO2IconImageView];
    self.NO2IconImageView = NO2IconImageView;
    
    UIImageView *NO2ImageView = [[UIImageView alloc] init];
    NO2ImageView.image = ImageWithNamed(@"NO2");
    [self.NO2ContainerView addSubview:NO2ImageView];
    self.NO2ImageView = NO2ImageView;
    
    UILabel *NO2NameLabel = [[UILabel alloc] init];
    NO2NameLabel.numberOfLines = 2;
    NO2NameLabel.textColor = ColorWithHexString(@"#4C4B4B");
    NO2NameLabel.font = TextFont(12);
    NO2NameLabel.text = @"星星闪烁的一把火";
    NO2NameLabel.textAlignment = NSTextAlignmentCenter;
    [self.NO2ContainerView addSubview:NO2NameLabel];
    self.NO2NameLabel = NO2NameLabel;
    
    UILabel *NO2RewardLabel = [[UILabel alloc] init];
    NO2RewardLabel.textColor = ColorWithHexString(@"#333333");
    NO2RewardLabel.font = TextFont(12);
    NO2RewardLabel.text = @"奖励：666.66";
    [self.NO2ContainerView addSubview:NO2RewardLabel];
    self.NO2RewardLabel = NO2RewardLabel;

    // NO3
    UIView *NO3ContainerView = [[UIView alloc] init];
    NO3ContainerView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:NO3ContainerView];
    self.NO3ContainerView = NO3ContainerView;
    
    UIImageView *NO3CrownImageView = [[UIImageView alloc] init];
    NO3CrownImageView.image = ImageWithNamed(@"NO3_Crown");
    [self.NO3ContainerView addSubview:NO3CrownImageView];
    self.NO3CrownImageView = NO3CrownImageView;
    
    UIImageView *NO3IconImageView = [[UIImageView alloc] init];
    NO3IconImageView.image = PlaceHolderImage;
    NO3IconImageView.layer.cornerRadius = AUTOSIZESCALEX(25);
    NO3IconImageView.layer.masksToBounds = YES;
    [self.NO3ContainerView addSubview:NO3IconImageView];
    self.NO3IconImageView = NO3IconImageView;
    
    UIImageView *NO3ImageView = [[UIImageView alloc] init];
    NO3ImageView.image = ImageWithNamed(@"NO3");
    [self.NO3ContainerView addSubview:NO3ImageView];
    self.NO3ImageView = NO3ImageView;
    
    UILabel *NO3NameLabel = [[UILabel alloc] init];
    NO3NameLabel.numberOfLines = 2;
    NO3NameLabel.textColor = ColorWithHexString(@"#4C4B4B");
    NO3NameLabel.font = TextFont(12);
    NO3NameLabel.text = @"星星闪烁";
    NO3NameLabel.textAlignment = NSTextAlignmentCenter;
    [self.NO3ContainerView addSubview:NO3NameLabel];
    self.NO3NameLabel = NO3NameLabel;
    
    UILabel *NO3RewardLabel = [[UILabel alloc] init];
    NO3RewardLabel.textColor = ColorWithHexString(@"#333333");
    NO3RewardLabel.font = TextFont(12);
    NO3RewardLabel.text = @"奖励：555.55";
    [self.NO3ContainerView addSubview:NO3RewardLabel];
    self.NO3RewardLabel = NO3RewardLabel;

    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    // NO1
    [self.NO1ContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH / 3);
        make.width.mas_equalTo(SCREEN_WIDTH / 3);
    }];

    [self.NO1CrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NO1ContainerView).offset(AUTOSIZESCALEX(8));
        make.right.equalTo(self.NO1ContainerView).offset(AUTOSIZESCALEX(-33));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(24), AUTOSIZESCALEX(20)));
    }];
    
    [self.NO1IconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NO1ContainerView).offset(AUTOSIZESCALEX(15));
        make.centerX.equalTo(self.NO1ContainerView).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(55), AUTOSIZESCALEX(55)));
    }];

    [self.NO1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NO1ContainerView).offset(AUTOSIZESCALEX(62));
        make.centerX.equalTo(self.NO1ContainerView).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(80), AUTOSIZESCALEX(18)));
    }];

    [self.NO1NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.NO1ContainerView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.NO1ImageView.mas_bottom).offset(AUTOSIZESCALEX(13.5));
    }];
    
    [self.NO1RewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.NO1ContainerView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.NO1NameLabel.mas_bottom).offset(AUTOSIZESCALEX(12.5));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
    }];
    
    // NO2
    [self.NO2ContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SCREEN_WIDTH / 3);
    }];
    
    [self.NO2CrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NO2ContainerView).offset(AUTOSIZESCALEX(18));
        make.right.equalTo(self.NO2ContainerView).offset(AUTOSIZESCALEX(-35.5));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(22), AUTOSIZESCALEX(17)));
    }];
    
    [self.NO2IconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NO2ContainerView).offset(AUTOSIZESCALEX(24));
        make.centerX.equalTo(self.NO2ContainerView).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(50)));
    }];
    
    [self.NO2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NO2ContainerView).offset(AUTOSIZESCALEX(67));
        make.centerX.equalTo(self.NO2ContainerView).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(80), AUTOSIZESCALEX(17)));
    }];
    
    [self.NO2NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.NO2ContainerView).offset(AUTOSIZESCALEX(25));
        make.right.equalTo(self.NO2ContainerView).offset(AUTOSIZESCALEX(-25));
        make.top.equalTo(self.NO2ImageView.mas_bottom).offset(AUTOSIZESCALEX(8.5));
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
    [self.NO2RewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.NO2ContainerView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.NO2NameLabel.mas_bottom).offset(AUTOSIZESCALEX(6));
    }];
    
    // NO3
    [self.NO3ContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH / 3 * 2);
        make.width.mas_equalTo(SCREEN_WIDTH / 3);
    }];
    
    [self.NO3CrownImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NO3ContainerView).offset(AUTOSIZESCALEX(18));
        make.right.equalTo(self.NO3ContainerView).offset(AUTOSIZESCALEX(-35.5));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(22), AUTOSIZESCALEX(17)));
    }];
    
    [self.NO3IconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NO3ContainerView).offset(AUTOSIZESCALEX(24));
        make.centerX.equalTo(self.NO3ContainerView).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(50)));
    }];
    
    [self.NO3ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.NO3ContainerView).offset(AUTOSIZESCALEX(67));
        make.centerX.equalTo(self.NO3ContainerView).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(80), AUTOSIZESCALEX(17)));
    }];
    
    [self.NO3NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.NO3ContainerView).offset(AUTOSIZESCALEX(25));
        make.right.equalTo(self.NO3ContainerView).offset(AUTOSIZESCALEX(-25));
        make.top.equalTo(self.NO3ImageView.mas_bottom).offset(AUTOSIZESCALEX(8.5));
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
    [self.NO3RewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.NO3ContainerView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.NO3NameLabel.mas_bottom).offset(AUTOSIZESCALEX(6));
    }];

}

#pragma mark - Setter

- (void)setDatasource:(NSMutableArray *)datasource {
    _datasource = datasource;
    if (_datasource.count == 0) {
        
        self.NO1ContainerView.hidden = self.NO2ContainerView.hidden = self.NO3ContainerView.hidden = YES;
        
    } else if (_datasource.count == 1) {
        
        self.NO1ContainerView.hidden = NO;
        self.NO2ContainerView.hidden = self.NO3ContainerView.hidden = YES;

        MemberRankItem *item = _datasource[0];
        [self.NO1IconImageView wy_setImageWithUrlString:item.headpicUrl placeholderImage:PlaceHolderImage];
        self.NO1NameLabel.text = item.nickname;
//        self.NO1RewardLabel.text = [NSString stringWithFormat:@"奖励：%@",item.money];
        
        NSString *money1 = [NSString stringWithFormat:@"%.2f",[item.money floatValue]];
        NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖励：%@",money1]];
        [attribute1 addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"#FF1848") range:NSMakeRange(3, money1.length)];
        self.NO1RewardLabel.attributedText = attribute1;

    } else if (_datasource.count == 2) {
        
        self.NO1ContainerView.hidden = self.NO2ContainerView.hidden = NO;
        self.NO3ContainerView.hidden = YES;
        
        MemberRankItem *item1 = _datasource[0];
        [self.NO1IconImageView wy_setImageWithUrlString:item1.headpicUrl placeholderImage:PlaceHolderImage];
        self.NO1NameLabel.text = item1.nickname;
//        self.NO1RewardLabel.text = [NSString stringWithFormat:@"奖励：%@",item1.money];

        NSString *money1 = [NSString stringWithFormat:@"%.2f",[item1.money floatValue]];
        NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖励：%@",money1]];
        [attribute1 addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"#FF1848") range:NSMakeRange(3, money1.length)];
        self.NO1RewardLabel.attributedText = attribute1;

        MemberRankItem *item2 = _datasource[1];
        [self.NO2IconImageView wy_setImageWithUrlString:item2.headpicUrl placeholderImage:PlaceHolderImage];
        self.NO2NameLabel.text = item2.nickname;
//        self.NO2RewardLabel.text = [NSString stringWithFormat:@"奖励：%@",item2.money];

        NSString *money2 = [NSString stringWithFormat:@"%.2f",[item2.money floatValue]];
        NSMutableAttributedString *attribute2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖励：%@",money2]];
        [attribute2 addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"#FF1848") range:NSMakeRange(3, money2.length)];
        self.NO2RewardLabel.attributedText = attribute2;

    } else if (_datasource.count > 2) {
        
        self.NO1ContainerView.hidden = self.NO2ContainerView.hidden = self.NO3ContainerView.hidden = NO;
        
        MemberRankItem *item1 = _datasource[0];
        [self.NO1IconImageView wy_setImageWithUrlString:item1.headpicUrl placeholderImage:PlaceHolderImage];
        self.NO1NameLabel.text = item1.nickname;
//        self.NO1RewardLabel.text = [NSString stringWithFormat:@"奖励：%@",item1.money];
        
        NSString *money1 = [NSString stringWithFormat:@"%.2f",[item1.money floatValue]];
        NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖励：%@",money1]];
        [attribute1 addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"#FF1848") range:NSMakeRange(3, money1.length)];
        self.NO1RewardLabel.attributedText = attribute1;

        MemberRankItem *item2 = _datasource[1];
        [self.NO2IconImageView wy_setImageWithUrlString:item2.headpicUrl placeholderImage:PlaceHolderImage];
        self.NO2NameLabel.text = item2.nickname;
//        self.NO2RewardLabel.text = [NSString stringWithFormat:@"奖励：%@",item2.money];

        NSString *money2 = [NSString stringWithFormat:@"%.2f",[item2.money floatValue]];
        NSMutableAttributedString *attribute2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖励：%@",money2]];
        [attribute2 addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"#FF1848") range:NSMakeRange(3, money2.length)];
        self.NO2RewardLabel.attributedText = attribute2;

        MemberRankItem *item3 = _datasource[2];
        [self.NO3IconImageView wy_setImageWithUrlString:item3.headpicUrl placeholderImage:PlaceHolderImage];
        self.NO3NameLabel.text = item3.nickname;
        self.NO3RewardLabel.text = [NSString stringWithFormat:@"奖励：%@",item3.money];
        
        NSString *money3 = [NSString stringWithFormat:@"%.2f",[item3.money floatValue]];
        NSMutableAttributedString *attribute3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"奖励：%@",money3]];
        [attribute3 addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"#FF1848") range:NSMakeRange(3, money3.length)];
        self.NO3RewardLabel.attributedText = attribute3;

    }
}

@end
