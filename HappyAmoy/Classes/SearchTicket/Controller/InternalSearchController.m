//
//  InternalSearchController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "InternalSearchController.h"
#import "GoodsListCell.h"
#import "FilterView.h"
#import "BrandSellerListItem.h"
#import "CommodityListItem.h"
#import "CommodityCategoriesItem.h"
#import "NewSearchGoodsDetailController.h"
#import "CommoditySpecialCategoriesItem.h"

@interface InternalSearchController () <UICollectionViewDataSource,UICollectionViewDelegate,FilterViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**    筛选条件的view    */
@property (strong, nonatomic) UIView *filterView;
/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;
/**    筛选条件    */
@property (copy, nonatomic) NSString *sortType;
/**    排序方式    */
@property (copy, nonatomic) NSString *orderType;
/**    宝贝类型    */
@property (copy, nonatomic) NSString *babyType;

@end

static NSString *const listCellId = @"listCellId";

@implementation InternalSearchController

#pragma mark - Lazy load

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    self.sortType = @"";
    self.orderType = @"";
    self.babyType = @"";
    
    [self loadDataWithPageNo:self.pageNo sortType:self.sortType orderType:self.orderType babyType:self.babyType];
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    NSArray *buttonArray = @[@"销量",@"最新",@"券额",@"券后价",@"宝贝类型"];
    
    FilterView *filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, AUTOSIZESCALEX(45)) buttonArray:buttonArray synthesisArray:@[@"男装",@"女装",@"童装",@"孕装"]];
    filterView.delegate = self;
    [self.view addSubview:filterView];
    self.filterView = filterView;
    
    [self.filterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(AUTOSIZESCALEX(45));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - SeparatorLineHeight) / 2, AUTOSIZESCALEX(280));
    layout.minimumLineSpacing = SeparatorLineHeight;
    layout.minimumInteritemSpacing = SeparatorLineHeight;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.emptyDataSetDelegate = self;
    collectionView.emptyDataSetSource = self;
    collectionView.backgroundColor = ViewControllerBackgroundColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    //    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(24), 0, AUTOSIZESCALEX(24));
    [collectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:listCellId];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    WeakSelf
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 获取数据
        [weakSelf loadDataWithPageNo:1 sortType:weakSelf.sortType orderType:weakSelf.orderType babyType:weakSelf.babyType];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载更多
        [weakSelf loadDataWithPageNo:weakSelf.pageNo sortType:weakSelf.sortType orderType:weakSelf.orderType babyType:weakSelf.babyType];
    }];
    
    self.collectionView.mj_footer.hidden = YES;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Data

// 加载数据
- (void)loadDataWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
    [self getCommodityCategoriesListWithPageNo:pageNo sortType:sortType orderType:orderType babyType:babyType];
}

// 商品分类列表
- (void)getCommodityCategoriesListWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (![NSString isEmpty:babyType]) {
        // 宝贝类型 1-淘宝 2-天猫 不传则为全部
        parameters[@"type"] = babyType;
    }
    if (![NSString isEmpty:sortType]) {
        // 排序字段 1销量 2- 最新 3-券额 4-券后价 默认1
        parameters[@"sortType"] = sortType;
    }
    if (![NSString isEmpty:orderType]) {
        // 排序 方式 1-升序 2-降序 默认1
        parameters[@"orderType"] = orderType;
    }
    parameters[@"keywords"] = self.keyword;
    
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
    
    NSString *userId = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"userId"] = userId;
    
    WeakSelf
//    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
    [[NetworkSingleton sharedManager] getCoRequestWithUrl:@"/Search" parameters:parameters successBlock:^(id response) {
        [weakSelf handleData:response pageNo:pageNo];
    } failureBlock:^(NSString *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

// 统一处理数据
- (void)handleData:(id)response pageNo:(NSInteger)pageNo {
    WeakSelf
    if ([response[@"code"] integerValue] == 1) {
        if (pageNo == 1) {
            weakSelf.pageNo = 1;
            weakSelf.datasource = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"list"]];
            [weakSelf.collectionView reloadData];
        } else {
            [weakSelf.datasource addObjectsFromArray:[CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"list"]]];
        }
        if ([response[@"data"][@"list"] count] == 0) {
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            if ((weakSelf.datasource.count % PageSize != 0) || weakSelf.datasource.count == 0) { // 有余数说明没有下一页了
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                weakSelf.pageNo++;
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
        }
        
        [weakSelf.collectionView reloadData];
    } else {
        [weakSelf.collectionView.mj_footer endRefreshing];
        [WYProgress showErrorWithStatus:response[@"msg"]];
    }
    [weakSelf.collectionView.mj_header endRefreshing];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.mj_footer.hidden = (self.datasource.count == 0);
    
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellId forIndexPath:indexPath];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYLog(@"indexPath = %zd",indexPath.row);
    
    NewSearchGoodsDetailController *detailVc = [[NewSearchGoodsDetailController alloc] init];
    CommodityListItem *item = self.datasource[indexPath.row];
    detailVc.itemId = item.itemId;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - FilterViewDelegate

// 选择宝贝类型
- (void)filterView:(FilterView *)filterView didClickBabyType:(NSInteger)babyType {
    if (babyType == 0) {
        WYLog(@"淘宝");
        self.babyType = @"1";
    } else {
        WYLog(@"天猫");
        self.babyType = @"2";
    }
    [self loadDataWithPageNo:1 sortType:self.sortType orderType:self.orderType babyType:self.babyType];
}

// 选择筛选条件
- (void)filterView:(FilterView *)filterView didClickIndex:(NSInteger)index {
    if (index == 1) {
        WYLog(@"销量");
        self.sortType = @"1";
        self.orderType = @"2";
    } else if (index == 2) {
        WYLog(@"最新");
        self.sortType = @"2";
        self.orderType = @"2";
    } else if (index == 3) {
        WYLog(@"券额");
        self.sortType = @"3";
        self.orderType = @"2";
    } else if (index == 4) {
        WYLog(@"券后价");
        self.sortType = @"4";
        self.orderType = @"1";
    }
    
    [self loadDataWithPageNo:1 sortType:self.sortType orderType:self.orderType babyType:self.babyType];
    
}

#pragma mark - DZNEmptyDataSetSource Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ImageWithNamed(@"search_noResultData");
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有搜索结果";
    UIFont *font = [UIFont systemFontOfSize:18.0];
    UIColor *textColor = ColorWithHexString(@"333333");
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有找到相关的宝贝";
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UIColor *textColor = ColorWithHexString(@"999999");
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return RGB(239, 239, 239);
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -0;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    WYFunc
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
}





@end
