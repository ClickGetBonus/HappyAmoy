//
//  NewsReportController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewsReportController.h"
#import "NewsReportItem.h"
#import "NewsReportListCell.h"
#import "NewsReportDetailController.h"

@interface NewsReportController () <UITableViewDelegate,UITableViewDataSource>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    轮播图    */
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/**    banner数组    */
@property (strong, nonatomic) NSMutableArray *bannerArray;
/**    快报数组    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;

@end

static NSString *const listCellId = @"listCellId";

@implementation NewsReportController

#pragma mark - Lazy load

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    self.title = @"好麦快报";

    self.pageNo = 1;
    
    [self setupUI];
    [self loadDataWithPageNo:self.pageNo];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.tableHeaderView = self.cycleScrollView;
    [tableView registerClass:[NewsReportListCell class] forCellReuseIdentifier:listCellId];
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
        make.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        WeakSelf
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(150)) delegate:nil placeholderImage:PlaceHolderMainImage];
        cycleScrollView.localizationImageNamesGroup = @[ImageWithNamed(@"新闻资讯")];
        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            if (weakSelf.bannerArray.count == 0) {
                return ;
                [WYPackagePhotoBrowser showPhotoWithImageArray:[NSMutableArray arrayWithObject:ImageWithNamed(@"新闻资讯")] currentIndex:0];
            } else {
//                BannerItem *item = weakSelf.bannerArray[currentIndex];
//
//                if (item.urlType == 1) { // 页面url
//                    WebViewController *webVc = [[WebViewController alloc] init];
//                    webVc.urlString = item.target;
//                    [weakSelf.navigationController pushViewController:webVc animated:YES];
//                    //                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:item.target]]) {
//                    //                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.target]];
//                    //                    }
//                } else if (item.urlType == 2) { // 特色分类列表
//
//                }
            }
        };
        _cycleScrollView = cycleScrollView;
    }
    return _cycleScrollView;
}

#pragma mark - Data

// 加载数据
- (void)loadDataWithPageNo:(NSInteger)pageNo {
    [self getBannerData];
    [self getArticlesWithPageNo:pageNo];
}

// 加载更多数据
- (void)loadMoreDataWithPageNo:(NSInteger)pageNo {
    [self getArticlesWithPageNo:pageNo];
}

// 轮播图
- (void)getBannerData {
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
//    parameters[@"type"] = @"1";
//    WeakSelf
//    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/banners" parameters:parameters successBlock:^(id response) {
//        if ([response[@"code"] integerValue] == RequestSuccess) {
//            weakSelf.bannerArray = [BannerItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
//            WYLog(@"self.bannerArray = %@",weakSelf.bannerArray);
//            if (weakSelf.bannerArray.count == 0) {
//                return ;
//            }
//            NSMutableArray *imagesArray = [NSMutableArray array];
//            for (BannerItem *item in weakSelf.bannerArray) {
//                [imagesArray addObject:item.imageUrl];
//            }
//            weakSelf.cycleScrollView.imageURLStringsGroup = imagesArray;
//
//            //            weakSelf.headerView.imageArray = imagesArray;
//        } else {
//            [WYHud showMessage:response[@"msg"]];
//        }
//    } failureBlock:^(NSString *error) {
//
//    }];
}

// 省惠快报列表
- (void)getArticlesWithPageNo:(NSInteger)pageNo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
    
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/news/articles" parameters:parameters successBlock:^(id response) {
        
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.datasource = [NewsReportItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.datasource addObjectsFromArray:[NewsReportItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
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

#pragma mark - Button Action

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.datasource.count == 0);

    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AUTOSIZESCALEX(125);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsReportListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellId];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsReportDetailController *detailVc = [[NewsReportDetailController alloc] init];
    detailVc.item = self.datasource[indexPath.row];
    [self.navigationController pushViewController:detailVc animated:YES];
}


@end
