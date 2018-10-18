//
//  PutForwardController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PutForwardController.h"
#import "PutForwardView.h"
#import "BinaryAccountController.h"
#import "CheckProtocolController.h"

@interface PutForwardController () <PutForwardViewDelegate>

/**    提现    */
@property (strong, nonatomic) PutForwardView *putForwardView;

@end

@implementation PutForwardController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"提现";

    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    PutForwardView *putForwardView = [[PutForwardView alloc] init];
    putForwardView.delegate = self;
    [self.view addSubview:putForwardView];
    self.putForwardView = putForwardView;
    
    [self.putForwardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(5));
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
}

#pragma mark - Button Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - PutForwardViewDelegate

// 选择提现账号
- (void)putForwardView:(PutForwardView *)putForwardView changeAccount:(NSString *)account {
    BinaryAccountController *binaryAccountVc = [[BinaryAccountController alloc] init];
    [self.navigationController pushViewController:binaryAccountVc animated:YES];
}

// 提现须知
- (void)putForwardView:(PutForwardView *)putForwardView checkProtocol:(NSString *)protocol {
    CheckProtocolController *protocolVc = [[CheckProtocolController alloc] init];
    protocolVc.title = @"提现须知";
    protocolVc.isPutForward = YES;
    [self.navigationController pushViewController:protocolVc animated:YES];
}

// 确认提现
- (void)putForwardView:(PutForwardView *)putForwardView confirmPutForward:(NSString *)money {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"money"] = money;
    WeakSelf
    [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/fetch" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [WYProgress showSuccessWithStatus:@"提现成功!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:WalletDidChangeNotificationName object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
    
}


@end
