//
//  WYProgress.m
//  ChikeCommerCial
//
//  Created by apple on 2018/2/26.
//  Copyright © 2018年 LL. All rights reserved.
//

#import "WYProgress.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation WYProgress

+ (void)show {
    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

+ (void)showWithStatus:(NSString *)status {
    [SVProgressHUD showWithStatus:status];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
}

+ (void)showSuccessWithStatus:(NSString *)status {
    [self showSuccessWithStatus:status dismissWithDelay:1.5f];
}

+ (void)showSuccessWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay {
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    if (delay != 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

+ (void)showErrorWithStatus:(NSString *)status {
    [self showErrorWithStatus:status dismissWithDelay:1.5f];
}

+ (void)showErrorWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay {
    [SVProgressHUD showErrorWithStatus:status];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    if (delay != 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
}

+ (void)showProgress:(float)progress {
    [SVProgressHUD showProgress:progress];
}

+ (void)showProgress:(float)progress status:(NSString*)status {
    [SVProgressHUD showProgress:progress status:status];
}

+ (void)dismiss {
    [SVProgressHUD dismiss];
}

@end
