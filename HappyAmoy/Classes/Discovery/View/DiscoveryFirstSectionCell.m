//
//  DiscoveryFirstSectionCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DiscoveryFirstSectionCell.h"

@interface DiscoveryFirstSectionCell()

/**    竖线    */
@property(nonatomic,strong) UIView *colorLine;
/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    图片    */
@property(nonatomic,strong) UIImageView *iconImageVIew;
/**    分割线    */
@property(nonatomic,strong) UIView *line;

@end

@implementation DiscoveryFirstSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIView *colorLine = [[UIView alloc] init];
    colorLine.backgroundColor = ColorWithHexString(@"#ffb42b");
    [self.contentView addSubview:colorLine];
    self.colorLine = colorLine;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = ColorWithHexString(@"333333");
    titleLabel.font = TextFont(15);
    titleLabel.text = @"好麦拼团";
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIImageView *iconImageVIew = [[UIImageView alloc] init];
    iconImageVIew.image = ImageWithNamed(@"省惠拼团banner");
    [self.contentView addSubview:iconImageVIew];
    self.iconImageVIew = iconImageVIew;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.colorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(3));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.colorLine).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.colorLine.mas_right).offset(AUTOSIZESCALEX(5));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.iconImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
//        make.height.mas_equalTo(AUTOSIZESCALEX(125));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setBannerImage:(UIImage *)bannerImage {
    _bannerImage = bannerImage;
    self.iconImageVIew.image = _bannerImage;
}

- (void)setHiddenLine:(BOOL)hiddenLine {
    _hiddenLine = hiddenLine;
    self.line.hidden = hiddenLine;
}

@end
