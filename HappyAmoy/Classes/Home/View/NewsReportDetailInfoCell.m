//
//  NewsReportDetailInfoCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewsReportDetailInfoCell.h"
#import "NewsReportItem.h"

@interface NewsReportDetailInfoCell()

/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    来源    */
@property(nonatomic,strong) UILabel *comeFromLabel;
/**    发布时间    */
@property(nonatomic,strong) UILabel *createTimeLabel;
/**    点赞按钮    */
@property(nonatomic,strong) UIButton *praiseButton;

@end

@implementation NewsReportDetailInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.text = @"谁没在寒风中等过那顿路边摊?谁没在寒风\n中等过那顿路边摊?";
    titleLabel.textColor = ColorWithHexString(@"#000000");
    titleLabel.font = TextFont(18);
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
    
    UILabel *comeFromLabel = [[UILabel alloc] init];
    comeFromLabel.text = @"美食攻略";
    comeFromLabel.textColor = ColorWithHexString(@"#FB4F67");
    comeFromLabel.font = TextFont(12);
    [self.contentView addSubview:comeFromLabel];
    self.comeFromLabel = comeFromLabel;
    
    [self.comeFromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
    
    UILabel *createTimeLabel = [[UILabel alloc] init];
    createTimeLabel.text = @"2017-5-19 12:05";
    createTimeLabel.textColor = ColorWithHexString(@"#999999");
    createTimeLabel.font = TextFont(12);
    [self.contentView addSubview:createTimeLabel];
    self.createTimeLabel = createTimeLabel;
    
    [self.createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.comeFromLabel.mas_right).offset(AUTOSIZESCALEX(15));
        make.centerY.equalTo(self.comeFromLabel).offset(AUTOSIZESCALEX(0));
        make.height.equalTo(self.comeFromLabel);
    }];
    
    UIButton *praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [praiseButton setTitle:@" 点赞(0)" forState:UIControlStateNormal];
    [praiseButton setTitleColor:ColorWithHexString(@"#999999") forState:UIControlStateNormal];
    praiseButton.titleLabel.font = TextFont(12);
    [praiseButton setImage:ImageWithNamed(@"点赞") forState:UIControlStateNormal];
    [praiseButton addTarget:self action:@selector(didClickPraiseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:praiseButton];
    self.praiseButton = praiseButton;
    
    [self.praiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.createTimeLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
    }];
}

#pragma mark - Setter

- (void)setItem:(NewsReportItem *)item {
    _item = item;
    if (_item) {
        self.titleLabel.text = _item.title;
        self.comeFromLabel.text = _item.author;
        self.createTimeLabel.text = _item.createTime;
        if (_item.praised == 1) {
            [self.praiseButton setImage:ImageWithNamed(@"点赞2") forState:UIControlStateNormal];
        } else {
            [self.praiseButton setImage:ImageWithNamed(@"点赞") forState:UIControlStateNormal];
        }
        [self.praiseButton setTitle:[NSString stringWithFormat:@" 点赞(%zd)",_item.praiseNum] forState:UIControlStateNormal];
    }
}

#pragma mark - Button Action

- (void)didClickPraiseButton {
    
    if (self.praiseCallBack) {
        self.praiseCallBack(self.item.praised == 1);
    }
    
}

@end
