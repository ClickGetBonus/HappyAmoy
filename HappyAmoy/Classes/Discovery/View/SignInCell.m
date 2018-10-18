//
//  SignInCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SignInCell.h"
#import "SignInCalanderCell.h"
#import "SignInOverviewItem.h"
#import "SignInListItem.h"

@interface SignInCell () <UICollectionViewDelegate,UICollectionViewDataSource>

/**    签到按钮    */
@property(nonatomic,strong) UIButton *signInButton;
/**    我的金豆按钮    */
@property(nonatomic,strong) UIButton *myGoldButton;
/**    我的金豆    */
@property(nonatomic,strong) UILabel *myGoldLabel;
/**    已连续签到天数按钮    */
@property(nonatomic,strong) UIButton *daysButton;
/**    已连续签到天数    */
@property(nonatomic,strong) UILabel *daysLabel;
/**    签到规则按钮    */
@property(nonatomic,strong) UIButton *rulesButton;
/**    签到规则    */
@property(nonatomic,strong) UILabel *rulesLabel;
/**    左线条    */
@property(nonatomic,strong) UIView *leftLine;
/**    右线条    */
@property(nonatomic,strong) UIView *rightLine;
/**    日历容器    */
@property(nonatomic,strong) UIView *calanderContainerView;
/**    月份    */
@property(nonatomic,strong) UILabel *monthLabel;
/**    周末容器    */
@property(nonatomic,strong) UIView *weekContainerView;
/**    日历表    */
@property(nonatomic,strong) UICollectionView *collectionView;
/**    数据源    */
@property(nonatomic,strong) NSMutableArray *datasource;

@end

static NSString *calanderCellId = @"calanderCellId";

@implementation SignInCell

#pragma mark - Lazy load

- (NSMutableArray *)datasource {
    if (!_datasource) {
        _datasource = [NSMutableArray array];
        
        NSInteger firstDay = [NSString getWeekdayFromDateString:[NSString stringWithFormat:@"%@-01",[NSString getCurrentTimeWithDateFormat:@"yyyy-MM"]]];
        for (int i = 0; i < (firstDay - 1); i++) {
            [_datasource addObject:@""];
        }
        
        for (int i = 1; i < ([NSDate date].daysInMonth + 1); i++) {
            [_datasource addObject:[NSString stringWithFormat:@"%02d",i]];
        }
    }
    return _datasource;
}

- (NSInteger)weekdayStringFromDateString:(NSString *)dateString {
    
    NSDate *inputDate = [NSString dateWithTimeString:dateString];
    
//    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/SuZhou"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return theComponents.weekday;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorWithHexString(@"#F3F3F6");
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    WeakSelf
    
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInButton setBackgroundImage:ImageWithNamed(@"赚金豆") forState:UIControlStateNormal];
    [[signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([weakSelf.delegate respondsToSelector:@selector(signInCell:didClickSignInButton:)]) {
            [weakSelf.delegate signInCell:weakSelf didClickSignInButton:x];
        }
    }];
    [self.contentView addSubview:signInButton];
    self.signInButton = signInButton;
    
    // 日历
    UIView *calanderContainerView = [[UIView alloc] init];
    calanderContainerView.backgroundColor = QHWhiteColor;
    calanderContainerView.layer.cornerRadius = AUTOSIZESCALEX(5);
    calanderContainerView.layer.masksToBounds = YES;
    [self.contentView addSubview:calanderContainerView];
    self.calanderContainerView = calanderContainerView;

    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.backgroundColor = ColorWithHexString(@"#ffb42b");
    monthLabel.text = [NSString stringWithFormat:@"%zd月",[NSDate date].month];
    monthLabel.textColor = ColorWithHexString(@"#ffffff");
    monthLabel.font = TextFont(14);
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [self.calanderContainerView addSubview:monthLabel];
    self.monthLabel = monthLabel;

    UIView *weekContainerView = [[UIView alloc] init];
    weekContainerView.backgroundColor = QHWhiteColor;
    [self.calanderContainerView addSubview:weekContainerView];
    self.weekContainerView = weekContainerView;
    
    NSArray *weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat buttonW = (SCREEN_WIDTH - AUTOSIZESCALEX(15) * 2) / 7;
    CGFloat buttonH = AUTOSIZESCALEX(40);
    
    for (int i = 0; i < weekArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonW * i, 0, buttonW, buttonH);
        [button setTitle:weekArray[i] forState:UIControlStateNormal];
        [button setTitleColor:ColorWithHexString(@"#333333") forState:UIControlStateNormal];
        button.titleLabel.font = TextFont(12);
        [weekContainerView addSubview:button];
    }

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(buttonW - AUTOSIZESCALEX(1), AUTOSIZESCALEX(35));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = AUTOSIZESCALEX(1);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(1);

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:SCREEN_FRAME collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(0), 0, AUTOSIZESCALEX(0));
    [collectionView registerClass:[SignInCalanderCell class] forCellWithReuseIdentifier:calanderCellId];
    [self.calanderContainerView addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIButton *myGoldButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myGoldButton.layer.cornerRadius = AUTOSIZESCALEX(5);
    myGoldButton.layer.masksToBounds = YES;
    [myGoldButton setTitle:@"我的麦粒" forState:UIControlStateNormal];
    [myGoldButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    myGoldButton.titleLabel.font = TextFont(14);
    [myGoldButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(30)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [self.contentView addSubview:myGoldButton];
    self.myGoldButton = myGoldButton;
    
    UILabel *myGoldLabel = [[UILabel alloc] init];
    myGoldLabel.text = @"0";
    myGoldLabel.textColor = ColorWithHexString(@"#ffb42b");
    myGoldLabel.font = TextFont(15);
    myGoldLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:myGoldLabel];
    self.myGoldLabel = myGoldLabel;
    
    UIButton *daysButton = [UIButton buttonWithType:UIButtonTypeCustom];
    daysButton.layer.cornerRadius = AUTOSIZESCALEX(5);
    daysButton.layer.masksToBounds = YES;
    [daysButton setTitle:@"已连续签到" forState:UIControlStateNormal];
    [daysButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    daysButton.titleLabel.font = TextFont(14);
    [daysButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(30)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [self.contentView addSubview:daysButton];
    self.daysButton = daysButton;

    UILabel *daysLabel = [[UILabel alloc] init];
    daysLabel.text = @"0天";
    daysLabel.textColor = ColorWithHexString(@"#ffb42b");
    daysLabel.font = TextFont(15);
    daysLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:daysLabel];
    self.daysLabel = daysLabel;

    UIButton *rulesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rulesButton.layer.cornerRadius = AUTOSIZESCALEX(12.5);
    rulesButton.layer.masksToBounds = YES;
    [rulesButton setTitle:@"签到规则" forState:UIControlStateNormal];
    [rulesButton setTitleColor:ColorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    rulesButton.titleLabel.font = TextFont(14);
    [rulesButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(100), AUTOSIZESCALEX(25)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    [self.contentView addSubview:rulesButton];
    self.rulesButton = rulesButton;

    UILabel *rulesLabel = [[UILabel alloc] init];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"01 每日签到完成，奖励立即发放\n02 只有注册会员才能享受签到福利\n03 签到每七天翻倍一次"];
    attribute.yy_lineSpacing = AUTOSIZESCALEX(10);
    rulesLabel.attributedText = attribute;
    rulesLabel.textColor = ColorWithHexString(@"#4C4949");
    rulesLabel.font = TextFont(12);
    rulesLabel.numberOfLines = 0;
    [self.contentView addSubview:rulesLabel];
    self.rulesLabel = rulesLabel;

    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = ColorWithHexString(@"#CCCCCC");
    [self.contentView addSubview:leftLine];
    self.leftLine = leftLine;
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = leftLine.backgroundColor;
    [self.contentView addSubview:rightLine];
    self.rightLine = rightLine;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    [self.signInButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(75), AUTOSIZESCALEX(75)));
    }];
    
    [self.calanderContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signInButton.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(260));
    }];

    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.calanderContainerView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(35));
    }];

    [self.weekContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.monthLabel.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.right.equalTo(self.calanderContainerView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekContainerView.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.right.equalTo(self.calanderContainerView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(185));
    }];

    [self.myGoldButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.calanderContainerView.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView.mas_centerX).offset(AUTOSIZESCALEX(-15));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(30)));
    }];
    
    [self.myGoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myGoldButton.mas_bottom).offset(AUTOSIZESCALEX(17.5));
        make.centerX.equalTo(self.myGoldButton);
        make.height.mas_equalTo(AUTOSIZESCALEX(13));
    }];

    [self.daysButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.myGoldButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView.mas_centerX).offset(AUTOSIZESCALEX(15));
        make.size.mas_equalTo(self.myGoldButton);
    }];
    
    [self.daysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.myGoldLabel).offset(AUTOSIZESCALEX(0));
        make.centerX.equalTo(self.daysButton);
        make.height.equalTo(self.myGoldLabel);
    }];

    [self.rulesButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myGoldButton.mas_bottom).offset(AUTOSIZESCALEX(70));
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(100), AUTOSIZESCALEX(25)));
    }];
    
    [self.rulesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rulesButton.mas_bottom).offset(AUTOSIZESCALEX(20));
        make.centerX.equalTo(self.rulesButton);
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rulesButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(110));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rulesButton).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.width.equalTo(self.leftLine);
        make.height.equalTo(self.leftLine);
    }];

    
}

#pragma mark - Setter

- (void)setOverviewItem:(SignInOverviewItem *)overviewItem {
    _overviewItem = overviewItem;
    if (_overviewItem) {
        self.myGoldLabel.text = [NSString stringWithFormat:@"%zd",_overviewItem.socre];
        self.daysLabel.text = [NSString stringWithFormat:@"%zd天",_overviewItem.continuousDay];
    }
}

- (void)setDaysArray:(NSMutableArray *)daysArray {
    _daysArray = daysArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SignInCalanderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:calanderCellId forIndexPath:indexPath];

    NSString *date = self.datasource[indexPath.row];
    if ([NSString isEmpty:date]) {
        cell.date = @"";
        cell.haveSignIn = NO;
    } else {
        cell.date = date;
        NSString *monthDate = [NSString stringWithFormat:@"%02zd-%@",[NSDate date].month,date];
        BOOL haveSignIn = NO;
        for (SignInListItem *item in self.daysArray) {
            if ([item.createTime containsString:monthDate]) {
                haveSignIn = YES;
                break;
            }
        }
        cell.haveSignIn = haveSignIn;
    }
    
    return cell;
}



@end
