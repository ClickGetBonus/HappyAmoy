//
//  GlobalSearchShareController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GlobalSearchShareController.h"
#import "ShareImageCell.h"
#import "TaoBaoSearchItem.h"
#import "TaoBaoSearchDetailItem.h"
#import "ShareView.h"

@interface GlobalSearchShareController () <UICollectionViewDataSource,UICollectionViewDelegate,ShareViewDelegate>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    分享的视图    */
@property (strong, nonatomic) ShareView *shareView;

@end

static NSString *const shareCellId = @"shareCellId";

@implementation GlobalSearchShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    self.title = @"分享好友";
    [self setupNav];
    [self setupUI];
    [self screenShots];
    [self setupShareView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [WYProgress dismiss];
}

#pragma mark - Nav

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageOriginalWithNamed:@"icon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickSystemShare)];
}

#pragma mark - UI

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(AUTOSIZESCALEX(250), AUTOSIZESCALEX(345));
    layout.minimumLineSpacing = AUTOSIZESCALEX(15);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(15);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(15), 0, AUTOSIZESCALEX(15));
    [collectionView registerClass:[ShareImageCell class] forCellWithReuseIdentifier:shareCellId];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(15));
        make.left.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(345));
    }];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.layer.cornerRadius = AUTOSIZESCALEX(3);
    copyButton.layer.masksToBounds = YES;
    copyButton.titleLabel.font = TextFont(12);
    [copyButton setTitle:@"一键保存图片到相册" forState:UIControlStateNormal];
    [copyButton setTitleColor:QHBlackColor forState:UIControlStateNormal];
    [copyButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(125), AUTOSIZESCALEX(23)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [self.view addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(125));
        make.height.mas_equalTo(AUTOSIZESCALEX(23));
    }];
    
    [[copyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [WYProgress show];
        for (UIImage *image in [LoginUserDefault userDefault].shareImageArray) {
            [WYPhotoLibraryManager wy_savePhotoImage:image completion:^(UIImage *image, NSError *error) {
                if (!error) {
                } else {
                }
            }];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WYProgress showSuccessWithStatus:@"保存图片成功!"];
        });
        
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:line];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [LoginUserDefault userDefault].shareImageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShareImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareCellId forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.shareImage = [LoginUserDefault userDefault].shareImageArray[indexPath.row];
    //    cell.item = self.item;
    //    cell.isFirstImage = indexPath.row == 0;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYLog(@"indexPath = %zd",indexPath.row);
    [WYPackagePhotoBrowser showPhotoWithImageArray:[LoginUserDefault userDefault].shareImageArray currentIndex:indexPath.row];
}


#pragma mark - Button Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    //     创建UMSocialMessageObject实例进行分享
    //     分享数据对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // 图片或图文分享
    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:self.detailItem.title descr:@"" thumImage:[LoginUserDefault userDefault].shareImageArray[0]];
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
    titleLabel.font = TextFont(11);
    titleLabel.textColor = QHBlackColor;
    NSString *title = [NSString stringWithFormat:@"           %@",self.detailItem.title];
    //        NSString *title = [NSString stringWithFormat:@"           %@",self.detailItem.name];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
    text.yy_lineSpacing = AUTOSIZESCALEX(3);
    titleLabel.attributedText = text;
    [infoView addSubview:titleLabel];
    
    UIButton *shipButton = [[UIButton alloc] init];
    shipButton.layer.cornerRadius = 3;
    shipButton.layer.masksToBounds = YES;
    [shipButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(35), AUTOSIZESCALEX(18)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    shipButton.titleLabel.font = TextFont(10);
    [shipButton setTitle:@"包邮" forState:UIControlStateNormal];
    [shipButton setTintColor:QHWhiteColor];
    [infoView addSubview:shipButton];
    
    UILabel *originalPriceLabel = [[UILabel alloc] init];
    // 加横线
    NSString *originPrice = [NSString stringWithFormat:@"¥ %.2f",self.listItem.currentPrice];
//    NSMutableAttributedString *origin = [[NSMutableAttributedString alloc] initWithString: originPrice];
//    [origin addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, origin.length)];
    originalPriceLabel.text = originPrice;
    originalPriceLabel.font = TextFont(12);
    originalPriceLabel.textColor = QHMainColor;
    [infoView addSubview:originalPriceLabel];
    
//    UILabel *discountPriceLabel = [[UILabel alloc] init];
//    NSString *discountPrice = [NSString stringWithFormat:@"券后价:¥ %.2f",self.listItem.afterCouponPrice];
//    NSMutableAttributedString *discount = [[NSMutableAttributedString alloc] initWithString: discountPrice];
//    [discount addAttribute:NSForegroundColorAttributeName value:RGB(80, 80, 80) range:NSMakeRange(0, 4)];
//    discountPriceLabel.attributedText = discount;
//    discountPriceLabel.font = TextFont(9);
//    discountPriceLabel.textColor = QHMainColor;
//    [infoView addSubview:discountPriceLabel];
//
//    UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [ticketButton setTitle:[NSString stringWithFormat:@"%.0f元券",self.listItem.couponPrice] forState:UIControlStateNormal];
//    ticketButton.titleLabel.font = TextFont(9);
//    [ticketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
//    [ticketButton setBackgroundImage:ImageWithNamed(@"3元券bg") forState:UIControlStateNormal];
//    [infoView addSubview:ticketButton];
    
    UIView *qCodeBgView = [[UIView alloc] init];
    [infoView addSubview:qCodeBgView];
    
    UIImageView *qCodeImageView = [[UIImageView alloc] init];
    
    
    NSString *itemId = self.detailItem.numIid;
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
                
                
                // 截图
                UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
                CGContextRef context = UIGraphicsGetCurrentContext();
                [bgView.layer renderInContext:context];
                UIImage *image2 = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [[LoginUserDefault userDefault].shareImageArray insertObject:image2 atIndex:0];
                
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
    
//    [ticketButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(infoView).offset(AUTOSIZESCALEX(-7.5));
//        make.left.equalTo(titleLabel).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(47.5);
//        make.height.mas_equalTo(18);
//    }];
//
//    [discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(ticketButton).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(ticketButton.mas_right).offset(AUTOSIZESCALEX(5));
//    }];
    
    [originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(infoView).offset(AUTOSIZESCALEX(-7.5));
        make.left.equalTo(titleLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    [longPressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(-7.5));
        make.centerX.equalTo(borderImageView).offset(AUTOSIZESCALEX(0));
    }];
    
    NSURL *url = [NSURL URLWithString: self.listItem.pictUrl];
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache) {
            UIImage *img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            imageView.image = img;
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 从网络下载图片
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *img = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = img;
                });
            });
        }
    }];
    
    __block NSInteger count = 0;
    
    for (int i = 0; i < self.detailItem.smallImages.count; i++) {
        
        NSURL *url = [NSURL URLWithString: self.detailItem.smallImages[i]];
        [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
            UIImage *img;
            if (isInCache) {
                img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
                [[LoginUserDefault userDefault].shareImageArray addObject:img];
                count++;
                if (count == self.detailItem.smallImages.count) {
                    [WYProgress dismiss];
                    [self.collectionView reloadData];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareImage" object:nil];
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
                        if (count == self.detailItem.smallImages.count) {
                            [WYProgress dismiss];
                            [self.collectionView reloadData];
//                            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShareImage" object:nil];
                        }
                    });
                });
            }
        }];
    }
}


@end
