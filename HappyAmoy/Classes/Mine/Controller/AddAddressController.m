//
//  AddAddressController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddAddressController.h"
#import "AddAddressCell.h"
#import "JWAddressPickerView.h"
#import <BRPickerView/BRPickerView.h>
#import "AddressItem.h"

@interface AddAddressController () <UITableViewDelegate,UITableViewDataSource,AddAddressCellDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    数据源    */
@property(nonatomic,strong) NSMutableArray *datasource;
/**    类型标题数组    */
@property(nonatomic,strong) NSArray *typeArray;
/**    内容数组    */
@property(nonatomic,strong) NSArray *contentArray;

@end

static NSString *const addCellId = @"addCellId";

@implementation AddAddressController

#pragma mark - Lazy load

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加收货地址";
    self.view.backgroundColor = ViewControllerBackgroundColor;
    if (!_isModify) {
        self.item = [AddressItem emptyItem];
    }
    [self initData];
    [self setupUI];
}

#pragma mark - UI

// 初始化数据
- (void)initData {
    self.typeArray = @[@"收货人 ：",@"手机号 ：",@"省/市/区 ：",@"详细地址 ："];
    self.contentArray = @[self.item.deliveryName,self.item.deliveryMobile,[NSString stringWithFormat:@"%@  %@  %@",self.item.provinceName,self.item.cityName,self.item.areaName],self.item.address];
}

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    [tableView registerClass:[AddAddressCell class] forCellReuseIdentifier:addCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(5) + kNavHeight);
        make.left.right.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(0));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.layer.cornerRadius = AUTOSIZESCALEX(5);
    saveButton.layer.masksToBounds = YES;
    [saveButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(30), AUTOSIZESCALEX(40)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:QHBlackColor forState:UIControlStateNormal];
    saveButton.titleLabel.font = TextFont(15);
    [saveButton addTarget:self action:@selector(didClickSaveButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-15));
        make.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(-25)-SafeAreaBottomHeight);
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
}

#pragma mark - Button Action
// 保存
- (void)didClickSaveButton {
    [self.view endEditing:YES];
    if ([NSString isEmpty:self.item.deliveryName]) {
        [WYProgress showErrorWithStatus:@"收货人不能为空!"];
        return;
    } else if ([NSString isEmpty:self.item.deliveryMobile]) {
        [WYProgress showErrorWithStatus:@"手机号不能为空!"];
        return;
    } else if ([NSString isEmpty:self.item.provinceId]) {
        [WYProgress showErrorWithStatus:@"请选择省市区!"];
        return;
    } else if ([NSString isEmpty:self.item.address]) {
        [WYProgress showErrorWithStatus:@"请输入详细地址!"];
        return;
    }
    
    WeakSelf

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *url = @"/personal/delivery/add";

    if (_isModify) {
        parameters[@"id"] = self.item.addressId;
        url = @"/personal/delivery/update";
    }
    parameters[@"customerId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"deliveryMobile"] = self.item.deliveryMobile;
    parameters[@"deliveryName"] = self.item.deliveryName;
    parameters[@"provinceId"] = self.item.provinceId;
    parameters[@"cityId"] = self.item.cityId;
    parameters[@"areaId"] = self.item.areaId;
    parameters[@"address"] = self.item.address;

    [[NetworkSingleton sharedManager] postRequestWithUrl:url parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (_isModify) {
                [WYProgress showSuccessWithStatus:@"修改地址成功!"];
            } else {
                [WYProgress showSuccessWithStatus:@"增加地址成功!"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:AddressHaveChangedNotificationName object:nil];

                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AUTOSIZESCALEX(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:addCellId];
    cell.type = self.typeArray[indexPath.row];
    cell.content = self.contentArray[indexPath.row];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.canEdit = indexPath.row != 2;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.row == 2) {// 省市区
        WeakSelf
        [BRAddressPickerView showAddressPickerWithDefaultSelected:@[weakSelf.item.provinceName,weakSelf.item.cityName,weakSelf.item.areaName] isAutoSelect:NO themeColor:QHMainColor resultBlock:^(NSArray *selectAddressArr) {
            WYLog(@"selectAddressArr = %@",selectAddressArr);
            weakSelf.item.provinceName = selectAddressArr[0];
            weakSelf.item.cityName = selectAddressArr[1];
            weakSelf.item.areaName = selectAddressArr[2];
            [weakSelf getProvinceCityAreaId];
            weakSelf.contentArray = @[weakSelf.item.deliveryName,weakSelf.item.deliveryMobile,[NSString stringWithFormat:@"%@  %@  %@",weakSelf.item.provinceName,weakSelf.item.cityName,weakSelf.item.areaName],weakSelf.item.address];
            [weakSelf.tableView reloadData];
        }];
        
//        [JWAddressPickerView showWithAddressBlock:^(NSString *province, NSString *city, NSString *area) {
//            WYLog(@"province = %@ ,city = %@ ,area = %@",province,city,area);
//        }];
    }
}

#pragma mark - AddAddressCellDelegate

- (void)addAddressCell:(AddAddressCell *)addAddressCell textFieldDidEndEditing:(NSString *)text index:(NSInteger)index {
    switch (index) {
        case 0: { // 收货人
            self.item.deliveryName = text;
        }
            break;
        case 1: { // 手机号
            self.item.deliveryMobile = text;
        }
            break;
        case 3: { // 详细地址
            self.item.address = text;
        }
            break;
        default:
            break;
    }
    self.contentArray = @[self.item.deliveryName,self.item.deliveryMobile,[NSString stringWithFormat:@"%@  %@  %@",self.item.provinceName,self.item.cityName,self.item.areaName],self.item.address];
    [self.tableView reloadData];
}

#pragma mark - Private method
// 根据名称获取省市区ID
- (void)getProvinceCityAreaId {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"areas" ofType:@"csv"];
    NSError *error = nil;
    NSString *fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    //取出每一行的数据
    NSArray *areasArray = [fileContents componentsSeparatedByString:@"\r\n"];
    
    for (NSString *area in areasArray) {
        if ([area containsString:self.item.provinceName]) {
            NSArray *parr = [area componentsSeparatedByString:@","];
            if (parr.count > 0) {
                self.item.provinceId = parr[0];
                WYLog(@"self.item.provinceId = %@",self.item.provinceId);
            }
            break;
        }
    }
    for (NSString *area in areasArray) {
        if ([area containsString:self.item.cityName]) {
            NSArray *carr = [area componentsSeparatedByString:@","];
            if (carr.count > 0) {
                self.item.cityId = carr[0];
                WYLog(@"self.item.cityId = %@",self.item.cityId);
            }
            break;
        }
    }
    for (NSString *area in areasArray) {
        if ([area containsString:self.item.areaName]) {
            NSArray *aarr = [area componentsSeparatedByString:@","];
            if (aarr.count > 0) {
                self.item.areaId = aarr[0];
                WYLog(@"self.item.areaId = %@",self.item.areaId);
            }
            break;
        }
    }

}

@end
