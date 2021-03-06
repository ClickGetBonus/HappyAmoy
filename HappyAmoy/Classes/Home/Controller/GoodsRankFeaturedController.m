//
//  GoodsRankFeaturedController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsRankFeaturedController.h"
#import "GoodsListCell.h"
#import "CommodityListItem.h"
#import "NewSearchGoodsDetailController.h"
#import "GoodsRankListCell.h"
#import "FilterView.h"
#import "ClassifyOfGoodsListCell.h"

@interface GoodsRankFeaturedController () <UITableViewDelegate,UITableViewDataSource,FilterViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;

@end

static NSString *const classifyCellId = @"classifyCellId";
static NSString *const rankCellId = @"rankCellId";

@implementation GoodsRankFeaturedController

#pragma mark - Lazy load

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
    
    [self getGoodsListWithPageNo:self.pageNo];
    [self setupUI];
}

#pragma mark Data

// 商品列表
- (void)getGoodsListWithPageNo:(NSInteger)pageNo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
//    if (![NSString isEmpty:self.specialCategoryId]) {
//        parameters[@"specialCategoryId"] = self.specialCategoryId;
//    }
    
    if (![NSString isEmpty:self.categoryId]) {
        parameters[@"categoryId"] = self.categoryId;
    }

    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];

    WeakSelf

    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.datasource = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
                [weakSelf.tableView reloadData];
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
        [weakSelf getGoodsListWithPageNo:1];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载更多
        [weakSelf getGoodsListWithPageNo:weakSelf.pageNo];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AUTOSIZESCALEX(135);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

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
    GoodsRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:rankCellId];
    cell.index = indexPath.row;
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewSearchGoodsDetailController *detailVc = [[NewSearchGoodsDetailController alloc] init];
    CommodityListItem *item = self.datasource[indexPath.row];
    detailVc.itemId = item.itemId;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - Private method

- (UIView *)secondSectionHeaderView {
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
    
    return headerView;
}

#pragma mark - FilterViewDelegate

// 选择宝贝类型
- (void)filterView:(FilterView *)filterView didClickBabyType:(NSInteger)babyType {
    if (babyType == 0) {
        WYLog(@"淘宝");
        //        self.babyType = @"1";
    } else {
        WYLog(@"天猫");
        //        self.babyType = @"2";
    }
    //    [self loadDataWithPageNo:1 sortType:self.sortType orderType:self.orderType babyType:self.babyType];
}

// 选择筛选条件
- (void)filterView:(FilterView *)filterView didClickIndex:(NSInteger)index {
    if (index == 1) {
        WYLog(@"销量");
        //        self.sortType = @"1";
        //        self.orderType = @"2";
    } else if (index == 2) {
        WYLog(@"最新");
        //        self.sortType = @"2";
        //        self.orderType = @"2";
    } else if (index == 3) {
        WYLog(@"券额");
        //        self.sortType = @"3";
        //        self.orderType = @"2";
    } else if (index == 4) {
        WYLog(@"券后价");
        //        self.sortType = @"4";
        //        self.orderType = @"1";
    }
    
    //    [self loadDataWithPageNo:1 sortType:self.sortType orderType:self.orderType babyType:self.babyType];
    
}


@end
