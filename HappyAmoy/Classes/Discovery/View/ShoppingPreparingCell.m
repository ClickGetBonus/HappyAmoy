//
//  ShoppingPreparingCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShoppingPreparingCell.h"

@interface ShoppingPreparingCell()

/**    签到标识    */
@property(nonatomic,strong) UIImageView *bgImageView;

@end

@implementation ShoppingPreparingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {

    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = ImageWithNamed(@"淘宝查券");
    [self.contentView addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));

//        make.center.equalTo(self.contentView);
//        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(29), AUTOSIZESCALEX(27)));
    }];
    
}

#pragma mark - Setter

- (void)setContentImage:(UIImage *)contentImage {
    _contentImage = contentImage;
    self.bgImageView.image = _contentImage;
}

@end
