//
//  SpecialSessionViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SpecialSessionViewController.h"
#import "SpecialSectionHeaderView.h"
#import "TodayRecommendOfSpecialCell.h"

#import "BrandAreaCell.h"
#import "MustBuyListCell.h"
#import "GoodsListViewController.h"
#import "CommodityListItem.h"
#import "BannerItem.h"
#import "NewSearchGoodsDetailController.h"
#import "WebViewController.h"

#import "BrandTypeCell.h"
#import "BrandBanerCell.h"
#import "BrandImportCell.h"
#import "BrandSelectionCell.h"

#import "CommodityCategoriesItem.h"
#import "GoodsListOfNewController.h"

@interface SpecialSessionViewController () <UITableViewDelegate,UITableViewDataSource,BrandAreaCellDelegate,BrandTypeCellDelegate,BrandBanerCellDelegate,BrandSelectionCellDelegate,BrandImportCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
/**    banner数组    */
@property (strong, nonatomic) NSMutableArray *bannerArray;
/**    品牌精选商品列表    */
@property (strong, nonatomic) NSMutableArray *ppjxCommodityListArray;
/**    进口优选商品列表    */
@property (strong, nonatomic) NSMutableArray *jkyxCommodityListArray;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;
/**    商品分类数组    */
@property(nonatomic,strong) NSMutableArray *categoriesArray;
/**    置顶按钮    */
@property(nonatomic,strong) UIButton *topButton;

@end

static NSString *const brandTypeCellId = @"brandTypeCellId";
static NSString *const bannerCellId = @"bannerCellId";
static NSString *const importCellId = @"importCellId";
static NSString *const brandSelectionCellId = @"brandSelectionCellId";

@implementation SpecialSessionViewController

#pragma mark - Lazy load

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)categoriesArray {
    if (!_categoriesArray) {
        _categoriesArray = [NSMutableArray array];
    }
    return _categoriesArray;
}

- (NSMutableArray *)jkyxCommodityListArray {
    if (!_jkyxCommodityListArray) {
        _jkyxCommodityListArray = [NSMutableArray array];
    }
    return _jkyxCommodityListArray;
}

- (NSMutableArray *)ppjxCommodityListArray {
    if (!_ppjxCommodityListArray) {
        _ppjxCommodityListArray = [NSMutableArray array];
    }
    return _ppjxCommodityListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"品牌精选";
    self.view.backgroundColor = FooterViewBackgroundColor;
    self.pageNo = 1;

    [self loadDataWithPageNo:self.pageNo];
    [self setupUI];
}

#pragma mark Data

// 加载数据
- (void)loadDataWithPageNo:(NSInteger)pageNo {
    [self moduleCategories];
    [self getBannerData];
    [self getJKYXCommodityList];
    [self getPPJXCommodityListWithPageNo:pageNo];
}

// 加载更多数据
- (void)loadMoreDataWithPageNo:(NSInteger)pageNo {
    [self getPPJXCommodityListWithPageNo:pageNo];
}

// 轮播图
- (void)getBannerData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"type"] = @"2";
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/banners" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.bannerArray = [BannerItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [WYHud showMessage:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 品牌精选商品分类
- (void)moduleCategories {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 1-爱生活 2-品牌精选
    parameters[@"module"] = @"2";
    
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

// 进口优选列表
- (void)getJKYXCommodityList {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
//    parameters[@"module"] = @"2";
    parameters[@"imported"] = @"1";
    parameters[@"page"] = @"1";
    parameters[@"size"] = @"50";
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
       
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.jkyxCommodityListArray = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }

    } failureBlock:^(NSString *error) {
        
    }];
}

// 品牌精选商品列表
- (void)getPPJXCommodityListWithPageNo:(NSInteger)pageNo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"module"] = @"2";
    parameters[@"imported"] = @"0";
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];

    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.ppjxCommodityListArray = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.ppjxCommodityListArray addObjectsFromArray:[CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
            }
            if ([response[@"data"][@"datas"] count] == 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                if ((weakSelf.ppjxCommodityListArray.count % PageSize != 0) || weakSelf.ppjxCommodityListArray.count == 0) { // 有余数说明没有下一页了
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
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[BrandTypeCell class] forCellReuseIdentifier:brandTypeCellId];
    [tableView registerClass:[BrandBanerCell class] forCellReuseIdentifier:bannerCellId];
    [tableView registerClass:[BrandImportCell class] forCellReuseIdentifier:importCellId];
    [tableView registerClass:[BrandSelectionCell class] forCellReuseIdentifier:brandSelectionCellId];
//    tableView.tableHeaderView = self.cycleScrollView;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    WeakSelf
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 获取数据
        [weakSelf loadDataWithPageNo:1];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载更多
        [weakSelf loadMoreDataWithPageNo:weakSelf.pageNo];
    }];
    
    self.tableView.mj_footer.hidden = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(1));
        make.left.right.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(0));
    }];
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[topButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }];
    [topButton setImage:ImageWithNamed(@"置顶") forState:UIControlStateNormal];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-kTabbar_Bottum_Height-SafeAreaBottomHeight-AUTOSIZESCALEX(25));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-12.5));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(40), AUTOSIZESCALEX(40)));
    }];
}

#pragma mark - Button Action
// 点击轮播图
- (void)didClickBannerWithBannerId:(NSString *)bannerId {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:[NSString stringWithFormat:@"/system/banner/%@",bannerId] parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            
        } else {
            
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.tableView.mj_footer.hidden = (self.ppjxCommodityListArray.count == 0);

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return AUTOSIZESCALEX(240);
    } else if (indexPath.section == 1) {
        return AUTOSIZESCALEX(150);
    } else if (indexPath.section == 2) {
        if (self.jkyxCommodityListArray.count == 0) {
            return AUTOSIZESCALEX(0.01);
        }
        return AUTOSIZESCALEX(260);
    }
    if (self.ppjxCommodityListArray.count == 0) {
        return AUTOSIZESCALEX(0.01);
    }
    NSInteger row = (self.ppjxCommodityListArray.count - 1) / 2 + 1;
    return (row * AUTOSIZESCALEX(280) + row * AUTOSIZESCALEX(1));

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 || section == 3) {
        return AUTOSIZESCALEX(50);
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return [self thirdSectionHeaderView];
    } else if (section == 3) {
        return [self fourthSectionHeaderView];
    } else {
        return [[UIView alloc] init];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //    return section == 3 ? 0.01 : 5;
    return SectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView tableFooterView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.section == 0) {
//        BrandAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendCellId];
//        cell.delegate = self;
//        cell.datasource = self.todayRecommendedCommodityListArray;
//        return cell;
//    }
//    MustBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:specialCellId];
//    cell.item = self.nineCommodityListArray[indexPath.row];
//    return cell;
    if (indexPath.section == 0) {
        BrandTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:brandTypeCellId];
        cell.datasource = self.categoriesArray;
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 1) {
        BrandBanerCell *cell = [tableView dequeueReusableCellWithIdentifier:bannerCellId];
        cell.delegate = self;
        cell.datasource = self.bannerArray;
        return cell;
    } else if (indexPath.section == 2) {
        BrandImportCell *cell = [tableView dequeueReusableCellWithIdentifier:importCellId];
        cell.datasource = self.jkyxCommodityListArray;
        cell.delegate = self;
        return cell;
    } else {
        BrandSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:brandSelectionCellId];
        cell.delegate = self;
        cell.datasource = self.ppjxCommodityListArray;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > AUTOSIZESCALEX(2000)) {
        self.topButton.hidden = NO;
    } else {
        self.topButton.hidden = YES;
    }
}

#pragma mark - Private method

- (UIView *)thirdSectionHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(55))];
    headerView.backgroundColor = QHWhiteColor;
    
    UIButton *line = [UIButton buttonWithType:UIButtonTypeCustom];
    line.frame = CGRectMake(AUTOSIZESCALEX(10), AUTOSIZESCALEX(13.5), AUTOSIZESCALEX(3), AUTOSIZESCALEX(23));
    [line gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(3), AUTOSIZESCALEX(23)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [headerView addSubview:line];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(AUTOSIZESCALEX(23), AUTOSIZESCALEX(15), AUTOSIZESCALEX(100), AUTOSIZESCALEX(20))];
    descLabel.text = @"进口优选";
    descLabel.textColor = ColorWithHexString(@"#575054");
    descLabel.font = AppMainTextFont(16);
    [headerView addSubview:descLabel];
    
    UIView *bottomLine = [UIView separatorLine:CGRectMake(0, AUTOSIZESCALEX(49.5), SCREEN_WIDTH, AUTOSIZESCALEX(0.5))];
    [headerView addSubview:bottomLine];
    
    return headerView;
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
    [WYUtils TextGradientview:descLabel bgVIew:headerView gradientColors:@[(id)ColorWithHexString(@"#F96C74").CGColor, (id)ColorWithHexString(@"#FB4F67").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
    
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
    GoodsListViewController *listVc = [[GoodsListViewController alloc] init];
//    listVc.type = CommodityOfTodayRecommend;
//    NSArray *titles = @[@"个人护理",@"大牌护肤",@"休闲零食",@"家居护理",@"口碑面膜",@"彩妆"];
    listVc.module = @"2";
    listVc.moduleCategoryId = item.categoriesId;
    listVc.title = item.name;
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark - BrandBanerCellDelegate

- (void)brandBanerCell:(BrandBanerCell *)brandBanerCell didClickBanner:(BannerItem *)item {
    if (item.urlType == 1) { // 页面url
        WebViewController *webVc = [[WebViewController alloc] init];
        webVc.urlString = item.target;
        webVc.title = item.title;
        [self.navigationController pushViewController:webVc animated:YES];
    } else if (item.urlType == 2) { // 特色分类列表
        GoodsListOfNewController *listVc = [[GoodsListOfNewController alloc] init];
        listVc.specialCategoriesId = item.target;
        listVc.title = item.title;
        [self.navigationController pushViewController:listVc animated:YES];
    }
    [self didClickBannerWithBannerId:item.bannerId];
}

#pragma mark - BrandImportCellDelegate

- (void)brandImportCell:(BrandImportCell *)brandImportCell didSelectItem:(CommodityListItem *)item {
    NewSearchGoodsDetailController *detailVc = [[NewSearchGoodsDetailController alloc] init];
    detailVc.itemId = item.itemId;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - BrandSelectionCellDelegate

- (void)brandSelectionCell:(BrandSelectionCell *)brandSelectionCell didSelectItem:(CommodityListItem *)item {
    NewSearchGoodsDetailController *detailVc = [[NewSearchGoodsDetailController alloc] init];
    detailVc.itemId = item.itemId;
    [self.navigationController pushViewController:detailVc animated:YES];
}

@end
