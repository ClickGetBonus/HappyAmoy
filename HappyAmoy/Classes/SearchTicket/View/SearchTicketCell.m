//
//  SearchTicketCell.m
//  HappyAmoy
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SearchTicketCell.h"

@interface SearchTicketCell()



@end

@implementation SearchTicketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = RGB(231, 231, 231);
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"装饰")];
    [self.contentView addSubview:titleImageView];
    [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(25));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(25));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-25));
        make.height.mas_equalTo(AUTOSIZESCALEX(9));
    }];

    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"好麦领券指南";
    titleLabel.textColor = QHMainColor;
    titleLabel.font = AppMainTextFont(15);
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.centerY.equalTo(titleImageView).offset(AUTOSIZESCALEX(0));
    }];

    
    UIImageView *firstImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"如何省钱")];
    [self.contentView addSubview:firstImageView];
    [firstImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(60));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.height.mas_equalTo(AUTOSIZESCALEX(460));
    }];
    
    
    UIImageView *secondImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"如何领取优惠券")];
    [self.contentView addSubview:secondImageView];
    [secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstImageView.mas_bottom).offset(AUTOSIZESCALEX(20));
        make.left.equalTo(firstImageView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(firstImageView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(1100));
    }];
}

@end
