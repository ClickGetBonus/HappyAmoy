//
//  ClassifyOfGoodsListCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ClassifyOfGoodsListCell.h"
#import "ClassifyOfGoodsListChildCell.h"

@interface ClassifyOfGoodsListCell () <UICollectionViewDelegate,UICollectionViewDataSource>

/**    collectionView    */
@property(nonatomic,strong) UICollectionView *collectionView;

@end

static NSString *const classifyCellId = @"classifyCellId";

@implementation ClassifyOfGoodsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.backgroundColor = QHWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    
    CGFloat buttonW = (SCREEN_WIDTH - AUTOSIZESCALEX(5)) / 4;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(buttonW - AUTOSIZESCALEX(1), AUTOSIZESCALEX(90));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = AUTOSIZESCALEX(1);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(3);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:SCREEN_FRAME collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(0), 0, AUTOSIZESCALEX(0));
    [collectionView registerClass:[ClassifyOfGoodsListChildCell class] forCellWithReuseIdentifier:classifyCellId];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyOfGoodsListChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:classifyCellId forIndexPath:indexPath];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(classifyOfGoodsListCell:didSelectItem:)]) {
        [_delegate classifyOfGoodsListCell:self didSelectItem:self.datasource[indexPath.row]];
    }
}


@end
