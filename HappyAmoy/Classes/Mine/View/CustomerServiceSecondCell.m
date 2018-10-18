//
//  CustomerServiceSecondCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CustomerServiceSecondCell.h"

@interface CustomerServiceSecondCell()

/**    图标    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    主标题    */
@property (strong, nonatomic) UILabel *mainTitleLabel;
/**    箭头    */
@property (strong, nonatomic) UIImageView *arrowImageView;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation CustomerServiceSecondCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = ImageWithNamed(@"客服(1)");
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *mainTitleLabel = [[UILabel alloc] init];
    mainTitleLabel.textColor = ColorWithHexString(@"#000000");
    mainTitleLabel.font = TextFont(14.0);
    mainTitleLabel.text = @"在线客服";
    [self.contentView addSubview:mainTitleLabel];
    self.mainTitleLabel = mainTitleLabel;

    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"next")];
    [self.contentView addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    // 添加约束
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(22));
        make.height.mas_equalTo(AUTOSIZESCALEX(22));
    }];
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(17));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(8));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

@end
