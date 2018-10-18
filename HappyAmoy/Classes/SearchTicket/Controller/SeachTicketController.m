//
//  SeachTicketController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SeachTicketController.h"
#import "SearchTicketView.h"
#import "SearchViewController.h"
#import "SearchTicketCell.h"

@interface SeachTicketController () <SearchTicketViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) SearchTicketView *searchView;
/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;

@end

static NSString *const searchCellId = @"searchCellId";

@implementation SeachTicketController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - UI

- (void)setupUI {
    
    SearchTicketView *searchView = [[SearchTicketView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(210))];
    searchView.delegate = self;
//    [self.view addSubview:searchView];
    self.searchView = searchView;
    
//    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
//        make.height.mas_equalTo(AUTOSIZESCALEX(210));
//    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = searchView;
    [tableView registerClass:[SearchTicketCell class] forCellReuseIdentifier:searchCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(-kNavHeight));
        make.left.right.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
//        make.height.mas_equalTo(AUTOSIZESCALEX(210));
    }];
}

#pragma mark - Button Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AUTOSIZESCALEX(1660);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellId];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - SearchTicketViewDelegate

- (void)searchTicketView:(SearchTicketView *)searchTicketView searchWithContent:(NSString *)content {
    WYLog(@"content = %@",content);
    SearchViewController *searchVc = [[SearchViewController alloc] init];
    searchVc.content = content;
    [self.navigationController pushViewController:searchVc animated:YES];
}

@end
