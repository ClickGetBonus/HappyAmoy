//
//  WYUtils.m
//  DianDian
//
//  Created by apple on 17/11/16.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "WYUtils.h"

@implementation WYUtils

/**
 *  @brief  判断应用是否处于后台
 */
+ (BOOL)runningInBackground {
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
   
    BOOL result = (state == UIApplicationStateBackground);
    
    return result;
}
/**
 *  @brief  判断应用是否处于前台
 */
+ (BOOL)runningInForeground {
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    
    BOOL result = (state == UIApplicationStateActive);
    
    return result;
}
/**
 *  @brief  获取当前控制器
 */
+ (UIViewController *)currentViewController {
    UIViewController *vc = [self rootViewController];
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        } else {
            break;
        }
    }
    return vc;
}

/**
 显示弹框

 @param title   弹框标题
 @param message 弹框内容
 */
+ (void)showMessageAlertWithTitle:(NSString *)title message:(NSString *)message {
    [self showMessageAlertWithTitle:title message:message actionTitle:@"确定" actionHandler:nil];
}

+ (void)showMessageAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle {
    [self showMessageAlertWithTitle:title message:message actionTitle:actionTitle actionHandler:nil];
}

+ (void)showMessageAlertWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle actionHandler:(void (^ __nullable)())actionHandler {
    //IOS8.0及以后，采用UIAlertController
    if ([self systemVersion] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action;
        if (actionHandler) {
            action = [UIAlertAction actionWithTitle:actionTitle
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action){
                                                actionHandler();
                                            }];
        }else {
            action = [UIAlertAction actionWithTitle:actionTitle
                                              style:UIAlertActionStyleDefault
                                            handler:nil];
        }
        
        [alertController addAction:action];
        
        [[self currentViewController] presentViewController:alertController animated:YES completion:nil];
        
    }
}

+ (void)showConfirmAlertWithTitle:(NSString *)title message:(NSString *)message yesTitle:(NSString *)yesTitle yesAction:(void (^ __nullable)())yesAction {
    [self showConfirmAlertWithTitle:title message:message yesTitle:yesTitle yesAction:yesAction cancelTitle:@"取消" cancelAction:nil];
}

+ (void)showConfirmAlertWithTitle:(NSString *)title message:(NSString *)message yesTitle:(NSString *)yesTitle yesAction:(void (^ __nullable)())yesAction cancelTitle:(NSString *)cancelTitle cancelAction:(void (^ __nullable)())cancelAction {
    [self showConfirmAlertWithTitle:title message:message firstActionTitle:cancelTitle firstAction:cancelAction secondActionTitle:yesTitle secondAction:yesAction];
}

+ (void)showConfirmAlertWithTitle:(NSString *)title message:(NSString *)message firstActionTitle:(NSString *)firstActionTitle firstAction:(void (^ __nullable)())firstAction secondActionTitle:(NSString *)secondActionTitle secondAction:(void (^ __nullable)())secondAction {
    //IOS8.0及以后，采用UIAlertController
    if ([self systemVersion] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:firstActionTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                           if (firstAction)
                                                               firstAction();
                                                       }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:secondActionTitle
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            if (secondAction)
                                                                secondAction();
                                                        }];
        
        [alertController addAction:action];
        [alertController addAction:action2];

        [[self currentViewController] presentViewController:alertController animated:YES completion:nil];
        
    }
}

/**
 显示actionSheet

 @param title 标题
 @param message 简介
 @param actionTitle 按钮标题
 @param action 按钮事件
 */
+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle action:(void (^ __nullable)())action{
    
    [self showActionSheetWithTitle:title message:message firstActionTitle:actionTitle firstAction:action secondActionTitle:nil secondAction:nil];
}

+ (void)showActionSheetWithTitle:(NSString *)title message:(NSString *)message firstActionTitle:(NSString *)firstActionTitle firstAction:(void (^ __nullable)())firstAction secondActionTitle:(NSString *)secondActionTitle secondAction:(void (^ __nullable)())secondAction {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:firstActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (firstAction)
            firstAction();
    }];
    
    [alertController addAction:action];
    
    if (![NSString isEmpty:secondActionTitle]) {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:secondActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (secondAction)
                secondAction();
        }];
        
        [alertController addAction:action1];
    }
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:action2];
    
    [[self currentViewController] presentViewController:alertController animated:YES completion:nil];
}

/**
 *  @brief  获取当前系统版本
 */
+ (CGFloat)systemVersion {
    static CGFloat _version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _version = [[UIDevice currentDevice].systemVersion floatValue];
    });
    return _version;
}
/**
 *  @brief  获取根控制器
 */
+ (UIViewController *)rootViewController {
    return [UIApplication sharedApplication].delegate.window.rootViewController;
}
/**
 *  @brief  获取当前窗口
 */
+ (UIWindow *)currentWindow {
    return [UIApplication sharedApplication].delegate.window;
}

// 递归获取子视图

/**
 打印指定view的子控件

 @param view  想要知道的View
 @param level 层级，从 1 开始
 */
+ (void)getSubView:(UIView *)view level:(int)level {
    NSArray *subviews = [view subviews];
    
    // 如果没有子视图就直接返回
    if ([subviews count] == 0) return;
    
    for (UIView *subview in subviews) {
        
        // 根据层级决定前面空格个数，来缩进显示
        NSString *blank = @"";
        for (int i = 1; i < level; i++) {
            blank = [NSString stringWithFormat:@"  %@", blank];
        }
        
        // 打印子视图类名
        WYLog(@"%@%d: %@", blank, level, subview);
        
        // 递归获取此视图的子视图
        [self getSubView:subview level:(level+1)];
        
    }
}


+ (CALayer *)lineWithLength:(CGFloat)length atPoint:(CGPoint)point {
    CALayer *line = [CALayer layer];
    line.backgroundColor = RGB(221, 221, 221).CGColor;
    
    line.frame = CGRectMake(point.x, point.y, length, 1/[self screenScale]);
    
    return line;
}

+ (CGFloat)screenScale {
    
    return [UIScreen mainScreen].scale;
}

/*
 view 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientview:(UIView *)view bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    
    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = view.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = view.layer;
    view.frame = gradientLayer1.bounds;
}

/*
 control 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientControl:(UIControl *)control bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    
    CAGradientLayer* gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = control.frame;
    gradientLayer1.colors = colors;
    gradientLayer1.startPoint =startPoint;
    gradientLayer1.endPoint = endPoint;
    [bgVIew.layer addSublayer:gradientLayer1];
    gradientLayer1.mask = control.layer;
    control.frame = gradientLayer1.bounds;
}



@end
