//
//  BrandBanerCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BrandBanerCell.h"
#import "BannerItem.h"

@interface BrandBanerCell ()

/**    轮播图    */
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@end

@implementation BrandBanerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    WeakSelf
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(150)) delegate:nil placeholderImage:PlaceHolderMainImage];
    cycleScrollView.localizationImageNamesGroup = @[ImageWithNamed(@"新用户专享")];
    cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        if (weakSelf.datasource.count == 0) {
            [WYPackagePhotoBrowser showPhotoWithImageArray:[NSMutableArray arrayWithArray:@[ImageWithNamed(@"新用户专享")]] currentIndex:0];
        } else {
            BannerItem *item = weakSelf.datasource[currentIndex];

            if ([weakSelf.delegate respondsToSelector:@selector(brandBanerCell:didClickBanner:)]) {
                [weakSelf.delegate brandBanerCell:weakSelf didClickBanner:item];
            }
        }
    };
    [self.contentView addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;

}

#pragma mark - Setter

- (void)setDatasource:(NSMutableArray *)datasource {
    _datasource = datasource;
    if (_datasource.count == 0) {
        return ;
    }
    NSMutableArray *imagesArray = [NSMutableArray array];
    for (BannerItem *item in _datasource) {
        [imagesArray addObject:item.imageUrl];
    }
    self.cycleScrollView.imageURLStringsGroup = imagesArray;

}

@end
