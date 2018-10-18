//
//  SystemMeaageController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SystemMeaageController.h"
#import "MessageCell.h"
#import "MessageItem.h"

@interface SystemMeaageController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;

@end

static NSString * const messageCellId = @"messageCellId";

@implementation SystemMeaageController

#pragma mark - 懒加载
- (NSMutableArray *)datasource {
    
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

#pragma mark - 页面初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = QHWhiteColor;
    
    self.pageNo = 1;
    
    [self setupUI];
    [self getMsgsWithPageNo:self.pageNo];
}

#pragma mark - Data

- (void)getMsgsWithPageNo:(NSInteger)pageNo {
    
    WeakSelf
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"role"] = @"2";
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];;
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/personal/msgs" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.datasource = [MessageItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            } else {
                [weakSelf.datasource addObjectsFromArray:[MessageItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
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

// 设置界面
- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.emptyDataSetSource = self;
    tableView.backgroundColor = ViewControllerBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    tableView.estimatedRowHeight = 0;
    tableView.rowHeight = UITableViewAutomaticDimension;
    [tableView registerClass:[MessageCell class] forCellReuseIdentifier:messageCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WeakSelf
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 获取数据
        [weakSelf getMsgsWithPageNo:self.pageNo];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载更多
        [weakSelf getMsgsWithPageNo:weakSelf.pageNo];
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.datasource.count == 0);
    
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCellId];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

// 添加编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 左滑动出现的文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}

// 删除所做的动作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    MessageItem *item = self.datasource[indexPath.row];
//
//    WeakSelf
//
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
//    [[NetworkSingleton sharedManager] postRequestWithUrl:[NSString stringWithFormat:@"/personal/msg/%@/delete",item.noticeId] parameters:parameters successBlock:^(id response) {
//        if ([response[@"code"] integerValue] == RequestSuccess) {
//            [WYProgress showSuccessWithStatus:@"消息删除成功!"];
//            [weakSelf.datasource removeObject:item];
//            [weakSelf.tableView reloadData];
////            [weakSelf getMsgsWithPageNo:1];
//        } else {
//            [WYProgress showErrorWithStatus:response[@"msg"]];
//        }
//        [weakSelf.tableView.mj_header endRefreshing];
//    } failureBlock:^(NSString *error) {
//    }];
//}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf

    UITableViewRowAction *deleteButton = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MessageItem *item = weakSelf.datasource[indexPath.row];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
        [[NetworkSingleton sharedManager] postRequestWithUrl:[NSString stringWithFormat:@"/personal/msg/%@/delete",item.noticeId] parameters:parameters successBlock:^(id response) {
            if ([response[@"code"] integerValue] == RequestSuccess) {
                [WYProgress showSuccessWithStatus:@"消息删除成功!"];
                [weakSelf.datasource removeObject:item];
                [weakSelf.tableView reloadData];
                //            [weakSelf getMsgsWithPageNo:1];
            } else {
                [WYProgress showErrorWithStatus:response[@"msg"]];
            }
            [weakSelf.tableView.mj_header endRefreshing];
        } failureBlock:^(NSString *error) {
        }];
    }];
    deleteButton.backgroundColor = QHMainColor;
    return @[deleteButton];
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
@end
