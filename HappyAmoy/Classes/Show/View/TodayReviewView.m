//
//  TodayReviewView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TodayReviewView.h"

@interface TodayReviewView() <WYCarouselViewDelegate>

/**    今日点评    */
@property (strong, nonatomic) UILabel *todayReviewLabel;
/**    数量    */
@property (strong, nonatomic) UILabel *countLabel;
/**    轮播图    */
//@property (strong, nonatomic) WYCarouselView *carouselView;
/**    轮播图    */
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/**    头像    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    描述    */
@property (strong, nonatomic) UILabel *descLabel;

@end

@implementation TodayReviewView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *todayReviewLabel = [[UILabel alloc] init];
    todayReviewLabel.text = @"今日点评";
    todayReviewLabel.font = AppMainTextFont(15);
    todayReviewLabel.textColor = QHMainColor;
    [self addSubview:todayReviewLabel];
    self.todayReviewLabel = todayReviewLabel;
//    self.todayReviewLabel.frame = CGRectMake(AUTOSIZESCALEX(10), AUTOSIZESCALEX(10), AUTOSIZESCALEX(60), AUTOSIZESCALEX(15));
//    self.todayReviewLabel.size = CGSizeMake(AUTOSIZESCALEX(60), AUTOSIZESCALEX(13));
//    [WYUtils TextGradientview:self.todayReviewLabel bgVIew:self gradientColors:@[(id)ColorWithHexString(@"#F96C74").CGColor, (id)ColorWithHexString(@"#FB4F67").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];

    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.text = @"1/3";
    countLabel.font = TextFont(16);
    countLabel.textColor = QHMainColor;
    [self addSubview:countLabel];
    self.countLabel = countLabel;

//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(150)) delegate:nil placeholderImage:PlaceHolderMainImage];

    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(195)) imageNamesGroup:@[ImageWithNamed(@"appIcon_small"),ImageWithNamed(@"appIcon_small"),ImageWithNamed(@"appIcon_small")]];
    [self addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
//    WYCarouselView *carouselView = [[WYCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - AUTOSIZESCALEX(20), AUTOSIZESCALEX(195))];
//    // 图片是否自适应
//    // carouselView.isAutoSizeImage = NO;
//    carouselView.delegate = self;
//    carouselView.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
//    carouselView.imageArray = @[ImageWithNamed(@"appIcon_small"),ImageWithNamed(@"appIcon_small"),ImageWithNamed(@"appIcon_small")];
//    [self addSubview:carouselView];
//    self.carouselView = carouselView;

    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = PlaceHolderImage;
    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = @"今天赚了不少";
    descLabel.font = TextFont(14);
    descLabel.textColor = ColorWithHexString(@"#575554");
    [self addSubview:descLabel];
    self.descLabel = descLabel;

    [self addConstraints];
    
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.todayReviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(10));
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.todayReviewLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-10));
    }];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.todayReviewLabel.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.todayReviewLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.countLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(195));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.todayReviewLabel).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(40), AUTOSIZESCALEX(40)));
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-10));
    }];
}

#pragma mark - WYCarouselViewDelegate

- (void)carouselView:(WYCarouselView *)carouselView didScrollToIndex:(NSInteger)index {
    
    WYLog(@"index = %zd",index);
    
    self.countLabel.text = [NSString stringWithFormat:@"%zd/3",index + 1];
    
}

@end
