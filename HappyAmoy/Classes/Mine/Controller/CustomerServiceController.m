//
//  CustomerServiceController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CustomerServiceController.h"
#import "CustomerServiceFirstCell.h"
#import "CustomerServiceSecondCell.h"

@interface CustomerServiceController () <UITableViewDelegate,UITableViewDataSource>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    数据源    */
@property (strong, nonatomic) NSDictionary *dataDict;

@end

static NSString * const firstCellId = @"firstCellId";
static NSString * const secondCellId = @"secondCellId";

@implementation CustomerServiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客服服务";
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupTableView];
}

#pragma mark - UI
// 设置tableView
- (void)setupTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ViewControllerBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.bounces = NO;
    tableView.tableHeaderView = [self tableHeaderView];
    UIView *tableFooterView = [[UIView alloc] init];
    tableFooterView.backgroundColor = ViewControllerBackgroundColor;
    tableView.tableFooterView = tableFooterView;
    tableView.rowHeight = AUTOSIZESCALEX(60);
    [tableView registerClass:[CustomerServiceFirstCell class] forCellReuseIdentifier:firstCellId];
    [tableView registerClass:[CustomerServiceSecondCell class] forCellReuseIdentifier:secondCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.mj_footer.hidden = YES;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CustomerServiceFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellId];
        
        return cell;
    } else {
        CustomerServiceSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCellId];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) { // 客服热线
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[LoginUserDefault userDefault].consumerHotline]];
        [[UIApplication sharedApplication] openURL:url];
    } else { // 在线客服

    }
}

#pragma mark - Private method

- (UIView *)tableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(150))];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headerView.width, headerView.height)];
    bgImageView.image = ImageWithNamed(@"custom_service_banner");
    [headerView addSubview:bgImageView];
    return headerView;
}

@end
