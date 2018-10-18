//
//  QHNewFetureController.m
//  QianHong
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import "QHNewFetureController.h"
#import "QHNewFeatureCell.h"
#import "LoginViewController.h"
#import "BootPagesItem.h"
#import "WYTabBarController.h"
#import "WYDrawCircleProgressView.h"

@interface QHNewFetureController () <UICollectionViewDelegate,UICollectionViewDataSource,QHNewFeatureCellDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
/**    分页指示器    */
@property (strong, nonatomic) UIPageControl *pageControl;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
// 跳过按钮
@property (nonatomic, strong) WYDrawCircleProgressView *drawCircleBtn;

@end

static NSString *const featureCellId = @"featureCellId";

@implementation QHNewFetureController

#pragma mark - Lazy load

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        [_datasource addObject:ImageWithNamed(@"引导页1")];
        [_datasource addObject:ImageWithNamed(@"引导页2")];
        [_datasource addObject:ImageWithNamed(@"引导页3")];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:SCREEN_FRAME collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = NO;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[QHNewFeatureCell class] forCellWithReuseIdentifier:featureCellId];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
        
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QHNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:featureCellId forIndexPath:indexPath];
    
    cell.delegate = self;

    cell.featureImage = self.datasource[indexPath.row];
    cell.isLastFeature = (indexPath.row == (self.datasource.count - 1));
    
    return cell;
}

#pragma mark - QHNewFeatureCellDelegate
// 即刻开启
- (void)newFeatureCell:(QHNewFeatureCell *)newFeatureCell didClickStartAtOnce:(UIButton *)sender {
    WYFunc
    
    [UIApplication sharedApplication].keyWindow.rootViewController =  [[WYTabBarController alloc] init];
}


@end
