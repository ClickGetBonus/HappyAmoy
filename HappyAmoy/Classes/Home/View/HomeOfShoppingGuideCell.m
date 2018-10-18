//
//  HomeOfShoppingGuideCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeOfShoppingGuideCell.h"

@interface HomeOfShoppingGuideCell ()

/**    购物攻略    */
@property(nonatomic,strong) UIButton *shoppingGuideButton;
/**    分享    */
@property(nonatomic,strong) UIButton *shareButton;

@end

@implementation HomeOfShoppingGuideCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
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
    if ([_delegate respondsToSelector:@selector(homeOfShoppingGuideCell:didClickShoppingGuideButton:)]) {
        [_delegate homeOfShoppingGuideCell:self didClickShoppingGuideButton:sender];
    }
}

// 邀请好友
- (void)didClickShareButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(homeOfShoppingGuideCell:didClickShareButton:)]) {
        [_delegate homeOfShoppingGuideCell:self didClickShareButton:sender];
    }
}


@end
