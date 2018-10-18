//
//  CategoryScrollView.m
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CategoryScrollView.h"
#import "ClassifyItem.h"

@interface CategoryScrollView ()

@property(nonatomic,strong) UIScrollView *scrollView;
/**    上次点击的按钮    */
@property (strong, nonatomic) UIButton *previousClickButton;
/**    标题按钮的下划线    */
@property (strong, nonatomic) UIView *titleButtonUnderLine;
/**    按钮数组    */
@property(nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation CategoryScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.buttonArray = [NSMutableArray array];
        [self setupUI];
    }
    return self;
}

#pragma mark - Setter

- (void)setCategoriesArray:(NSArray *)categoriesArray {
    _categoriesArray = categoriesArray;
    if (self.buttonArray.count > 0) {
        return;
    }
    [self addCategoryButton];
    [self setupTitleBtnUnderLine];
    // 默认开始点击第一个标题
    UIButton *button = self.scrollView.subviews[0];
    [self titleButtonClick:button];
}

#pragma mark - UI

- (void)setupUI {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.backgroundColor = QHWhiteColor;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)addCategoryButton {
    NSInteger count = self.categoriesArray.count;
    
    CGFloat buttonW = AUTOSIZESCALEX(65);
    CGFloat buttonH = self.height;
    
    for (NSInteger i = 0; i < count; i++) {
        ClassifyItem *item = self.categoriesArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonW , 0, buttonW, buttonH);
        button.tag = i;
        [button setTitleColor:ColorWithHexString(@"#333333") forState:UIControlStateNormal];
        [button setTitleColor:QHMainColor forState:UIControlStateSelected];
        [button setTitle:item.name forState:UIControlStateNormal];
        button.titleLabel.font = TextFont(13);
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        [self.scrollView addSubview:button];
        self.scrollView.contentSize = CGSizeMake(button.right_WY, self.scrollView.height);
    }
}

// 添加标题下划线
- (void)setupTitleBtnUnderLine {
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(-AUTOSIZESCALEX(100), self.scrollView.height - AUTOSIZESCALEX(0.5), self.scrollView.contentSize.width + AUTOSIZESCALEX(200), AUTOSIZESCALEX(0.5))];
    line1.backgroundColor = SeparatorLineColor;
    self.titleButtonUnderLine = line1;
    [self.scrollView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(-AUTOSIZESCALEX(100), 0, self.scrollView.contentSize.width + AUTOSIZESCALEX(200), AUTOSIZESCALEX(0.5))];
    line2.backgroundColor = SeparatorLineColor;
    self.titleButtonUnderLine = line2;
    [self.scrollView addSubview:line2];

    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.height - AUTOSIZESCALEX(1.5), AUTOSIZESCALEX(40), AUTOSIZESCALEX(1.5))];
    line3.backgroundColor = QHMainColor;
    self.titleButtonUnderLine = line3;
    [self.scrollView addSubview:line3];
    
}

#pragma mark - Button Action

// 标题的点击事件
- (void)titleButtonClick:(UIButton *)sender {
    [self titleButtonClickWhenScroll:sender];
}

// 处理滑动时调用的点击标题按钮事件
- (void)titleButtonClickWhenScroll:(UIButton *)sender {
    
    self.previousClickButton.selected = NO;
    sender.selected = YES;
    self.previousClickButton = sender;
    
    if ([_delegate respondsToSelector:@selector(categoryScrollView:didSelectItem:)]) {
        [_delegate categoryScrollView:self didSelectItem:self.categoriesArray[sender.tag]];
    }
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    // 切换坐标，找出按钮相对于屏幕的坐标点
    CGRect rect=[sender convertRect: sender.bounds toView:window];
    WYLog(@"rect = %@",NSStringFromCGRect(rect));
    
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
//        self.scrollView.contentOffset = CGPointMake(sender.tag * self.scrollView.width, self.scrollView.contentOffset.y);
        
        if (sender.tag > 2) {
            if ((self.categoriesArray.count - sender.tag) > 3) {
                if ((rect.origin.x + AUTOSIZESCALEX(65) * 0.5) > (SCREEN_WIDTH * 0.5)) {
                    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + rect.origin.x + AUTOSIZESCALEX(65) * 0.5 - SCREEN_WIDTH * 0.5, self.scrollView.contentOffset.y);
                } else {
                    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x - (SCREEN_WIDTH * 0.5 - rect.origin.x - AUTOSIZESCALEX(65) * 0.5), self.scrollView.contentOffset.y);
                }
            } else {
                self.scrollView.contentOffset = CGPointMake(self.scrollView.contentSize.width - SCREEN_WIDTH , self.scrollView.contentOffset.y);
            }
        } else {
            self.scrollView.contentOffset = CGPointMake(0, self.scrollView.contentOffset.y);
        }
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - UIScrollViewDelegate
// scrollView滑动结束时会调用该方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 找到偏移后的按钮的索引
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    
    UIButton *button = self.buttonArray[index];
    
    [self titleButtonClickWhenScroll:button];
    
}

@end
