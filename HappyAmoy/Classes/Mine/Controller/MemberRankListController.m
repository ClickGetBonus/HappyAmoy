//
//  MemberRankListController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MemberRankListController.h"
#import "MemberRankListController.h"
#import "MemberRankFirstSectionCell.h"
#import "MemberRankSecondSectionCell.h"
#import "MemberRankItem.h"

@interface MemberRankListController () <UITableViewDelegate,UITableViewDataSource>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    数据源    */
@property(nonatomic,strong) NSMutableArray *datasource;

@end

static NSString *const firstSectionCellId = @"firstSectionCellId";
static NSString *const secondSectionCellId = @"secondSectionCellId";

@implementation MemberRankListController

#pragma mark - Lazy load

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"会员排行榜";

    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self getRankingData];
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[MemberRankFirstSectionCell class] forCellReuseIdentifier:firstSectionCellId];
    [tableView registerClass:[MemberRankSecondSectionCell class] forCellReuseIdentifier:secondSectionCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(5) + kNavHeight);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
}

#pragma mark - Data

- (void)getRankingData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/personal/rankings" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.datasource = [MemberRankItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.datasource.count == 0) {
        return 0;
    }
    if (self.datasource.count < 4) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : (self.datasource.count - 3);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return AUTOSIZESCALEX(150);
    }
    return AUTOSIZESCALEX(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MemberRankFirstSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:firstSectionCellId];
        cell.datasource = self.datasource;
        return cell;
    } else { // 会员排行榜
        MemberRankSecondSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:secondSectionCellId];
        cell.index = indexPath.row + 4;
        cell.item = self.datasource[indexPath.row + 3];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return AUTOSIZESCALEX(5);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


@end
