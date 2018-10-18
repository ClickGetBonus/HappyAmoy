//
//  BrandTypeLayout.m
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BrandTypeLayout.h"

@interface BrandTypeLayout ()

@property (nonatomic,strong)NSMutableArray *itemsAttributes;//保存所有item尺寸的数组

@end

@implementation BrandTypeLayout

- (void)prepareLayout {
    
    // 确定所有item的个数
    NSUInteger itemCounts = [[self collectionView] numberOfItemsInSection:0];
    
    self.itemsAttributes = [NSMutableArray arrayWithCapacity:itemCounts];
    
    // 给attributes.frame赋值，并存入self.itemsAttributes
    
    CGFloat longW = SCREEN_WIDTH / 2;
    CGFloat height = AUTOSIZESCALEX(120);
    
    if (itemCounts > 0) {
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        attributes.frame = CGRectMake(0, 0, longW, height);
        [self.itemsAttributes addObject:attributes];
        
        UICollectionViewLayoutAttributes *attributes1 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
        attributes1.frame = CGRectMake(longW, 0, longW, height);
        [self.itemsAttributes addObject:attributes1];
        
        UICollectionViewLayoutAttributes *attributes2 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
        attributes2.frame = CGRectMake(0, height, longW * 0.5, height);
        [self.itemsAttributes addObject:attributes2];
        
        UICollectionViewLayoutAttributes *attributes3 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
        attributes3.frame = CGRectMake(longW * 0.5, height, longW * 0.5, height);
        [self.itemsAttributes addObject:attributes3];
        
        UICollectionViewLayoutAttributes *attributes4 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
        attributes4.frame = CGRectMake(longW, height, longW * 0.5, height);
        [self.itemsAttributes addObject:attributes4];

        UICollectionViewLayoutAttributes *attributes5 = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:[NSIndexPath indexPathForItem:5 inSection:0]];
        attributes5.frame = CGRectMake(longW * 3 / 2, height, longW * 0.5, height);
        [self.itemsAttributes addObject:attributes5];

    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.itemsAttributes;
}

@end
