//
//  WebViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "WebViewH5Controller.h"
#import "WebViewJavascriptBridge.h"
#import "WYPhotoLibraryManager.h"


@interface WebViewH5Controller () <UIWebViewDelegate>

/**    加载html    */
@property (strong, nonatomic) UIWebView *webView;
@property WebViewJavascriptBridge *bridge;

@property (copy, nonatomic) NSString *wxOrderNum;

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
    
    WeakSelf
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
    
    //复制文本
    [self.bridge registerHandler:@"copyword" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = (NSString *)data[@"data"];
        [WYHud showMessage:@"已复制到剪贴板!"];
        WYLog(@"复制的内容 = %@",(NSString *)data);
    }];
    
    //保存图片
    [self.bridge registerHandler:@"saveimg" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSString *imgString = data[@"data"];
        NSString *base64String = [imgString substringFromIndex:[imgString rangeOfString:@"base64"].location+7];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:base64String
                                                                options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        UIImage *image = [UIImage imageWithData:imageData];
        [WYPhotoLibraryManager wy_savePhotoImage:image completion:^(UIImage *image, NSError *error) {
            if (!error) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [WYProgress showSuccessWithStatus:@"保存图片成功!"];
                });
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [WYProgress showSuccessWithStatus:@"保存图片失败!"];
                });
            }
        }];
    }];
    
    
    //分享图片
    [self.bridge registerHandler:@"shareimg" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSInteger type = [data[@"type"] integerValue]; //0微信 1朋友圈
        
        NSString *imgString = data[@"data"];
        NSString *base64String = [imgString substringFromIndex:[imgString rangeOfString:@"base64"].location+7];
        NSData *imgData = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
        UIImage *image = [[UIImage alloc] initWithData:imgData];
        
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        // 图片或图文分享
        UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"" descr:@"" thumImage:image];
        shareObject.shareImage = image;
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:type ==0 ? UMSocialPlatformType_WechatSession : UMSocialPlatformType_WechatTimeLine
                                            messageObject:messageObject
                                    currentViewController:self completion:^(id result, NSError *error) {
                                        
                                        if (!error) {
                                            //                                            UMSocialShareResponse *response = result;
                                            [WYProgress showSuccessWithStatus:@"分享成功!"];
                                        } else {
                                            [WYProgress showSuccessWithStatus:@"分享时遇到问题!"];
                                        }
                                    }];
    }];
    
    
    //分享文本
    [self.bridge registerHandler:@"shareword" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSInteger type = [data[@"type"] integerValue]; //0微信 1朋友圈
        NSString *word = data[@"data"];
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        messageObject.text = word;
        
        [[UMSocialManager defaultManager] shareToPlatform:type ==0 ? UMSocialPlatformType_WechatSession : UMSocialPlatformType_WechatTimeLine
                                            messageObject:messageObject
                                    currentViewController:self
                                               completion:^(id result, NSError *error) {
                                                   
                                                   if (!error) {
                                                       [WYProgress showSuccessWithStatus:@"分享成功!"];
                                                   } else {
                                                       [WYProgress showSuccessWithStatus:@"分享时遇到问题"];
                                                   }
                                               }];
    }];
    
    
    //支付宝支付
    [self.bridge registerHandler:@"aliPay" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"%@",data);
        NSString *orderNum = data[@"order_no"];
        float orderAmout = [data[@"order_amount"] floatValue];
        
        [AliPay payWithOrder:orderNum
                      amount:orderAmout
                       title:[NSString stringWithFormat:@"订单支付:%@",orderNum]
                completation:^(NSDictionary *resultDic, NSInteger code, NSString *msg) {
                    WYLog(@"msg = %@",msg);
                    /**
                     resultStatus结果码含义
                     返回码     含义
                     9000     订单支付成功
                     8000     正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                     4000     订单支付失败
                     5000     重复请求
                     6001     用户中途取消
                     6002     网络连接出错
                     6004     支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                     其它     其它支付错误
                     */
                    NSString *status = @"";
                    switch (code) {
                        case 9000:
                        {
                            status = @"支付成功";
                            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://haomaimall.lucius.cn/center/pay/payres/?c_o_no=%@",orderNum]];
                            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:url]];
                        }
                            break;
                        case 6001:
                            status = @"支付已取消";
                            break;
                        case 4000:
                            status = @"支付失败";
                            break;
                        default:
                            status = @"网络连接出错";
                            break;
                    }
                    
                    [WYProgress showSuccessWithStatus:status];
                }];
        
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxPaySuccess) name:PaySuccessNotificationName object:nil];
    
    //微信支付
    [self.bridge registerHandler:@"weixinPay" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSLog(@"%@",data);
        NSString *orderNum = data[@"order_no"];
        float orderAmout = [data[@"order_amount"] floatValue];
        weakSelf.wxOrderNum = orderNum;
        
        [MXWechatPayHandler payWithOrder:orderNum
                                  amount:orderAmout
                                   title:[NSString stringWithFormat:@"订单支付:%@",orderNum]
                            completation:^(BOOL resp) {
                                
                                
                            }];
    }];
    
    
    
    //    // 微信支付
    //    - (void)wxPayWithOrder:(NSString *)order amount:(CGFloat)amount {
    //
    //        [MXWechatPayHandler payWithOrder:order amount:amount title:@"赞助好麦" completation:^(BOOL resp) {
    //
    //        }];
    //    }
    //
    //    // 支付宝支付
    //    - (void)aliPayWithOrder:(NSString *)order amount:(CGFloat)amount {
    //        WeakSelf
    //        [AliPay payWithOrder:order amount:amount title:@"赞助好麦" completation:^(NSDictionary *resultDic, NSInteger code, NSString *msg) {
    //            WYLog(@"msg = %@",msg);
    //            if (code == 9000) { // 支付成功
    //                [weakSelf paySuccess];
    //            }
    //        }];
    //    }
    
    
    
    
    self.webView = web;
    
}


- (void)wxPaySuccess {
    
    if (self.wxOrderNum && self.wxOrderNum.length>0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://haomaimall.lucius.cn/center/pay/payres/?c_o_no=%@",self.wxOrderNum]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
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
