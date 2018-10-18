//
//  MemberListView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MemberListView.h"
#import "MemberListCell.h"

@interface MemberListView() <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UIImageView *headerView;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    排名    */
@property (strong, nonatomic) UILabel *rankLabel;
/**    会员    */
@property (strong, nonatomic) UILabel *memberLabel;
/**    奖励    */
@property (strong, nonatomic) UILabel *rewardLabel;
/**    列表    */
@property (strong, nonatomic) UITableView *tableView;
/**    排名数组    */
@property (strong, nonatomic) NSMutableArray *rankArray;
/**    会员数组    */
@property (strong, nonatomic) NSMutableArray *memberArray;
/**    奖励数组    */
@property (strong, nonatomic) NSMutableArray *rewardArray;

@end

static NSString *listCellId = @"listCellId";

@implementation MemberListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.memberArray = [NSMutableArray arrayWithArray:@[@"一把火",@"小斌斌",@"蓝天",@"问",@"月",@"黄",@"紫",@"露",@"汪",@"宝宝"]];
        self.rewardArray = [NSMutableArray arrayWithArray:@[@"999",@"888",@"777",@"666",@"555",@"444",@"333",@"222",@"111",@"0"]];

        [self setupUI];
        self.backgroundColor = QHWhiteColor;
        
        //设置切哪个直角
        //    UIRectCornerTopLeft     = 1 << 0,  左上角
        //    UIRectCornerTopRight    = 1 << 1,  右上角
        //    UIRectCornerBottomLeft  = 1 << 2,  左下角
        //    UIRectCornerBottomRight = 1 << 3,  右下角
        //    UIRectCornerAllCorners  = ~0UL     全部角
        //得到view的遮罩路径
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;

    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.image = [ImageWithNamed(@"appIcon_small") createImageWithSize:CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(20), AUTOSIZESCALEX(40)) gradientColors:@[(id)ColorWithHexString(@"#F96C74"),(id)ColorWithHexString(@"#FB4F67")] percentage:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [self addSubview:headerView];
    self.headerView = headerView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = QHWhiteColor;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"会员榜单   今天你努力了吗"];
    [attribute addAttribute:NSFontAttributeName value:AppMainTextFont(15) range:NSMakeRange(0, 4)];
    [attribute addAttribute:NSFontAttributeName value:TextFont(12) range:NSMakeRange(5, attribute.length - 5)];
    [attribute addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"#FDFCFB") range:NSMakeRange(5, attribute.length - 5)];

    [titleLabel setAttributedText:attribute];
    [self.headerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *rankLabel = [[UILabel alloc] init];
    rankLabel.textColor = [UIColor blackColor];
    rankLabel.text = @"排名";
    rankLabel.font = AppMainTextFont(14);
    rankLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:rankLabel];
    self.rankLabel = rankLabel;
    
    UILabel *memberLabel = [[UILabel alloc] init];
    memberLabel.textColor = [UIColor blackColor];
    memberLabel.text = @"会员";
    memberLabel.font = AppMainTextFont(14);
    memberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:memberLabel];
    self.memberLabel = memberLabel;
    
    UILabel *rewardLabel = [[UILabel alloc] init];
    rewardLabel.textColor = [UIColor blackColor];
    rewardLabel.text = @"获得奖励";
    rewardLabel.font = AppMainTextFont(14);
    rewardLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:rewardLabel];
    self.rewardLabel = rewardLabel;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = AUTOSIZESCALEX(40);
    [tableView registerClass:[MemberListCell class] forCellReuseIdentifier:listCellId];
    [self addSubview:tableView];
    self.tableView = tableView;
    
    [self addConstraints];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = SeparatorLineColor;
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankLabel.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = QHMainColor;
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line3 = [[UIView alloc] init];
    line3.backgroundColor = QHMainColor;
    [self addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line4 = [[UIView alloc] init];
    line4.backgroundColor = QHMainColor;
    [self addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.headerView).offset(AUTOSIZESCALEX(23));
        make.right.equalTo(self.headerView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.headerView).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.headerView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(75));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
    
    [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rankLabel).offset(AUTOSIZESCALEX(0));
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(self.rankLabel);
        make.height.mas_equalTo(self.rankLabel);
    }];
    
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rankLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.headerView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(90));
        make.height.mas_equalTo(self.rankLabel);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rankLabel.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self).offset(AUTOSIZESCALEX(0));
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.memberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:listCellId];
    cell.sort = indexPath.row + 1;
    cell.memberName = self.memberArray[indexPath.row];
    cell.reward = self.rewardArray[indexPath.row];
    return cell;
}

@end
