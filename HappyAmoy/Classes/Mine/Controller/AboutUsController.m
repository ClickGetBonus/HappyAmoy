//
//  AboutUsController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AboutUsController.h"

@interface AboutUsController () <UIWebViewDelegate>

/**    加载html    */
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"关于我们";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;

    [self setupWeb];
    // 获取数据
    [self getData];
    
    [WYProgress show];

//    [self setupUI];
}

#pragma mark - UI

//- (void)setupUI {
//
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"appIcon_small")];
//    [self.view addSubview:imageView];
//
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(50));
//        make.centerX.equalTo(self.view).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(AUTOSIZESCALEX(100));
//        make.height.mas_equalTo(AUTOSIZESCALEX(100));
//    }];
//
//    UILabel *descLabel = [[UILabel alloc] init];
//    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"省惠优选是一款淘宝天猫购物返利APP，在省惠优选淘尽淘宝百万商品，优惠券优惠力度最高达商品的百分之九十。推荐好友成为省惠优选会员，更可以获得丰厚的福利。"];
//    attribute.yy_lineSpacing = AUTOSIZESCALEX(3);
////    descLabel.text = @"省惠优选是一款淘宝天猫购物返利APP，在省惠优选淘尽淘宝百万商品，优惠券优惠力度最高达商品的百分之九十。推荐好友成为省惠优选会员，更可以获得丰厚的福利。";
//    descLabel.attributedText = attribute;
//    descLabel.textColor = QHBlackColor;
//    descLabel.numberOfLines = 0;
//    descLabel.font = TextFont(15);
//    [self.view addSubview:descLabel];
//
//    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(10));
//        make.centerY.equalTo(self.view).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-10));
//    }];
//}

#pragma mark - Web

- (void)setupWeb {
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:self.view.bounds];
    web.backgroundColor = self.view.backgroundColor;
    web.scalesPageToFit = YES;
    web.delegate = self;
    [self.view addSubview:web];
    self.webView = web;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, SeparatorLineHeight)];
    line.backgroundColor = SeparatorLineColor;
    [self.view addSubview:line];
    
}

#pragma mark - Data

- (void)getData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/aboutus" parameters:parameters successBlock:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == RequestSuccess) {
            NSString *html = [response objectForKey:@"data"];
            [self.webView loadHTMLString:html baseURL:nil];
        }
    } failureBlock:^(NSString *error) {
        
    } shouldDismissHud:NO];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [WYProgress dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [WYProgress dismiss];
}


@end
