//
//  ClassifyController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ClassifyController.h"
#import "CustomSearchView.h"
#import "SearchViewController.h"
#import "ClassifyTypeCell.h"
#import "ClassifyContentCell.h"
#import "ClassifyItem.h"
#import "GoodsListViewController.h"
#import "NewSearchViewController.h"
#import "NewSearchTicketController.h"

@interface ClassifyController () <UITableViewDelegate,UITableViewDataSource,ClassifyContentCellDelegate>

/**    左边tableView    */
@property (strong, nonatomic) UITableView *leftTableView;
/**    右边tableView    */
@property (strong, nonatomic) UITableView *rightTableView;
/**    左边数据源    */
@property (strong, nonatomic) NSMutableArray *leftDatasource;
/**    右边数据源    */
@property (strong, nonatomic) NSMutableArray *rightDatasource;
/**    已选的索引    */
@property (assign, nonatomic) NSInteger selectedIndex;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;
/**    热门分类    */
@property(nonatomic,strong) NSMutableArray *hotCategories;
/**    全部分类    */
@property(nonatomic,strong) NSMutableArray *subCategories;

@end

static NSString *const leftCellId = @"leftCellId";
static NSString *const rightCellId = @"rightCellId";

@implementation ClassifyController

#pragma mark - Lazy load

- (NSMutableArray *)leftDatasource {
    if (!_leftDatasource) {
        _leftDatasource = [NSMutableArray array];
//        [_leftDatasource addObjectsFromArray:@[@"男装",@"女装",@"美妆",@"食品",@"护肤",@"内衣",@"洗护",@"百货",@"女鞋",@"母婴",@"数码",@"箱包",@"家电",@"运动",@"配饰",@"宠物",@"成人"]];
    }
    return _leftDatasource;
}

- (NSMutableArray *)rightDatasource {
    if (!_rightDatasource) {
        _rightDatasource = [NSMutableArray array];
    }
    return _rightDatasource;
}

- (NSMutableArray *)hotCategories {
    if (!_hotCategories) {
        _hotCategories = [NSMutableArray array];
    }
    return _hotCategories;
}

- (NSMutableArray *)subCategories {
    if (!_subCategories) {
        _subCategories = [NSMutableArray array];
    }
    return _subCategories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithHexString(@"#F3F3F6");
    
    self.pageNo = 0;
    self.selectedIndex = 0;
    
    [self setupNav];
    [self setupUI];
    [self getFirstCategories];
}

#pragma mark Data

// 一级分类
- (void)getFirstCategories {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/categories" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.leftDatasource = [ClassifyItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            if (self.leftDatasource.count > 0) {
                weakSelf.selectedIndex = 0;
                ClassifyItem *firstItem = weakSelf.leftDatasource[0];
                [weakSelf getSecondCategoriesWithPID:firstItem.classifyId];
            }
            [weakSelf.leftTableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {

    }];
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
                weakSelf.hotCategories = [NSMutableArray arrayWithArray:firstItem.hotCategories];
                weakSelf.subCategories = [NSMutableArray arrayWithArray:firstItem.subCategories];
            }
            [weakSelf.rightTableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - Nav

- (void)setupNav {
    WeakSelf
    CustomSearchView *searchView = [[CustomSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - AUTOSIZESCALEX(90), 30)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        
        NewSearchTicketController *searchVc = [[NewSearchTicketController alloc] init];

        [weakSelf.navigationController pushViewController:searchVc animated:YES];

//        SearchViewController *searchVc = [[SearchViewController alloc] init];
//        searchVc.content = @"";
//        [weakSelf.navigationController pushViewController:searchVc animated:NO];
    }];
    [searchView addGestureRecognizer:tap];
    
    self.navigationItem.titleView = searchView;
}

#pragma mark - Data

#pragma mark - UI

- (void)setupUI {
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leftTableView.backgroundColor = QHWhiteColor;
    leftTableView.showsVerticalScrollIndicator = NO;
    [leftTableView registerClass:[ClassifyTypeCell class] forCellReuseIdentifier:leftCellId];
    [self.view addSubview:leftTableView];
    self.leftTableView = leftTableView;
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(1) + kNavHeight);
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(-8) - SafeAreaBottomHeight - kTabbar_Bottum_Height);
        make.width.mas_equalTo(AUTOSIZESCALEX(90));
    }];
    
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rightTableView.backgroundColor = self.view.backgroundColor;
    rightTableView.showsVerticalScrollIndicator = NO;
    [rightTableView registerClass:[ClassifyContentCell class] forCellReuseIdentifier:rightCellId];
    [self.view addSubview:rightTableView];
    self.rightTableView = rightTableView;
    WeakSelf
//    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf getTrainingCourseWithPageNo:1];
//    }];
//    self.courseTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf getTrainingCourseWithPageNo:weakSelf.pageNo];
//    }];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftTableView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.leftTableView.mas_right).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.leftTableView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
    }];
    
    // 禁止系统为scrollView添加额外的上边距
    if (@available(iOS 11.0, *)) {
        self.leftTableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        self.rightTableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - Button Action


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.leftTableView) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.leftDatasource.count;
    }
    if (section == 0) {
        return self.hotCategories.count > 0 ? 1 : 0;
    } else {
        return self.subCategories.count > 0 ? 1 : 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        return AUTOSIZESCALEX(40);
    }
    if (indexPath.section == 0) {
        NSInteger row = (self.hotCategories.count - 1) / 3 + 1;
        return row * AUTOSIZESCALEX(115) + AUTOSIZESCALEX(3) * row;
    } else {
        NSInteger row = (self.subCategories.count - 1) / 3 + 1;
        return row * AUTOSIZESCALEX(115) + AUTOSIZESCALEX(3) * row;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOSIZESCALEX(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForHeaderInSection:section tableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return 0.01;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = QHWhiteColor;
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        ClassifyTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellId];
        cell.item = self.leftDatasource[indexPath.row];
        cell.haveSelected = self.selectedIndex == indexPath.row;
        return cell;
    } else {
        ClassifyContentCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCellId];
        cell.datasource = indexPath.section == 0 ? self.hotCategories : self.subCategories;
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        self.selectedIndex = indexPath.row;
        ClassifyItem *item = self.leftDatasource[self.selectedIndex];
        [self getSecondCategoriesWithPID:item.classifyId];
//        self.hotCategories = [NSMutableArray arrayWithArray:item.hotCategories];
//        self.subCategories = [NSMutableArray arrayWithArray:item.subCategories];
        [tableView reloadData];
//        [self.rightTableView reloadData];
    } else {
        
    }
}

#pragma mark - ClassifyContentCellDelegate

- (void)classifyContentCell:(ClassifyContentCell *)classifyContentCell didSelectItem:(ClassifyItem *)item {
    GoodsListViewController *listVc = [[GoodsListViewController alloc] init];
    listVc.title = item.name;
    listVc.categoryId = item.pid;
    listVc.subCategoryId = item.classifyId;
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark - Private method

- (UIView *)viewForHeaderInSection:(NSInteger)section tableView:(UITableView *)tableView {
    
    if (tableView == self.leftTableView) {
        if (section == 0) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, AUTOSIZESCALEX(90), AUTOSIZESCALEX(40))];
            headerView.backgroundColor = QHWhiteColor;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
            titleLabel.text = @"全部分类";
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = TextFont(12);
            [headerView addSubview:titleLabel];
            return headerView;
        }
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH - AUTOSIZESCALEX(90), AUTOSIZESCALEX(40))];
        headerView.backgroundColor = self.view.backgroundColor;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AUTOSIZESCALEX(10), 0,AUTOSIZESCALEX(200), headerView.height)];
        titleLabel.text = section == 0 ? @"热卖分类" : @"全部分类";
        titleLabel.font = TextFont(12);
        [headerView addSubview:titleLabel];
        return headerView;
    }
    return [[UIView alloc] init];
}

@end
