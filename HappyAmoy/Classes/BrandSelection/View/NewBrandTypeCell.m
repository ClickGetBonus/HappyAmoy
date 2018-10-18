//
//  NewBrandTypeCell.m
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewBrandTypeCell.h"
#import "BrandTypeLayout.h"
#import "PlatfomrCharacterChildCell.h"
#import "CommoditySpecialCategoriesItem.h"

@interface NewBrandTypeCell() <UICollectionViewDelegate,UICollectionViewDataSource>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    分割线1    */
@property (strong, nonatomic) UIView *line1;
/**    分割线2    */
@property (strong, nonatomic) UIView *line2;
/**    分割线3    */
@property (strong, nonatomic) UIView *line3;
/**    分割线4    */
@property (strong, nonatomic) UIView *line4;

@end

static NSString *const characterCellId = @"characterCellId";

@implementation NewBrandTypeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    BrandTypeLayout *layout = [[BrandTypeLayout alloc] init];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[PlatfomrCharacterChildCell class] forCellWithReuseIdentifier:characterCellId];
    
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIView *line1 = [UIView separatorLine];
    [self.contentView addSubview:line1];
    self.line1 = line1;
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH / 2);
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line2 = [UIView separatorLine];
    [self.contentView addSubview:line2];
    self.line2 = line2;
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(120));
        make.left.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line3 = [UIView separatorLine];
    [self.contentView addSubview:line3];
    self.line3 = line3;
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(120));
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH / 4);
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line4 = [UIView separatorLine];
    [self.contentView addSubview:line4];
    self.line4 = line4;
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(120));
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH / 4 * 3);
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
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
    
    PlatfomrCharacterChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:characterCellId forIndexPath:indexPath];
    cell.ppjxItem = self.datasource[indexPath.row];
    //    cell.image = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(newBrandTypeCell:didSelectItem:)]) {
        [_delegate newBrandTypeCell:self didSelectItem:self.datasource[indexPath.row]];
    }
}

@end
