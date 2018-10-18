//
//  CustomerServiceFirstCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CustomerServiceFirstCell.h"

@interface CustomerServiceFirstCell()

/**    图标    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    主标题    */
@property (strong, nonatomic) UILabel *mainTitleLabel;
/**    副标题    */
@property (strong, nonatomic) UILabel *subTitleLabel;
/**    箭头    */
@property (strong, nonatomic) UIImageView *arrowImageView;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation CustomerServiceFirstCell

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
    iconImageView.image = ImageWithNamed(@"电话");
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *mainTitleLabel = [[UILabel alloc] init];
    mainTitleLabel.textColor = ColorWithHexString(@"#000000");
    mainTitleLabel.font = TextFont(14.0);
    mainTitleLabel.text = @"客服热线";
    [self.contentView addSubview:mainTitleLabel];
    self.mainTitleLabel = mainTitleLabel;
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.textColor = ColorWithHexString(@"#999999");
    subTitleLabel.font = TextFont(10.0);
    subTitleLabel.text = @"（工作时间：09：00-22：00）";
    [self.contentView addSubview:subTitleLabel];
    self.subTitleLabel = subTitleLabel;
    
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
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(13));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(17));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-13));
        make.left.equalTo(self.mainTitleLabel).offset(AUTOSIZESCALEX(-5));
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
