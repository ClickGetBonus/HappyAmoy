//
//  WYProgress.h
//  ChikeCommerCial
//
//  Created by apple on 2018/2/26.
//  Copyright © 2018年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYProgress : UIView

+ (void)show;

+ (void)showWithStatus:(NSString *)status;

+ (void)showSuccessWithStatus:(NSString *)status;

+ (void)showSuccessWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay;

+ (void)showErrorWithStatus:(NSString *)status;

+ (void)showErrorWithStatus:(NSString *)status dismissWithDelay:(NSTimeInterval)delay;

+ (void)showProgress:(float)progress;

+ (void)showProgress:(float)progress status:(NSString*)status;

+ (void)dismiss;

@end
