//
//  MineThirdSectionCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineThirdSectionCell.h"
#import "MineThirdSectionChildCell.h"
#import "VersionItem.h"

@interface MineThirdSectionCell() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
/**    数据源    */
@property (strong, nonatomic) NSArray *typeArray;
@property (strong, nonatomic) NSArray *iconArray;

@end

static NSString *const childCellId = @"childCellId";

@implementation MineThirdSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initData];
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WeakSelf
        [RACObserve([LoginUserDefault userDefault], versionDataHaveChanged) subscribeNext:^(id x) {
            [weakSelf initData];
            [weakSelf.collectionView reloadData];
        }];
    }
    return self;
}

// 初始化数据
- (void)initData {
    if ([[LoginUserDefault userDefault].versionItem.version isEqualToString:APP_VERSION]) { // 版本一样，说明当前的是最新版本，需要判断当前版本的数字编号，数字编号大于0表示审核通过了，可以显示升级会员了
        if ([LoginUserDefault userDefault].versionItem.number > 0) { // 数字编号大于0表示审核通过了，可以显示升级会员了
            self.typeArray =@[@"升级VIP",@"我的团队",@"宣传物料",@"分享APP",@"我的收藏",@"最近浏览"];
            self.iconArray =@[@"icon_会员",@"团队",@"文件",@"手机(1)",@"爱心",@"足迹"];
        } else {
            self.typeArray =@[@"我的团队",@"宣传物料",@"分享APP",@"我的收藏",@"最近浏览"];
            self.iconArray =@[@"团队",@"文件",@"手机(1)",@"爱心",@"足迹"];
        }
    } else { // 版本不一样，说明当前版本是旧版本，可以显示升级会员
//        self.typeArray =@[@"升级VIP",@"我的团队",@"宣传物料",@"我的收藏",@"最近浏览",@"客服中心",@"关于我们",@"意见反馈"];
//                self.iconArray =@[@"icon_vip",@"icon_taem",@"icon_publicity",@"icon_collect",@"icon_record",@"icon_service",@"icon_abot we",@"icon_feedback"];
          self.typeArray =@[@"升级VIP",@"我的团队",@"宣传素材",@"我的收藏",@"最近浏览",@"常见问题",@"关于我们",@"意见反馈",@"设置",@"分享"];
        self.iconArray =@[@"icon_vip",@"icon_taem",@"icon_publicity",@"icon_collect",@"icon_record",@"icon_problem",@"icon_abot we",@"icon_feedback",@"icon_set",@"icon_share"];
    }
}


#pragma mark - UI

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat itemW = (SCREEN_WIDTH - AUTOSIZESCALEX(5)) / 4;
    CGFloat itemH = AUTOSIZESCALEX(85);
    
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumLineSpacing = AUTOSIZESCALEX(0.01);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(0.01);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    //    collectionView.contentInset = UIEdgeInsetsMake(AUTOSIZESCALEX(10), AUTOSIZESCALEX(10), AUTOSIZESCALEX(10), AUTOSIZESCALEX(10));
    [collectionView registerClass:[MineThirdSectionChildCell class] forCellWithReuseIdentifier:childCellId];
    
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
//    UIView *line = [[UIView alloc] init];
//    line.backgroundColor = SeparatorLineColor;
//    [self.contentView addSubview:line];
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.left.right.equalTo(self.contentView);
//        make.height.mas_equalTo(AUTOSIZESCALEX(0.5));
//    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.typeArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MineThirdSectionChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:childCellId forIndexPath:indexPath];

    cell.iconName = self.iconArray[indexPath.row];
    cell.type = self.typeArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(mineThirdSectionCell:didSelectItemAtIndex:)]) {
        [_delegate mineThirdSectionCell:self didSelectItemAtIndex:indexPath.row];
    }
    
}


@end
