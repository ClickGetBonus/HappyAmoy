//
//  BrandSelectionController.m
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BrandSelectionController.h"
#import "SpecialSectionHeaderView.h"
#import "TodayRecommendOfSpecialCell.h"

#import "BrandAreaCell.h"
#import "MustBuyListCell.h"
#import "GoodsListViewController.h"
#import "CommodityListItem.h"
#import "BannerItem.h"
#import "GoodsDetailController.h"
#import "WebViewController.h"

#import "NewBrandTypeCell.h"
#import "NewBrandBanerCell.h"
#import "NewBrandImportCell.h"
#import "BrandSelectionCell.h"

#import "CommodityCategoriesItem.h"
#import "GoodsListOfNewController.h"
#import "GoodsListCell.h"

@interface BrandSelectionController () <UICollectionViewDelegate,UICollectionViewDataSource,BrandAreaCellDelegate,NewBrandTypeCellDelegate,NewBrandBanerCellDelegate,BrandSelectionCellDelegate,NewBrandImportCellDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
/**    banner数组    */
@property (strong, nonatomic) NSMutableArray *bannerArray;
/**    品牌精选商品列表    */
@property (strong, nonatomic) NSMutableArray *ppjxCommodityListArray;
/**    进口优选商品列表    */
@property (strong, nonatomic) NSMutableArray *jkyxCommodityListArray;
/**    页码    */
@property (assign, nonatomic) NSInteger pageNo;
/**    商品分类数组    */
@property(nonatomic,strong) NSMutableArray *categoriesArray;
/**    置顶按钮    */
@property(nonatomic,strong) UIButton *topButton;

@end

static NSString *const brandTypeCellId = @"brandTypeCellId";
static NSString *const bannerCellId = @"bannerCellId";
static NSString *const importCellId = @"importCellId";
static NSString *const brandSelectionCellId = @"brandSelectionCellId";

@implementation BrandSelectionController

#pragma mark - Lazy load

- (NSMutableArray *)bannerArray {
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)categoriesArray {
    if (!_categoriesArray) {
        _categoriesArray = [NSMutableArray array];
    }
    return _categoriesArray;
}

- (NSMutableArray *)jkyxCommodityListArray {
    if (!_jkyxCommodityListArray) {
        _jkyxCommodityListArray = [NSMutableArray array];
    }
    return _jkyxCommodityListArray;
}

- (NSMutableArray *)ppjxCommodityListArray {
    if (!_ppjxCommodityListArray) {
        _ppjxCommodityListArray = [NSMutableArray array];
    }
    return _ppjxCommodityListArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"品牌精选";
    self.view.backgroundColor = FooterViewBackgroundColor;
    self.pageNo = 1;
    
    [self loadDataWithPageNo:self.pageNo];
    [self setupUI];
}

#pragma mark Data

// 加载数据
- (void)loadDataWithPageNo:(NSInteger)pageNo {
    [self moduleCategories];
    [self getBannerData];
    [self getJKYXCommodityList];
    [self getPPJXCommodityListWithPageNo:pageNo];
}

// 加载更多数据
- (void)loadMoreDataWithPageNo:(NSInteger)pageNo {
    [self getPPJXCommodityListWithPageNo:pageNo];
}

// 轮播图
- (void)getBannerData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"type"] = @"2";
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/banners" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.bannerArray = [BannerItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [weakSelf.collectionView reloadData];
        } else {
            [WYHud showMessage:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 品牌精选商品分类
- (void)moduleCategories {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 1-爱生活 2-品牌精选
    parameters[@"module"] = @"2";
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/moduleCategories" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.categoriesArray = [CommodityCategoriesItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            [weakSelf.collectionView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 进口优选列表
- (void)getJKYXCommodityList {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //    parameters[@"module"] = @"2";
    parameters[@"imported"] = @"1";
    parameters[@"page"] = @"1";
    parameters[@"size"] = @"50";
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
        
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.jkyxCommodityListArray = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
            [weakSelf.collectionView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
        
    } failureBlock:^(NSString *error) {
        
    }];
}

// 品牌精选商品列表
- (void)getPPJXCommodityListWithPageNo:(NSInteger)pageNo {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"module"] = @"2";
    parameters[@"imported"] = @"0";
    parameters[@"page"] = [NSString stringWithFormat:@"%zd",pageNo];
    parameters[@"size"] = [NSString stringWithFormat:@"%zd",PageSize];
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/commodities" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            if (pageNo == 1) {
                weakSelf.pageNo = 1;
                weakSelf.ppjxCommodityListArray = [CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]];
                [weakSelf.collectionView reloadData];
            } else {
                [weakSelf.ppjxCommodityListArray addObjectsFromArray:[CommodityListItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"datas"]]];
            }
            if ([response[@"data"][@"datas"] count] == 0) {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            } else {
                if ((weakSelf.ppjxCommodityListArray.count % PageSize != 0) || weakSelf.ppjxCommodityListArray.count == 0) { // 有余数说明没有下一页了
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

#pragma mark - UI

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    layout.headerReferenceSize = CGSizeMake(AUTOSIZESCALEX(100), AUTOSIZESCALEX(200));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = ViewControllerBackgroundColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerClass:[NewBrandTypeCell class] forCellWithReuseIdentifier:brandTypeCellId];
    [collectionView registerClass:[NewBrandImportCell class] forCellWithReuseIdentifier:importCellId];
    [collectionView registerClass:[NewBrandBanerCell class] forCellWithReuseIdentifier:bannerCellId];
    [collectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:brandSelectionCellId];
    
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeaderOfThird"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeaderOfFourth"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter"];
    
//    [collectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:mustBuyCellId];
    
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
        [weakSelf loadMoreDataWithPageNo:weakSelf.pageNo];
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.view).offset(-kTabbar_Bottum_Height-SafeAreaBottomHeight);
    }];

    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[topButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    }];
    [topButton setImage:ImageWithNamed(@"置顶") forState:UIControlStateNormal];
    [self.view addSubview:topButton];
    self.topButton = topButton;
    
    [self.topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-kTabbar_Bottum_Height-SafeAreaBottomHeight-AUTOSIZESCALEX(25));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-12.5));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(40), AUTOSIZESCALEX(40)));
    }];
    
    UIView *line = [UIView separatorLine:CGRectMake(0, kNavHeight, SCREEN_WIDTH, SeparatorLineHeight)];
    [self.view addSubview:line];

}

#pragma mark - Button Action
// 点击轮播图
- (void)didClickBannerWithBannerId:(NSString *)bannerId {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:[NSString stringWithFormat:@"/system/banner/%@",bannerId] parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            
        } else {
            
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    self.collectionView.mj_footer.hidden = (self.ppjxCommodityListArray.count == 0);

    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return self.ppjxCommodityListArray.count;
    }
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 2) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeaderOfThird" forIndexPath:indexPath];
            [headerView addSubview:[self thirdSectionHeaderView]];
            return headerView;
        } else if (indexPath.section == 3) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionElementKindSectionHeaderOfFourth" forIndexPath:indexPath];
            [headerView addSubview:[self fourthSectionHeaderView]];
            return headerView;
        }
    } else {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"UICollectionElementKindSectionFooter" forIndexPath:indexPath];
        footerView.backgroundColor = ViewControllerBackgroundColor;
        return footerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 2 || section == 3) {
        return CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(55));
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(5));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(240));
    } else if (indexPath.section == 1) {
        return CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(150));
    } else if (indexPath.section == 2) {
        return CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(260));
    } else if (indexPath.section == 3) {
        return CGSizeMake((SCREEN_WIDTH) * 0.5 - 0.5, AUTOSIZESCALEX(280));
    }
    return CGSizeMake(AUTOSIZESCALEX(150), AUTOSIZESCALEX(150));
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 模块分类
        NewBrandTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandTypeCellId forIndexPath:indexPath];
        cell.datasource = self.categoriesArray;
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 1) { // 轮播图
        NewBrandBanerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerCellId forIndexPath:indexPath];
        cell.delegate = self;
        cell.datasource = self.bannerArray;
        return cell;
    } else if (indexPath.section == 2) { // 进口优选
        NewBrandImportCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:importCellId forIndexPath:indexPath];
        cell.datasource = self.jkyxCommodityListArray;
        cell.delegate = self;
        return cell;
    } else if (indexPath.section == 3) { // 品牌精选
        GoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandSelectionCellId forIndexPath:indexPath];
        cell.item = self.ppjxCommodityListArray[indexPath.row];
        return cell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = RandomColor;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        GoodsDetailController *detailVc = [[GoodsDetailController alloc] init];
        detailVc.item = self.ppjxCommodityListArray[indexPath.row];;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > AUTOSIZESCALEX(2000)) {
        self.topButton.hidden = NO;
    } else {
        self.topButton.hidden = YES;
    }
}

#pragma mark - Private method

- (UIView *)thirdSectionHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(55))];
    headerView.backgroundColor = QHWhiteColor;
    
    UIButton *line = [UIButton buttonWithType:UIButtonTypeCustom];
    line.frame = CGRectMake(AUTOSIZESCALEX(10), AUTOSIZESCALEX(13.5), AUTOSIZESCALEX(3), AUTOSIZESCALEX(23));
    [line gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(3), AUTOSIZESCALEX(23)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [headerView addSubview:line];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(AUTOSIZESCALEX(23), AUTOSIZESCALEX(15), AUTOSIZESCALEX(100), AUTOSIZESCALEX(20))];
    descLabel.text = @"进口优选";
    descLabel.textColor = ColorWithHexString(@"#575054");
    descLabel.font = AppMainTextFont(16);
    [headerView addSubview:descLabel];
    
    UIView *bottomLine = [UIView separatorLine:CGRectMake(0, AUTOSIZESCALEX(49.5), SCREEN_WIDTH, AUTOSIZESCALEX(0.5))];
    [headerView addSubview:bottomLine];
    
    return headerView;
}


- (UIView *)fourthSectionHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(55))];
    headerView.backgroundColor = QHWhiteColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"装饰")];
    imageView.frame = CGRectMake(AUTOSIZESCALEX(40), 0, headerView.width - AUTOSIZESCALEX(40) * 2, AUTOSIZESCALEX(9));
    imageView.center = headerView.center;
    [headerView addSubview:imageView];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(DynamicContentLeftSpace, AUTOSIZESCALEX(15), headerView.width - AUTOSIZESCALEX(30), AUTOSIZESCALEX(20))];
    descLabel.text = @"品牌精选";
    descLabel.font = AppMainTextFont(16);
    [headerView addSubview:descLabel];
    [descLabel sizeToFit];
    descLabel.height = AUTOSIZESCALEX(20);
    descLabel.center = headerView.center;
    
    // 文字渐变
    [WYUtils TextGradientview:descLabel bgVIew:headerView gradientColors:@[(id)ColorWithHexString(@"#ffb42b").CGColor, (id)ColorWithHexString(@"#ffb42b").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
    
    UIView *line = [UIView separatorLine:CGRectMake(0, AUTOSIZESCALEX(49.5), SCREEN_WIDTH, AUTOSIZESCALEX(0.5))];
    [headerView addSubview:line];
    
    return headerView;
}

#pragma mark - NewBrandTypeCellDelegate

- (void)newBrandTypeCell:(NewBrandTypeCell *)newBrandTypeCell didSelectItem:(CommodityCategoriesItem *)item {
    GoodsListViewController *listVc = [[GoodsListViewController alloc] init];
    listVc.module = @"2";
    listVc.moduleCategoryId = item.categoriesId;
    listVc.title = item.name;
    [self.navigationController pushViewController:listVc animated:YES];
}

#pragma mark - NewBrandBanerCellDelegate

- (void)newBrandBanerCell:(NewBrandBanerCell *)newBrandBanerCell didClickBanner:(BannerItem *)item {
    if (item.urlType == 1) { // 页面url
        WebViewController *webVc = [[WebViewController alloc] init];
        webVc.urlString = item.target;
        webVc.title = item.title;
        [self.navigationController pushViewController:webVc animated:YES];
    } else if (item.urlType == 2) { // 特色分类列表
        GoodsListOfNewController *listVc = [[GoodsListOfNewController alloc] init];
        listVc.specialCategoriesId = item.target;
        listVc.title = item.title;
        [self.navigationController pushViewController:listVc animated:YES];
    }
    [self didClickBannerWithBannerId:item.bannerId];
}

#pragma mark - NewBrandImportCellDelegate

- (void)newBrandImportCell:(NewBrandImportCell *)newBrandImportCell didSelectItem:(CommodityListItem *)item {
    GoodsDetailController *detailVc = [[GoodsDetailController alloc] init];
    detailVc.item = item;
    [self.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - BrandSelectionCellDelegate

- (void)brandSelectionCell:(BrandSelectionCell *)brandSelectionCell didSelectItem:(CommodityListItem *)item {
    GoodsDetailController *detailVc = [[GoodsDetailController alloc] init];
    detailVc.item = item;
    [self.navigationController pushViewController:detailVc animated:YES];
}


@end
