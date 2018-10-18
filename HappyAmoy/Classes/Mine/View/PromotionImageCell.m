//
//  PromotionImageCell.m
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PromotionImageCell.h"
#import "PromotionItem.h"

@interface PromotionImageCell()

/**    图片    */
@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation PromotionImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage scaleAcceptFitWithImage:PlaceHolderMainImage imageViewSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(90))];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
}

#pragma mark - Setter
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    if (![NSString isEmpty:_imageUrl]) {
        UIImageView *cacheImageView = [[UIImageView alloc] init];
        // 缓存图片
        [cacheImageView wy_setImageWithUrlString:_imageUrl placeholderImage:PlaceHolderMainImage];
        if (self.index == 0) {
            [self snapWithQRCode];
        } else {
            WeakSelf
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            NSURL *url = [NSURL URLWithString: _imageUrl];
            [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
                if (isInCache) {
                    WYLog(@"图片缓存");
                    UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
                    weakSelf.imageView.image = [UIImage scaleAcceptFitWithImage:image imageViewSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(90))];
                } else {
                    WYLog(@"图片下载");
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        //从网络下载图片
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        UIImage *image = [UIImage imageWithData:data];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            weakSelf.imageView.image = [UIImage scaleAcceptFitWithImage:image imageViewSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(90))];
                        });
                    });
                }
            }];            
//            [self.imageView wy_setImageWithUrlString:imageUrl placeholderImage:PlaceHolderMainImage scaleAspectFit:YES imageViewSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(90))];
        }
    }
}

// 一张图片的时候需要组合二维码
- (void)snapWithQRCode {
    
    if (self.item.firstImage) {
        self.imageView.image = [UIImage scaleAcceptFitWithImage:self.item.firstImage imageViewSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(90))];
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
    iconImageView.layer.borderColor = ColorWithHexString(@"#FB4F67").CGColor;
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
    qCodeLabel.textColor = QHWhiteColor;
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
    NSURL *url = [NSURL URLWithString: self.imageUrl];
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache) {
            UIImage *image = [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
            imageView.image = image;
            UIGraphicsBeginImageContextWithOptions(bgView.bounds.size, NO, 0.0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [bgView.layer renderInContext:context];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.imageView.image = [UIImage scaleAcceptFitWithImage:img imageViewSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(90))];;
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
                    self.imageView.image = [UIImage scaleAcceptFitWithImage:img imageViewSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(90))];
                    self.item.firstImage = img;
                });
            });
        }
    }];

}


@end
