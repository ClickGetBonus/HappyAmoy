//
//  NewsReportListCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewsReportListCell.h"
#import "NewsReportItem.h"

@interface NewsReportListCell ()

/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    来源    */
@property(nonatomic,strong) UILabel *comeFromLabel;
/**    浏览数    */
@property(nonatomic,strong) UILabel *countLabel;
/**    图标    */
@property(nonatomic,strong) UIImageView *iconImageView;
/**    分割线    */
@property(nonatomic,strong) UIView *line;

@end

@implementation NewsReportListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.text = @"一加6核心配置遭曝光，小米万\n万没想到这次一加6这么狠";
    titleLabel.textColor = ColorWithHexString(@"#333333");
    titleLabel.font = TextFont(14);
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(29));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-160));
    }];
    
    UILabel *comeFromLabel = [[UILabel alloc] init];
    comeFromLabel.text = @"小眼镜看世界";
    comeFromLabel.textColor = ColorWithHexString(@"#666666");
    comeFromLabel.font = TextFont(12);
    [self.contentView addSubview:comeFromLabel];
    self.comeFromLabel = comeFromLabel;
    
    [self.comeFromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-29));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = @"1025人浏览";
    countLabel.textColor = ColorWithHexString(@"#999999");
    countLabel.font = TextFont(12);
    [self.contentView addSubview:countLabel];
    self.countLabel = countLabel;
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.centerY.equalTo(self.comeFromLabel).offset(AUTOSIZESCALEX(0));
        make.height.equalTo(self.comeFromLabel);
    }];

    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"新闻资讯") imageViewSize:CGSizeMake(AUTOSIZESCALEX(118), AUTOSIZESCALEX(100))];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(118), AUTOSIZESCALEX(100)));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(0.75));
    }];

}

#pragma mark - Setter

- (void)setItem:(NewsReportItem *)item {
    _item = item;
    if (_item) {
        [self.iconImageView wy_setImageWithUrlString:_item.iconUrl placeholderImage:PlaceHolderMainImage];
        self.titleLabel.text = _item.summary;
        self.comeFromLabel.text = _item.author;
        self.countLabel.text = [NSString stringWithFormat:@"%zd人浏览",_item.viewNum];
    }
}

@end
