//
//  PlatfomrCharacterChildCell.h
//  HappyAmoy
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommodityCategoriesItem;
@class CommoditySpecialCategoriesItem;

@interface PlatfomrCharacterChildCell : UICollectionViewCell

/**    图片    */
@property (strong, nonatomic) UIImage *image;
/**    数据模型    */
@property (strong, nonatomic) CommoditySpecialCategoriesItem *item;
/**    品牌精选的商品分类    */
@property(nonatomic,strong) CommodityCategoriesItem *ppjxItem;

@end
