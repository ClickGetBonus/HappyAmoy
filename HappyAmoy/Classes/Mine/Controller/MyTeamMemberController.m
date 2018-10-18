//
//  MyTeamMemberController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyTeamMemberController.h"
#import "MyTeamDirectMemberController.h"
#import "MyTeamIndirectMemberController.h"

@interface MyTeamMemberController () <UIScrollViewDelegate>

/**    存放子控制器的scrollView    */
@property (strong, nonatomic) UIScrollView *scrollView;
/**    标题栏    */
@property (strong, nonatomic) UIView *titleView;
/**    上次点击的按钮    */
@property (strong, nonatomic) UIButton *previousClickButton;
/**    标题按钮的下划线    */
@property (strong, nonatomic) UIView *titleButtonUnderLine;

@end

@implementation MyTeamMemberController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    // 设置子控制器
    [self setupChildVc];
    // 添加scrollView
    [self setupScrollView];
    // 添加标题栏
    [self setupTitleView];
}

#pragma mark - 添加子控制器
- (void)setupChildVc {
    MyTeamDirectMemberController *directVc = [[MyTeamDirectMemberController alloc] init];
    directVc.isVip = self.isVip;
    [self addChildViewController:directVc];
    
    MyTeamIndirectMemberController *indirectVc = [[MyTeamIndirectMemberController alloc] init];
    indirectVc.isVip = self.isVip;
    [self addChildViewController:indirectVc];
}

#pragma mark - 设置scrollView
- (void)setupScrollView {
    // 禁止系统为scrollView添加额外的上边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 0)];
    
    scrollView.backgroundColor = ViewControllerBackgroundColor;
    // 设置分页
    scrollView.pagingEnabled = YES;
    // 隐藏垂直滚动条
    scrollView.showsVerticalScrollIndicator = NO;
    // 隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    scrollView.delegate = self;
    // 当点击状态栏的时候，禁止scrollView滑动到顶部
    scrollView.scrollsToTop = NO;
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    NSInteger count = self.childViewControllers.count;
    
    scrollView.contentSize = CGSizeMake(count * scrollView.width, 0);
}

#pragma mark - 设置标题栏
- (void)setupTitleView {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight + AUTOSIZESCALEX(1), SCREEN_WIDTH, AUTOSIZESCALEX(45))];
    titleView.centerX = self.view.centerX;
    self.titleView = titleView;
    
    titleView.backgroundColor = QHWhiteColor;
    
    [self.view addSubview:titleView];
    
    // 设置标题按钮
    [self setupTitleButton];
    // 添加标题按钮的下划线
    [self setupTitleBtnUnderLine];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5, AUTOSIZESCALEX(10), AUTOSIZESCALEX(1), AUTOSIZESCALEX(25))];
    line.backgroundColor = SeparatorLineColor;
    [titleView addSubview:line];

    // 默认开始点击第一个标题
    UIButton *button = self.titleView.subviews[0];
    
    [self titleButtonClick:button];
}

#pragma mark - 添加标题按钮
- (void)setupTitleButton {
    
    NSArray *titleArray = @[@"直属",@"间属"];
    
    NSInteger count = titleArray.count;
    
    CGFloat buttonW = SCREEN_WIDTH * 0.5;
    CGFloat buttonH = self.titleView.height;
    
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(i * buttonW , 0, buttonW, buttonH);
        
        button.tag = i;
        
        [button setTitleColor:ColorWithHexString(@"#565656") forState:UIControlStateNormal];
        [button setTitleColor:QHMainColor forState:UIControlStateSelected];
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = TextFont(17);
        
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleView addSubview:button];
    }
}

#pragma mark - 添加标题下划线
- (void)setupTitleBtnUnderLine {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView.height - AUTOSIZESCALEX(1.5), AUTOSIZESCALEX(40), AUTOSIZESCALEX(1.5))];
    
    line.backgroundColor = QHMainColor;
    
    self.titleButtonUnderLine = line;
    
    [self.titleView addSubview:line];
    
}

#pragma mark - 标题的点击事件
- (void)titleButtonClick:(UIButton *)sender {
    [self titleButtonClickWhenScroll:sender];
}

#pragma mark - 处理滑动时调用的点击标题按钮事件
- (void)titleButtonClickWhenScroll:(UIButton *)sender {
    
    self.previousClickButton.selected = NO;
    sender.selected = YES;
    self.previousClickButton = sender;
    
    [UIView animateWithDuration:0.25 animations:^{
        // 设置下划线平移
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSFontAttributeName] = sender.titleLabel.font;
        // 获取按钮标题的宽度
        //        CGFloat buttonwidth = [sender.currentTitle sizeWithAttributes:attr].width;
        // 下划线宽度比按钮标题的宽度宽一点，有点突出感
        //        self.titleButtonUnderLine.width = buttonwidth + 10;
        
        self.titleButtonUnderLine.centerX = sender.centerX;
        
        // 设置scrollView平移
        self.scrollView.contentOffset = CGPointMake(sender.tag * self.scrollView.width, self.scrollView.contentOffset.y);
        
    } completion:^(BOOL finished) {
        
        UIView *childView = self.childViewControllers[sender.tag].view;
        
        childView.frame = CGRectMake(sender.tag * self.scrollView.width, self.titleView.bottom_WY, self.scrollView.width, self.scrollView.height - self.titleView.bottom_WY);
        
        [self.scrollView addSubview:childView];
        
    }];
    
    // 当点击状态栏的时候，把当前显示的tableView滑动到顶部，只要设置scrollView的scrollsToTop为yes即可，但前提是只有一个scrollView设置为yes，其他都设置为no
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        
        UIViewController *childVc = self.childViewControllers[i];
        // 如果控制器的View还没加载，则不需要处理
        if (!childVc.isViewLoaded) continue;
        
        UIView *mainView = (UIView *)childVc.view;
        
        for (UIScrollView *subView in mainView.subviews) {
            
            if (![subView isKindOfClass:[UIScrollView class]]) continue;
            
            subView.scrollsToTop = (i == sender.tag);
        }
    }
}

#pragma mark - UIScrollViewDelegate
// scrollView滑动结束时会调用该方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 找到偏移后的按钮的索引
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    
    UIButton *button = self.titleView.subviews[index];
    
    [self titleButtonClickWhenScroll:button];
    
}





@end
