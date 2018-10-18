//
//  ReceiptAddressController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ReceiptAddressController.h"
#import "ReceiptAddressCell.h"
#import "AddAddressController.h"
#import "AddressItem.h"

@interface ReceiptAddressController () <UITableViewDelegate,UITableViewDataSource>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    数据源    */
@property(nonatomic,strong) NSMutableArray *datasource;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;

@end

static NSString *const addressCellId = @"addressCellId";

@implementation ReceiptAddressController

#pragma mark - Lazy load

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收货地址";
    self.view.backgroundColor = ViewControllerBackgroundColor;
    self.pageNo = 1;

    [self getDataWithPageNo:self.pageNo];
    [self setupNav];
    [self setupUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressHaveChanged) name:AddressHaveChangedNotificationName object:nil];
}

#pragma mark - Notice
// 监听地址的变化
- (void)addressHaveChanged {
    [self getDataWithPageNo:1];
}

#pragma mark - Nav

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"添加" titleColor:QHBlackColor titleFont:TextFont(14) target:self action:@selector(didClickAdd)];
}

#pragma mark - UI

// 初始化数据
- (void)getDataWithPageNo:(NSInteger)pageNo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
    
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/personal/deliveries" parameters:parameters successBlock:^(id response) {
        
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.datasource = [AddressItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.datasource addObjectsFromArray:[AddressItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
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

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[ReceiptAddressCell class] forCellReuseIdentifier:addressCellId];
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
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(0) + kNavHeight);
        make.left.right.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(0));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Button Action
// 添加
- (void)didClickAdd {
    AddAddressController *addVc = [[AddAddressController alloc] init];
    [self.navigationController pushViewController:addVc animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.tableView.mj_footer.hidden = self.datasource.count == 0;
    return self.datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AUTOSIZESCALEX(70);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOSIZESCALEX(5);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReceiptAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellId];
    cell.item = self.datasource[indexPath.section];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isSelectAddress) { // 选择地址
        if (self.selectAddressCallBack) {
            self.selectAddressCallBack(self.datasource[indexPath.section]);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    AddAddressController *addVc = [[AddAddressController alloc] init];
    addVc.isModify = YES;
    addVc.item = self.datasource[indexPath.section];
    [self.navigationController pushViewController:addVc animated:YES];
}

// 添加编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 左滑动出现的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
// 删除所做的动作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    WeakSelf
    AddressItem *item = self.datasource[indexPath.section];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [[NetworkSingleton sharedManager] postRequestWithUrl:[NSString stringWithFormat:@" /personal/delivery/%@/delete",item.addressId] parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [WYProgress showSuccessWithStatus:@"删除地址成功!"];
            [weakSelf.datasource removeObject:item];
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - Private method

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
