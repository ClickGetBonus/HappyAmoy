//
//  MemberMoneyCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MemberMoneyCell.h"
#import "MemberMoneyChildCell.h"
#import "MemberRewardController.h"

@interface MemberMoneyCell() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
/**    数据源    */
@property (strong, nonatomic) NSArray *typeArray;
@property (strong, nonatomic) NSArray *iconArray;

@end

static NSString *const moneyCellId = @"moneyCellId";

@implementation MemberMoneyCell

#pragma mark - UI

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
    
    CGFloat itemWH = SCREEN_WIDTH * 0.5;
    
    layout.itemSize = CGSizeMake(itemWH, AUTOSIZESCALEX(55));
    layout.minimumLineSpacing = AUTOSIZESCALEX(0);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.showsHorizontalScrollIndicator = NO;
//    collectionView.contentInset = UIEdgeInsetsMake(AUTOSIZESCALEX(10), AUTOSIZESCALEX(10), AUTOSIZESCALEX(10), AUTOSIZESCALEX(10));
    [collectionView registerClass:[MemberMoneyChildCell class] forCellWithReuseIdentifier:moneyCellId];
    
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(55));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line1];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH * 0.5);
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
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
    
    MemberMoneyChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moneyCellId forIndexPath:indexPath];
//    cell.index = indexPath.row;
    if (self.balanceArray.count == 4) {
        cell.balance = self.balanceArray[indexPath.row];
    }
    cell.iconName = self.iconArray[indexPath.row];
    cell.type = self.typeArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(memberMoneyCell:didSelectItemAtIndex:)]) {
        [_delegate memberMoneyCell:self didSelectItemAtIndex:indexPath.row];
    }
        
}

@end
