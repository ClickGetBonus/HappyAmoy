//
//  PlatfomrCharacterCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PlatfomrCharacterCell.h"
#import "PlatformCharacterViewLayout.h"
#import "PlatfomrCharacterChildCell.h"
#import "CommoditySpecialCategoriesItem.h"

@interface PlatfomrCharacterCell() <UICollectionViewDelegate,UICollectionViewDataSource>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;
@property(nonatomic,strong) UIImageView *imageView1;
@property(nonatomic,strong) UIImageView *imageView2;
@property(nonatomic,strong) UIImageView *imageView3;
@property(nonatomic,strong) UIImageView *imageView4;

/**    分割线1    */
@property (strong, nonatomic) UIView *line1;
/**    分割线2    */
@property (strong, nonatomic) UIView *line2;
/**    分割线3    */
@property (strong, nonatomic) UIView *line3;

@end

static NSString *const characterCellId = @"characterCellId";

@implementation PlatfomrCharacterCell

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
    WeakSelf
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] init];
    [[tap1 rac_gestureSignal] subscribeNext:^(id x) {
        if (self.datasource.count < 1) {
            return;
        }
        if ([weakSelf.delegate respondsToSelector:@selector(platfomrCharacterCell:didSelectItem:)]) {
            [weakSelf.delegate platfomrCharacterCell:weakSelf didSelectItem:weakSelf.datasource[0]];
        }
    }];
    [imageView1 addGestureRecognizer:tap1];
    [self.contentView addSubview:imageView1];
    self.imageView1 = imageView1;
    [self.imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
        make.height.mas_equalTo(AUTOSIZESCALEX(120));
    }];

    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] init];
    [[tap2 rac_gestureSignal] subscribeNext:^(id x) {
        if (self.datasource.count < 2) {
            return;
        }
        if ([weakSelf.delegate respondsToSelector:@selector(platfomrCharacterCell:didSelectItem:)]) {
            [weakSelf.delegate platfomrCharacterCell:weakSelf didSelectItem:weakSelf.datasource[1]];
        }
    }];
    [imageView2 addGestureRecognizer:tap2];
    [self.contentView addSubview:imageView2];
    self.imageView2 = imageView2;
    [self.imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.imageView1.mas_right).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
        make.height.mas_equalTo(AUTOSIZESCALEX(120));
    }];

    UIImageView *imageView3 = [[UIImageView alloc] init];
    imageView3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] init];
    [[tap3 rac_gestureSignal] subscribeNext:^(id x) {
        if (self.datasource.count < 3) {
            return;
        }
        if ([weakSelf.delegate respondsToSelector:@selector(platfomrCharacterCell:didSelectItem:)]) {
            [weakSelf.delegate platfomrCharacterCell:weakSelf didSelectItem:weakSelf.datasource[2]];
        }
    }];
    [imageView3 addGestureRecognizer:tap3];
    [self.contentView addSubview:imageView3];
    self.imageView3 = imageView3;
    [self.imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView1.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
        make.height.mas_equalTo(AUTOSIZESCALEX(120));
    }];
    
    UIImageView *imageView4 = [[UIImageView alloc] init];
    imageView4.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] init];
    [[tap4 rac_gestureSignal] subscribeNext:^(id x) {
        if (self.datasource.count < 4) {
            return;
        }
        if ([weakSelf.delegate respondsToSelector:@selector(platfomrCharacterCell:didSelectItem:)]) {
            [weakSelf.delegate platfomrCharacterCell:weakSelf didSelectItem:weakSelf.datasource[3]];
        }
    }];
    [imageView4 addGestureRecognizer:tap4];
    [self.contentView addSubview:imageView4];
    self.imageView4 = imageView4;
    [self.imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView3).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.imageView2).offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.5);
        make.height.mas_equalTo(AUTOSIZESCALEX(120));
    }];

    //    PlatformCharacterViewLayout *layout = [[PlatformCharacterViewLayout alloc] init];
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//
//    layout.itemSize = CGSizeMake(SCREEN_WIDTH * 0.5 - AUTOSIZESCALEX(1), AUTOSIZESCALEX(120));
//    layout.minimumLineSpacing = AUTOSIZESCALEX(0.1);
//    layout.minimumInteritemSpacing = AUTOSIZESCALEX(0.1);
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//
//    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
//    collectionView.delegate = self;
//    collectionView.dataSource = self;
//    collectionView.backgroundColor = QHWhiteColor;
//    collectionView.showsHorizontalScrollIndicator = NO;
//    //    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(24), 0, AUTOSIZESCALEX(24));
//    [collectionView registerClass:[PlatfomrCharacterChildCell class] forCellWithReuseIdentifier:characterCellId];
//
//    [self.contentView addSubview:collectionView];
//    self.collectionView = collectionView;
//
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
    
    UIView *line1 = [UIView separatorLine];
    [self.contentView addSubview:line1];
    self.line1 = line1;
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH * 0.5);
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line2 = [UIView separatorLine];
    [self.contentView addSubview:line2];
    self.line2 = line2;
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(120));
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
//    UIView *line3 = [UIView separatorLine];
//    [self.contentView addSubview:line3];
//    self.line3 = line3;
//
//    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(95));
//        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH * 16 / 26 * 0.5);
//        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(SeparatorLineHeight);
//    }];
}

#pragma mark - Setter

- (void)setDatasource:(NSMutableArray *)datasource {
    _datasource = datasource;
//    [self.collectionView reloadData];
    
    if (_datasource.count > 0) {
        CommoditySpecialCategoriesItem *item1 = self.datasource[0];
        [self.imageView1 wy_setImageWithUrlString:item1.iconUrl placeholderImage:PlaceHolderMainImage];
    }
    
    if (_datasource.count > 1) {
        CommoditySpecialCategoriesItem *item2 = self.datasource[1];
        [self.imageView2 wy_setImageWithUrlString:item2.iconUrl placeholderImage:PlaceHolderMainImage];
    }
    
    if (_datasource.count > 2) {
        CommoditySpecialCategoriesItem *item3 = self.datasource[2];
        [self.imageView3 wy_setImageWithUrlString:item3.iconUrl placeholderImage:PlaceHolderMainImage];
    }
    
    if (_datasource.count > 3) {
        CommoditySpecialCategoriesItem *item4 = self.datasource[3];
        [self.imageView4 wy_setImageWithUrlString:item4.iconUrl placeholderImage:PlaceHolderMainImage];
    }
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
    
    if ([_delegate respondsToSelector:@selector(platfomrCharacterCell:didSelectItem:)]) {
        [_delegate platfomrCharacterCell:self didSelectItem:self.datasource[indexPath.row]];
    }
}

@end
