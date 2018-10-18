//
//  ClassifyContentCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ClassifyContentCell.h"
#import "ClassifyContentChildCell.h"

@interface ClassifyContentCell () <UICollectionViewDelegate,UICollectionViewDataSource>

/**    容器    */
@property(nonatomic,strong) UIView *containerView;
/**    collectionView    */
@property(nonatomic,strong) UICollectionView *collectionView;

@end

@implementation ClassifyContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.backgroundColor = ColorWithHexString(@"#F3F3F6");
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = QHWhiteColor;
    containerView.layer.cornerRadius = AUTOSIZESCALEX(5);
    containerView.layer.masksToBounds = YES;
    [self.contentView addSubview:containerView];
    self.containerView = containerView;
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.top.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
    }];
    
    CGFloat buttonW = (SCREEN_WIDTH - AUTOSIZESCALEX(90) - AUTOSIZESCALEX(20) - AUTOSIZESCALEX(0)) / 3;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(buttonW - AUTOSIZESCALEX(1), AUTOSIZESCALEX(115));
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = AUTOSIZESCALEX(1);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(1);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:SCREEN_FRAME collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(0), 0, AUTOSIZESCALEX(0));
    [collectionView registerClass:[ClassifyContentChildCell class] forCellWithReuseIdentifier:@"cell"];
    [self.containerView addSubview:collectionView];
    self.collectionView = collectionView;

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(AUTOSIZESCALEX(5));
        make.left.right.equalTo(self.containerView);
        make.bottom.equalTo(self.containerView).offset(AUTOSIZESCALEX(0));
    }];

}

#pragma mark - Setter

- (void)setDatasource:(NSMutableArray *)datasource {
    _datasource = datasource;
    if (self.datasource.count == 0) {
        self.containerView.hidden = YES;
    } else {
        self.containerView.hidden = NO;
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassifyContentChildCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(classifyContentCell:didSelectItem:)]) {
        [_delegate classifyContentCell:self didSelectItem:self.datasource[indexPath.row]];
    }
}


@end
