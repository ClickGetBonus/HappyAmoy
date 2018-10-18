//
//  ShowViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShowViewController.h"
#import "TodayReviewCell.h"
#import "ShowSecondRowCell.h"

@interface ShowViewController () <UITableViewDelegate,UITableViewDataSource>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;

@end

static NSString *const reviewCellId = @"reviewCellId";
static NSString *const listCellId = @"listCellId";

@implementation ShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"晒晒";
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    //    TodayReviewView *todayReview = [[TodayReviewView alloc] init];
    //    [self.view addSubview:todayReview];
    //    self.todayReview = todayReview;
    //
    //    [self.todayReview mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view).offset(kNavHeight);
    //        make.left.equalTo(self.view).offset(0);
    //        make.right.equalTo(self.view).offset(0);
    //        make.height.mas_equalTo(AUTOSIZESCALEX(295));
    //    }];
//    
//    MemberListView *memberListView = [[MemberListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - AUTOSIZESCALEX(20), SCREEN_HEIGHT - kNavHeight - AUTOSIZESCALEX(295) - AUTOSIZESCALEX(20) - kTabbar_Bottum_Height)];
//    [self.view addSubview:memberListView];
//    self.memberListView = memberListView;
//
//    [self.memberListView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.todayReview.mas_bottom).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(10));
//        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-10));
//        make.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(-10)-kTabbar_Bottum_Height);
//    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[TodayReviewCell class] forCellReuseIdentifier:reviewCellId];
    [tableView registerClass:[ShowSecondRowCell class] forCellReuseIdentifier:listCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(2));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(-10));
    }];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return AUTOSIZESCALEX(295);
    }
    
    return AUTOSIZESCALEX(500);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        TodayReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:reviewCellId];
        
        return cell;
    }
    
    ShowSecondRowCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellId];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
