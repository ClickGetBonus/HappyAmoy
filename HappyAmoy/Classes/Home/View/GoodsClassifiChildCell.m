//
//  GoodsClassifiChildCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsClassifiChildCell.h"
#import "CommodityCategoriesItem.h"

@interface GoodsClassifiChildCell()

/**    图标    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation GoodsClassifiChildCell

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
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"男装";
    titleLabel.font = TextFont(13);
    titleLabel.textColor = ColorWithHexString(@"666666");
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(7.5));
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(45), AUTOSIZESCALEX(45)));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(AUTOSIZESCALEX(5));
        make.centerX.equalTo(self.contentView);
    }];
    
}

#pragma mark - Setter

- (void)setItem:(CommodityCategoriesItem *)item {
    _item = item;
    if (_item) {
        self.titleLabel.text = _item.name;
        [self.iconImageView wy_setImageWithUrlString:_item.iconUrl placeholderImage:PlaceHolderImage];
    }
}

- (void)setType:(NSString *)type {
    _type = type;
    self.titleLabel.text = _type;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.iconImageView.image = _icon;
}

@end
