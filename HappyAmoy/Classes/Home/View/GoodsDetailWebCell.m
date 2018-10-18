//
//  GoodsDetailWebCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsDetailWebCell.h"
#import <WebKit/WebKit.h>

@interface GoodsDetailWebCell() <WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate>

//@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIWebView *webView;

/**    标记是否已经加载完毕    */
@property (assign, nonatomic) BOOL finishLoad;

/**    label    */
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation GoodsDetailWebCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - Setter

- (void)setAttribute:(NSAttributedString *)attribute {
    _attribute = attribute;
    if (_attribute != nil) {
        self.contentLabel.attributedText = attribute;
    }
}






//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setupUI];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return self;
//}
//
//#pragma mark - UI
//
//- (void)setupUI {
//
////    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
//
//    // 自适应屏幕宽度js
//
////    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//
////    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//
//
//    // 添加自适应屏幕宽度js调用的方法
//
////    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.bounds configuration:wkWebConfig];
//
////    WKWebView *webView = [[WKWebView alloc] init];
//////    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baidu.com"]]];
////    webView.UIDelegate = self;
////
////    webView.navigationDelegate = self;
////    webView.scrollView.scrollEnabled = NO;
////    [self.contentView addSubview:webView];
////    self.webView = webView;
//
//    UIWebView *webView = [[UIWebView alloc] init];
//    //    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baidu.com"]]];
//    webView.delegate = self;
//    webView.scalesPageToFit = YES;
////    webView.navigationDelegate = self;
//    webView.scrollView.scrollEnabled = NO;
//    [self.contentView addSubview:webView];
//    self.webView = webView;
//
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.contentView);
////        make.height.mas_equalTo(2000);
//    }];
//
////    UILabel *contentLabel = [[UILabel alloc] init];
////    contentLabel.numberOfLines = 0;
////    contentLabel.font = [UIFont systemFontOfSize:13];
////    contentLabel.textAlignment = NSTextAlignmentCenter;
////    [self.contentView addSubview:contentLabel];
////    self.contentLabel = contentLabel;
////
////    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.left.right.bottom.equalTo(self.contentView);
////        //        make.height.mas_equalTo(2000);
////    }];
//}
//
//#pragma mark - Setter
//
//- (void)setContent:(NSString *)content {
//    _content = content;
//    if (![NSString isEmpty:_content]) {
//
////        if (self.finishLoad) {
////            return;
////        }
////        NSString * htmlString = [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\"></head><body>%@</body></html>", _content];
////
//////        WeakSelf
////
////        //因为一些网页上的图片在线显示不出来，我就先将html内容保存到本地 然后加载本地文件
////        //获取文件路径
////        //沙盒中文件
////        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////        NSString *filePath=[path stringByAppendingPathComponent:@"detail.html"];
////        //本地文件
////        //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"detail" ofType:@"html"];
////
////        //待写入的数据
////        //从服务器获取数据
////        //创建数据缓冲
////        NSMutableData *writer = [[NSMutableData alloc] init];
////        //将字符串添加到缓冲中
////        [writer appendData:[htmlString dataUsingEncoding:NSUTF8StringEncoding]];
////        //将缓冲的数据写入到文件中
////        [writer writeToFile:filePath atomically:YES];
////
////        //加载本地文件
////        NSURL *localUrl = [NSURL fileURLWithPath:filePath];
////        NSURLRequest *localRequest = [NSURLRequest requestWithURL:localUrl];
////        //打开网页
////        [self.webView loadRequest:localRequest];
//
//
////        NSString *content1 = [content stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
////        content1 = [content1 stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
////        content1 = [content1 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
////        content1 = [content1 stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//
//        NSString *content1 = [self htmlEntityDecode:_content];
//
//        NSString *htmls = [NSString stringWithFormat:@"<html> \n"
//                           "<head> \n"
//                           "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
//                           "<style type=\"text/css\"> \n"
//                           "body {font-size:15px;}\n"
//                           "</style> \n"
//                           "</head> \n"
//                           "<body>"
//                           "<script type='text/javascript'>"
//                           "window.onload = function(){\n"
//                           "var $img = document.getElementsByTagName('img');\n"
//                           "for(var p in  $img){\n"
//                           " $img[p].style.width = '100%%';\n"
//                           "$img[p].style.height ='auto'\n"
//                           "}\n"
//                           "}"
//                           "</script>%@"
//                           "</body>"
//                           "</html>",content1];
//
//
//
////        //因为一些网页上的图片在线显示不出来，我就先将html内容保存到本地 然后加载本地文件
////        //获取文件路径
////        //沙盒中文件
////        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
////        NSString *filePath=[path stringByAppendingPathComponent:@"detail.html"];
////        //本地文件
////        //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"detail" ofType:@"html"];
////
////        //创建数据缓冲
////        NSMutableData *writer = [[NSMutableData alloc] init];
////        //将字符串添加到缓冲中
////        [writer appendData:[htmls dataUsingEncoding:NSUTF8StringEncoding]];
////        //将缓冲的数据写入到文件中
////        [writer writeToFile:filePath atomically:YES];
////
////        //加载本地文件
////        NSURL *localUrl = [NSURL fileURLWithPath:filePath];
////        NSURLRequest *localRequest = [NSURLRequest requestWithURL:localUrl];
//        //打开网页
////        [self.webView loadRequest:localRequest];
//
//        [self.webView loadHTMLString:htmls baseURL:nil];
//
////        [self.webView loadHTMLString:htmls baseURL:[NSURL URLWithString:@"http://112.74.200.84/api"]];
//
////        [self.webView loadHTMLString:_content baseURL:nil];
//    }
//}
//
//- (void)setAttribute:(NSAttributedString *)attribute {
//    _attribute = attribute;
//    if (_attribute != nil) {
//        self.contentLabel.attributedText = attribute;
//    }
//}
//
//#pragma mark - WKNavigationDelegate
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
////    WeakSelf
////    if (!self.finishLoad) {
////        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.top.left.right.bottom.equalTo(self.contentView);
////            make.height.mas_equalTo(webView.scrollView.contentSize.height);
////        }];
////        [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
//////            make.top.left.right.bottom.equalTo(self.contentView);
////            make.height.mas_equalTo(webView.scrollView.contentSize.height);
////        }];
////        WYLog(@"self.webView = %@",self.webView);
////        self.finishLoad = YES;
////        if (self.loadFinish) {
////            weakSelf.loadFinish();
////        }
////    }
//}
//
//- (NSString *)htmlEntityDecode:(NSString *)string
//{
//    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
//    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
//    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
//    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
//
//    return string;
//}
//
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    self.finishLoad = YES;
//    WYLog(@"加载完成");
//    NSString *script = [NSString stringWithFormat:
//                        @"var script = document.createElement('script');"
//                        "script.type = 'text/javascript';"
//                        "script.text = \"function ResizeImages() { "
//                        "var img;"
//                        "var maxwidth=%f;"
//                        "for(i=0;i <document.images.length;i++){"
//                        "img = document.images[i];"
//                        "if(img.width > maxwidth){"
//                        "img.width = maxwidth;"
//                        "}"
//                        "}"
//                        "}\";"
//                        "document.getElementsByTagName('head')[0].appendChild(script);", SCREEN_WIDTH - 20];
//    [webView stringByEvaluatingJavaScriptFromString: script];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
//
//}

@end
