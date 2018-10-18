//
//  GoodsClassifiChildCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommodityCategoriesItem;

@interface GoodsClassifiChildCell : UICollectionViewCell

/**    图片    */
@property (strong, nonatomic) UIImage *icon;
/**    类型    */
@property (copy, nonatomic) NSString *type;
/**    数据模型    */
@property (strong, nonatomic) CommodityCategoriesItem *item;

@end
