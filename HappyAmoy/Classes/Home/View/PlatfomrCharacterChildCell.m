//
//  PlatfomrCharacterChildCell.m
//  HappyAmoy
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PlatfomrCharacterChildCell.h"
#import "CommoditySpecialCategoriesItem.h"
#import "CommodityCategoriesItem.h"

@interface PlatfomrCharacterChildCell()

/**    图片    */
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation PlatfomrCharacterChildCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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
        make.edges.equalTo(self.contentView);
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
