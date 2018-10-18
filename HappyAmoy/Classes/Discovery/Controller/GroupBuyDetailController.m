//
//  GroupBuyDetailController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupBuyDetailController.h"
#import "GroupBuyDetailInfoCell.h"
#import "GroupBuyRulesCell.h"
#import "GroupBuyProgressCell.h"
#import "GroupListItem.h"
#import "ReceiptAddressController.h"
#import "AddressItem.h"
#import "GroupBuyDetailItem.h"

@interface GroupBuyDetailController () <UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate,DTLazyImageViewDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    轮播图    */
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
/**    购买按钮    */
@property (strong, nonatomic) UIButton *buyButton;
/**    收藏按钮    */
@property (strong, nonatomic) UIButton *collectedButton;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSAttributedString *attribute;
//类似tabelView的缓冲池，用于存放图片大小
@property (nonatomic, strong) NSCache *imageSizeCache;
/**    地址id    */
@property(nonatomic,copy) NSString *addressId;
/**    详情    */
@property(nonatomic,strong) GroupBuyDetailItem *detailItem;
/**    拼团按钮    */
@property(nonatomic,strong) UIButton *joinUpButton;

@end

static NSString *const goodsInfoCellId = @"goodsInfoCellId";
static NSString *const rulesCellId = @"rulesCellId";
static NSString *const progressCellId = @"progressCellId";

@implementation GroupBuyDetailController

#pragma mark - Lazy load

- (NSCache *)imageSizeCache {
    if (!_imageSizeCache) {
        _imageSizeCache = [[NSCache alloc] init];
    }
    return _imageSizeCache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    self.title = @"拼团商品";

    [self setupUI];
    [self detailData];
    [WYProgress show];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.detailItem.customerGroup.groupId) { // 已经开始拼团了，则需要取消定时器
        GroupBuyProgressCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        // 取消定时器
        [cell cancelTimer];
        WYLog(@"cell = %@",cell);
    }
}

#pragma mark - Data

- (void)detailData {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    WeakSelf
    [[NetworkSingleton sharedManager] getRequestWithUrl:[NSString stringWithFormat:@"/group/group/%@",self.groupId] parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            weakSelf.detailItem = [GroupBuyDetailItem mj_objectWithKeyValues:response[@"data"]];
            if (weakSelf.detailItem.customerGroup.groupId) {
                if (weakSelf.detailItem.customerGroup.status == 0) {
                    [weakSelf.joinUpButton setTitle:@"邀请好友" forState:UIControlStateNormal];
                    [weakSelf.joinUpButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(50)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
                } else if (weakSelf.detailItem.customerGroup.status == 1) {
                    [weakSelf.joinUpButton setTitle:@"拼团成功" forState:UIControlStateNormal];
                    [weakSelf.joinUpButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(50)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
                } else if (weakSelf.detailItem.customerGroup.status == 2) {
                    [weakSelf.joinUpButton setTitle:@"拼团失败" forState:UIControlStateNormal];
                    [weakSelf.joinUpButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(50)) colorArray:@[(id)ColorWithHexString(@"#CCCCCC"),(id)(id)ColorWithHexString(@"#CCCCCC")] percentageArray:@[@(0.5),@(1)] gradientType:GradientFromLeftToRight];
                } else {
                    [weakSelf.joinUpButton setTitle:@"拼团已取消" forState:UIControlStateNormal];
                    [weakSelf.joinUpButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(50)) colorArray:@[(id)ColorWithHexString(@"#CCCCCC"),(id)(id)ColorWithHexString(@"#CCCCCC")] percentageArray:@[@(0.5),@(1)] gradientType:GradientFromLeftToRight];
                }
            } else {
                if (weakSelf.detailItem.stock == 0) { // 拼完了
                    [weakSelf.joinUpButton setTitle:@"拼完了" forState:UIControlStateNormal];
                    [weakSelf.joinUpButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(50)) colorArray:@[(id)ColorWithHexString(@"#CCCCCC"),(id)(id)ColorWithHexString(@"#CCCCCC")] percentageArray:@[@(0.5),@(1)] gradientType:GradientFromLeftToRight];
                } else {
                    [weakSelf.joinUpButton setTitle:@"马上拼团" forState:UIControlStateNormal];
                    [weakSelf.joinUpButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(50)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
                }
            }
            weakSelf.cycleScrollView.imageURLStringsGroup = weakSelf.detailItem.imagesUrls;
            [weakSelf.tableView reloadData];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

// 开始拼团
- (void)openGroupBuyWithAddressId:(NSString *)addressId {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"groupId"] = self.groupId;
    parameters[@"userId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"addressId"] = addressId;
    WeakSelf
    [[NetworkSingleton sharedManager] postRequestWithUrl:@"/group/open" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [WYProgress showSuccessWithStatus:@"开始拼团"];
            [weakSelf detailData];
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
    [tableView registerClass:[GroupBuyDetailInfoCell class] forCellReuseIdentifier:goodsInfoCellId];
    [tableView registerClass:[GroupBuyRulesCell class] forCellReuseIdentifier:rulesCellId];
    [tableView registerClass:[GroupBuyProgressCell class] forCellReuseIdentifier:progressCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    WeakSelf
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(0);
        make.left.equalTo(weakSelf.view).offset(0);
        make.right.equalTo(weakSelf.view).offset(0);
        make.bottom.equalTo(weakSelf.view).offset(AUTOSIZESCALEX(-50)-SafeAreaBottomHeight);
    }];
    
    [self setupBottomView];
    // 顶部分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(kNavHeight);
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        WeakSelf
        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(375)) delegate:nil placeholderImage:PlaceHolderMainImage];
        cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            if (weakSelf.detailItem.imagesUrls.count > 0) {
                [WYPackagePhotoBrowser showPhotoWithUrlArray:[NSMutableArray arrayWithArray:weakSelf.detailItem.imagesUrls] currentIndex:currentIndex];
            } else {
                [WYPackagePhotoBrowser showPhotoWithImageArray:[NSMutableArray arrayWithArray:@[ImageWithNamed(@"省惠拼团banner")]] currentIndex:currentIndex];
            }
        };
        cycleScrollView.localizationImageNamesGroup = @[ImageWithNamed(@"省惠拼团banner")];
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
        make.height.mas_equalTo(AUTOSIZESCALEX(50));
    }];
    
    WeakSelf
    
    UIButton *joinUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [joinUpButton setTitle:@"马上拼团" forState:UIControlStateNormal];
    [joinUpButton setTitleColor:ColorWithHexString(@"#FEFCFC") forState:UIControlStateNormal];
    joinUpButton.titleLabel.font = TextFont(14);
    [joinUpButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(50)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [[joinUpButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [LoginUtil loginWithFatherVc:weakSelf completedHandler:^{
            if (!weakSelf.detailItem) {
                return;
            }
            if (weakSelf.detailItem.stock == 0) { // 拼完了
                return;
            }
            if (weakSelf.detailItem.customerGroup.groupId) { // 今天已拼团
                if (weakSelf.detailItem.customerGroup.status == 0) {  // 邀请好友
                    [[WYUMShareMnager manager] showShareUIWithSelectionBlock:^(UMSocialPlatformType type) {
                        [[WYUMShareMnager manager] shareDataWithPlatform:type title:@"帮我免费得商品，就差你来注册了" desc:self.detailItem.name shareURL:[LoginUserDefault userDefault].userItem.recommendUrl thumImage:ImageWithNamed(@"appIcon_small") fromVc:self completion:^(id result, NSError *error) {
                            if (!error) {
                                [WYProgress showSuccessWithStatus:@"分享成功!"];
                            }
                        }];
                    }];
                }
            } else { // 马上拼团
                if ([NSString isEmpty:weakSelf.addressId]) {
                    ReceiptAddressController *addressVc = [[ReceiptAddressController alloc] init];
                    addressVc.isSelectAddress = YES;
                    addressVc.selectAddressCallBack = ^(AddressItem *item) {
                        weakSelf.addressId = item.addressId;
                        [weakSelf openGroupBuyWithAddressId:item.addressId];
                    };
                    [weakSelf.navigationController pushViewController:addressVc animated:YES];
                }
            }
        }];
    }];
    [bottomView addSubview:joinUpButton];
    self.joinUpButton = joinUpButton;
    [joinUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bottomView);
    }];
}

#pragma mark - Button Action


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.detailItem) {
        if (self.detailItem.customerGroup.groupId) {
            return 4;
        }
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return AUTOSIZESCALEX(100);
    }
    
    if (self.detailItem.customerGroup.groupId) {
        if (indexPath.section == 1) { // 拼团进度
            return AUTOSIZESCALEX(150);
        } else if (indexPath.section == 2) { // 拼团规则
            return UITableViewAutomaticDimension;
        }
    } else {
        if (indexPath.section == 1) { // 拼团规则
            return UITableViewAutomaticDimension;
        }
    }

    DTAttributedTextCell *cell = (DTAttributedTextCell *)[self tableView:tableView prepareCellForIndexPath:indexPath];
    return [cell requiredRowHeightInTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        GroupBuyDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsInfoCellId];
        cell.item = self.detailItem;
        return cell;
    }
    
    if (self.detailItem.customerGroup.groupId) {
        if (indexPath.section == 1) { // 拼团进度
            GroupBuyProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:progressCellId];
            cell.item = self.detailItem;
            return cell;
        } else if (indexPath.section == 2) { // 拼团规则
            GroupBuyRulesCell *cell = [tableView dequeueReusableCellWithIdentifier:rulesCellId];
            
            return cell;
        } else { // 商品详情
            //自定义方法，创建富文本单元格
            DTAttributedTextCell *dtCell = (DTAttributedTextCell *) [self tableView:tableView prepareCellForIndexPath:indexPath];
            
            return dtCell;
        }
    } else {
        if (indexPath.section == 1) { // 拼团规则
            GroupBuyRulesCell *cell = [tableView dequeueReusableCellWithIdentifier:rulesCellId];
            
            return cell;
        } else { // 商品详情
            //自定义方法，创建富文本单元格
            DTAttributedTextCell *dtCell = (DTAttributedTextCell *) [self tableView:tableView prepareCellForIndexPath:indexPath];
            
            return dtCell;
        }
    }
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
        if (UI_IS_IPHONEX) {
            [self.tableView  reloadData];
        }
//        if (self.detailItem.customerGroup.groupId) {
//            [self.tableView  reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
//        } else {
//            [self.tableView  reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
//        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSInteger row = 2;
    if (self.detailItem.customerGroup.groupId) {
        row = 3;
    }
    return section == row ? AUTOSIZESCALEX(50) : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSInteger row = 2;
    if (self.detailItem.customerGroup.groupId) {
        row = 3;
    }
    if (section == row) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(50))];
        headerView.backgroundColor = QHWhiteColor;
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.width, headerView.height)];
        descLabel.text = @"商品详情";
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.font = TextFont(14);
        descLabel.textColor = ColorWithHexString(@"#000000");
        [headerView addSubview:descLabel];
        return headerView;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView tableFooterView];
}

#pragma mark - Private method

- (void)dealloc {
    WYFunc
}




@end
