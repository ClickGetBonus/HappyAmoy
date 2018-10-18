//
//  MineFourthSectionCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineFourthSectionCell.h"
#import "MineThirdSectionChildCell.h"

@interface MineFourthSectionCell() <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
/**    数据源    */
@property (strong, nonatomic) NSArray *typeArray;
@property (strong, nonatomic) NSArray *iconArray;

@end

static NSString *const childCellId = @"childCellId";

@implementation MineFourthSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.typeArray =@[@"客服中心",@"关于我们",@"意见反馈"];
        self.iconArray =@[@"客服",@"关于我",@"意见反馈"];
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
    [collectionView registerClass:[MineThirdSectionChildCell class] forCellWithReuseIdentifier:childCellId];
    
    [self.contentView addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
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
    
    if ([_delegate respondsToSelector:@selector(mineFourthSectionCell:didSelectItemAtIndex:)]) {
        [_delegate mineFourthSectionCell:self didSelectItemAtIndex:indexPath.row];
    }
    
}

@end
