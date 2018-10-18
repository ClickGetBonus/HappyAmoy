//
//  MyOrderOfGroupBuyCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupOrderItem;

@interface MyOrderOfGroupBuyCell : UITableViewCell

/**    数据模型    */
@property(nonatomic,strong) GroupOrderItem *item;

@end
