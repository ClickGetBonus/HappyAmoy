//
//  MessageCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MessageCell.h"
#import "MessageItem.h"

@interface MessageCell()

/**    头像    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    内容    */
@property (strong, nonatomic) UILabel *contentLabel;
/**    时间    */
@property (strong, nonatomic) UILabel *timeLabel;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation MessageCell

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
    iconImageView.image = ImageWithNamed(@"消息通知");
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"间接会员139****00000购物消费获得会员福利，奖励已到账";
    contentLabel.font = TextFont(15);
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = RGB(90, 90, 90);
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"2018-03-30";
    timeLabel.font = TextFont(15);
    timeLabel.textColor = RGB(130, 130, 130);
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(35), AUTOSIZESCALEX(35)));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Setter

- (void)setItem:(MessageItem *)item {
    _item = item;
    if (_item) {
        self.contentLabel.text = _item.content;
        self.timeLabel.text = _item.createTime;
    }
}

- (void)setIsFriendNotice:(BOOL)isFriendNotice {
    _isFriendNotice = isFriendNotice;
    if (_isFriendNotice) {
        self.iconImageView.image = ImageWithNamed(@"好友消息通知");
    } else {
        self.iconImageView.image = ImageWithNamed(@"消息通知");
    }
}

@end
