//
//  GlobalSearchDetailController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GlobalSearchDetailController.h"
#import "GlobalSearchDetailInfoCell.h"
#import "GoodsRecommendReasonsCell.h"
#import "ShareController.h"
#import "SwapGoogsListItem.h"
#import "ExchangeDetailController.h"

#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "TaoBaoSearchItem.h"
#import "TaoBaoSearchDetailItem.h"
#import "GlobalSearchShareController.h"
#import "SearchGoodsItem.h"

@interface GlobalSearchDetailController () <UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    轮播图    */
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/**    详情模型    */
@property (strong, nonatomic) TaoBaoSearchDetailItem *detailItem;
//@property (strong, nonatomic) SearchGoodsItem *detailItem;
/**    购买按钮    */
@property (strong, nonatomic) UIButton *buyButton;
/**    收藏按钮    */
@property (strong, nonatomic) UIButton *collectedButton;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSAttributedString *attribute;
//类似tabelView的缓冲池，用于存放图片大小
@property (nonatomic, strong) NSCache *imageSizeCache;

@end

static NSString *const goodsInfoCellId = @"goodsInfoCellId";
static NSString *const recommendCellId = @"recommendCellId";
static NSString *const webCellId = @"webCellId";

@implementation GlobalSearchDetailController

- (NSCache *)imageSizeCache {
    if (!_imageSizeCache) {
        _imageSizeCache = [[NSCache alloc] init];
    }
    return _imageSizeCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    [self setupNav];
    [self detailData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - Data

- (void)detailData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSInteger itemId = [self.item.id integerValue];
    parameters[@"id"] =  @(itemId);
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;

    WeakSelf
    [[NetworkSingleton sharedManager] getCoRequestWithUrl:@"/GoodsDetail" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
//            weakSelf.detailItem = [SwapGoogsListItem mj_objectWithKeyValues:response[@"data"][@"detail"]];
//            weakSelf.cycleScrollView.imageURLStringsGroup = weakSelf.detailItem.cover;
            [weakSelf.tableView reloadData];
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
    tableView.tableHeaderView = self.cycleScrollView;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[GlobalSearchDetailInfoCell class] forCellReuseIdentifier:goodsInfoCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    WeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.right.equalTo(weakSelf.view).offset(0);
        make.bottom.equalTo(weakSelf.view).offset(AUTOSIZESCALEX(-50) - SafeAreaBottomHeight);
    }];
    
    [self setupBottomView];
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        WeakSelf
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(375)) delegate:nil placeholderImage:PlaceHolderMainImage];
        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            if (weakSelf.detailItem.smallImages.count > 0) {
                [WYPackagePhotoBrowser showPhotoWithUrlArray:[NSMutableArray arrayWithArray:weakSelf.detailItem.smallImages] currentIndex:currentIndex];
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
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTitle:[NSString stringWithFormat:@"分享好友"] forState:UIControlStateNormal];
    shareButton.titleLabel.numberOfLines = 0;
    [shareButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    [shareButton setBackgroundImage:ImageWithNamed(@"分享好友背景图片") forState:UIControlStateNormal];
    shareButton.titleLabel.font = TextFont(16);
    [[shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        WYLog(@"立即推广");
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            GlobalSearchShareController *shareVc = [[GlobalSearchShareController alloc] init];
            //            shareVc.item = weakSelf.detailItem;
//            shareVc.listItem = weakSelf.item;
            shareVc.detailItem = weakSelf.detailItem;
            [weakSelf.navigationController pushViewController:shareVc animated:YES];

//            ShareController *shareVc = [[ShareController alloc] init];
////            shareVc.item = weakSelf.detailItem;
//            shareVc.searchItem = weakSelf.detailItem;
//            [weakSelf.navigationController pushViewController:shareVc animated:YES];
            
        }];
    }];
    [bottomView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
    }];
    
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [buyButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
    [buyButton gradientButtonWithSize:CGSizeMake((SCREEN_WIDTH -AUTOSIZESCALEX(75)) * 0.5, AUTOSIZESCALEX(60)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.5),@(1.0)] gradientType:GradientFromTopToBottom];
    buyButton.titleLabel.font = TextFont(16);
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
    }];
    
}

#pragma mark - Button Action

// 领券
- (void)takeTicketWithItem:(TaoBaoSearchDetailItem *)item {
    
    //根据链接打开页面
//    id<AlibcTradePage> page = [AlibcTradePageFactory page: [NSString stringWithFormat:@"http:%@",self.item.clickUrl]];
//    id<AlibcTradePage> page = [AlibcTradePageFactory page: [NSString stringWithFormat:@"http:%@",self.item.shareUrl]];
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

    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"itemId"] = self.item.id;
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return AUTOSIZESCALEX(90);
    }
    DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView prepareCellForIndexPath:indexPath];
    return [cell requiredRowHeightInTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        GlobalSearchDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellId];
//        cell.searchItem = self.item;
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
    [cell setHTMLString:@""];
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

#pragma mark - DTLazyImageViewDelegate
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
        [self.tableView  reloadData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0.01 : AUTOSIZESCALEX(40);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
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

@end
