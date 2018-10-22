//
//  MineViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderView.h"
#import "MineNormalCell.h"

#import "BindPhoneViewController.h"
#import "PersonalInfoController.h"
#import "MemberRewardController.h"
#import "MemberWelfareController.h"
#import "ShowShowGradeController.h"
#import "SettingViewController.h"
#import "MineWalletController.h"
#import "ConsumPointController.h"
#import "MyTeamController.h"
#import "AboutUsController.h"
#import "MyCollectController.h"
#import "RecentlyBrowserController.h"
#import "PromotionController.h"
#import "UpgradeVIPController.h"
#import "VersionItem.h"
#import "LoginViewController.h"
#import "MineMemberRankListCell.h"
#import "CustomerServiceController.h"
#import "MemberRankListController.h"
#import "FeedBackController.h"

#import "MineFirstSectionCell.h"
#import "MineThirdSectionCell.h"
#import "MineFourthSectionCell.h"
#import "ShareMakeMoneyController.h"


#import "WebViewH5Controller.h"

@interface MineViewController () <UITableViewDelegate,UITableViewDataSource,MineheaderViewDelegate,MineFirstSectionCellDelegate,MineThirdSectionCellDelegate,MineFourthSectionCellDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MineHeaderView *headerView;
/**    数据源    */
@property (strong, nonatomic) NSArray *secondSectionTitleArray;
@property (strong, nonatomic) NSArray *secondSectionIconArray;

@end

static NSString *const firstSectionCellId = @"firstSectionCellId";
static NSString *const thirdSectionCellId = @"thirdSectionCellId";
static NSString *const fourthSectionCellId = @"fourthSectionCellId";
static NSString *const rankCellId = @"rankCellId";

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self initData];
    [self setupNav];
    [self setupUI];
    
    WeakSelf
    
    [RACObserve([LoginUserDefault userDefault], dataHaveChanged) subscribeNext:^(id x) {
        if (![LoginUserDefault userDefault].isTouristsMode) {
            [weakSelf getMemberData];
        }else{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *reward = [userDefaults objectForKey:@"reward"];
            NSString *walfare = [userDefaults objectForKey:@"walfare"];
            NSString *wallet = [userDefaults objectForKey:@"wallet"];
            NSString *score = [userDefaults objectForKey:@"consumePoint"];

            if ([reward isEqualToString:@""]||reward == nil) {
                reward = @"0.00";
            }
            if ([walfare isEqualToString:@""]||walfare == nil) {
                walfare = @"0.00";
            }
            if ([score isEqualToString:@""]||score == nil) {
                score = @"0";
            }
            //            [weakSelf.tableView reloadData];
            _headerView.balanceArray = [NSMutableArray arrayWithArray:@[[NSString excludeEmptyQuestion:reward],[NSString excludeEmptyQuestion:walfare],[NSString excludeEmptyQuestion:score]]];

        }

        [weakSelf.tableView reloadData];
    }];
    
    [RACObserve([LoginUserDefault userDefault], versionDataHaveChanged) subscribeNext:^(id x) {
        [weakSelf initData];
        [weakSelf.tableView reloadData];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    WYLog(@"viewWillAppear");
    // 每次都要更新数据
    [self getMemberData];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:QHBlackColor}];
}

#pragma mark - Data

// 初始化数据
- (void)initData {
    NSString *recommendCode = @"我的推荐码";
    if (![LoginUserDefault userDefault].isTouristsMode) {
        recommendCode = [NSString stringWithFormat:@"我的邀请码：%@",[LoginUserDefault userDefault].userItem.recommendCode];
    }
    
    if ([[LoginUserDefault userDefault].versionItem.version isEqualToString:APP_VERSION]) { // 版本一样，说明当前的是最新版本，需要判断当前版本的数字编号，数字编号大于0表示审核通过了，可以显示升级会员了
        if ([LoginUserDefault userDefault].versionItem.number > 0) { // 数字编号大于0表示审核通过了，可以显示升级会员了
            self.secondSectionTitleArray =@[@[@"会员排行榜"],@[@"升级VIP会员",@"我的团队"],@[@"宣传物料",recommendCode],@[@"分享APP",@"关于我们",@"客服中心"]];
            self.secondSectionIconArray =@[@[@"icon_会员"],@[@"icon_会员",@"团队"],@[@"文件",@"邀请码填充"],@[@"手机(1)",@"关于我",@"客服"]];
        } else {
            self.secondSectionTitleArray =@[@[@"会员排行榜"],@[@"我的团队"],@[@"宣传物料",recommendCode],@[@"分享APP",@"关于我们",@"客服中心"]];
            self.secondSectionIconArray =@[@[@"icon_会员"],@[@"团队"],@[@"文件",@"邀请码填充"],@[@"手机(1)",@"关于我",@"客服"]];
        }
    } else { // 版本不一样，说明当前版本是旧版本，可以显示升级会员
        self.secondSectionTitleArray =@[@[@"会员排行榜"],@[@"升级VIP会员",@"我的团队"],@[@"宣传物料",recommendCode],@[@"分享APP",@"关于我们",@"客服中心"]];
        self.secondSectionIconArray =@[@[@"icon_会员"],@[@"icon_会员",@"团队"],@[@"文件",@"邀请码填充"],@[@"手机(1)",@"关于我",@"客服"]];
    }
}

// 获取会员奖励、消费积分、会员福利、我的钱包数据
- (void)getMemberData {
    WeakSelf
    
    if ([LoginUserDefault userDefault].isTouristsMode) {
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/personal/overview" parameters:parameters successBlock:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == RequestSuccess) {
            [LoginUserDefault userDefault].reward = [NSString stringWithFormat:@"%.2f",[response[@"data"][@"reward"]  floatValue]];
            [LoginUserDefault userDefault].walfare = [NSString stringWithFormat:@"%.2f",[response[@"data"][@"welfare"]  floatValue]];
            [LoginUserDefault userDefault].wallet = [NSString stringWithFormat:@"%.2f",[response[@"data"][@"balance"]  floatValue]];
            [LoginUserDefault userDefault].consumePoint = [NSString stringWithFormat:@"%zd",[response[@"data"][@"score"]  integerValue]];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:[NSString stringWithFormat:@"%.2f",[response[@"data"][@"reward"]  floatValue]] forKey:@"reward"];
            [userDefaults setObject:[NSString stringWithFormat:@"%.2f",[response[@"data"][@"welfare"]  floatValue]] forKey:@"walfare"];
            [userDefaults setObject:[NSString stringWithFormat:@"%.2f",[response[@"data"][@"balance"]  floatValue]] forKey:@"wallet"];
            [userDefaults setObject:[NSString stringWithFormat:@"%.2f",[response[@"data"][@"score"]  floatValue]] forKey:@"consumePoint"];
            [userDefaults synchronize];
//            [weakSelf.tableView reloadData];
            _headerView.balanceArray = [NSMutableArray arrayWithArray:@[[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].reward],[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].walfare],[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].consumePoint]]];

        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - Nav

- (void)setupNav {
    //self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"设置" titleColor:QHBlackColor titleFont:TextFont(13) target:self action:@selector(didClickSetting)];
//    UIBarButtonItem* setItem = [UIBarButtonItem barButtonItemWithImage:ImageWithNamed(@"icon_set") selectedImage:ImageWithNamed(@"icon_share") target:self action:@selector(didClickSetting)];
//    UIBarButtonItem* shareItem = [UIBarButtonItem barButtonItemWithImage:ImageWithNamed(@"icon_share") selectedImage:ImageWithNamed(@"icon_share") target:self action:@selector(shareAction)];
//    self.navigationItem.rightBarButtonItems = @[shareItem,setItem];

    UIBarButtonItem* kefuItem = [UIBarButtonItem barButtonItemWithImage:ImageWithNamed(@"icon_service") selectedImage:ImageWithNamed(@"icon_service") target:self action:@selector(didClickKefu)];
        self.navigationItem.rightBarButtonItems = @[kefuItem];

    
}
-(void)setAction{
    
}
-(void)shareAction{
    WeakSelf
    [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
        [[WYUMShareMnager manager] showShareUIWithSelectionBlock:^(UMSocialPlatformType type) {
            [[WYUMShareMnager manager] shareDataWithPlatform:type title:@"好麦优惠券APP" desc:@"不花冤枉钱，先领券再消费，能省的绝不多花一分，海量商品最高返佣60%" shareURL:[LoginUserDefault userDefault].userItem.recommendUrl thumImage:ImageWithNamed(@"appIcon_small") fromVc:self completion:^(id result, NSError *error) {
                if (!error) {
                    [WYProgress showSuccessWithStatus:@"分享成功!"];
                }
            }];
        }];
    }];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(-kNavHeight, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = self.headerView;
    [tableView registerClass:[MineFirstSectionCell class] forCellReuseIdentifier:firstSectionCellId];
    [tableView registerClass:[MineThirdSectionCell class] forCellReuseIdentifier:thirdSectionCellId];
    [tableView registerClass:[MineFourthSectionCell class] forCellReuseIdentifier:fourthSectionCellId];
    [tableView registerClass:[MineMemberRankListCell class] forCellReuseIdentifier:rankCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
}

- (MineHeaderView *)headerView {
    if (!_headerView) {
        CGFloat height = AUTOSIZESCALEX(325);
        if (UI_IS_IPHONEX) {
            height = AUTOSIZESCALEX(325) + 75;
        }
        _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
        _headerView.delegate = self;
      
    }
    if ([LoginUserDefault userDefault].isTouristsMode) { // 游客模式
        _headerView.balanceArray = [NSMutableArray arrayWithArray:@[@"0.00",@"0.00",@"0"]];
    } else {
        _headerView.balanceArray = [NSMutableArray arrayWithArray:@[[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].reward],[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].walfare],[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].consumePoint]]];
    }
    return _headerView;
}

#pragma mark - Button Action

- (void)didClickSetting {
    WeakSelf
    [LoginUtil loginWithFatherVc:self completedHandler:^{
        SettingViewController *settingVc = [[SettingViewController alloc] init];
        [weakSelf.navigationController pushViewController:settingVc animated:YES];
    }];
}

- (void)didClickKefu
{
    [LoginUtil loginWithFatherVc:self completedHandler:^{
        //            CustomerServiceController *serviceVc = [[CustomerServiceController alloc] init];
        //            [weakSelf.navigationController pushViewController:serviceVc animated:YES];
        NSString *qrurl = @"http://haomaih5.lucius.cn//#/kefu";
        WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
        webVc.urlString = qrurl;
        [self.navigationController pushViewController:webVc animated:YES];
    }];
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIImage *image = ImageWithNamed(@"会员排行榜");
        return AUTOSIZESCALEX(image.size.height);
    } else if (indexPath.section == 2) {
        return AUTOSIZESCALEX(75);
    } else if (indexPath.section == 1) {
        return AUTOSIZESCALEX(255);
    } else if (indexPath.section == 3) {
        return AUTOSIZESCALEX(85);
    }
    return AUTOSIZESCALEX(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        MineFirstSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:firstSectionCellId];
        if ([LoginUserDefault userDefault].isTouristsMode) { // 游客模式
            cell.balanceArray = [NSMutableArray arrayWithArray:@[@"0.00",@"0.00",@"0"]];
        } else {
            cell.balanceArray = [NSMutableArray arrayWithArray:@[[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].wallet],[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].walfare],[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].consumePoint]]];
        }
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 0) { // 会员排行榜
        MineMemberRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:rankCellId];
        return cell;
    } else if (indexPath.section == 1) { //
        MineThirdSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdSectionCellId];
        cell.delegate = self;
        return cell;
    } else {
        MineFourthSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:fourthSectionCellId];
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 会员排行榜
        WeakSelf
        [LoginUtil loginWithFatherVc:self completedHandler:^{
            WYLog(@"会员排行榜");
            MemberRankListController *rankListVc = [[MemberRankListController alloc] init];
            [weakSelf.navigationController pushViewController:rankListVc animated:YES];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffSet = scrollView.contentOffset;
    if (contentOffSet.y < 0) {
        contentOffSet.y = 0;
        self.tableView.contentOffset = contentOffSet;
    }
}

#pragma mark - MineheaderViewDelegate
// 编辑个人信息
- (void)mineHeaderView:(MineHeaderView *)mineHeaderView editPersonalInfo:(NSString *)info {
    WeakSelf
    NSInteger tag = [info integerValue];
    switch (tag) {
        case shareMaisui:
        {
            [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
                MemberRewardController *rewardVc = [[MemberRewardController alloc] init];
                [weakSelf.navigationController pushViewController:rewardVc animated:YES];
            }];
        }
            break;
        case consumeMaisui:
        {
            [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
                MemberWelfareController *welfareVc = [[MemberWelfareController alloc] init];
                [weakSelf.navigationController pushViewController:welfareVc animated:YES];
            }];
        }
            break;
        case maili:
        {
            [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
                ConsumPointController *consumPointVc = [[ConsumPointController alloc] init];
                [weakSelf.navigationController pushViewController:consumPointVc animated:YES];
            }];
        }
            break;
        case myWallet:
        {
            [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
                
                NSString *qrurl = [[NSString alloc] initWithFormat:@"%@%@",@"http://haomaih5.lucius.cn/#/wallet?phone=", [LoginUserDefault userDefault].userItem.mobile];
                
                
                WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
                webVc.urlString = qrurl;
                webVc.title = @"我的钱包";
                [weakSelf.navigationController pushViewController:webVc animated:YES];
                
                //            MineWalletController *walletVc = [[MineWalletController alloc] init];
                //            [weakSelf.navigationController pushViewController:walletVc animated:YES];
            }];
        }
            break;
        case waitPay:
            [self gotoH5VCWithStatus:0];
            break;
        case handOut:
            [self gotoH5VCWithStatus:1];
            break;
        case receive:
            [self gotoH5VCWithStatus:2];
            break;
        case reCommand:
            [self gotoH5VCWithStatus:3];
            break;
        case afterSale:
            [self gotoH5VCWithStatus:3];
            break;
        case moreOrder:
            [self gotoH5VCWithStatus:5];
            break;
        case header:
        {
            [LoginUtil loginWithFatherVc:self completedHandler:^{
                PersonalInfoController *personalInfoVc = [[PersonalInfoController alloc] init];
                [weakSelf.navigationController pushViewController:personalInfoVc animated:YES];
            }];
        }
        default:
            break;
    }
//    [LoginUtil loginWithFatherVc:self completedHandler:^{
//        PersonalInfoController *personalInfoVc = [[PersonalInfoController alloc] init];
//        [weakSelf.navigationController pushViewController:personalInfoVc animated:YES];
//    }];
}

// 我的收藏
- (void)mineHeaderView:(MineHeaderView *)mineHeaderView checkMyCollect:(NSString *)info {
    WeakSelf
    [LoginUtil loginWithFatherVc:self completedHandler:^{
        MyCollectController *myCollectVc = [[MyCollectController alloc] init];
        [weakSelf.navigationController pushViewController:myCollectVc animated:YES];
    }];
}

// 最近浏览
- (void)mineHeaderView:(MineHeaderView *)mineHeaderView checkRecentlyBrowse:(NSString *)info {
    WeakSelf
    [LoginUtil loginWithFatherVc:self completedHandler:^{
        RecentlyBrowserController *recentlyBrowserVc = [[RecentlyBrowserController alloc] init];
        [weakSelf.navigationController pushViewController:recentlyBrowserVc animated:YES];
    }];
}

#pragma mark - MineFirstSectionCellDelegate

- (void)mineFirstSectionCell:(MineFirstSectionCell *)mineFirstSectionCell didSelectItemAtIndex:(NSInteger)index {
    WeakSelf
    if (index == 0) { // 会员奖励
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            MemberRewardController *rewardVc = [[MemberRewardController alloc] init];
            [weakSelf.navigationController pushViewController:rewardVc animated:YES];
        }];
    } else if (index == 1) { // 会员福利
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            MemberWelfareController *welfareVc = [[MemberWelfareController alloc] init];
            [weakSelf.navigationController pushViewController:welfareVc animated:YES];
        }];
    } else if (index == 2) { // 消费积分
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            ConsumPointController *consumPointVc = [[ConsumPointController alloc] init];
            [weakSelf.navigationController pushViewController:consumPointVc animated:YES];
        }];
    } else if (index == 3) { // 我的钱包
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            
            NSString *qrurl = [[NSString alloc] initWithFormat:@"%@%@",@"http://haomaih5.lucius.cn/#/wallet?phone=", [LoginUserDefault userDefault].userItem.mobile];
            
            
            WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
            webVc.urlString = qrurl;
            webVc.title = @"我的钱包";
            [weakSelf.navigationController pushViewController:webVc animated:YES];
            
//            MineWalletController *walletVc = [[MineWalletController alloc] init];
//            [weakSelf.navigationController pushViewController:walletVc animated:YES];
        }];
    }
}

#pragma mark - MineThirdSectionCellDelegate

- (void)mineThirdSectionCell:(MineThirdSectionCell *)mineThirdSectionCell didSelectItemAtIndex:(NSInteger)index {
    WeakSelf
    if ([[LoginUserDefault userDefault].versionItem.version isEqualToString:APP_VERSION]) { // 版本一样，说明当前的是最新版本，需要判断当前版本的数字编号
        if ([LoginUserDefault userDefault].versionItem.number == 0) { // 数字编号等于0表示审核中，不可以显示升级会员
            if (index == 0) { // 我的团队
                [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
                    MyTeamController *myTeamVc = [[MyTeamController alloc] init];
                    [weakSelf.navigationController pushViewController:myTeamVc animated:YES];
                }];
            } else if (index == 1) { // 宣传物料
                [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
                    PromotionController *promotionVc = [[PromotionController alloc] init];
                    [weakSelf.navigationController pushViewController:promotionVc animated:YES];
                }];
            } else if (index == 2) { // 分享APP
                [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
                    [[WYUMShareMnager manager] showShareUIWithSelectionBlock:^(UMSocialPlatformType type) {
                        [[WYUMShareMnager manager] shareDataWithPlatform:type title:@"好麦优惠券APP" desc:@"不花冤枉钱，先领券再消费，能省的绝不多花一分，海量商品最高返佣60%" shareURL:[LoginUserDefault userDefault].userItem.recommendUrl thumImage:ImageWithNamed(@"appIcon_small") fromVc:self completion:^(id result, NSError *error) {
                            if (!error) {
                                [WYProgress showSuccessWithStatus:@"分享成功!"];
                            }
                        }];
                    }];
                }];
//                ShareMakeMoneyController *shareVc = [[ShareMakeMoneyController alloc] init];
//                [weakSelf.navigationController pushViewController:shareVc animated:YES];
            } else if (index == 3) { // 我的收藏
                [LoginUtil loginWithFatherVc:self completedHandler:^{
                    MyCollectController *myCollectVc = [[MyCollectController alloc] init];
                    [weakSelf.navigationController pushViewController:myCollectVc animated:YES];
                }];
            } else if (index == 4) { // 最近浏览
                [LoginUtil loginWithFatherVc:self completedHandler:^{
                    RecentlyBrowserController *recentlyBrowserVc = [[RecentlyBrowserController alloc] init];
                    [weakSelf.navigationController pushViewController:recentlyBrowserVc animated:YES];
                }];
            }
            return;
        }
    }
    if (index == 0) { // 升级VIP
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            UpgradeVIPController *upgradeVc = [[UpgradeVIPController alloc] init];
            [weakSelf.navigationController pushViewController:upgradeVc animated:YES];
        }];
    } else if (index == 1) { // 我的团队
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            MyTeamController *myTeamVc = [[MyTeamController alloc] init];
            [weakSelf.navigationController pushViewController:myTeamVc animated:YES];
        }];
    } else if (index == 2) { // 宣传物料
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            PromotionController *promotionVc = [[PromotionController alloc] init];
            [weakSelf.navigationController pushViewController:promotionVc animated:YES];
        }];
    } else if (index == 3) { // 分享APP
//        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
//            [[WYUMShareMnager manager] showShareUIWithSelectionBlock:^(UMSocialPlatformType type) {
//                [[WYUMShareMnager manager] shareDataWithPlatform:type title:@"好麦优惠券APP" desc:@"不花冤枉钱，先领券再消费，能省的绝不多花一分，海量商品最高返佣60%" shareURL:[LoginUserDefault userDefault].userItem.recommendUrl thumImage:ImageWithNamed(@"appIcon_small") fromVc:self completion:^(id result, NSError *error) {
//                    if (!error) {
//                        [WYProgress showSuccessWithStatus:@"分享成功!"];
//                    }
//                }];
//            }];
//        }];
//        ShareMakeMoneyController *shareVc = [[ShareMakeMoneyController alloc] init];
//        [weakSelf.navigationController pushViewController:shareVc animated:YES];
        [LoginUtil loginWithFatherVc:self completedHandler:^{
            MyCollectController *myCollectVc = [[MyCollectController alloc] init];
            [weakSelf.navigationController pushViewController:myCollectVc animated:YES];
        }];
    } else if (index == 4) { // 我的收藏
//        [LoginUtil loginWithFatherVc:self completedHandler:^{
//            MyCollectController *myCollectVc = [[MyCollectController alloc] init];
//            [weakSelf.navigationController pushViewController:myCollectVc animated:YES];
//        }];
        [LoginUtil loginWithFatherVc:self completedHandler:^{
            RecentlyBrowserController *recentlyBrowserVc = [[RecentlyBrowserController alloc] init];
            [weakSelf.navigationController pushViewController:recentlyBrowserVc animated:YES];
        }];
    } else if (index == 5) { // 最近浏览
//        [LoginUtil loginWithFatherVc:self completedHandler:^{
//            RecentlyBrowserController *recentlyBrowserVc = [[RecentlyBrowserController alloc] init];
//            [weakSelf.navigationController pushViewController:recentlyBrowserVc animated:YES];
//
//        }];
        [WYProgress showSuccessWithStatus:@"敬请期待"];
    } else if(index == 6){
        [LoginUtil loginWithFatherVc:self completedHandler:^{
            AboutUsController *aboutUsVc = [[AboutUsController alloc] init];
            [weakSelf.navigationController pushViewController:aboutUsVc animated:YES];
        }];
    } else if(index == 7){
        [LoginUtil loginWithFatherVc:self completedHandler:^{
            FeedBackController *feedBackVc = [[FeedBackController alloc] init];
            [weakSelf.navigationController pushViewController:feedBackVc animated:YES];
        }];
    } else if(index == 8){
        [LoginUtil loginWithFatherVc:self completedHandler:^{
            SettingViewController *settingVc = [[SettingViewController alloc] init];
            [weakSelf.navigationController pushViewController:settingVc animated:YES];
        }];
    } else if(index == 9){
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            [[WYUMShareMnager manager] showShareUIWithSelectionBlock:^(UMSocialPlatformType type) {
                [[WYUMShareMnager manager] shareDataWithPlatform:type title:@"好麦优惠券APP" desc:@"不花冤枉钱，先领券再消费，能省的绝不多花一分，海量商品最高返佣60%" shareURL:[LoginUserDefault userDefault].userItem.recommendUrl thumImage:ImageWithNamed(@"appIcon_small") fromVc:self completion:^(id result, NSError *error) {
                    if (!error) {
                        [WYProgress showSuccessWithStatus:@"分享成功!"];
                    }
                }];
            }];
        }];
    }
}

#pragma mark - MineFourthSectionCellDelegate

- (void)mineFourthSectionCell:(MineFourthSectionCell *)mineFourthSectionCell didSelectItemAtIndex:(NSInteger)index {
    WeakSelf
    if (index == 0) { // 客服中心
        [LoginUtil loginWithFatherVc:self completedHandler:^{
            CustomerServiceController *serviceVc = [[CustomerServiceController alloc] init];
            [weakSelf.navigationController pushViewController:serviceVc animated:YES];
        }];
    } else if (index == 1) { // 关于我们
        [LoginUtil loginWithFatherVc:self completedHandler:^{
            AboutUsController *aboutUsVc = [[AboutUsController alloc] init];
            [weakSelf.navigationController pushViewController:aboutUsVc animated:YES];
        }];
    } else if (index == 2) { // 意见反馈
        [LoginUtil loginWithFatherVc:self completedHandler:^{
            FeedBackController *feedBackVc = [[FeedBackController alloc] init];
            [weakSelf.navigationController pushViewController:feedBackVc animated:YES];
        }];
    }
}


- (void)gotoH5VCWithStatus:(NSInteger)status
{
    
    NSString *qrurl = @"http://haomaimall.lucius.cn/center/order/index";
//    BOOL isTouristsMode = [LoginUserDefault userDefault].isTouristsMode;
//    if (isTouristsMode) {
        if (status == 5) {
            NSString *userId = [LoginUserDefault userDefault].userItem.userId;
            qrurl = [NSString stringWithFormat:@"%@?uid=%@",qrurl,userId];
        }else{
            NSString *userId = [LoginUserDefault userDefault].userItem.userId;
            qrurl = [NSString stringWithFormat:@"%@?uid=%@&status=%ld",qrurl,userId,(long)status];
        }

//    }
    WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
    webVc.urlString = qrurl;
    [self.navigationController pushViewController:webVc animated:YES];
}
@end
