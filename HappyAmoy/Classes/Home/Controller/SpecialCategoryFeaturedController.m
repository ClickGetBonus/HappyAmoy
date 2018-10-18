//
//  SpecialCategoryFeaturedController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SpecialCategoryFeaturedController.h"
#import "GoodsListCell.h"
#import "BrandSellerListItem.h"
#import "CommodityListItem.h"
#import "CommodityCategoriesItem.h"
#import "GoodsDetailController.h"
#import "CommoditySpecialCategoriesItem.h"

#import "ClassifyItem.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SpecialCategoryFeaturedController () <UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,GoodsListCellDelegate>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;

@end

static NSString *const listCellId = @"listCellId";

@implementation SpecialCategoryFeaturedController

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
    
    [self setupUI];
    [self loadDataWithPageNo:self.pageNo];
}

#pragma mark - UI

- (void)setupUI {
    
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
    //    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(24), 0, AUTOSIZESCALEX(24));
    [collectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:listCellId];
    
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
        make.edges.equalTo(self.view);
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
    
    if (![NSString isEmpty:self.specialCategoryId]) {
        parameters[@"specialCategoryId"] = self.specialCategoryId;
    }
    if (![NSString isEmpty:self.categoryId]) {
        parameters[@"categoryId"] = self.categoryId;
    }

    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
        [weakSelf handleData:response pageNo:pageNo];
    } failureBlock:^(NSString *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

// 统一处理数据
- (void)handleData:(id)response pageNo:(NSInteger)pageNo {
    WeakSelf
    if ([response[@"code"] integerValue] == RequestSuccess) {
        if (pageNo == 1) {
            weakSelf.pageNo = 1;
            weakSelf.datasource = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            [weakSelf.collectionView reloadData];
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
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.collectionView.mj_footer.hidden = (self.datasource.count == 0);
    
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellId forIndexPath:indexPath];
    cell.isVideoType = self.isVideoType;
    cell.item = self.datasource[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYLog(@"indexPath = %zd",indexPath.row);
    
    GoodsDetailController *detailVc = [[GoodsDetailController alloc] init];
    detailVc.item = self.datasource[indexPath.row];
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - GoodsListCellDelegate
// 播放视频
- (void)goodsListCell:(GoodsListCell *)goodsListCell didPlayVideo:(CommodityListItem *)item {
    if ([NSString isEmpty:item.videoUrl]) {
        [WYProgress showErrorWithStatus:@"播放链接失效！"];
        return;
    }
    // iOS9 苹果推荐使用的方法
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:item.videoUrl]];
    AVPlayerViewController *playerVc = [[AVPlayerViewController alloc] init];
    playerVc.player = player;
    // 一点进去就开始播放
    [playerVc.player play];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:playerVc animated:YES completion:nil];
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


@end
