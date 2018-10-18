//
//  GroupBuyProgressCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupBuyDetailItem;

@interface GroupBuyProgressCell : UITableViewCell

/**    数据模型    */
@property(nonatomic,strong) GroupBuyDetailItem *item;

/**
 *  @brief  取消定时器  
 */
- (void)cancelTimer;

@end
