//
//  MyTeamMemberCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyTeamMemberCell.h"
#import "MyTeamItem.h"

@interface MyTeamMemberCell()

/**    头像    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    会员账号    */
@property (strong, nonatomic) UILabel *nameLabel;
/**    注册时间    */
@property (strong, nonatomic) UILabel *timeLabel;
/**    电话按钮    */
@property (strong, nonatomic) UIButton *phoneBtn;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation MyTeamMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:PlaceHolderImage];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;

    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = ColorWithHexString(@"#333333");
    nameLabel.font = TextFont(13.0);
    nameLabel.text = @"VIP会员： 139****0000";
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = ColorWithHexString(@"999999");
    timeLabel.font = TextFont(12.0);
    timeLabel.text = @"注册时间：2017-10-24";
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIButton *button = [[UIButton alloc]init];
    [button addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon_call"] forState:UIControlStateNormal];
    [self.contentView addSubview:button];
    self.phoneBtn = button;

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    // 添加约束
    [self addConstraints];
}

#pragma mark - Btn
- (void)clickedBtn:(id)sender
{
    if (self.ClickedPhoneBlockBlock) {
        self.ClickedPhoneBlockBlock(_item);
    }
}
#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(40));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(13.5));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(15));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-13.5));
        make.left.equalTo(self.nameLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(20));
        make.height.mas_equalTo(AUTOSIZESCALEX(20));
        
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Setter

- (void)setItem:(MyTeamItem *)item {
    _item = item;
    if (_item) {
        [self.iconImageView wy_setCircleImageWithUrlString:_item.headpicUrl placeholderImage:PlaceHolderImage];
        if (_item.viped == 1) { // VIP
            self.nameLabel.text = [NSString stringWithFormat:@"VIP会员： %@",_item.nickname];
        }else if (_item.viped == 11) { // VIP
            self.nameLabel.text = [NSString stringWithFormat:@"荣誉总裁： %@",_item.nickname];
        }else if (_item.viped == 12) { // VIP
            self.nameLabel.text = [NSString stringWithFormat:@"联席总裁： %@",_item.nickname];
        }else if (_item.viped == 13) { // VIP
            self.nameLabel.text = [NSString stringWithFormat:@"战略合伙人： %@",_item.nickname];
        } else {
            self.nameLabel.text = [NSString stringWithFormat:@"普通会员： %@",_item.nickname];
        }
        self.timeLabel.text = [NSString stringWithFormat:@"注册时间：%@",_item.createTime];
    }
}

@end
