//
//  RewardBalanceCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberRewardItem;
@class ConsumPointItem;

@interface RewardBalanceCell : UITableViewCell

/**    数据模型    */
@property (strong, nonatomic) MemberRewardItem *item;
/**    积分的数据模型    */
@property (strong, nonatomic) ConsumPointItem *pointItem;

@end
