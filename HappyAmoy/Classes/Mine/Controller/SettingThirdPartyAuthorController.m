//
//  SettingThirdPartyAuthorController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SettingThirdPartyAuthorController.h"
#import "SettingSwitchCell.h"
#import "ThirdPartyAuthorCell.h"
#import <AlibabaAuthSDK/ALBBSDK.h>

@interface SettingThirdPartyAuthorController () <UITableViewDelegate,UITableViewDataSource>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    类型数据源    */
@property (strong, nonatomic) NSArray *titleArray;
/**    内容数据源    */
@property (strong, nonatomic) NSArray *contentArray;
/**    图标数据源    */
@property (strong, nonatomic) NSArray *iconArray;

@end

static NSString *const authorCellId = @"authorCellId";

@implementation SettingThirdPartyAuthorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"第三方授权";
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
//    self.iconArray = @[@"微信授权",@"淘宝授权"];
//    self.titleArray = @[@"绑定微信",@"淘宝授权"];
//    if ([NSString isEmpty:[LoginUserDefault userDefault].userItem.wechatAccount]) {
//        self.contentArray = @[@"未绑定",@"未绑定"];
//    } else {
//        self.contentArray = @[@"已绑定"];
//        self.contentArray = @[@"已绑定",@"未绑定"];
//    }
    
    self.iconArray = @[@"淘宝授权"];
    self.titleArray = @[@"淘宝授权"];
    if ([NSString isEmpty:[LoginUserDefault userDefault].userItem.taobaoAccount]) {
        self.contentArray = @[@"未绑定"];
    } else {
        self.contentArray = @[@"已绑定"];
    }

    [self setupUI];
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
    [tableView registerClass:[ThirdPartyAuthorCell class] forCellReuseIdentifier:authorCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).offset(0);
    }];
}

#pragma mark - Button Action


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AUTOSIZESCALEX(45);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ThirdPartyAuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:authorCellId];
    
    cell.iconName = self.iconArray[indexPath.row];
    cell.title = self.titleArray[indexPath.row];
    cell.content = self.contentArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) { // 淘宝授权
        if (![NSString isEmpty:[LoginUserDefault userDefault].userItem.taobaoAccount]) {
            return;
        }
        ALBBSDK *albbSDK = [ALBBSDK sharedInstance];
        [albbSDK setAppkey:@"24894535"];
        [albbSDK setAuthOption:NormalAuth];
        [albbSDK auth:self successCallback:^(ALBBSession *session){
            ALBBUser *user = [session getUser];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"id"] = [LoginUserDefault userDefault].userItem.userId;
            parameters[@"taobaoAccount"] = user.nick;
            WeakSelf
            [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/edit" parameters:parameters successBlock:^(id response) {
                if ([response[@"code"] integerValue] == RequestSuccess) {
                    [LoginUserDefault userDefault].userItem.taobaoAccount = user.nick;
                    [WYProgress showSuccessWithStatus:@"绑定淘宝成功!"];
                    weakSelf.contentArray = @[@"已绑定"];
                    [weakSelf.tableView reloadData];
                } else {
                    [WYProgress showSuccessWithStatus:@"绑定淘宝失败!"];
                }
            } failureBlock:^(NSString *error) {

            }];
        } failureCallback:^(ALBBSession *session,NSError *error){
            WYLog(@"session == %@,error == %@",session,error);
        }];
    }

    
//    if (indexPath.row == 0) { // 绑定微信
//
//        [[WYUMShareMnager manager] thirdLoginWithPlatform:UMSocialPlatformType_WechatSession completion:^(UMSocialUserInfoResponse *result, NSError *error) {
//
//            if (!error) {
//
//                NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
//                parameters[@"id"] = [LoginUserDefault userDefault].userItem.userId;
//                parameters[@"wechatAccount"] = result.name;
//
//                WeakSelf
//                [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/edit" parameters:parameters successBlock:^(id response) {
//                    if ([response[@"code"] integerValue] == RequestSuccess) {
//                        [LoginUserDefault userDefault].userItem.wechatAccount = result.name;
//                        [WYProgress showSuccessWithStatus:@"绑定微信成功!"];
//                        weakSelf.contentArray = @[@"已绑定",@"未绑定"];
//                        [weakSelf.tableView reloadData];
//                    } else {
//                        [WYProgress showSuccessWithStatus:@"绑定失败!"];
//                    }
//                } failureBlock:^(NSString *error) {
//
//                }];
//            }
//
//            WYLog(@"name = %@ , iconurl = %@ , error = %@",result.name,result.originalResponse,error);
//        }];
//
//    }
}

#pragma mark - Private method

- (void)bindAccount {
    
}


@end
