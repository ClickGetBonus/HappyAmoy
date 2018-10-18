//
//  GroupBuyProgressCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GroupBuyProgressCell.h"
#import "GroupBuyPeopleCell.h"
#import "GroupBuyDetailItem.h"
#import "CustomerGroupItem.h"

@interface GroupBuyProgressCell () <UICollectionViewDelegate,UICollectionViewDataSource>

/**    标题    */
@property(nonatomic,strong) UILabel *titleLabel;
/**    倒计时    */
@property(nonatomic,strong) UILabel *countDownLabel;
/**    collectionView    */
@property(nonatomic,strong) UICollectionView *collectionView;
/**    时    */
@property(nonatomic,strong) UILabel *hourLabel;
/**    分    */
@property(nonatomic,strong) UILabel *minuteLabel;
/**    秒    */
@property(nonatomic,strong) UILabel *secondLabel;
/** 定时器(这里不用带*，因为dispatch_source_t就是个类，内部已经包含了*) */
@property (nonatomic, strong) dispatch_source_t timer;
/**    标记是否已经开始倒计时了    */
@property(nonatomic,assign) BOOL isCountDowning;
/**    倒计时    */
@property(nonatomic,assign) NSInteger residueSecond;

@end

static NSString *const cellId = @"cellId";

@implementation GroupBuyProgressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorWithHexString(@"#FB4F67");
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = QHWhiteColor;
    titleLabel.font = TextFont(16);
    titleLabel.text = @"拼团进度";
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *countDownLabel = [[UILabel alloc] init];
    countDownLabel.text = @"还差0人拼团成功         时       分       秒后结束";
    countDownLabel.textColor = ColorWithHexString(@"#FFFFFF");
    countDownLabel.font = TextFont(13);
    countDownLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:countDownLabel];
    self.countDownLabel = countDownLabel;
    
    UILabel *hourLabel = [[UILabel alloc] init];
    hourLabel.text = @"00";
    hourLabel.textColor = ColorWithHexString(@"#313131");
    hourLabel.backgroundColor = ColorWithHexString(@"#FFFFFF");
    hourLabel.font = TextFont(13);
    hourLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:hourLabel];
    self.hourLabel = hourLabel;
    
    UILabel *minuteLabel = [[UILabel alloc] init];
    minuteLabel.text = @"00";
    minuteLabel.textColor = ColorWithHexString(@"#313131");
    minuteLabel.backgroundColor = ColorWithHexString(@"#FFFFFF");
    minuteLabel.font = TextFont(13);
    minuteLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:minuteLabel];
    self.minuteLabel = minuteLabel;

    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.text = @"00";
    secondLabel.textColor = ColorWithHexString(@"#313131");
    secondLabel.backgroundColor = ColorWithHexString(@"#FFFFFF");
    secondLabel.font = TextFont(13);
    secondLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:secondLabel];
    self.secondLabel = secondLabel;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(AUTOSIZESCALEX(55), AUTOSIZESCALEX(55));
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = AUTOSIZESCALEX(18);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(18);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:SCREEN_FRAME collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(15), 0, AUTOSIZESCALEX(15));
    [collectionView registerClass:[GroupBuyPeopleCell class] forCellWithReuseIdentifier:cellId];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;

    [self addConstraints];
}

#pragma mark - Layout
- (void)addConstraints {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(13));
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(AUTOSIZESCALEX(16));
    }];
    
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countDownLabel).offset(AUTOSIZESCALEX(0));
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10.5));
        make.width.mas_equalTo(AUTOSIZESCALEX(20));
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hourLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.hourLabel.mas_right).offset(AUTOSIZESCALEX(19));
        make.width.equalTo(self.hourLabel);
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hourLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.minuteLabel.mas_right).offset(AUTOSIZESCALEX(19));
        make.width.equalTo(self.hourLabel);
        make.height.equalTo(self.titleLabel);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.countDownLabel.mas_bottom).offset(AUTOSIZESCALEX(22));
        make.left.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(55));
    }];
}

#pragma mark - Setter

- (void)setItem:(GroupBuyDetailItem *)item {
    _item = item;
    if (_item) {
        self.countDownLabel.text = [NSString stringWithFormat:@"还差%zd人拼团成功         时       分       秒后结束",_item.customerGroup.targetNum - _item.customerGroup.inviteNum];
        self.residueSecond = _item.customerGroup.residueSecond;
        if (self.residueSecond > 0) {
            if (!self.isCountDowning) {
                [self countDown];
                self.isCountDowning = YES;
            }
        }
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.item.customerGroup.custList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupBuyPeopleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    NSDictionary *dict = self.item.customerGroup.custList[indexPath.row];
    cell.iconImageURL = dict[@"headpicUrl"];
    return cell;
}

#pragma mark - Private method

/**
 *  @brief  创建一个定时器用来验证码的倒计时
 */
- (void)countDown{
    
    WeakSelf
    
    __block int count = self.residueSecond;
    
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置定时器的各种属性（几时开始任务，每隔多长时间执行一次）
    // GCD的时间参数，一般是纳秒（1秒 == 10的9次方纳秒）
    // 何时开始执行第一个任务
    // dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC) 比当前时间晚3秒
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        
        count--;
        
        if ((count / 3600) == 0) {
            weakSelf.hourLabel.text = @"00";
            if ((count / 60) == 0) {
                weakSelf.minuteLabel.text = @"00";
                weakSelf.secondLabel.text = [NSString stringWithFormat:@"%02zd",count];;
            } else {
                weakSelf.minuteLabel.text = [NSString stringWithFormat:@"%02zd",(count / 60)];
                weakSelf.secondLabel.text = [NSString stringWithFormat:@"%02zd",(count % 60)];
            }
        } else {
            weakSelf.hourLabel.text = [NSString stringWithFormat:@"%02zd",(count / 3600)];
            weakSelf.minuteLabel.text = [NSString stringWithFormat:@"%02zd",(count % 3600) / 60];
            weakSelf.secondLabel.text = [NSString stringWithFormat:@"%02zd",(count % 60)];
        }
        
//        WYLog(@"count = %zd",count);
        if (count == 0) {
            if (self.timer) {
                // 取消定时器
                dispatch_cancel(weakSelf.timer);
                weakSelf.timer = nil;
            }
        }
    });
    // 开启定时器
    dispatch_resume(self.timer);
}


/**
 *  @brief  取消定时器
 */
- (void)cancelTimer {
    if (self.timer) {
        // 取消定时器
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

- (void)dealloc {
    WYFunc
    [self cancelTimer];
}


@end
