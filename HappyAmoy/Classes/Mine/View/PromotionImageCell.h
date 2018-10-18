//
//  PromotionImageCell.h
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromotionItem;

@interface PromotionImageCell : UICollectionViewCell

/**    数据模型    */
@property (strong, nonatomic) PromotionItem *item;
/**    索引    */
@property (assign, nonatomic) NSInteger index;
/**    图片url    */
@property (copy, nonatomic) NSString *imageUrl;

@end
