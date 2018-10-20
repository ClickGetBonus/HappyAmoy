//
//  PastePopupView.m
//  HappyAmoy
//
//  Created by Lan on 2018/10/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PastePopupView.h"
#import "PasteResponseItem.h"
#import "WYTabBarController.h"
#import "WYNavigationController.h"
#import "NewSearchGoodsDetailController.h"
#import "GlobalSearchController.h"

@interface PastePopupView()

/**    类型(0 商品详情, 1 搜索内容)   */
@property (assign, nonatomic) NSInteger type;
/**    内容   */
@property (strong, nonatomic) PasteResponseItem *item;


/**    遮罩    */
@property (strong, nonatomic) UIView *maskView;
/**    弹框    */
@property (strong, nonatomic) UIView *popupView;

@property(nonatomic, strong) UIImageView *mineCommisionBg;
/**    图标    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    优惠券类型    */
@property (strong, nonatomic) UILabel *ticketTypeLabel;
///**    标题    */
//@property (strong, nonatomic) YYLabel *titleLabel;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    原价    */
@property (strong, nonatomic) UILabel *originalPriceLabel;
/**    折扣价    */
@property (strong, nonatomic) UILabel *discountPriceLabel;
/**    优惠券    */
@property (strong, nonatomic) UIButton *ticketButton;
/**    预估佣金    */
@property(nonatomic,strong) UILabel *mineCommisionLabel;
//**   背景       */
@property(nonatomic,strong) UIImageView *mineCommisionView;
/**    跳转按钮    */
@property(nonatomic,strong) UIButton *openButton;
/**    关闭按钮    */
@property(nonatomic,strong) UIButton *closeButton;

@property(nonatomic, strong) UIImageView *tagBgView;

@end

@implementation PastePopupView

+ (instancetype)showByType:(NSInteger)type data:(id)data {
    
    PastePopupView *popupView = [[PastePopupView alloc] initWithFrame:SCREEN_FRAME];
    
    [popupView setupUIByType:type];
    [popupView configureByData:data];
    
    [popupView setupConstraints];
    
    [popupView show];
    
    return popupView;
}


#pragma mark - Public method

- (void)show {
    
    self.alpha = 0;
    
    WeakSelf
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:DEFAULT_DURATION animations:^{
        weakSelf.alpha = 1.0;
    }];
}

- (void)dismiss {
    
    WeakSelf
    
    [UIView animateWithDuration:DEFAULT_DURATION animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}



#pragma mark - UI


- (void)configureByData:(id)data {
    
    
    PasteResponseItem *item = [PasteResponseItem mj_objectWithKeyValues:data];
    self.item = item;
    
    if (self.type == 0) {
        
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:PlaceHolderMainImage];
        //        self.titleLabel.text = [NSString stringWithFormat:@"          %@",_item.name];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@",item.name]];
        text.yy_lineSpacing = AUTOSIZESCALEX(5);
        self.titleLabel.attributedText = text;
        
        self.originalPriceLabel.text = [NSString stringWithFormat:@"原价:¥ %@",item.price];
        self.discountPriceLabel.text = [NSString stringWithFormat:@"券后价 ¥ %@",item.discountPrice];
        [self.ticketButton setTitle:[NSString stringWithFormat:@"%@元券",item.couponAmount] forState:UIControlStateNormal];
        self.mineCommisionLabel.text = [NSString stringWithFormat:@"预估麦穗 %.2f",item.mineCommision];
        
        [self.openButton setTitle:@"打开" forState:UIControlStateNormal];
    } else {
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.iconUrl] placeholderImage:PlaceHolderMainImage];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@",item.name]];
        text.yy_lineSpacing = AUTOSIZESCALEX(5);
        self.titleLabel.attributedText = text;
        
        [self.openButton setTitle:@"搜索相关" forState:UIControlStateNormal];
    }
}


- (void)setupUIByType:(NSInteger)type {
    
    self.type = type;
    
    UIView *maskView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.6);
//    [maskView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maskView];
    self.maskView = maskView;
    
    [maskView rac_signalForSelector:@selector(dismiss)];
    
    UIView *popupView = [[UIView alloc] init];
    popupView.backgroundColor = QHWhiteColor;
    popupView.layer.cornerRadius = AUTOSIZESCALEX(5);
    popupView.layer.masksToBounds = YES;
    [self addSubview:popupView];
    self.popupView = popupView;
    
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    //    iconImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"appIcon_small") imageViewSize:CGSizeMake(AUTOSIZESCALEX(150), AUTOSIZESCALEX(150))];
    [self.popupView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    // 还需要设置preferredMaxLayoutWidth最大的宽度值才可以生效多行效果
    //    titleLabel.preferredMaxLayoutWidth = SCREEN_WIDTH * 0.5 - AUTOSIZESCALEX(30); //设置最大的宽度
    titleLabel.font = TextFont(15);
    titleLabel.textColor = ColorWithHexString(@"555555");
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString: @"          周生生小巧玲珑真金女款佩带好看"];
    text.yy_lineSpacing = AUTOSIZESCALEX(5);
    titleLabel.attributedText = text;
    [self.popupView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    
    
    if (self.type == 0) {
        
        _mineCommisionBg = [[UIImageView alloc] init];
        _mineCommisionBg.image = ImageWithNamed(@"bg_sp");
        _mineCommisionBg.contentMode = UIViewContentModeScaleAspectFill;
        [self.popupView addSubview:_mineCommisionBg];
        
        
        UIImageView *mineCommisionView = [[UIImageView alloc]init];
        [mineCommisionView setImage: [UIImage imageNamed:@"bg_sp"]];
        mineCommisionView.alpha = 0.8;
        [self.popupView addSubview:mineCommisionView];
        self.mineCommisionView = mineCommisionView;
        
        
        UILabel *mineCommisionLabel = [[UILabel alloc] init];
        mineCommisionLabel.text = [NSString stringWithFormat:@"预估麦穗: %@", @"79.84"];
        mineCommisionLabel.font = TextFont(12);
        mineCommisionLabel.textColor = ColorWithHexString(@"#ffffff");
        //    mineCommisionLabel.backgroundColor = [ColorWithHexString(@"#ffb42b") colorWithAlphaComponent:0.8];
        mineCommisionLabel.textAlignment = NSTextAlignmentCenter;
        [self.popupView addSubview:mineCommisionLabel];
        self.mineCommisionLabel = mineCommisionLabel;
        
        
        
        UILabel *originalPriceLabel = [[UILabel alloc] init];
        //    // 加横线
        //    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString: @"¥ 59.00"];
        //    [attribtStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attribtStr.length)];
        //    originalPriceLabel.attributedText = attribtStr;
        originalPriceLabel.text = [NSString stringWithFormat:@"原价: 1099.0"];
        originalPriceLabel.font = TextFont(14);
        originalPriceLabel.textColor = ColorWithHexString(@"999999");
        [self.popupView addSubview:originalPriceLabel];
        self.originalPriceLabel = originalPriceLabel;
        
        
        UILabel *discountPriceLabel = [[UILabel alloc] init];
        discountPriceLabel.text = @"券后价 ¥ 49.00";
        discountPriceLabel.font = TextFont(14);
        discountPriceLabel.textColor = QHPriceColor;
        discountPriceLabel.textAlignment = NSTextAlignmentRight;
        [self.popupView addSubview:discountPriceLabel];
        self.discountPriceLabel = discountPriceLabel;
        
        UIButton *ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [ticketButton setTitle:@"10元券" forState:UIControlStateNormal];
        [ticketButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
        //    ticketButton.backgroundColor = QHMainColor;
        [ticketButton setBackgroundImage:ImageWithNamed(@"3元券bg") forState:UIControlStateNormal];
        ticketButton.titleLabel.font = TextFont(14);
        ticketButton.layer.cornerRadius = 3;
        ticketButton.layer.masksToBounds = YES;
        [self.popupView addSubview:ticketButton];
        self.ticketButton = ticketButton;
    }
    
    UIButton *openButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [openButton setTitle:@"打 开" forState:UIControlStateNormal];
    [openButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    openButton.backgroundColor = QHMainColor;
    [openButton addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    openButton.titleLabel.font = TextFont(15);
    openButton.layer.cornerRadius = 20;
    openButton.layer.masksToBounds = YES;
    [self.popupView addSubview:openButton];
    self.openButton = openButton;
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:ImageWithNamed(@"icon_back_circle") forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    self.closeButton = closeButton;
    
}


- (void)setupConstraints {
    
    
    [self.popupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(AUTOSIZESCALEX(40));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-40));
        make.centerY.equalTo(self).offset(AUTOSIZESCALEX(-20));
        make.height.mas_equalTo(AUTOSIZESCALEX(self.type==0 ? 420 : 400));
    }];
    
    
    [self.iconImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.popupView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.popupView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(230));
    }];
    
    [self.mineCommisionLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
    [self.mineCommisionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(0));
        make.right.mas_equalTo(self.mineCommisionLabel.mas_right).mas_offset(10);
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(-10));
    }];
    
    [self.closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.popupView);
        make.top.equalTo(self.popupView.mas_bottom).offset(AUTOSIZESCALEX(30));
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    if (self.type == 0) {
        
        [self.originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.titleLabel.mas_centerX).offset(AUTOSIZESCALEX(0));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(14));
        }];
        
        [self.discountPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.originalPriceLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
            make.left.equalTo(self.popupView);
            make.right.equalTo(self.popupView.mas_centerX).offset(AUTOSIZESCALEX(-5));
        }];
        
        [self.ticketButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.popupView.mas_centerX).offset(AUTOSIZESCALEX(5));
            make.centerY.equalTo(self.discountPriceLabel);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(20);
        }];
        
        [self.openButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.popupView).offset(AUTOSIZESCALEX(10));
            make.right.equalTo(self.popupView).offset(AUTOSIZESCALEX(-10));
            make.height.mas_equalTo(40);
            make.top.equalTo(self.ticketButton.mas_bottom).offset(AUTOSIZESCALEY(10));
        }];
    } else {
        
        
        [self.openButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.popupView).offset(AUTOSIZESCALEX(10));
            make.right.equalTo(self.popupView).offset(AUTOSIZESCALEX(-10));
            make.height.mas_equalTo(40);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEY(50));
        }];
    }
    
    
    
}

#pragma mark - Event
- (void)next {
    
    if (self.type == 0) {
        
        UIViewController *rootVC = self.window.rootViewController;
        if ([rootVC isKindOfClass:[WYTabBarController class]]) {
            
            [self dismiss];
            
            [(WYTabBarController *)rootVC setSelectedIndex:0];
            WYNavigationController *homeNavC = [(WYTabBarController *)rootVC viewControllers].firstObject;
            [homeNavC popToRootViewControllerAnimated:NO];
            
            NewSearchGoodsDetailController *detailVC = [[NewSearchGoodsDetailController alloc] init];
            detailVC.itemId = self.item.itemId;
            
            [homeNavC pushViewController:detailVC animated:YES];
        }
        
    } else {
        
        UIViewController *rootVC = self.window.rootViewController;
        if ([rootVC isKindOfClass:[WYTabBarController class]]) {
            
            [self dismiss];
            
            [(WYTabBarController *)rootVC setSelectedIndex:0];
            WYNavigationController *homeNavC = [(WYTabBarController *)rootVC viewControllers].firstObject;
            [homeNavC popToRootViewControllerAnimated:NO];
            
            GlobalSearchController *searchVC = [[GlobalSearchController alloc] init];
            searchVC.keyword = self.item.keyword;
            searchVC.title = self.item.keyword;
            
            [homeNavC pushViewController:searchVC animated:YES];
        }
    }
}



@end
