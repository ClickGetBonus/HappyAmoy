//
//  LoveLifeController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LoveLifeController.h"
#import "SpecialSectionHeaderView.h"
#import "TodayRecommendOfSpecialCell.h"

#import "BrandAreaCell.h"
#import "MustBuyListCell.h"
#import "GoodsListViewController.h"
#import "CommodityListItem.h"
#import "BannerItem.h"
#import "NewSearchGoodsDetailController.h"

#import "BrandTypeCell.h"
#import "BrandBanerCell.h"
#import "BrandImportCell.h"
#import "BrandSelectionCell.h"
#import "FilterView.h"
#import "GoodsListOfNewController.h"
#import "CommodityCategoriesItem.h"

@interface LoveLifeController () <UITableViewDelegate,UITableViewDataSource,BrandAreaCellDelegate,BrandTypeCellDelegate,FilterViewDelegate,BrandSelectionCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
/**    商品列表    */
@property (strong, nonatomic) NSMutableArray *commodityListArray;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;
/**    商品分类数组    */
@property(nonatomic,strong) NSMutableArray *categoriesArray;
/**    筛选条件    */
@property (copy, nonatomic) NSString *sortType;
/**    排序方式    */
@property (copy, nonatomic) NSString *orderType;
/**    宝贝类型    */
@property (copy, nonatomic) NSString *babyType;
/**    secondSectionHeaderView    */
@property(nonatomic,strong) UIView *secondSectionHeaderView;

@end

static NSString *const brandTypeCellId = @"brandTypeCellId";
static NSString *const bannerCellId = @"bannerCellId";
static NSString *const importCellId = @"importCellId";
static NSString *const brandSelectionCellId = @"brandSelectionCellId";

@implementation LoveLifeController

#pragma mark - Lazy load

- (NSMutableArray *)categoriesArray {
    if (!_categoriesArray) {
        _categoriesArray = [NSMutableArray array];
    }
    return _categoriesArray;
}

- (NSMutableArray *)commodityListArray {
    if (!_commodityListArray) {
        _commodityListArray = [NSMutableArray array];
    }
    return _commodityListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"爱生活";
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
    [self moduleCategories];
    [self getCommodityListWithPageNo:pageNo sortType:sortType orderType:orderType babyType:babyType];
}

// 加载更多数据
- (void)loadMoreDataWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
    [self getCommodityListWithPageNo:pageNo sortType:sortType orderType:orderType babyType:babyType];
}

// 爱生活商品分类
- (void)moduleCategories {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 1-爱生活 2-品牌精选
    parameters[@"module"] = @"1";
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/moduleCategories" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.categoriesArray = [CommodityCategoriesItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 商品列表
- (void)getCommodityListWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
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

    parameters[@"module"] = @"1";
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.commodityListArray = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.commodityListArray addObjectsFromArray:[CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
            }
            if ([response[@"data"][@"datas"] count] == 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                if ((weakSelf.commodityListArray.count % PageSize != 0) || weakSelf.commodityListArray.count == 0) { // 有余数说明没有下一页了
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
    tableView.estimatedRowHeight = 0;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[BrandTypeCell class] forCellReuseIdentifier:brandTypeCellId];
    [tableView registerClass:[BrandBanerCell class] forCellReuseIdentifier:bannerCellId];
    [tableView registerClass:[BrandImportCell class] forCellReuseIdentifier:importCellId];
    [tableView registerClass:[BrandSelectionCell class] forCellReuseIdentifier:brandSelectionCellId];
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
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(1));
        make.left.right.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(0));
    }];
}

#pragma mark - Button Action


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.tableView.mj_footer.hidden = (self.commodityListArray.count == 0);
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return AUTOSIZESCALEX(240);
    }
    
    if (self.commodityListArray.count == 0) {
        return AUTOSIZESCALEX(0.01);
    }
    NSInteger row = (self.commodityListArray.count - 1) / 2 + 1;
    return (row * AUTOSIZESCALEX(280) + row * AUTOSIZESCALEX(1));
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return AUTOSIZESCALEX(40);
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return section == 0 ? [[UIView alloc] init] : self.secondSectionHeaderView;
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
        BrandTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:brandTypeCellId];
        cell.delegate = self;
        cell.datasource = self.categoriesArray;
        return cell;
    } else {
        BrandSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:brandSelectionCellId];
        cell.datasource = self.commodityListArray;
        cell.delegate = self;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (indexPath.section == 1) {
    //        GoodsDetailController *detailVc = [[GoodsDetailController alloc] init];
    //        detailVc.item = self.nineCommodityListArray[indexPath.row];;
    //        [self.navigationController pushViewController:detailVc animated:YES];
    //    }
}

#pragma mark - Private method

//- (UIView *)secondSectionHeaderView {
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(40))];
//    headerView.backgroundColor = QHWhiteColor;
//
//    NSArray *buttonArray = @[@"销量",@"最新",@"券额",@"券后价",@"宝贝类型"];
//    FilterView *filterView = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(40)) buttonArray:buttonArray synthesisArray:@[@"男装",@"女装",@"童装",@"孕装"]];
//    filterView.delegate = self;
//    [headerView addSubview:filterView];
//
//    [filterView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headerView).offset(0);
//        make.left.right.bottom.equalTo(headerView);
//    }];
//
//    return headerView;
//}

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

- (UIView *)fourthSectionHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(55))];
    headerView.backgroundColor = QHWhiteColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"装饰")];
    imageView.frame = CGRectMake(AUTOSIZESCALEX(40), 0, headerView.width - AUTOSIZESCALEX(40) * 2, AUTOSIZESCALEX(9));
    imageView.center = headerView.center;
    [headerView addSubview:imageView];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(DynamicContentLeftSpace, AUTOSIZESCALEX(15), headerView.width - AUTOSIZESCALEX(30), AUTOSIZESCALEX(20))];
    descLabel.text = @"品牌精选";
    descLabel.font = AppMainTextFont(16);
    [headerView addSubview:descLabel];
    [descLabel sizeToFit];
    descLabel.height = AUTOSIZESCALEX(20);
    descLabel.center = headerView.center;
    
    // 文字渐变
    [WYUtils TextGradientview:descLabel bgVIew:headerView gradientColors:@[(id)ColorWithHexString(@"#ffb42b").CGColor, (id)ColorWithHexString(@"#ffb42b").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
    
    UIView *line = [UIView separatorLine:CGRectMake(0, AUTOSIZESCALEX(49.5), SCREEN_WIDTH, AUTOSIZESCALEX(0.5))];
    [headerView addSubview:line];
    
    return headerView;
}

#pragma mark - BrandAreaCellDelegate

- (void)brandAreaCell:(BrandAreaCell *)brandAreaCell didSelectItem:(CommodityListItem *)item {
    NewSearchGoodsDetailController *detailVc = [[NewSearchGoodsDetailController alloc] init];
    detailVc.itemId = item.itemId;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - BrandTypeCellDelegate

- (void)brandTypeCell:(BrandTypeCell *)brandTypeCell didSelectItem:(CommodityCategoriesItem *)item {
//    GoodsListOfNewController *listVc = [[GoodsListOfNewController alloc] init];
////    NSArray *titles = @[@"穿搭达人",@"吃货世界",@"爱上运动",@"宠物用品",@"爱美丽",@"居家百货"];
//    listVc.categoriesItem = item;
//    listVc.title = item.name;
//    [self.navigationController pushViewController:listVc animated:YES];
    
    GoodsListViewController *listVc = [[GoodsListViewController alloc] init];
    listVc.module = @"1";
    listVc.moduleCategoryId = item.categoriesId;
    listVc.title = item.name;
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark - BrandSelectionCellDelegate

- (void)brandSelectionCell:(BrandSelectionCell *)brandSelectionCell didSelectItem:(CommodityListItem *)item {
    NewSearchGoodsDetailController *detailVc = [[NewSearchGoodsDetailController alloc] init];
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


@end
