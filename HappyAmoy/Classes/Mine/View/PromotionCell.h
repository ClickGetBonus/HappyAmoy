//
//  PromotionCell.h
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PromotionItem;

@interface PromotionCell : UITableViewCell

/**    数据模型    */
@property (strong, nonatomic) PromotionItem *item;
/**    图片数组    */
@property (strong, nonatomic) NSMutableArray *imagesArray;

@end
