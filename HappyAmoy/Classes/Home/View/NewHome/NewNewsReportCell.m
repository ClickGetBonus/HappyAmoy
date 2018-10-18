//
//  NewNewsReportCell.m
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewNewsReportCell.h"
#import "NewsReportItem.h"

@interface NewNewsReportCell ()

/**    图标    */
@property(nonatomic,strong) UIImageView *iconImageView;
/**    轮播图    */
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;

@end

@implementation NewNewsReportCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
//        self.backgroundColor = ColorWithHexString(@"#F3F3F6");
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = ImageWithNamed(@"省惠快报");
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }]; 
    
    [self.contentView addSubview:self.cycleScrollView];
}

#pragma mark - Setter
- (void)setArticlesArray:(NSMutableArray *)articlesArray {
    _articlesArray = articlesArray;
    if (_articlesArray.count > 0) {
        NSMutableArray *titlesGroup = [NSMutableArray array];
        NSMutableArray *imagesArray = [NSMutableArray array];
        for (int i = 0; i < _articlesArray.count; i++) {
            NewsReportItem *item = _articlesArray[i];
            [titlesGroup addObject:item.title];
            [imagesArray addObject:[[UIImage alloc] init]];
        }
        self.cycleScrollView.titlesGroup = [titlesGroup copy];
        self.cycleScrollView.localizationImageNamesGroup = [imagesArray copy];
    }
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(AUTOSIZESCALEX(80), AUTOSIZESCALEX(5), SCREEN_WIDTH - AUTOSIZESCALEX(115), AUTOSIZESCALEX(30)) delegate:nil placeholderImage:[[UIImage alloc] init]];
        cycleScrollView.userInteractionEnabled = NO;
        cycleScrollView.backgroundColor = QHClearColor;
        //        cycleScrollView.localizationImageNamesGroup = @[[[UIImage alloc] init],[[UIImage alloc] init]];
        //        cycleScrollView.titlesGroup = @[@"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈",@"嘿嘿嘿"];
        cycleScrollView.onlyDisplayText = YES;
        cycleScrollView.showPageControl = NO;
        cycleScrollView.titleLabelHeight = AUTOSIZESCALEX(30);
        cycleScrollView.titleLabelBackgroundColor = QHClearColor;
        cycleScrollView.titleLabelTextFont = TextFont(11);
        cycleScrollView.titleLabelTextColor = QHBlackColor;
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        [cycleScrollView disableScrollGesture];
        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            
        };
        _cycleScrollView = cycleScrollView;
    }
    return _cycleScrollView;
}

@end
