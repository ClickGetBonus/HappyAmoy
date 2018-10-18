//
//  NewHomeOfShoppingGuideCell.m
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewHomeOfShoppingGuideCell.h"

@interface NewHomeOfShoppingGuideCell ()

/**    购物攻略    */
@property(nonatomic,strong) UIButton *shoppingGuideButton;
/**    分享    */
@property(nonatomic,strong) UIButton *shareButton;


@property(nonatomic,strong) UIImageView *shopimg;
@property(nonatomic,strong) UIImageView *shareimg;

@end

@implementation NewHomeOfShoppingGuideCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
//    UIImageView *iconImageView = [[UIImageView alloc] init];
//    iconImageView.image = ImageWithNamed(@"购物攻略");
//    [self.contentView addSubview:iconImageView];
//    self.shopimg = iconImageView;
//    
//    [self.shopimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
//        make.width.mas_equalTo((SCREEN_WIDTH - AUTOSIZESCALEX(35)) * 0.5);
//        make.height.mas_equalTo(AUTOSIZESCALEX(75));
//    }];
//    
//    UIImageView *iconImageView2 = [[UIImageView alloc] init];
//    iconImageView2.image = ImageWithNamed(@"邀请好友");
//    [self.contentView addSubview:iconImageView2];
//    self.shareimg = iconImageView2;
//    
//    [self.shareimg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
//        make.width.equalTo(self.shopimg);
//        make.height.equalTo(self.shopimg);
//    }];
    
    
    
    UIButton *shoppingGuideButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shoppingGuideButton setBackgroundImage:ImageWithNamed(@"购物攻略") forState:UIControlStateNormal];
    [shoppingGuideButton addTarget:self action:@selector(didClickShoppingGuideButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shoppingGuideButton];
    self.shoppingGuideButton = shoppingGuideButton;
    
    [self.shoppingGuideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.width.mas_equalTo((SCREEN_WIDTH - AUTOSIZESCALEX(35)) * 0.5);
        make.height.mas_equalTo(AUTOSIZESCALEX(75));
    }];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setBackgroundImage:ImageWithNamed(@"邀请好友") forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:shareButton];
    self.shareButton = shareButton;
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.width.equalTo(self.shoppingGuideButton);
        make.height.equalTo(self.shoppingGuideButton);
    }];
    
}

#pragma mark - Button action

// 购物攻略
- (void)didClickShoppingGuideButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(newHomeOfShoppingGuideCell:didClickShoppingGuideButton:)]) {
        [_delegate newHomeOfShoppingGuideCell:self didClickShoppingGuideButton:sender];
    }
}

// 邀请好友
- (void)didClickShareButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(newHomeOfShoppingGuideCell:didClickShareButton:)]) {
        [_delegate newHomeOfShoppingGuideCell:self didClickShareButton:sender];
    }
}

@end
