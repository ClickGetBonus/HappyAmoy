//
//  NewHomeOfNetRedCell.m
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewHomeOfNetRedCell.h"
#import "PlatformCharacterViewLayout.h"
#import "PlatfomrCharacterChildCell.h"
#import "CommoditySpecialCategoriesItem.h"

@interface NewHomeOfNetRedCell() <UICollectionViewDelegate,UICollectionViewDataSource>

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

@implementation NewHomeOfNetRedCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = QHWhiteColor;
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    PlatformCharacterViewLayout *layout = [[PlatformCharacterViewLayout alloc] init];
    
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
        make.left.equalTo(self.contentView).offset(SCREEN_WIDTH * 0.5);
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line2 = [UIView separatorLine];
    [self.contentView addSubview:line2];
    self.line2 = line2;
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(SCREEN_WIDTH * 0.38);
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIView *line3 = [UIView separatorLine];
    line3.backgroundColor = ViewControllerBackgroundColor;
    [self.contentView addSubview:line3];
    self.line3 = line3;
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.contentView.height/2));
        make.left.equalTo(@(self.contentView.width/4));
        make.width.equalTo(@1);
        make.height.equalTo(@(self.contentView.height/2));
    }];
}

#pragma mark - Setter

- (void)setDatasource:(NSMutableArray *)datasource {
    _datasource = datasource;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count > 5 ? 5 : self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlatfomrCharacterChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:characterCellId forIndexPath:indexPath];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_delegate respondsToSelector:@selector(newHomeOfNetRedCell:didSelectItem:)]) {
        [_delegate newHomeOfNetRedCell:self didSelectItem:self.datasource[indexPath.row]];
    }
}

@end
