//
//  GoodsRankListChildController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsRankListChildController.h"
#import "GoodsListCell.h"
#import "CommodityListItem.h"
#import "GoodsDetailController.h"
#import "GoodsRankListCell.h"
#import "FilterView.h"
#import "ClassifyOfGoodsListCell.h"
#import "ClassifyItem.h"
#import "GoodsListViewController.h"

@interface GoodsRankListChildController () <UITableViewDelegate,UITableViewDataSource,FilterViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,ClassifyOfGoodsListCellDelegate>

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
static NSString *const rankCellId = @"rankCellId";

@implementation GoodsRankListChildController

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
    
    self.view.backgroundColor = ColorWithHexString(@"#F3F3F6");
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
//    if (![NSString isEmpty:self.specialCategoryId]) {
//        parameters[@"specialCategoryId"] = self.specialCategoryId;
//    }
    
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
//    tableView.contentInset = UIEdgeInsetsMake(AUTOSIZESCALEX(5), 0, 0, 0);
    [tableView registerClass:[ClassifyOfGoodsListCell class] forCellReuseIdentifier:classifyCellId];
    [tableView registerClass:[GoodsRankListCell class] forCellReuseIdentifier:rankCellId];
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
    if (section == 0) {
        return 1;
    }
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.subCategoriesArray.count == 0) {
            return 0.01;
        }
        NSInteger row = (self.subCategoriesArray.count - 1) / 4 + 1;
        return row * AUTOSIZESCALEX(90) + row * AUTOSIZESCALEX(2);
    }
    return AUTOSIZESCALEX(135);
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
    GoodsRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:rankCellId];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        GoodsDetailController *detailVc = [[GoodsDetailController alloc] init];
        detailVc.item = self.datasource[indexPath.row];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark - ClassifyOfGoodsListCellDelegate

- (void)classifyOfGoodsListCell:(ClassifyOfGoodsListCell *)classifyOfGoodsListCell didSelectItem:(ClassifyItem *)item {
    GoodsListViewController *listVc = [[GoodsListViewController alloc] init];
    listVc.title = item.name;
    listVc.categoryId = item.pid;
    listVc.subCategoryId = item.classifyId;
    [self.navigationController pushViewController:listVc animated:YES];
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




@end
