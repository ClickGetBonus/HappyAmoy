//
//  GroupBuyPeopleCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupBuyPeopleCell.h"

@interface GroupBuyPeopleCell()

/**    头像    */
@property(nonatomic,strong) UIImageView *iconImageView;

@end

@implementation GroupBuyPeopleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.cornerRadius = AUTOSIZESCALEX(27.5);
    iconImageView.layer.masksToBounds = YES;
    iconImageView.image = ImageWithNamed(@"headImage_white");
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - Setter

- (void)setIconImageURL:(NSString *)iconImageURL {
    _iconImageURL = iconImageURL;
    [self.iconImageView wy_setImageWithUrlString:_iconImageURL placeholderImage:ImageWithNamed(@"headImage_white")];
}

@end
