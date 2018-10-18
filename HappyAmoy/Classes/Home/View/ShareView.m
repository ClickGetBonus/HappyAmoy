//
//  ShareView.m
//  HappyAmoy
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareView.h"
#import "ShareViewCell.h"

@interface ShareView() <UICollectionViewDataSource,UICollectionViewDelegate>

/**    标题label    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    左分割线    */
@property (strong, nonatomic) UIView *leftLine;
/**    右分割线    */
@property (strong, nonatomic) UIView *rightLine;
/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    分享平台数据源    */
@property (strong, nonatomic) NSArray *wayArray;
/**    分享平台图标数据源    */
@property (strong, nonatomic) NSArray *iconArray;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;

@end

static NSString *const shareCellId = @"shareCellId";

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.wayArray = @[@"微信",@"朋友圈",@"QQ",@"QQ空间",@"微博"];
        self.iconArray = @[ImageWithNamed(@"微信"),ImageWithNamed(@"朋友圈"),ImageWithNamed(@"QQ"),ImageWithNamed(@"qq空间"),ImageWithNamed(@"微博")];
        [self setupUI];
        self.backgroundColor = QHWhiteColor;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"分享到";
    titleLabel.textColor = ColorWithHexString(@"#333333");
    titleLabel.font = TextFont(15);
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self).offset(AUTOSIZESCALEX(14));
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = RGB(230, 230, 230);
    [self addSubview:leftLine];
    self.leftLine = leftLine;
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.titleLabel.mas_left).offset(AUTOSIZESCALEX(-22));
        make.width.mas_equalTo(AUTOSIZESCALEX(105));
        make.height.mas_equalTo(AUTOSIZESCALEX(1));
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = RGB(230, 230, 230);
    [self addSubview:rightLine];
    self.rightLine = rightLine;
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.titleLabel.mas_right).offset(AUTOSIZESCALEX(22));
        make.width.mas_equalTo(AUTOSIZESCALEX(105));
        make.height.mas_equalTo(AUTOSIZESCALEX(1));
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - AUTOSIZESCALEX(0)) / 5, AUTOSIZESCALEX(70));
    layout.minimumLineSpacing = AUTOSIZESCALEX(0);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[ShareViewCell class] forCellWithReuseIdentifier:shareCellId];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel).offset(AUTOSIZESCALEX(0));
        make.left.right.bottom.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(10));
    }];

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShareViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareCellId forIndexPath:indexPath];
    cell.platform = self.wayArray[indexPath.row];
    cell.iconImage = self.iconArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYLog(@"indexPath = %zd",indexPath.row);
    
    UMSocialPlatformType type = UMSocialPlatformType_WechatSession;
    switch (indexPath.row) {
        case 0: // 微信
            type = UMSocialPlatformType_WechatSession;
            break;
        case 1: // 朋友圈
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        case 2: // QQ
            type = UMSocialPlatformType_QQ;
            break;
        case 3: // QQ空间
            type = UMSocialPlatformType_Qzone;
            break;
        case 4: // 微博
            type = UMSocialPlatformType_Sina;
            break;
        default:
            break;
    }
    if ([_delegate respondsToSelector:@selector(shareView:platformType:)]) {
        [_delegate shareView:self platformType:type];
    }
}



























@end
