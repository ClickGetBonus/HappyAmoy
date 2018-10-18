//
//  ExchangeDetailController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeDetailController.h"
#import "ExchangeDetailCell.h"
#import "SubmitExchangeController.h"
#import "SwapGoogsListItem.h"

@interface ExchangeDetailController () <UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    轮播图    */
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/**    详情数据    */
@property(nonatomic,strong) SwapGoogsListItem *detailItem;
//类似tabelView的缓冲池，用于存放图片大小
@property (nonatomic, strong) NSCache *imageSizeCache;

@end

static NSString *const goodsInfoCellId = @"goodsInfoCellId";
static NSString *const recommendCellId = @"recommendCellId";
static NSString *const webCellId = @"webCellId";

@implementation ExchangeDetailController

- (NSCache *)imageSizeCache {
    if (!_imageSizeCache) {
        _imageSizeCache = [[NSCache alloc] init];
    }
    return _imageSizeCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupUI];
    [self detailData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Data

- (void)detailData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:[NSString stringWithFormat:@"/sign/swapGoogs/%@",self.listItem.swapId] parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.detailItem = [SwapGoogsListItem mj_objectWithKeyValues:response[@"data"]];
            weakSelf.cycleScrollView.imageURLStringsGroup = weakSelf.detailItem.imageUrls;
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {

    }];
}

#pragma mark - UI

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tableHeaderView = self.cycleScrollView;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [tableView registerClass:[ExchangeDetailCell class] forCellReuseIdentifier:goodsInfoCellId];
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
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(kNavHeight);
        make.height.mas_equalTo(SeparatorLineHeight * 0.5);
    }];
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        WeakSelf
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(375)) delegate:nil placeholderImage:PlaceHolderMainImage];
        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            if (weakSelf.detailItem.imageUrls.count > 0) {
                [WYPackagePhotoBrowser showPhotoWithUrlArray:[NSMutableArray arrayWithArray:weakSelf.detailItem.imageUrls] currentIndex:currentIndex];
            } else {
                [WYPackagePhotoBrowser showPhotoWithUrlArray:[NSMutableArray arrayWithArray:@[weakSelf.listItem.iconUrl]] currentIndex:currentIndex];
            }
        };
        if (![NSString isEmpty:self.listItem.iconUrl]) {
            cycleScrollView.imageURLStringsGroup = @[self.listItem.iconUrl];
        }

        _cycleScrollView = cycleScrollView;
    }
    return _cycleScrollView;
}

// 底部工具条
- (void)setupBottomView {
    WeakSelf
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exchangeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
    [exchangeButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
    exchangeButton.titleLabel.font = TextFont(14);
    [exchangeButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(50)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [[exchangeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            WYLog(@"立即兑换");
            SubmitExchangeController *submitVc = [[SubmitExchangeController alloc] init];
            submitVc.item = weakSelf.detailItem;
            [weakSelf.navigationController pushViewController:submitVc animated:YES];
        }];
    }];
    [self.view addSubview:exchangeButton];
    [exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight);
        make.height.mas_equalTo(AUTOSIZESCALEX(50));
    }];
}

#pragma mark - Button Action

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }
    DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView prepareCellForIndexPath:indexPath];
    return [cell requiredRowHeightInTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        ExchangeDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellId];
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
//        if (UI_IS_IPHONEX) {
            [self.tableView  reloadData];
//        }
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
        
//        UIImageView *lineImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"商品详情页装饰")];
//        lineImageView.frame = CGRectMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(18), SCREEN_WIDTH - AUTOSIZESCALEX(100), AUTOSIZESCALEX(6));
//        [headerView addSubview:lineImageView];
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
        descLabel.text = @"宝贝详情";
        descLabel.font = TextFont(15);
        descLabel.textColor = ColorWithHexString(@"#010101");
        descLabel.textAlignment = NSTextAlignmentCenter;
//        [descLabel sizeToFit];
//        descLabel.height = AUTOSIZESCALEX(20);
//        descLabel.centerX = headerView.centerX;
        [headerView addSubview:descLabel];
        // 文字渐变
//        [WYUtils TextGradientview:descLabel bgVIew:headerView gradientColors:@[(id)ColorWithHexString(@"#F96C74").CGColor, (id)ColorWithHexString(@"#FB4F67").CGColor] gradientStartPoint:CGPointMake(0, 1) endPoint:CGPointMake(1, 1)];
        
        return headerView;
    } else {
        //        return self.headerView;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 0.01;
    } else {
        return 5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return [[UIView alloc] init];
    } else {
        return [UIView tableFooterView];
    }
}

#pragma mark - Private method

@end
