//
//  NewSearchTicketController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewSearchTicketController.h"
#import "SearchView.h"
#import "InternalSearchController.h"
#import "GlobalSearchController.h"

#import "SearchDataItem.h"

#import "HistorySearchCell.h"
#import "SearchImageCell.h"

@interface NewSearchTicketController () <SearchViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) SearchView *searchView;
@property(nonatomic,strong) UIButton *internalButton;
@property(nonatomic,strong) UIButton *globalButton;
@property(nonatomic,strong) UIView *internalLine;
@property(nonatomic,strong) UIView *globalLine;

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *historyDataList;
@property (nonatomic, strong) NSMutableArray *hotDataList;
@property (nonatomic, strong) NSMutableArray *introList;

@property (nonatomic, strong) NSMutableArray *netDataList;

@property (nonatomic, assign) NSInteger selectTag;
@property (nonatomic, assign) BOOL hotHidden;

@property (nonatomic, strong) HistorySearchCell *searchCell;
@property (nonatomic, strong) HistorySearchCell *hotCell;
@property (nonatomic, strong) SearchImageCell *imageIntroCell;

@end

static NSString *const historySearchCell = @"historySearchCell";
static NSString *const hotRecommendCell = @"hotRecommendCell";
static NSString *const imageIntroCell = @"imageIntroCell";

@implementation NewSearchTicketController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self createTableView];
    [self createBtnView];

    [self setData];

    [self.searchView beginEditingWithContent:@""];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.tableView) {
        [self setData];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark -
- (void)setData
{
//    NSArray *array = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"231231232122",@"231231232122",@"231231232122",@"231231232122",@"231231232122",nil];
    _introList = [[NSMutableArray alloc]init];
    [_introList addObject:@"get_coupon"];

    [self getMySearch];
    [self getHotSearchList];
    
    _netDataList = [[NSMutableArray alloc]init];
    [_netDataList addObject:@"net_search"];
    [self.tableView reloadData];
}
#pragma mark - UI

- (void)setupUI {
    
    UIView *topView = [[UIView alloc] init];
//    topView.backgroundColor = QHClearColor;
    [self.view addSubview:topView];
    self.topView = topView;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(kNavHeight);
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [[UIImage alloc] createImageWithSize:CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(20) + kNavHeight) gradientColors:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentage:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [self.topView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topView);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:ImageWithNamed(@"返回_白色") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(didClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(AUTOSIZESCALEX(7.5));
        make.bottom.equalTo(self.topView).offset(-AUTOSIZESCALEX(7));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(28), AUTOSIZESCALEX(28)));
    }];

    SearchView *searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, AUTOSIZESCALEX(295), AUTOSIZESCALEX(28))];
    searchView.backgroundColor = ColorWithHexString(@"#ffffff");
    searchView.placeholder = @"输入商品关键词，搜索商品优惠券";
    searchView.delegate = self;
    [self.topView addSubview:searchView];
    self.searchView = searchView;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topView);
        make.centerY.equalTo(backButton);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(90), AUTOSIZESCALEX(28)));
    }];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateSelected];
    searchBtn.titleLabel.font = TextFont(13);
    [searchBtn addTarget:self action:@selector(clickedSearchBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).offset(AUTOSIZESCALEX(-10));
        make.top.equalTo(searchView.mas_top).offset(AUTOSIZESCALEX(8));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    UIButton *internalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [internalButton setTitle:@"搜索" forState:UIControlStateNormal];
    [internalButton setTitleColor:ColorWithHexString(@"#848282") forState:UIControlStateNormal];
    [internalButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateSelected];
    internalButton.selected = YES;
    internalButton.hidden = YES;
    internalButton.titleLabel.font = TextFont(13);
    [internalButton addTarget:self action:@selector(didClickInternalButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:internalButton];
    self.internalButton = internalButton;
    [internalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_centerX).offset(AUTOSIZESCALEX(-15));
        make.bottom.equalTo(searchView.mas_top).offset(AUTOSIZESCALEX(-8));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];

    UIButton *globalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [globalButton setTitle:@"全网搜索" forState:UIControlStateNormal];
    [globalButton setTitleColor:ColorWithHexString(@"#848282") forState:UIControlStateNormal];
    [globalButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateSelected];
    globalButton.titleLabel.font = TextFont(13);
    [globalButton addTarget:self action:@selector(didClickGlobalButton:) forControlEvents:UIControlEventTouchUpInside];
    globalButton.hidden = YES;
    [self.topView addSubview:globalButton];
    self.globalButton = globalButton;
    [globalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_centerX).offset(AUTOSIZESCALEX(5));
        make.centerY.equalTo(internalButton).offset(AUTOSIZESCALEX(0));
        make.height.equalTo(internalButton);
    }];

    
}


#pragma mark - ButtonView
- (void)createTableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = self.view.backgroundColor;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.estimatedRowHeight = 0;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [tableView registerClass:[HistorySearchCell class] forCellReuseIdentifier:historySearchCell];
        [tableView registerClass:[HistorySearchCell class] forCellReuseIdentifier:hotRecommendCell];
        [tableView registerClass:[SearchImageCell class] forCellReuseIdentifier:imageIntroCell];
        [self.view addSubview:tableView];
        
        _tableView = tableView;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom);
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
        }];
    }
}
- (void)createBtnView
{
    if (!_buttonView) {
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, AUTOSIZESCALEY(40))];
//        btnView.backgroundColor = [UIColor redColor];
        UIButton *internalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [internalButton setTitle:@"搜索" forState:UIControlStateNormal];
        [internalButton setTitleColor:ColorWithHexString(@"#848282") forState:UIControlStateNormal];
        [internalButton setTitleColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:43/255.0 alpha:1]forState:UIControlStateSelected];
        internalButton.selected = YES;
        internalButton.titleLabel.font = TextFont(15);
        [internalButton addTarget:self action:@selector(didClickInternalButton:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:internalButton];
        self.internalButton = internalButton;
        [internalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(btnView.mas_centerX).offset(AUTOSIZESCALEX(-40));
            make.top.equalTo(btnView.mas_top);
            make.height.equalTo(btnView.mas_height);
        }];
        
        UIButton *globalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [globalButton setTitle:@"全网搜索" forState:UIControlStateNormal];
        [globalButton setTitleColor:ColorWithHexString(@"#848282") forState:UIControlStateNormal];
        [globalButton setTitleColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:43/255.0 alpha:1] forState:UIControlStateSelected];
        globalButton.titleLabel.font = TextFont(15);
        [globalButton addTarget:self action:@selector(didClickGlobalButton:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:globalButton];
        self.globalButton = globalButton;
        [globalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btnView.mas_centerX).offset(AUTOSIZESCALEX(20));
            make.centerY.equalTo(internalButton).offset(AUTOSIZESCALEX(0));
            make.height.equalTo(internalButton);
        }];
        
        _internalLine = [[UIView alloc]init];
        _internalLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:43/255.0 alpha:1];
        [_internalButton addSubview:_internalLine];
        [_internalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_internalButton.mas_left);
            make.right.mas_equalTo(_internalButton.mas_right);
            make.bottom.mas_equalTo(_internalButton.mas_bottom).mas_offset(-1);
            make.height.equalTo(@1);
        }];
        _globalLine = [[UIView alloc]init];
        _globalLine.backgroundColor = [UIColor colorWithRed:255/255.0 green:180/255.0 blue:43/255.0 alpha:1];
        [_globalButton addSubview:_globalLine];
        [_globalLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_globalButton.mas_left).mas_offset(12);
            make.right.mas_equalTo(_globalButton.mas_right).mas_offset(-12);
            make.bottom.mas_equalTo(_globalButton.mas_bottom).mas_offset(-1);
            make.height.equalTo(@1);
        }];
        _globalLine.hidden = YES;
        self.buttonView = btnView;
    }
    self.tableView.tableHeaderView = self.buttonView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_selectTag == 1) {
        return 1;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_selectTag == 1) {
        float height = [_imageIntroCell getHeight];
        return height;
    }
    if (indexPath.section == 0) {
        float height = [_searchCell getRowHeight];
        return height;
    }
    if (indexPath.section == 1) {
        if (_hotHidden == YES) {
            return 0.01;
        }else{
            float height = [_hotCell getRowHeight];
            return height;
        }
    }
    if (indexPath.section == 2) {
        float height = [_imageIntroCell getHeight];
        return height;
    }
    return 0.01;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_selectTag == 1) {
        if (indexPath.section == 0) {
            NSString *image = [_netDataList objectAtIndex:indexPath.section];
            _imageIntroCell = [tableView dequeueReusableCellWithIdentifier:imageIntroCell];
            [_imageIntroCell setImageTxt:image];
            return _imageIntroCell;
        }
    } else {
        if (indexPath.section == 0) {
            WeakSelf
//            NSArray *historyList = [_historyDataList objectAtIndex:indexPath.section];
            _searchCell =  [tableView dequeueReusableCellWithIdentifier:historySearchCell];
            [_searchCell setHistoryArray: _historyDataList];
            [_searchCell setSearchTapHistoryBlock:^(NSInteger tag) {
                SearchDataItem *item = [weakSelf.historyDataList objectAtIndex:tag];
                [weakSelf searchWithText:item.keyword];
            }];
            return _searchCell;
        }
        if (indexPath.section == 1) {
            WeakSelf
            if (_hotHidden == YES) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                cell.backgroundColor = QHWhiteColor;
                return cell;
            }
//            NSArray *hotRecommendList = [_hotDataList objectAtIndex:indexPath.section];
            _hotCell =  [tableView dequeueReusableCellWithIdentifier:hotRecommendCell];
            [_hotCell setHistoryArray: _hotDataList];
            [_hotCell setSearchTapHistoryBlock:^(NSInteger tag) {
                SearchDataItem *item = [weakSelf.hotDataList objectAtIndex:tag];
                [weakSelf searchWithText:item.keyword];
            }];
            return _hotCell;
        }
        if (indexPath.section == 2) {
            NSString *image = [_introList objectAtIndex:0];
            _imageIntroCell = [tableView dequeueReusableCellWithIdentifier:imageIntroCell];
            [_imageIntroCell setImageTxt:image];
            return _imageIntroCell;
        }
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.backgroundColor = QHWhiteColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_selectTag == 1) {
        return 0.01;
    }
    if (section == 0 || section == 1 || section == 2) {
        if (section == 0) {
            if (_historyDataList == nil || _historyDataList.count == 0) {
                return 0.01;
            }
        }
        return AUTOSIZESCALEX(40);
    }
    return  0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        return self.secondSectionHeaderView;
//    }
    if (_selectTag == 1) {
        return nil;
    }
    if (section == 0) {
        if (_historyDataList == nil || _historyDataList.count == 0) {
            return nil;
        }
        UILabel *label = [[UILabel alloc]init];
        label.text = @"历史搜索";
        label.font = [UIFont systemFontOfSize:14];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_left).mas_offset(10);
            make.top.mas_equalTo(view.mas_top);
            make.bottom.mas_equalTo(view.mas_bottom);
            make.width.equalTo(@100);
        }];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
        clearBtn.tag = 0;
        [clearBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:clearBtn];
        
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_centerY);
            make.right.mas_equalTo(view.mas_right).mas_offset(-10);
        }];
        return view;
    }
    if (section == 1) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"热门搜索";
        label.font = [UIFont systemFontOfSize:14];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_left).mas_offset(10);
            make.top.mas_equalTo(view.mas_top);
            make.bottom.mas_equalTo(view.mas_bottom);
            make.width.equalTo(@100);
        }];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn setImage:[UIImage imageNamed:@"icon_examine"] forState:UIControlStateNormal];
        [clearBtn setImage:[UIImage imageNamed:@"icon_examine_pressed"] forState:UIControlStateHighlighted];
        [clearBtn setImage:[UIImage imageNamed:@"icon_examine_pressed"] forState:UIControlStateSelected];

        clearBtn.tag =1;
        clearBtn.selected = _hotHidden;
        [clearBtn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];

        [view addSubview:clearBtn];
        
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_centerY);
            make.right.mas_equalTo(view.mas_right).mas_offset(-10);;
        }];
        return view;
    }
    if (section == 2) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"搜索教程";
        label.font = [UIFont systemFontOfSize:14];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        [view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_left).mas_offset(10);
            make.top.mas_equalTo(view.mas_top);
            make.bottom.mas_equalTo(view.mas_bottom);
            make.width.equalTo(@100);
        }];
        return view;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return section == 1 ? 0.01 : 5;
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return section == 1 ? [[UIView alloc] init] : [UIView tableFooterView];
    return nil;
}
#pragma mark - Button Action

- (void)didClickBackButton {
    [self.searchView endEditing];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchView endEditing];
}

// 系统内搜索
- (void)didClickInternalButton:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    _internalLine.hidden = NO;
    _globalLine.hidden = YES;
    sender.selected = !sender.selected;
    self.globalButton.selected = !sender.selected;
//    self.searchView.placeholder = @"输入商品关键词";
    self.selectTag = 0;
    [self.tableView reloadData];
}

- (void)clickedSearchBtn:(id)sender
{
    NSString *keyWord = [self.searchView getKeyword];
    if (![keyWord isEqualToString:@""]) {
        [self searchWithText:keyWord];

    }
}
// 全网搜索
- (void)didClickGlobalButton:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    _internalLine.hidden = YES;
    _globalLine.hidden = NO;
    _selectTag = 1;
    sender.selected = !sender.selected;
    self.internalButton.selected = !sender.selected;
//    self.searchView.placeholder = @"粘贴淘宝天猫商品标题到这里";
    [self.tableView reloadData];
}

#pragma mark - BtnDelegate
- (void)clickedBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    if (tag == 0) {
        [self delMySearch];
    }
    if (tag == 1) {
        btn.selected = !btn.selected;
        if (btn.selected == YES) {
            _hotHidden = YES;
        }else{
            _hotHidden = NO;
        }
        [self.tableView reloadData];
    }
}
#pragma mark - SearchViewDelegate

- (void)searchView:(SearchView *)searchView searchWithContent:(NSString *)content {
    if ([NSString isEmpty:content]) {
        return;
    }
//    if (self.internalButton.selected) { // 系统内搜索
//        InternalSearchController *internalVc = [[InternalSearchController alloc] init];
//        internalVc.title = content;
//        internalVc.keyword = content;
//        [self.navigationController pushViewController:internalVc animated:YES];
//    } else {
        // 全局搜索
        GlobalSearchController *globalVc = [[GlobalSearchController alloc] init];
        globalVc.title = content;
        globalVc.keyword = content;
        [self.navigationController pushViewController:globalVc animated:YES];
//    }
}

- (void)searchWithText:(NSString *)text
{
//    InternalSearchController *internalVc = [[InternalSearchController alloc] init];
//    internalVc.title = text;
//    internalVc.keyword = text;
//    [self.navigationController pushViewController:internalVc animated:YES];
    GlobalSearchController *globalVc = [[GlobalSearchController alloc] init];
    globalVc.title = text;
    globalVc.keyword = text;
    [self.navigationController pushViewController:globalVc animated:YES];
}

#pragma mark - Http
- (void)getHotSearchList
{
    WeakSelf
    [[NetworkSingleton sharedManager]getCoRequestWithUrl:@"/getHotSearch" parameters:nil successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            weakSelf.hotDataList = [SearchDataItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            if (_selectTag == 0) {
                [self.tableView reloadData];
            }
        } else {
//            [WYProgress showErrorWithStatus:response[@"message"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

- (void)getMySearch
{
    
    if ([LoginUserDefault userDefault].isTouristsMode) {
        return;
    }
    
    NSString *userId = [LoginUserDefault userDefault].userItem.userId;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userid"] = userId;
    WeakSelf
    [[NetworkSingleton sharedManager]getCoRequestWithUrl:@"/getMySearch/" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            weakSelf.historyDataList = [SearchDataItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            if (_selectTag == 0) {
                [self.tableView reloadData];
            }
        } else {
            
            [WYProgress showErrorWithStatus:response[@"message"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

- (void)delMySearch
{
    NSString *userId = [LoginUserDefault userDefault].userItem.userId;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userid"] = userId;
    WeakSelf
    [[NetworkSingleton sharedManager]getCoRequestWithUrl:@"/delMySearch" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            [weakSelf.historyDataList removeAllObjects];
            if (_selectTag == 0) {
                [self.tableView reloadData];
            }
        } else {
            
            [WYProgress showErrorWithStatus:response[@"message"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];

}
@end
