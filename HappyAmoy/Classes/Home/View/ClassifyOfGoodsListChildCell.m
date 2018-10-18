//
//  ClassifyOfGoodsListChildCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ClassifyOfGoodsListChildCell.h"
#import "ClassifyItem.h"

@interface ClassifyOfGoodsListChildCell ()

/**    图片    */
@property(nonatomic,strong) UIImageView *iconImageView;
/**    名称    */
@property(nonatomic,strong) UILabel *nameLabel;

@end

@implementation ClassifyOfGoodsListChildCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"省惠拼团banner") imageViewSize:CGSizeMake(AUTOSIZESCALEX(45), AUTOSIZESCALEX(45))];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(13));
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(45), AUTOSIZESCALEX(45)));
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"休闲裤";
    nameLabel.textColor = ColorWithHexString(@"#656161");
    nameLabel.font = TextFont(11);
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.centerX.equalTo(self.contentView);
    }];
    
}

#pragma mark - Setter

- (void)setItem:(ClassifyItem *)item {
    _item = item;
    if (_item) {
        [self.iconImageView wy_setImageWithUrlString:_item.iconUrl placeholderImage:PlaceHolderMainImage];
        self.nameLabel.text = _item.name;
    }
}

@end
