//
//  RewardBalanceView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RewardBalanceView;

@protocol RewardBalanceViewDelegate <NSObject>

@optional
// 转入钱包余额
- (void)rewardBalanceView:(RewardBalanceView *)rewardBalanceView toWallet:(NSInteger)currentScore;

@end

@interface RewardBalanceView : UIView

/**    余额    */
@property (copy, nonatomic) NSString *balanceText;


/**    代理    */
@property (weak, nonatomic) id<RewardBalanceViewDelegate> delegate;

@end
