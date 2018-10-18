//
//  BrandAreaCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BrandAreaCell.h"
#import "BrandAreaChildCell.h"

@interface BrandAreaCell() <UICollectionViewDelegate,UICollectionViewDataSource>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;

@end

static NSString *const brandCellId = @"brandCellId";

@implementation BrandAreaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - AUTOSIZESCALEX(30) - AUTOSIZESCALEX(60)) * 0.5, AUTOSIZESCALEX(230));
    layout.minimumLineSpacing = AUTOSIZESCALEX(10);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(10);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(10), 0, AUTOSIZESCALEX(10));
    [collectionView registerClass:[BrandAreaChildCell class] forCellWithReuseIdentifier:brandCellId];
    
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
        make.top.left.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
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
    
    BrandAreaChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brandCellId forIndexPath:indexPath];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(brandAreaCell:didSelectItem:)]) {
        [_delegate brandAreaCell:self didSelectItem:self.datasource[indexPath.row]];
    }
}

@end
