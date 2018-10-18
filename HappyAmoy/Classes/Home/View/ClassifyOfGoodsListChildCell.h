//
//  ClassifyOfGoodsListChildCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassifyItem;

@interface ClassifyOfGoodsListChildCell : UICollectionViewCell

/**    数据模型    */
@property(nonatomic,strong) ClassifyItem *item;

@end
