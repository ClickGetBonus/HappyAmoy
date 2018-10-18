//
//  BrandSelectionCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BrandSelectionCell.h"
#import "GoodsListCell.h"

@interface BrandSelectionCell () <UICollectionViewDelegate,UICollectionViewDataSource>

/**    collectionView    */
@property(nonatomic,strong) UICollectionView *collectionView;

@end

static NSString *listCellId = @"listCellId";

@implementation BrandSelectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - SeparatorLineHeight) / 2, AUTOSIZESCALEX(280));
    layout.minimumLineSpacing = SeparatorLineHeight;
    layout.minimumInteritemSpacing = SeparatorLineHeight;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = ViewControllerBackgroundColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:listCellId];
    [collectionView registerClass:[GoodsListCell class] forCellWithReuseIdentifier:listCellId];
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];

}

#pragma mark - Setter

- (void)setDatasource:(NSMutableArray *)datasource {
    _datasource = datasource;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellId forIndexPath:indexPath];
//    cell.backgroundColor = RandomColor;
//    return cell;
    
    GoodsListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:listCellId forIndexPath:indexPath];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(brandSelectionCell:didSelectItem:)]) {
        [_delegate brandSelectionCell:self didSelectItem:self.datasource[indexPath.row]];
    }
}


@end
