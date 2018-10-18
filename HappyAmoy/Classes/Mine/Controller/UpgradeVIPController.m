//
//  UpgradeVIPController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UpgradeVIPController.h"
#import "UpgradeVIPView.h"
#import "UpgradeVIPCell.h"
#import "WebViewH5Controller.h"

#import "PayWayView.h"

@interface UpgradeVIPController () <UITableViewDelegate,UITableViewDataSource,UpgradeVIPCellDelegate,PayWayViewDelegate>

/**    视图    */
@property (strong, nonatomic) UpgradeVIPView *vipView;
/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;

@end

static NSString *const vipCellId = @"vipCellId";

@implementation UpgradeVIPController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupUI];

    // 监听是否付款成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:PaySuccessNotificationName object:nil];
}

#pragma mark - Notice
// 监听是否付款成功
- (void)paySuccess {
//    [WYProgress showSuccessWithStatus:@"支付成功!"];
//    [WYProgress showSuccessWithStatus:@"恭喜您成为好麦VIP会员！请立即完善信息，领取我们为您精心准备的大礼包"];
    [self showAlertController];

    [LoginUserDefault userDefault].userItem.viped = 1;
    [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - Nav

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageOriginalWithNamed:@"返回_白色"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickBackButton)];
}

- (void)showAlertController
{
    /*
     先创建UIAlertController，preferredStyle：选择UIAlertControllerStyleActionSheet，这个就是相当于创建8.0版本之前的UIActionSheet；
     
     typedef NS_ENUM(NSInteger, UIAlertControllerStyle) {
     UIAlertControllerStyleActionSheet = 0,
     UIAlertControllerStyleAlert
     } NS_ENUM_AVAILABLE_IOS(8_0);
     
     */
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"恭喜您成为好麦VIP会员！请立即完善信息，领取我们为您精心准备的大礼包" preferredStyle:UIAlertControllerStyleAlert];
    
    /*
     typedef NS_ENUM(NSInteger, UIAlertActionStyle) {
     UIAlertActionStyleDefault = 0,
     UIAlertActionStyleCancel,         取消按钮
     UIAlertActionStyleDestructive     破坏性按钮，比如：“删除”，字体颜色是红色的
     } NS_ENUM_AVAILABLE_IOS(8_0);
     
     */
    // 创建action，这里action1只是方便编写，以后再编程的过程中还是以命名规范为主
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *userid = [LoginUserDefault userDefault].userItem.userId;
        
        NSString *url = [NSString stringWithFormat:@"http://haomaimall.lucius.cn/center/address?uid=%@",userid];

        WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
        webVc.urlString = url;
        [self.navigationController pushViewController:webVc animated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
 
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    
    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark - UI

- (void)setupUI {
    WeakSelf
    UpgradeVIPView *vipView = [[UpgradeVIPView alloc] init];
    [self.view addSubview:vipView];
    self.vipView = vipView;
    [self.vipView setClickedBtnBlock:^{
        [weakSelf clickVipBtn];
    }];
    [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.backgroundColor = FooterViewBackgroundColor;
//    tableView.estimatedRowHeight = 740;
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [tableView registerClass:[UpgradeVIPCell class] forCellReuseIdentifier:vipCellId];
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
//    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(-kNavHeight);
//        make.left.right.bottom.equalTo(self.view);
//    }];
}

#pragma mark - Button Action

- (void)didClickBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (UI_IS_IPHONEX) {
//        return SCREEN_HEIGHT;
//    }
//    return AUTOSIZESCALEX(740);
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpgradeVIPCell *cell = [tableView dequeueReusableCellWithIdentifier:vipCellId];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UpgradeVIPCellDelegate
// 返回上一页面
- (void)upgradeVIPCell:(UpgradeVIPCell *)upgradeVIPCell didClickBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
// 选择支付方式
- (void)upgradeVIPCell:(UpgradeVIPCell *)upgradeVIPCell didSelectedPayWay:(NSInteger)payWay {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"payType"] = [NSString stringWithFormat:@"%zd",payWay];
    WeakSelf
    [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/upgradeVip" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (payWay == 1) { // 支付宝支付
                [weakSelf aliPayWithOrder:response[@"data"][@"payNo"] amount:[response[@"data"][@"amount"] floatValue]];
            } else { // 微信支付
//                [weakSelf wxPayWithOrder:response[@"data"][@"payNo"] amount:[response[@"data"][@"amount"] floatValue]];
                [weakSelf wxPayWithOrder:response[@"data"][@"payNo"] amount:[response[@"data"][@"amount"] floatValue]];
            }
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - Pay

// 微信支付
- (void)wxPayWithOrder:(NSString *)order amount:(CGFloat)amount {
    
    [MXWechatPayHandler payWithOrder:order amount:amount title:@"赞助好麦" completation:^(BOOL resp) {
        
    }];
}

// 支付宝支付
- (void)aliPayWithOrder:(NSString *)order amount:(CGFloat)amount {
    WeakSelf
    [AliPay payWithOrder:order amount:amount title:@"赞助好麦" completation:^(NSDictionary *resultDic, NSInteger code, NSString *msg) {
        WYLog(@"msg = %@",msg);
        if (code == 9000) { // 支付成功
            [weakSelf paySuccess];
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -
- (void)clickVipBtn
{
    if ([LoginUserDefault userDefault].userItem.viped == 0) { // 普通会员
        PayWayView *payView = [[PayWayView alloc] initWithFrame:SCREEN_FRAME];
        payView.delegate = self;
        [payView show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)payWayView:(PayWayView *)payWayView didSelectedPayWay:(NSInteger)payWay {
    
//    if ([self.delegate respondsToSelector:@selector(upgradeVIPCell:didSelectedPayWay:)]) {
//        [self.delegate upgradeVIPCell:self didSelectedPayWay:payWay];
//    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"payType"] = [NSString stringWithFormat:@"%zd",payWay];
    WeakSelf
    [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/upgradeVip" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (payWay == 1) { // 支付宝支付
                [weakSelf aliPayWithOrder:response[@"data"][@"payNo"] amount:[response[@"data"][@"amount"] floatValue]];
            } else { // 微信支付
                //                [weakSelf wxPayWithOrder:response[@"data"][@"payNo"] amount:[response[@"data"][@"amount"] floatValue]];
                [weakSelf wxPayWithOrder:response[@"data"][@"payNo"] amount:[response[@"data"][@"amount"] floatValue]];
            }
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

@end
