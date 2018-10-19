//
//  GoodsListChildController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsListChildController.h"
#import "GoodsListCell.h"
#import "CommodityListItem.h"
#import "NewSearchGoodsDetailController.h"
#import "BrandSelectionCell.h"
#import "FilterView.h"
#import "ClassifyOfGoodsListCell.h"
#import "ClassifyItem.h"
#import "GoodsListViewController.h"

@interface GoodsListChildController () <UITableViewDelegate,UITableViewDataSource,FilterViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,ClassifyOfGoodsListCellDelegate,BrandSelectionCellDelegate>

///**    collectionView    */
//@property (strong, nonatomic) UICollectionView *collectionView;
///**    数据源    */
//@property (strong, nonatomic) NSMutableArray *datasource;
///**    页码    */
//@property (assign, nonatomic) NSInteger pageNo;
///**    筛选条件    */
//@property (copy, nonatomic) NSString *sortType;
///**    排序方式    */
//@property (copy, nonatomic) NSString *orderType;
///**    宝贝类型    */
//@property (copy, nonatomic) NSString *babyType;

@property (strong, nonatomic) UITableView *tableView;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;
/**    子分类数组    */
@property(nonatomic,strong) NSMutableArray *subCategoriesArray;
/**    筛选条件    */
@property (copy, nonatomic) NSString *sortType;
/**    排序方式    */
@property (copy, nonatomic) NSString *orderType;
/**    宝贝类型    */
@property (copy, nonatomic) NSString *babyType;
/**    secondSectionHeaderView    */
@property(nonatomic,strong) UIView *secondSectionHeaderView;

@end

static NSString *const classifyCellId = @"classifyCellId";
static NSString *const goodsCellId = @"goodsCellId";

@implementation GoodsListChildController

#pragma mark - Lazy load

- (NSMutableArray *)subCategoriesArray {
    if (!_subCategoriesArray) {
        _subCategoriesArray = [NSMutableArray array];
    }
    return _subCategoriesArray;
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = FooterViewBackgroundColor;
    self.pageNo = 1;
    self.sortType = @"";
    self.orderType = @"";
    self.babyType = @"";
    
    [self loadDataWithPageNo:self.pageNo sortType:self.sortType orderType:self.orderType babyType:self.babyType];
    [self setupUI];
}

#pragma mark Data

// 加载数据
- (void)loadDataWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
    [self subCategoriesData];
    [self getCommodityCategoriesListWithPageNo:pageNo sortType:sortType orderType:orderType babyType:babyType];
}

// 加载更多数据
- (void)loadMoreDataWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
    [self getCommodityCategoriesListWithPageNo:pageNo sortType:sortType orderType:orderType babyType:babyType];
}

// 分类列表
- (void)subCategoriesData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pid"] = self.classifyItem.classifyId;
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/categories" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            NSArray *tempArray = [ClassifyItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            if (tempArray.count > 0) {
                ClassifyItem *firstItem = tempArray[0];
                weakSelf.subCategoriesArray = [NSMutableArray arrayWithArray:firstItem.subCategories];
            }
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 商品列表
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
    //    if (self.classifyItem) {
    //        parameters[@"categoryId"] = self.classifyItem.pid;
    //        parameters[@"subCategoryId"] = self.classifyItem.classifyId;
    //    }
    if (![NSString isEmpty:self.classifyItem.classifyId]) {
        parameters[@"categoryId"] = self.classifyItem.classifyId;
    }
    if (![NSString isEmpty:self.specialCategoryId]) {
        parameters[@"specialCategoryId"] = self.specialCategoryId;
    }
    
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];

    WeakSelf

    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.datasource = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            } else {
                [weakSelf.datasource addObjectsFromArray:[CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
            }
            if ([response[@"data"][@"datas"] count] == 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                if ((weakSelf.datasource.count % PageSize != 0) || weakSelf.datasource.count == 0) { // 有余数说明没有下一页了
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    weakSelf.pageNo++;
                    [weakSelf.tableView.mj_footer endRefreshing];
                }
            }
            [weakSelf.tableView reloadData];
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];

    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[ClassifyOfGoodsListCell class] forCellReuseIdentifier:classifyCellId];
    [tableView registerClass:[BrandSelectionCell class] forCellReuseIdentifier:goodsCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    WeakSelf
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 获取数据
        [weakSelf loadDataWithPageNo:1 sortType:weakSelf.sortType orderType:weakSelf.orderType babyType:weakSelf.babyType];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载更多
        [weakSelf loadMoreDataWithPageNo:weakSelf.pageNo sortType:weakSelf.sortType orderType:weakSelf.orderType babyType:weakSelf.babyType];
    }];
    
    self.tableView.mj_footer.hidden = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(1));
        make.left.right.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(0));
    }];
}

#pragma mark - Button Action

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.tableView.mj_footer.hidden = (self.datasource.count == 0);

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.subCategoriesArray.count == 0) {
            return 0.01;
        }
        NSInteger row = (self.subCategoriesArray.count - 1) / 4 + 1;
        return row * AUTOSIZESCALEX(90) + row * AUTOSIZESCALEX(2);
    }
    if (self.datasource.count == 0) {
        return 0.01;
    }
    NSInteger row = (self.datasource.count - 1) / 2 + 1;
    return row * AUTOSIZESCALEX(280) + row * 0.55;
//    return AUTOSIZESCALEX(850);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return AUTOSIZESCALEX(40);
    }

    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.secondSectionHeaderView;
    }

    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    return section == 3 ? 0.01 : 5;
    return SectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView tableFooterView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ClassifyOfGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:classifyCellId];
        cell.datasource = self.subCategoriesArray;
        cell.delegate = self;
        return cell;
    }

    BrandSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellId];
    cell.datasource = self.datasource;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - Private method

- (UIView *)secondSectionHeaderView {
    if (!_secondSectionHeaderView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(40))];
        headerView.backgroundColor = QHWhiteColor;
        
        NSArray *buttonArray = @[@"销量",@"最新",@"券额",@"券后价",@"宝贝类型"];
        FilterView *filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(40)) buttonArray:buttonArray synthesisArray:@[@"男装",@"女装",@"童装",@"孕装"]];
        filterView.delegate = self;
        [headerView addSubview:filterView];
        
        [filterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView).offset(0);
            make.left.right.bottom.equalTo(headerView);
        }];
        _secondSectionHeaderView = headerView;
    }
    
    return _secondSectionHeaderView;
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

#pragma mark - ClassifyOfGoodsListCellDelegate

- (void)classifyOfGoodsListCell:(ClassifyOfGoodsListCell *)classifyOfGoodsListCell didSelectItem:(ClassifyItem *)item {
    GoodsListViewController *listVc = [[GoodsListViewController alloc] init];
    listVc.title = item.name;
    listVc.categoryId = item.pid;
    listVc.subCategoryId = item.classifyId;
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark - BrandSelectionCellDelegate

- (void)brandSelectionCell:(BrandSelectionCell *)brandSelectionCell didSelectItem:(CommodityListItem *)item {
    NewSearchGoodsDetailController *detailVc = [[NewSearchGoodsDetailController alloc] init];
    detailVc.itemId = item.itemId;
    [self.navigationController pushViewController:detailVc animated:YES];
}

//#pragma mark - Lazy load
//
//- (NSMutableArray *)datasource {
//    if (!_datasource) {
//        _datasource = [NSMutableArray array];
//    }
//    return _datasource;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.pageNo = 1;
//    self.sortType = @"";
//    self.orderType = @"";
//    self.babyType = @"";
//
//    //    [self loadDataWithPageNo:self.pageNo sortType:self.sortType orderType:self.orderType babyType:self.babyType];
//    [self setupUI];
//}
//
//#pragma mark - UI
//
//- (void)setupUI {
//
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = SeparatorLineColor;
//    [self.view addSubview:line];
//
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(kNavHeight);
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(SeparatorLineHeight);
//    }];
//
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//
//    layout.itemSize = CGSizeMake((SCREEN_WIDTH - SeparatorLineHeight) / 2, AUTOSIZESCALEX(280));
//    layout.minimumLineSpacing = SeparatorLineHeight;
//    layout.minimumInteritemSpacing = SeparatorLineHeight;
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//    collectionView.delegate = self;
//    collectionView.dataSource = self;
//    collectionView.emptyDataSetDelegate = self;
//    collectionView.emptyDataSetSource = self;
//    collectionView.backgroundColor = ViewControllerBackgroundColor;
//    collectionView.showsHorizontalScrollIndicator = NO;
//    //    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(24), 0, AUTOSIZESCALEX(24));
//    [collectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:listCellId];
//
//    [self.view addSubview:collectionView];
//    self.collectionView = collectionView;
//
//    WeakSelf
//    // 下拉刷新
//    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 获取数据
//        [weakSelf loadDataWithPageNo:1 sortType:weakSelf.sortType orderType:weakSelf.orderType babyType:weakSelf.babyType];
//    }];
//
//    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        // 上拉加载更多
//        [weakSelf loadDataWithPageNo:weakSelf.pageNo sortType:weakSelf.sortType orderType:weakSelf.orderType babyType:weakSelf.babyType];
//    }];
//
//    self.collectionView.mj_footer.hidden = YES;
//
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(SeparatorLineHeight);
//        make.left.right.bottom.equalTo(self.view);
//    }];
//}
//
//#pragma mark - Data
//
//// 加载数据
//- (void)loadDataWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
////    if (self.type == CommodityOfBrand) { // 品牌商家
////        [self getBrandCommodityListWithPageNo:pageNo sortType:sortType orderType:orderType babyType:babyType];
////    } else if (self.type == CommodityOfTodayRecommend) { // 今日推荐
////        [self getTodayRecommendListWithPageNo:pageNo sortType:sortType orderType:orderType babyType:babyType];
////    } else if (self.type == CommodityOfCategories) { // 商品分类
////        [self getCommodityCategoriesListWithPageNo:pageNo sortType:sortType orderType:orderType babyType:babyType];
////    } else if (self.type == CommodityOfSpecialCategories) { // 特色分类
////        [self getSpecialCommodityListWithPageNo:pageNo sortType:sortType orderType:orderType babyType:babyType];
////    }
//}
//
//// 品牌专区商品列表
//- (void)getBrandCommodityListWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
////    parameters[@"brandSellerId"] = _brandItem.sellerId;
////    if (![NSString isEmpty:sortType]) {
////        // 排序字段 1销量 2- 最新 3-券额 4-券后价 默认1
////        parameters[@"sortType"] = sortType;
////    }
////    if (![NSString isEmpty:orderType]) {
////        // 排序 方式 1-升序 2-降序 默认1
////        parameters[@"orderType"] = orderType;
////    }
////    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
////    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
////
////    WeakSelf
////
////    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/brandCommodityList" parameters:parameters successBlock:^(id response) {
////        [weakSelf handleData:response pageNo:pageNo];
////    } failureBlock:^(NSString *error) {
////        [weakSelf.collectionView.mj_header endRefreshing];
////        [weakSelf.collectionView.mj_footer endRefreshing];
////    }];
//}
//
//// 今日推荐商品列表
//- (void)getTodayRecommendListWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
//    if (![NSString isEmpty:sortType]) {
//        // 排序字段 1销量 2- 最新 3-券额 4-券后价 默认1
//        parameters[@"sortType"] = sortType;
//    }
//    if (![NSString isEmpty:orderType]) {
//        // 排序 方式 1-升序 2-降序 默认1
//        parameters[@"orderType"] = orderType;
//    }
//    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
//    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
//
//    WeakSelf
//
//    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/todayRecommendedCommodityList" parameters:parameters successBlock:^(id response) {
//        [weakSelf handleData:response pageNo:pageNo];
//    } failureBlock:^(NSString *error) {
//        [weakSelf.collectionView.mj_header endRefreshing];
//        [weakSelf.collectionView.mj_footer endRefreshing];
//    }];
//}
//
//// 商品分类列表
//- (void)getCommodityCategoriesListWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
////    parameters[@"categoryId"] = _categoriesItem.categoriesId;
////    if (![NSString isEmpty:babyType]) {
////        // 宝贝类型 1-淘宝 2-天猫 不传则为全部
////        parameters[@"type"] = babyType;
////    }
////    if (![NSString isEmpty:sortType]) {
////        // 排序字段 1销量 2- 最新 3-券额 4-券后价 默认1
////        parameters[@"sortType"] = sortType;
////    }
////    if (![NSString isEmpty:orderType]) {
////        // 排序 方式 1-升序 2-降序 默认1
////        parameters[@"orderType"] = orderType;
////    }
////    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
////    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
////
////    WeakSelf
////
////    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodityList" parameters:parameters successBlock:^(id response) {
////        [weakSelf handleData:response pageNo:pageNo];
////    } failureBlock:^(NSString *error) {
////        [weakSelf.collectionView.mj_header endRefreshing];
////        [weakSelf.collectionView.mj_footer endRefreshing];
////    }];
//}
//
//// 特色分类列表
//- (void)getSpecialCommodityListWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
////    parameters[@"specialCategoryId"] = _specialItem.specialCategoriesId;
////    if (![NSString isEmpty:babyType]) {
////        // 宝贝类型 1-淘宝 2-天猫 不传则为全部
////        parameters[@"type"] = babyType;
////    }
////    if (![NSString isEmpty:sortType]) {
////        // 排序字段 1销量 2- 最新 3-券额 4-券后价 默认1
////        parameters[@"sortType"] = sortType;
////    }
////    if (![NSString isEmpty:orderType]) {
////        // 排序 方式 1-升序 2-降序 默认1
////        parameters[@"orderType"] = orderType;
////    }
////    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
////    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
////
////    WeakSelf
////
////    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/specialCommodityList" parameters:parameters successBlock:^(id response) {
////        [weakSelf handleData:response pageNo:pageNo];
////    } failureBlock:^(NSString *error) {
////        [weakSelf.collectionView.mj_header endRefreshing];
////        [weakSelf.collectionView.mj_footer endRefreshing];
////    }];
//}
//
//// 统一处理数据
//- (void)handleData:(id)response pageNo:(NSInteger)pageNo {
//    WeakSelf
//    if ([response[@"code"] integerValue] == RequestSuccess) {
//        if (pageNo == 1) {
//            weakSelf.pageNo = 1;
//            weakSelf.datasource = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
//            [weakSelf.collectionView reloadData];
//        } else {
//            [weakSelf.datasource addObjectsFromArray:[CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
//        }
//        if ([response[@"data"][@"datas"] count] == 0) {
//            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
//        } else {
//            if ((weakSelf.datasource.count % PageSize != 0) || weakSelf.datasource.count == 0) { // 有余数说明没有下一页了
//                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
//            } else {
//                weakSelf.pageNo++;
//                [weakSelf.collectionView.mj_footer endRefreshing];
//            }
//        }
//
//        [weakSelf.collectionView reloadData];
//    } else {
//        [weakSelf.collectionView.mj_footer endRefreshing];
//        [WYProgress showErrorWithStatus:response[@"msg"]];
//    }
//    [weakSelf.collectionView.mj_header endRefreshing];
//}
//
//#pragma mark - UICollectionViewDataSource
//
//- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    self.collectionView.mj_footer.hidden = (self.datasource.count == 0);
//
//    //    return self.datasource.count;
//    return 10;
//}
//
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    GoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellId forIndexPath:indexPath];
//    //    cell.item = self.datasource[indexPath.row];
//    return cell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    WYLog(@"indexPath = %zd",indexPath.row);
//
//    GoodsDetailController *detailVc = [[GoodsDetailController alloc] init];
//    //    detailVc.item = self.datasource[indexPath.row];
//    [self.navigationController pushViewController:detailVc animated:YES];
//}
//
//#pragma mark - DZNEmptyDataSetSource Methods
//
//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
//    return ImageWithNamed(@"浏览无数据");
//}
//
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"当前没有数据";
//    UIFont *font = [UIFont systemFontOfSize:16.0];
//    UIColor *textColor = ColorWithHexString(@"999999");
//
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    [attributes setObject:font forKey:NSFontAttributeName];
//    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}
//
////- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
////{
////    NSString *text = @"没有找到相关的宝贝";
////    UIFont *font = [UIFont systemFontOfSize:16.0];
////    UIColor *textColor = ColorWithHexString(@"999999");
////
////    NSMutableDictionary *attributes = [NSMutableDictionary new];
////    [attributes setObject:font forKey:NSFontAttributeName];
////    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
////
////    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
////}
//
//
//- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return RGB(239, 239, 239);
//}
//
//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
//{
//    return -kNavHeight;
//}
//
//#pragma mark - DZNEmptyDataSetDelegate Methods
//
//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
//{
//    return YES;
//}
//
//- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
//{
//    return YES;
//}
//
//- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
//{
//    return YES;
//}
//
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
//{
//    WYFunc
//}
//
//- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
//{
//
//}




@end
