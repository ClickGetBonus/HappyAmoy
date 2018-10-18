//
//  UpgradeVIPCell.m
//  HappyAmoy
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UpgradeVIPCell.h"
#import "PayWayView.h"

@interface UpgradeVIPCell() <UICollectionViewDelegate,UICollectionViewDataSource,PayWayViewDelegate>

/**    背景图片    */
@property (strong, nonatomic) UIImageView *backgroundImageView;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    升级按钮    */
@property (strong, nonatomic) UIButton *upgradeButton;
/**    福利一    */
@property (strong, nonatomic) UIView *firstWelfareView;
/**    福利二    */
@property (strong, nonatomic) UIView *secondWelfareView;
/**    福利三    */
@property (strong, nonatomic) UIView *thirdWelfareView;

@end

@implementation UpgradeVIPCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"bg")];
    [self.contentView addSubview:backgroundImageView];
    self.backgroundImageView = backgroundImageView;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSURL *url = [NSURL URLWithString:@"http://haomaieco.lucius.cn/upload/vip.png"];
        //从网络下载图片
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            backgroundImageView.image = image;
        });
    });
    
    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.numberOfLines = 2;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = AppMainTextFont(20);
//    titleLabel.textColor = QHWhiteColor;
//    //    titleLabel.text = @"不是会员的你\n错过了很多赚钱的机会";
//
//    NSMutableAttributedString *attribute11 = [[NSMutableAttributedString alloc] initWithString:@"不是会员的你\n错过了很多赚钱的机会"];
//    // 设置字间距
//    attribute11.yy_kern = @3;
//    titleLabel.attributedText = attribute11;
//
//    [self.contentView addSubview:titleLabel];
//    self.titleLabel = titleLabel;
//
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(44));
//        make.centerX.equalTo(self.contentView);
//    }];
//
//    UIView *firstWelfareView = [[UIView alloc] init];
//    firstWelfareView.backgroundColor = QHWhiteColor;
//    firstWelfareView.layer.cornerRadius = 5;
//    firstWelfareView.layer.masksToBounds = YES;
//    [self.contentView addSubview:firstWelfareView];
//    self.firstWelfareView = firstWelfareView;
//
//    UILabel *typeLabel1 = [[UILabel alloc] init];
//    typeLabel1.text = @"会员福利";
//    typeLabel1.font = TextFont(15);
//    typeLabel1.textColor = ColorWithHexString(@"E79223");
//    [self.firstWelfareView addSubview:typeLabel1];
//
//    UIImageView *icon1 = [[UIImageView alloc] initWithImage:ImageWithNamed(@"1")];
//    [self.firstWelfareView addSubview:icon1];
//
//    UILabel *welfareLabel1 = [[UILabel alloc] init];
//    welfareLabel1.numberOfLines = 0;
//    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"成为VIP会员年费仅需99元，VIP会员享受购物优惠，积分返还，省钱的同时又能赚钱，等于免费购物。"];
//    attribute.yy_kern = @1.5;
//    attribute.yy_lineSpacing = 2;
//    welfareLabel1.attributedText = attribute;
//    welfareLabel1.font = TextFont(13);
//    welfareLabel1.textColor = ColorWithHexString(@"232322");
//    [self.firstWelfareView addSubview:welfareLabel1];
//
//    [self.firstWelfareView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(150));
//        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
//        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
//    }];
//
//    [typeLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.firstWelfareView).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(self.firstWelfareView).offset(AUTOSIZESCALEX(10));
//    }];
//
//    [icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(typeLabel1).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(typeLabel1.mas_right).offset(AUTOSIZESCALEX(8));
//    }];
//
//    [welfareLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(typeLabel1.mas_bottom).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(typeLabel1).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.firstWelfareView).offset(AUTOSIZESCALEX(-10));
//        make.bottom.equalTo(self.firstWelfareView).offset(AUTOSIZESCALEX(-10));
//    }];
//
//
//    UIView *secondWelfareView = [[UIView alloc] init];
//    secondWelfareView.backgroundColor = QHWhiteColor;
//    secondWelfareView.layer.cornerRadius = 5;
//    secondWelfareView.layer.masksToBounds = YES;
//    [self.contentView addSubview:secondWelfareView];
//    self.secondWelfareView = secondWelfareView;
//
//    UILabel *typeLabel2 = [[UILabel alloc] init];
//    typeLabel2.text = @"消费麦穗";
//    typeLabel2.font = TextFont(15);
//    typeLabel2.textColor = ColorWithHexString(@"E79223");
//    [self.secondWelfareView addSubview:typeLabel2];
//
//    UIImageView *icon2 = [[UIImageView alloc] initWithImage:ImageWithNamed(@"2")];
//    [self.secondWelfareView addSubview:icon2];
//
//    UILabel *welfareLabel2 = [[UILabel alloc] init];
//    welfareLabel2.numberOfLines = 0;
//    NSMutableAttributedString *attribute2 = [[NSMutableAttributedString alloc] initWithString:@"成为VIP会员，直属推广和间属推广好友成为VIP会员的，将分别获得公司奖励35和25的会员值。间属好友推广好友成为VIP会员的，将会获得平台的团队奖奖励。"];
//    attribute2.yy_kern = @1.5;
//    attribute2.yy_lineSpacing = 2;
//    welfareLabel2.attributedText = attribute2;
//    welfareLabel2.font = TextFont(13);
//    welfareLabel2.textColor = ColorWithHexString(@"232322");
//    [self.secondWelfareView addSubview:welfareLabel2];
//
//    UILabel *welfareLabel22 = [[UILabel alloc] init];
//    welfareLabel22.numberOfLines = 0;
//    NSMutableAttributedString *attribute22 = [[NSMutableAttributedString alloc] initWithString:@"直属邀请好友成为VIP会员达到相应人次，将会获得平台成就奖："];
//    attribute22.yy_kern = @1.5;
//    attribute22.yy_lineSpacing = 2;
//    welfareLabel22.attributedText = attribute22;
//    welfareLabel22.font = TextFont(13);
//    welfareLabel22.textColor = ColorWithHexString(@"232322");
//    [self.secondWelfareView addSubview:welfareLabel22];
//
//    UILabel *welfareLabel23 = [[UILabel alloc] init];
//    welfareLabel23.numberOfLines = 0;
////    NSMutableAttributedString *attribute23 = [[NSMutableAttributedString alloc] initWithString:@"VIP会员青铜奖  188会员值      (直推10人次)\nVIP会员白银奖  318会员值      (直推25人次)\nVIP会员黄金奖  588会员值      (直推60人次)\nVIP会员钻石奖  1288会员值    (直推150人次)"];
//    NSMutableAttributedString *attribute23 = [[NSMutableAttributedString alloc] initWithString:@"VIP会员青铜奖  188会员值\nVIP会员白银奖  318会员值\nVIP会员黄金奖  588会员值\nVIP会员钻石奖  1288会员值"];
//
//    attribute23.yy_kern = @1.5;
//    attribute23.yy_lineSpacing = 5;
//    welfareLabel23.attributedText = attribute23;
//    welfareLabel23.font = TextFont(13);
//    welfareLabel23.textColor = ColorWithHexString(@"232322");
//    [self.secondWelfareView addSubview:welfareLabel23];
//
//    UILabel *welfareLabel24 = [[UILabel alloc] init];
//    welfareLabel24.numberOfLines = 0;
//    NSMutableAttributedString *attribute24 = [[NSMutableAttributedString alloc] initWithString:@"(直推10人次)\n(直推25人次)\n(直推60人次)\n(直推150人次)"];
//    attribute24.yy_kern = @1.5;
//    attribute24.yy_lineSpacing = 5;
//    welfareLabel24.attributedText = attribute24;
//    welfareLabel24.font = TextFont(13);
//    welfareLabel24.textColor = ColorWithHexString(@"232322");
//    [self.secondWelfareView addSubview:welfareLabel24];
//
//
//    [self.secondWelfareView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.firstWelfareView.mas_bottom).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(self.firstWelfareView).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.firstWelfareView).offset(AUTOSIZESCALEX(0));
//    }];
//
//    [typeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.secondWelfareView).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(self.secondWelfareView).offset(AUTOSIZESCALEX(10));
//    }];
//
//    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(typeLabel2).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(typeLabel2.mas_right).offset(AUTOSIZESCALEX(8));
//    }];
//
//    [welfareLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(typeLabel2.mas_bottom).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(typeLabel2).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.secondWelfareView).offset(AUTOSIZESCALEX(-10));
//    }];
//
//    [welfareLabel22 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(welfareLabel2.mas_bottom).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(welfareLabel2).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(welfareLabel2).offset(AUTOSIZESCALEX(0));
//    }];
//
//    [welfareLabel23 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(welfareLabel22.mas_bottom).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(welfareLabel2).offset(AUTOSIZESCALEX(0));
//        make.bottom.equalTo(self.secondWelfareView).offset(AUTOSIZESCALEX(-10));
//    }];
//
//    [welfareLabel24 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(welfareLabel23).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(welfareLabel23.mas_right).offset(AUTOSIZESCALEX(20));
//        make.right.equalTo(self.secondWelfareView).offset(AUTOSIZESCALEX(-10));
//    }];
//
//    UIView *thirdWelfareView = [[UIView alloc] init];
//    thirdWelfareView.backgroundColor = QHWhiteColor;
//    thirdWelfareView.layer.cornerRadius = 5;
//    thirdWelfareView.layer.masksToBounds = YES;
//    [self.contentView addSubview:thirdWelfareView];
//    self.thirdWelfareView = thirdWelfareView;
//
//    UILabel *typeLabel3 = [[UILabel alloc] init];
//    typeLabel3.text = @"x f麦穗";
//    typeLabel3.font = TextFont(15);
//    typeLabel3.textColor = ColorWithHexString(@"E79223");
//    [self.thirdWelfareView addSubview:typeLabel3];
//
//    UIImageView *icon3 = [[UIImageView alloc] initWithImage:ImageWithNamed(@"3")];
//    [self.thirdWelfareView addSubview:icon3];
//
//    UILabel *welfareLabel3 = [[UILabel alloc] init];
//    welfareLabel3.numberOfLines = 0;
//    NSMutableAttributedString *attribute3 = [[NSMutableAttributedString alloc] initWithString:@"成为VIP会员，直属好友和间属好友在平台领取优惠券，到淘宝天猫成功交易活动商品享受优惠折扣的同时，会员得到公司的额外奖励，额外奖励约为消费金额的3.5%.\n钱包余额不论金额大小均可提现 ，秒到账。"];
//    attribute3.yy_kern = @1.5;
//    attribute3.yy_lineSpacing = 2;
//    welfareLabel3.attributedText = attribute3;
//    //    welfareLabel3.text = @"成为VIP会员，直属好友在平台上进行购物消费可获得好友消费金额3.5%的奖励，间属好友在平台进行购物消费，可获得其好友消费金额2.5%的奖励。\n钱包金额不论大小均可提现，秒到账。";
//    welfareLabel3.font = TextFont(13);
//    welfareLabel3.textColor = ColorWithHexString(@"232322");
//    [self.thirdWelfareView addSubview:welfareLabel3];
//
//    [self.thirdWelfareView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.secondWelfareView.mas_bottom).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(self.firstWelfareView).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.firstWelfareView).offset(AUTOSIZESCALEX(0));
//    }];
//
//    [typeLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.thirdWelfareView).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(self.thirdWelfareView).offset(AUTOSIZESCALEX(10));
//    }];
//
//    [icon3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(typeLabel3).offset(AUTOSIZESCALEX(0));
//        make.left.equalTo(typeLabel3.mas_right).offset(AUTOSIZESCALEX(8));
//    }];
//
//    [welfareLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(typeLabel3.mas_bottom).offset(AUTOSIZESCALEX(10));
//        make.left.equalTo(typeLabel3).offset(AUTOSIZESCALEX(0));
//        make.right.equalTo(self.thirdWelfareView).offset(AUTOSIZESCALEX(-10));
//        make.bottom.equalTo(self.thirdWelfareView).offset(AUTOSIZESCALEX(-10));
//    }];
//
    WeakSelf

    UIButton *upgradeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    upgradeButton.layer.cornerRadius = 3;
    upgradeButton.layer.masksToBounds = YES;
    if ([LoginUserDefault userDefault].userItem.viped == 0) { // 普通会员
        [upgradeButton setTitle:@"升级VIP会员" forState:UIControlStateNormal];
    } else {
        [upgradeButton setTitle:@"您已是尊贵VIP" forState:UIControlStateNormal];
    }
    [RACObserve([LoginUserDefault userDefault], dataHaveChanged) subscribeNext:^(id x) {
        if ([LoginUserDefault userDefault].userItem.viped == 0) {
            [weakSelf.upgradeButton setTitle:@"升级VIP会员" forState:UIControlStateNormal];
        } else if ([LoginUserDefault userDefault].userItem.viped == 1) {
            [weakSelf.upgradeButton setTitle:@"您已是尊贵VIP" forState:UIControlStateNormal];
        }
    }];

    [upgradeButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    upgradeButton.titleLabel.font = TextFont(15);
    [upgradeButton gradientButtonWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(30), AUTOSIZESCALEX(40)) colorArray:@[(id)ColorWithHexString(@"#FFCC00"),(id)ColorWithHexString(@"#DEA200")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    
    [[upgradeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        if ([LoginUserDefault userDefault].userItem.viped == 0) { // 普通会员
            PayWayView *payView = [[PayWayView alloc] initWithFrame:SCREEN_FRAME];
            payView.delegate = weakSelf;
            [payView show];
        } else {
            if ([weakSelf.delegate respondsToSelector:@selector(upgradeVIPCell:didClickBack:)]) {
                [weakSelf.delegate upgradeVIPCell:weakSelf didClickBack:sender];
            }
        }
    }];
    [self.contentView addSubview:upgradeButton];
    self.upgradeButton = upgradeButton;
    
    if (UI_IS_IPHONEX) {
        [self.upgradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-30));
            make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
            make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
            make.height.mas_equalTo(AUTOSIZESCALEX(40));
        }];
    } else {
        [self.upgradeButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(welfareLabel3.mas_bottom).offset(AUTOSIZESCALEX(35));
                    make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
            make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
            make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
            make.height.mas_equalTo(AUTOSIZESCALEX(40));
        }];
    }
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
//        make.height.mas_equalTo(AUTOSIZESCALEX(740));
    }];

}

#pragma mark - PayWayViewDelegate

- (void)payWayView:(PayWayView *)payWayView didSelectedPayWay:(NSInteger)payWay {
    
    if ([self.delegate respondsToSelector:@selector(upgradeVIPCell:didSelectedPayWay:)]) {
        [self.delegate upgradeVIPCell:self didSelectedPayWay:payWay];
    }

}

@end
