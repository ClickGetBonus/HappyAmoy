//
//  PromotionCell.m
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PromotionCell.h"
#import "PromotionImageCell.h"
#import "PromotionItem.h"

@interface PromotionCell() <UICollectionViewDelegate,UICollectionViewDataSource>

/**    日期    */
@property (strong, nonatomic) UILabel *dateLabel;
/**    内容    */
@property (strong, nonatomic) UILabel *contentLabel;
/**    图片九宫格    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    一张图片的显示    */
@property (strong, nonatomic) UIImageView *oneImageView;
/**    保存图片按钮    */
@property (strong, nonatomic) UIButton *saveImageButton;
/**    复制文字按钮    */
@property (strong, nonatomic) UIButton *wordCopyButton;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

static NSString *const imageCellId = @"imageCellId";

@implementation PromotionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    // 日期
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.font = TextFont(14);
    dateLabel.textColor = ColorWithHexString(@"#666666");
    dateLabel.text = @"4月10日";
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = TextFont(14);
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = ColorWithHexString(@"#333333");
    [contentLabel wy_setAttributedText:@"交易源于每一分积累\n财富来自不断的积累" lineSpacing:AUTOSIZESCALEX(5)];
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    // 一张图片
    UIImageView *oneImageView = [[UIImageView alloc] init];
    oneImageView.userInteractionEnabled = YES;
    [oneImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkImage)]];
    oneImageView.hidden = YES;
    [self.contentView addSubview:oneImageView];
    self.oneImageView = oneImageView;
    
    // 图片九宫格
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat itemWH = ((SCREEN_WIDTH - AUTOSIZESCALEX(80) - AUTOSIZESCALEX(15) - AUTOSIZESCALEX(6) * 2) / 3);
    
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    layout.minimumLineSpacing = AUTOSIZESCALEX(5);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(5);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(AUTOSIZESCALEX(0), AUTOSIZESCALEX(0), AUTOSIZESCALEX(0), AUTOSIZESCALEX(0));
    [collectionView registerClass:[PromotionImageCell class] forCellWithReuseIdentifier:imageCellId];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    CGFloat buttonFont = 13;
    UIColor *buttonTitleColor = ColorWithHexString(@"#999999");
    // 保存图片按钮
    UIButton *saveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveImageButton setImage:ImageWithNamed(@"保存") forState:UIControlStateNormal];
    [saveImageButton setTitle:@"  保存图片" forState:UIControlStateNormal];
    saveImageButton.titleLabel.font = TextFont(buttonFont);
    [saveImageButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [saveImageButton addTarget:self action:@selector(didClickSaveImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:saveImageButton];
    self.saveImageButton = saveImageButton;
    
    // 复制文字按钮
    UIButton *wordCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [wordCopyButton setImage:ImageWithNamed(@"复制(1)") forState:UIControlStateNormal];
    [wordCopyButton setTitle:@"  复制文字" forState:UIControlStateNormal];
    wordCopyButton.titleLabel.font = TextFont(buttonFont);
    [wordCopyButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
    [wordCopyButton addTarget:self action:@selector(didClickCopyWordButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:wordCopyButton];
    self.wordCopyButton = wordCopyButton;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(50));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(80));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
    
    [self.oneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentLabel).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(110));
        make.height.mas_equalTo(AUTOSIZESCALEX(195));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentLabel).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(0));
    }];
    
    [self.wordCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.right.equalTo(self.contentLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.saveImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.wordCopyButton);
        make.right.equalTo(self.wordCopyButton.mas_left).offset(AUTOSIZESCALEX(-15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Setter

- (void)setImagesArray:(NSMutableArray *)imagesArray {
    _imagesArray = imagesArray;
    [self updateCollectionViewHeight];
}

- (void)setItem:(PromotionItem *)item {
    _item = item;
    if (_item) {
        self.contentLabel.text = _item.title;
        self.dateLabel.text = _item.createTime;
        self.imagesArray = [NSMutableArray arrayWithArray:_item.images];
        [self updateCollectionViewHeight];
    }
}

#pragma mark - Button Action

// 查看一张图片
- (void)checkImage {
    //    if (_item.videos.count > 0) {
    //        [self didClickPlayButton:self.playButton];
    //    } else {
    //        NSMutableArray *urlArray = [NSMutableArray array];
    //        for (QHForumImageItem *item in self.imagesArray) {
    //            [urlArray addObject:item.originalUrl];
    //        }
    //        [WYPackagePhotoBrowser showPhotoWithUrlArray:urlArray currentIndex:0];
    //    }
    
    [WYPackagePhotoBrowser showPhotoWithImageArray:[NSMutableArray arrayWithArray:@[self.item.firstImage]] currentIndex:0];
//    [WYPackagePhotoBrowser showPhotoWithUrlArray:self.imagesArray currentIndex:0];
}

// 保存图片
- (void)didClickSaveImageButton:(UIButton *)sender {
    
    if (self.imagesArray.count == 0) {
        return;
    }
    
    [WYProgress showWithStatus:@"保存图片中..."];
    
    if (self.imagesArray.count == 1) {
        [WYPhotoLibraryManager wy_savePhotoImage:self.item.firstImage completion:^(UIImage *image, NSError *error) {
            if (!error) {
                [WYProgress showSuccessWithStatus:@"保存图片成功!"];
            }
        }];
        return;
    } else {
        [WYPhotoLibraryManager wy_savePhotoImage:self.item.firstImage completion:^(UIImage *image, NSError *error) {
            if (!error) {

            }
        }];
        for (int i = 1; i < self.imagesArray.count; i++) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            NSURL *url = [NSURL URLWithString: self.imagesArray[i]];
            [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
                if (isInCache) {
                    WYLog(@"图片缓存");
                    UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
                    [WYPhotoLibraryManager wy_savePhotoImage:image completion:^(UIImage *image, NSError *error) {
                        if (!error) {
                            
                        }
                    }];
                } else {
                    WYLog(@"图片下载");
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        //从网络下载图片
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        UIImage *image = [UIImage imageWithData:data];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [WYPhotoLibraryManager wy_savePhotoImage:image completion:^(UIImage *image, NSError *error) {
                                if (!error) {
                                    
                                }
                            }];
                        });
                    });
                }
            }];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WYProgress showSuccessWithStatus:@"保存图片成功!"];
    });
}

// 复制文字
- (void)didClickCopyWordButton:(UIButton *)sender {
    if ([NSString isEmpty:self.item.title]) {
        return;
    }
    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.item.title;
    
    [WYHud showMessage:@"已复制到剪贴板!"];
    
    WYLog(@"复制的内容 = %@",self.item.title);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imagesArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PromotionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellId forIndexPath:indexPath];
    cell.item = self.item;
    cell.index = indexPath.row;
    cell.imageUrl = self.imagesArray[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.collectionView == collectionView) {
//        NSMutableArray *urlArray = [NSMutableArray array];
//        for (NSString *url in self.imagesArray) {
//            [urlArray addObject:url];
//        }
//        [WYPackagePhotoBrowser showPhotoWithUrlArray:urlArray currentIndex:indexPath.row];
//    }
    
    
    NSMutableArray *cacheArray = [NSMutableArray array];
    
    [cacheArray addObject:self.item.firstImage];
    
    __block NSInteger count = 1;
    for (int i = 1; i < self.imagesArray.count; i++) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        NSURL *url = [NSURL URLWithString: self.imagesArray[i]];
        [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
            if (isInCache) {
                WYLog(@"图片缓存");
                count++;
                UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
                [cacheArray addObject:image];
                if (count == self.imagesArray.count) {
                    [WYPackagePhotoBrowser showPhotoWithImageArray:cacheArray currentIndex:indexPath.row];
                }
            } else {
                WYLog(@"图片下载");
                count++;
                //从网络下载图片
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                [cacheArray addObject:image];
                if (count == self.imagesArray.count) {
                    [WYPackagePhotoBrowser showPhotoWithImageArray:cacheArray currentIndex:indexPath.row];
                }
            }
        }];
    }
    
    WYLog(@"indexPath = %zd",indexPath.row);
}

#pragma mark - Setter


#pragma mark - Private method

// 更新 collectionView 的高度
- (void)updateCollectionViewHeight {
    
    CGFloat collectionViewHeight = 0;
    
    if (_imagesArray.count > 0) {
        if (_imagesArray.count == 1) { // 只有一张图片
            self.oneImageView.hidden = NO;
            self.collectionView.hidden = YES;
            
            CGSize imageSize = CGSizeMake(AUTOSIZESCALEX(110), AUTOSIZESCALEX(195));
            
            //            self.oneImageView.image = self.imagesArray[0];
//            [self.oneImageView wy_setImageWithUrlString:self.imagesArray[0] placeholderImage:PlaceHolderImage scaleAspectFit:YES imageViewSize:imageSize radious:0];
            // 主要是为了缓存图片
            UIImageView *cacheImageView = [[UIImageView alloc] init];
            [cacheImageView wy_setImageWithUrlString:self.imagesArray[0] placeholderImage:PlaceHolderImage scaleAspectFit:YES imageViewSize:imageSize radious:0];

            [self snapWithQRCode];
            [self.oneImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(imageSize);
            }];
        } else {
            self.oneImageView.hidden = YES;
            self.collectionView.hidden = NO;
            NSInteger row = ((_imagesArray.count - 1) / 3 + 1);
            CGFloat itemWH = ((SCREEN_WIDTH - AUTOSIZESCALEX(80) - AUTOSIZESCALEX(15) - AUTOSIZESCALEX(6) * 2) / 3);
            
            collectionViewHeight = row * itemWH + (row - 1) * DynamicImageItemSpace;
            
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(collectionViewHeight);
            }];
            [self.collectionView reloadData];
        }
    } else {
        self.collectionView.hidden = self.oneImageView.hidden = YES;
    }
}

// 一张图片的时候需要组合二维码
- (void)snapWithQRCode {
    
    if (self.item.firstImage) {
        self.oneImageView.image = self.item.firstImage;
        return;
    }
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self addSubview:bgView];
    
    WeakSelf
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = ImageWithNamed(@"banner2");
    imageView.userInteractionEnabled = YES;
    [bgView addSubview:imageView];
    
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = QHWhiteColor;
    [bgView addSubview:infoView];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.layer.borderColor = ColorWithHexString(@"#ffb42b").CGColor;
    iconImageView.layer.borderWidth = AUTOSIZESCALEX(0.5);
    iconImageView.layer.cornerRadius = AUTOSIZESCALEX(65) * 0.5;
    iconImageView.layer.masksToBounds = YES;
    [infoView addSubview:iconImageView];
    if ([NSString isEmpty:[LoginUserDefault userDefault].userItem.headpicUrl]) {
        iconImageView.image = PlaceHolderImage;
    } else {
        NSURL *headpicUrl = [NSURL URLWithString: [LoginUserDefault userDefault].userItem.headpicUrl];
        [manager diskImageExistsForURL:headpicUrl completion:^(BOOL isInCache) {
            if (isInCache) {
                UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:headpicUrl.absoluteString];
                iconImageView.image = [UIImage scaleAcceptFitWithImage:image imageViewSize:CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(65))];
            } else {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //从网络下载图片
                    NSData *data = [NSData dataWithContentsOfURL:headpicUrl];
                    UIImage *image = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        iconImageView.image = [UIImage scaleAcceptFitWithImage:image imageViewSize:CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(65))];
                    });
                });
            }
        }];
    }
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = [NSString stringWithFormat:@"我是%@",[LoginUserDefault userDefault].userItem.nickname];
    nameLabel.textColor = ColorWithHexString(@"666666");
    nameLabel.font = TextFont(15);
    [infoView addSubview:nameLabel];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.text = [NSString stringWithFormat:@"我为好麦代言"];
    descLabel.textColor = ColorWithHexString(@"666666");
    descLabel.font = TextFont(15);
    [infoView addSubview:descLabel];
    
    UILabel *promotionLabel = [[UILabel alloc] init];
    promotionLabel.text = [NSString stringWithFormat:@"好麦，有你更生态"];
    promotionLabel.textColor = ColorWithHexString(@"#ffb42b");
    promotionLabel.font = TextFont(15);
    [infoView addSubview:promotionLabel];

    
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
    [qCodeBgView addSubview:qCodeImageView];
    
    UILabel *qCodeLabel = [[UILabel alloc] init];
    qCodeLabel.text = [NSString stringWithFormat:@"麦"];
    qCodeLabel.textAlignment = NSTextAlignmentCenter;
    qCodeLabel.backgroundColor = ColorWithHexString(@"#ffb42b");
    qCodeLabel.layer.cornerRadius = AUTOSIZESCALEX(11.5);
    qCodeLabel.layer.masksToBounds = YES;
    qCodeLabel.textColor = QHBlackColor;
    qCodeLabel.font = TextFont(14);
    [qCodeBgView addSubview:qCodeLabel];

    
    // 约束
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bgView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SCREEN_HEIGHT - AUTOSIZESCALEX(150));
    }];
    
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.right.bottom.equalTo(bgView).offset(AUTOSIZESCALEX(0));
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView).offset(AUTOSIZESCALEX(30));
        make.left.equalTo(infoView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(65);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(iconImageView.mas_right).offset(AUTOSIZESCALEX(15));
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconImageView).offset(AUTOSIZESCALEX(-10));
        make.left.equalTo(iconImageView.mas_right).offset(AUTOSIZESCALEX(15));
    }];
    
    [promotionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(AUTOSIZESCALEX(13));
        make.left.equalTo(iconImageView).offset(AUTOSIZESCALEX(0));
    }];

    [qCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(infoView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(150);
    }];
    
    [qCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(qCodeBgView).offset(AUTOSIZESCALEX(-10));
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(130);
    }];
    
    [qCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(qCodeBgView);
        make.width.mas_equalTo(23);
        make.height.mas_equalTo(23);
    }];

//
    NSURL *url = [NSURL URLWithString: self.imagesArray[0]];
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache) {
            UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            imageView.image = image;
            UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [bgView.layer renderInContext:context];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.oneImageView.image = img;
            self.item.firstImage = img;
        } else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //从网络下载图片
                NSData *data = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                    UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
                    CGContextRef context = UIGraphicsGetCurrentContext();
                    [bgView.layer renderInContext:context];
                    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    self.oneImageView.image = img;
                    self.item.firstImage = img;
                });
            });
        }
    }];

//    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
//        if (isInCache) {
//            UIImage *img = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
//            imageView.image = img;
//
//            UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            [bgView.layer renderInContext:context];
//            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//
//            [[LoginUserDefault userDefault].shareImageArray insertObject:image atIndex:0];
//
//        } else {
//            //                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            //从网络下载图片
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            UIImage *img = [UIImage imageWithData:data];
//            //                        dispa .tch_async(dispatch_get_main_queue(), ^{
//            imageView.image = img;
//
//            UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
//            CGContextRef context = UIGraphicsGetCurrentContext();
//            [bgView.layer renderInContext:context];
//            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//
//            [[LoginUserDefault userDefault].shareImageArray insertObject:image atIndex:0];
//            //                        });
//            //                    });
//        }
//    }];
    
       
}























































//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setupUI];
////        [self.imagesArray addObject:@"123"];
////        [self.imagesArray addObject:@"123"];
////        [self.imagesArray addObject:@"123"];
////        [self.imagesArray addObject:@"123"];
////        [self.imagesArray addObject:@"123"];
////        [self.imagesArray addObject:@"123"];
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    return self;
//}
//
//#pragma mark - Lazy load
//
//#pragma mark - UI
//
//- (void)setupUI {
//
//    // 日期
//    UILabel *dateLabel = [[UILabel alloc] init];
//    dateLabel.font = TextFont(14);
//    dateLabel.textColor = ColorWithHexString(@"#666666");
//    dateLabel.text = @"4月10日";
//    dateLabel.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:dateLabel];
//    self.dateLabel = dateLabel;
//
//    // 内容
//    UILabel *contentLabel = [[UILabel alloc] init];
//    contentLabel.font = TextFont(14);
//    contentLabel.numberOfLines = 0;
//    contentLabel.textColor = ColorWithHexString(@"#333333");
//    [contentLabel wy_setAttributedText:@"交易源于每一分积累\n财富来自不断的积累" lineSpacing:AUTOSIZESCALEX(5)];
//    [self.contentView addSubview:contentLabel];
//    self.contentLabel = contentLabel;
//
//    // 一张图片
//    UIImageView *oneImageView = [[UIImageView alloc] init];
//    oneImageView.userInteractionEnabled = YES;
//    [oneImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkImage)]];
//    oneImageView.hidden = YES;
//    [self.contentView addSubview:oneImageView];
//    self.oneImageView = oneImageView;
//
//    // 图片九宫格
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//
//    CGFloat itemWH = ((SCREEN_WIDTH - AUTOSIZESCALEX(80) - AUTOSIZESCALEX(15) - AUTOSIZESCALEX(6) * 2) / 3);
//
//    layout.itemSize = CGSizeMake(itemWH, itemWH);
//    layout.minimumLineSpacing = AUTOSIZESCALEX(5);
//    layout.minimumInteritemSpacing = AUTOSIZESCALEX(5);
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//    collectionView.delegate = self;
//    collectionView.dataSource = self;
//    collectionView.backgroundColor = QHWhiteColor;
//    collectionView.showsHorizontalScrollIndicator = NO;
//    collectionView.contentInset = UIEdgeInsetsMake(AUTOSIZESCALEX(0), AUTOSIZESCALEX(0), AUTOSIZESCALEX(0), AUTOSIZESCALEX(0));
//    [collectionView registerClass:[PromotionImageCell class] forCellWithReuseIdentifier:imageCellId];
//    [self.contentView addSubview:collectionView];
//    self.collectionView = collectionView;
//
//    CGFloat buttonFont = 13;
//    UIColor *buttonTitleColor = ColorWithHexString(@"#999999");
//    // 保存图片按钮
//    UIButton *saveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [saveImageButton setImage:ImageWithNamed(@"保存") forState:UIControlStateNormal];
//    [saveImageButton setTitle:@"  保存图片" forState:UIControlStateNormal];
//    saveImageButton.titleLabel.font = TextFont(buttonFont);
//    [saveImageButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
//    [saveImageButton addTarget:self action:@selector(didClickSaveImageButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:saveImageButton];
//    self.saveImageButton = saveImageButton;
//
//    // 复制文字按钮
//    UIButton *wordCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [wordCopyButton setImage:ImageWithNamed(@"复制(1)") forState:UIControlStateNormal];
//    [wordCopyButton setTitle:@"  复制文字" forState:UIControlStateNormal];
//    wordCopyButton.titleLabel.font = TextFont(buttonFont);
//    [wordCopyButton setTitleColor:buttonTitleColor forState:UIControlStateNormal];
//    [wordCopyButton addTarget:self action:@selector(didClickCopyWordButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:wordCopyButton];
//    self.wordCopyButton = wordCopyButton;
//
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = LineColor;
//    [self.contentView addSubview:line];
//    self.line = line;
//
//    [self addConstraints];
//}
//
//#pragma mark - Layout
//
//- (void)addConstraints {
//
//    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
//        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
//        make.width.mas_equalTo(AUTOSIZESCALEX(50));
//    }];
//
//    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.dateLabel).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(80));
//        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
//    }];
//
//    [self.oneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
//        make.left.equalTo(self.contentLabel).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(AUTOSIZESCALEX(110));
//        make.height.mas_equalTo(AUTOSIZESCALEX(195));
//    }];
//
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
//        make.left.equalTo(self.contentLabel).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.contentLabel).offset(AUTOSIZESCALEX(0));
//        make.height.mas_equalTo(AUTOSIZESCALEX(0));
//    }];
//
//    [self.wordCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
//        make.right.equalTo(self.contentLabel).offset(AUTOSIZESCALEX(0));
//    }];
//
//    [self.saveImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.wordCopyButton);
//        make.right.equalTo(self.wordCopyButton.mas_left).offset(AUTOSIZESCALEX(-15));
//    }];
//
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
//        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
//        make.height.mas_equalTo(0.5);
//    }];
//}
//
//#pragma mark - Setter
//
//- (void)setImagesArray:(NSMutableArray *)imagesArray {
//    _imagesArray = imagesArray;
//    [self updateCollectionViewHeight];
//}
//
//- (void)setItem:(PromotionItem *)item {
//    _item = item;
//    if (_item) {
//        self.contentLabel.text = _item.title;
//        self.dateLabel.text = _item.createTime;
//        self.imagesArray = [NSMutableArray arrayWithArray:_item.images];
//        [self updateCollectionViewHeight];
//    }
//}
//
//#pragma mark - Button Action
//
//// 查看一张图片
//- (void)checkImage {
////    if (_item.videos.count > 0) {
////        [self didClickPlayButton:self.playButton];
////    } else {
////        NSMutableArray *urlArray = [NSMutableArray array];
////        for (QHForumImageItem *item in self.imagesArray) {
////            [urlArray addObject:item.originalUrl];
////        }
////        [WYPackagePhotoBrowser showPhotoWithUrlArray:urlArray currentIndex:0];
////    }
//    [WYPackagePhotoBrowser showPhotoWithUrlArray:self.imagesArray currentIndex:0];
//}
//
//// 保存图片
//- (void)didClickSaveImageButton:(UIButton *)sender {
//
//    [WYProgress showWithStatus:@"保存图片中..."];
//
//    for (int i = 0; i < self.imagesArray.count; i++) {
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imagesArray[i]]]];
//
//        [WYPhotoLibraryManager wy_savePhotoImage:image completion:^(UIImage *image, NSError *error) {
//            if (!error) {
//
//            }
//        }];
//    }
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [WYProgress showSuccessWithStatus:@"保存图片成功!"];
//    });
//}
//
//// 复制文字
//- (void)didClickCopyWordButton:(UIButton *)sender {
//    if ([NSString isEmpty:self.item.title]) {
//        return;
//    }
//    UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
//
//    pasteboard.string = self.item.title;
//
//    [WYHud showMessage:@"已复制到剪贴板!"];
//
//    WYLog(@"复制的内容 = %@",self.item.title);
//}
//
//#pragma mark - UICollectionViewDataSource
//
//- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.imagesArray.count;
//}
//
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    PromotionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellId forIndexPath:indexPath];
//    cell.imageUrl = self.imagesArray[indexPath.row];
//    return cell;
//
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (self.collectionView == collectionView) {
//        NSMutableArray *urlArray = [NSMutableArray array];
//        for (NSString *url in self.imagesArray) {
//            [urlArray addObject:url];
//        }
//        [WYPackagePhotoBrowser showPhotoWithUrlArray:urlArray currentIndex:indexPath.row];
//    }
//
////    [WYPackagePhotoBrowser showPhotoWithImageArray:self.imagesArray currentIndex:indexPath.row];
//
//    WYLog(@"indexPath = %zd",indexPath.row);
//}
//
//#pragma mark - Setter
//
//
//#pragma mark - Private method
//
//// 更新 collectionView 的高度
//- (void)updateCollectionViewHeight {
//
//    CGFloat collectionViewHeight = 0;
//
//    if (_imagesArray.count > 0) {
//        if (_imagesArray.count == 1) { // 只有一张图片
//            self.oneImageView.hidden = NO;
//            self.collectionView.hidden = YES;
//
//            CGSize imageSize = CGSizeMake(AUTOSIZESCALEX(110), AUTOSIZESCALEX(195));
//
////            self.oneImageView.image = self.imagesArray[0];
//            [self.oneImageView wy_setImageWithUrlString:self.imagesArray[0] placeholderImage:PlaceHolderImage scaleAspectFit:YES imageViewSize:imageSize radious:0];
//
//            [self.oneImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(imageSize);
//            }];
//        } else {
//            self.oneImageView.hidden = YES;
//            self.collectionView.hidden = NO;
//            NSInteger row = ((_imagesArray.count - 1) / 3 + 1);
//            CGFloat itemWH = ((SCREEN_WIDTH - AUTOSIZESCALEX(80) - AUTOSIZESCALEX(15) - AUTOSIZESCALEX(6) * 2) / 3);
//
//            collectionViewHeight = row * itemWH + (row - 1) * DynamicImageItemSpace;
//
//            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(collectionViewHeight);
//            }];
//            [self.collectionView reloadData];
//        }
//    } else {
//        self.collectionView.hidden = self.oneImageView.hidden = YES;
//    }
//}

@end
