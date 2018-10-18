//
//  ShareViewCell.m
//  HappyAmoy
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareViewCell.h"

@interface ShareViewCell ()

/**    icon    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    方式    */
@property (strong, nonatomic) UILabel *wayLabel;

@end

@implementation ShareViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = PlaceHolderImage;
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(36));
        make.height.mas_equalTo(AUTOSIZESCALEX(36));
    }];
    
    UILabel *wayLabel = [[UILabel alloc] init];
    wayLabel.text = @"朋友圈";
    wayLabel.textColor = ColorWithHexString(@"666666");
    wayLabel.font = TextFont(12);
    [self.contentView addSubview:wayLabel];
    self.wayLabel = wayLabel;
    [self.wayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.iconImageView.mas_bottom).offset(AUTOSIZESCALEX(10));
    }];
}

#pragma mark - Setter

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    self.iconImageView.image = iconImage;
}

- (void)setPlatform:(NSString *)platform {
    _platform = platform;
    self.wayLabel.text = _platform;
}

@end
