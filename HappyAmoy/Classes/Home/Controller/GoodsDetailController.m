//
//  GoodsDetailController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GoodsDetailController.h"
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
#import "WebViewH5Controller.h"

#import <AlibcTradeSDK/AlibcTradeSDK.h>

@interface GoodsDetailController () <UITableViewDelegate,UITableViewDataSource,GoodsClassifiCellDelegate,PlatfomrCharacterCellDelegate,GoodsDetailInfoCellDelegate,WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>

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

@end

static NSString *const goodsInfoCellId = @"goodsInfoCellId";
static NSString *const recommendCellId = @"recommendCellId";
static NSString *const webCellId = @"webCellId";

@implementation GoodsDetailController

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
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:[NSString stringWithFormat:@"/commodity/detail/%@",self.item.itemId] parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.detailItem = [CommodityDetailItem mj_objectWithKeyValues:response[@"data"]];
//            [weakSelf screenShots];
//            [weakSelf.buyButton setTitle:[NSString stringWithFormat:@"  ¥ %.2f\n折扣价购买",weakSelf.detailItem.discountPrice] forState:UIControlStateNormal];
            [weakSelf.buyButton setTitle:[NSString stringWithFormat:@"领券￥%@",weakSelf.detailItem.couponAmount] forState:UIControlStateNormal];
            weakSelf.cycleScrollView.imageURLStringsGroup = weakSelf.detailItem.imageUrls;
            [weakSelf.tableView reloadData];
            if (weakSelf.detailItem.collected == 0) { // 未收藏
                [weakSelf.collectedButton setImage:ImageWithNamed(@"收藏") forState:UIControlStateNormal];
            } else { // 已收藏
                [weakSelf.collectedButton setImage:ImageWithNamed(@"已收藏") forState:UIControlStateNormal];
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
            parameters[@"targetId"] = weakSelf.item.itemId;
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
//    [shareButton setTitle:[NSString stringWithFormat:@"      分享好友\n预估佣金￥%.2f",self.item.mineCommision] forState:UIControlStateNormal];
    [shareButton setTitle:[NSString stringWithFormat:@"分享好友\n预估麦穗 %.2f",self.item.mineCommision] forState:UIControlStateNormal];
    shareButton.titleLabel.numberOfLines = 0;
    shareButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [shareButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    [shareButton setBackgroundImage:ImageWithNamed(@"分享好友背景图片") forState:UIControlStateNormal];
//    [shareButton gradientButtonWithSize:CGSizeMake((SCREEN_WIDTH - AUTOSIZESCALEX(75)) * 0.5, AUTOSIZESCALEX(60)) colorArray:@[(id)ColorWithHexString(@"#EC8307"),(id)ColorWithHexString(@"#E0AE14")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    shareButton.titleLabel.font = TextFont(13);
    [[shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        WYLog(@"立即推广");
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
//            //        [WYProgress showSuccessWithStatus:@"推广成功!"];
//            ShareController *shareVc = [[ShareController alloc] init];
//            shareVc.item = weakSelf.detailItem;
//            [weakSelf.navigationController pushViewController:shareVc animated:YES];
            NSString *userId = [LoginUserDefault userDefault].userItem.userId;
            
            NSString *qrurl = [[NSString alloc] initWithFormat:@"http://haomaih5.lucius.cn//#/share?id=%@&userid=%@", self.item.itemId,userId];
            
            
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
    [buyButton setTitle:@"领券￥2" forState:UIControlStateNormal];

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
        
//        NSURL *url = [NSURL URLWithString: self.detailItem.imageUrls[i]];
//        [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
//            if (isInCache) {
//                UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
//                imageView.image = image;
//            } else {
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    //从网络下载图片
//                    NSData *data = [NSData dataWithContentsOfURL:url];
//                    UIImage *image = [UIImage imageWithData:data];
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        imageView.image = image;
//                    });
//                });
//            }
//        }];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *img = [UIImage imageWithData:data];
//        imageView.image = img;
//        [imageView wy_setImageWithUrlString:self.detailItem.imageUrls[i] placeholderImage:PlaceHolderMainImage];
        
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
//        NSData *qCodeData = [NSData dataWithContentsOfURL:qCodeUrl];
//        UIImage *qCodeImg = [UIImage imageWithData:qCodeData];
//        qCodeImageView.image = qCodeImg;
//        [qCodeImageView wy_setImageWithUrlString:[LoginUserDefault userDefault].userItem.recommendQcodePathUrl placeholderImage:PlaceHolderMainImage];
        qCodeImageView.userInteractionEnabled = YES;
        [qCodeBgView addSubview:qCodeImageView];

        UIImageView *borderImageView = [[UIImageView alloc] init];
        borderImageView.image = ImageWithNamed(@"二维码边框");
        [qCodeBgView addSubview:borderImageView];
        
//        UIView *borderView = [[UIView alloc] init];
//        borderView.layer.borderColor = QHMainColor.CGColor;
//        borderView.layer.borderWidth = AUTOSIZESCALEX(0.5);
//        [qCodeBgView addSubview:borderView];
        
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
        
//        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(qCodeImageView).offset(AUTOSIZESCALEX(0));
//            //        make.right.equalTo(self.infoView).offset(AUTOSIZESCALEX(-15));
//            make.width.mas_equalTo(60);
//            make.height.mas_equalTo(60);
//        }];
        
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
                    
                    [[LoginUserDefault userDefault].shareImageArray insertObject:image atIndex:0];

                } else {
//                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        //从网络下载图片
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        UIImage *img = [UIImage imageWithData:data];
//                        dispa .tch_async(dispatch_get_main_queue(), ^{
                            imageView.image = img;
                            
                            UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
                            CGContextRef context = UIGraphicsGetCurrentContext();
                            [bgView.layer renderInContext:context];
                            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                            
                            [[LoginUserDefault userDefault].shareImageArray insertObject:image atIndex:0];
//                        });
//                    });
                }
            }];

            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
//                CGContextRef context = UIGraphicsGetCurrentContext();
//                [bgView.layer renderInContext:context];
//                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//
//                [[LoginUserDefault userDefault].shareImageArray insertObject:image atIndex:0];
//
//                WYLog(@"[LoginUserDefault userDefault].shareImageArray = %@",[LoginUserDefault userDefault].shareImageArray);
//            });
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
        
        
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
        //            CGContextRef context = UIGraphicsGetCurrentContext();
        //            [bgView.layer renderInContext:context];
        //            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        //            UIGraphicsEndImageContext();
        //
        //            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.item.imageUrls[0]]];
        //            UIImage *img = [UIImage imageWithData:data];
        //
        //            [WYPhotoLibraryManager savePhotoImage:img completion:^(UIImage *image, NSError *error) {
        //                if (!error) {
        //                    WYLog(@"保存图片成功");
        //                    //                    [WYHud showMessage:@"保存图片成功"];
        //                } else {
        //                    WYLog(@"保存图片失败");
        //                    //                    [WYHud showMessage:@"保存图片失败"];
        //                }
        //            }];
        
        
        //            [WYPhotoLibraryManager savePhotoImage:image completion:^(UIImage *image, NSError *error) {
        //                if (!error) {
        //                    WYLog(@"保存图片成功");
        ////                    [WYHud showMessage:@"保存图片成功"];
        //                } else {
        //                    WYLog(@"保存图片失败");
        ////                    [WYHud showMessage:@"保存图片失败"];
        //                }
        //            }];
        //        });
        
        
    }
    
    
}






















































//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.view.backgroundColor = ViewControllerBackgroundColor;
//
//    self.webViewHeight = AUTOSIZESCALEX(2000);
//    [self detailData];
//    [self setupUI];
//
//    self.title = @"商品详情";
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}
//
//#pragma mark - Data
//
//- (void)detailData {
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
//    WeakSelf
//    [[NetworkSingleton sharedManager] getRequestWithUrl:[NSString stringWithFormat:@"/commodity/detail/%@",self.item.listId] parameters:parameters successBlock:^(id response) {
//        if ([response[@"code"] integerValue] == RequestSuccess) {
//            weakSelf.detailItem = [CommodityDetailItem mj_objectWithKeyValues:response[@"data"]];
//            [weakSelf.buyButton setTitle:[NSString stringWithFormat:@"  ¥ %.2f\n折扣价购买",weakSelf.detailItem.discountPrice] forState:UIControlStateNormal];
//            weakSelf.cycleScrollView.imageURLStringsGroup = weakSelf.detailItem.imageUrls;
//            [weakSelf webViewHeightWithContent:weakSelf.detailItem.content];
//            //            weakSelf.headerView.imageArray = weakSelf.detailItem.imageUrls;
//            [weakSelf.tableView reloadData];
//            if (weakSelf.detailItem.collected == 0) { // 未收藏
//                [weakSelf.collectedButton setImage:ImageWithNamed(@"收藏") forState:UIControlStateNormal];
//            } else { // 已收藏
//                [weakSelf.collectedButton setImage:ImageWithNamed(@"已收藏") forState:UIControlStateNormal];
//            }
//        } else {
//            [WYProgress showErrorWithStatus:response[@"msg"]];
//            //            [WYHud showMessage:response[@"msg"]];
//        }
//    } failureBlock:^(NSString *error) {
//
//    }];
//}
//
//#pragma mark - UI
//
//- (void)setupUI {
//
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.backgroundColor = self.view.backgroundColor;
//    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.tableHeaderView = self.cycleScrollView;
//    //    tableView.tableHeaderView = [self carouselHeaderView];
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    [tableView registerClass:[GoodsDetailInfoCell class] forCellReuseIdentifier:goodsInfoCellId];
//    [tableView registerClass:[GoodsRecommendReasonsCell class] forCellReuseIdentifier:recommendCellId];
//    [tableView registerClass:[GoodsDetailWebCell class] forCellReuseIdentifier:webCellId];
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
//
//    WeakSelf
//
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view).offset(0);
//        make.left.equalTo(weakSelf.view).offset(0);
//        make.right.equalTo(weakSelf.view).offset(0);
//        make.bottom.equalTo(weakSelf.view).offset(AUTOSIZESCALEX(-60));
//    }];
//
//    [self setupBottomView];
//}
//
//- (SDCycleScrollView *)cycleScrollView {
//    if (!_cycleScrollView) {
//        WeakSelf
//        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(375)) delegate:nil placeholderImage:PlaceHolderMainImage];
//        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
//            if (weakSelf.detailItem.imageUrls.count > 0) {
//                [WYPackagePhotoBrowser showPhotoWithUrlArray:[NSMutableArray arrayWithArray:weakSelf.detailItem.imageUrls] currentIndex:currentIndex];
//            }
//        };
//        _cycleScrollView = cycleScrollView;
//    }
//    return _cycleScrollView;
//}
//
////- (WYCarouselView *)headerView {
////    if (!_headerView) {
////
////        WeakSelf
////
////        WYCarouselView *carouselView = [[WYCarouselView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(375))];
////        // 图片是否自适应
////        //    carouselView.isAutoSizeImage = NO;
////        carouselView.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
////        carouselView.imageArray = @[ImageWithNamed(@"appIcon_small"),ImageWithNamed(@"appIcon_small")];
////
////        carouselView.imgClickBlock = ^(NSInteger currentIndex) {
////            if (weakSelf.detailItem.imageUrls.count) {
////                [WYPackagePhotoBrowser showPhotoWithUrlArray:[NSMutableArray arrayWithArray:weakSelf.detailItem.imageUrls] currentIndex:currentIndex];
////            }
////        };
////
////        _headerView = carouselView;
////    }
////    return _headerView;
////}
//
//// 底部工具条
//- (void)setupBottomView {
//
//    UIView *bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = QHWhiteColor;
//    [self.view addSubview:bottomView];
//
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(0);
//        make.right.equalTo(self.view).offset(0);
//        make.bottom.equalTo(self.view).offset(0);
//        make.height.mas_equalTo(AUTOSIZESCALEX(60));
//    }];
//
//    WeakSelf
//
//    UIButton *collectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [collectedButton setTitle:@"收藏" forState:UIControlStateNormal];
//    [collectedButton setTitleColor:ColorWithHexString(@"666666") forState:UIControlStateNormal];
//    collectedButton.titleLabel.font = TextFont(13);
//    [collectedButton setImage:ImageWithNamed(@"收藏") forState:UIControlStateNormal];
//    [[collectedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
//        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
//            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//            parameters[@"customerId"] = [LoginUserDefault userDefault].userItem.userId;
//            parameters[@"type"] = @"1";
//            parameters[@"targetId"] = weakSelf.item.listId;
//            [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/collection/add" parameters:parameters successBlock:^(id response) {
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
//            } failureBlock:^(NSString *error) {
//
//            }];
//        }];
//    }];
//    [bottomView addSubview:collectedButton];
//
//    [collectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
//        make.bottom.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(SCREEN_WIDTH * 0.25);
//    }];
//
//    collectedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//    [collectedButton setTitleEdgeInsets:UIEdgeInsetsMake(collectedButton.imageView.frame.size.height + 10 ,-collectedButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [collectedButton setImageEdgeInsets:UIEdgeInsetsMake(-collectedButton.titleLabel.bounds.size.height - 5, 0.0,0.0, -collectedButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
//    self.collectedButton = collectedButton;
//
//    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [shareButton setTitle:@"立即推广" forState:UIControlStateNormal];
//    [shareButton setTitleColor:ColorWithHexString(@"666666") forState:UIControlStateNormal];
//    shareButton.titleLabel.font = TextFont(13);
//    [shareButton setImage:ImageWithNamed(@"推广") forState:UIControlStateNormal];
//    [[shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        WYLog(@"立即推广");
//        [WYProgress showSuccessWithStatus:@"推广成功!"];
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
//
//    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buyButton setTitle:@"  ¥ 88.00\n折扣价购买" forState:UIControlStateNormal];
//    buyButton.titleLabel.numberOfLines = 0;
//    [buyButton setTitleColor:ColorWithHexString(@"#FBF7F7") forState:UIControlStateNormal];
//    //    [buyButton setBackgroundColor:QHMainColor];
//    [buyButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH * 0.5, AUTOSIZESCALEX(60)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
//    buyButton.titleLabel.font = TextFont(16);
//    [[buyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
//            WYLog(@"购买");
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://seno.tmall.com/shop/view_shop.htm?shop_id=63797458"]];
//        }];
//    }];
//    [bottomView addSubview:buyButton];
//    self.buyButton = buyButton;
//
//    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(bottomView).offset(SCREEN_WIDTH * 0.5);
//        make.bottom.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
//    }];
//}
//
//#pragma mark - Button Action
//
//- (void)didClickMessageButton {
//
//    MessageNoticeController *messageVc = [[MessageNoticeController alloc] init];
//    [self.navigationController pushViewController:messageVc animated:YES];
//
//}
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return AUTOSIZESCALEX(200);
//    } else if (indexPath.section == 1) {
//        return UITableViewAutomaticDimension;
//        //        return AUTOSIZESCALEX(60);
//    }
//    return self.webViewHeight;
////    return UITableViewAutomaticDimension;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (indexPath.section == 0) {
//        GoodsDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellId];
//        cell.delegate = self;
//        cell.item = self.detailItem;
//        return cell;
//    } else if (indexPath.section == 1) {
//        GoodsRecommendReasonsCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendCellId];
//        cell.item = self.detailItem;
//        return cell;
//    } else if (indexPath.section == 2) {
//        GoodsDetailWebCell *cell = [tableView dequeueReusableCellWithIdentifier:webCellId];
////        cell.attribute = self.attribute;
//        cell.content = self.detailItem.content;
//        return cell;
//    }
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//
//    cell.backgroundColor = QHWhiteColor;
//
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return section == 0 ? 0.01 : AUTOSIZESCALEX(40);
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section != 0) {
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(40))];
//        headerView.backgroundColor = QHWhiteColor;
//
//        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"商品详情页装饰")];
//        lineImageView.frame = CGRectMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(18), SCREEN_WIDTH - AUTOSIZESCALEX(100), AUTOSIZESCALEX(6));
//        [headerView addSubview:lineImageView];
//
//        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AUTOSIZESCALEX(10), headerView.width, AUTOSIZESCALEX(20))];
//
//        descLabel.text = section == 1 ? @"推荐理由" : @"宝贝详情";
//        descLabel.textAlignment = NSTextAlignmentCenter;
//        //        descLabel.textColor = ColorWithHexString(@"FB4F67");
//
//        descLabel.font = TextFont(15);
//        [descLabel sizeToFit];
//        descLabel.height = AUTOSIZESCALEX(20);
//        descLabel.centerX = headerView.centerX;
//        [headerView addSubview:descLabel];
//        // 文字渐变
//        [WYUtils TextGradientview:descLabel bgVIew:headerView gradientColors:@[(id)ColorWithHexString(@"#F96C74").CGColor, (id)ColorWithHexString(@"#FB4F67").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
//
//        return headerView;
//    } else {
//        //        return self.headerView;
//    }
//    return [[UIView alloc] init];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 5;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [UIView tableFooterView];
//}
//
//#pragma mark - GoodsDetailInfoCellDelegate
//
//// 点击立即领券
//- (void)goodsDetailInfoCell:(GoodsDetailInfoCell *)goodsDetailInfoCell takeTicket:(CommodityDetailItem *)item {
//    [LoginUtil loginWithFatherVc:self completedHandler:^{
//        WYLog(@"立即领券");
//        [WYProgress showSuccessWithStatus:@"领券成功!"];
//    }];
//}
//
//#pragma mark - Private method
//
//// 计算webView的高度
//- (void)webViewHeightWithContent:(NSString *)content {
//
//    //    NSString * htmlString = [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\"></head><body>%@</body></html>", content];
//
//
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(100))];
//    webView.delegate = self;
//    webView.scrollView.scrollEnabled = NO;
//    webView.scalesPageToFit = YES;
//    self.webView = webView;
//    self.webView.hidden = YES;
//    [self.view addSubview:self.webView];
//
//
//    NSString *content1 = [self htmlEntityDecode:content];
//
//    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
//                       "<head> \n"
//                       "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
//                       "<style type=\"text/css\"> \n"
//                       "body {font-size:15px;}\n"
//                       "</style> \n"
//                       "</head> \n"
//                       "<body>"
//                       "<script type='text/javascript'>"
//                       "window.onload = function(){\n"
//                       "var $img = document.getElementsByTagName('img');\n"
//                       "for(var p in  $img){\n"
//                       " $img[p].style.width = '100%%';\n"
//                       "$img[p].style.height ='auto'\n"
//                       "}\n"
//                       "}"
//                       "</script>%@"
//                       "</body>"
//                       "</html>",content1];
//
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//
//    [self.webView loadHTMLString:htmls baseURL:nil];
//
//    //    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://baidu.com"]]];
//
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//
//    if ([keyPath isEqualToString:@"contentSize"]) {
//
//        WYLog(@"webViewSize = %@",NSStringFromCGSize(self.webView.scrollView.contentSize));
//
//        self.webViewHeight = self.webView.scrollView.contentSize.height;
//        [self.tableView reloadData];
//    }
//
//}
//
//- (NSAttributedString *)attrWithEarn:(NSString *)itemName {
//    //    NSString * htmlString = [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\"></head><body>%@</body></html>", itemName];
//    NSString * htmlString = itemName;
//
//    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//
//    WYLog(@"attrstr = %@",attrStr);
//    if (attrStr && attrStr.length != 0) {
//
//        [attrStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrStr.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
//            //            if (![value isKindOfClass:[NSTextAttachment class]]) {
//            //                return;
//            //            }
//            WYLog(@"range = %@",NSStringFromRange(range));
//            WYLog(@"value = %@",value);
//
//            NSTextAttachment *attachment = (NSTextAttachment*)value;
//            CGSize size = attachment.bounds.size;
//            WYLog(@"----%@   %@", attachment.fileType, NSStringFromCGSize(size));
//            if ([attachment.fileType hasSuffix:@"jpeg"]||[attachment.fileType hasSuffix:@"gif"]||[attachment.fileType hasSuffix:@"jpg"]||[attachment.fileType hasSuffix:@"png"]) {
//                attachment.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 30, size.height/size.width * (SCREEN_WIDTH - 30));
//            }
//        }];
//        WYLog(@"====================html end");
//        return attrStr;
//    } else {
//        return [[NSAttributedString alloc] initWithString:itemName?:@""];
//    }
//}
//
//#pragma mark - WKNavigationDelegate
//
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//
//    WYLog(@"webView.scrollView.contentSize.height = %f",webView.scrollView.contentSize.height);
//    //    self.webViewHeight = webView.scrollView.contentSize.height;
//    //    [self.tableView reloadData];
//}
//
//- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    WYLog(@"webView 加载失败 error = %@",error);
//}
//
//
//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//
//    NSString *script = [NSString stringWithFormat:
//                        @"var script = document.createElement('script');"
//                        "script.type = 'text/javascript';"
//                        "script.text = \"function ResizeImages() { "
//                        "var img;"
//                        "var maxwidth=%f;"
//                        "for(i=0;i <document.images.length;i++){"
//                        "img = document.images[i];"
//                        "if(img.width > maxwidth){"
//                        "img.width = maxwidth;"
//                        "}"
//                        "}"
//                        "}\";"
//                        "document.getElementsByTagName('head')[0].appendChild(script);", SCREEN_WIDTH - 20];
//    [webView stringByEvaluatingJavaScriptFromString: script];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
//}
//
//
//- (NSString *)htmlEntityDecode:(NSString *)string
//{
//    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
//    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
//    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
//    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
//
//    return string;
//}
































//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.view.backgroundColor = ViewControllerBackgroundColor;
//
//    self.webViewHeight = AUTOSIZESCALEX(2000);
//    [self detailData];
//    [self setupUI];
//
//    self.title = @"商品详情";
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}
//
//#pragma mark - Data
//
//- (void)detailData {
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
//    WeakSelf
//    [[NetworkSingleton sharedManager] getRequestWithUrl:[NSString stringWithFormat:@"/commodity/detail/%@",self.item.listId] parameters:parameters successBlock:^(id response) {
//        if ([response[@"code"] integerValue] == RequestSuccess) {
//            weakSelf.detailItem = [CommodityDetailItem mj_objectWithKeyValues:response[@"data"]];
//            [weakSelf screenShots];
//            [weakSelf.buyButton setTitle:[NSString stringWithFormat:@"  ¥ %.2f\n折扣价购买",weakSelf.detailItem.discountPrice] forState:UIControlStateNormal];
//            weakSelf.cycleScrollView.imageURLStringsGroup = weakSelf.detailItem.imageUrls;
//            [weakSelf webViewHeightWithContent:weakSelf.detailItem.content];
////            weakSelf.headerView.imageArray = weakSelf.detailItem.imageUrls;
//            [weakSelf.tableView reloadData];
//            if (weakSelf.detailItem.collected == 0) { // 未收藏
//                [weakSelf.collectedButton setImage:ImageWithNamed(@"收藏") forState:UIControlStateNormal];
//            } else { // 已收藏
//                [weakSelf.collectedButton setImage:ImageWithNamed(@"已收藏") forState:UIControlStateNormal];
//            }
//        } else {
//            [WYProgress showErrorWithStatus:response[@"msg"]];
//        }
//    } failureBlock:^(NSString *error) {
//
//    }];
//}
//
//#pragma mark - UI
//
//- (void)setupUI {
//
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.backgroundColor = self.view.backgroundColor;
//    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.tableHeaderView = self.cycleScrollView;
//    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//    [tableView registerClass:[GoodsDetailInfoCell class] forCellReuseIdentifier:goodsInfoCellId];
//    [tableView registerClass:[GoodsRecommendReasonsCell class] forCellReuseIdentifier:recommendCellId];
//    [tableView registerClass:[GoodsDetailWebCell class] forCellReuseIdentifier:webCellId];
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
//
//    WeakSelf
//
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.view).offset(0);
//        make.left.equalTo(weakSelf.view).offset(0);
//        make.right.equalTo(weakSelf.view).offset(0);
//        make.bottom.equalTo(weakSelf.view).offset(AUTOSIZESCALEX(-60));
//    }];
//
//    [self setupBottomView];
//}
//
//- (SDCycleScrollView *)cycleScrollView {
//    if (!_cycleScrollView) {
//        WeakSelf
//        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(375)) delegate:nil placeholderImage:PlaceHolderMainImage];
//        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
//            if (weakSelf.detailItem.imageUrls.count > 0) {
//                [WYPackagePhotoBrowser showPhotoWithUrlArray:[NSMutableArray arrayWithArray:weakSelf.detailItem.imageUrls] currentIndex:currentIndex];
//            }
//        };
//        _cycleScrollView = cycleScrollView;
//    }
//    return _cycleScrollView;
//}
//
//// 底部工具条
//- (void)setupBottomView {
//
//    UIView *bottomView = [[UIView alloc] init];
//    bottomView.backgroundColor = QHWhiteColor;
//    [self.view addSubview:bottomView];
//
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(0);
//        make.right.equalTo(self.view).offset(0);
//        make.bottom.equalTo(self.view).offset(0);
//        make.height.mas_equalTo(AUTOSIZESCALEX(60));
//    }];
//
//    WeakSelf
//
//    UIButton *collectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [collectedButton setTitle:@"收藏" forState:UIControlStateNormal];
//    [collectedButton setTitleColor:ColorWithHexString(@"666666") forState:UIControlStateNormal];
//    collectedButton.titleLabel.font = TextFont(13);
//    [collectedButton setImage:ImageWithNamed(@"收藏") forState:UIControlStateNormal];
//    [[collectedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
//        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
//            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//            parameters[@"customerId"] = [LoginUserDefault userDefault].userItem.userId;
//            parameters[@"type"] = @"1";
//            parameters[@"targetId"] = weakSelf.item.listId;
//            [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/collection/add" parameters:parameters successBlock:^(id response) {
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
//            } failureBlock:^(NSString *error) {
//
//            }];
//        }];
//    }];
//    [bottomView addSubview:collectedButton];
//
//    [collectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
//        make.bottom.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(SCREEN_WIDTH * 0.25);
//    }];
//
//    collectedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//    [collectedButton setTitleEdgeInsets:UIEdgeInsetsMake(collectedButton.imageView.frame.size.height + 10 ,-collectedButton.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [collectedButton setImageEdgeInsets:UIEdgeInsetsMake(-collectedButton.titleLabel.bounds.size.height - 5, 0.0,0.0, -collectedButton.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
//    self.collectedButton = collectedButton;
//
//    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [shareButton setTitle:@"立即推广" forState:UIControlStateNormal];
//    [shareButton setTitleColor:ColorWithHexString(@"666666") forState:UIControlStateNormal];
//    shareButton.titleLabel.font = TextFont(13);
//    [shareButton setImage:ImageWithNamed(@"推广") forState:UIControlStateNormal];
//    [[shareButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        WYLog(@"立即推广");
////        [WYProgress showSuccessWithStatus:@"推广成功!"];
//        ShareController *shareVc = [[ShareController alloc] init];
//        shareVc.item = weakSelf.detailItem;
//        [weakSelf.navigationController pushViewController:shareVc animated:YES];
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
//
//    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [buyButton setTitle:@"  ¥ 88.00\n折扣价购买" forState:UIControlStateNormal];
//    buyButton.titleLabel.numberOfLines = 0;
//    [buyButton setTitleColor:ColorWithHexString(@"#FBF7F7") forState:UIControlStateNormal];
////    [buyButton setBackgroundColor:QHMainColor];
//    [buyButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH * 0.5, AUTOSIZESCALEX(60)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
//    buyButton.titleLabel.font = TextFont(16);
//    [[buyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
//            WYLog(@"购买");
//            [weakSelf takeTicketWithItem:weakSelf.detailItem];
//        }];
//    }];
//    [bottomView addSubview:buyButton];
//    self.buyButton = buyButton;
//
//    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(bottomView).offset(SCREEN_WIDTH * 0.5);
//        make.bottom.equalTo(bottomView).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
//    }];
//}
//
//#pragma mark - Button Action
//
//// 领券
//- (void)takeTicketWithItem:(CommodityDetailItem *)item {
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
//
//}
//
//#pragma mark - UITableViewDataSource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return AUTOSIZESCALEX(200);
//    }
////    return self.webViewHeight;
//    return UITableViewAutomaticDimension;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (indexPath.section == 0) {
//        GoodsDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellId];
//        cell.delegate = self;
//        cell.item = self.detailItem;
//        return cell;
//    } else if (indexPath.section == 1) {
//        GoodsDetailWebCell *cell = [tableView dequeueReusableCellWithIdentifier:webCellId];
//        cell.attribute = self.attribute;
//        //        cell.content = self.detailItem.content;
//        return cell;
//    }
////    else if (indexPath.section == 1) {
////        GoodsRecommendReasonsCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendCellId];
////        cell.item = self.detailItem;
////        return cell;
////    }
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//
//    cell.backgroundColor = QHWhiteColor;
//
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return section == 0 ? 0.01 : AUTOSIZESCALEX(40);
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section != 0) {
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(40))];
//        headerView.backgroundColor = QHWhiteColor;
//
//        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"商品详情页装饰")];
//        lineImageView.frame = CGRectMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(18), SCREEN_WIDTH - AUTOSIZESCALEX(100), AUTOSIZESCALEX(6));
//        [headerView addSubview:lineImageView];
//
//        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AUTOSIZESCALEX(10), headerView.width, AUTOSIZESCALEX(20))];
//
////        descLabel.text = section == 1 ? @"推荐理由" : @"宝贝详情";
//        descLabel.text = @"宝贝详情";
//        descLabel.textAlignment = NSTextAlignmentCenter;
////        descLabel.textColor = ColorWithHexString(@"FB4F67");
//
//        descLabel.font = TextFont(15);
//        [descLabel sizeToFit];
//        descLabel.height = AUTOSIZESCALEX(20);
//        descLabel.centerX = headerView.centerX;
//        [headerView addSubview:descLabel];
//        // 文字渐变
//        [WYUtils TextGradientview:descLabel bgVIew:headerView gradientColors:@[(id)ColorWithHexString(@"#F96C74").CGColor, (id)ColorWithHexString(@"#FB4F67").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
//
//        return headerView;
//    } else {
////        return self.headerView;
//    }
//    return [[UIView alloc] init];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 5;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return [UIView tableFooterView];
//}
//
//#pragma mark - GoodsDetailInfoCellDelegate
//
//// 点击立即领券
//- (void)goodsDetailInfoCell:(GoodsDetailInfoCell *)goodsDetailInfoCell takeTicket:(CommodityDetailItem *)item {
//    WeakSelf
//    [LoginUtil loginWithFatherVc:self completedHandler:^{
//        WYLog(@"立即领券");
//        [weakSelf takeTicketWithItem:item];
//    }];
//}
//
//#pragma mark - Private method
//
//// 计算webView的高度
//- (void)webViewHeightWithContent:(NSString *)content {
//
//    NSString *content1 = [self htmlEntityDecode:content];
//
//    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
//                       "<head> \n"
//                       "<meta name=\"viewport\" content=\"initial-scale=1.0, maximum-scale=1.0, user-scalable=no\" /> \n"
//                       "<style type=\"text/css\"> \n"
//                       "body {font-size:15px;}\n"
//                       "</style> \n"
//                       "</head> \n"
//                       "<body>"
//                       "<script type='text/javascript'>"
//                       "window.onload = function(){\n"
//                       "var $img = document.getElementsByTagName('img');\n"
//                       "for(var p in  $img){\n"
//                       " $img[p].style.width = '100%%';\n"
//                       "$img[p].style.height ='auto'\n"
//                       "}\n"
//                       "}"
//                       "</script>%@"
//                       "</body>"
//                       "</html>",content1];
//
//
//    WeakSelf
//
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//        weakSelf.attribute = [weakSelf attrWithEarn:htmls];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf.tableView reloadData];
//        });
//    });
//}
//
//- (NSAttributedString *)attrWithEarn:(NSString *)itemName {
////    NSString * htmlString = [NSString stringWithFormat:@"<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><meta http-equiv=\"X-UA-Compatible\" content=\"ie=edge\"></head><body>%@</body></html>", itemName];
//    NSString * htmlString = itemName;
//
//     NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//
////    WYLog(@"attrstr = %@",attrStr);
//    if (attrStr && attrStr.length != 0) {
//
////        for (id value in attrStr) {
////            NSTextAttachment *attachment = (NSTextAttachment*)value;
////            CGSize size = attachment.bounds.size;
////            WYLog(@"----%@   %@", attachment.fileType, NSStringFromCGSize(size));
////            if ([attachment.fileType hasSuffix:@"jpeg"]||[attachment.fileType hasSuffix:@"gif"]||[attachment.fileType hasSuffix:@"jpg"]||[attachment.fileType hasSuffix:@"png"]) {
////                attachment.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 30, size.height/size.width * (SCREEN_WIDTH - 30));
////            }
////        }
//
////        [attrStr enumerateAttributesInRange:NSMakeRange(0, attrStr.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
////            WYLog(@"attrs = %@",attrs);
////            if (attrs[@"NSAttachment"]) {
////                NSTextAttachment *attachment = (NSTextAttachment*)attrs[@"NSAttachment"];
////                CGSize size = attachment.bounds.size;
////                WYLog(@"----%@   %@", attachment.fileType, NSStringFromCGSize(size));
////                if ([attachment.fileType hasSuffix:@"jpeg"]||[attachment.fileType hasSuffix:@"gif"]||[attachment.fileType hasSuffix:@"jpg"]||[attachment.fileType hasSuffix:@"png"]) {
////                    attachment.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 30, size.height/size.width * (SCREEN_WIDTH - 30));
////                }
////            }
////
////            WYLog(@"range = %@",NSStringFromRange(range));
////        }];
//
//        [attrStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrStr.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
////            if (![value isKindOfClass:[NSTextAttachment class]]) {
////                return;
////            }
//            WYLog(@"range = %@",NSStringFromRange(range));
//            WYLog(@"value = %@",value);
//
//            NSTextAttachment *attachment = (NSTextAttachment*)value;
//            CGSize size = attachment.bounds.size;
//            WYLog(@"----%@   %@", attachment.fileType, NSStringFromCGSize(size));
//            if ([attachment.fileType hasSuffix:@"jpeg"]||[attachment.fileType hasSuffix:@"gif"]||[attachment.fileType hasSuffix:@"jpg"]||[attachment.fileType hasSuffix:@"png"]) {
//                attachment.bounds = CGRectMake(0, 0, SCREEN_WIDTH - 30, size.height/size.width * (SCREEN_WIDTH - 30));
//            }
//        }];
//        WYLog(@"====================html end");
//        return attrStr;
//    } else {
//        return [[NSAttributedString alloc] initWithString:itemName?:@""];
//    }
//}
//
//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (NSString *)htmlEntityDecode:(NSString *)string
//{
//    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
//    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
//    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
//    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
//    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
//
//    return string;
//}
//
//#pragma mark - Private method
//
//- (void)screenShots {
//    // 每次加载详情都需要清空上一次的记录
//    [[LoginUserDefault userDefault].shareImageArray removeAllObjects];
//
//
//    for (int i = 0; i < self.detailItem.imageUrls.count; i++) {
//
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, AUTOSIZESCALEX(250), AUTOSIZESCALEX(345))];
//        [self.view addSubview:bgView];
//
//        WeakSelf
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.image = ImageWithNamed(@"banner2");
//        imageView.userInteractionEnabled = YES;
//        [bgView addSubview:imageView];
//        [imageView wy_setImageWithUrlString:self.detailItem.imageUrls[i] placeholderImage:PlaceHolderMainImage];
//
//        UIView *infoView = [[UIView alloc] init];
//        infoView.backgroundColor = QHWhiteColor;
//        [bgView addSubview:infoView];
//
//        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.numberOfLines = 3;
//        titleLabel.font = TextFont(10);
//        titleLabel.textColor = QHBlackColor;
//        NSString *title = [NSString stringWithFormat:@"           %@",self.detailItem.name];
//        if (self.detailItem.freeShip == 1) { // 包邮
//            title = [NSString stringWithFormat:@"           %@",self.detailItem.name];
//        } else {
//            title = [NSString stringWithFormat:@"%@",self.detailItem.name];
//        }
////        NSString *title = [NSString stringWithFormat:@"           %@",self.detailItem.name];
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
//        text.yy_lineSpacing = AUTOSIZESCALEX(3);
//        titleLabel.attributedText = text;
//        [infoView addSubview:titleLabel];
//
//        UIButton *shipButton = [[UIButton alloc] init];
//        shipButton.hidden = (self.detailItem.freeShip == 0);
//        shipButton.layer.cornerRadius = 3;
//        shipButton.layer.masksToBounds = YES;
//        [shipButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(35), AUTOSIZESCALEX(18)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
//        shipButton.titleLabel.font = TextFont(10);
//        [shipButton setTitle:@"包邮" forState:UIControlStateNormal];
//        [shipButton setTintColor:QHWhiteColor];
//        [infoView addSubview:shipButton];
//
//        UILabel *originalPriceLabel = [[UILabel alloc] init];
//        // 加横线
//        NSString *originPrice = [NSString stringWithFormat:@"原价 ¥ %.2f",self.detailItem.price];
//        NSMutableAttributedString *origin = [[NSMutableAttributedString alloc] initWithString: originPrice];
//        [origin addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, origin.length)];
//        originalPriceLabel.attributedText = origin;
//        originalPriceLabel.font = TextFont(9);
//        originalPriceLabel.textColor = RGB(160, 160, 160);
//        [infoView addSubview:originalPriceLabel];
//
//        UILabel *discountPriceLabel = [[UILabel alloc] init];
//        NSString *discountPrice = [NSString stringWithFormat:@"券后价:¥ %.2f",self.detailItem.discountPrice];
//        NSMutableAttributedString *discount = [[NSMutableAttributedString alloc] initWithString: discountPrice];
//        [discount addAttribute:NSForegroundColorAttributeName value:RGB(80, 80, 80) range:NSMakeRange(0, 4)];
//        discountPriceLabel.attributedText = discount;
//        discountPriceLabel.font = TextFont(9);
//        discountPriceLabel.textColor = QHMainColor;
//        [infoView addSubview:discountPriceLabel];
//
//        UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [ticketButton setTitle:[NSString stringWithFormat:@"%.0f元券",self.detailItem.couponAmount] forState:UIControlStateNormal];
//        ticketButton.titleLabel.font = TextFont(9);
//        [ticketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
//        [ticketButton setBackgroundImage:ImageWithNamed(@"3元券bg") forState:UIControlStateNormal];
//        [infoView addSubview:ticketButton];
//
//        UIView *qCodeBgView = [[UIView alloc] init];
//        [infoView addSubview:qCodeBgView];
//
//        UIImageView *qCodeImageView = [[UIImageView alloc] init];
//        [qCodeImageView wy_setImageWithUrlString:[LoginUserDefault userDefault].userItem.recommendQcodePathUrl placeholderImage:PlaceHolderMainImage];
//        qCodeImageView.userInteractionEnabled = YES;
//        [qCodeBgView addSubview:qCodeImageView];
//
//        UIImageView *borderImageView = [[UIImageView alloc] init];
//        borderImageView.image = ImageWithNamed(@"二维码边框");
//        [qCodeBgView addSubview:borderImageView];
//
//        UIView *borderView = [[UIView alloc] init];
//        borderView.layer.borderColor = QHMainColor.CGColor;
//        borderView.layer.borderWidth = AUTOSIZESCALEX(0.5);
//        [qCodeBgView addSubview:borderView];
//
//        UILabel *longPressLabel = [[UILabel alloc] init];
//        longPressLabel.font = TextFont(6.5);
//        longPressLabel.textColor = QHMainColor;
//        longPressLabel.text = @"长按识别二维码";
//        [qCodeBgView addSubview:longPressLabel];
//
//        // 约束
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(bgView).offset(AUTOSIZESCALEX(0));
//            make.height.mas_equalTo(250);
//        }];
//
//        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(imageView.mas_bottom).offset(AUTOSIZESCALEX(0));
//            make.left.right.bottom.equalTo(bgView).offset(AUTOSIZESCALEX(0));
//        }];
//
//        [qCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.bottom.equalTo(infoView).offset(AUTOSIZESCALEX(0));
//            make.width.mas_equalTo(85);
//        }];
//
//        [qCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(0));
//            make.right.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(-15));
//            make.width.mas_equalTo(70);
//            make.height.mas_equalTo(70);
//        }];
//
//        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(qCodeImageView).offset(AUTOSIZESCALEX(0));
//            //        make.right.equalTo(self.infoView).offset(AUTOSIZESCALEX(-15));
//            make.width.mas_equalTo(60);
//            make.height.mas_equalTo(60);
//        }];
//
//        [borderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(0));
//            make.right.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(-15));
//            make.width.mas_equalTo(70);
//            make.height.mas_equalTo(70);
//        }];
//
//        if (i == 0) {
//            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(infoView).offset(AUTOSIZESCALEX(10));
//                make.left.equalTo(infoView).offset(AUTOSIZESCALEX(10));
//                make.right.equalTo(qCodeBgView.mas_left).offset(AUTOSIZESCALEX(-10));
//            }];
//        } else {
//            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(infoView).offset(AUTOSIZESCALEX(10));
//                make.left.equalTo(infoView).offset(AUTOSIZESCALEX(10));
//                make.right.equalTo(infoView).offset(AUTOSIZESCALEX(-10));
//            }];
//        }
//
//        [shipButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(titleLabel).offset(AUTOSIZESCALEX(0));
//            make.left.equalTo(titleLabel).offset(AUTOSIZESCALEX(0));
//            make.width.mas_equalTo(25);
//            make.height.mas_equalTo(13);
//        }];
//
//        [ticketButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(infoView).offset(AUTOSIZESCALEX(-7.5));
//            make.left.equalTo(titleLabel).offset(AUTOSIZESCALEX(0));
//            make.width.mas_equalTo(47.5);
//            make.height.mas_equalTo(18);
//        }];
//
//        [discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(ticketButton).offset(AUTOSIZESCALEX(0));
//            make.left.equalTo(ticketButton.mas_right).offset(AUTOSIZESCALEX(5));
//        }];
//
//        [originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(ticketButton.mas_top).offset(AUTOSIZESCALEX(-3.5));
//            make.left.equalTo(titleLabel).offset(AUTOSIZESCALEX(0));
//        }];
//
//        [longPressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(-7.5));
//            make.centerX.equalTo(borderImageView).offset(AUTOSIZESCALEX(0));
//        }];
//
//        if (i == 0) { // 第一张图片需要组合二维码再截图，之所以等两秒是因为需要等二维码加载出来先
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
//                CGContextRef context = UIGraphicsGetCurrentContext();
//                [bgView.layer renderInContext:context];
//                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//
//                [[LoginUserDefault userDefault].shareImageArray insertObject:image atIndex:0];
//
//                WYLog(@"[LoginUserDefault userDefault].shareImageArray = %@",[LoginUserDefault userDefault].shareImageArray);
//            });
//        } else {
//            NSURL *url = [NSURL URLWithString: weakSelf.detailItem.imageUrls[i]];
//            SDWebImageManager *manager = [SDWebImageManager sharedManager];
//            [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
//                UIImage *img;
//
//                if (isInCache) {
//                    img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
//                } else {
//                    //从网络下载图片
//                    NSData *data = [NSData dataWithContentsOfURL:url];
//                    img = [UIImage imageWithData:data];
//                }
//                [[LoginUserDefault userDefault].shareImageArray addObject:img];
//            }];
//
//            //            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.item.imageUrls[i]]];
//            //            UIImage *img = [UIImage imageWithData:data];
//
//            //            [[LoginUserDefault userDefault].shareImageArray addObject:img];
//        }
//
//
//        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //            UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
//        //            CGContextRef context = UIGraphicsGetCurrentContext();
//        //            [bgView.layer renderInContext:context];
//        //            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//        //            UIGraphicsEndImageContext();
//        //
//        //            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.item.imageUrls[0]]];
//        //            UIImage *img = [UIImage imageWithData:data];
//        //
//        //            [WYPhotoLibraryManager savePhotoImage:img completion:^(UIImage *image, NSError *error) {
//        //                if (!error) {
//        //                    WYLog(@"保存图片成功");
//        //                    //                    [WYHud showMessage:@"保存图片成功"];
//        //                } else {
//        //                    WYLog(@"保存图片失败");
//        //                    //                    [WYHud showMessage:@"保存图片失败"];
//        //                }
//        //            }];
//
//
//        //            [WYPhotoLibraryManager savePhotoImage:image completion:^(UIImage *image, NSError *error) {
//        //                if (!error) {
//        //                    WYLog(@"保存图片成功");
//        ////                    [WYHud showMessage:@"保存图片成功"];
//        //                } else {
//        //                    WYLog(@"保存图片失败");
//        ////                    [WYHud showMessage:@"保存图片失败"];
//        //                }
//        //            }];
//        //        });
//
//
//    }
//
//
//}

@end
