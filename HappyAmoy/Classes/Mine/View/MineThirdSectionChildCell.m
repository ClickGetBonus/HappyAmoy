//
//  MineThirdSectionChildCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineThirdSectionChildCell.h"

@interface MineThirdSectionChildCell()

/**    图标    */
@property (strong, nonatomic) UIButton *iconImageView;
/**    类型    */
@property (strong, nonatomic) UILabel *typeLabel;
/**    余额    */
@property (strong, nonatomic) UILabel *balanceLabel;

@end

@implementation MineThirdSectionChildCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIButton *iconImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    iconImageView.userInteractionEnabled = NO;
    [iconImageView setImage:ImageWithNamed(@"defaultHeadImage") forState:UIControlStateNormal];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.font = TextFont(12);
    typeLabel.text = @"会员奖励";
    typeLabel.textColor = ColorWithHexString(@"#333333");
    [self.contentView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(25));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-19));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
    }];    
}

#pragma mark - Setter

- (void)setType:(NSString *)type {
    
    _type = type;
    
    self.typeLabel.text = _type;
}

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    [self.iconImageView setImage:ImageWithNamed(_iconName) forState:UIControlStateNormal];
}

@end
