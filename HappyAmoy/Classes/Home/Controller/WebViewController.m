//
//  WebViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate>

/**    加载html    */
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [WYProgress show];
    
    [self setupWeb];
    
}

#pragma mark - Web

- (void)setupWeb {
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight)];
    web.backgroundColor = self.view.backgroundColor;
    web.scalesPageToFit = YES;
    web.delegate = self;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self.view addSubview:web];
    self.webView = web;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, SeparatorLineHeight)];
    line.backgroundColor = SeparatorLineColor;
    [self.view addSubview:line];
    
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
