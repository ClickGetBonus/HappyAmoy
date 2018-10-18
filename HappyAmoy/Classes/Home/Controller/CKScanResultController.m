//
//  CKScanResultController.m
//  ChikeCommerCial
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 LL. All rights reserved.
//

#import "CKScanResultController.h"

@interface CKScanResultController () <UIWebViewDelegate>

/**    加载二维码链接    */
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation CKScanResultController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"扫一扫";
    
    [self loadQRCodeLink];
    
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"返回"] highlightImage:[UIImage imageNamed:@"返回"] buttonSize:CGSizeMake(35, 35) target:self action:@selector(backClick) imageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [WYProgress dismiss];
}

#pragma mark - 加载二维码链接

- (void)loadQRCodeLink {
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.scanResult]]];
    webView.delegate = self;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
}

#pragma mark - 返回按钮的点击
- (void)backClick {
    
    [self.navigationController popViewControllerAnimated:YES];
 
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [WYProgress show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [WYProgress dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
   
    [WYProgress dismiss];
    
    WeakSelf
    
    [WYUtils showMessageAlertWithTitle:@"结果" message:self.scanResult actionTitle:@"确定" actionHandler:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
