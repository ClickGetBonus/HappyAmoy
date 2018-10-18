//
//  ThirdPartyAuthorCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ThirdPartyAuthorCell.h"

@interface ThirdPartyAuthorCell()

/**    图标    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    内容    */
@property (strong, nonatomic) UILabel *contentLabel;
/**    右边箭头    */
@property (strong, nonatomic) UIImageView *arrowImageView;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation ThirdPartyAuthorCell

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
    iconImageView.image = PlaceHolderImage;
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TextFont(14);
    titleLabel.textColor = RGB(70, 70, 70);
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = TextFont(14);
    contentLabel.textColor = RGB(115, 115, 115);
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = ImageWithNamed(@"grayRightArrow");
    [self.contentView addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(20));
        make.height.mas_equalTo(AUTOSIZESCALEX(20));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(15));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(6.5));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.arrowImageView.mas_left).offset(AUTOSIZESCALEX(-15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
}

#pragma mark - Setter

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    self.iconImageView.image = ImageWithNamed(_iconName);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.contentLabel.text = content;
}



@end
