//
//  NewSearchDetailController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewSearchDetailController.h"
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
#import <WebKit/WebKit.h>
#import "ShareController.h"
#import "SearchGoodsItem.h"

#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import "TaoBaoSearchItem.h"
#import "TaoBaoSearchDetailItem.h"
#import "WebViewH5Controller.h"
@interface NewSearchDetailController () <UITableViewDelegate,UITableViewDataSource,GoodsClassifiCellDelegate,PlatfomrCharacterCellDelegate,GoodsDetailInfoCellDelegate,WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    轮播图    */
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/**    详情模型    */
@property (strong, nonatomic) TaoBaoSearchDetailItem *detailItem;
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

@implementation NewSearchDetailController

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
    
    //    self.title = @"商品详情";
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

#pragma mark - Data

- (void)detailData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"itemId"] = self.item.id;
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/tbkDetail" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.detailItem = [TaoBaoSearchDetailItem mj_objectWithKeyValues:response[@"data"]];
            //            [weakSelf screenShots];
            //            [weakSelf.buyButton setTitle:[NSString stringWithFormat:@"  ¥ %.2f\n折扣价购买",weakSelf.detailItem.discountPrice] forState:UIControlStateNormal];
            [weakSelf.buyButton setTitle:[NSString stringWithFormat:@"领券￥%@",weakSelf.item.quan] forState:UIControlStateNormal];
            weakSelf.cycleScrollView.imageURLStringsGroup = weakSelf.detailItem.smallImages;
            [weakSelf.tableView reloadData];
//            if (weakSelf.detailItem.collected == 0) { // 未收藏
//                [weakSelf.collectedButton setImage:ImageWithNamed(@"收藏") forState:UIControlStateNormal];
//            } else { // 已收藏
//                [weakSelf.collectedButton setImage:ImageWithNamed(@"已收藏") forState:UIControlStateNormal];
//            }
            
//            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.detailItem.itemUrl]]];
            
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

    [self setupBottomView];
    
    
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
    
//    UIWebView *web = [[UIWebView alloc] initWithFrame:SCREEN_FRAME];
//    web.backgroundColor = self.view.backgroundColor;
//    web.scalesPageToFit = YES;
//    web.delegate = self;
//    [self.view addSubview:web];
//    self.webView = web;

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
//            parameters[@"targetId"] = weakSelf.item.listId;
            [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/collection/add" parameters:parameters successBlock:^(id response) {
//                if ([response[@"code"] integerValue] == RequestSuccess) {
//                    if (weakSelf.detailItem.collected == 0) { // 收藏
//                        weakSelf.detailItem.collected = 1;
//                        [WYProgress showSuccessWithStatus:@"收藏成功!"];
//                        [sender setImage:ImageWithNamed(@"已收藏") forState:UIControlStateNormal];
//                    } else {
//                        weakSelf.detailItem.collected = 0;
//                        [WYProgress showSuccessWithStatus:@"取消收藏成功!"];
//                        [sender setImage:ImageWithNamed(@"收藏") forState:UIControlStateNormal];
//                    }
//                    [[NSNotificationCenter defaultCenter] postNotificationName:MyCollectDidCancelNotificationName object:nil];
//                } else {
//                    [WYProgress showErrorWithStatus:response[@"msg"]];
//                }
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
    
    //    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [shareButton setTitle:@"立即推广" forState:UIControlStateNormal];
    //    [shareButton setTitleColor:ColorWithHexString(@"666666") forState:UIControlStateNormal];
    //    shareButton.titleLabel.font = TextFont(13);
    //    [shareButton setImage:ImageWithNamed(@"推广") forState:UIControlStateNormal];
    //    [[shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    //        WYLog(@"立即推广");
    //        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
    //            //        [WYProgress showSuccessWithStatus:@"推广成功!"];
    //            ShareController *shareVc = [[ShareController alloc] init];
    //            shareVc.item = weakSelf.detailItem;
    //            [weakSelf.navigationController pushViewController:shareVc animated:YES];
    //        }];
    //    }];
    //    [bottomView addSubview:shareButton];
    //
    //    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
    //        make.left.equalTo(bottomView).offset(AUTOSIZESCALEX(SCREEN_WIDTH * 0.25));
    //        make.bottom.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
    //        make.width.mas_equalTo(SCREEN_WIDTH * 0.25);
    //    }];
    //
    //    shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    //    [shareButton setTitleEdgeInsets:UIEdgeInsetsMake(shareButton.imageView.frame.size.height + 10 ,-shareButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    //    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(-shareButton.titleLabel.bounds.size.height - 5, 0.0,0.0, -shareButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
    
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [shareButton setTitle:[NSString stringWithFormat:@"    分享好友\n预估佣金￥%.2f",self.item.mineCommision] forState:UIControlStateNormal];
    shareButton.titleLabel.numberOfLines = 0;
    [shareButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    //    [buyButton setBackgroundColor:QHMainColor];
    [shareButton setBackgroundImage:ImageWithNamed(@"分享好友背景图片") forState:UIControlStateNormal];
    //    [shareButton gradientButtonWithSize:CGSizeMake((SCREEN_WIDTH - AUTOSIZESCALEX(75)) * 0.5, AUTOSIZESCALEX(60)) colorArray:@[(id)ColorWithHexString(@"#EC8307"),(id)ColorWithHexString(@"#E0AE14")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    shareButton.titleLabel.font = TextFont(13);
    [[shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        WYLog(@"立即推广");
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            //        [WYProgress showSuccessWithStatus:@"推广成功!"];
            NSString *userId = [LoginUserDefault userDefault].userItem.userId;
            
            NSString *qrurl = [[NSString alloc] initWithFormat:@"http://haomaih5.lucius.cn//#/share?id=%@&userid=%@", self.item.id,userId];
            
            
            WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
            webVc.urlString = qrurl;
            [weakSelf.navigationController pushViewController:webVc animated:YES];
//            ShareController *shareVc = [[ShareController alloc] init];
//            shareVc.item = weakSelf.detailItem;
//            [weakSelf.navigationController pushViewController:shareVc animated:YES];
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
    [buyButton setTitle:@"领券￥2" forState:UIControlStateNormal];
    
    buyButton.titleLabel.numberOfLines = 0;
    [buyButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
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
- (void)takeTicketWithItem:(TaoBaoSearchDetailItem *)item {
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
//    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
//    parameters[@"commodityId"] = item.commodityId;
//
//    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/commodity/clickUrl" parameters:parameters successBlock:^(id response) {
//        if ([response[@"code"] integerValue] == RequestSuccess) {
//            //                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:response[@"data"]]]) {
//            //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:response[@"data"]]];
//            //                }
//            //根据链接打开页面
//            id<AlibcTradePage> page = [AlibcTradePageFactory page: response[@"data"]];
//
//            //淘客信息
//            AlibcTradeTaokeParams *taoKeParams=[[AlibcTradeTaokeParams alloc] init];
//            taoKeParams.pid=nil; //
//            //打开方式
//            AlibcTradeShowParams* showParam = [[AlibcTradeShowParams alloc] init];
//            // 强制跳手淘
//            showParam.openType = AlibcOpenTypeNative;
//
//            [[AlibcTradeSDK sharedInstance].tradeService show:self.navigationController page:page showParams:showParam taoKeParams:nil trackParam:nil tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
//
//            } tradeProcessFailedCallback:^(NSError * _Nullable error) {
//
//            }];
//        } else {
//            [WYProgress showErrorWithStatus:response[@"msg"]];
//        }
//    } failureBlock:^(NSString *error) {
//
//    }];
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
        cell.searchItem = self.item;
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
    
    //    if([attachment isKindOfClass:[DTImageTextAttachment class]]){
    //        CGFloat aspectRatio = 1;
    //        CGFloat width = SCREEN_WIDTH - 10*2;
    //        CGFloat height = width * aspectRatio;
    //        UIView *View = [[UIView alloc] initWithFrame:frame];
    //        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,width,height)];
    //        imageView.backgroundColor = [UIColor grayColor];
    //        [imageView sd_setImageWithURL:attachment.contentURL placeholderImage:PlaceHolderMainImage options:SDWebImageProgressiveDownload];
    ////        imageView.canClick = YES;
    //        imageView.contentMode = UIViewContentModeScaleAspectFit;
    //        [View addSubview:imageView];
    //
    //        return View;
    //    }
    //    return nil;
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
        [WYUtils TextGradientview:descLabel bgVIew:headerView gradientColors:@[(id)ColorWithHexString(@"#F96C74").CGColor, (id)ColorWithHexString(@"#FB4F67").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
        
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
//        [weakSelf takeTicketWithItem:item];
    }];
}




@end
