//
//  ShareImageCell.m
//  HappyAmoy
//
//  Created by apple on 2018/5/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareImageCell.h"
#import "CommodityDetailItem.h"

@interface ShareImageCell ()

/**    图片    */
@property (strong, nonatomic) UIImageView *imageView;
/**    详情view    */
@property (strong, nonatomic) UIView *infoView;
/**    包邮    */
@property (strong, nonatomic) UIButton *shipButton;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    原价    */
@property (strong, nonatomic) UILabel *originalPriceLabel;
/**    折扣价    */
@property (strong, nonatomic) UILabel *discountPriceLabel;
/**    券额    */
@property (strong, nonatomic) UIButton *ticketButton;
/**    二维码背景容器    */
@property (strong, nonatomic) UIView *qCodeBgView;
/**    二维码    */
@property (strong, nonatomic) UIImageView *qCodeImageView;
/**    边框线条    */
@property (strong, nonatomic) UIView *borderView;
/**    二维码边框    */
@property (strong, nonatomic) UIImageView *borderImageView;
/**    长按识别二维码    */
@property (strong, nonatomic) UILabel *longPressLabel;

@end

@implementation ShareImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = ImageWithNamed(@"banner2");
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

- (void)setShareImage:(UIImage *)shareImage {
    _shareImage = shareImage;
    self.imageView.image = shareImage;
    if (self.index == 0) {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    } else {
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(250), AUTOSIZESCALEX(250)));
        }];
    }
}

//- (void)setImageUrl:(NSString *)imageUrl {
//    _imageUrl = imageUrl;
//    [self.imageView wy_setImageWithUrlString:_imageUrl placeholderImage:PlaceHolderMainImage];
//}

//- (void)setIsFirstImage:(BOOL)isFirstImage {
//    _isFirstImage = isFirstImage;
//    self.qCodeBgView.hidden = !_isFirstImage;
//
//    if (_isFirstImage) {
//        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.infoView).offset(AUTOSIZESCALEX(10));
//            make.left.equalTo(self.infoView).offset(AUTOSIZESCALEX(10));
//            make.right.equalTo(self.qCodeBgView.mas_left).offset(AUTOSIZESCALEX(-10));
//        }];
//    } else {
//        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.infoView).offset(AUTOSIZESCALEX(10));
//            make.left.equalTo(self.infoView).offset(AUTOSIZESCALEX(10));
//            make.right.equalTo(self.infoView).offset(AUTOSIZESCALEX(-10));
//        }];
//    }
//}

//- (void)setItem:(CommodityDetailItem *)item {
//    _item = item;
//    if (_item) {
//        [self.imageView wy_setImageWithUrlString:_item.imageUrls[self.index] placeholderImage:PlaceHolderMainImage];
//        NSString *title = [NSString stringWithFormat:@"           %@",_item.name];
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
//        text.yy_lineSpacing = AUTOSIZESCALEX(3);
//        self.titleLabel.attributedText = text;
//
//        NSString *originPrice = [NSString stringWithFormat:@"原价 ¥ %.2f",_item.price];
//        NSMutableAttributedString *origin = [[NSMutableAttributedString alloc] initWithString: originPrice];
//        [origin addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, origin.length)];
//        self.originalPriceLabel.attributedText = origin;
//
//        [self.ticketButton setTitle:[NSString stringWithFormat:@"%.0f元券",_item.couponAmount] forState:UIControlStateNormal];
//
//        NSString *discountPrice = [NSString stringWithFormat:@"券后价:¥ %.2f",_item.discountPrice];
//        NSMutableAttributedString *discount = [[NSMutableAttributedString alloc] initWithString: discountPrice];
//        [discount addAttribute:NSForegroundColorAttributeName value:RGB(80, 80, 80) range:NSMakeRange(0, 4)];
//        self.discountPriceLabel.attributedText = discount;
//
//    }
//}










































//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self setupUI];
//    }
//    return self;
//}
//
//#pragma mark - UI
//
//- (void)setupUI {
//
//    UIView *bgView = [[UIView alloc] init];
//    [self.contentView addSubview:bgView];
//    self.bgView = bgView;
//    WeakSelf
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image = ImageWithNamed(@"banner2");
//    imageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//    [[tap rac_gestureSignal] subscribeNext:^(id x) {
//        [WYPackagePhotoBrowser showPhotoWithUrlArray:[NSMutableArray arrayWithArray:weakSelf.item.imageUrls] currentIndex:weakSelf.index];
//    }];
//    [imageView addGestureRecognizer:tap];
//    [self.bgView addSubview:imageView];
//    self.imageView = imageView;
//
//    UIView *infoView = [[UIView alloc] init];
//    infoView.backgroundColor = QHWhiteColor;
//    [self.bgView addSubview:infoView];
//    self.infoView = infoView;
//
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.numberOfLines = 3;
//    titleLabel.font = TextFont(10);
////    titleLabel.textColor = RGB(85, 85, 85);
//    titleLabel.textColor = QHBlackColor;
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: @"           抢！双十一邀请爆款返场2小时！高领羊绒套头毛衣针织衫"];
//    text.yy_lineSpacing = AUTOSIZESCALEX(3);
//    titleLabel.attributedText = text;
//    [self.infoView addSubview:titleLabel];
//    self.titleLabel = titleLabel;
//
//    UIButton *shipButton = [[UIButton alloc] init];
//    shipButton.layer.cornerRadius = 3;
//    shipButton.layer.masksToBounds = YES;
//    [shipButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(35), AUTOSIZESCALEX(18)) colorArray:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
//    shipButton.titleLabel.font = TextFont(10);
//    [shipButton setTitle:@"包邮" forState:UIControlStateNormal];
//    [shipButton setTintColor:QHWhiteColor];
//    [self.infoView addSubview:shipButton];
//    self.shipButton = shipButton;
//
//    UILabel *originalPriceLabel = [[UILabel alloc] init];
//    // 加横线
//    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString: @"原价 ¥ 288.00"];
//    [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
//    originalPriceLabel.attributedText = attribtStr;
//    originalPriceLabel.font = TextFont(9);
//    originalPriceLabel.textColor = RGB(160, 160, 160);
//    [self.infoView addSubview:originalPriceLabel];
//    self.originalPriceLabel = originalPriceLabel;
//
//    UILabel *discountPriceLabel = [[UILabel alloc] init];
//    discountPriceLabel.font = TextFont(9);
//    discountPriceLabel.textColor = QHMainColor;
//    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString: @"券后价:¥ 49.00"];
//    [attribute addAttribute:NSForegroundColorAttributeName value:RGB(80, 80, 80) range:NSMakeRange(0, 4)];
//    discountPriceLabel.attributedText = attribute;
//    [self.infoView addSubview:discountPriceLabel];
//    self.discountPriceLabel = discountPriceLabel;
//
//    UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [ticketButton setTitle:@"200元券" forState:UIControlStateNormal];
//    ticketButton.titleLabel.font = TextFont(9);
//    [ticketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
//    [ticketButton setBackgroundImage:ImageWithNamed(@"3元券bg") forState:UIControlStateNormal];
//    [self.infoView addSubview:ticketButton];
//    self.ticketButton = ticketButton;
//
//    UIView *qCodeBgView = [[UIView alloc] init];
//    [self.infoView addSubview:qCodeBgView];
//    self.qCodeBgView = qCodeBgView;
//
//    UIImageView *qCodeImageView = [[UIImageView alloc] init];
//    [qCodeImageView wy_setImageWithUrlString:[LoginUserDefault userDefault].userItem.recommendQcodePathUrl placeholderImage:PlaceHolderMainImage];
//    qCodeImageView.userInteractionEnabled = YES;
//    [self.qCodeBgView addSubview:qCodeImageView];
//    self.qCodeImageView = qCodeImageView;
//
//    UIImageView *borderImageView = [[UIImageView alloc] init];
//    borderImageView.image = ImageWithNamed(@"二维码边框");
//    [self.qCodeBgView addSubview:borderImageView];
//    self.borderImageView = borderImageView;
//
//    UIView *borderView = [[UIView alloc] init];
//    borderView.layer.borderColor = QHMainColor.CGColor;
//    borderView.layer.borderWidth = AUTOSIZESCALEX(0.5);
//    [self.qCodeBgView addSubview:borderView];
//    self.borderView = borderView;
//
//    UILabel *longPressLabel = [[UILabel alloc] init];
//    longPressLabel.font = TextFont(6.5);
//    longPressLabel.textColor = QHMainColor;
//    longPressLabel.text = @"长按识别二维码";
//    [self.qCodeBgView addSubview:longPressLabel];
//    self.longPressLabel = longPressLabel;
//
//    [self addConstraints];
//}
//
//#pragma mark - Layout
//
//- (void)addConstraints {
//
//    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
//
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.bgView).offset(AUTOSIZESCALEX(0));
//        make.height.mas_equalTo(250);
//    }];
//
//    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.imageView.mas_bottom).offset(AUTOSIZESCALEX(0));
//        make.left.right.bottom.equalTo(self.bgView).offset(AUTOSIZESCALEX(0));
//    }];
//
//    [self.qCodeBgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.bottom.equalTo(self.infoView).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(85);
//    }];
//
//    [self.qCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.qCodeBgView).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.qCodeBgView).offset(AUTOSIZESCALEX(-15));
//        make.width.mas_equalTo(70);
//        make.height.mas_equalTo(70);
//    }];
//
//    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.qCodeImageView).offset(AUTOSIZESCALEX(0));
////        make.right.equalTo(self.infoView).offset(AUTOSIZESCALEX(-15));
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(60);
//    }];
//
//    [self.borderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.qCodeBgView).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.qCodeBgView).offset(AUTOSIZESCALEX(-15));
//        make.width.mas_equalTo(70);
//        make.height.mas_equalTo(70);
//    }];
//
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.infoView).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(self.infoView).offset(AUTOSIZESCALEX(10));
//        make.right.equalTo(self.qCodeBgView.mas_left).offset(AUTOSIZESCALEX(-10));
//    }];
//
//    [self.shipButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(25);
//        make.height.mas_equalTo(13);
//    }];
//
//    [self.ticketButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.infoView).offset(AUTOSIZESCALEX(-7.5));
//        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(47.5);
//        make.height.mas_equalTo(18);
//    }];
//
//    [self.discountPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.ticketButton).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(self.ticketButton.mas_right).offset(AUTOSIZESCALEX(5));
//    }];
//
//    [self.originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.ticketButton.mas_top).offset(AUTOSIZESCALEX(-3.5));
//        make.left.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
//    }];
//
//    [self.longPressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.qCodeBgView).offset(AUTOSIZESCALEX(-7.5));
//        make.centerX.equalTo(self.borderImageView).offset(AUTOSIZESCALEX(0));
//    }];
//}
//
//#pragma mark - Setter
//
//- (void)setIsFirstImage:(BOOL)isFirstImage {
//    _isFirstImage = isFirstImage;
//    self.qCodeBgView.hidden = !_isFirstImage;
//
//    if (_isFirstImage) {
//        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.infoView).offset(AUTOSIZESCALEX(10));
//            make.left.equalTo(self.infoView).offset(AUTOSIZESCALEX(10));
//            make.right.equalTo(self.qCodeBgView.mas_left).offset(AUTOSIZESCALEX(-10));
//        }];
//    } else {
//        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.infoView).offset(AUTOSIZESCALEX(10));
//            make.left.equalTo(self.infoView).offset(AUTOSIZESCALEX(10));
//            make.right.equalTo(self.infoView).offset(AUTOSIZESCALEX(-10));
//        }];
//    }
//}
//
//- (void)setItem:(CommodityDetailItem *)item {
//    _item = item;
//    if (_item) {
//        [self.imageView wy_setImageWithUrlString:_item.imageUrls[self.index] placeholderImage:PlaceHolderMainImage];
//        NSString *title = [NSString stringWithFormat:@"           %@",_item.name];
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
//        text.yy_lineSpacing = AUTOSIZESCALEX(3);
//        self.titleLabel.attributedText = text;
//
//        NSString *originPrice = [NSString stringWithFormat:@"原价 ¥ %.2f",_item.price];
//        NSMutableAttributedString *origin = [[NSMutableAttributedString alloc] initWithString: originPrice];
//        [origin addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, origin.length)];
//        self.originalPriceLabel.attributedText = origin;
//
//        [self.ticketButton setTitle:[NSString stringWithFormat:@"%.0f元券",_item.couponAmount] forState:UIControlStateNormal];
//
//        NSString *discountPrice = [NSString stringWithFormat:@"券后价:¥ %.2f",_item.discountPrice];
//        NSMutableAttributedString *discount = [[NSMutableAttributedString alloc] initWithString: discountPrice];
//        [discount addAttribute:NSForegroundColorAttributeName value:RGB(80, 80, 80) range:NSMakeRange(0, 4)];
//        self.discountPriceLabel.attributedText = discount;
//
//    }
//}





























@end
