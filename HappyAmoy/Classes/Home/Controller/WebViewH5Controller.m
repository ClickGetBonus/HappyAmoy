//
//  WebViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WebViewH5Controller.h"
#import "WebViewJavascriptBridge.h"



@interface WebViewH5Controller () <UIWebViewDelegate>

/**    加载html    */
@property (strong, nonatomic) UIWebView *webView;
@property WebViewJavascriptBridge *bridge;

@end

@implementation WebViewH5Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [WYProgress show];
    
    [self setupWeb];
    
}

#pragma mark - Web

- (void)setupWeb {
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView * view = [[UIWebView alloc] initWithFrame:self.view.frame];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    web.backgroundColor = self.view.backgroundColor;
    web.scalesPageToFit = YES;
    web.delegate = self;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.view addSubview:web];
    
    // 开启日志
    [WebViewJavascriptBridge enableLogging];
    
    // 给哪个webview建立JS与OjbC的沟通桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:web];
    [self.bridge setWebViewDelegate:self];
    
    // JS主动调用OjbC的方法
    // 这是JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
    // JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
    // OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
    [self.bridge registerHandler:@"back" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call back, data from js is %@", data);
       
        [self.navigationController popViewControllerAnimated:YES];
        
        
        if (responseCallback) {
            // 反馈给JS
//            responseCallback(@{@"userId": @"123456"});
        }
    }];
    [self.bridge registerHandler:@"download" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call back, data from js is %@", data);
        
        NSString *urlstr;
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstr]];
        
        
        if (responseCallback) {
            // 反馈给JS
            //            responseCallback(@{@"userId": @"123456"});
        }
    }];

    
    self.webView = web;

}


//在页面出现的时候就将黑线隐藏起来
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
//在页面消失的时候就让navigationbar还原样式
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
}



@end
