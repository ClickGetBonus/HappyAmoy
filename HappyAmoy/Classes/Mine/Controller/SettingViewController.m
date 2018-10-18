//
//  SettingViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingSwitchCell.h"
#import "SettingNormalCell.h"
#import "SettingThirdPartyAuthorController.h"
#import "LoginViewController.h"
#import "WYNavigationController.h"
#import "VersionItem.h"
#import "UpdateVersionView.h"
#import "WebViewH5Controller.h"

@interface SettingViewController () <UITableViewDelegate,UITableViewDataSource,UpdateVersionViewDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    类型数据源    */
@property (strong, nonatomic) NSArray *titleArray;
/**    缓存大小    */
@property (assign, nonatomic) NSInteger totalSize;

@end

static NSString *const normalCellId = @"normalCellId";
static NSString *const switchCellId = @"switchCellId";

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    if ([[LoginUserDefault userDefault].versionItem.version isEqualToString:APP_VERSION]) { // 版本一样，说明当前的是最新版本，需要判断当前版本的数字编号，数字编号大于0表示审核通过了，可以显示版本更新了
        if ([LoginUserDefault userDefault].versionItem.number > 0) { // 数字编号大于0表示审核通过了，可以显示版本更新了
            self.titleArray = @[@"推送设置",@"清理缓存",@"第三方授权",@"版本号"];
        } else {
            self.titleArray = @[@"推送设置",@"清理缓存",@"第三方授权"];
        }
    } else { // 版本不一样，说明当前版本是旧版本，可以显示版本更新
        self.titleArray = @[@"修改支付密码",@"推送设置",@"清理缓存",@"第三方授权",@"版本号"];
    }
    
    if (![[WYUserDefaultManager shareManager] firstMessageNoticeSetting]) {
        [[WYUserDefaultManager shareManager] saveReceiveMessageNoticeSetting:YES];
        [[WYUserDefaultManager shareManager] saveFirstMessageNoticeSetting:YES];
    }

    [self setupUI];
    
    WeakSelf
    
    [RACObserve([LoginUserDefault userDefault].userItem, wechatAccount) subscribeNext:^(id x) {
        [weakSelf.tableView reloadData];
    }];
    
    // 计算缓存大小
    [WYFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        
        weakSelf.totalSize = totalSize;
        
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(AUTOSIZESCALEX(10), 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[SettingSwitchCell class] forCellReuseIdentifier:switchCellId];
    [tableView registerClass:[SettingNormalCell class] forCellReuseIdentifier:normalCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
    
    WeakSelf
    
    UIButton *signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signOutButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    [signOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    signOutButton.titleLabel.font = TextFont(15);
//    [signOutButton setBackgroundColor:QHMainColor];
    [signOutButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(30), AUTOSIZESCALEX(40)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    signOutButton.layer.cornerRadius = 3;
    signOutButton.layer.masksToBounds = YES;
    [[signOutButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
        
        [[NetworkSingleton sharedManager] postRequestWithUrl:@"/auth/logout" parameters:parameters successBlock:^(id response) {
            if ([response[@"code"] integerValue] == RequestSuccess) {
                [[WYUserDefaultManager shareManager] setUserPassword:@""];
                [LoginUserDefault userDefault].userItem = [[UserItem alloc] init];
                [LoginUserDefault userDefault].isTouristsMode = YES;
                [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;

                LoginViewController *loginVc = [[LoginViewController alloc] init];
                loginVc.comeFromLoginOut = YES;
                [LoginUserDefault userDefault].isLoginVc = YES;
                [weakSelf.navigationController pushViewController:loginVc animated:YES];
//                WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:loginVc];
//                [weakSelf presentViewController:nav animated:YES completion:nil];
            } else {
                [WYHud showMessage:response[@"msg"]];
            }
        } failureBlock:^(NSString *error) {
            
        }];
        
//        [UIApplication sharedApplication].keyWindow.rootViewController = nav;
    }];
    [self.view addSubview:signOutButton];
    
    CGFloat top = AUTOSIZESCALEX(250);
    
    if ([[LoginUserDefault userDefault].versionItem.version isEqualToString:APP_VERSION]) { // 版本一样，说明当前的是最新版本，需要判断当前版本的数字编号，数字编号大于0表示审核通过了，可以显示版本更新了
        if ([LoginUserDefault userDefault].versionItem.number > 0) { // 数字编号大于0表示审核通过了，可以显示版本更新了
            top = AUTOSIZESCALEX(300);
        } else {
            top = AUTOSIZESCALEX(250);
        }
    } else { // 版本不一样，说明当前版本是旧版本，可以显示版本更新
        top = AUTOSIZESCALEX(300);
    }
    
    [signOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(top+80);
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AUTOSIZESCALEX(45);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        SettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:switchCellId];
        
        return cell;
    }
    SettingNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellId];
    
    cell.title = self.titleArray[indexPath.row];
    if (indexPath.row == 2) {
        cell.content = [self sizeString];
        [cell setArrowImageViewHidden:NO];
    } else if (indexPath.row == 3) {
        cell.content = [NSString isEmpty:[LoginUserDefault userDefault].userItem.wechatAccount] ? @"" : @"";
        [cell setArrowImageViewHidden:NO];

    } else if (indexPath.row == 4) {
        cell.content = [NSString stringWithFormat:@"V%@",APP_VERSION];
        [cell setArrowImageViewHidden:YES];
    } else if (indexPath.row == 0) {
        [cell setArrowImageViewHidden:YES];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        NSString *qrurl = [[NSString alloc] initWithFormat:@"http://haomaih5.lucius.cn//#/paypassword?phone=%@&from=set", [LoginUserDefault userDefault].userItem.mobile];
        WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
        webVc.urlString = qrurl;
        [self.navigationController pushViewController:webVc animated:YES];
    }
    if (indexPath.row == 2) { // 清理缓存
        [self didClickClearCache];
    } else if (indexPath.row == 3) { // 第三方授权
        SettingThirdPartyAuthorController *authorVc = [[SettingThirdPartyAuthorController alloc] init];
        [self.navigationController pushViewController:authorVc animated:YES];
    } else if (indexPath.row == 4) { // 版本更新
        WYLog(@"版本更新");
//        if ([[LoginUserDefault userDefault].versionItem.version isEqualToString:APP_VERSION]) { // 版本一样，说明当前的是最新版本，需要判断当前版本的数字编号，数字编号大于0表示审核通过了，可以显示版本更新了
//            if ([LoginUserDefault userDefault].versionItem.number > 0) { // 数字编号大于0表示审核通过了，可以显示版本更新了
//                [WYHud showMessage:@"当前已是最新版本!"];
//            }
//        } else { // 版本不一样，说明当前版本是旧版本，可以显示版本更新
//            UpdateVersionView *versionView = [[UpdateVersionView alloc] initWithFrame:SCREEN_FRAME];
//            //        versionView.updateDesc = @"1、修复了部分bug体验更优\n2、双十一双重活动来袭，快来领福利!\n3、增加更多礼包\n4、优化了部分界面";
//            versionView.updateDesc = [LoginUserDefault userDefault].versionItem.log;
//            versionView.delegate = self;
//            [versionView show];
//        }
    }
}

#pragma mark - Private method

// 计算缓存尺寸
- (NSString *)sizeString {
    
    NSString *sizeStr = @"0.0B";
    
    if (self.totalSize > 1000 * 1000) {
        sizeStr = [NSString stringWithFormat:@"%.1fMB",self.totalSize / 1000.0 / 1000.0];
    } else if (self.totalSize > 1000) {
        sizeStr = [NSString stringWithFormat:@"%.1fKB",self.totalSize / 1000.0];
    } else if (self.totalSize > 0) {
        sizeStr = [NSString stringWithFormat:@"%zdB",self.totalSize];
    }
    
    return sizeStr;
}

// 清理缓存
- (void)didClickClearCache {
    
    if (_totalSize == 0) { // 没有缓存不用清理
        return;
    }
    [WYProgress showWithStatus:@"正在清理..."];
    
    [WYFileTool removeDirectoryPath:CachePath];
    
    // 清除缓存的时候要把totalSize清零
    _totalSize = 0;
    
    WeakSelf
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WYProgress showSuccessWithStatus:@"清理缓存成功" dismissWithDelay:1.0];
        // 删除后刷新
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - UpdateVersionViewDelegate

- (void)updateVersionView:(UpdateVersionView *)updateVersionView didClcikUpdateButton:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[LoginUserDefault userDefault].versionItem.downloadUrl]];
}

@end
