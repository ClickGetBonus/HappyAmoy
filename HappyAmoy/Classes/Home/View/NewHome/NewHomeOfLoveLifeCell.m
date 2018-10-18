//
//  NewHomeOfLoveLifeCell.m
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewHomeOfLoveLifeCell.h"

@interface NewHomeOfLoveLifeCell ()

/**    竖线    */
@property(nonatomic,strong) UIImageView *lineImageView;
/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    图标    */
@property(nonatomic,strong) UIImageView *iconImageView;

@end

@implementation NewHomeOfLoveLifeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *lineImageView = [[UIImageView alloc] init];
    lineImageView.image = ImageWithNamed(@"矩形23");
    [self.contentView addSubview:lineImageView];
    self.lineImageView = lineImageView;
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(6));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(13));
        make.width.mas_equalTo(AUTOSIZESCALEX(3));
        make.height.mas_equalTo(AUTOSIZESCALEX(23));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AUTOSIZESCALEX(23), AUTOSIZESCALEX(15), AUTOSIZESCALEX(100), AUTOSIZESCALEX(20))];
    titleLabel.text = @"爱生活，更要懂生活";
    titleLabel.textColor = ColorWithHexString(@"#3E3B3C");
    titleLabel.font = AppMainTextFont(16);
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lineImageView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.lineImageView.mas_right).offset(AUTOSIZESCALEX(10));
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = ImageWithNamed(@"我是生活达人");
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(35));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
    }];
}

@end
