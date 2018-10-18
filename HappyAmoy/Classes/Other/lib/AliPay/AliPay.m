//
//  AliPay.m
//  ChiKe
//
//  Created by 刘俊臣 on 2018/1/16.
//  Copyright © 2018年 你亲爱的爸爸. All rights reserved.
//

#import "AliPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "APRSASigner.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "WYProgress.h"

@implementation AliPay

+ (instancetype)share{
    static AliPay *py = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        py = [AliPay new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPay:) name:@"AliPayResult" object:nil];
    });
    return py;
}

+ (void)onPay:(NSNotification *)noti {
    NSDictionary *resultDic = noti.userInfo;
    NSInteger code = [resultDic[@"resultStatus"] integerValue];
    if (code == 9000) {
//        [SVProgressHUD showSuccessWithStatus:@"支付成功"];
        [WYProgress showSuccessWithStatus:@"支付成功"];
    } else {
//        [SVProgressHUD showErrorWithStatus:@"支付失败"];
        [WYProgress showErrorWithStatus:@"支付失败"];

    }
}

+ (void)payWithOrder:(NSString *)orderKey amount:(float)amount title:(NSString *)title completation:(void (^)(NSDictionary *, NSInteger, NSString *))comp {
    [self share];
    // 重要说明
    // 这里只是为了方便直接向商户展示支付宝的整个支付流程；所以Demo中加签过程直接放在客户端完成；
    // 真实App里，privateKey等数据严禁放在客户端，加签过程务必要放在服务端完成；
    // 防止商户私密数据泄露，造成不必要的资金损失，及面临各种安全风险；
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *appID = @"2018082361162175";
    
    // 如下私钥，rsa2PrivateKey 或者 rsaPrivateKey 只需要填入一个
    // 如果商户两个都设置了，优先使用 rsa2PrivateKey
    // rsa2PrivateKey 可以保证商户交易在更加安全的环境下进行，建议使用 rsa2PrivateKey
    // 获取 rsa2PrivateKey，建议使用支付宝提供的公私钥生成工具生成，
    // 工具地址：https://doc.open.alipay.com/docs/doc.htm?treeId=291&articleId=106097&docType=1
    NSString *rsa2PrivateKey = @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCwpu1q0DNxm5EoP32Qax24yepLb3VlBdoReU2vlp+1gzuf5wGylRMZfSs/W5Xv+T4YdlsyfEtAz1gRJhL7sC452sVRZEk3/NAQRgCq/nXhFLgwEFjZi2SVbajBU/9pSGO6nsGHRp3heAN/WA253fddRP3l4gCZAibtB/89LFAeltmWWafrXA6Pbabc5LRn37/hnbWdLUgJ4B7fnhPu2pzOWkcyW6Up9206QFJt19Tk6xn7MELpug6SELPPPiETr76LCP+y/7ULU/oEUPxRkyLPwtMpqVgxDSkJifnB0o34cTHy5WPABddyOXCa9a/NaALFiRBzOBxXJqqHROWGWlyLAgMBAAECggEAVglHEsHKfGeHQDIEBsWU2T5GRW1IoOZDukT5SC61JGOBM7UAB6lBfyWOXbJOiW08CBAFBMaypCMYQmnnzvuU2AqsFaMhYgpYj8R4aM+8O96qgoZDr9iLKZgaG+a8O9vM7sSJf0gudvTLx0bskH0CEEQc4My8+8inisRdVL7zWqHQXizVz2lKHaP2zbrLJgd9rdLBDsOG4HFD8JSdQOvY2a7scxpKhVmZ2Su1be+zqCQlzvG8JjNKCuwrLXZaBEbZaZkNKFcDnIoDWL3NeD1VkRUN3Nu/U6vlHKTUAxHBHec8B2jHk32UoES9eQWBfLuYuy4joHzmpmOsvbMj0CEC8QKBgQDhsnrT5opfu4XMxNPt1maYiDXza697AIcOHeQicAGQ984ILmw/3FBZJlxg6KMytMj9wdTrTbi6Ouw6bsDtQjeDiJIOb75iSl/jfjwWoAAmcPvDkyTx50CTcj8aw1h12laWa55jiF+yuTveNAxsZsKn5iQs8wsdgWeoMF7t+HQbMwKBgQDIXrMgLXkicvCIy29NzMtXDzrm5/bxQ7PWDrFWwWpgPU5FsCQfy1RteUtssOITaXCa99e2WIC40zcADoiMG9OyTtqxYLyGA9qTicUPvFjVCQspZeKc0KBtIdwU1czCCdeCnsdC+ehPXBiwyvbxHFpq5iPkyXP5WMNfAtKLtg75SQKBgEI21ZgzS6dYYaG4oSBmxUS8uW9HyXzBo929YT/FMoBwYw69Z964aQ4ule2Mcsyeg1UHN8ssyyQ/wyxFb+5rfdPmDkuT9vvpLAaW81QD7udYQFSZZ75chPJ9EwxsARjaTIrm2doDmWfatjizdm2bHEKb30McrsciPuH2BvOz74RHAoGASZGz1Wm843Aubxu692btdj7KUsPzAKzqF/t3E7Kam1GHLsE40k+25Sc3EWZ068m4Jb5AftxKDxLGTAgKDN+ewAaB98TcE5zQoYFhUKDIQRg79+xH42oarVdUVnYV41z3uycPZMEbkh/vlOJA/1B4xm1P2o45PeFggr8njVLAdrkCgYEAvw1ki6LZf0r9NLybvgF38esluJQbkFt2iz0WGBOtIzKiKZCDwZeE8h08aEMiumGC8kjv35OCrB6dCpT0Xqdzi07yWhoLuvN4zX7BNgaaED0Aj1VzKTu3heDigviIGCL/kyT7tboKz4WGYE022BU5IvEDPMkX5L9krqQZUFkc89A=";
    NSString *rsaPrivateKey = @"";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    APOrderInfo* order = [APOrderInfo new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    order.notify_url = @"http://haomaiapi.lucius.cn/api/callback/alipay";
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = (rsa2PrivateKey.length > 1)?@"RSA2":@"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [APBizContent new];
    order.biz_content.body = @"支付";
    order.biz_content.subject = title;
    order.biz_content.out_trade_no = orderKey; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", amount]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    WYLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    APRSASigner* signer = [[APRSASigner alloc] initWithPrivateKey:((rsa2PrivateKey.length > 1)?rsa2PrivateKey:rsaPrivateKey)];
    if ((rsa2PrivateKey.length > 1)) {
        signedString = [signer signString:orderInfo withRSA2:YES];
    } else {
        signedString = [signer signString:orderInfo withRSA2:NO];
    }
    
    // NOTE: 如果加签成功，则继续执行支付
    if (signedString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
        NSString *appScheme = @"haomai";
        
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
        
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            WYLog(@"reslut = %@",resultDic);
            comp(resultDic, [resultDic[@"resultStatus"] integerValue] , @"");
        }];
    }
}
@end
