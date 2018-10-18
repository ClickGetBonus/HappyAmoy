//
//  BrandAreaController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BrandAreaController.h"
#import "BrandAreaCell.h"
#import "BrandSellerListItem.h"
#import "GoodsListViewController.h"
#import "GoodsDetailController.h"

@interface BrandAreaController () <UITableViewDelegate,UITableViewDataSource,BrandAreaCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (strong, nonatomic) UITableView *tableView;
/**    品牌商家列表    */
@property (strong, nonatomic) NSMutableArray *brandSellerListArray;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;

@end

static NSString *const brandCellId = @"brandCellId";

@implementation BrandAreaController

#pragma mark - Lazy load

- (NSMutableArray *)brandSellerListArray {
    if (!_brandSellerListArray) {
        _brandSellerListArray = [NSMutableArray array];
    }
    return _brandSellerListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"品牌专区";
    
    self.view.backgroundColor = FooterViewBackgroundColor;
    
    self.pageNo = 1;

    [self setupUI];
    [self getBrandSellerListWithPageNo:self.pageNo];
}

#pragma mark - Data

- (void)getBrandSellerListWithPageNo:(NSInteger)pageNo {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];;

    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/brandSellerList" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.brandSellerListArray = [BrandSellerListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            } else {
                [weakSelf.brandSellerListArray addObjectsFromArray:[BrandSellerListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
            }
            
            if ((weakSelf.brandSellerListArray.count % PageSize != 0) || weakSelf.brandSellerListArray.count == 0) { // 有余数说明没有下一页了
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                weakSelf.pageNo++;
                [weakSelf.tableView.mj_footer endRefreshing];
            }
            
            [weakSelf.tableView reloadData];

        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];

    } failureBlock:^(NSString *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.emptyDataSetDelegate = self;
    tableView.emptyDataSetSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[BrandAreaCell class] forCellReuseIdentifier:brandCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getBrandSellerListWithPageNo:1];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getBrandSellerListWithPageNo:_pageNo];
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + 5);
        make.left.right.bottom.equalTo(self.view).offset(0);
    }];
}

#pragma mark - Button Action

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    self.tableView.mj_footer.hidden = (self.brandSellerListArray.count == 0);

    return self.brandSellerListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return AUTOSIZESCALEX(240);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BrandSellerListItem *item = self.brandSellerListArray[section];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(40))];
    headerView.tag = section;
    headerView.backgroundColor = QHWhiteColor;
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(DynamicContentLeftSpace, AUTOSIZESCALEX(10), headerView.width - AUTOSIZESCALEX(30), AUTOSIZESCALEX(20))];
    descLabel.text = item.name;
    descLabel.textColor = QHMainColor;
    descLabel.font = AppMainTextFont(16);
    [headerView addSubview:descLabel];
    [descLabel sizeToFit];
    descLabel.center = headerView.center;
    
    UIImageView *nextImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"next_red")];
    nextImageView.frame = CGRectMake(descLabel.right_WY + AUTOSIZESCALEX(10), 0, AUTOSIZESCALEX(8), AUTOSIZESCALEX(15));
    [headerView addSubview:nextImageView];
    nextImageView.centerY = descLabel.centerY;
    
    WeakSelf
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        WYLog(@"x = %@",x);
        GoodsListViewController *goodsListVc = [[GoodsListViewController alloc] init];
        goodsListVc.title = item.name;
        goodsListVc.brandItem = weakSelf.brandSellerListArray[section];
        goodsListVc.type = CommodityOfBrand;
        [self.navigationController pushViewController:goodsListVc animated:YES];
    }];
    
    [headerView addGestureRecognizer:tap];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView tableFooterView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BrandAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:brandCellId];
    cell.delegate = self;
    BrandSellerListItem *item = self.brandSellerListArray[indexPath.section];
    cell.datasource = [NSMutableArray arrayWithArray:item.commodityList];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - BrandAreaCellDelegate

- (void)brandAreaCell:(BrandAreaCell *)brandAreaCell didSelectItem:(CommodityListItem *)item {
    
    GoodsDetailController *detailVc = [[GoodsDetailController alloc] init];
    detailVc.item = item;
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

#pragma mark - DZNEmptyDataSetSource Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ImageWithNamed(@"浏览无数据");
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"当前没有数据";
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UIColor *textColor = ColorWithHexString(@"999999");
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
//{
//    NSString *text = @"没有找到相关的宝贝";
//    UIFont *font = [UIFont systemFontOfSize:16.0];
//    UIColor *textColor = ColorWithHexString(@"999999");
//
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    [attributes setObject:font forKey:NSFontAttributeName];
//    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return RGB(239, 239, 239);
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -kNavHeight;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    WYFunc
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
