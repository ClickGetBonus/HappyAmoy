//
//  MineFirstSectionCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineFirstSectionCell.h"
#import "MineFirstSectionChildCell.h"

@interface MineFirstSectionCell() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
/**    数据源    */
@property (strong, nonatomic) NSArray *typeArray;
@property (strong, nonatomic) NSArray *iconArray;

@end

static NSString *const moneyCellId = @"moneyCellId";

@implementation MineFirstSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.typeArray = @[@"分享麦穗",@"消费麦穗",@"麦粒",@"我的钱包"];
        self.iconArray = @[@"奖励",@"积分2",@"会员福利",@"钱包"];
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
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
    [collectionView registerClass:[MineFirstSectionChildCell class] forCellWithReuseIdentifier:moneyCellId];
    
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

    UIImageView *line = [[UIImageView alloc] init];
    line.image = ImageWithNamed(@"矩形28");
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-itemW + AUTOSIZESCALEX(2));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(4), AUTOSIZESCALEX(55)));
    }];
}

#pragma mark - Setter

- (void)setBalanceArray:(NSMutableArray *)balanceArray {
    _balanceArray = balanceArray;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.typeArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MineFirstSectionChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moneyCellId forIndexPath:indexPath];
    //    cell.index = indexPath.row;
    if (self.balanceArray.count == 4) {
        cell.balance = self.balanceArray[indexPath.row];
    }
    cell.iconName = self.iconArray[indexPath.row];
    cell.type = self.typeArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(mineFirstSectionCell:didSelectItemAtIndex:)]) {
        [_delegate mineFirstSectionCell:self didSelectItemAtIndex:indexPath.row];
    }
    
}

@end
