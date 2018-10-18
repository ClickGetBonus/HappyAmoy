//
//  MineHeaderView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineHeaderView.h"
#import "VersionItem.h"
#import <YYText/YYText.h>

@interface MineHeaderView()

/**    背景图片    */
@property (strong, nonatomic) UIImageView *bgImageView;
/**    头像    */
@property (strong, nonatomic) UIImageView *iconImageView;
/**    名称    */
@property (strong, nonatomic) UILabel *nameLabel;
/**    注册会员    */
@property(nonatomic,strong) UIButton *registerButton;
/**    邀请码    */
@property (strong, nonatomic) UILabel *invitedCodeLabel;
/**    复制按钮    */
@property(nonatomic,strong) UIButton *myCopyButton;
//订单
@property (strong, nonatomic) UIView *balanceView;
@property(nonatomic, strong) NSArray *balanceInfoArray;
@property(nonatomic, strong) NSMutableArray *balabnceViews;

@property(nonatomic, strong) UIView *orderView;
@property(nonatomic, strong) NSArray *orderInfos;


@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _balabnceViews = [[NSMutableArray alloc]init];
        self.balanceInfoArray = @[@{@"title":@"分享麦穗",@"icon":@"奖励"},@{@"title":@"消费麦穗",@"icon":@"积分2"},@{@"title":@"麦粒",@"icon":@"会员福利"},@{@"title":@"我的钱包",@"icon":@"钱包"}];
        self.orderInfos = @[@{@"title":@"待付款",@"icon":@"icon_dfk"},@{@"title":@"待发货",@"icon":@"icon_shipments"},@{@"title":@"待收货",@"icon":@"icon_dsh"},@{@"title":@"待评价",@"icon":@"icon_evaluate "},@{@"title":@"售后",@"icon":@"icon_after sale"}];
        
        [self setupUI];
//        WeakSelf
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//        [[tap rac_gestureSignal] subscribeNext:^(id x) {
//            if ([weakSelf.delegate respondsToSelector:@selector(mineHeaderView:editPersonalInfo:)]) {
//                [weakSelf.delegate mineHeaderView:weakSelf editPersonalInfo:@""];
//            }
//        }];
//
//        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    WeakSelf
    self.backgroundColor = QHWhiteColor;
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"personal_bg")];
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    UIImageView *iconImageView = [[UIImageView alloc] init];;
    [iconImageView wy_setCircleImageWithUrlString:[LoginUserDefault userDefault].userItem.headpicUrl placeholderImage:ImageWithNamed(@"headImage_white") scaleAspectFit:YES];
    iconImageView.clipsToBounds = YES;

    [self addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [self setGestureRecognizersWithTag:header andView:self.iconImageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
//    nameLabel.text = @"183*****1103";
    nameLabel.text = @"登录/注册";
    nameLabel.text = [LoginUserDefault userDefault].userItem.nickname;
    nameLabel.font = TextFont(14);
    nameLabel.textColor = QHWhiteColor;
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
//    RAC(self.nameLabel,text) = RACObserve([LoginUserDefault userDefault].userItem, nickname);

    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitleColor:ColorWithHexString(@"#eabc88") forState:UIControlStateNormal];
    registerButton.titleLabel.font = TextFont(10);
    [registerButton setTitle:@"注册会员" forState:UIControlStateNormal];
    [registerButton setBackgroundColor:ColorWithHexString(@"#430709")];
    registerButton.layer.cornerRadius = AUTOSIZESCALEX(9);
    registerButton.layer.masksToBounds = YES;
    [[registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

    }];
    [self addSubview:registerButton];
    self.registerButton = registerButton;
    
    UILabel *invitedCodeLabel = [[UILabel alloc] init];
    invitedCodeLabel.text = [NSString stringWithFormat:@"邀请码：%@",[LoginUserDefault userDefault].userItem.recommendCode];
    invitedCodeLabel.font = TextFont(11);
    invitedCodeLabel.textColor = ColorWithHexString(@"#ffffff");
    [self addSubview:invitedCodeLabel];
    self.invitedCodeLabel = invitedCodeLabel;

    UIButton *myCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myCopyButton setTitleColor:QHWhiteColor forState:UIControlStateNormal];
    myCopyButton.titleLabel.font = TextFont(10);
    [myCopyButton setTitle:@"复制" forState:UIControlStateNormal];
    [myCopyButton setBackgroundColor:[UIColor clearColor]];
    myCopyButton.layer.cornerRadius = AUTOSIZESCALEX(4);
    myCopyButton.layer.masksToBounds = YES;
    myCopyButton.layer.borderColor = QHWhiteColor.CGColor;
    myCopyButton.layer.borderWidth = AUTOSIZESCALEX(1);
    [[myCopyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (![LoginUserDefault userDefault].isTouristsMode) {
            UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [LoginUserDefault userDefault].userItem.recommendCode;
            [WYHud showMessage:@"已复制到剪贴板!"];
            WYLog(@"复制的内容 = %@",[LoginUserDefault userDefault].userItem.recommendCode);
        }
    }];
    [self addSubview:myCopyButton];
    self.myCopyButton = myCopyButton;
    
    _balanceView = [[UIView alloc] initWithFrame:CGRectMake(AUTOSIZESCALEX(15), AUTOSIZESCALEY(125), self.width-AUTOSIZESCALEX(15)*2.0, AUTOSIZESCALEY(40))];
    CGFloat width = _balanceView.width/self.balanceInfoArray.count;
    _balanceView.backgroundColor = QHClearColor;
    _balanceArray = [NSMutableArray array];
    for (NSInteger i = 0; i < self.balanceInfoArray.count; i++) {
        UILabel* titleLb = [[UILabel alloc] init];
        titleLb.frame = CGRectMake(i*width, AUTOSIZESCALEY(25), width, AUTOSIZESCALEY(13));
        titleLb.textColor = QHWhiteColor;
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.font = [UIFont systemFontOfSize:11];
        titleLb.text = [self.balanceInfoArray[i] objectForKey:@"title"];
        [self setGestureRecognizersWithTag:i andView:titleLb];
        [_balanceView addSubview:titleLb];
        
        if (i == self.balanceInfoArray.count - 1) {
            UIImageView* icon = [[UIImageView alloc] initWithFrame:CGRectMake(i*width+(width - AUTOSIZESCALEY(20))/2.0, 0, AUTOSIZESCALEY(20), AUTOSIZESCALEY(20))];
            icon.image = [ImageWithNamed(@"icon_wallet") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            icon.contentMode = UIViewContentModeCenter;
            [_balanceView addSubview:icon];
            [self setGestureRecognizersWithTag:i andView:icon];

        }else{
            UILabel* infoLb = [[UILabel alloc] init];
            infoLb.frame = CGRectMake(i*width, 0, width, AUTOSIZESCALEY(16));
            infoLb.textColor = QHWhiteColor;
            infoLb.font = [UIFont systemFontOfSize:14];
            infoLb.text = @"0.00";
            infoLb.textAlignment = NSTextAlignmentCenter;
            [_balanceView addSubview:infoLb];
            [_balabnceViews addObject:infoLb];
            [self setGestureRecognizersWithTag:i andView:infoLb];

        }
    }
    [self addSubview:_balanceView];
    
    _orderView = [[UIView alloc] initWithFrame:CGRectMake(AUTOSIZESCALEX(19), AUTOSIZESCALEY(195), self.width - AUTOSIZESCALEX(19)*2.0, AUTOSIZESCALEY(120))];
    _orderView.backgroundColor = QHWhiteColor;;
    _orderView.layer.shadowColor = [UIColor grayColor].CGColor;
    _orderView.layer.shadowOpacity = 0.8f;
    _orderView.layer.shadowRadius = 4.0;
    _orderView.layer.cornerRadius = 4.0;
    _orderView.layer.shadowOffset = CGSizeMake(0, 3);
    [self addSubview:_orderView];
    
    UILabel* titleLb = [[UILabel alloc] initWithFrame:CGRectMake(AUTOSIZESCALEX(15), AUTOSIZESCALEY(14), 120, AUTOSIZESCALEY(16))];
    titleLb.text = @"我的订单";
    titleLb.textColor = [UIColor colorWithHexString:@"333333"];
    titleLb.font = [UIFont systemFontOfSize:15];
    [_orderView addSubview:titleLb];
    
    YYLabel* moreBtn = [YYLabel new];
    moreBtn.frame = CGRectMake(titleLb.right_WY, titleLb.top_WY, _orderView.width - titleLb.right_WY - AUTOSIZESCALEX(19), titleLb.height);
    NSMutableAttributedString* moreTextAtt = [[NSMutableAttributedString alloc] initWithString:@"查看更多订单 " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"666666"]}];
    UIImage* arrowImg = ImageWithNamed(@"icon_pop");
    NSMutableAttributedString* arrowTxt = [NSMutableAttributedString yy_attachmentStringWithContent:arrowImg contentMode:UIViewContentModeCenter attachmentSize:arrowImg.size alignToFont:[UIFont systemFontOfSize:11.0] alignment:YYTextVerticalAlignmentCenter];
    [moreTextAtt appendAttributedString:arrowTxt];
    moreTextAtt.yy_alignment = NSTextAlignmentRight;
    moreBtn.attributedText = moreTextAtt;
    moreBtn.textAlignment = NSTextAlignmentRight;
    [self setGestureRecognizersWithTag:moreOrder andView:moreBtn];
    [_orderView addSubview:moreBtn];
    
    CGFloat orderWidth = _orderView.width/self.orderInfos.count;;
    for (NSInteger i = 0; i < self.orderInfos.count; i++) {
        UILabel* subTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(i*orderWidth, AUTOSIZESCALEY(82), orderWidth, AUTOSIZESCALEY(14))];
        subTitleLb.font = [UIFont systemFontOfSize:12];
        subTitleLb.textColor = [UIColor colorWithHexString:@"#333333"];
        subTitleLb.textAlignment = NSTextAlignmentCenter;
        NSInteger tag = i + _balanceInfoArray.count;
        [self setGestureRecognizersWithTag:tag andView:subTitleLb];

        [_orderView addSubview:subTitleLb];
        
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(subTitleLb.centerX-AUTOSIZESCALEY(20)/2.0, AUTOSIZESCALEY(54), AUTOSIZESCALEY(20), AUTOSIZESCALEY(20))];
        [_orderView addSubview:imgView];
        
        subTitleLb.text = [self.orderInfos[i] objectForKey:@"title"];
        imgView.image = ImageWithNamed([self.orderInfos[i] objectForKey:@"icon"]);
        [self setGestureRecognizersWithTag:tag andView:imgView];

        
    }
    
    [RACObserve([LoginUserDefault userDefault], dataHaveChanged) subscribeNext:^(id x) {
        weakSelf.nameLabel.text = [NSString isEmpty:[LoginUserDefault userDefault].userItem.nickname] ? @"登录/注册" : [LoginUserDefault userDefault].userItem.nickname;
        [weakSelf.iconImageView wy_setCircleImageWithUrlString:[LoginUserDefault userDefault].userItem.headpicUrl placeholderImage:ImageWithNamed(@"headImage_white") scaleAspectFit:YES];
        if ([LoginUserDefault userDefault].isTouristsMode) {
//            weakSelf.levelButton.hidden = YES;
            weakSelf.invitedCodeLabel.hidden = YES;
            weakSelf.myCopyButton.hidden = YES;
            weakSelf.registerButton.hidden = YES;
            [weakSelf.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(weakSelf.iconImageView);
                make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOSIZESCALEX(15));
            }];
        } else {
            weakSelf.invitedCodeLabel.hidden = NO;
            weakSelf.myCopyButton.hidden = NO;
            if ([[LoginUserDefault userDefault].versionItem.version isEqualToString:APP_VERSION]) { // 版本一样，说明当前的是最新版本，需要判断当前版本的数字编号
                if ([LoginUserDefault userDefault].versionItem.number == 0) { // 数字编号等于0表示审核中，不可以显示会员等级
                    weakSelf.registerButton.hidden = YES;
                } else {
//                    weakSelf.registerButton.hidden = NO;
                    weakSelf.registerButton.hidden = YES;

                }
            }
            [weakSelf.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.iconImageView).offset(AUTOSIZESCALEX(2.5));
                make.left.equalTo(weakSelf.iconImageView.mas_right).offset(AUTOSIZESCALEX(15));
            }];
//            weakSelf.levelButton.hidden = NO;
        }
        
        weakSelf.registerButton.hidden = NO;
        if ([LoginUserDefault userDefault].userItem.viped == 0) {
            [weakSelf.registerButton setTitle:@"普通会员" forState:UIControlStateNormal];
        } else if ([LoginUserDefault userDefault].userItem.viped == 1){
            [weakSelf.registerButton setTitle:@"VIP会员" forState:UIControlStateNormal];
        }else if ([LoginUserDefault userDefault].userItem.viped == 11){
            [weakSelf.registerButton setTitle:@"荣誉总裁" forState:UIControlStateNormal];
        }else if ([LoginUserDefault userDefault].userItem.viped == 12){
            [weakSelf.registerButton setTitle:@"联席总裁" forState:UIControlStateNormal];
        }else if ([LoginUserDefault userDefault].userItem.viped == 13){
            [weakSelf.registerButton setTitle:@"战略合伙人" forState:UIControlStateNormal];
        }
        
//        if ([LoginUserDefault userDefault].userItem.viped == 0) {
//            [weakSelf.levelButton setBackgroundImage:ImageWithNamed(@"普通会员") forState:UIControlStateNormal];
//        } else if ([LoginUserDefault userDefault].userItem.viped == 1) {
//            [weakSelf.levelButton setBackgroundImage:ImageWithNamed(@"vip会员") forState:UIControlStateNormal];
//        }
    }];
    
    [RACObserve([LoginUserDefault userDefault], dataHaveChanged) subscribeNext:^(id x) {
        WYLog(@"邀请码");
        if (![LoginUserDefault userDefault].isTouristsMode) {
            weakSelf.invitedCodeLabel.text = [NSString stringWithFormat:@"邀请码：%@",[NSString excludeEmptyQuestion:[LoginUserDefault userDefault].userItem.recommendCode]];
        }
    }];


    [self addConstraints];
}

-(void)setBalanceArray:(NSMutableArray *)balanceArray{
    for (NSInteger i = 0; i < balanceArray.count; i++) {
        UILabel* lb = _balabnceViews[i];
        lb.text = balanceArray[i];
    }
    
}


#pragma mark - Layout

- (void)addConstraints {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(UI_IS_IPHONEX ? AUTOSIZESCALEY(225)+24 : AUTOSIZESCALEY(225));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kNavHeight);
        make.left.equalTo(self).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(50));
        make.height.mas_equalTo(AUTOSIZESCALEX(50));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(5));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(15));
    }];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.nameLabel.mas_right).offset(AUTOSIZESCALEX(10));
        make.width.mas_equalTo(AUTOSIZESCALEX(60));
        make.height.mas_equalTo(AUTOSIZESCALEX(18));
    }];

    [self.invitedCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView).offset(AUTOSIZESCALEX(-5));
        make.left.equalTo(self.nameLabel).offset(AUTOSIZESCALEX(0));
    }];

    [self.myCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.invitedCodeLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.invitedCodeLabel.mas_right).offset(AUTOSIZESCALEX(25));
        make.width.mas_equalTo(AUTOSIZESCALEX(40));
        make.height.mas_equalTo(AUTOSIZESCALEX(18));
    }];

    [self.balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AUTOSIZESCALEX(15));
        make.right.mas_equalTo(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEY(40));
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(AUTOSIZESCALEY(20));
    }];
    
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(AUTOSIZESCALEX(19));
        make.right.mas_equalTo(-AUTOSIZESCALEX(19));
        make.top.mas_equalTo(AUTOSIZESCALEY(195));
        make.height.mas_equalTo(AUTOSIZESCALEY(120));
    }];

}


#pragma mark -
- (void)setGestureRecognizersWithTag:(NSInteger )tag andView:(UIView *)view
{
    view.userInteractionEnabled = YES;
    view.tag = tag;
    WeakSelf
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)x;
        UIView *view = tap.view;
        NSInteger viewTag = view.tag;
        if ([weakSelf.delegate respondsToSelector:@selector(mineHeaderView:editPersonalInfo:)]) {
            NSString *info = [NSString stringWithFormat:@"%ld",(long)viewTag];
            [weakSelf.delegate mineHeaderView:weakSelf editPersonalInfo:info];
        }
    }];
    [view addGestureRecognizer:tap];
}
@end
