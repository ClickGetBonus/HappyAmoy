//
//  WYNavigationController.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "WYNavigationController.h"
#import "FriendMessageController.h"
#import "SystemMeaageController.h"
#import "MessageNoticeController.h"
#import "ReceiptAddressController.h"

@interface WYNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation WYNavigationController

+ (void)load {
    
    UINavigationBar *navBar;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        navBar = [UINavigationBar appearanceWhenContainedIn:self,nil];
    } else {
        navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    }
    // 通过富文本设置标题大小
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = TextFont(16);
    dict[NSForegroundColorAttributeName] = QHWhiteColor;
    
    [navBar setTitleTextAttributes:dict];
    
    [navBar setBarTintColor:QHMainColor];

    // 设置导航条背景图片
//    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    
    // 去除导航栏底部黑线
//    [navBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     直接设置代理为自己只能解决边缘滑动返回不了的问题，但是最好的效果的是可以全屏滑动返回，所以使用下面的方法
//    self.interactivePopGestureRecognizer.delegate = self;
    
//     自定义手势替换系统的边缘手势滑动返回，达到全屏滑动返回的效果
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    // 控制手势什么时候触发，只有非根控制器才能触发手势
    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
    // 禁止系统的边缘手势返回
    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UISlider class]] || [touch.view isKindOfClass:[UIButton class]]) { // 如果滑动的是UISlider或者UIButton，则不响应滑动返回手势
        return NO;
    }
    
    for (UIViewController *controller in self.childViewControllers) {
        if ([controller isKindOfClass:[MessageNoticeController class]] || [controller isKindOfClass:[ReceiptAddressController class]]) { // 左滑界面的禁用手势返回
            return NO;
        }
    }
    // 只有非根控制器才有手势返回的功能，否则会造成程序假死
    return self.childViewControllers.count > 1;
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) { // 排除根控制器
        
        // push的时候隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
        
//        // 统一设置返回按钮，非根控制器
//        viewController.navigationItem.leftBarButtonItem =  [UIBarButtonItem barButtonItemWithImage:[UIImage imageNamed:@"返回"] highlightImage:[UIImage imageNamed:@"返回"] buttonSize:CGSizeMake(30, 30) target:self action:@selector(backClick) imageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//
//        [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateHighlighted];
//        button.imageEdgeInsets = imageEdgeInsets;
//        button.size = buttonSize;
//        [button addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
//
//        UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageOriginalWithNamed:@"返回_白色"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 返回按钮的点击
- (void)backClick {
    
    [self popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
