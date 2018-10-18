//
//  WYLaunchViewController.m
//  DianDian
//
//  Created by apple on 17/11/23.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "WYLaunchViewController.h"
#import "QHNewFeatureCell.h"
#import "LoginViewController.h"
#import "BootPagesItem.h"
#import "WYTabBarController.h"
#import "WYDrawCircleProgressView.h"

@interface WYLaunchViewController () <UICollectionViewDelegate,UICollectionViewDataSource,QHNewFeatureCellDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
/**    分页指示器    */
@property (strong, nonatomic) UIPageControl *pageControl;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
// 跳过按钮
@property (nonatomic, strong) WYDrawCircleProgressView *drawCircleBtn;

@end

static NSString *const adCellId = @"adCellId";

@implementation WYLaunchViewController

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
    
    [self getBootPages];
}

#pragma mark - Data

// 获取启动页列表
- (void)getBootPages {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/bootPages" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.datasource = [BootPagesItem mj_objectArrayWithKeyValuesArray:response[@"data"]];
            //            weakSelf.pageControl.numberOfPages = weakSelf.datasource.count;
            [weakSelf.collectionView reloadData];
        } else {
            [WYHud showMessage:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
    
}
#pragma mark - UI

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:SCREEN_FRAME collectionViewLayout:layout];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = NO;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[QHNewFeatureCell class] forCellWithReuseIdentifier:adCellId];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    // 2.跳过按钮
    WYDrawCircleProgressView *drawCircleBtn = [[WYDrawCircleProgressView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 30, 40, 40)];
    drawCircleBtn.lineWidth = 2;
    drawCircleBtn.trackColor = QHWhiteColor;
    drawCircleBtn.progressColor = [UIColor blueColor];
    [drawCircleBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [drawCircleBtn setTitleColor:QHBlackColor forState:UIControlStateNormal];
    drawCircleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [drawCircleBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:drawCircleBtn];
    self.drawCircleBtn = drawCircleBtn;
    
    [self.drawCircleBtn startAnimationDuration:5 withBlock:^{
        [UIApplication sharedApplication].keyWindow.rootViewController =  [[WYTabBarController alloc] init];
    }];
    
    
    // 添加分页指示器
    //    UIPageControl *pageControl = [[UIPageControl alloc] init];
    //    pageControl.numberOfPages = 3;
    //    pageControl.pageIndicatorTintColor = QHWhiteColor;
    //    pageControl.currentPageIndicatorTintColor = RGB(42, 162, 255);
    //
    //    pageControl.center = CGPointMake(SCREEN_WIDTH * 0.5, SCREEN_HEIGHT - 25);
    //    self.pageControl = pageControl;
    //    [self.view addSubview:self.pageControl];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count == 0 ? 1 : self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QHNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:adCellId forIndexPath:indexPath];
    
    cell.delegate = self;
    if (self.datasource.count == 0) {
        cell.featureImage = [UIImage imageNamed:[NSString stringWithFormat:@"launch"]];
    } else {
        cell.item = self.datasource[indexPath.row];
    }
    cell.isLastFeature = NO;

    return cell;
}

// 滚动就会调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获取当前的偏移量，计算当前第几页
    //    int number = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    //
    //    self.pageControl.currentPage = number;
}

#pragma mark - QHNewFeatureCellDelegate
// 即刻开启
- (void)newFeatureCell:(QHNewFeatureCell *)newFeatureCell didClickStartAtOnce:(UIButton *)sender {
    WYFunc
    
    [UIApplication sharedApplication].keyWindow.rootViewController =  [[WYTabBarController alloc] init];
}

#pragma mark - Button action

// 跳过
- (void)jump {
    [UIApplication sharedApplication].keyWindow.rootViewController =  [[WYTabBarController alloc] init];
}




//#pragma mark - Lazy load
//
//- (NSMutableArray *)datasource {
//    if (!_datasource) {
//        _datasource = [NSMutableArray array];
//    }
//    return _datasource;
//}
//
//- (void)viewDidLoad {
//    
//    [super viewDidLoad];
//
//    self.view.backgroundColor = ViewControllerBackgroundColor;
//    
//    // 设置启动图
//    [self setupLaunchImage];
//    
//}
//
//#pragma mark - 添加启动图
//- (void)setupLaunchImage {
//    
//    UIImageView *launchImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    
//    launchImageView.image = [UIImage imageNamed:@"launch_imag.png"];
//    
//    [self.view addSubview:launchImageView];
//    
//}

@end
