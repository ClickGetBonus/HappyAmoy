//
//  HomeViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "MessageNoticeController.h"
#import "CustomSearchView.h"
#import "GoodsClassifiCell.h"
#import "MustBuyListCell.h"
#import "PlatfomrCharacterCell.h"
#import "GoodsListViewController.h"
#import "BrandAreaController.h"
#import "GoodsDetailController.h"
#import "BannerItem.h"
#import "CommodityCategoriesItem.h"
#import "CommoditySpecialCategoriesItem.h"
#import "CommodityListItem.h"
#import "MMScanViewController.h"
#import "SearchViewController.h"
#import "WebViewController.h"
#import "VersionItem.h"

#import "NewsReportItem.h"
#import "NewsReportCell.h"
#import "HomeOfShoppingGuideCell.h"
#import "HomeOfNetRedCell.h"
#import "HomeOfLoveLifeCell.h"
#import "BrandSelectionCell.h"

#import "ShoppingGuideController.h"
#import "ShareMakeMoneyController.h"
#import "NewsReportController.h"
#import "LoveLifeController.h"

#import "GoodsListOfNewController.h"
#import "GoodsRankListController.h"
#import "NewSearchTicketController.h"

#import "CategoryScrollView.h"
#import "ClassifyItem.h"
#import "ClassifyOfGoodsListCell.h"
#import "FilterView.h"
#import "HomePopupsView.h"
#import "BenefitGroupBuyController.h"

@interface HomeViewController () <UITableViewDelegate,UITableViewDataSource,GoodsClassifiCellDelegate,PlatfomrCharacterCellDelegate,HomeOfShoppingGuideCellDelegate,HomeOfNetRedCellDelegate,BrandSelectionCellDelegate,CategoryScrollViewDelegate,ClassifyOfGoodsListCellDelegate,FilterViewDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    分类tableView    */
@property (strong, nonatomic) UITableView *categoryTableView;

/**    轮播图    */
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/**    自定义导航栏    */
@property (strong, nonatomic) UIView *navView;
/**    banner数组    */
@property (strong, nonatomic) NSMutableArray *bannerArray;
/**    商品分类数组    */
@property (strong, nonatomic) NSMutableArray *categoriesArray;
/**    商品分类列表数组    */
@property (strong, nonatomic) NSMutableArray *categoryListArray;
/**    特色商品分类数组    */
@property (strong, nonatomic) NSMutableArray *commoditySpecialCategoriesArray;
/**    必买清单商品列表数组    */
@property (strong, nonatomic) NSMutableArray *needBuyedListArray;
/**    快报列表数组    */
@property(nonatomic,strong) NSMutableArray *articlesArray;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;
/**    商品分类页码    */
@property (assign, nonatomic) NSInteger categoryPageNo;
/**    扫一扫    */
@property (strong, nonatomic) UILabel *scanLabel;
/**    扫一扫图标    */
@property (strong, nonatomic) UIImageView *scanImageView;
/**    消息    */
@property (strong, nonatomic) UILabel *messageLabel;
/**    消息图标    */
@property (strong, nonatomic) UIImageView *messageImageView;
/**    置顶按钮    */
@property(nonatomic,strong) UIButton *topButton;
/**    分类滑动条    */
@property(nonatomic,strong) CategoryScrollView *categoryView;
/**    全部分类    */
@property(nonatomic,strong) NSMutableArray *subCategories;
/**    分类ID    */
@property(nonatomic,copy) NSString *categoryId;

@property(nonatomic,strong) UIView *secondSectionHeaderView;
/**    标记是否第一次加载    */
@property(nonatomic,assign) BOOL firstLoad;
/**    筛选条件    */
@property (copy, nonatomic) NSString *sortType;
/**    排序方式    */
@property (copy, nonatomic) NSString *orderType;
/**    宝贝类型    */
@property (copy, nonatomic) NSString *babyType;

@end

static NSString *const reportCellId = @"reportCellId";
static NSString *const characterCellId = @"characterCellId";
static NSString *const guideCellId = @"guideCellId";
static NSString *const lifeCellId = @"lifeCellId";
static NSString *const netRedCellId = @"netRedCellId";
static NSString *const mustBuyCellId = @"mustBuyCellId";
static NSString *const subCategoriesCellId = @"subCategoriesCellId";
static NSString *const categoriesListCellId = @"categoriesListCellId";

@implementation HomeViewController

#pragma mark - Lazy load

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)articlesArray {
    if (!_articlesArray) {
        _articlesArray = [NSMutableArray array];
    }
    return _articlesArray;
}

- (NSMutableArray *)categoriesArray {
    if (!_categoriesArray) {
        _categoriesArray = [NSMutableArray array];
    }
    return _categoriesArray;
}

- (NSMutableArray *)subCategories {
    if (!_subCategories) {
        _subCategories = [NSMutableArray array];
    }
    return _subCategories;
}

- (NSMutableArray *)categoryListArray {
    if (!_categoryListArray) {
        _categoryListArray = [NSMutableArray array];
    }
    return _categoryListArray;
}

- (NSMutableArray *)commoditySpecialCategoriesArray {
    if (!_commoditySpecialCategoriesArray) {
        _commoditySpecialCategoriesArray = [NSMutableArray array];
    }
    return _commoditySpecialCategoriesArray;
}

- (CategoryScrollView *)categoryView {
    if (!_categoryView) {
        CategoryScrollView *categoryView = [[CategoryScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, AUTOSIZESCALEX(40))];
        categoryView.delegate = self;
        categoryView.hidden = YES;
        [self.view addSubview:categoryView];
        _categoryView = categoryView;
    }
    return _categoryView;
}

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

- (UITableView *)categoryTableView {
    if (!_categoryTableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = self.view.backgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedRowHeight = 0;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [tableView registerClass:[ClassifyOfGoodsListCell class] forCellReuseIdentifier:subCategoriesCellId];
        [tableView registerClass:[BrandSelectionCell class] forCellReuseIdentifier:categoriesListCellId];
        [self.view addSubview:tableView];
        _categoryTableView = tableView;
        WeakSelf
        _categoryTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            // 上拉加载更多
            [weakSelf getCategoryListWithPageNo:weakSelf.categoryPageNo sortType:weakSelf.sortType orderType:weakSelf.orderType babyType:weakSelf.babyType];
        }];
        _categoryTableView.mj_footer.hidden = YES;
        
        [_categoryTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(40));
            make.left.right.bottom.equalTo(self.view).offset(0);
        }];

    }
    return _categoryTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = ViewControllerBackgroundColor;
    self.pageNo = 1;
    self.categoryPageNo = 1;
    self.firstLoad = YES;
    self.sortType = @"";
    self.orderType = @"";
    self.babyType = @"";

    [self setupUI];
    [self setupNav];
    [self loadDataWithPageNo:self.pageNo];
    [self getContact];
    [self getVersion];
    self.categoryTableView.hidden = YES;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
        // Fallback on earlier versions
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Data

// 加载数据
- (void)loadDataWithPageNo:(NSInteger)pageNo {
    [self getBannerData];
    [self getArticles];
    [self getFirstCategories];
    [self getCommoditySpecialCategories];
    [self getNeedBuyedListWithPageNo:pageNo];
}

// 加载更多数据
- (void)loadMoreDataWithPageNo:(NSInteger)pageNo {
    [self getNeedBuyedListWithPageNo:pageNo];
}

// 轮播图
- (void)getBannerData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    parameters[@"type"] = @"1";
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/banners" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.bannerArray = [BannerItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            WYLog(@"self.bannerArray = %@",weakSelf.bannerArray);
            if (weakSelf.bannerArray.count == 0) {
                return ;
            }
            NSMutableArray *imagesArray = [NSMutableArray array];
            for (BannerItem *item in weakSelf.bannerArray) {
                [imagesArray addObject:item.imageUrl];
            }
            weakSelf.cycleScrollView.imageURLStringsGroup = imagesArray;

//            weakSelf.headerView.imageArray = imagesArray;
        } else {
            [WYHud showMessage:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {

    }];
}

// 获取省惠快报列表
- (void)getArticles {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",1];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
    
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/news/articles" parameters:parameters successBlock:^(id response) {
        
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.articlesArray = [NewsReportItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {

    }];
}

// 一级分类
- (void)getFirstCategories {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/categories" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.categoriesArray = [ClassifyItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            ClassifyItem *item = [[ClassifyItem alloc] init];
            item.name = @"精选";
            [weakSelf.categoriesArray insertObject:item atIndex:0];
            weakSelf.categoryView.categoriesArray = weakSelf.categoriesArray;
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 获取特色商品分类列表
- (void)getCommoditySpecialCategories {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"page"] = @"1";
    parameters[@"size"] = @"50";

    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/commoditySpecialCategories" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.commoditySpecialCategoriesArray = [CommoditySpecialCategoriesItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            WYLog(@"self.commoditySpecialCategoriesArray = %@",weakSelf.commoditySpecialCategoriesArray);
            [weakSelf.tableView reloadData];
        } else {
            [WYHud showMessage:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 必买清单商品列表
- (void)getNeedBuyedListWithPageNo:(NSInteger)pageNo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"needBuyed"] = @"1";
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];

    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
        
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.needBuyedListArray = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.needBuyedListArray addObjectsFromArray:[CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
            }
            
            if ((weakSelf.needBuyedListArray.count % PageSize != 0) || weakSelf.needBuyedListArray.count == 0) { // 有余数说明没有下一页了
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                weakSelf.pageNo++;
                [weakSelf.tableView.mj_footer endRefreshing];
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

// 获取客服电话
- (void)getContact {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/contact" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [LoginUserDefault userDefault].consumerHotline = response[@"data"];
        } else {
//            [WYHud showMessage:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 版本更新
- (void)getVersion {
    
    WeakSelf
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"machineType"] = @"2";
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/version" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [LoginUserDefault userDefault].versionItem = [VersionItem mj_objectWithKeyValues:response[@"data"]];
            [LoginUserDefault userDefault].versionDataHaveChanged = ![LoginUserDefault userDefault].versionDataHaveChanged;
            // 弹窗
            [weakSelf showPopupView];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - Nav

- (void)setupNav {
    
    UIView *navView = [[UIView alloc] init];
    navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:navView];
    self.navView = navView;
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(kNavHeight);
    }];
    WeakSelf
    CustomSearchView *searchView = [[CustomSearchView alloc] initWithFrame:CGRectMake(0, 0, AUTOSIZESCALEX(295), AUTOSIZESCALEX(30))];
    [self.navView addSubview:searchView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
//        SearchViewController *searchVc = [[SearchViewController alloc] init];
//        searchVc.content = @"";
//        [weakSelf.navigationController pushViewController:searchVc animated:YES];
        
        NewSearchTicketController *searchVc = [[NewSearchTicketController alloc] init];
        
        [weakSelf.navigationController pushViewController:searchVc animated:NO];

    }];
    [searchView addGestureRecognizer:tap];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.navView).offset(AUTOSIZESCALEX(25));
        make.bottom.equalTo(self.navView).offset(AUTOSIZESCALEX(-8));
        make.centerX.equalTo(self.navView).offset(AUTOSIZESCALEX(4));
        make.width.mas_equalTo(AUTOSIZESCALEX(295));
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
//    self.scanLabel = [[UILabel alloc] init];
    UIButton *scanButton = [self createButtonWithImage:ImageWithNamed(@"扫一扫") title:@"扫一扫" titleColor:QHWhiteColor titleFont:TextFont(11) size:CGSizeMake(AUTOSIZESCALEX(35), AUTOSIZESCALEX(28)) target:self action:@selector(didClickScanButton) isScanButton:YES];
    [self.navView addSubview:scanButton];
    
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(searchView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.navView).offset(AUTOSIZESCALEX(5));
        make.width.mas_equalTo(AUTOSIZESCALEX(35));
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
//    self.messageLabel = [[UILabel alloc] init];
    UIButton *messageButton = [self createButtonWithImage:ImageWithNamed(@"31评论") title:@"消息" titleColor:QHWhiteColor titleFont:TextFont(11) size:CGSizeMake(AUTOSIZESCALEX(30), AUTOSIZESCALEX(28)) target:self action:@selector(didClickMessageButton) isScanButton:NO];
    [messageButton addTarget:self action:@selector(didClickMessageButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:messageButton];
    
    [messageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(searchView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(searchView.mas_right).offset(AUTOSIZESCALEX(2));
        make.width.mas_equalTo(AUTOSIZESCALEX(30));
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.estimatedRowHeight = 0;
//    tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 0;
    tableView.tableHeaderView = self.cycleScrollView;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[NewsReportCell class] forCellReuseIdentifier:reportCellId];
    [tableView registerClass:[PlatfomrCharacterCell class] forCellReuseIdentifier:characterCellId];
    [tableView registerClass:[HomeOfShoppingGuideCell class] forCellReuseIdentifier:guideCellId];
    [tableView registerClass:[HomeOfLoveLifeCell class] forCellReuseIdentifier:lifeCellId];
    [tableView registerClass:[HomeOfNetRedCell class] forCellReuseIdentifier:netRedCellId];
    [tableView registerClass:[BrandSelectionCell class] forCellReuseIdentifier:mustBuyCellId];
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
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.view).offset(-kTabbar_Bottum_Height-SafeAreaBottomHeight);
    }];
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[topButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        if (weakSelf.categoryTableView.hidden) {
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } else {
            [weakSelf.categoryTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
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

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        WeakSelf
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(175)) delegate:nil placeholderImage:PlaceHolderMainImage];
        cycleScrollView.localizationImageNamesGroup = @[ImageWithNamed(@"banner")];
        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            if (weakSelf.bannerArray.count == 0) {
                return ;
                [WYPackagePhotoBrowser showPhotoWithImageArray:[NSMutableArray arrayWithObject:ImageWithNamed(@"banner")] currentIndex:0];
            } else {
                BannerItem *item = weakSelf.bannerArray[currentIndex];
                
                if (item.urlType == 1) { // 页面url
                    WebViewController *webVc = [[WebViewController alloc] init];
                    webVc.urlString = item.target;
                    webVc.title = item.title;
                    [weakSelf.navigationController pushViewController:webVc animated:YES];
//                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:item.target]]) {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.target]];
//                    }
                } else if (item.urlType == 2) { // 特色分类列表
                    GoodsListOfNewController *listVc = [[GoodsListOfNewController alloc] init];
                    listVc.specialCategoriesId = item.target;
                    listVc.title = item.title;
                    [weakSelf.navigationController pushViewController:listVc animated:YES];
                }
                [weakSelf didClickBannerWithBannerId:item.bannerId];
            }
        };
        _cycleScrollView = cycleScrollView;
    }
    return _cycleScrollView;
}

#pragma mark - Button Action

// 扫一扫
- (void)didClickScanButton {
    WeakSelf
    [LoginUtil loginWithFatherVc:self completedHandler:^{
        MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeQrCode onFinish:^(NSString *result, NSError *error) {
            if (error) {
                WYLog(@"error: %@",error);
            } else {
                WYLog(@"扫描结果：%@",result);
                [WYHud showMessage:result];
            }
        }];
        [weakSelf.navigationController pushViewController:scanVc animated:YES];
    }];
}

// 消息
- (void)didClickMessageButton {
    WeakSelf
    [LoginUtil loginWithFatherVc:self completedHandler:^{
        MessageNoticeController *messageVc = [[MessageNoticeController alloc] init];
        [weakSelf.navigationController pushViewController:messageVc animated:YES];
    }];
}

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
    self.tableView.mj_footer.hidden = (self.needBuyedListArray.count == 0);

    if (tableView == self.categoryTableView) { // 显示分类中
        self.categoryTableView.mj_footer.hidden = (self.categoryListArray.count == 0);

        return 2;
    }
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) { // 显示分类中
        if (indexPath.section == 0) {
            if (self.subCategories.count == 0) {
                return 0.01;
            }
            NSInteger row = (self.subCategories.count - 1) / 4 + 1;
            return row * AUTOSIZESCALEX(90) + row * AUTOSIZESCALEX(2);
        } else {
            if (self.categoryListArray.count == 0) {
                return 0.01;
            }
            NSInteger row = (self.categoryListArray.count - 1) / 2 + 1;
            return row * AUTOSIZESCALEX(280) + row * 0.55;
        }
//        NSInteger row = (self.needBuyedListArray.count - 1) / 2 + 1;
//        return (row * AUTOSIZESCALEX(280) + row * AUTOSIZESCALEX(1));
    } else {
        if (indexPath.section == 0) {
            return AUTOSIZESCALEX(60);
        } else if (indexPath.section == 1) {
            return AUTOSIZESCALEX(240);
        } else if (indexPath.section == 2) {
            return AUTOSIZESCALEX(95);
        } else if (indexPath.section == 3) {
            return AUTOSIZESCALEX(190);
        } else if (indexPath.section == 4) {
            return AUTOSIZESCALEX(145);
        }
//        return AUTOSIZESCALEX(6000);
        if (self.needBuyedListArray.count == 0) {
            return AUTOSIZESCALEX(0.01);
        }
        NSInteger row = (self.needBuyedListArray.count - 1) / 2 + 1;
        return (row * AUTOSIZESCALEX(280) + row * SeparatorLineHeight);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) { // 显示分类中
        if (indexPath.section == 0) { // 二级分类
            ClassifyOfGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:subCategoriesCellId];
            cell.datasource = self.subCategories;
            cell.delegate = self;
            return cell;
        } else if (indexPath.section == 1) { // 分类商品列表
            BrandSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:categoriesListCellId];
            cell.datasource = self.categoryListArray;
            cell.delegate = self;
            return cell;
        }
    } else {
        if (indexPath.section == 0) { // 省惠快报
            NewsReportCell *cell = [tableView dequeueReusableCellWithIdentifier:reportCellId];
            cell.articlesArray = self.articlesArray;
            return cell;
        } else if (indexPath.section == 1) { // 品质优选
            PlatfomrCharacterCell *cell = [tableView dequeueReusableCellWithIdentifier:characterCellId];
            cell.delegate = self;
            cell.datasource = self.commoditySpecialCategoriesArray;
            return cell;
        } else if (indexPath.section == 2) { // 购物攻略
            HomeOfShoppingGuideCell *cell = [tableView dequeueReusableCellWithIdentifier:guideCellId];
            cell.delegate = self;
            return cell;
        } else if (indexPath.section == 3) { // 网红同款
            HomeOfNetRedCell *cell = [tableView dequeueReusableCellWithIdentifier:netRedCellId];
            if (self.commoditySpecialCategoriesArray.count > 4) {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (int i = 4; i < self.commoditySpecialCategoriesArray.count; i++) {
                    [tempArray addObject:self.commoditySpecialCategoriesArray[i]];
                }
                cell.datasource = tempArray;
            } else {
                cell.datasource = [NSMutableArray array];
            }
            cell.delegate = self;
            return cell;
        } else if (indexPath.section == 4) { // 爱生活
            HomeOfLoveLifeCell *cell = [tableView dequeueReusableCellWithIdentifier:lifeCellId];
            return cell;
        } else if (indexPath.section == 5) { // 必买清单
            BrandSelectionCell *cell = [tableView dequeueReusableCellWithIdentifier:mustBuyCellId];
            cell.delegate = self;
            cell.datasource = self.needBuyedListArray;
            //        MustBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:mustBuyCellId];
            //        cell.item = self.needBuyedListArray[indexPath.row];
            return cell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.backgroundColor = QHWhiteColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) { // 显示分类中
        
    } else {
        if (indexPath.section == 0) { // 省惠快报
            NewsReportController *reportVc = [[NewsReportController alloc] init];
            [self.navigationController pushViewController:reportVc animated:YES];
        } else if (indexPath.section == 4) { // 爱生活
            LoveLifeController *lifeVc = [[LoveLifeController alloc] init];
            [self.navigationController pushViewController:lifeVc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.categoryTableView) { // 显示分类中
        return section == 1 ? AUTOSIZESCALEX(40) : CGFLOAT_MIN;
    } else {
        return section == 5 ? AUTOSIZESCALEX(50) : CGFLOAT_MIN;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.categoryTableView) { // 显示分类中
        if (section == 1) {
            return self.secondSectionHeaderView;
        }
    } else {
        if (section == 5) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(50))];
            headerView.backgroundColor = QHWhiteColor;
            
            UIImageView *lineImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"装饰")];
            lineImageView.frame = CGRectMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(21), SCREEN_WIDTH - AUTOSIZESCALEX(100), AUTOSIZESCALEX(8));
            [headerView addSubview:lineImageView];

            UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AUTOSIZESCALEX(10), headerView.width, AUTOSIZESCALEX(30))];
            descLabel.text = @"必买清单";
            //        descLabel.textAlignment = NSTextAlignmentCenter;
            descLabel.font = AppMainTextFont(16);
            //        descLabel.textColor = QHMainColor;
            [descLabel sizeToFit];
            descLabel.height = AUTOSIZESCALEX(30);
            descLabel.centerX = headerView.centerX;
            [headerView addSubview:descLabel];
            // 文字渐变
            [WYUtils TextGradientview:descLabel bgVIew:headerView gradientColors:@[(id)ColorWithHexString(@"#ffb42b").CGColor, (id)ColorWithHexString(@"#ffb42b").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];

            [headerView addSubview:[UIView separatorLine:CGRectMake(0, headerView.height - SeparatorLineHeight, headerView.width, SeparatorLineHeight)]];
            
            return headerView;
        }
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.categoryTableView) { // 显示分类中
        return section == 1 ? 0.01 : 5;
    }
    return section == 0 ? 0.01 : 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.categoryTableView) { // 显示分类中
        return section == 1 ? [[UIView alloc] init] : [UIView tableFooterView];
    }
    return section == 0 ? [[UIView alloc] init] :  [UIView tableFooterView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    UIColor * color = [UIColor whiteColor];

    UITableView *tableView = (UITableView *)scrollView;

    if (self.categoryTableView == tableView) {
        CGFloat offsetY = scrollView.contentOffset.y;

        if (offsetY > AUTOSIZESCALEX(1800)) {
            self.topButton.hidden = NO;
            [self.view bringSubviewToFront:self.topButton];
        } else {
            self.topButton.hidden = YES;
        }

    } else {
        CGFloat offsetY = scrollView.contentOffset.y;

        if (offsetY > 0) {
            CGFloat alpha = MIN(1, 1 - ((kNavHeight - offsetY) / (kNavHeight * 1.0)));
            self.navView.backgroundColor = [color colorWithAlphaComponent:alpha];
//        self.navView.backgroundColor = QHWhiteColor;
            self.scanLabel.textColor = ColorWithHexString(@"666666");
            self.messageLabel.textColor = ColorWithHexString(@"666666");
            self.scanImageView.image = ImageWithNamed(@"扫一扫(灰)");
            self.messageImageView.image = ImageWithNamed(@"31评论(灰)");
        } else {
            self.navView.backgroundColor = [color colorWithAlphaComponent:0];
            self.scanLabel.textColor = QHWhiteColor;
            self.messageLabel.textColor = QHWhiteColor;
            self.scanImageView.image = ImageWithNamed(@"扫一扫");
            self.messageImageView.image = ImageWithNamed(@"31评论");
        }
        
        if (offsetY > AUTOSIZESCALEX(2500)) {
            self.topButton.hidden = NO;
        } else {
            self.topButton.hidden = YES;
        }
        
        if (offsetY > (AUTOSIZESCALEX(175) - kNavHeight)) {
            self.categoryView.hidden = NO;
            [self.view bringSubviewToFront:self.categoryView];
            
        } else {
            self.categoryView.hidden = YES;
        }
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

#pragma mark - GoodsClassifiCellDelegate

- (void)goodsClassifiCell:(GoodsClassifiCell *)goodsClassifiCell didSelectItem:(CommodityCategoriesItem *)item {
    GoodsListViewController *listVc = [[GoodsListViewController alloc] init];
    listVc.type = CommodityOfCategories;
    listVc.categoriesItem = item;
    listVc.title = item.name;
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark - PlatfomrCharacterCellDelegate

- (void)platfomrCharacterCell:(PlatfomrCharacterCell *)platfomrCharacterCell didSelectItem:(CommoditySpecialCategoriesItem *)item {
    GoodsListOfNewController *listVc = [[GoodsListOfNewController alloc] init];
    listVc.specialCategoriesId = item.specialCategoriesId;
    listVc.title = item.name;
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark - HomeOfNetRedCellDelegate

- (void)homeOfNetRedCell:(HomeOfNetRedCell *)homeOfNetRedCell didSelectItem:(CommoditySpecialCategoriesItem *)item {
    if ([item.name isEqualToString:@"排行榜"]) { // 排行榜
        GoodsRankListController *rankVc = [[GoodsRankListController alloc] init];
        rankVc.specialCategoriesId = item.specialCategoriesId;
        [self.navigationController pushViewController:rankVc animated:YES];
        
        return;
    }
    BOOL isVideoType = NO;
    if ([item.name isEqualToString:@"视频优购"]) { // 视频优购
        isVideoType = YES;
    }
    GoodsListOfNewController *listVc = [[GoodsListOfNewController alloc] init];
    listVc.isVideoType = isVideoType;
    listVc.specialCategoriesId = item.specialCategoriesId;
    listVc.title = item.name;
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark - HomeOfShoppingGuideCellDelegate
// 购物攻略
- (void)homeOfShoppingGuideCell:(HomeOfShoppingGuideCell *)homeOfShoppingGuideCell didClickShoppingGuideButton:(UIButton *)sender {
    ShoppingGuideController *guideVc = [[ShoppingGuideController alloc] init];
    [self.navigationController pushViewController:guideVc animated:YES];
}

// 邀请好友
- (void)homeOfShoppingGuideCell:(HomeOfShoppingGuideCell *)homeOfShoppingGuideCell didClickShareButton:(UIButton *)sender {
    ShareMakeMoneyController *shareVc = [[ShareMakeMoneyController alloc] init];
    [self.navigationController pushViewController:shareVc animated:YES];
}

#pragma mark - BrandSelectionCellDelegate

- (void)brandSelectionCell:(BrandSelectionCell *)brandSelectionCell didSelectItem:(CommodityListItem *)item {
    GoodsDetailController *detailVc = [[GoodsDetailController alloc] init];
    detailVc.item = item;
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
    [self getCategoryListWithPageNo:1 sortType:self.sortType orderType:self.orderType babyType:self.babyType];
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
    
    [self getCategoryListWithPageNo:1 sortType:self.sortType orderType:self.orderType babyType:self.babyType];

}

#pragma mark - CategoryScrollViewDelegate

- (void)categoryScrollView:(CategoryScrollView *)categoryScrollView didSelectItem:(ClassifyItem *)item {
    self.secondSectionHeaderView = nil;
    if ([item.name isEqualToString:@"精选"]) {
        self.categoryId = @"";
        self.categoryTableView.hidden = YES;
        self.tableView.hidden = NO;
        if (self.firstLoad) {
            self.firstLoad = NO;
        }
    } else {
        if ([item.classifyId isEqualToString:self.categoryId]) {
            return;
        }
        self.sortType = @"";
        self.orderType = @"";
        self.babyType = @"";
        self.categoryId = item.classifyId;
        [self getCategoryListWithPageNo:1 sortType:self.sortType orderType:self.orderType babyType:self.babyType];
        [self getSecondCategoriesWithPID:item.classifyId];
        self.categoryTableView.hidden = NO;
        self.tableView.hidden = YES;
    }
    self.categoryTableView.contentOffset = CGPointMake(0, 0);
}

// 二级分类
- (void)getSecondCategoriesWithPID:(NSString *)pid {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"pid"] = pid;
    
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/categories" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            NSArray *tempArray = [ClassifyItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            if (tempArray.count > 0) {
                ClassifyItem *firstItem = tempArray[0];
                weakSelf.subCategories = [NSMutableArray arrayWithArray:firstItem.subCategories];
            }
            [weakSelf.categoryTableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 商品分类列表
- (void)getCategoryListWithPageNo:(NSInteger)pageNo sortType:(NSString *)sortType orderType:(NSString *)orderType babyType:(NSString *)babyType {
    [WYProgress show];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (![NSString isEmpty:self.categoryId]) {
        parameters[@"categoryId"] = self.categoryId;
    }
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

    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.categoryPageNo = 1;
                weakSelf.categoryListArray = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            } else {
                [weakSelf.categoryListArray addObjectsFromArray:[CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
            }
            if ([response[@"data"][@"datas"] count] == 0) {
                [weakSelf.categoryTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                if ((weakSelf.categoryListArray.count % PageSize != 0) || weakSelf.categoryListArray.count == 0) { // 有余数说明没有下一页了
                    [weakSelf.categoryTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    weakSelf.categoryPageNo++;
                    [weakSelf.categoryTableView.mj_footer endRefreshing];
                }
            }
            [weakSelf.categoryTableView reloadData];
        } else {
            [weakSelf.categoryTableView.mj_footer endRefreshing];
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
        [weakSelf.categoryTableView.mj_header endRefreshing];
        
    } failureBlock:^(NSString *error) {
        [weakSelf.categoryTableView.mj_header endRefreshing];
        [weakSelf.categoryTableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Private method

- (UIButton *)createButtonWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont size:(CGSize)size target:(id)target action:(SEL)action isScanButton:(BOOL)isScanButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = size;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.size = CGSizeMake(AUTOSIZESCALEX(14), AUTOSIZESCALEX(14));
    imageView.centerX = button.centerX;
    imageView.y = 0;
    [button addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom_WY + AUTOSIZESCALEX(4), button.width, button.height - imageView.bottom_WY - AUTOSIZESCALEX(4))];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = titleColor;
    titleLabel.font = titleFont;
    [button addSubview:titleLabel];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (isScanButton) {
        self.scanLabel = titleLabel;
        self.scanImageView = imageView;
    } else {
        self.messageLabel = titleLabel;
        self.messageImageView = imageView;
    }

    return button;
}

// 第一次显示弹窗
- (void)showPopupView {
    if ([LoginUserDefault userDefault].isShowPopupOfHome) {
        if ([[LoginUserDefault userDefault].versionItem.version isEqualToString:APP_VERSION]) { // 版本一样，说明当前的是最新版本，需要判断当前版本的数字编号，
            if ([LoginUserDefault userDefault].versionItem.number == 0) { // 数字编号等于0表示审核中，不弹框
                return;
            }
        }
        HomePopupsView *popupView = [[HomePopupsView alloc] initWithFrame:SCREEN_FRAME];
        WeakSelf
        popupView.clickIconCallBack = ^{
            BenefitGroupBuyController *groupBuyVc = [[BenefitGroupBuyController alloc] init];
            [weakSelf.navigationController pushViewController:groupBuyVc animated:YES];
        };
        [popupView show];
        [LoginUserDefault userDefault].isShowPopupOfHome = NO;
    }
}

@end
