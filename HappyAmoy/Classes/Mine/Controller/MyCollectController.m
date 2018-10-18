//
//  MyCollectController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyCollectController.h"
#import "GoodsListCell.h"
#import "CommodityListItem.h"
#import "GoodsDetailController.h"

@interface MyCollectController () <UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,GoodsListCellDelegate>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;
/**    数据列表    */
@property (strong, nonatomic) NSMutableArray *datasource;

@end

static NSString *const listCellId = @"listCellId";

@implementation MyCollectController

#pragma mark - Lazy load

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"我的收藏";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.pageNo = 1;

    [self setupUI];
    [self.collectionView.mj_header beginRefreshing];
//    [self getCollectionsDataWithPageNo:self.pageNo];
    
    WeakSelf
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MyCollectDidCancelNotificationName object:nil] subscribeNext:^(id x) {
        [weakSelf getCollectionsDataWithPageNo:1];
    }];
}

#pragma mark - UI

- (void)setupUI {
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(0));
        make.left.right.equalTo(self.view);
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
    collectionView.emptyDataSetDelegate = self;
    collectionView.emptyDataSetSource = self;
    collectionView.backgroundColor = ViewControllerBackgroundColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:listCellId];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    WeakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCollectionsDataWithPageNo:1];
    }];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getCollectionsDataWithPageNo:_pageNo];
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Data

- (void)getCollectionsDataWithPageNo:(NSInteger)pageNo {
    
    WeakSelf
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];;

    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/personal/collections" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.datasource = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            } else {
                [weakSelf.datasource addObjectsFromArray:[CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
            }
            if ([response[@"data"][@"datas"] count] == 0) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                if ((weakSelf.datasource.count % PageSize != 0) || weakSelf.datasource.count == 0) { // 有余数说明没有下一页了
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
    } shouldDismissHud:NO];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.mj_footer.hidden = (self.datasource.count == 0);
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellId forIndexPath:indexPath];
    cell.isCollected = YES;
    cell.delegate = self;
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsDetailController *detailVc = [[GoodsDetailController alloc] init];
    detailVc.item = self.datasource[indexPath.row];
    [self.navigationController pushViewController:detailVc animated:YES];

}

#pragma mark - DZNEmptyDataSetSource Methods

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return ImageWithNamed(@"收藏无数据");
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"暂时没有收藏喔";
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

#pragma mark - GoodsListCellDelegate
// 取消收藏
- (void)goodsListCell:(id)goodsListCell didCancelCollected:(CommodityListItem *)item {
    WYLog(@"取消收藏");
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] postRequestWithUrl:[NSString stringWithFormat:@"/personal/collection/%@/delete",item.currentId] parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [WYProgress showSuccessWithStatus:@"取消收藏成功!"];
            [weakSelf.datasource removeObject:item];
            [weakSelf.collectionView reloadData];
        } else {
            [WYProgress showErrorWithStatus:@"取消收藏失败!"];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}


#pragma mark - Private method

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
