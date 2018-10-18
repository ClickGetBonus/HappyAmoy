//
//  MemberWelfareController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MemberWelfareController.h"
#import "MemberWelfareView.h"
#import "RewardBalanceCell.h"
#import "MemberRewardItem.h"
#import "WebViewH5Controller.h"

@interface MemberWelfareController () <UITableViewDelegate,UITableViewDataSource,MemberWelfareViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    我的余额    */
@property (strong, nonatomic) MemberWelfareView *balanceView;
/**    余额明细数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    从第几页开始加载    */
@property (assign, nonatomic) NSInteger pageNo;

@end

static NSString * const balanceCellId = @"balanceCellId";

@implementation MemberWelfareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消费麦穗";
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    

    self.view.backgroundColor = ViewControllerBackgroundColor;

    self.pageNo = 1;
    // 设置我的余额
    [self setupBalanceView];
    // 设置tableView
    [self setupTableView];
    // 获取余额
    [self getBalance];
    // 获取余额明细
    [self getRecordWithPageNo:self.pageNo];
}

#pragma mark - UI
// 设置我的余额
- (void)setupBalanceView {
    
    MemberWelfareView *balanceView = [[MemberWelfareView alloc] init];
    balanceView.delegate = self;
    [self.view addSubview:balanceView];
    self.balanceView = balanceView;
    
    [self.balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(5));
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(AUTOSIZESCALEX(205));
    }];
}
// 设置tableView
- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.emptyDataSetSource = self;
    tableView.backgroundColor = QHWhiteColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.backgroundColor = ViewControllerBackgroundColor;
    tableView.tableFooterView = tableFooterView;
    tableView.rowHeight = AUTOSIZESCALEX(60);
    [tableView registerClass:[RewardBalanceCell class] forCellReuseIdentifier:balanceCellId];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    WeakSelf
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 获取数据
        [weakSelf getRecordWithPageNo:1];
    }];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载更多
        [weakSelf getRecordWithPageNo:weakSelf.pageNo];
    }];
    
//    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceView.mas_bottom).offset(0);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

#pragma mark - Data
// 获取余额
- (void)getBalance {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;

    WeakSelf

    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/personal/welfare" parameters:parameters successBlock:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == RequestSuccess) {
            
            weakSelf.balanceView.balance = [NSString stringWithFormat:@"%@",response[@"data"][@"balance"]];
            weakSelf.balanceView.totalBalance = [NSString stringWithFormat:@"%@",response[@"data"][@"balance"]];
            weakSelf.balanceView.goingBalance = [NSString stringWithFormat:@"%@",response[@"data"][@"goingBalance"]];

        }
    } failureBlock:^(NSString *error) {

    }];
    
}
// 获取余额明细
- (void)getRecordWithPageNo:(NSInteger)pageNo {
    
    WeakSelf

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];

    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/personal/welfares" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.datasource = [MemberRewardItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            } else {
                [weakSelf.datasource addObjectsFromArray:[MemberRewardItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
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
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
        [weakSelf.tableView reloadData];

        [weakSelf.tableView.mj_header endRefreshing];

    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableView.mj_footer.hidden = (self.datasource.count == 0);

    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RewardBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:balanceCellId];
    
    cell.item = self.datasource[indexPath.row];
    
    return cell;
}

#pragma mark - DZNEmptyDataSetSource Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ImageWithNamed(@"浏览无数据");
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"当前没有数据";
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UIColor *textColor = ColorWithHexString(@"999999");
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"没有找到相关的宝贝";
//    UIFont *font = [UIFont systemFontOfSize:16.0];
//    UIColor *textColor = ColorWithHexString(@"999999");
//
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    [attributes setObject:font forKey:NSFontAttributeName];
//    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}


#pragma mark - RewardBalanceViewDelegate

- (void)memberWelfareView:(MemberWelfareView *)memberWelfareView toWallet:(NSInteger)currentScore {
    
    
    WeakSelf
    NSString *qrurl = [[NSString alloc] initWithFormat:@"%@%@%@",@"http://haomaih5.lucius.cn/#/Convert?phone=", [LoginUserDefault userDefault].userItem.mobile,@"&tab=1&type=1"];
    
    
    WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
    webVc.urlString = qrurl;
    webVc.title = @"兑换HGS";
    [weakSelf.navigationController pushViewController:webVc animated:YES];
    
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return QHWhiteColor;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavHeight;
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
