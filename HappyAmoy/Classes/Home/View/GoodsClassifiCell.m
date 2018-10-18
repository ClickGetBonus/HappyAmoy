//
//  GoodsClassifiCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsClassifiCell.h"
#import "GoodsClassifiChildCell.h"
#import "CommodityCategoriesItem.h"

@interface GoodsClassifiCell() <UICollectionViewDataSource,UICollectionViewDelegate>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *typeArray;
/**    分页指示器    */
@property (strong, nonatomic) UIPageControl *pageControl;

@end

static NSString *const goodsCellId = @"goodsCellId";

@implementation GoodsClassifiCell

//- (NSMutableArray *)datasource {
//    if (!_datasource) {
//        _datasource = [NSMutableArray array];
//        [_datasource addObject:ImageWithNamed(@"男装")];
//        [_datasource addObject:ImageWithNamed(@"女装")];
//        [_datasource addObject:ImageWithNamed(@"化妆品")];
//        [_datasource addObject:ImageWithNamed(@"鞋包")];
//        [_datasource addObject:ImageWithNamed(@"母婴")];
//        [_datasource addObject:ImageWithNamed(@"家居用品")];
//        [_datasource addObject:ImageWithNamed(@"食品")];
//        [_datasource addObject:ImageWithNamed(@"其他")];
//    }
//    return _datasource;
//}

//- (NSMutableArray *)typeArray {
//    if (!_typeArray) {
//        _typeArray = [NSMutableArray array];
//        [_typeArray addObject:@"男装"];
//        [_typeArray addObject:@"女装"];
//        [_typeArray addObject:@"化妆品"];
//        [_typeArray addObject:@"鞋包"];
//        [_typeArray addObject:@"母婴"];
//        [_typeArray addObject:@"家具用品"];
//        [_typeArray addObject:@"食品"];
//        [_typeArray addObject:@"其他"];
//    }
//    return _typeArray;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - AUTOSIZESCALEX(0)) / 4, AUTOSIZESCALEX(80));
    layout.minimumLineSpacing = AUTOSIZESCALEX(0);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
//    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(24), 0, AUTOSIZESCALEX(24));
    [collectionView registerClass:[GoodsClassifiChildCell class] forCellWithReuseIdentifier:goodsCellId];
    
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
        make.top.left.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-20));
    }];
    
    // 添加分页指示器
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = 2;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = QHMainColor;
    self.pageControl = pageControl;
    [self.contentView addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-5));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
}

#pragma mark - Setter

- (void)setDatasource:(NSMutableArray *)datasource {
    _datasource = datasource;
    NSInteger tempCount = (_datasource.count - 1);
    NSInteger pageCount = (tempCount / 8 + 1);
    self.pageControl.numberOfPages = pageCount;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsClassifiChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodsCellId forIndexPath:indexPath];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYLog(@"indexPath = %zd",indexPath.row);
    
    if ([_delegate respondsToSelector:@selector(goodsClassifiCell:didSelectItem:)]) {
        [_delegate goodsClassifiCell:self didSelectItem:self.datasource[indexPath.row]];
    }
}

// 滚动就会调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取当前的偏移量，计算当前第几页
    int number = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    self.pageControl.currentPage = number;
}

@end
