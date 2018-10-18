//
//  MemberMoneyCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberMoneyCell;

@protocol MemberMoneyCellDelegate <NSObject>

@optional

- (void)memberMoneyCell:(MemberMoneyCell *)memberMoneyCell didSelectItemAtIndex:(NSInteger)index;

@end

@interface MemberMoneyCell : UITableViewCell

/**    代理    */
@property (weak, nonatomic) id<MemberMoneyCellDelegate> delegate;
/**    余额数组    */
@property (strong, nonatomic) NSMutableArray *balanceArray;

@end
