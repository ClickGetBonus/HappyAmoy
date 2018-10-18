//
//  NewSearchViewController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewSearchViewController.h"
#import "SearchView.h"
#import "MustBuyListCell.h"
//#import "CommodityListItem.h"
#import "GoodsListCell.h"
#import "NewSearchDetailController.h"
#import "TaoBaoSearchItem.h"

@interface NewSearchViewController () <UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,SearchViewDelegate>

/**    搜索框    */
@property (strong, nonatomic) SearchView *searchView;
/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;

@end

static NSString *const searchCellId = @"searchCellId";

@implementation NewSearchViewController

#pragma mark - Lazy load
- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    if (![NSString isEmpty:self.content]) {
        [self getCommodityListWithPageNo:1 keywords:self.content];
    } else {
        self.collectionView.hidden = YES;
    }
}

#pragma mark - UI

- (void)setupUI {
    
    SearchView *searchView = [[SearchView alloc] initWithFrame:CGRectMake(0, 0, AUTOSIZESCALEX(295), AUTOSIZESCALEX(28))];
    searchView.keyword = self.content;
    searchView.delegate = self;
    self.navigationItem.titleView = searchView;
    self.searchView = searchView;
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(90), 30));
    }];
    if ([NSString isEmpty:self.content]) {
        [searchView beginEditingWithContent:self.content];
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - SeparatorLineHeight) / 2, AUTOSIZESCALEX(280));
    layout.minimumLineSpacing = SeparatorLineHeight;
    layout.minimumInteritemSpacing = SeparatorLineHeight;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.emptyDataSetDelegate = self;
    collectionView.emptyDataSetSource = self;
    collectionView.backgroundColor = ViewControllerBackgroundColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:searchCellId];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    WeakSelf
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 获取数据
        [weakSelf getCommodityListWithPageNo:1 keywords:weakSelf.content];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载更多
        [weakSelf getCommodityListWithPageNo:weakSelf.pageNo keywords:weakSelf.content];
    }];
    
    self.collectionView.mj_footer.hidden = YES;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Data

// 商品分类列表
- (void)getCommodityListWithPageNo:(NSInteger)pageNo keywords:(NSString *)keywords {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSString *userId = [LoginUserDefault userDefault].userItem.userId;

    parameters[@"keyword"] = keywords;
    parameters[@"pageNum"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"userId"] = userId;

    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/tbkSearch" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.collectionView.hidden = NO;
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.datasource = [TaoBaoSearchItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
                [weakSelf.collectionView reloadData];
            } else {
                [weakSelf.datasource addObjectsFromArray:[TaoBaoSearchItem mj_objectArrayWithKeyValuesArray:response[@"data"]]];
            }
            if ([response[@"data"] count] == 0) {
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

        } else {
            [weakSelf.collectionView.mj_footer endRefreshing];
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
        [weakSelf.collectionView.mj_header endRefreshing];
    } failureBlock:^(NSString *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

#pragma mark - Button Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchView endEditing];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.mj_footer.hidden = (self.datasource.count == 0);
    
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:searchCellId forIndexPath:indexPath];
    cell.searchItem = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYLog(@"indexPath = %zd",indexPath.row);
    [self.searchView endEditing];
    
    NewSearchDetailController *detailVc = [[NewSearchDetailController alloc] init];
    detailVc.item = self.datasource[indexPath.row];
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![NSString isEmpty:self.content]) {
        [self.searchView endEditing];
    }
}

#pragma mark - SearchViewDelegate

- (void)searchView:(SearchView *)searchView searchWithContent:(NSString *)content {
    self.content = content;
    [self getCommodityListWithPageNo:1 keywords:content];
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
