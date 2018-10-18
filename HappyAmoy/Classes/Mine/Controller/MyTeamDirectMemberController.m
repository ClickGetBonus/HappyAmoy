//
//  MyTeamDirectMemberController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyTeamDirectMemberController.h"
#import "MyTeamMemberCell.h"
#import "MyTeamItem.h"

@interface MyTeamDirectMemberController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;

@end

static NSString * const memberCellId = @"memberCellId";

@implementation MyTeamDirectMemberController

#pragma mark - Lazy load

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = ViewControllerBackgroundColor;
    self.pageNo = 1;
    
    [self setupTableView];
    
    [self getDataWithPageNo:self.pageNo];
}

#pragma mark - UI
// 设置tableView
- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.emptyDataSetSource = self;
    tableView.backgroundColor = ViewControllerBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.backgroundColor = ViewControllerBackgroundColor;
    tableView.tableFooterView = tableFooterView;
    tableView.rowHeight = AUTOSIZESCALEX(65);
    [tableView registerClass:[MyTeamMemberCell class] forCellReuseIdentifier:memberCellId];
    
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

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(5));
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

#pragma mark - Data

- (void)getDataWithPageNo:(NSInteger)pageNo  {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"type"] = self.isVip ? @"1" : @"0";
    parameters[@"role"] = @"1";

    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
    
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/personal/recommendTeams" parameters:parameters successBlock:^(id response) {
        
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.datasource = [MyTeamItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.datasource addObjectsFromArray:[MyTeamItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.tableView.mj_footer.hidden = (self.datasource.count == 0);

    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeakSelf
    MyTeamMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:memberCellId];
    cell.item = self.datasource[indexPath.row];
    [cell setClickedPhoneBlockBlock:^(MyTeamItem *item) {
        [weakSelf takePhoneWithTel:item.mobile];
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return RGB(239, 239, 239);
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


#pragma mark - TakePhone
- (void)takePhoneWithTel:(NSString *)tel
{
    if (tel == nil || [tel isEqualToString:@""]) {
        return;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tel];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

@end
