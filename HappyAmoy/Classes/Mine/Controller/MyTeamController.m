//
//  MyTeamController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyTeamController.h"
#import "MyTeamCell.h"
#import "MyTeamMemberController.h"

@interface MyTeamController () <UITableViewDelegate,UITableViewDataSource>

/**    顶部视图    */
@property(nonatomic,strong) UIView *topView;
/**    我的推荐人    */
@property(nonatomic,strong) UILabel *recommendLabel;
/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    数据源    */
@property (strong, nonatomic) NSDictionary *dataDict;

@end

static NSString * const teamCellId = @"teamCellId";

@implementation MyTeamController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的团队";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupTableView];
    
    [self recommendTeam];
}

#pragma mark - Data
// 我的团队概览数据
- (void)recommendTeam {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/personal/recommendTeam" parameters:parameters successBlock:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == RequestSuccess) {
            weakSelf.dataDict = response[@"data"];
            if ([NSString isEmpty:response[@"data"][@"mineRecommend"]]) {
                weakSelf.recommendLabel.text = [NSString stringWithFormat:@"我的推荐人：无"];
            } else {
                weakSelf.recommendLabel.text = [NSString stringWithFormat:@"我的推荐人：%@",[NSString excludeEmptyQuestion:response[@"data"][@"mineRecommend"]]];
            }
            [weakSelf.tableView reloadData];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - UI
// 设置tableView
- (void)setupTableView {
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = QHWhiteColor;
    [self.view addSubview:topView];
    self.topView = topView;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(1));
        make.left.right.equalTo(self.view).offset(0);
        make.height.mas_equalTo(AUTOSIZESCALEX(60));
    }];

    UILabel *recommendLabel = [[UILabel alloc] init];
    recommendLabel.text = @"我的推荐人：无";
    recommendLabel.textColor = ColorWithHexString(@"#898589");
    recommendLabel.font = TextFont(14);
    [self.topView addSubview:recommendLabel];
    self.recommendLabel = recommendLabel;
    [self.recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.topView).offset(AUTOSIZESCALEX(15));
    }];

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ViewControllerBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = NO;
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.backgroundColor = ViewControllerBackgroundColor;
    tableView.tableFooterView = tableFooterView;
    tableView.rowHeight = AUTOSIZESCALEX(60);
    [tableView registerClass:[MyTeamCell class] forCellReuseIdentifier:teamCellId];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;

    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(AUTOSIZESCALEX(5));
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:teamCellId];
    cell.index = indexPath.row;
    cell.dataDict = self.dataDict;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    MyTeamMemberController *teamMemberVc = [[MyTeamMemberController alloc] init];
    teamMemberVc.isVip = indexPath.row == 0;
    teamMemberVc.title = (indexPath.row == 0 ? @"VIP会员" : @"普通会员");
    [self.navigationController pushViewController:teamMemberVc animated:YES];
}



@end
