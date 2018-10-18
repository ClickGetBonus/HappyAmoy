//
//  TodayRecommendCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TodayRecommendCell.h"

@interface TodayRecommendCell ()

/**    封面图片    */
@property (strong, nonatomic) UIImageView *coverImageView;
/**    介绍    */
@property (strong, nonatomic) UILabel *descLabel;
/**    折扣价    */
@property (strong, nonatomic) UILabel *discountLabel;
/**    原价    */
@property (strong, nonatomic) UILabel *originalLabel;
/**    优惠券    */
@property (strong, nonatomic) UIButton *couponButton;
/**    销量    */
@property (strong, nonatomic) UILabel *salesLabel;

@end

@implementation TodayRecommendCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    CGFloat itemWH = (SCREEN_WIDTH - AUTOSIZESCALEX(10) * 2) * 0.5 - AUTOSIZESCALEX(5);

    UIImageView *coverImageView = [[UIImageView alloc] init];
    
    coverImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"appIcon_small") imageViewSize:CGSizeMake(itemWH, itemWH)];
    
    [self.contentView addSubview:coverImageView];
    self.coverImageView = coverImageView;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.font = TextFont(15);
    descLabel.text = @"周生生78003p pt950铂金petcat小猫吊坠";
    descLabel.textColor = QHBlackColor;
    descLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:descLabel];
    self.descLabel = descLabel;
    
    UILabel *discountLabel = [[UILabel alloc] init];
    discountLabel.font = TextFont(15);
    discountLabel.text = @"¥69.00";
    discountLabel.textColor = RGB(176, 176, 176);
    discountLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:discountLabel];
    self.discountLabel = discountLabel;
    
    UILabel *originalLabel = [[UILabel alloc] init];
    originalLabel.font = TextFont(15);
    originalLabel.text = @"¥99.00";
    originalLabel.textColor = RGB(176, 176, 176);
    originalLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:originalLabel];
    self.originalLabel = originalLabel;
    
    UIButton *couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [couponButton setTitle:@"10.00元" forState:UIControlStateNormal];
    [couponButton addTarget:self action:@selector(didClickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:couponButton];
    self.couponButton = couponButton;
    
    
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(100));
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).offset(AUTOSIZESCALEX(7));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
    }];
    
//    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.coverImageView);
//        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(21), AUTOSIZESCALEX(21)));
//    }];
}

#pragma mark - Button Action

- (void)didClickPlayButton:(UIButton *)sender {
    WYFunc
}


@end
