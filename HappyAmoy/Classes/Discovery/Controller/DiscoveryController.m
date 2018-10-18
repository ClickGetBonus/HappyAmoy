//
//  DiscoveryController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DiscoveryController.h"
#import "DiscoveryFirstSectionCell.h"
#import "DiscoverySecondSectionCell.h"
#import "BenefitGroupBuyController.h"
#import "ExchangeDetailController.h"
#import "SignInController.h"
#import "SwapGoogsListItem.h"

@interface DiscoveryController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;
/**    数据源    */
@property(nonatomic,strong) NSMutableArray *datasource;

@end

static NSString *const firstSectionCellId = @"firstSectionCellId";
static NSString *const secondSectionCellId = @"secondSectionCellId";

@implementation DiscoveryController

#pragma mark - Lazy load

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发现";
    self.view.backgroundColor = FooterViewBackgroundColor;
    self.pageNo = 1;
    
    [self getDataWithPageNo:self.pageNo];
    [self setupUI];
}

#pragma mark Data

// 初始化数据
- (void)getDataWithPageNo:(NSInteger)pageNo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
    
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/sign/swapGoogsList" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.datasource = [SwapGoogsListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.datasource addObjectsFromArray:[SwapGoogsListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
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
    [tableView registerClass:[DiscoveryFirstSectionCell class] forCellReuseIdentifier:firstSectionCellId];
    [tableView registerClass:[DiscoverySecondSectionCell class] forCellReuseIdentifier:secondSectionCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    WeakSelf
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 获取数据
        [weakSelf getDataWithPageNo:1];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载更多
        [weakSelf getDataWithPageNo:weakSelf.pageNo];
    }];
    
    self.tableView.mj_footer.hidden = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + SeparatorLineHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *line = [UIView separatorLine:CGRectMake(0, kNavHeight, SCREEN_WIDTH, SeparatorLineHeight)];
    [self.view addSubview:line];
}

#pragma mark - Button Action

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.tableView.mj_footer.hidden = self.datasource.count == 0;
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 1;
    }
//    return section == 0 ? 1 : self.datasource.count;
    return self.datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 1) {
        return AUTOSIZESCALEX(180);
    }
    
    return AUTOSIZESCALEX(110);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return AUTOSIZESCALEX(0.01);
    }
    return AUTOSIZESCALEX(44);
//    return section == 0 ? AUTOSIZESCALEX(0.01) : AUTOSIZESCALEX(44);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return [[UIView alloc] init];
    } else {
        return [self secondSectionHeaderView];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return section == 0 ? AUTOSIZESCALEX(10) : SectionHeight;
    if (section == 0 || section == 1) {
        return AUTOSIZESCALEX(10);
    }
    return SectionHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return section == 0 ? [[UIView alloc] init] : [UIView tableFooterView];
    if (section == 0 || section == 1) {
        return [[UIView alloc] init];
    }
    return [UIView tableFooterView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        DiscoveryFirstSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:firstSectionCellId];
        cell.title = indexPath.row == 1 ? @"好麦拼团" : @"签到赚麦粒";
        cell.bannerImage = indexPath.row == 1 ? ImageWithNamed(@"省惠拼团banner") : ImageWithNamed(@"签到领金豆banner");
        cell.hiddenLine = indexPath.row == 1 ? NO : YES;
        return cell;
    }
    if (indexPath.section == 1) {
        
        DiscoveryFirstSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:firstSectionCellId];
        cell.title = @"好麦生态圈";
        cell.bannerImage = ImageWithNamed(@"好买生态领取野山参banner");
        cell.hiddenLine = indexPath.row == 1 ? NO : YES;
        return cell;
    }
    DiscoverySecondSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:secondSectionCellId];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) { // 省惠拼团
        BenefitGroupBuyController *groupBuyVc = [[BenefitGroupBuyController alloc] init];
        [self.navigationController pushViewController:groupBuyVc animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 0) { // 签到
        SignInController *signInVc = [[SignInController alloc] init];
        [self.navigationController pushViewController:signInVc animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 0) { // 签到
        [WYProgress showErrorWithStatus:@"敬请期待"];

    } else { // 兑换专区
        ExchangeDetailController *detailVc = [[ExchangeDetailController alloc] init];
        detailVc.listItem = self.datasource[indexPath.row];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

#pragma mark - Private method

- (UIView *)secondSectionHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(44))];
    headerView.backgroundColor = QHWhiteColor;
//    
//    
//    UIView *colorLine = [[UIView alloc] initWithFrame:CGRectMake(AUTOSIZESCALEX(0), AUTOSIZESCALEX(0), AUTOSIZESCALEX(10), AUTOSIZESCALEX(10))];
//    colorLine.backgroundColor = ColorWithHexString(@"#ffb42b");
//    [headerView addSubview:colorLine];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(AUTOSIZESCALEX(23), AUTOSIZESCALEX(15), headerView.width - AUTOSIZESCALEX(30), AUTOSIZESCALEX(14))];
    descLabel.text = @"兑换专区";
    descLabel.font = TextFont(14);
    descLabel.textColor = ColorWithHexString(@"#333333");
    [headerView addSubview:descLabel];
    
    UIView *line = [UIView separatorLine:CGRectMake(0, headerView.height - SeparatorLineHeight, SCREEN_WIDTH, SeparatorLineHeight)];
    [headerView addSubview:line];
    
    UIView *colorLine = [[UIView alloc] init];
    colorLine.backgroundColor = ColorWithHexString(@"#ffb42b");
    [headerView addSubview:colorLine];
    
    [colorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(headerView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(3));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    return headerView;
}


@end
