//
//  TBCQController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TBCQController.h"
#import "ShoppingPreparingCell.h"

@interface TBCQController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TBCQController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[ShoppingPreparingCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(5);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return AUTOSIZESCALEX(1250);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ShoppingPreparingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.contentImage = ImageWithNamed(@"淘宝查券");
    return cell;
    
}





@end
