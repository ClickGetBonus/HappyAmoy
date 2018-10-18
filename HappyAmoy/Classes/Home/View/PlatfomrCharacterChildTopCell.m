//
//  PlatfomrCharacterChildTopCell.m
//  HappyAmoy
//
//  Created by 崔家铭 on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//


#import "PlatfomrCharacterChildTopCell.h"
#import "CommoditySpecialCategoriesItem.h"
#import "CommodityCategoriesItem.h"

@interface PlatfomrCharacterChildTopCell()

/**    图片    */
@property (strong, nonatomic) UIImageView *imageView;

@property(nonatomic,strong) UILabel *titleLabel;

@end

@implementation PlatfomrCharacterChildTopCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = QHWhiteColor;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {

    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;

    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(AUTOSIZESCALEX(5));
        make.width.mas_equalTo(SCREEN_WIDTH * 0.13*0.8);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.13*0.8);
//        make.left.equalTo(self).offset((SCREEN_WIDTH) * 0.06);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).mas_offset(-10);
//        make.top.equalTo(self).offset((SCREEN_WIDTH) * 0.02);
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.text = @"121212么狠";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = ColorWithHexString(@"#333333");
    titleLabel.font = TextFont(14);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH * 0.2);
        make.top.equalTo(self.contentView).offset(SCREEN_WIDTH * 0.17);
    }];
}

#pragma mark - Setter

- (void)setItem:(CommoditySpecialCategoriesItem *)item {
    _item = item;
    if (_item) {
        if (![_item.iconUrl hasPrefix:@"http://"]) {
            self.imageView.image = [UIImage imageNamed:_item.iconUrl];
        }else{
            [self.imageView wy_setImageWithUrlString:_item.iconUrl placeholderImage:PlaceHolderMainImage];
        }
        self.titleLabel.text = _item.name;
    }
}

- (void)setPpjxItem:(CommodityCategoriesItem *)ppjxItem {
    _ppjxItem = ppjxItem;
    if (_ppjxItem) {
        [self.imageView wy_setImageWithUrlString:_ppjxItem.iconUrl placeholderImage:PlaceHolderMainImage];
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

@end
