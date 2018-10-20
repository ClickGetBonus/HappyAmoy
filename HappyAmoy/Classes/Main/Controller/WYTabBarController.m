//
//  WYTabBarController.m
//  DianDian
//
//  Created by apple on 17/10/9.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "WYTabBarController.h"
#import "WYNavigationController.h"
#import "HomeViewController.h"
#import "SpecialSessionViewController.h"
#import "ShowViewController.h"
#import "MineViewController.h"
#import "SeachTicketController.h"
#import "DiscoveryController.h"
#import "ClassifyController.h"
#import "NewHomeViewController.h"
#import "BrandSelectionController.h"
#import "PastePopupView.h"

@interface WYTabBarController ()

/**    上一次点击的tabBarButton    */
@property (strong, nonatomic) UITabBarItem *previousTabBarItem;

@end

@implementation WYTabBarController

+ (void)load {
    
    // 获取指定类的UITabBarItem
    
    UITabBarItem *tabbarItem;
    if ([[UIDevice currentDevice].systemVersion floatValue] < 9.0) {
        tabbarItem = [UITabBarItem appearanceWhenContainedIn:self,nil];
    } else {
        tabbarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    }
    
    // 创建一个描述颜色属性的字典
    NSMutableDictionary *selectedDict = [[NSMutableDictionary alloc] init];
    selectedDict[NSForegroundColorAttributeName] = QHBlackColor;

    [tabbarItem setTitleTextAttributes:selectedDict forState:UIControlStateSelected];
    
    // 设置字体大小：只有设置正常状态下的字体，才会生效
    // 创建一个描述字体大小属性的字典
    NSMutableDictionary *normalDict = [[NSMutableDictionary alloc] init];
    normalDict[NSFontAttributeName] = TextFont(12);
    normalDict[NSForegroundColorAttributeName] = ColorWithHexString(@"#999999");

    [tabbarItem setTitleTextAttributes:normalDict forState:UIControlStateNormal];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置子控制器
    [self setupAllChildControllers];
    
    // 设置对应的tabarItem
    [self setupAllTabbarItem];

    // 设置tabbar顶部黑线
    [self setupTabbarShadowImage];
    
    [self checkPasteBoard];
}


#pragma mark - 检查粘贴板的内容是否需要显示弹窗
- (void)checkPasteBoard {
    
    
    
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSString *pasteString = board.string;
    
    if (!pasteString || pasteString.length<=0) {
        return;
    }
    
    [[NetworkSingleton sharedManager] getCoRequestWithUrl:@"/ClipboardSearch"
                                               parameters:@{@"keyword" : pasteString}
                                             successBlock:^(id response) {
                                                 
                                                 if ([response[@"code"] integerValue] == 1) {
                                                     
                                                     NSInteger status = [response[@"data"][@"status"] integerValue];
                                                     if (status == -1) {
                                                         //不需要做响应
                                                     } else if (status == 0) {
                                                         //跳转到商品详情页
                                                         [PastePopupView showByType:status data:response[@"data"][@"info"]];
                                                         
                                                     } else if (status == 1) {
                                                         //跳转到搜索结果页
                                                         [PastePopupView showByType:status data:response[@"data"][@"info"]];
                                                         
                                                     }
                                                 }
                                             } failureBlock:^(NSString *error) {
                                                 
                                             }];
}

#pragma mark - 设置tabbar顶部黑线
- (void)setupTabbarShadowImage {
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [RGBA(215, 215, 215, 0.7) CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // 去掉tabbar顶部黑线
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:img];
    
    self.tabBar.backgroundColor = QHWhiteColor;
}

#pragma mark - 添加子控制器
- (void)setupAllChildControllers {
    // 首页
    NewHomeViewController *homeVc = [[NewHomeViewController alloc] init];
    WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:homeVc];
    [self addChildViewController:nav];

//    HomeViewController *homeVc = [[HomeViewController alloc] init];
//    WYNavigationController *nav = [[WYNavigationController alloc] initWithRootViewController:homeVc];
//    [self addChildViewController:nav];
    
    // 品牌精选
    BrandSelectionController *brandVc = [[BrandSelectionController alloc] init];
    WYNavigationController *nav1 = [[WYNavigationController alloc] initWithRootViewController:brandVc];
    [self addChildViewController:nav1];

//    SpecialSessionViewController *specialVc = [[SpecialSessionViewController alloc] init];
//    WYNavigationController *nav1 = [[WYNavigationController alloc] initWithRootViewController:specialVc];
//    [self addChildViewController:nav1];

    // 分类
    ClassifyController *classifyVc = [[ClassifyController alloc] init];
    WYNavigationController *nav2 = [[WYNavigationController alloc] initWithRootViewController:classifyVc];
    [self addChildViewController:nav2];

    // 发现
    DiscoveryController *discoveryVc = [[DiscoveryController alloc] init];
    WYNavigationController *nav3 = [[WYNavigationController alloc] initWithRootViewController:discoveryVc];
    [self addChildViewController:nav3];

    // 我的
    MineViewController *mineVc = [[MineViewController alloc] init];
    WYNavigationController *nav4 = [[WYNavigationController alloc] initWithRootViewController:mineVc];
    [self addChildViewController:nav4];
}

#pragma mark - 设置对应的tabbarItem
- (void)setupAllTabbarItem {
    
    UIOffset titleOffset = UIOffsetMake(0, -1);
    
    // 首页
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"首页";
    nav.tabBarItem.titlePositionAdjustment = titleOffset;
    nav.tabBarItem.image = [UIImage imageOriginalWithNamed:@"首页"];
    nav.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"首页2"];

    // 品牌精选
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"品牌精选";
    nav1.tabBarItem.titlePositionAdjustment = titleOffset;
    nav1.tabBarItem.image = [UIImage imageOriginalWithNamed:@"专场2"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"专场"];

    // 分类
    UINavigationController *nav2 = self.childViewControllers[2];
    nav2.tabBarItem.title = @"分类";
    nav2.tabBarItem.titlePositionAdjustment = titleOffset;
    nav2.tabBarItem.image = [UIImage imageOriginalWithNamed:@"分类"];
    nav2.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"分类拷贝"];

    // 发现
    UINavigationController *nav3 = self.childViewControllers[3];
    nav3.tabBarItem.title = @"发现";
    nav3.tabBarItem.titlePositionAdjustment = titleOffset;
    nav3.tabBarItem.image = [UIImage imageOriginalWithNamed:@"发现"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"发现2"];

    // 我的
    UINavigationController *nav4 = self.childViewControllers[4];
    nav4.tabBarItem.title = @"我的";
    nav4.tabBarItem.titlePositionAdjustment = titleOffset;
    nav4.tabBarItem.image = [UIImage imageOriginalWithNamed:@"我的"];
    nav4.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"我的2"];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    if (self.previousTabBarItem == item) {
        // 发出通知，让对应的控制器刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:TabbarTitleButtonDidRepeatClickNotificationName object:nil];
    }
    
    self.previousTabBarItem = item;
}

#pragma mark - Public

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
