//
//  NewSearchGoodsDetailController.m
//  HappyAmoy
//
//  Created by VictoryLam on 2018/10/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewSearchGoodsDetailController.h"
#import "MessageNoticeController.h"
#import "CustomSearchView.h"
#import "GoodsClassifiCell.h"
#import "MustBuyListCell.h"
#import "PlatfomrCharacterCell.h"
#import "GoodsListViewController.h"
#import "BrandAreaController.h"
#import "GoodsDetailController.h"
#import "GoodsDetailInfoCell.h"
#import "GoodsRecommendReasonsCell.h"
#import "GoodsDetailWebCell.h"
#import "CommodityListItem.h"
#import "CommodityDetailItem.h"
#import <WebKit/WebKit.h>
#import "ShareController.h"
#import "SearchGoodsItem.h"

#import "NewGlobalSearchListCell.h"
#import "GlobalSearchListCell.h"
#import "WebViewH5Controller.h"

#import <AlibcTradeSDK/AlibcTradeSDK.h>

@interface NewSearchGoodsDetailController ()<UITableViewDelegate,UITableViewDataSource,GoodsClassifiCellDelegate,PlatfomrCharacterCellDelegate,GoodsDetailInfoCellDelegate,WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,NewGlobalSearchListCellDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    轮播图    */
//@property (strong, nonatomic) WYCarouselView *headerView;
/**    轮播图    */
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/**    详情模型    */
@property (strong, nonatomic) CommodityDetailItem *detailItem;
/**    购买按钮    */
@property (strong, nonatomic) UIButton *buyButton;
/**    收藏按钮    */
@property (strong, nonatomic) UIButton *collectedButton;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSAttributedString *attribute;
//类似tabelView的缓冲池，用于存放图片大小
@property (nonatomic, strong) NSCache *imageSizeCache;

@property (strong, nonatomic) UIView *topView;
/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;

@property (assign, nonatomic) BOOL loadFailed;

@end

static NSString *const goodsInfoCellId = @"goodsInfoCellId";
static NSString *const recommendCellId = @"recommendCellId";
static NSString *const webCellId = @"webCellId";
static NSString *const listCellId = @"listCellId";

@implementation NewSearchGoodsDetailController

- (NSCache *)imageSizeCache {
    if (!_imageSizeCache) {
        _imageSizeCache = [[NSCache alloc] init];
    }
    return _imageSizeCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupNav];
    [self detailData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    
    //    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Data

- (void)detailData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //    NSInteger itemId = [self.item.id integerValue];
    parameters[@"id"] = self.itemId;
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    WeakSelf
    [[NetworkSingleton sharedManager] getCoRequestWithUrl:@"/GoodsDetail" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == 1) {
            
            if ([response[@"data"][@"status"] integerValue] == 0) {
                
                
                weakSelf.detailItem = [CommodityDetailItem mj_objectWithKeyValues:response[@"data"][@"detail"]];
                [self setupBottomView];
                [weakSelf screenShots];
                //            [weakSelf.buyButton setTitle:[NSString stringWithFormat:@"  ¥ %.2f\n折扣价购买",weakSelf.detailItem.discountPrice] forState:UIControlStateNormal];
                [weakSelf.buyButton setTitle:[NSString stringWithFormat:@"领券￥%@",weakSelf.detailItem.couponAmount] forState:UIControlStateNormal];
                weakSelf.cycleScrollView.imageURLStringsGroup = weakSelf.detailItem.imageUrls;
                [weakSelf.tableView reloadData];
                if (weakSelf.detailItem.collected == 0) { // 未收藏
                    [weakSelf.collectedButton setImage:ImageWithNamed(@"收藏") forState:UIControlStateNormal];
                } else { // 已收藏
                    [weakSelf.collectedButton setImage:ImageWithNamed(@"已收藏") forState:UIControlStateNormal];
                }
                weakSelf.datasource = [SearchGoodsItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"others"]];
                [self setupCollectionUI];
                
                [weakSelf.collectionView reloadData];
            } else {
                
                self.loadFailed = YES;
                
                [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(weakSelf.view).offset(SafeAreaBottomHeight);
                }];
                weakSelf.datasource = [SearchGoodsItem mj_objectArrayWithKeyValuesArray:response[@"data"][@"others"]];
                [self setupNothingView];
                [self setupCollectionUI];
                [weakSelf.tableView reloadData];
                [weakSelf.collectionView reloadData];
            }
            
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - Nav

- (void)setupNav {
    //    商品详情返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageOriginalWithNamed:@"商品详情返回"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    //    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:ImageWithNamed(@"商品详情返回") highlightImage:ImageWithNamed(@"商品详情返回") buttonSize:CGSizeMake(30, 30) target:self action:@selector(backClick) imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

// 返回
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(-kNavHeight, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    tableView.estimatedRowHeight = 0;
    //    tableView.estimatedSectionFooterHeight = 0;
    //    tableView.estimatedSectionHeaderHeight = 0;
    tableView.tableHeaderView = self.cycleScrollView;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[GoodsDetailInfoCell class] forCellReuseIdentifier:goodsInfoCellId];
    [tableView registerClass:[GoodsRecommendReasonsCell class] forCellReuseIdentifier:recommendCellId];
    [tableView registerClass:[GoodsDetailWebCell class] forCellReuseIdentifier:webCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WeakSelf
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.right.equalTo(weakSelf.view).offset(0);
        make.bottom.equalTo(weakSelf.view).offset(AUTOSIZESCALEX(-50) - SafeAreaBottomHeight);
    }];
    
    // 顶部分割线
    //    UIView *line = [[UIView alloc] init];
    //    line.backgroundColor = [UIColor lightGrayColor];
    //    [self.view addSubview:line];
    //
    //    [line mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(self.view).offset(0);
    //        make.top.equalTo(self.view).offset(kNavHeight);
    //        make.height.mas_equalTo(SeparatorLineHeight);
    //    }];
}

- (void)setupNothingView {
    
    UIView *nothingHeaderView = [[UIView alloc]initWithFrame:CGRectZero];
    nothingHeaderView.frame = CGRectMake(0, 0, self.view.width, AUTOSIZESCALEY(150));
    nothingHeaderView.backgroundColor = [UIColor whiteColor];
   
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, nothingHeaderView.width, AUTOSIZESCALEX(20))];
    descLabel.text = @"该商品没有优惠券领取";
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = TextFont(18);
    [descLabel sizeToFit];
    descLabel.height = AUTOSIZESCALEX(20);
    descLabel.centerX = self.view.width/2;
    descLabel.centerY = nothingHeaderView.height/2;
    [nothingHeaderView addSubview:descLabel];
    
    [WYUtils TextGradientview:descLabel bgVIew:nothingHeaderView gradientColors:@[(id)ColorWithHexString(@"#ffb42b").CGColor, (id)ColorWithHexString(@"#ffb42b").CGColor] gradientStartPoint:CGPointMake(0, 0) endPoint:CGPointMake(20, 20)];
    
    
    self.tableView.tableHeaderView = nothingHeaderView;
}

- (void)setupCollectionUI {
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectZero];
    float height = (self.datasource.count/2)*AUTOSIZESCALEX(280) + AUTOSIZESCALEX(40);
    footerView.frame = CGRectMake(0, 0, self.view.width, height);
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:topView];
    self.topView = topView;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView);
        make.left.right.equalTo(footerView);
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"商品详情页装饰")];
    lineImageView.frame = CGRectMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(18), SCREEN_WIDTH - AUTOSIZESCALEX(100), AUTOSIZESCALEX(6));
    [topView addSubview:lineImageView];
    
    // 文字渐变
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, footerView.width, AUTOSIZESCALEX(20))];
    descLabel.text = @"更多宝贝";
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.font = TextFont(15);
    [descLabel sizeToFit];
    descLabel.height = AUTOSIZESCALEX(20);
    descLabel.centerX = footerView.centerX;
    descLabel.centerY = AUTOSIZESCALEX(20);
    [self.topView addSubview:descLabel];
    //    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.topView).offset(0);
    //        make.left.equalTo(self.topView).offset(AUTOSIZESCALEX(10));
    //    }];
    [WYUtils TextGradientview:descLabel bgVIew:topView gradientColors:@[(id)ColorWithHexString(@"#ffb42b").CGColor, (id)ColorWithHexString(@"#ffb42b").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
    
    //    UIView *line1 = [[UIView alloc] init];
    //    line1.backgroundColor = SeparatorLineColor;
    //    [self.topView addSubview:line1];
    //
    //    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.topView).offset(0);
    //        make.left.right.equalTo(self.topView);
    //        make.height.mas_equalTo(SeparatorLineHeight);
    //    }];
    //
    //    UIView *line2 = [[UIView alloc] init];
    //    line2.backgroundColor = SeparatorLineColor;
    //    [self.topView addSubview:line2];
    //
    //    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.equalTo(self.topView).offset(0);
    //        make.left.right.equalTo(self.topView);
    //        make.height.mas_equalTo(SeparatorLineHeight);
    //    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - SeparatorLineHeight) / 2, AUTOSIZESCALEX(280));
    layout.minimumLineSpacing = SeparatorLineHeight;
    layout.minimumInteritemSpacing = SeparatorLineHeight;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 0, footerView.width, footerView.height) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //    collectionView.hidden = YES;
    collectionView.emptyDataSetDelegate = self;
    collectionView.emptyDataSetSource = self;
    collectionView.backgroundColor = ViewControllerBackgroundColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    //    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(24), 0, AUTOSIZESCALEX(24));
    [collectionView registerClass:[NewGlobalSearchListCell class] forCellWithReuseIdentifier:listCellId];
    collectionView.scrollEnabled = NO;
    [footerView addSubview:collectionView];
    self.collectionView = collectionView;
    
    //    WeakSelf
    //    // 下拉刷新
    //    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    //        // 获取数据
    //        [weakSelf loadDataWithPageNo:1];
    //    }];
    //
    //    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    //        // 上拉加载更多
    //        [weakSelf loadDataWithPageNo:weakSelf.pageNo];
    //    }];
    
    self.collectionView.mj_footer.hidden = YES;
    //    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.topView.mas_bottom).offset(AUTOSIZESCALEX(0));
    //        make.left.right.bottom.equalTo(footerView);
    //    }];
    self.collectionView.frame = CGRectMake(0, 30, footerView.width, height -AUTOSIZESCALEX(40));
    self.tableView.tableFooterView = footerView;
}
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        WeakSelf
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(375)) delegate:nil placeholderImage:PlaceHolderMainImage];
        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            if (weakSelf.detailItem.imageUrls.count > 0) {
                [WYPackagePhotoBrowser showPhotoWithUrlArray:[NSMutableArray arrayWithArray:weakSelf.detailItem.imageUrls] currentIndex:currentIndex];
            }
        };
        _cycleScrollView = cycleScrollView;
    }
    return _cycleScrollView;
}

// 底部工具条
- (void)setupBottomView {
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = QHWhiteColor;
    [self.view addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight);
        make.height.mas_equalTo(AUTOSIZESCALEX(49));
    }];
    
    WeakSelf
    
    UIButton *collectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [collectedButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectedButton setTitleColor:ColorWithHexString(@"666666") forState:UIControlStateNormal];
    collectedButton.titleLabel.font = TextFont(13);
    [collectedButton setImage:ImageWithNamed(@"收藏") forState:UIControlStateNormal];
    [[collectedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            parameters[@"customerId"] = [LoginUserDefault userDefault].userItem.userId;
            parameters[@"type"] = @"1";
            parameters[@"targetId"] = weakSelf.itemId;
            [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/collection/add" parameters:parameters successBlock:^(id response) {
                if ([response[@"code"] integerValue] == RequestSuccess) {
                    if (weakSelf.detailItem.collected == 0) { // 收藏
                        weakSelf.detailItem.collected = 1;
                        [WYProgress showSuccessWithStatus:@"收藏成功!"];
                        [sender setImage:ImageWithNamed(@"已收藏") forState:UIControlStateNormal];
                    } else {
                        weakSelf.detailItem.collected = 0;
                        [WYProgress showSuccessWithStatus:@"取消收藏成功!"];
                        [sender setImage:ImageWithNamed(@"收藏") forState:UIControlStateNormal];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:MyCollectDidCancelNotificationName object:nil];
                } else {
                    [WYProgress showErrorWithStatus:response[@"msg"]];
                }
            } failureBlock:^(NSString *error) {
                
            }];
        }];
    }];
    [bottomView addSubview:collectedButton];
    
    [collectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(75));
    }];
    
    collectedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [collectedButton setTitleEdgeInsets:UIEdgeInsetsMake(collectedButton.imageView.frame.size.height + 5 ,-collectedButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [collectedButton setImageEdgeInsets:UIEdgeInsetsMake(-collectedButton.titleLabel.bounds.size.height - 0, 0.0,0.0, -collectedButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    self.collectedButton = collectedButton;
    
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [shareButton setTitle:[NSString stringWithFormat:@"      分享好友\n预估佣金￥%.2f",self.item.mineCommision] forState:UIControlStateNormal];
    [shareButton setTitle:[NSString stringWithFormat:@"分享好友\n预估麦穗 %@",self.detailItem.mineCommision] forState:UIControlStateNormal];
    shareButton.titleLabel.numberOfLines = 0;
    shareButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [shareButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    [shareButton setBackgroundImage:ImageWithNamed(@"分享好友背景图片") forState:UIControlStateNormal];
    
    shareButton.titleLabel.font = TextFont(13);
    [[shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        WYLog(@"立即推广");
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            //        [WYProgress showSuccessWithStatus:@"推广成功!"];
            //            http://haomaih5.lucius.cn//#/share?id=xxx&userid=xxx
            //            ShareController *shareVc = [[ShareController alloc] init];
            //            shareVc.item = weakSelf.detailItem;
            //            [weakSelf.navigationController pushViewController:shareVc animated:YES];
            NSString *userId = [LoginUserDefault userDefault].userItem.userId;
            
            NSString *qrurl = [[NSString alloc] initWithFormat:@"http://haomaih5.lucius.cn//#/share?id=%@&userid=%@", self.itemId,userId];
            
            
            WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
            webVc.urlString = qrurl;
            [weakSelf.navigationController pushViewController:webVc animated:YES];
        }];
    }];
    [bottomView addSubview:shareButton];
    //    self.shareButton = shareButton;
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(bottomView).offset(AUTOSIZESCALEX(75));
        make.bottom.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo((SCREEN_WIDTH - AUTOSIZESCALEX(75)) * 0.5);
    }];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [buyButton setTitle:@"  ¥ 88.00\n折扣价购买" forState:UIControlStateNormal];
    [buyButton setTitle:@"领券￥" forState:UIControlStateNormal];
    
    buyButton.titleLabel.numberOfLines = 0;
    [buyButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    //    [buyButton setBackgroundColor:QHMainColor];
    [buyButton gradientButtonWithSize:CGSizeMake((SCREEN_WIDTH -AUTOSIZESCALEX(75)) * 0.5, AUTOSIZESCALEX(60)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.5),@(1.0)] gradientType:GradientFromTopToBottom];
    buyButton.titleLabel.font = TextFont(13);
    [[buyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            WYLog(@"购买");
            [weakSelf takeTicketWithItem:weakSelf.detailItem];
        }];
    }];
    [bottomView addSubview:buyButton];
    self.buyButton = buyButton;
    
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(shareButton.mas_right).offset(AUTOSIZESCALEX(0));
        //        make.bottom.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        //        make.width.mas_equalTo((SCREEN_WIDTH -AUTOSIZESCALEX(75)) * 0.5);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(0);
        //        make.right.equalTo(bottomView).offset(0);
        make.top.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(75));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
}

#pragma mark - Button Action

// 领券
- (void)takeTicketWithItem:(CommodityDetailItem *)item {
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
            
            [[AlibcTradeSDK sharedInstance].tradeService show:self.navigationController page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
                
            } tradeProcessFailedCallback:^(NSError * _Nullable error) {
                
            }];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.loadFailed ? 0 : 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return AUTOSIZESCALEX(200);
    }
    DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView prepareCellForIndexPath:indexPath];
    return [cell requiredRowHeightInTableView:tableView];
    
    //    return [cell requiredRowHeightInTableView:tableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        GoodsDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellId];
        cell.delegate = self;
        cell.item = self.detailItem;
        return cell;
    } else if (indexPath.section == 1) {
        //自定义方法，创建富文本单元格
        DTAttributedTextCell *dtCell = (DTAttributedTextCell *) [self tableView:tableView prepareCellForIndexPath:indexPath];
        
        return dtCell;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = QHWhiteColor;
    return cell;
}

#pragma mark - private Methods
//创建富文本单元格，并更新单元格上的数据
//ZSDTCoreTextCell是自定义的继承于DTCoreTextCell的单元格
- (DTAttributedTextCell *)tableView:(UITableView *)tableView prepareCellForIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [NSString stringWithFormat:@"dtCoreTextCellKEY%ld-%ld", (long)indexPath.section, (long)indexPath.row];
    DTAttributedTextCell *cell = [tableView dequeueReusableCellWithIdentifier:key];
    if (!cell){
        //cell = [tableView dequeueReusableCellWithIdentifier:key];
        cell = [[DTAttributedTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:key];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.hasFixedRowHeight = NO;
        cell.textDelegate = self;
        cell.attributedTextContextView.shouldDrawImages = YES;
        //记录在缓存中
        //[_cellCache setObject:cell forKey:key];
    }
    //2.设置数据
    //2.1为富文本单元格设置Html数据
    //    NSString *content = @"<p><img src=\"https://img.alicdn.com/imgextra/i4/539549300/O1CN012IZRs4AFutBtAiK_!!539549300.jpg\" height=\"800\" width=\"200\"><p>你好</p></img></p>";
    //    [cell setHTMLString:content];
    [cell setHTMLString:self.detailItem.content];
    
    //2.2为每个占位图(图片)设置大小，并更新
    for (DTTextAttachment *oneAttachment in cell.attributedTextContextView.layoutFrame.textAttachments) {
        NSValue *sizeValue = [self.imageSizeCache objectForKey:oneAttachment.contentURL];
        if (sizeValue) {
            cell.attributedTextContextView.layouter=nil;
            oneAttachment.displaySize = [sizeValue CGSizeValue];
        }
    }
    [cell.attributedTextContextView relayoutText];
    return cell;
}

#pragma mark - DTLazyImageViewDelegate

#pragma mark - DTAttributedTextContentViewDelegate
//对于没有在Html标签里设置宽高的图片，在这里为其设置占位
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame{
    if([attachment isKindOfClass:[DTImageTextAttachment class]]){
        //自定义的ZSDTLazyImageView继承于DTLazyImageView，增加了一个属性textContentView
        //用于更新图片大小
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        imageView.delegate = self;
        imageView.image = [(DTImageTextAttachment *)attachment image];
        imageView.contentView = attributedTextContentView;
        imageView.url = attachment.contentURL;
        return imageView;
    }
    return nil;
}

//对于无宽高懒加载得到的图片，缓存记录其大小,然后执行表视图更新
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size{
    BOOL needUpdate = NO;
    NSURL *url = lazyImageView.url;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    /* update all attachments that matchin this URL (possibly multiple
     images with same size)
     */
    for (DTTextAttachment *oneAttachment in [lazyImageView.contentView.layoutFrame textAttachmentsWithPredicate:pred]){
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero)){
            oneAttachment.originalSize = size;
            NSValue *sizeValue = [_imageSizeCache objectForKey:oneAttachment.contentURL];
            if (!sizeValue) {
                //将图片大小记录在缓存中，但是这种图片的原始尺寸可能很大，所以这里设置图片的最大宽
                //并且计算高
                CGFloat aspectRatio = size.height / size.width;
                //                CGFloat width = SCREEN_WIDTH - 15*2;
                CGFloat width = SCREEN_WIDTH - 10;
                CGFloat height = width * aspectRatio;
                CGSize newSize = CGSizeMake(width, height);
                [self.imageSizeCache setObject:[NSValue valueWithCGSize:newSize]forKey:url];
            }
            needUpdate = YES;
        }
    }
    if (needUpdate){
        if (UI_IS_IPHONEX) {
            [self.tableView  reloadData];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : AUTOSIZESCALEX(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0 && !self.loadFailed) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(40))];
        headerView.backgroundColor = QHWhiteColor;
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"商品详情页装饰")];
        lineImageView.frame = CGRectMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(18), SCREEN_WIDTH - AUTOSIZESCALEX(100), AUTOSIZESCALEX(6));
        [headerView addSubview:lineImageView];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AUTOSIZESCALEX(10), headerView.width, AUTOSIZESCALEX(20))];
        descLabel.text = @"宝贝详情";
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.font = TextFont(15);
        [descLabel sizeToFit];
        descLabel.height = AUTOSIZESCALEX(20);
        descLabel.centerX = headerView.centerX;
        [headerView addSubview:descLabel];
        // 文字渐变
        [WYUtils TextGradientview:descLabel bgVIew:headerView gradientColors:@[(id)ColorWithHexString(@"#ffb42b").CGColor, (id)ColorWithHexString(@"#ffb42b").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
        
        return headerView;
    } else {
        //        return self.headerView;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView tableFooterView];
}

#pragma mark - GoodsDetailInfoCellDelegate

// 点击立即领券
- (void)goodsDetailInfoCell:(GoodsDetailInfoCell *)goodsDetailInfoCell takeTicket:(CommodityDetailItem *)item {
    WeakSelf
    [LoginUtil loginWithFatherVc:self completedHandler:^{
        WYLog(@"立即领券");
        [weakSelf takeTicketWithItem:item];
    }];
}

#pragma mark - Private method

- (void)screenShots {
    // 每次加载详情都需要清空上一次的记录
    [[LoginUserDefault userDefault].shareImageArray removeAllObjects];
    
    for (int i = 0; i < self.detailItem.imageUrls.count; i++) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        if (i > 0) {
            NSURL *url = [NSURL URLWithString: self.detailItem.imageUrls[i]];
            [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
                UIImage *img;
                
                if (isInCache) {
                    img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
                    [[LoginUserDefault userDefault].shareImageArray addObject:img];
                } else {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        //从网络下载图片
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        UIImage *image = [UIImage imageWithData:data];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[LoginUserDefault userDefault].shareImageArray addObject:image];
                        });
                    });
                }
            }];
            continue;
        }
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, AUTOSIZESCALEX(250), AUTOSIZESCALEX(345))];
        [self.view addSubview:bgView];
        
        WeakSelf
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = ImageWithNamed(@"banner2");
        imageView.userInteractionEnabled = YES;
        [bgView addSubview:imageView];
        
        UIView *infoView = [[UIView alloc] init];
        infoView.backgroundColor = QHWhiteColor;
        [bgView addSubview:infoView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 3;
        titleLabel.font = TextFont(10);
        titleLabel.textColor = QHBlackColor;
        NSString *title = [NSString stringWithFormat:@"           %@",self.detailItem.name];
        if (self.detailItem.freeShip == 1) { // 包邮
            title = [NSString stringWithFormat:@"           %@",self.detailItem.name];
        } else {
            title = [NSString stringWithFormat:@"%@",self.detailItem.name];
        }
        //        NSString *title = [NSString stringWithFormat:@"           %@",self.detailItem.name];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
        text.yy_lineSpacing = AUTOSIZESCALEX(3);
        titleLabel.attributedText = text;
        [infoView addSubview:titleLabel];
        
        UIButton *shipButton = [[UIButton alloc] init];
        shipButton.hidden = (self.detailItem.freeShip == 0);
        shipButton.layer.cornerRadius = 3;
        shipButton.layer.masksToBounds = YES;
        [shipButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(35), AUTOSIZESCALEX(18)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
        shipButton.titleLabel.font = TextFont(10);
        [shipButton setTitle:@"包邮" forState:UIControlStateNormal];
        [shipButton setTintColor:QHWhiteColor];
        [infoView addSubview:shipButton];
        
        UILabel *originalPriceLabel = [[UILabel alloc] init];
        // 加横线
        NSString *originPrice = [NSString stringWithFormat:@"原价 ¥ %.2f",self.detailItem.price];
        NSMutableAttributedString *origin = [[NSMutableAttributedString alloc] initWithString: originPrice];
        [origin addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, origin.length)];
        originalPriceLabel.attributedText = origin;
        originalPriceLabel.font = TextFont(9);
        originalPriceLabel.textColor = RGB(160, 160, 160);
        [infoView addSubview:originalPriceLabel];
        
        UILabel *discountPriceLabel = [[UILabel alloc] init];
        NSString *discountPrice = [NSString stringWithFormat:@"券后价:¥ %.2f",self.detailItem.discountPrice];
        NSMutableAttributedString *discount = [[NSMutableAttributedString alloc] initWithString: discountPrice];
        [discount addAttribute:NSForegroundColorAttributeName value:RGB(80, 80, 80) range:NSMakeRange(0, 4)];
        discountPriceLabel.attributedText = discount;
        discountPriceLabel.font = TextFont(9);
        discountPriceLabel.textColor = QHPriceColor;
        [infoView addSubview:discountPriceLabel];
        
        UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ticketButton setTitle:[NSString stringWithFormat:@"%@元券",self.detailItem.couponAmount] forState:UIControlStateNormal];
        ticketButton.titleLabel.font = TextFont(9);
        [ticketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
        [ticketButton setBackgroundImage:ImageWithNamed(@"3元券bg") forState:UIControlStateNormal];
        [infoView addSubview:ticketButton];
        
        UIView *qCodeBgView = [[UIView alloc] init];
        [infoView addSubview:qCodeBgView];
        
        UIImageView *qCodeImageView = [[UIImageView alloc] init];
        NSURL *qCodeUrl = [NSURL URLWithString: [LoginUserDefault userDefault].userItem.recommendQcodePathUrl];
        [manager diskImageExistsForURL:qCodeUrl completion:^(BOOL isInCache) {
            if (isInCache) {
                UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:qCodeUrl.absoluteString];
                qCodeImageView.image = image;
            } else {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //从网络下载图片
                    NSData *data = [NSData dataWithContentsOfURL:qCodeUrl];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        qCodeImageView.image = image;
                    });
                });
            }
        }];
        qCodeImageView.userInteractionEnabled = YES;
        [qCodeBgView addSubview:qCodeImageView];
        
        UIImageView *borderImageView = [[UIImageView alloc] init];
        borderImageView.image = ImageWithNamed(@"二维码边框");
        [qCodeBgView addSubview:borderImageView];
        
        UILabel *longPressLabel = [[UILabel alloc] init];
        longPressLabel.font = TextFont(6.5);
        longPressLabel.textColor = QHMainColor;
        longPressLabel.text = @"长按识别二维码";
        [qCodeBgView addSubview:longPressLabel];
        
        // 约束
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(bgView).offset(AUTOSIZESCALEX(0));
            make.height.mas_equalTo(250);
        }];
        
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(AUTOSIZESCALEX(0));
            make.left.right.bottom.equalTo(bgView).offset(AUTOSIZESCALEX(0));
        }];
        
        [qCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(infoView).offset(AUTOSIZESCALEX(0));
            make.width.mas_equalTo(85);
        }];
        
        [qCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(0));
            make.right.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(-15));
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(70);
        }];
        
        [borderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(0));
            make.right.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(-15));
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(70);
        }];
        
        if (i == 0) {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(infoView).offset(AUTOSIZESCALEX(10));
                make.left.equalTo(infoView).offset(AUTOSIZESCALEX(10));
                make.right.equalTo(qCodeBgView.mas_left).offset(AUTOSIZESCALEX(-10));
            }];
        } else {
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(infoView).offset(AUTOSIZESCALEX(10));
                make.left.equalTo(infoView).offset(AUTOSIZESCALEX(10));
                make.right.equalTo(infoView).offset(AUTOSIZESCALEX(-10));
            }];
        }
        
        [shipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel).offset(AUTOSIZESCALEX(0));
            make.left.equalTo(titleLabel).offset(AUTOSIZESCALEX(0));
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(13);
        }];
        
        [ticketButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(infoView).offset(AUTOSIZESCALEX(-7.5));
            make.left.equalTo(titleLabel).offset(AUTOSIZESCALEX(0));
            make.width.mas_equalTo(47.5);
            make.height.mas_equalTo(18);
        }];
        
        [discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ticketButton).offset(AUTOSIZESCALEX(0));
            make.left.equalTo(ticketButton.mas_right).offset(AUTOSIZESCALEX(5));
        }];
        
        [originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(ticketButton.mas_top).offset(AUTOSIZESCALEX(-3.5));
            make.left.equalTo(titleLabel).offset(AUTOSIZESCALEX(0));
        }];
        
        [longPressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(-7.5));
            make.centerX.equalTo(borderImageView).offset(AUTOSIZESCALEX(0));
        }];
        
        if (i == 0) { // 第一张图片需要组合二维码再截图，之所以等两秒是因为需要等二维码加载出来先
            NSURL *url = [NSURL URLWithString: self.detailItem.imageUrls[i]];
            [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
                if (isInCache) {
                    UIImage *img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
                    imageView.image = img;
                    
                    UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    [bgView.layer renderInContext:context];
                    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    if (!image) {
                        NSLog(@"就是他!");
                    }
                    [[LoginUserDefault userDefault].shareImageArray insertObject:image atIndex:0];
                    
                } else {
                    //从网络下载图片
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *img = [UIImage imageWithData:data];
                    imageView.image = img;
                    
                    UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    [bgView.layer renderInContext:context];
                    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    if (!image) {
                        NSLog(@"就是他2!");
                    }
                    [[LoginUserDefault userDefault].shareImageArray insertObject:image atIndex:0];
                }
            }];
        } else {
            NSURL *url = [NSURL URLWithString: weakSelf.detailItem.imageUrls[i]];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
                UIImage *img;
                
                if (isInCache) {
                    img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
                } else {
                    //从网络下载图片
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    img = [UIImage imageWithData:data];
                }
                [[LoginUserDefault userDefault].shareImageArray addObject:img];
            }];
        }
    }
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
    if ([item.type isEqualToString:@"1"]) {
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
    if ([item.type isEqualToString:@"2"] || [item.type isEqualToString:@"3"]) {
        NewSearchGoodsDetailController *detailVc = [[NewSearchGoodsDetailController alloc] init];
        detailVc.itemId = item.id;
        [self.navigationController pushViewController:detailVc animated:YES];
    }
    
}

#pragma mark -

@end
