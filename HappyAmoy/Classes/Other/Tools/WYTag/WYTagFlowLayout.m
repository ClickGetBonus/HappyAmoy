//
//  WYTagFlowLayout.m
//  DianDian
//
//  Created by apple on 17/10/27.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "WYTagFlowLayout.h"

/**     item的高度     */
static CGFloat itemH = 30;
/**     item的间距     */
static CGFloat itemSpace = 5;
/**     字体的大小     */
static CGFloat itemFont = 14;


@implementation WYTagFlowLayout {
    
    CGFloat itemX;
    CGFloat itemY;
    CGFloat lineNumber;
    
}

- (void)prepareLayout {
    
    [super prepareLayout];
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    itemX = 0;
    itemY = 0;
    lineNumber = 0;

    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    
    for (int i = 0; i < attributesArray.count; i++) {
        
        UICollectionViewLayoutAttributes *attributes = attributesArray[i];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        NSString *title = [self.dataSource tagFlowLayout:self titleForRowAtIndexPath:indexPath];
        
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, itemH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:itemFont]} context:nil].size;
        // 因为计算出来的长度刚刚好，加上20使得两边有空间，比较好看
        CGFloat itemW = titleSize.width + 15;
        if (titleSize.width > (self.collectionView.width - 15)) {
            itemW = self.collectionView.width - 15;
        }
        
        attributes.frame = CGRectMake(itemX, itemY, itemW, itemH);
        
        itemX += itemW + itemSpace;
        
        if (i < attributesArray.count -  1) {
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:i + 1 inSection:0];
            NSString *nextTitle = [self.dataSource tagFlowLayout:self titleForRowAtIndexPath:nextIndexPath];
            
            CGSize nextSize = [nextTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, itemH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:itemFont]} context:nil].size;
            
            if (nextSize.width > self.collectionView.width - itemX - 15) {
                lineNumber++;
                itemX = 0;

                itemY = (itemH + itemSpace) * lineNumber;

            }
        } else {
            [self.delegate tagFlowLayout:self collectionViewHeight:(itemY + itemH)];
        }
    }
    return attributesArray;
    
}

@end
