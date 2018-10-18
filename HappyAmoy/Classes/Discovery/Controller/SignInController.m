//
//  SignInController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SignInController.h"
#import "SignInCell.h"
#import "SignInOverviewItem.h"
#import "SignInListItem.h"
#import "SignInSuccessView.h"

@interface SignInController () <UITableViewDelegate,UITableViewDataSource,SignInCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
/**    签到概览    */
@property(nonatomic,strong) SignInOverviewItem *overviewItem;
/**    签到列表    */
@property(nonatomic,strong) NSMutableArray *datasource;

@end

static NSString *const cellId = @"cellId";

@implementation SignInController

#pragma mark - Lazy load
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"签到";
    self.view.backgroundColor = ColorWithHexString(@"#F3F3F6");

    [self setupUI];
    WeakSelf
    [RACObserve([LoginUserDefault userDefault], dataHaveChanged) subscribeNext:^(id x) {
        if (![LoginUserDefault userDefault].isTouristsMode) {
            // 签到概览
            [weakSelf surveyData];
            // 当月签到天数列表
            [weakSelf signinsList];
        }
    }];
}

#pragma mark Data

// 签到概览
- (void)surveyData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/sign/survey" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.overviewItem = [SignInOverviewItem mj_objectWithKeyValues:response[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 当月签到天数列表
- (void)signinsList {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/sign/signins" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.datasource = [SignInListItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[SignInCell class] forCellReuseIdentifier:cellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;

    self.tableView.mj_footer.hidden = YES;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Button Action

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SignInCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.delegate = self;
    cell.overviewItem = self.overviewItem;
    cell.daysArray = self.datasource;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - SignInCellDelegate

// 签到
- (void)signInCell:(SignInCell *)signInCell didClickSignInButton:(UIButton *)sender {
    
    [LoginUtil loginWithFatherVc:self completedHandler:^{
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
        WeakSelf
        [[NetworkSingleton sharedManager] postRequestWithUrl:@"/sign/signin" parameters:parameters successBlock:^(id response) {
            if ([response[@"code"] integerValue] == RequestSuccess) {
                [WYProgress showSuccessWithStatus:@"签到成功!"];
                // 重新获取数据，刷新界面
                // 签到概览
                [weakSelf surveyData];
                // 当月签到天数列表
                [weakSelf signinsList];
                
                SignInSuccessView *alertView = [[SignInSuccessView alloc] initWithFrame:SCREEN_FRAME];
                alertView.days = [NSString stringWithFormat:@"%zd",self.datasource.count + 1];
                alertView.gold = [response[@"data"] integerValue];
                [alertView show];
            } else {
                [WYProgress showErrorWithStatus:response[@"msg"]];
            }
        } failureBlock:^(NSString *error) {
            
        }];
    }];
}

#pragma mark - Private method



@end
