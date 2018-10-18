//
//  SubmitExchangeController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SubmitExchangeController.h"
#import "ExchangeAddressCell.h"
#import "AvailableGoldCell.h"
#import "ExchangeGoodsCell.h"
#import "ExchangeRemarkCell.h"
#import "ExchangeSuccessView.h"
#import "SwapGoogsListItem.h"
#import "ReceiptAddressController.h"
#import "AddressItem.h"

@interface SubmitExchangeController () <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,ExchangeRemarkCellDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    购买按钮    */
@property (strong, nonatomic) UIButton *buyButton;
/**    收藏按钮    */
@property (strong, nonatomic) UIButton *collectedButton;
/**    地址    */
@property(nonatomic,strong) AddressItem *addressItem;
/**    我的金豆    */
@property(nonatomic,assign) NSInteger myScore;
/**    备注    */
@property(nonatomic,copy) NSString *remark;

@end

static NSString *const addressCellId = @"addressCellId";
static NSString *const availableCellId = @"availableCellId";
static NSString *const goodsCellId = @"goodsCellId";
static NSString *const remarkCellId = @"remarkCellId";

@implementation SubmitExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    self.title = @"提交兑换";

    [self setupUI];
    [self getScore];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Data

// 获取我的金豆
- (void)getScore {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/sign/survey" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.myScore = [response[@"data"][@"socre"] integerValue];
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

- (void)swapGoods {
    if (!self.addressItem) {
        [WYProgress showErrorWithStatus:@"请选择收货地址!"];
        return;
    }
//    if (self.item.score > self.myScore) {
//        [WYProgress showErrorWithStatus:@"可用金豆不够兑换哟!"];
//        return;
//    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"addressId"] = self.addressItem.addressId;
    parameters[@"goodsId"] = self.item.swapId;
    parameters[@"quantity"] = @"1";
    parameters[@"remark"] = [NSString excludeEmptyQuestion:self.remark];
    WeakSelf
    [[NetworkSingleton sharedManager] postRequestWithUrl:[NSString stringWithFormat:@"/sign/swap"] parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            ExchangeSuccessView *successView = [[ExchangeSuccessView alloc] initWithFrame:SCREEN_FRAME];
            successView.cancelCallBack = ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [successView show];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {

    }];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[ExchangeAddressCell class] forCellReuseIdentifier:addressCellId];
    [tableView registerClass:[AvailableGoldCell class] forCellReuseIdentifier:availableCellId];
    [tableView registerClass:[ExchangeGoodsCell class] forCellReuseIdentifier:goodsCellId];
    [tableView registerClass:[ExchangeRemarkCell class] forCellReuseIdentifier:remarkCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WeakSelf
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.right.equalTo(weakSelf.view).offset(0);
        make.bottom.equalTo(weakSelf.view).offset(AUTOSIZESCALEX(-50)-SafeAreaBottomHeight);
    }];
    
    [self setupBottomView];
}

// 底部工具条
- (void)setupBottomView {
    
    UILabel *goldLabel = [[UILabel alloc] init];
    goldLabel.backgroundColor = QHWhiteColor;
    goldLabel.text = [NSString stringWithFormat:@"使用%zd麦粒",self.item.score];
    goldLabel.textColor = ColorWithHexString(@"#FB4F67");
    goldLabel.font = TextFont(14);
    goldLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:goldLabel];
    [goldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(0)-SafeAreaBottomHeight);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
        make.height.mas_equalTo(AUTOSIZESCALEX(50));
    }];

    WeakSelf
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeButton setTitle:@"马上兑换" forState:UIControlStateNormal];
    [exchangeButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
    exchangeButton.titleLabel.font = TextFont(14);
    [exchangeButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH * 0.5, AUTOSIZESCALEX(50)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [[exchangeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            WYLog(@"马上兑换");
            [weakSelf.view endEditing:YES];
            [weakSelf swapGoods];
//            ExchangeSuccessView *successView = [[ExchangeSuccessView alloc] initWithFrame:SCREEN_FRAME];
//            [successView show];
        }];
    }];
    [self.view addSubview:exchangeButton];
    [exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(SCREEN_WIDTH * 0.5);
        make.centerY.equalTo(goldLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(50));
    }];
}

#pragma mark - Button Action

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return AUTOSIZESCALEX(90);
    } else if (indexPath.section == 1) {
        return AUTOSIZESCALEX(50);
    } else if (indexPath.section == 2) {
        return AUTOSIZESCALEX(145);
    }
    return AUTOSIZESCALEX(200);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) { // 地址
        ExchangeAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellId];
        cell.item = self.addressItem;
        return cell;
    } else if (indexPath.section == 1) { // 可用金豆
        AvailableGoldCell *cell = [tableView dequeueReusableCellWithIdentifier:availableCellId];
        cell.myScroe = self.myScore;
        return cell;
    } else if (indexPath.section == 2) { // 兑换商品
        ExchangeGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsCellId];
        cell.item = self.item;
        return cell;
    } else if (indexPath.section == 3) { // 备注
        ExchangeRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:remarkCellId];
        cell.remark = self.remark;
        cell.delegate = self;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.backgroundColor = RandomColor;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.section == 0) { // 选择地址
        ReceiptAddressController *addressVc = [[ReceiptAddressController alloc] init];
        addressVc.isSelectAddress = YES;
        WeakSelf
        addressVc.selectAddressCallBack = ^(AddressItem *item) {
            weakSelf.addressItem = item;
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:addressVc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return AUTOSIZESCALEX(5);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - ExchangeRemarkCellDelegate

- (void)exchangeRemarkCell:(ExchangeRemarkCell *)exchangeRemarkCell textViewDidBeginEditing:(NSString *)text {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(270))];
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, AUTOSIZESCALEX(180));
    }];
}

- (void)exchangeRemarkCell:(ExchangeRemarkCell *)exchangeRemarkCell textViewDidEndEditing:(NSString *)text {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(0))];

    WYLog(@"remark = %@",text);
    self.remark = text;
}

#pragma mark - Private method


@end
