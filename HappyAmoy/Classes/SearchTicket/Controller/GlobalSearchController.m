//
//  GlobalSearchController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GlobalSearchController.h"
#import "GlobalSearchListCell.h"
#import "TaoBaoSearchItem.h"
#import "TaoBaoSearchDetailItem.h"
#import "GlobalSearchDetailController.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "GlobalSearchShareController.h"
#import "SearchGoodsItem.h"
#import "WebViewH5Controller.h"

#import "NewSearchGoodsDetailController.h"

#import "NewGlobalSearchListCell.h"
@interface GlobalSearchController () <UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,NewGlobalSearchListCellDelegate>

@property (strong, nonatomic) UIView *topView;
/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;
/**    详情模型    */
@property (strong, nonatomic) TaoBaoSearchDetailItem *detailItem;

@end

static NSString *const listCellId = @"listCellId";

@implementation GlobalSearchController

#pragma mark - Lazy load

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 1;
    [WYProgress show];
    [self loadDataWithPageNo:self.pageNo];
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    self.topView = topView;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = @"以下商品是好麦为您全网搜索的相关产品";
    tipsLabel.textColor = ColorWithHexString(@"#848282");
    tipsLabel.font = TextFont(11);
    [self.topView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView).offset(0);
        make.left.equalTo(self.topView).offset(AUTOSIZESCALEX(10));
    }];

    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = SeparatorLineColor;
    [self.topView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView).offset(0);
        make.left.right.equalTo(self.topView);
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = SeparatorLineColor;
    [self.topView addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView).offset(0);
        make.left.right.equalTo(self.topView);
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - SeparatorLineHeight) / 2, AUTOSIZESCALEX(280));
    layout.minimumLineSpacing = SeparatorLineHeight;
    layout.minimumInteritemSpacing = SeparatorLineHeight;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.hidden = YES;
    collectionView.emptyDataSetDelegate = self;
    collectionView.emptyDataSetSource = self;
    collectionView.backgroundColor = ViewControllerBackgroundColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    //    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(24), 0, AUTOSIZESCALEX(24));
    [collectionView registerClass:[NewGlobalSearchListCell class] forCellWithReuseIdentifier:listCellId];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    WeakSelf
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 获取数据
        [weakSelf loadDataWithPageNo:1];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载更多
        [weakSelf loadDataWithPageNo:weakSelf.pageNo];
    }];
    
    self.collectionView.mj_footer.hidden = YES;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Data

// 加载数据
- (void)loadDataWithPageNo:(NSInteger)pageNo {
    [self getCommodityCategoriesListWithPageNo:pageNo];
}

// 商品分类列表
- (void)getCommodityCategoriesListWithPageNo:(NSInteger)pageNo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSString *userId = [LoginUserDefault userDefault].userItem.userId;
    
    parameters[@"userId"] = userId;
    parameters[@"keyword"] = self.keyword;
    parameters[@"pageNum"] = [NSString stringWithFormat:@"%zd",pageNo];
    
    WeakSelf
    
//    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/tbkSearch" parameters:parameters successBlock:^(id response) {
    [[NetworkSingleton sharedManager] getCoRequestWithUrl:@"/Search" parameters:parameters successBlock:^(id response) {

        weakSelf.collectionView.hidden = NO;
        if ([response[@"code"] integerValue] == 1) {
            NSString *status = response[@"data"][@"status"];
            if ([status isEqualToString:@"1"]) {
                if (pageNo == 1) {
                    weakSelf.pageNo = 1;
                    weakSelf.datasource = [SearchGoodsItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"list"]];
                    [weakSelf.collectionView reloadData];
                } else {
                    [weakSelf.datasource addObjectsFromArray:[SearchGoodsItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"list"]]];
                }
                if ([response[@"data"][@"list"] count] == 0) {
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    if ((weakSelf.datasource.count % 30 != 0) || weakSelf.datasource.count == 0) { // 有余数说明没有下一页了
                        [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                    } else {
                        weakSelf.pageNo++;
                        [weakSelf.collectionView.mj_footer endRefreshing];
                    }
                }
                
                [weakSelf.collectionView reloadData];
            }else{
                NSString *goodsId = response[@"data"][@"id"];
//                SearchGoodsItem *item = [[SearchGoodsItem alloc]init];
//                item.id = goodsId;
                NewSearchGoodsDetailController *detailVc = [[NewSearchGoodsDetailController alloc] init];
                detailVc.itemId = goodsId;
                [self.navigationController pushViewController:detailVc animated:YES];
            }

          
            
        } else {
            [weakSelf.collectionView.mj_footer endRefreshing];
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
        [weakSelf.collectionView.mj_header endRefreshing];
    } failureBlock:^(NSString *error) {
        weakSelf.collectionView.hidden = NO;
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.mj_footer.hidden = (self.datasource.count == 0);
    
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    GlobalSearchListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellId forIndexPath:indexPath];
//    cell.searchItem = self.datasource[indexPath.row];
//    cell.delegate = self;
//    return cell;
    NewGlobalSearchListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellId forIndexPath:indexPath];
    cell.searchGoodsItem = self.datasource[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYLog(@"indexPath = %zd",indexPath.row);
    
//    GlobalSearchDetailController *detailVc = [[GlobalSearchDetailController alloc] init];
//    detailVc.item = self.datasource[indexPath.row];
//    [self.navigationController pushViewController:detailVc animated:YES];
    SearchGoodsItem *item = self.datasource[indexPath.row];
    if ([item.type isEqualToString:@"1"] || [item.type isEqualToString:@"3"]) {
        NSString *userId = [LoginUserDefault userDefault].userItem.userId;
        NSInteger viped = [LoginUserDefault userDefault].userItem.viped;
        NSInteger itemId = [item.id integerValue];
        NSString *qrurl = [NSString stringWithFormat:@"http://haomaimall.lucius.cn/p/%ld?uid=%@&viped=%ld",itemId,userId,(long)viped];
        if (userId == nil) {
            qrurl = [NSString stringWithFormat:@"http://haomaimall.lucius.cn/p/%ld.html",itemId];
        }
        WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
        webVc.urlString = qrurl;
        //    webVc.title = @"我的钱包";
        [self.navigationController pushViewController:webVc animated:YES];
    }
    if ([item.type isEqualToString:@"2"]) {
        NewSearchGoodsDetailController *detailVc = [[NewSearchGoodsDetailController alloc] init];
        detailVc.itemId = self.datasource[indexPath.row][@"id"];
        [self.navigationController pushViewController:detailVc animated:YES];
    }

}

#pragma mark - GlobalSearchListCellDelegate

// 分享好友
- (void)globalSearchListCell:(GlobalSearchListCell *)globalSearchListCell didClickShareButton:(TaoBaoSearchItem *)item {
    WeakSelf
    [LoginUtil loginWithFatherVc:self completedHandler:^{
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        parameters[@"itemId"] = item.itemId;
        [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/tbkDetail" parameters:parameters successBlock:^(id response) {
            if ([response[@"code"] integerValue] == RequestSuccess) {
                weakSelf.detailItem = [TaoBaoSearchDetailItem mj_objectWithKeyValues:response[@"data"]];
                GlobalSearchShareController *shareVc = [[GlobalSearchShareController alloc] init];
                shareVc.listItem = item;
                shareVc.detailItem = weakSelf.detailItem;
                [weakSelf.navigationController pushViewController:shareVc animated:YES];
            } else {
                [WYProgress showErrorWithStatus:response[@"msg"]];
            }
        } failureBlock:^(NSString *error) {
            
        }];
    }];
}

// 立即购买
- (void)globalSearchListCell:(GlobalSearchListCell *)globalSearchListCell didClickBuyButton:(TaoBaoSearchItem *)item {
    WeakSelf
    [LoginUtil loginWithFatherVc:self completedHandler:^{
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
        parameters[@"itemId"] = item.itemId;
        
        [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/clickUrl" parameters:parameters successBlock:^(id response) {
            if ([response[@"code"] integerValue] == RequestSuccess) {
                //根据链接打开页面
                id<AlibcTradePage> page = [AlibcTradePageFactory page: response[@"data"]];
                
                //淘客信息
                AlibcTradeTaokeParams *taoKeParams=[[AlibcTradeTaokeParams alloc] init];
                taoKeParams.pid=nil; //
                //打开方式
                AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
                // 强制跳手淘
                showParam.openType = AlibcOpenTypeNative;
                
                [[AlibcTradeSDK sharedInstance].tradeService show:weakSelf.navigationController page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                    
                } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                    
                }];
            } else {
                [WYProgress showErrorWithStatus:response[@"msg"]];
            }
        } failureBlock:^(NSString *error) {
            
        }];

    }];

    
//    id<AlibcTradePage> page = [AlibcTradePageFactory page: [NSString stringWithFormat:@"http:%@",item.shareUrl]];
//
//    //淘客信息
//    AlibcTradeTaokeParams *taoKeParams=[[AlibcTradeTaokeParams alloc] init];
//    taoKeParams.pid=nil; //
//    //打开方式
//    AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
//    // 强制跳手淘
//    showParam.openType = AlibcOpenTypeNative;
//
//    [[AlibcTradeSDK sharedInstance].tradeService show:self.navigationController page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//
//    } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//
//    }];

}

#pragma mark - DZNEmptyDataSetSource Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ImageWithNamed(@"search_noResultData");
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有搜索结果";
    UIFont *font = [UIFont systemFontOfSize:18.0];
    UIColor *textColor = ColorWithHexString(@"333333");
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有找到相关的宝贝";
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UIColor *textColor = ColorWithHexString(@"999999");
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return RGB(239, 239, 239);
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -0;
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


@end
