//
//  WYUtils.h
//  DianDian
//
//  Created by apple on 17/11/16.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYUtils : NSObject

/**
 *  @brief  判断应用是否处于后台
 */
+ (BOOL)runningInBackground;
/**
 *  @brief  判断应用是否处于前台
 */
+ (BOOL)runningInForeground;
/**     当前系统版本   */
+ (CGFloat)systemVersion;
/**     当前窗口的跟控制器   */
+ (UIViewController *_Nullable)rootViewController;
/**     获取当前控制器   */
+ (UIViewController *_Nullable)currentViewController;
/**     获取当前窗口   */
+ (UIWindow *_Nullable)currentWindow;

+ (void)showMessageAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message;

+ (void)showMessageAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message actionTitle:(NSString *_Nullable)actionTitle;

+ (void)showMessageAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message actionTitle:(NSString *_Nullable)actionTitle actionHandler:(void (^_Nullable)())actionHandler;

+ (void)showConfirmAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message yesTitle:(NSString *_Nullable)yesTitle yesAction:(void (^_Nullable)())yesAction;

+ (void)showConfirmAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message yesTitle:(NSString *_Nullable)yesTitle yesAction:(void (^_Nullable)())yesAction cancelTitle:(NSString *_Nullable)cancelTitle cancelAction:(void (^_Nullable)())cancelAction;

+ (void)showConfirmAlertWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message firstActionTitle:(NSString *_Nullable)firstActionTitle firstAction:(void (^_Nullable)())firstAction secondActionTitle:(NSString *_Nullable)secondActionTitle secondAction:(void (^_Nullable)())secondAction;


/**
 显示actionSheet
 
 @param title 标题
 @param message 简介
 @param actionTitle 按钮标题
 @param action 按钮事件
 */
+ (void)showActionSheetWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message actionTitle:(NSString *_Nullable)actionTitle action:(void (^ __nullable)())action;

+ (void)showActionSheetWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message firstActionTitle:(NSString *_Nullable)firstActionTitle firstAction:(void (^ _Nullable)())firstAction secondActionTitle:(NSString *_Nullable)secondActionTitle secondAction:(void (^ __nullable)())secondAction;

/**
 打印指定view的子控件
 
 @param view  想要知道的View
 @param level 层级，从 1 开始
 */
+ (void)getSubView:(UIView *_Nullable)view level:(int)level;

+ (CALayer *_Nullable)lineWithLength:(CGFloat)length atPoint:(CGPoint)point;

+ (CGFloat)screenScale;

/*
 view 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientview:(UIView *)view bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
/*
 control 是要设置渐变字体的控件   bgVIew是view的父视图  colors是渐变的组成颜色  startPoint是渐变开始点 endPoint结束点
 */
+(void)TextGradientControl:(UIControl *)control bgVIew:(UIView *)bgVIew gradientColors:(NSArray *)colors gradientStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
