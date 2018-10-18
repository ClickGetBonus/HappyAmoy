//
//  PlatformCharacterViewLayout.m
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PlatformCharacterViewLayout.h"

@interface PlatformCharacterViewLayout ()

@property (nonatomic,strong)NSMutableArray *itemsAttributes;//保存所有item尺寸的数组

@end
/**     cell之间的间距   */
static NSInteger const cellMargin = 5;
/**     列数      */
//static NSInteger const columnsCount = 3;
static NSInteger const columnsCount = 4;


@implementation PlatformCharacterViewLayout

- (void)prepareLayout {
    
    // 确定所有item的个数
    NSUInteger itemCounts = [[self collectionView] numberOfItemsInSection:0];
    
    self.itemsAttributes = [NSMutableArray arrayWithCapacity:itemCounts];
    
    // 给attributes.frame赋值，并存入self.itemsAttributes
    
    CGFloat longW = SCREEN_WIDTH * 16 / 26;
    CGFloat height = AUTOSIZESCALEX(190);
    
    if (itemCounts > 0) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        attributes.frame = CGRectMake(0, 0, SCREEN_WIDTH *0.5, SCREEN_WIDTH *0.38);
        [self.itemsAttributes addObject:attributes];
        
        UICollectionViewLayoutAttributes *attributes1 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        attributes1.frame = CGRectMake(SCREEN_WIDTH *0.5, 0, SCREEN_WIDTH *0.5, SCREEN_WIDTH *0.38);
        [self.itemsAttributes addObject:attributes1];
        
        UICollectionViewLayoutAttributes *attributes2 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
        attributes2.frame = CGRectMake(0, SCREEN_WIDTH *0.38, SCREEN_WIDTH *0.5/2, SCREEN_WIDTH *0.38);
        [self.itemsAttributes addObject:attributes2];
        
        UICollectionViewLayoutAttributes *attributes3 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
        attributes3.frame = CGRectMake(SCREEN_WIDTH *0.5/2, SCREEN_WIDTH *0.38, SCREEN_WIDTH *0.5/2, SCREEN_WIDTH *0.38);
        [self.itemsAttributes addObject:attributes3];
        
        UICollectionViewLayoutAttributes *attributes4 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
        attributes4.frame = CGRectMake(SCREEN_WIDTH *0.5, SCREEN_WIDTH *0.38, SCREEN_WIDTH *0.5, SCREEN_WIDTH *0.38);
        [self.itemsAttributes addObject:attributes4];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.itemsAttributes;
}

@end
