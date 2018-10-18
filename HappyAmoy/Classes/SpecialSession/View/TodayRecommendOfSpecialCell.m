//
//  TodayRecommendOfSpecialCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TodayRecommendOfSpecialCell.h"
#import "TodayRecommendCell.h"

@interface TodayRecommendOfSpecialCell() <UICollectionViewDelegate,UICollectionViewDataSource>

/**    今日推荐    */
@property (strong, nonatomic) UICollectionView *collectionView;

@end

static NSString *const recommendCellId = @"recommendCellId";

@implementation TodayRecommendOfSpecialCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat itemWH = (SCREEN_WIDTH - AUTOSIZESCALEX(10) * 2) * 0.5;
    
    layout.itemSize = CGSizeMake(itemWH, itemWH * 4 / 3);
    layout.minimumLineSpacing = AUTOSIZESCALEX(5);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(AUTOSIZESCALEX(10), AUTOSIZESCALEX(10), AUTOSIZESCALEX(10), AUTOSIZESCALEX(10));
    [collectionView registerClass:[TodayRecommendCell class] forCellWithReuseIdentifier:recommendCellId];
    
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TodayRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:recommendCellId forIndexPath:indexPath];
    cell.backgroundColor = RandomColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYLog(@"indexPath = %zd",indexPath.row);
}


@end
