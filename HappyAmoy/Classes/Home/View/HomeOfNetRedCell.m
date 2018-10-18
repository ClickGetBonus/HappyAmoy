//
//  HomeOfNetRedCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeOfNetRedCell.h"
#import "PlatformCharacterViewLayout.h"
#import "PlatfomrCharacterChildCell.h"
#import "CommoditySpecialCategoriesItem.h"

@interface HomeOfNetRedCell() <UICollectionViewDelegate,UICollectionViewDataSource>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
/**    分割线1    */
@property (strong, nonatomic) UIView *line1;
/**    分割线2    */
@property (strong, nonatomic) UIView *line2;
/**    分割线3    */
@property (strong, nonatomic) UIView *line3;

@end

static NSString *const characterCellId = @"characterCellId";

@implementation HomeOfNetRedCell

//- (NSMutableArray *)datasource {
//    if (!_datasource) {
//        _datasource = [NSMutableArray array];
//        [_datasource addObject:ImageWithNamed(@"品牌专区")];
//        [_datasource addObject:ImageWithNamed(@"人气热卖")];
//        [_datasource addObject:ImageWithNamed(@"新款上市")];
//        [_datasource addObject:ImageWithNamed(@"超低价")];
//    }
//    return _datasource;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        self.datasource = [NSMutableArray array];
        
        //        _datasource = [NSMutableArray array];
        //        [_datasource addObject:ImageWithNamed(@"品牌专区")];
        //        [_datasource addObject:ImageWithNamed(@"人气热卖")];
        //        [_datasource addObject:ImageWithNamed(@"新款上市")];
        //        [_datasource addObject:ImageWithNamed(@"超低价")];
        
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    PlatformCharacterViewLayout *layout = [[PlatformCharacterViewLayout alloc] init];
    
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//
//    layout.itemSize = CGSizeMake(SCREEN_WIDTH * 0.5 - AUTOSIZESCALEX(1), AUTOSIZESCALEX(120));
//    layout.minimumLineSpacing = AUTOSIZESCALEX(0.1);
//    layout.minimumInteritemSpacing = AUTOSIZESCALEX(0.1);
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = QHWhiteColor;
    collectionView.showsHorizontalScrollIndicator = NO;
    //    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(24), 0, AUTOSIZESCALEX(24));
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
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH * 16 / 26);
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line2 = [UIView separatorLine];
    [self.contentView addSubview:line2];
    self.line2 = line2;
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(95));
        make.left.equalTo(self.contentView).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH * 16 / 26);
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line3 = [UIView separatorLine];
    [self.contentView addSubview:line3];
    self.line3 = line3;

    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(95));
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH * 16 / 26 * 0.5);
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
    return self.datasource.count > 4 ? 4 : self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlatfomrCharacterChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:characterCellId forIndexPath:indexPath];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(homeOfNetRedCell:didSelectItem:)]) {
        [_delegate homeOfNetRedCell:self didSelectItem:self.datasource[indexPath.row]];
    }
}


@end
