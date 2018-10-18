//
//  WYTagView.m
//  DianDian
//
//  Created by apple on 17/10/27.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "WYTagView.h"
#import "WYTagFlowLayout.h"
#import "WYTagCell.h"

@interface WYTagView () <UICollectionViewDelegate,UICollectionViewDataSource,WYTagFlowLayoutDelegate,WYTagFlowLayoutDataSource>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation WYTagView

/***    collectionViewCell的ID   */
static NSString *const tagCellId = @"tagCellId";

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 默认不可点击
        _canClickCollectionView = NO;
        // 设置collectionView
        [self setupCollectionView];
    }
    return self;
}

- (void)setDataSource:(NSArray *)dataSource {
    
    _dataSource = dataSource;
    
    [self.collectionView reloadData];
    
}

#pragma mark - 设置collectionView
- (void)setupCollectionView {
    
    WYTagFlowLayout *layout = [[WYTagFlowLayout alloc] init];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    layout.delegate = self;
    layout.dataSource = self;

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    // 禁止collectionView滑动
    self.collectionView.scrollEnabled = NO;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.userInteractionEnabled = _canClickCollectionView;
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WYTagCell class]) bundle:nil] forCellWithReuseIdentifier:tagCellId];
    
    [self addSubview:self.collectionView];
        
}

- (void)setCanClickCollectionView:(BOOL)canClickCollectionView {
    
    _canClickCollectionView = canClickCollectionView;
    
    self.collectionView.userInteractionEnabled = _canClickCollectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:tagCellId forIndexPath:indexPath];
    /**
     *  @brief  颜色设置需要在 isSameHobby 属性前面设置
     */
    if (_defaultBackgroundColor) {
        cell.defaultBackgroundColor = _defaultBackgroundColor;
    }
    if (_defaultTextColor) {
        cell.defaultTextColor = _defaultTextColor;
    }
    if (_defaultBorderColor) {
        cell.defaultBorderColor = _defaultBorderColor;
    }
    if (_backgroundColorOfSameHobby) {
        cell.backgroundColorOfSameHobby = _backgroundColorOfSameHobby;
    }
    if (_textColorOfSameHobby) {
        cell.textColorOfSameHobby = _textColorOfSameHobby;
    }
    if (_borderColorOfSameHobby) {
        cell.borderColorOfSameHobby = _borderColorOfSameHobby;
    }
    
    NSString *tagItem = self.dataSource[indexPath.row];
    
    if ([self.sameHobbyDataSource containsObject:tagItem]) {
        cell.isSameHobby = YES;
    } else {
        cell.isSameHobby = NO;
    }
    
    cell.tagString = tagItem;
        
    WeakSelf
    cell.didClickTagButtonCallBack = ^(id tagItem) {
        if ([weakSelf.delegate respondsToSelector:@selector(tagView:didClickTag:)]) {
            [weakSelf.delegate tagView:weakSelf didClickTag:tagItem];
        }
    };
    return cell;
}

#pragma mark - WYTagFlowLayoutDataSource
- (NSString *)tagFlowLayout:(WYTagFlowLayout *)tagFlowLayout titleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *tagItem = self.dataSource[indexPath.row];
    
    return tagItem;
}

#pragma mark - WYTagFlowLayoutDelegate
- (void)tagFlowLayout:(WYTagFlowLayout *)tagFlowLayout collectionViewHeight:(CGFloat)height {
    
    self.height = self.collectionView.height = height;
    
}

@end
