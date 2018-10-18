//
//  FilterView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FilterView.h"

@interface FilterView() <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,YBPopupMenuDelegate>

/**    数据源    */
@property (strong, nonatomic) NSArray *buttonArray;
/**    上一次点击的按钮    */
@property (strong, nonatomic) UIButton *preClickButton;
/**    遮罩    */
@property (strong, nonatomic) UIView *hudView;
/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    综合数组    */
@property (strong, nonatomic) NSArray *synthesisArray;
/**    已选的综合选项    */
@property (copy, nonatomic) NSString *selectedSynthesis;
/**    已选的优惠券类型    */
@property (copy, nonatomic) NSString *type;

@end

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray synthesisArray:(NSArray *)synthesisArray {
    if (self = [super initWithFrame:frame]) {
        self.buttonArray = buttonArray;
        self.synthesisArray = synthesisArray;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    for (int i = 0; i < _buttonArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:_buttonArray[i] forState:UIControlStateNormal];
        [button setTitleColor:RGB(70, 70, 70) forState:UIControlStateNormal];
        [button setTitleColor:QHMainColor forState:UIControlStateSelected];
        button.titleLabel.font = TextFont(13);
        button.tag = i + 100;
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat buttonW = (self.width - AUTOSIZESCALEX(10)) / _buttonArray.count;

        if ([_buttonArray[i] isEqualToString:@"宝贝类型"]) {
            [button setImage:ImageWithNamed(@"宝贝类型") forState:UIControlStateNormal];
            button.width = buttonW;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, -(button.imageView.size.width), 0, (button.imageView.size.width));
            button.imageEdgeInsets = UIEdgeInsetsMake(0, (button.titleLabel.size.width) + AUTOSIZESCALEX(6), 0, -(button.titleLabel.size.width));
        }
        
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self).offset(AUTOSIZESCALEX(0));
            make.left.equalTo(self).offset(i * buttonW);
            make.width.mas_equalTo(buttonW);
        }];
    }
    
//    UIButton *babyTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [babyTypeButton setImage:ImageWithNamed(@"宝贝类型") forState:UIControlStateNormal];
//    [babyTypeButton addTarget:self action:@selector(didClickBabyType:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:babyTypeButton];
//    [babyTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self).offset(AUTOSIZESCALEX(-10));
//        make.width.mas_equalTo(AUTOSIZESCALEX(12));
//        make.height.mas_equalTo(AUTOSIZESCALEX(10));
//    }];
    
    UIView *line = [UIView separatorLine];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];

    UIView *hudView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height + kNavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - self.height - kNavHeight)];
    hudView.alpha = 0;
    hudView.backgroundColor = RGBA(0, 0, 0, 0.5);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [hudView addGestureRecognizer:tap];
    
    [self.superview addSubview:hudView];
    self.hudView = hudView;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, AUTOSIZESCALEX(-self.synthesisArray.count * 30 - 5), hudView.width, AUTOSIZESCALEX(self.synthesisArray.count * 30 + 5))];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [hudView addSubview:tableView];
    self.tableView = tableView;
}

#pragma mark - Button Action

- (void)didClickButton:(UIButton *)sender {
    
    WYLog(@"title = %@",sender.titleLabel.text);

    if ([sender.titleLabel.text isEqualToString:@"综合"] || [self.synthesisArray containsObject:sender.titleLabel.text]) {
        if (self.hudView.alpha == 0) {
            [self.superview addSubview:self.hudView];
            [UIView animateWithDuration:0.25 animations:^{
                self.tableView.y = 0;
                [self.tableView reloadData];
                self.hudView.alpha = 1;
            }];
        } else {
            self.hudView.alpha = 0;
            [self.hudView removeFromSuperview];
        }
    } else {
        [self dismiss];
        
        if ([sender.titleLabel.text isEqualToString:@"宝贝类型"] || [sender.titleLabel.text isEqualToString:@"天猫"] || [sender.titleLabel.text isEqualToString:@"淘宝"]) {
            [self didClickBabyType:sender];
            
            if (self.preClickButton == sender) {
                return;
            }
            self.preClickButton.selected = NO;

            self.preClickButton = sender;

            return;
        }
    }
    
    if (self.preClickButton == sender) {
        return;
    }
    self.preClickButton.selected = NO;
    
    sender.selected = !sender.selected;
    
    self.preClickButton = sender;
    
    if ([_delegate respondsToSelector:@selector(filterView:didClickIndex:)]) {
        [_delegate filterView:self didClickIndex:sender.tag - 100 + 1];
    }
}

// 点击宝贝类型
- (void)didClickBabyType:(UIButton *)sender {
    
    [self dismiss];
    
    YBPopupMenu *menu = [YBPopupMenu showRelyOnView:sender titles:@[@"天猫",@"淘宝"] icons:nil menuWidth:AUTOSIZESCALEX(70) delegate:self];
    
    menu.itemHeight = 35;

}

- (void)dismiss {
    self.hudView.alpha = 0;
    [self.hudView removeFromSuperview];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.synthesisArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AUTOSIZESCALEX(30);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    cell.textLabel.text = self.synthesisArray[indexPath.row];
    cell.textLabel.font = TextFont(13);
    cell.textLabel.textColor = RGB(100, 100, 100);
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    if ([self.selectedSynthesis isEqualToString:self.synthesisArray[indexPath.row]]) {
        cell.textLabel.textColor = QHMainColor;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedSynthesis = self.synthesisArray[indexPath.row];
    [self.preClickButton setTitle:self.selectedSynthesis forState:UIControlStateNormal];
    
    [self dismiss];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass(touch.view.class) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
    
}

#pragma mark - YBPopupMenuDelegate

- (UITableViewCell *)ybPopupMenu:(YBPopupMenu *)ybPopupMenu cellForRowAtIndex:(NSInteger)index {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCellId"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    titleLabel.text = index == 0 ? @"淘宝" : @"天猫";
    titleLabel.font = TextFont(13);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.layer.cornerRadius = 3;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.layer.borderWidth = 0.5;

    if ([self.type isEqualToString:titleLabel.text]) {
        titleLabel.textColor = QHMainColor;
        titleLabel.layer.borderColor = QHMainColor.CGColor;
    } else {
        titleLabel.textColor = RGB(90, 90, 90);
        titleLabel.layer.borderColor = RGB(90, 90, 90).CGColor;
    }
    titleLabel.center = CGPointMake(35, 17.5);
    [cell.contentView addSubview:titleLabel];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    self.type = index == 0 ? @"淘宝" : @"天猫";
    [self.preClickButton setTitle:self.type forState:UIControlStateNormal];
//    [self.preClickButton setTitleColor:QHMainColor forState:UIControlStateNormal];
    self.preClickButton.selected = YES;

    self.preClickButton.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.preClickButton.imageView.size.width), 0, (self.preClickButton.imageView.size.width));
    self.preClickButton.imageEdgeInsets = UIEdgeInsetsMake(0, (self.preClickButton.titleLabel.size.width) + AUTOSIZESCALEX(6), 0, -(self.preClickButton.titleLabel.size.width));
    
    if ([_delegate respondsToSelector:@selector(filterView:didClickBabyType:)]) {
        [_delegate filterView:self didClickBabyType:index];
    }

}

@end
