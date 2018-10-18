//
//  ShareController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareController.h"
#import "ShareTextController.h"
#import "ShareImageController.h"
#import "ShareView.h"
#import "CommodityDetailItem.h"

@interface ShareController () <UIScrollViewDelegate,ShareViewDelegate>

/**    存放子控制器的scrollView    */
@property (strong, nonatomic) UIScrollView *scrollView;
/**    标题栏    */
@property (strong, nonatomic) UIView *titleView;
/**    上次点击的按钮    */
@property (strong, nonatomic) UIButton *previousClickButton;
/**    标题按钮的下划线    */
@property (strong, nonatomic) UIView *titleButtonUnderLine;
/**    分享的视图    */
@property (strong, nonatomic) ShareView *shareView;

@end

@implementation ShareController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"分享赚麦穗";
    
    self.view.backgroundColor = QHWhiteColor;
    
    // 导航栏
    [self setupNav];
    // 设置子控制器
    [self setupChildVc];
    // 添加scrollView
    [self setupScrollView];
    // 添加标题栏
    [self setupTitleView];
    // 添加分享视图
    [self setupShareView];
    // 截图
    [self screenShots];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [WYProgress dismiss];
}

#pragma mark - Nav

- (void)setupNav {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageOriginalWithNamed:@"icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickSystemShare)];

//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithImage:ImageWithNamed(@"icon_more") highlightImage:ImageWithNamed(@"icon_more") buttonSize:CGSizeMake(30, 30) target:self action:@selector(didClickSystemShare) imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

#pragma mark - 添加子控制器
- (void)setupChildVc {
    ShareTextController *textVc = [[ShareTextController alloc] init];
    textVc.item = self.item;
    [self addChildViewController:textVc];
    
    ShareImageController *imageVc = [[ShareImageController alloc] init];
    imageVc.item = self.item;
    [self addChildViewController:imageVc];
}

#pragma mark - 设置scrollView
- (void)setupScrollView {
    // 禁止系统为scrollView添加额外的上边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 0)];
    
    scrollView.backgroundColor = ViewControllerBackgroundColor;
    // 设置分页
    scrollView.pagingEnabled = YES;
    // 隐藏垂直滚动条
    scrollView.showsVerticalScrollIndicator = NO;
    // 隐藏水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    scrollView.delegate = self;
    // 当点击状态栏的时候，禁止scrollView滑动到顶部
    scrollView.scrollsToTop = NO;
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    NSInteger count = self.childViewControllers.count;
    
    scrollView.contentSize = CGSizeMake(count * scrollView.width, 0);
}

#pragma mark - 设置标题栏
- (void)setupTitleView {
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight + AUTOSIZESCALEX(1), SCREEN_WIDTH, AUTOSIZESCALEX(45))];
    titleView.centerX = self.view.centerX;
    self.titleView = titleView;
    
    titleView.backgroundColor = QHWhiteColor;
    
    [self.view addSubview:titleView];
    
    // 设置标题按钮
    [self setupTitleButton];
    // 添加标题按钮的下划线
    [self setupTitleBtnUnderLine];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5, AUTOSIZESCALEX(10), AUTOSIZESCALEX(1), AUTOSIZESCALEX(25))];
    line.backgroundColor = SeparatorLineColor;
    [titleView addSubview:line];
    
    // 默认开始点击第一个标题
    UIButton *button = self.titleView.subviews[0];
    
    [self titleButtonClick:button];
}

#pragma mark - 添加标题按钮
- (void)setupTitleButton {
    
    NSArray *titleArray = @[@"文案分享",@"图片分享"];
    
    NSInteger count = titleArray.count;
    
    CGFloat buttonW = SCREEN_WIDTH * 0.5;
    CGFloat buttonH = self.titleView.height;
    
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(i * buttonW , 0, buttonW, buttonH);
        
        button.tag = i;
        
        [button setTitleColor:ColorWithHexString(@"#565656") forState:UIControlStateNormal];
        [button setTitleColor:QHMainColor forState:UIControlStateSelected];
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = TextFont(14);
        
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleView addSubview:button];
    }
}

#pragma mark - 添加标题下划线
- (void)setupTitleBtnUnderLine {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView.height - AUTOSIZESCALEX(1.5), AUTOSIZESCALEX(60), AUTOSIZESCALEX(1.5))];
    
    line.backgroundColor = QHMainColor;
    
    self.titleButtonUnderLine = line;
    
    [self.titleView addSubview:line];
    
}

#pragma mark - 添加分享视图
- (void)setupShareView {
    
    ShareView *shareView = [[ShareView alloc] init];
    shareView.delegate = self;
    [self.view addSubview:shareView];
    self.shareView = shareView;
    
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.view).offset(-SafeAreaBottomHeight);
        make.height.mas_equalTo(AUTOSIZESCALEX(115));
    }];
}

#pragma mark - 标题的点击事件
- (void)titleButtonClick:(UIButton *)sender {
    [self titleButtonClickWhenScroll:sender];
}

#pragma mark - 处理滑动时调用的点击标题按钮事件
- (void)titleButtonClickWhenScroll:(UIButton *)sender {
    
    [self.view endEditing:YES];

    self.previousClickButton.selected = NO;
    sender.selected = YES;
    self.previousClickButton = sender;
    
    [UIView animateWithDuration:0.25 animations:^{
        // 设置下划线平移
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSFontAttributeName] = sender.titleLabel.font;
        // 获取按钮标题的宽度
        //        CGFloat buttonwidth = [sender.currentTitle sizeWithAttributes:attr].width;
        // 下划线宽度比按钮标题的宽度宽一点，有点突出感
        //        self.titleButtonUnderLine.width = buttonwidth + 10;
        
        self.titleButtonUnderLine.centerX = sender.centerX;
        
        // 设置scrollView平移
        self.scrollView.contentOffset = CGPointMake(sender.tag * self.scrollView.width, self.scrollView.contentOffset.y);
        
    } completion:^(BOOL finished) {
        
        UIView *childView = self.childViewControllers[sender.tag].view;
        
        childView.frame = CGRectMake(sender.tag * self.scrollView.width, self.titleView.bottom_WY, self.scrollView.width, self.scrollView.height - self.titleView.bottom_WY - AUTOSIZESCALEX(115));
        
        [self.scrollView addSubview:childView];
        
    }];
    
    // 当点击状态栏的时候，把当前显示的tableView滑动到顶部，只要设置scrollView的scrollsToTop为yes即可，但前提是只有一个scrollView设置为yes，其他都设置为no
    for (NSInteger i = 0; i < self.childViewControllers.count; i++) {
        
        UIViewController *childVc = self.childViewControllers[i];
        // 如果控制器的View还没加载，则不需要处理
        if (!childVc.isViewLoaded) continue;
        
        UIView *mainView = (UIView *)childVc.view;
        
        for (UIScrollView *subView in mainView.subviews) {
            
            if (![subView isKindOfClass:[UIScrollView class]]) continue;
            
            subView.scrollsToTop = (i == sender.tag);
        }
    }
}

#pragma mark - UIScrollViewDelegate
// scrollView滑动结束时会调用该方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 找到偏移后的按钮的索引
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    
    UIButton *button = self.titleView.subviews[index];
    
    [self titleButtonClickWhenScroll:button];
    
}

// 系统分享
- (void)didClickSystemShare {
//     创建UMSocialMessageObject实例进行分享
//     分享数据对象
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:[LoginUserDefault userDefault].shareImageArray applicationActivities:nil];
    
    NSMutableArray *excludedActivityTypes =  [NSMutableArray arrayWithArray:@[UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeMail, UIActivityTypePostToTencentWeibo, UIActivityTypeMessage, UIActivityTypePostToTwitter,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeOpenInIBooks]];
    // 不显示的选项
    activityVC.excludedActivityTypes = excludedActivityTypes;
    
    [self presentViewController:activityVC animated:TRUE completion:nil];
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        
        WYLog(@"activityType = %@  \n completed = %zd  \n  returnedItems = %@  \n %@", activityType, completed, returnedItems,activityError);
        
    };
}

#pragma mark - ShareViewDelegate
// 自定义分享
- (void)shareView:(ShareView *)shareView platformType:(UMSocialPlatformType)platformType {
    
//    UIImage *imageToShare = PlaceHolderImage;
//    UIImage *imageToShare1 = PlaceHolderImage;
//    NSArray *activityItems = @[imageToShare,imageToShare1];
    
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:[LoginUserDefault userDefault].shareImageArray applicationActivities:nil];
//
//    NSMutableArray *excludedActivityTypes =  [NSMutableArray arrayWithArray:@[UIActivityTypeAirDrop, UIActivityTypeAssignToContact, UIActivityTypeMail, UIActivityTypePostToTencentWeibo, UIActivityTypeMessage, UIActivityTypePostToTwitter,UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeOpenInIBooks]];
//    // 不显示的选项
//    activityVC.excludedActivityTypes = excludedActivityTypes;
//
//    [self presentViewController:activityVC animated:TRUE completion:nil];
//    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
//
//        WYLog(@"activityType = %@  \n completed = %zd  \n  returnedItems = %@  \n %@", activityType, completed, returnedItems,activityError);
//
//    };

    
    
    
    
//    [[WYUMShareMnager manager] shareDataWithPlatform:platformType title:self.item.name desc:@"" shareURL:@"https://baidu.com" thumImage:[LoginUserDefault userDefault].shareImageArray[0] fromVc:self completion:^(id result, NSError *error) {
//
//    }];
    
//    [[WYUMShareMnager manager] shareImageWithPlatform:platformType title:self.item.name thumImage:PlaceHolderImage shareImage:[LoginUserDefault userDefault].shareImageArray[0] fromVc:self completion:^(id result, NSError *error) {
//
//    }];
    
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    // 图片或图文分享
//    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:title descr:@"" thumImage:thumImage];
//    shareObject.shareImage = shareImage;
//    messageObject.shareObject = shareObject;
//
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
//        completion(result,error);
//    }];

    
    
    //     创建UMSocialMessageObject实例进行分享
    //     分享数据对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // 图片或图文分享
    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:self.item.name descr:@"" thumImage:[LoginUserDefault userDefault].shareImageArray[0]];
    shareObject.shareImage = [LoginUserDefault userDefault].shareImageArray[0];
    messageObject.shareObject = shareObject;

    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {

    }];

}

#pragma mark - Private method

- (void)screenShots {
    // 每次加载详情都需要清空上一次的记录
    [[LoginUserDefault userDefault].shareImageArray removeAllObjects];
  
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

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
    NSString *title = [NSString stringWithFormat:@"           %@",self.item.name];
    if (self.item.freeShip == 1) { // 包邮
        title = [NSString stringWithFormat:@"           %@",self.item.name];
    } else {
        title = [NSString stringWithFormat:@"%@",self.item.name];
    }
    //        NSString *title = [NSString stringWithFormat:@"           %@",self.detailItem.name];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
    text.yy_lineSpacing = AUTOSIZESCALEX(3);
    titleLabel.attributedText = text;
    [infoView addSubview:titleLabel];
    
    UIButton *shipButton = [[UIButton alloc] init];
    shipButton.hidden = (self.item.freeShip == 0);
    shipButton.layer.cornerRadius = 3;
    shipButton.layer.masksToBounds = YES;
    [shipButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(35), AUTOSIZESCALEX(18)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    shipButton.titleLabel.font = TextFont(10);
    [shipButton setTitle:@"包邮" forState:UIControlStateNormal];
    [shipButton setTintColor:QHWhiteColor];
    [infoView addSubview:shipButton];
    
    UILabel *originalPriceLabel = [[UILabel alloc] init];
    // 加横线
    NSString *originPrice = [NSString stringWithFormat:@"原价 ¥ %.2f",self.item.price];
    NSMutableAttributedString *origin = [[NSMutableAttributedString alloc] initWithString: originPrice];
    [origin addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, origin.length)];
    originalPriceLabel.attributedText = origin;
    originalPriceLabel.font = TextFont(9);
    originalPriceLabel.textColor = RGB(160, 160, 160);
    [infoView addSubview:originalPriceLabel];
    
    UILabel *discountPriceLabel = [[UILabel alloc] init];
    NSString *discountPrice = [NSString stringWithFormat:@"券后价:¥ %.2f",self.item.discountPrice];
    NSMutableAttributedString *discount = [[NSMutableAttributedString alloc] initWithString: discountPrice];
    [discount addAttribute:NSForegroundColorAttributeName value:RGB(80, 80, 80) range:NSMakeRange(0, 4)];
    discountPriceLabel.attributedText = discount;
    discountPriceLabel.font = TextFont(9);
    discountPriceLabel.textColor = QHPriceColor;
    [infoView addSubview:discountPriceLabel];
    
    UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ticketButton setTitle:[NSString stringWithFormat:@"%@元券",self.item.couponAmount] forState:UIControlStateNormal];
    ticketButton.titleLabel.font = TextFont(9);
    [ticketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    [ticketButton setBackgroundImage:ImageWithNamed(@"3元券bg") forState:UIControlStateNormal];
    [infoView addSubview:ticketButton];
    
    UIView *qCodeBgView = [[UIView alloc] init];
    [infoView addSubview:qCodeBgView];
    
    UIImageView *qCodeImageView = [[UIImageView alloc] init];
    
        NSString *itemId = self.item.itemId;
        NSString *userid = [LoginUserDefault userDefault].userItem.userId;
        NSString *qrurl = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"http://haomaieco.lucius.cn/api/getGoodsShareQr?itemid=",itemId,@"&userid=",userid];
        NSLog(@" string is :%@",qrurl);
    
        NSURL *qCodeUrl = [NSURL URLWithString: qrurl];
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
                
                //截图
                UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
                CGContextRef context = UIGraphicsGetCurrentContext();
                [bgView.layer renderInContext:context];
                UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [[LoginUserDefault userDefault].shareImageArray insertObject:image2 atIndex:0];
            });
        }
    }];
    [qCodeBgView addSubview:qCodeImageView];
    
//    UIImageView *qCodeImageView = [[UIImageView alloc] init];
//
//    NSString *itemId = self.item.itemId;
//    NSString *userid = [LoginUserDefault userDefault].userItem.userId;
//    NSString *qrurl = [[NSString alloc] initWithFormat:@"%@%@%@%@",@"http://haomaieco.lucius.cn/api/getGoodsShareQr?itemid=",itemId,@"&userid=",userid];
//    NSLog(@" string is :%@",qrurl);
//
//    NSURL *qCodeUrl = [NSURL URLWithString: qrurl];
//
//    NSLog(@" qCodeUrl is :%@",qCodeUrl);
//
//    [manager diskImageExistsForURL:qCodeUrl completion:^(BOOL isInCache) {
//        if (isInCache) {
//            UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:qCodeUrl.absoluteString];
//            qCodeImageView.image = image;
//        } else {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                //从网络下载图片
//                NSLog(@" qCodeUrl is :%@",@"从网络下载图片");
//                NSData *data = [NSData dataWithContentsOfURL:qCodeUrl];
//                NSLog(@" qCodeUrl is :%@",data);
//                UIImage *image = [UIImage imageWithData:data];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSLog(@" qCodeUrl is :%@",@"从网络下载图片2");
//                    qCodeImageView.image = image;
//                });
//            });
//        }
//    }];
//
//
//    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
//
//
//    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage) object:nil];
//    [operationQueue addOperation:op];
//
//    qCodeImageView.userInteractionEnabled = YES;
//    [qCodeBgView addSubview:qCodeImageView];
    
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
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(infoView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(qCodeBgView.mas_left).offset(AUTOSIZESCALEX(-10));
    }];
    
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
    
    NSURL *url = [NSURL URLWithString: self.item.iconUrl];
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache) {
            UIImage *img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            imageView.image = img;
            // 截图
//            UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            [bgView.layer renderInContext:context];
//            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            [[LoginUserDefault userDefault].shareImageArray insertObject:image atIndex:0];
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 从网络下载图片
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *img = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = img;
                    // 截图
//                    UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
//                    CGContextRef context = UIGraphicsGetCurrentContext();
//                    [bgView.layer renderInContext:context];
//                    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//                    UIGraphicsEndImageContext();
//                    [[LoginUserDefault userDefault].shareImageArray insertObject:image atIndex:0];
                });
            });
        }
    }];

    __block NSInteger count = 0;
    
    for (int i = 0; i < self.item.imageUrls.count; i++) {
        
        NSURL *url = [NSURL URLWithString: self.item.imageUrls[i]];
        [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
            UIImage *img;
            if (isInCache) {
                img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
                [[LoginUserDefault userDefault].shareImageArray addObject:img];
                count++;
                if (count == self.item.imageUrls.count) {
                    [WYProgress dismiss];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareImage" object:nil];
                }
            } else {
                [WYProgress show];
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //从网络下载图片
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:data];
                    count++;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[LoginUserDefault userDefault].shareImageArray addObject:image];
                        if (count == self.item.imageUrls.count) {
                            [WYProgress dismiss];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareImage" object:nil];
                        }
                    });
                });
            }
        }];
    }
}

//- (void)screenShots {
//
//    for (int i = 0; i < self.item.imageUrls.count; i++) {
//
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, AUTOSIZESCALEX(250), AUTOSIZESCALEX(345))];
//        [self.view addSubview:bgView];
//
//        WeakSelf
//        UIImageView *imageView = [[UIImageView alloc] init];
//        imageView.image = ImageWithNamed(@"banner2");
//        imageView.userInteractionEnabled = YES;
//        [bgView addSubview:imageView];
//        [imageView wy_setImageWithUrlString:self.item.imageUrls[i] placeholderImage:PlaceHolderMainImage];
//
//        UIView *infoView = [[UIView alloc] init];
//        infoView.backgroundColor = QHWhiteColor;
//        [bgView addSubview:infoView];
//
//        UILabel *titleLabel = [[UILabel alloc] init];
//        titleLabel.numberOfLines = 3;
//        titleLabel.font = TextFont(10);
//        titleLabel.textColor = QHBlackColor;
//        NSString *title = [NSString stringWithFormat:@"           %@",self.item.name];
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
//        text.yy_lineSpacing = AUTOSIZESCALEX(3);
//        titleLabel.attributedText = text;
//        [infoView addSubview:titleLabel];
//
//        UIButton *shipButton = [[UIButton alloc] init];
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
//        NSString *originPrice = [NSString stringWithFormat:@"原价 ¥ %.2f",self.item.price];
//        NSMutableAttributedString *origin = [[NSMutableAttributedString alloc] initWithString: originPrice];
//        [origin addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, origin.length)];
//        originalPriceLabel.attributedText = origin;
//        originalPriceLabel.font = TextFont(9);
//        originalPriceLabel.textColor = RGB(160, 160, 160);
//        [infoView addSubview:originalPriceLabel];
//
//        UILabel *discountPriceLabel = [[UILabel alloc] init];
//        NSString *discountPrice = [NSString stringWithFormat:@"券后价:¥ %.2f",self.item.discountPrice];
//        NSMutableAttributedString *discount = [[NSMutableAttributedString alloc] initWithString: discountPrice];
//        [discount addAttribute:NSForegroundColorAttributeName value:RGB(80, 80, 80) range:NSMakeRange(0, 4)];
//        discountPriceLabel.attributedText = discount;
//        discountPriceLabel.font = TextFont(9);
//        discountPriceLabel.textColor = QHMainColor;
//        [infoView addSubview:discountPriceLabel];
//
//        UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [ticketButton setTitle:[NSString stringWithFormat:@"%.0f元券",self.item.couponAmount] forState:UIControlStateNormal];
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
//            NSURL *url = [NSURL URLWithString: weakSelf.item.imageUrls[i]];
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
////            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.item.imageUrls[i]]];
////            UIImage *img = [UIImage imageWithData:data];
//
////            [[LoginUserDefault userDefault].shareImageArray addObject:img];
//        }
//
//
////        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
////            CGContextRef context = UIGraphicsGetCurrentContext();
////            [bgView.layer renderInContext:context];
////            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
////            UIGraphicsEndImageContext();
////
////            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.item.imageUrls[0]]];
////            UIImage *img = [UIImage imageWithData:data];
////
////            [WYPhotoLibraryManager savePhotoImage:img completion:^(UIImage *image, NSError *error) {
////                if (!error) {
////                    WYLog(@"保存图片成功");
////                    //                    [WYHud showMessage:@"保存图片成功"];
////                } else {
////                    WYLog(@"保存图片失败");
////                    //                    [WYHud showMessage:@"保存图片失败"];
////                }
////            }];
//
//
////            [WYPhotoLibraryManager savePhotoImage:image completion:^(UIImage *image, NSError *error) {
////                if (!error) {
////                    WYLog(@"保存图片成功");
//////                    [WYHud showMessage:@"保存图片成功"];
////                } else {
////                    WYLog(@"保存图片失败");
//////                    [WYHud showMessage:@"保存图片失败"];
////                }
////            }];
////        });
//
//
//    }
//
//
//}




@end
