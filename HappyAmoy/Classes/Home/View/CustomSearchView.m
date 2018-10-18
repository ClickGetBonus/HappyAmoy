//
//  CustomSearchView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CustomSearchView.h"

@interface CustomSearchView()

/**    搜索图标    */
@property (strong, nonatomic) UIImageView *searchImageView;

@end

@implementation CustomSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.layer.cornerRadius = self.height * 0.5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"搜索栏")];
    searchImageView.frame = CGRectMake(AUTOSIZESCALEX(10), 0, AUTOSIZESCALEX(17), AUTOSIZESCALEX(18));
    searchImageView.centerY = self.centerY;
    [self addSubview:searchImageView];
    self.searchImageView = searchImageView;
    
//    [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(AUTOSIZESCALEX(10));
//        make.centerY.equalTo(self).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(AUTOSIZESCALEX(17));
//        make.height.mas_equalTo(AUTOSIZESCALEX(18));
//    }];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.searchImageView.right_WY + AUTOSIZESCALEX(8), 0, self.width - AUTOSIZESCALEX(35), AUTOSIZESCALEX(15))];
    tipsLabel.centerY = self.centerY;
    tipsLabel.font = TextFont(11);
    tipsLabel.textColor = ColorWithHexString(@"999999");
    tipsLabel.text = @"输入商品关键词，搜索商品优惠券";
    [self addSubview:tipsLabel];
    
//    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.searchImageView.mas_right).offset(AUTOSIZESCALEX(10));
//        make.centerY.equalTo(self).offset(AUTOSIZESCALEX(0));
//    }];
}

@end
