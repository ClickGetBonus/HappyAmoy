//
//  MustBuyListCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommodityListItem;

@interface MustBuyListCell : UITableViewCell

/**    券类型    */
@property (copy, nonatomic) NSString *type;

/**    数据模型    */
@property (strong, nonatomic) CommodityListItem *item;

@end